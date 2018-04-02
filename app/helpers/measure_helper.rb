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
    when 'measure_defined'
      vsac_options[:measure_defined] = true
      # TODO: determine if this is needed
      vsac_options[:backup_profile] = APP_CONFIG['vsac']['default_profile']
    end
    vsac_options
  end
end
