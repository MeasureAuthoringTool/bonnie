class HomeController < ApplicationController

  def index
    # FIXME: Preload everything for now until deferred fetch can be handled gracefully (tweak application.html.erb to when changing this)
    # @measure_attributes = [:_id, :hqmf_set_id, :title, :populations, :population_criteria]
    @measure_attributes = [:_id, :_type, :category, :cms_id, :continuous_variable, :custom_functions, :data_criteria, :description, :episode_ids, :episode_of_care, :force_sources, :hqmf_id, :hqmf_set_id, :hqmf_version_number, :measure_attributes, :measure_id, :measure_period, :needs_finalize, :population_criteria, :populations, :source_data_criteria, :title, :type, :updated_at, :user_id, :value_set_oid]
    @measures = Measure.by_user(current_user).only(@measure_attributes)
    @patients = Record.by_user(current_user)
  end

end
