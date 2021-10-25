class PatientsController < ApplicationController
  include MeasureHelper
  include PatientImportHelper
  include VirusScanHelper
  before_action :authenticate_user!
  prepend_view_path(Rails.root.join('lib/templates/'))

  def update
    old_patient = CQM::Patient.by_user(current_user).find(params[:_id])
    begin
      updated_patient = CQM::Patient.new(cqm_patient_params)
    rescue Mongoid::Errors::UnknownAttribute
      render json: { status: "error", messages: "Patient not properly structured for creation." }, status: :internal_server_error
      return
    end
    populate_measure_ids_if_composite_measures(updated_patient)
    updated_patient._id = old_patient._id if old_patient
    updated_patient.group_id = current_user.current_group.id
    updated_patient.upsert
    render :json => updated_patient
  end

  def create
    begin
      patient = CQM::Patient.new(cqm_patient_params)
      patient[:group_id] = current_user.current_group.id
    rescue Mongoid::Errors::UnknownAttribute
      render json: { status: "error", messages: "Patient not properly structured for creation." }, status: :internal_server_error
      return
    end
    populate_measure_ids_if_composite_measures(patient)
    patient.save!
    render :json => patient
  end

  def destroy
    patient = CQM::Patient.by_user(current_user).find(params[:id])
    CQM::Patient.by_user(current_user).find(params[:id]).destroy
    render :json => patient.as_document
  end

  def delete_all_patients
    patients = CQM::Patient.by_user(current_user).where({ :measure_ids.in => [params[:hqmf_set_id]] }).find(params[:patients])
    count = patients.count
    patients.each(&:destroy)
    logger.info "delete_all_patients: User #{current_user.id} removed #{count} patients from #{params[:hqmf_set_id]} measure"
    flash[:msg] = {
      title: "Success",
      summary: "",
      body: "#{count} patients have been successfully deleted."
    }
    render json: { status: 'ok', redirect: 'true' }
  rescue StandardError => e
    logger.error "delete_all_patients: error message: #{e.message}"
    puts e.backtrace
    flash[:error] = {
      title: "Error",
      summary: '',
      body: "Error occurred while deleting patients."
    }
    render json: { status: 'error', redirect: 'true' }, status: :internal_server_error
  end

  def qrda_export
    if params[:patients]
      # if patients are given, they're from the patient bank; use those patients
      patients = CQM::Patient.where(is_shared: true).find(params[:patients])
    else
      patients = CQM::Patient.by_user(current_user)
      unless current_user.portfolio?
        patients = patients.where({ :measure_ids.in => [params[:hqmf_set_id]] })
      end
      measure = CQM::Measure.by_user(current_user).where({ :hqmf_set_id => params[:hqmf_set_id] })
    end

    qrda_errors = {}
    html_errors = {}

    stringio = Zip::ZipOutputStream::write_buffer do |zip|
      patients.each_with_index do |patient, index|
        # Use defined measure if available, else get the specific measure for this patient
        patient_measure = measure || get_associated_measure(patient)
        # attach the QRDA export, or the error
        begin
          qrda = qrda_patient_export(patient, patient_measure) # allow error to stop execution before header is written
          zip.put_next_entry(File.join("qrda", "#{index + 1}_#{patient.familyName}_#{patient.givenNames[0]}.xml"))
          zip.puts qrda
        rescue Exception => e
          qrda_errors[patient.id] = e
        end
        # attach the HTML export, or the error
        begin
          html = QdmPatient.new(patient, true).render
          zip.put_next_entry(File.join("html", "#{index + 1}_#{patient.familyName}_#{patient.givenNames[0]}.html"))
          zip.puts html
        rescue Exception => e
          html_errors[patient.id] = e
        end
      end
      # add the summary content if there are results
      if (params[:results] && !params[:patients])
        measure = CQM::Measure.by_user(current_user).where({ :hqmf_set_id => params[:hqmf_set_id] }).first
        zip.put_next_entry("#{measure.cms_id}_patients_results.html")
        zip.puts measure_patients_summary(patients, params[:results].permit!.to_h, qrda_errors, html_errors, measure)
      end
    end
    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload
    stringio.rewind
    measure = CQM::Measure.by_user(current_user).where({ :hqmf_set_id => params[:hqmf_set_id] }).first
    filename = if params[:hqmf_set_id]
                 "#{measure.cms_id}_patient_export.zip"
               else
                 "bonnie_patient_export.zip"
               end
    send_data stringio.sysread, :type => 'application/zip', :disposition => 'attachment', :filename => filename
  end

  def excel_export
    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload
    package = PatientExport.export_excel_cql_file(JSON.parse(params[:calc_results]),
                                                  JSON.parse(params[:patient_details]),
                                                  JSON.parse(params[:population_details]),
                                                  JSON.parse(params[:statement_details]),
                                                  params[:measure_hqmf_set_id])
    send_data package.to_stream.read, type: "application/xlsx", filename: "#{params[:file_name]}.xlsx"
  end

  def convert_patients
    measure_set_id = params[:hqmf_set_id]
    base_file_name = "fhir_patients_" + measure_set_id

    patients = CQM::Patient.by_user_and_hqmf_set_id(current_user, measure_set_id).all.entries

    patient_json_array = []

    patients.each do |patient|
      patient_json_array.push(patient.to_json)
    end

    qdm_json = '[' + patient_json_array.join(',') + ']'

    fhir_json = PatientFhirConverter::convert(qdm_json)

    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload

    temp_file = Tempfile.new(base_file_name + "-#{request.remote_ip}.zip")

    Zip::ZipOutputStream.open(temp_file.path) do |zos|
      zos.put_next_entry(base_file_name + ".json")
      zos.puts fhir_json

      # Generate HTML Error Report
      zos.put_next_entry("#{base_file_name}_conversion_results.html")
      zos.puts patient_fhir_conversion_report(JSON.parse(fhir_json))
    end

    send_file temp_file.path, :type => 'application/zip', :disposition => 'attachment', :filename => base_file_name + ".zip"
    temp_file.close # The temp file will be deleted some time...
  end

  def json_export
    measure_set_id = params[:hqmf_set_id]
    qdm_version = (APP_CONFIG['support_qdm_version']).to_s
    qdm_version_file = qdm_version.gsub '.', ''
    created_at = Time.now.to_i
    base_file_name = "patients_#{measure_set_id}_QDM_#{qdm_version_file}_#{created_at}"

    patients = CQM::Patient.by_user_and_hqmf_set_id(current_user, measure_set_id).all.entries

    measure = CQM::Measure.by_user(current_user).where(hqmf_set_id: measure_set_id).first

    patient_json_array = []

    patient_count = patients.count

    patients.each do |patient|
      patient_json = patient.to_json(except: ['_id', 'measure_ids', 'measure_id', 'group_id', 'bundleId'])
      patient_json_array.push(patient_json)
    end

    bonnie_version = Bonnie::Version.current
    patients_json = '[' + patient_json_array.join(',') + ']'
    patients_signature = Digest::MD5.hexdigest("#{qdm_version}#{patients_json}")

    measure_populations_json = measure.population_criteria.keys.to_json

    meta_json = "{" \
              "\"bonnie_version\":\"#{bonnie_version}\"," \
               "\"qdm_version\":\"#{qdm_version}\"," \
               "\"measure_set_id\":\"#{measure_set_id}\"," \
               "\"created_by\":\"#{current_user.email}\"," \
               "\"created_at\":\"#{created_at}\"," \
               "\"measure_populations\":#{measure_populations_json}," \
               "\"patient_count\":\"#{patient_count}\"," \
               "\"patients_signature\":\"#{patients_signature}\"" \
    "}"

    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload
    begin
      temp_file = Tempfile.new(base_file_name + "-#{request.remote_ip}.zip")

      Zip::ZipOutputStream.open(temp_file.path) do |zos|
        zos.put_next_entry(base_file_name + ".json")
        zos.print patients_json
        zos.put_next_entry("#{base_file_name}_meta.json")
        zos.print meta_json
      end

      send_file temp_file.path, :type => 'application/zip', :disposition => 'attachment', :filename => base_file_name + ".zip"
    ensure
      temp_file.close # The temp file will be deleted some time...
    end
  end

  def json_import
    virus_scan params[:patient_import_file]
    is_zip_file params[:patient_import_file]

    # Verify target measure exists
    measure = CQM::Measure.where(id: params[:measure_id]).first
    raise MeasureUpdateMeasureNotFound if measure.nil?

    # Get the JSON files from the zip:
    #   meta - contains measure population, patient signature, and troubleshooting meta data.
    #   patients - contains the CQM Patients array.
    json = unzip_patient_import_files(params[:patient_import_file])
    meta = JSON.parse(json[:meta])
    raise PatientsModified if meta["patients_signature"].nil?
    raise IncompatibleQdmVersion unless meta["qdm_version"].eql?(APP_CONFIG['support_qdm_version'].to_s)

    # Verify Patients signature hash
    signature = Digest::MD5.hexdigest("#{meta['qdm_version']}#{json[:patients]}")
    raise PatientsModified unless signature.eql?(meta["patients_signature"])

    # Deserialize patients json array to CQM Patient model
    cqm_patients = JSON.parse(json[:patients]).map { |p| CQM::Patient.new.from_json JSON.generate p }

    # Check whether the provided measure populations match the populations in the target measure
    matching_populations = meta["measure_populations"] == measure.population_criteria.keys

    # Prepare patients for insert
    cqm_patients.each do |patient|
      patient[:id] = BSON::ObjectId.new
      patient[:group_id] = current_user.current_group.id
      patient['measure_ids'] = [measure.hqmf_set_id]
      # If the provided populations match the populations in the target measure, include them in the import
      if matching_populations
        patient[:expectedValues].each do |ev|
          ev["measure_id"] = measure.hqmf_set_id
        end
      else
        patient[:expectedValues] = [] # The measure population docs will be inserted when the user saves the patient.
      end
      # Validate patient so we don't have partial inserts
      raise MeasureLoadingOther unless patient.validate
    end

    cqm_patients.each(&:upsert)
    flash[:msg] = {
      title: "QDM PATIENT IMPORT COMPLETED",
      summary: "",
      body: "Your patients have been successfully added to the measure.
            #{'Due to mismatching populations, the Expected Values have been cleared from imported patients.' unless matching_populations}"
    }
  rescue StandardError => e
    puts e.backtrace
    flash[:error] = turn_exception_into_shared_error_if_needed(e).front_end_version
  ensure
    redirect_to "#{root_path}#measures/#{params[:hqmf_set_id]}"
  end

  def share_patients
    patients = CQM::Patient.by_user(current_user)
    patients = patients.where({ :measure_ids.in => [params[:hqmf_set_id]] })
    # set patient measure_ids to those selected in the UI
    measure_ids = params[:selected] || []
    # plus the hqmf_set_id of the measure the patients are being shared from
    measure_ids.push(params[:hqmf_set_id])
    # set measure_ids for all patients on the current measure
    patients.each do |patient|
      patient.measure_ids = measure_ids
      patient.save
    end
    redirect_to root_path
  end

  private

  def unzip_patient_import_files(zip_file)
    json = {}
    Zip::File.open(zip_file.path) do |file|
      file.each do |entry|
        next if '__MACOSX'.in? Pathname(entry.name).each_filename # ignore anything in a __MACOSX folder
        json[:patients] = entry.get_input_stream.read if entry.name.end_with?(".json") && !entry.name.end_with?("meta.json")
        json[:meta] = entry.get_input_stream.read if entry.name.end_with?("meta.json")
      end
      raise MissingZipEntry if json.empty?
      raise MissingZipEntry, "Patients JSON" if json[:patients].nil?
      raise MissingZipEntry, "Patients Meta JSON" if json[:meta].nil?
    end
    json
  end

  def is_zip_file(file)
    if file.content_type != "application/zip" &&
       file.content_type != "application/x-zip-compressed"
      raise UploadedFileNotZip
    end
  end

  def virus_scan(file)
    
    scan_for_viruses(file)
  rescue VirusFoundError => e
    logger.error "VIRSCAN: error message: #{e.message}"
    raise PatientImportVirusFoundError
  rescue VirusScannerError => e
    logger.error "VIRSCAN: error message: #{e.message}"
    raise PatientImportVirusScannerError
    
  end

  def cqm_patient_params
    # It would be better if we could explicitly check all nested params, but given the number and depth of
    # them, it just isn't feasible.  We will instead rely on Mongoid::Errors::UnknownAttribute to be thrown
    # if any undeclared properties make it into the cqmPatient hash.  This is only possible because currently
    # no models being instantiated here include the Mongoid::Attributes::Dynamic module.
    params.require(:cqmPatient).permit!
  end

  # if the patient has any existing measure ids that correspond to component measures, all 'sibling' measure ids will be added
  def populate_measure_ids_if_composite_measures(patient)
    # create array of unique parent composite measure ids
    parent_measure_ids = []
    patient['measure_ids'].each do |measure_id|
      # component hqmf set ids are two ids with '&' in between
      next if measure_id.nil? || !measure_id.include?("&")
      parent_measure_ids << measure_id.split('&').first
    end
    parent_measure_ids.uniq!

    # for each parent measure, get all the child ids and add them to the patient
    parent_measure_ids.each do |parent_measure_id|
      parent_measure = CQM::Measure.by_user(current_user).only(:component_hqmf_set_ids).where(hqmf_set_id: parent_measure_id).first
      patient['measure_ids'].concat parent_measure["component_hqmf_set_ids"]
      patient['measure_ids'] << parent_measure_id
    end
    patient['measure_ids'].uniq!
  end

  def convert_to_hash(key, array)
    Hash[array.map { |element| [element[key], element.except(key)] }]
  end

  def get_associated_measure(patient)
    CQM::Measure.where(hqmf_set_id: patient.measure_ids.first)
  end

  def qrda_patient_export(patient, measure)
    start_time = DateTime.parse(measure[0].measure_period['low']['value'])
    end_time = DateTime.parse(measure[0].measure_period['high']['value'])
    options = { start_time: start_time, end_time: end_time }
    if patient.qdmPatient.get_data_elements('patient_characteristic', 'payer').empty?
      payer_codes = [{ 'code' => '1', 'system' => '2.16.840.1.113883.3.221.5', 'codeSystem' => 'SOP' }]
      patient.qdmPatient.dataElements.push QDM::PatientCharacteristicPayer.new(dataElementCodes: payer_codes, relevantPeriod: QDM::Interval.new(patient.qdmPatient.birthDatetime, nil))
    end
    Qrda1R5.new(patient, measure, options).render
  end

  def measure_patients_summary(patients, results, qrda_errors, html_errors, measure)
    render_to_string partial: "index.html.erb", locals: { measure: measure, results: results, records: patients, html_errors: html_errors, qrda_errors: qrda_errors }
  end

  # Returns the conversion error report as a String representation of an HTML file.
  #
  # The returned String is generated using an ERB template. Report data is pulled from the conversion service results JSON (fhir_json)
  # and passed to the template as an Array of Hashes.
  #
  # Each Hash contains the relevant patient metadata and conversion notices/errors retrieved from the conversion service results.
  # NOTICE tags are appended here, where as all WARNING/ERROR tags are sourced from the result json.
  def patient_fhir_conversion_report(fhir_json)
    conversion_error_report = []
    fhir_json.each do |patient_result|
      conversion_error_report << {
        :family_name => patient_result['fhir_patient']['name'][0]['family'],
        :given_name => patient_result['fhir_patient']['name'][0]['given'][0],
        :outcome => parse_conversion_messages(patient_result.dig('patient_outcome', 'conversionMessages'),
                                              patient_result.dig('patient_outcome', 'validationMessages')),
        :data_elements => parse_converted_data_elements(patient_result['data_elements'])
      }
    end
    render_to_string partial: "fhir_conversion_report.html.erb", locals: { report: conversion_error_report }
  end

  def parse_converted_data_elements(data_elements)
    result = []
    data_elements.each do |data_element|
      result << {
        :description => data_element['description'],
        :outcome => parse_conversion_messages(data_element['outcome']['conversionMessages'],
                                              data_element['outcome']['validationMessages'])
      }
    end
    result
  end

  # Creates an array of report ready messages from the result's conversion and validation messages.
  def parse_conversion_messages(conversion_messages, validation_messages)
    result = []
    conversion_messages.each {|msg| result << "NOTICE: " + msg } unless conversion_messages.empty?
    validation_messages.each {|msg| result << "#{msg['severity']}: #{msg['locationString']}, #{msg['message']}" } unless validation_messages.empty?
    result
  end

end
