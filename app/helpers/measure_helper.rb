module MeasureHelper
    # HDS Measure to QDM Measure model translation
    def self.convert_patient_models(hds_measure)
      qdm_measure = CQMConverter.to_qdm(hds_measure)
      qdm_measure
    end

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

  def self.update_measures(measures, current_user, is_update, existing)
    measures.each do |measure|
      if !is_update
        existing = CqlMeasure.by_user(current_user).where(hqmf_set_id: measure.hqmf_set_id).first
        unless existing.nil?
          measures.each(&:delete)
          error_message = {title: "Error Loading Measure", summary: "A version of this measure is already loaded.", body: "You have a version of this measure loaded already.  Either update that measure with the update button, or delete that measure and re-upload it."}
          return error_message
        end
      elsif measure.component
        if existing.hqmf_set_id != measure.composite_hqmf_set_id
          measures.each(&:delete)
          error_message = {title: "Error Updating Measure", summary: "The update file does not match the measure.", body: "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure."}
          return error_message
        end
      elsif existing.hqmf_set_id != measure.hqmf_set_id
        measures.each(&:delete)
        error_message = {title: "Error Updating Measure", summary: "The update file does not match the measure.", body: "You have attempted to update a measure with a file that represents a different measure.  Please update the correct measure or upload the file as a new measure."}
        return error_message
      end

      # Exclude patient birthdate and expired OIDs used by SimpleXML parser for AGE_AT handling and bad oid protection in missing VS check
      missing_value_sets = (measure.as_hqmf_model.all_code_set_oids - measure.value_set_oids - ['2.16.840.1.113883.3.117.1.7.1.70', '2.16.840.1.113883.3.117.1.7.1.309'])
      next if missing_value_sets.empty?
      measures.each(&:delete)
      error_message = {title: "Measure is missing value sets", summary: "The measure you have tried to load is missing value sets.", body: "The measure you are trying to load is missing value sets.  Try re-packaging and re-exporting the measure from the Measure Authoring Tool.  The following value sets are missing: [#{missing_value_sets.join(', ')}]"}
      return error_message
    end
    if existing && is_update
      existing.component_hqmf_set_ids.each do |component_hqmf_set_id|
        component_measure = CqlMeasure.by_user(current_user).where(hqmf_set_id: component_hqmf_set_id).first
        component_measure.delete
      end
      existing.delete
    end
    nil
  end
  
  def self.measures_population_update(measures, is_update, current_user, measure_details)
    measures.each do |measure|
      current_user.measures << measure

      if is_update
        measure.populations.each_with_index do |population, population_index|
          population['title'] = measure_details['population_titles'][population_index] if measure_details['population_titles']
        end
      else
        measure.needs_finalize = measure.populations.size > 1
        if measure.populations.size > 1
          strat_index = 1
          measure.populations.each do |population|
            if population[HQMF::PopulationCriteria::STRAT]
              population['title'] = "Stratification #{strat_index}"
              strat_index += 1
            end
          end
        end
      end
      measure.save!

      # Rebuild the user's patients for the given measure
      Record.by_user_and_hqmf_set_id(current_user, measure.hqmf_set_id).each do |r|
        Measures::PatientBuilder.rebuild_patient(r)
        r.save!
      end

      # Ensure expected values on patient match those in the measure's populations
      Record.where(user_id: current_user.id, measure_ids: measure.hqmf_set_id).each do |patient|
        patient.update_expected_value_structure!(measure)
      end
    end
    current_user.save!
  end
end
