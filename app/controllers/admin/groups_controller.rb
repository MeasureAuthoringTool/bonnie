module Admin
  class GroupsController < ApplicationController
    protect_from_forgery
    before_action :authenticate_user!
    before_action :require_admin!
    respond_to :json

    def index
      groups = Group.where(is_personal: false).order(:name.asc).to_a
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
        group[:measure_count] = get_count_by_id(measures, group.id)
        group[:patient_count] = get_count_by_id(patients, group.id)
      end
      respond_with groups do |format|
        format.json { render json: groups.as_json }
      end
    end

    private

    def require_admin!
      raise "User #{current_user.email} requesting resource requiring admin access" unless current_user.admin?
    end
  end
end
