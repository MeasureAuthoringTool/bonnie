module Admin
  class GroupsController < ApplicationController
    protect_from_forgery
    before_action :authenticate_user!
    before_action :require_admin!
    respond_to :json

    def index
      groups = Group.where(is_personal: false).sort_by { |obj| obj.name.downcase }.to_a

      # pipeline stages for aggregation
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
      groups.each do |group|
        group[:measure_count] = get_count_for_group(measures, group)
        group[:patient_count] = get_count_for_group(patients, group)
      end
      respond_with groups do |format|
        format.json { render json: groups.as_json }
      end
    end

    def create_group
      group_name = params[:group_name]

      existing_group = Group.where(name: group_name).collation({ locale: 'en', strength: 2 }).first
      raise ActionController::BadRequest, "Group name #{group_name} is already used." if existing_group

      group = Group.new
      group.name = group_name
      group.save
      render json: group
    end

    private

    def require_admin!
      raise "User #{current_user.email} requesting resource requiring admin access" unless current_user.admin?
    end

    def get_count_for_group(group_objects, group)
      count_obj = group_objects.detect { |group_object| group_object['_id'] == group.id.to_s }
      count_obj ? count_obj['count'] : 0
    end
  end
end
