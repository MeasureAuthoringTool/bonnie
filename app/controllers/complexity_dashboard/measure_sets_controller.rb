class ComplexityDashboard::MeasureSetsController < ApplicationController

  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :require_dashboard!

  respond_to :json

  def index
    # We implement measure sets using user accounts, specially marked as "complexity_set" accounts; this lets
    # us use existing account interfaces to manage the sets of measures available on the complexity dashboard
    measure_sets = User.where(dashboard_set: true).only(:_id, :first_name, :last_name).sort(first_name: 1)
    measure_sets_json = MultiJson.encode(measure_sets)
    respond_with measure_sets do |format|
      format.json { render json: measure_sets_json }
    end
  end

  def show
    # This operates on a pair of IDs, and we use those IDs to construct appropriate pairs of measures
    measure_set_id_1, measure_set_id_2 = params[:id].split(',')
    measure_set_1 = User.find(measure_set_id_1)
    measure_set_2 = User.find(measure_set_id_2)
    unless measure_set_1.dashboard_set? && measure_set_2.dashboard_set?
      raise "User #{current_user.email} requesting a measure set from an inappropriate account"
    end
    # Pair up the measures
    measure_pairs = []
    measures_1 = measure_set_1.measures.only(:cms_id, :hqmf_set_id, :complexity, :measure_logic).index_by(&:hqmf_set_id)
    measures_2 = measure_set_2.measures.only(:cms_id, :hqmf_set_id, :complexity, :measure_logic).index_by(&:hqmf_set_id)
    measures_1.each do |hqmf_set_id, measure_1|
      if measure_2 = measures_2[hqmf_set_id]
        measure_pairs << { measure_1: measure_1, measure_2: measure_2, diff: measure_1.diff(measure_2) }
      end
    end
    measure_pairs_json = MultiJson.encode(measure_pairs)
    respond_with measure_pairs do |format|
      format.json { render json: measure_pairs_json }
    end
  end

  private

  def require_dashboard!
    raise "User #{current_user.email} requesting resource requiring complexity dashboard access" unless current_user.dashboard?
  end

end
