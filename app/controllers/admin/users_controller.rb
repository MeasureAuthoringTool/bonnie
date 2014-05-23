class Admin::UsersController < ApplicationController

  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :require_admin!

  respond_to :json

  def index
    users = User.asc(:email)
    respond_with users.as_json(methods: [:measure_count, :patient_count])
  end

  def email_all
    users = User.asc(:email)
    email = Admin::AllUsersMailer.send_to_all(users, params[:subject], params[:body])
    email.deliver
    render json: {}
  end

  def update
    user = User.find(params[:id])
    # Update select attributes directly so we can keep a more restrictive attr_accessible for other contexts
    [:email, :admin, :portfolio].each { |attr| user.send("#{attr}=", params[attr]) }
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
