require 'rest-client'

class MeasuresController < ApplicationController
  include MeasureHelper

  skip_before_action :verify_authenticity_token, only: [:show]

  respond_to :json, :js, :html

  def show
    # TODO: I think skippable_fields can be removed with the 'without(*skippable_fields)' below
    skippable_fields = [:map_fns, :record_ids, :measure_attributes]
    @measure = CQM::Measure.by_user(current_user).without(*skippable_fields).where(id: params[:id]).first
    raise Mongoid::Errors::DocumentNotFound unless @measure
    if stale? last_modified: @measure.updated_at.try(:utc), etag: @measure.cache_key
      measure_json = @measure.as_json(except: skippable_fields)
      @measure_json = MultiJson.encode(measure_json)
      respond_with @measure do |format|
        format.json { render json: @measure_json }
      end
    end
  end

  def create
    if params[:measure_file].blank?
      flash[:error] = {title: "Error Loading Measure", body: "You must specify a Measure Authoring tool measure export to use."}
      redirect_to "#{root_path}##{params[:redirect_route]}"
      return
    end

    scan_for_viruses(params)

    begin
      vsac_tgt = obtain_ticket_granting_ticket
    rescue Util::VSAC::VSACError => e
      raise convert_vsac_error_into_shared_error(e)
    end

    params[:vsac_tgt] = vsac_tgt[:ticket]
    params[:vsac_tgt_expires_at] = vsac_tgt[:expires]
    persist_measure(params[:measure_file], params.permit!.to_h, current_user)
    redirect_to "#{root_path}##{params[:redirect_route]}"
  rescue StandardError => e
    # also clear the ticket granting ticket in the session if it was a VSACTicketExpiredError
    session[:vsac_tgt] = nil if e.is_a?(VSACTicketExpiredError)
    flash[:error] = turn_exception_into_shared_error_if_needed(e).front_end_version
    redirect_to "#{root_path}##{params[:redirect_route]}"
  end

  # Virus scanning
  def scan_for_viruses(params)
    # uploaded_file.tempfile
    if APP_CONFIG['virus_scan']['enabled']
      start = Time.now
      original_filename = params[:measure_file].original_filename
      begin
        headers = { params: { api_key: APP_CONFIG['virus_scan']['api_key'] } }
        scan_url = APP_CONFIG['virus_scan']['scan_url']
        payload = { file_name: original_filename, file: File.new(params[:measure_file].tempfile, 'rb') }
        scan_timeout = APP_CONFIG['virus_scan']['timeout']
        RestClient::Request.execute(method: :post, url: scan_url, payload: payload, timeout: scan_timeout, headers: headers)
      rescue StandardError => e
        Rails.logger.error "#{controller_name}#scan_for_viruses: #{e.message} #{e.http_code}"
        if e.is_a?(RestClient::ExceptionWithResponse) && e.http_code == 400 # rubocop:disable Style/
          raise VirusScannerError.new("Potential virus found in file " + original_filename, e.message)
        else
          # Possible errors :
          # RestClient::Unauthorized,
          # RestClient::Forbidden,
          # RestClient::RequestTimeout,
          # RestClient::ServerBrokeConnection,
          # Errno::ECONNREFUSED
          raise VirusScannerError.new("Cannot perform virus scanning. Try again later.", e.message)
        end
      ensure
        duration = Time.now - start
        Rails.logger.info "#{controller_name}#scan_for_viruses - scanner took: #{duration}s"
      end
    end
  end

  def destroy
    measure = CQM::Measure.by_user(current_user).where(id: params[:id]).first
    measure.destroy
    render :json => measure
  end

  def finalize
    measure_finalize_data = params.values.select {|p| p['fhir_id']}.uniq
    measure_finalize_data.each do |data|
      measure = CQM::Measure.by_user(current_user).where(fhir_id: data['fhir_id']).first
      begin
        # TODO: should this do the same for component measures?
        Measures::BundleLoader.update_population_set_and_strat_titles(measure, data['titles'])
        measure.save!
      rescue Exception => e
        operator_error = true
        flash[:error] = {title: "Error Loading Measure", summary: "Error Finalizing Measure", body: "An unexpected error occurred while finalizing this measure.  Please delete the measure, re-package and re-export the measure from the MAT, and re-upload the measure."}
      ensure
        # These 2 steps need to be run even if there was an error, otherwise there will be an infinite loop with the finalize dialog
        measure['needs_finalize'] = false
        measure.save!
      end
    end
    redirect_to root_path
  end

  def measurement_period
    measure = CQM::Measure.by_user(current_user).where(id: params[:id]).first
    year = params[:year]
    is_valid_year = year.to_i == year.to_f && year.length == 4 && year.to_i >= 1 && year.to_i <= 9999

    if is_valid_year
      original_year = measure.measure_period['start'][0..3]
      year_shift = year.to_i - original_year.to_i
      successful_patient_shift = if params[:measurement_period_shift_dates].present?
                                   shift_years(measure, year_shift)
                                 else # No patients to shift dates on, so just save to measure
                                   true
                                 end
      if successful_patient_shift
        measure.measure_period['start'] = year + '-01-01' # Jan 1
        measure.measure_period['end'] = year + '-12-31' # Dec 31
        measure.save!
      end

    else
      flash[:error] = { title: 'Error Updating Measurement Period',
                        summary: 'Error Updating Measurement Period',
                        body: 'Invalid year selected. Year must be 4 digits and between 1 and 9999' }
    end

    redirect_to "#{root_path}##{params[:redirect_route]}"
  end

  private

  def persist_measure(uploaded_file, permitted_params, user)
    measure =
      if permitted_params[:set_id].present?
        update_measure(uploaded_file: uploaded_file,
                      target_id: permitted_params[:set_id],
                      value_set_loader: build_vs_loader(permitted_params, false),
                      user: user)
      else
        create_measure(uploaded_file: uploaded_file,
                      measure_details: retrieve_measure_details(permitted_params),
                      value_set_loader: build_vs_loader(permitted_params, false),
                      user: user)
      end
    return measure, measure.set_id
  end

  def retrieve_measure_details(params)
    return {
      'episode_of_care'=>params[:calculation_type] == 'episode',
      'calculate_sdes'=>params[:calc_sde]
    }
  end

  def shift_years(measure, year_shift)
    return true
    # TODO: not implemented for patients and data elements yet
    # Copy the patients to make sure there are no errors before saving every patient
    # patients = CQM::Patient.by_user_and_set_id(current_user, measure.set_id).all.entries
    # errored_patients = []
    # patients.each do |patient|
    #   begin
    #     patient_birthdate_year = patient.fhir_patient.birthDatetime.year
    #     if year_shift + patient_birthdate_year > 9999 || year_shift + patient_birthdate_year < 0001
    #       raise RangeError
    #     end
    #     patient.fhir_patient.birthDatetime = shift_birth_datetime(patient.qdmPatient.birthDatetime, year_shift)
    #     patient.fhir_patient.dataElements.each do |data_element|
    #       data_element.shift_years(year_shift)
    #     end
    #   rescue RangeError => e
    #     errored_patients << patient
    #   end
    # end
    #
    # if errored_patients.empty?
    #   patients.each(&:save!)
    #   return true
    # else
    #   body_text = 'Element(s) on '
    #   errored_patients.each { |patient| body_text += patient.givenNames[0] + ' ' + patient.familyName + ', '}
    #   body_text += 'could not be shifted. Please make sure shift will keep all years between 1 and 9999'
    #   flash[:error] = { title: 'Error Updating Measurement Period',
    #                     summary: 'Error Updating Measurement Period',
    #                     body: body_text }
    #   return false
    # end
  end

  def shift_birth_datetime(birth_datetime, year_shift)
    if birth_datetime.month == 2 && birth_datetime.day == 29 && !Date.leap?(year_shift + birth_datetime.year)
      birth_datetime.change(year: year_shift + birth_datetime.year, day: 28)
    else
      birth_datetime.change(year: year_shift + birth_datetime.year)
    end
  end

  def obtain_ticket_granting_ticket
    # Retrieve a (possibly) existing ticket granting ticket
    ticket_granting_ticket = session[:vsac_tgt]

    # If the ticket granting ticket doesn't exist (or has expired), get a new one
    if ticket_granting_ticket.nil?
      # The user could open a second browser window and remove their ticket_granting_ticket in the session after they
      # prepared a measure upload assuming ticket_granting_ticket in the session in the first tab

      # First make sure we have credentials to attempt getting a ticket with. Throw an error if there are no credentials.
      if params[:vsac_api_key].nil?
        raise Util::VSAC::VSACNoCredentialsError.new
      end

      # Retrieve a new ticket granting ticket by creating the api class.
      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], api_key: params[:vsac_api_key])
      ticket_granting_ticket = api.ticket_granting_ticket

      # Create a new ticket granting ticket session variable
      session[:vsac_tgt] = ticket_granting_ticket
      return ticket_granting_ticket

    # If it does exist, let the api test it
    else
      api = Util::VSAC::VSACAPI.new(config: APP_CONFIG['vsac'], ticket_granting_ticket: ticket_granting_ticket)
      return api.ticket_granting_ticket
    end
  end
end
