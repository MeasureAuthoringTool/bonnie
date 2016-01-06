class ApiV1::MeasuresController < ApplicationController
  before_action :set_api_v1_measure, only: [:show, :edit, :update, :destroy]

  # GET /api_v1/measures
  def index
    @api_v1_measures = ApiV1::Measure.all
  end

  # GET /api_v1/measures/1
  def show
  end

  # GET /api_v1/measures/new
  def new
    @api_v1_measure = ApiV1::Measure.new
  end

  # GET /api_v1/measures/1/edit
  def edit
  end

  # POST /api_v1/measures
  def create
    @api_v1_measure = ApiV1::Measure.new(api_v1_measure_params)

    if @api_v1_measure.save
      redirect_to @api_v1_measure, notice: 'Measure was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /api_v1/measures/1
  def update
    if @api_v1_measure.update(api_v1_measure_params)
      redirect_to @api_v1_measure, notice: 'Measure was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /api_v1/measures/1
  def destroy
    @api_v1_measure.destroy
    redirect_to api_v1_measures_url, notice: 'Measure was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api_v1_measure
      @api_v1_measure = ApiV1::Measure.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def api_v1_measure_params
      params[:api_v1_measure]
    end
end
