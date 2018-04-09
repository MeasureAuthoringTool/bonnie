module MeasureHelper
  # Helper method to parse vsac query related paramers into the vsac_options object that gets passed into
  # measure loading.
  def self.parse_vsac_parameters(params)
    vsac_options = {}

    case params[:vsac_query_type]
    when 'release'
      vsac_options[:release] = params[:vsac_query_release]
    when 'profile'
      vsac_options[:profile] = params[:vsac_query_profile]
      vsac_options[:include_draft] = true if params[:vsac_query_include_draft] == 'true'
    end

    if params[:vsac_query_measure_defined] == 'true'
      vsac_options[:measure_defined] = true
    end
    vsac_options
  end
end
