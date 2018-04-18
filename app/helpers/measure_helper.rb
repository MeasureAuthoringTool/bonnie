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

    vsac_options[:measure_defined] = true if params[:vsac_query_measure_defined] == 'true'

    vsac_options
  end

  # Helper method to build a flash error given a VSACError.
  def self.build_vsac_error_message(e)
    if e.is_a?(Util::VSAC::VSNotFoundError) || e.is_a?(Util::VSAC::VSEmptyError)
      {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC value set (#{e.oid}) not found or is empty.",
        body: "Please verify that you are using the correct profile or release and have VSAC authoring permissions if you are requesting draft value sets."
      }
    elsif e.is_a?(Util::VSAC::VSACInvalidCredentialsError)
      {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC credentials were invalid.",
        body: "Please verify that you are using the correct VSAC username and password."
      }
    elsif e.is_a?(Util::VSAC::VSACTicketExpiredError) || e.is_a?(Util::VSAC::VSACNoCredentialsError)
      {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC session expired.",
        body: "Please re-enter VSAC username and password to try again."
      }
    else
      {
        title: "Error Loading VSAC Value Sets",
        summary: "VSAC value sets could not be loaded.",
        body: "#{e.message}<br/>This may be due to lack of VSAC authoring permissions if you are requesting draft value sets. Please confirm you have the appropriate authoring permissions."
      }
    end
  end
end
