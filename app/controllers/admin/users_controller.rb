class Admin::UsersController < ApplicationController

  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :require_admin!

  respond_to :json

  def index
    # Getting the count for user measures and patients via the DB is a 1+n problem, and a bit slow, so we grab
    # the counts separately via map reduce and plug them in
    users = User.asc(:email).all.to_a # Need to convert to array so counts stick
    map = "function() { emit(this.user_id, 1); }"
    reduce = "function(user_id, counts) { return Array.sum(counts); }"
    measure_counts = Measure.map_reduce(map, reduce).out(inline: true).each_with_object({}) { |r, h| h[r[:_id]] = r[:value].to_i }
    patient_counts = Record.map_reduce(map, reduce).out(inline: true).each_with_object({}) { |r, h| h[r[:_id]] = r[:value].to_i }
    users.each do |u|
      u.measure_count = measure_counts[u.id] || 0
      u.patient_count = patient_counts[u.id] || 0
    end
    users_json = MultiJson.encode(users.as_json(methods: [:measure_count, :patient_count]))
    respond_with users do |format|
      format.json { render json: users_json }
    end
  end

  def email_all
    User.asc(:email).each do |user|
      email = Admin::AllUsersMailer.all_users_email(user, params[:subject], params[:body])
      email.deliver
    end
    render json: {}
  end

  def update
    user = User.find(params[:id])
    # Update select attributes directly so we can keep a more restrictive attr_accessible for other contexts
    [:email, :admin, :portfolio, :dashboard].each { |attr| user.send("#{attr}=", params[attr]) }
    user.save
    respond_with user
  end

  def approve
    user = User.find(params[:id])
    user.approved = true
    user.save
    UserMailer.account_activation_email(user).deliver
    render json: user
  end

  def disable
    user = User.find(params[:id])
    user.approved = false
    user.save
    render json: user
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: {}
  end

  def patients
    user = User.find(params[:id])
    send_data JSON.pretty_generate(JSON.parse(user.records.to_json)), :type => 'application/json', :disposition => 'attachment', :filename => "patients_#{user.email}.json"
  end

  def measures
    user = User.find(params[:id])
    send_data JSON.pretty_generate(JSON.parse(user.measures.to_json)), :type => 'application/json', :disposition => 'attachment', :filename => "measures_#{user.email}.json"
  end

  def bundle
    user = User.find(params[:id])
    exporter = Measures::Exporter::BundleExporter.new(user, version: '1.0', hqmfjs_libraries_version: APP_CONFIG['hqmfjs_libraries_version'], effective_date: ( Time.at(APP_CONFIG['measure_period_start']).utc + 1.year - 1.minute ).to_i)
    zip_data = exporter.export_zip

    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload

    send_data zip_data, :type => 'application/zip', :disposition => 'attachment', :filename => "bundle_#{user.email}_export.zip"
  end

  def log_in_as
    user = User.find(params[:id])
    sign_in user
    redirect_to root_path
  end

  private

  def require_admin!
    raise "User #{current_user.email} requesting resource requiring admin access" unless current_user.admin?
  end

end
