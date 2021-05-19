class Admin::UsersController < ApplicationController

  protect_from_forgery
  before_action :authenticate_user!
  before_action :require_admin!

  respond_to :json

  def index
    # aggregate pipeline stages
    stages = [
      {
        "$group" => {
          "_id" => "$group_id",
          "count" => { "$sum" => 1 }
        }
      }
    ]

    measures = CQM::Measure.collection.aggregate(stages).as_json
    patients = CQM::Patient.collection.aggregate(stages).as_json
    users = User.asc(:email).all.to_a # Need to convert to array so counts stick
    users.each do |user|
      user.measure_count = get_count_by_id(measures, user.id)
      user.patient_count = get_count_by_id(patients, user.id)
    end
    users_json = MultiJson.encode(users.as_json(methods: [:measure_count, :patient_count, :last_sign_in_at]))
    respond_with users do |format|
      format.json { render json: users_json }
    end
  end

  def email_all
    User.asc(:email).each do |user|
      email = Admin::UsersMailer.users_email(user, user_email_params[:subject], user_email_params[:body])
      email.deliver_now
      sleep 2 # address issues with mail throttling
    end
    render json: {}
  end

  def email_active
    # only send email to users who have logged in sometime in the last 6 months
    # and have at least one measure loaded
    User.asc(:email).where(:last_sign_in_at.gt => Date.today - 6.months).each do |user|
      if user.measure_count > 0
        email = Admin::UsersMailer.users_email(user, user_email_params[:subject], user_email_params[:body])
        email.deliver_now
        sleep 2 # address issues with mail throttling
      end
    end
    render json: {}
  end

  def email_single
    user = User.where(email: user_email_params[:target_email]).first
    email = Admin::UsersMailer.users_email(user, user_email_params[:subject], user_email_params[:body])
    email.deliver_now
    render json: {}
  end

  def update
    user = User.find(params[:id])
    user.update(user_params)
    respond_with user
  end

  def approve
    user = User.find(params[:id])
    user.approved = true
    user.save
    UserMailer.account_activation_email(user).deliver_now
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
    send_data JSON.pretty_generate(user.current_group.patients.map(&:as_json)), :type => 'application/json', :disposition => 'attachment', :filename => "patients_#{user.email}.json"
  end

  def measures
    user = User.find(params[:id])
    send_data JSON.pretty_generate(JSON.parse(user.current_group.cqm_measures.to_json)), :type => 'application/json', :disposition => 'attachment', :filename => "measures_#{user.email}.json"
  end

  def log_in_as
    user = User.find(params[:id])
    sign_in user
    redirect_to root_path
  end

  private

  def user_params
    params.permit(:email, :admin, :portfolio, :dashboard, :harp_id)
  end

  def user_email_params
    params.permit(:target_email, :subject, :body)
  end

  def require_admin!
    raise "User #{current_user.email} requesting resource requiring admin access" unless current_user.admin?
  end

end
