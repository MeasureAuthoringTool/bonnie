class HomeController < ApplicationController
  before_action :authenticate_user!, :except => [:show, :saml_error, :registered_not_active]

  def index
    @measures = CQM::Measure.by_user(current_user).only(:id)
    @patients = CQM::Patient.by_user(current_user)
  end

  def show
    render :show, layout: false
  end

  def saml_error
    render json: {status: "error", messages: "User is not activated."}, status: :not_found
  end

  def registered_not_active
    render :registered_not_active, layout: false
  end

  # switch user group
  def switch_group
    group = Group.find(params[:group_id])
    # make sure group is available and user has permission to view it
    if group && current_user.is_assigned_group(group)
      current_user.current_group = group
      current_user.save
    else
      flash[:error] = {
        title: 'Error switching the group',
        summary: 'User group could not be changed.',
        body: 'You do not have access to this group. Please contact group owner to get the access.'
      }
    end
    redirect_to root_path
  end
end
