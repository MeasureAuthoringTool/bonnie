class PatientsController < ApplicationController
  before_filter :authenticate_user!

  def update
    old_patient = CQM::Patient.by_user(current_user).find(params[:_id])
    begin
      updated_patient = CQM::Patient.new(params["cqmPatient"])
    rescue Mongoid::Errors::UnknownAttribute
      render json: {status: "error", messages: "Patient not properly structured for creation."}, status: :internal_server_error
      return
    end
    updated_patient._id = old_patient._id if old_patient
    updated_patient.user_id = current_user._id
    updated_patient.upsert
    render :json => updated_patient
  end

  def create
    begin
      patient = CQM::Patient.new(params["cqmPatient"])
    rescue Mongoid::Errors::UnknownAttribute
      render json: {status: "error", messages: "Patient not properly structured for creation."}, status: :internal_server_error
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

  def qrda_export
    if params[:patients]
      # if patients are given, they're from the patient bank; use those patients
      patients = CQM::Patient.where(is_shared: true).find(params[:patients])
    else
      patients = CQM::Patient.by_user(current_user)
      unless current_user.portfolio?
        patients = patients.where({:measure_ids.in => [params[:hqmf_set_id]]})
      end
      measure = CQM::Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]})
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
          zip.put_next_entry(File.join("qrda","#{index+1}_#{patient.last}_#{patient.first}.xml"))
          zip.puts qrda
        rescue Exception => e
          qrda_errors[patient.id] = e
        end
        # attach the HTML export, or the error
        begin
          html = html_patient_export(patient, if current_user.portfolio? then [] else patient_measure end) # allow error to stop execution before header is written
          zip.put_next_entry(File.join("html","#{index+1}_#{patient.last}_#{patient.first}.html"))
          zip.puts html
        rescue Exception => e
          html_errors[patient.id] = e
        end
      end
      # add the summary content if there are results
      if (params[:results] && !params[:patients])
        measure = CQM::Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first
        zip.put_next_entry("#{measure.cms_id}_patients_results.html")
        zip.puts measure_patients_summary(patients, params[:results].observation_values, qrda_errors, html_errors, measure)
      end
    end
    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload
    stringio.rewind
    measure = CQM::Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first
    filename = if params[:hqmf_set_id] then "#{measure.cms_id}_patient_export.zip" else "bonnie_patient_export.zip" end
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

private

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
    Hash[array.map {|element| [element[key],element.except(key)]}]
  end

  def get_associated_measure(patient)
    CQM::Measure.where(hqmf_set_id: patient.measure_ids.first)
  end

  # TODO: update this once we are using new patient model and cqm-reports (its partially updated)
  def qrda_patient_export(patient, measure)
    start_time = Time.zone.at(measure.measure_period['low']['value'].to_i)
    end_time = Time.zone.at(measure.measure_period['high']['value'].to_i)
    options = {
      start_time: Time.new(start_time.year, start_time.month, start_time.day),
      end_time: Time.new(end_time.year, end_time.month, end_time.day)
    }
    qrda_exporter = Qrda1R5.new(patient, measure, options)
    qrda_exporter.render
  end

  # TODO: update this once we are using new patient model, change to point to something from cqm-reports
  def html_patient_export(patient, measure)
    value_sets = measure.map(&:value_sets).flatten unless measure.empty?
    html_exporter = HealthDataStandards::Export::HTML.new
    html_exporter.export(patient, measure, value_sets)
  end

  # TODO: update this once we are using new patient model, change to point to something from cqm-reports
  def measure_patients_summary(patients, results, qrda_errors, html_errors, measure)
    # restructure differences for output
    results.each do |r|
      r[:differences] = convert_to_hash(:medicalRecordNumber, r[:differences].observation_values)
      r[:differences].observation_values.each {|d| d[:comparisons] = convert_to_hash(:name, d[:comparisons].observation_values)}
    end
    results
    rendering_context = HealthDataStandards::Export::RenderingContext.new
    rendering_context.template_helper = HealthDataStandards::Export::TemplateHelper.new('html', 'patient_summary', Rails.root.join('lib', 'templates'))
    rendering_context.render(:template => 'index', :locals => {records: patients, results: results, qrda_errors: qrda_errors, html_errors: html_errors, measure: measure})
  end

end
