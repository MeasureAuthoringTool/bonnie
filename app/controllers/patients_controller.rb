class PatientsController < ApplicationController
  before_filter :authenticate_user!

  def update
    patient = Record.by_user(current_user).find(params[:id]) # FIXME: will we have an ID attribute on server side?
    update_patient(patient)
    patient.save!
    render :json => patient
  end

  def create
    patient = update_patient(Record.new)
    populate_measure_ids_if_composite_measures(patient)
    patient.save!
    render :json => patient
  end

  def materialize
    patient = update_patient(Record.new) # Always materialize a patient from scratch
    render :json => patient
  end

  def destroy
    patient = Record.by_user(current_user).find(params[:id]) # FIXME: will we have an ID attribute on server side?
    Record.by_user(current_user).find(params[:id]).destroy
    render :json => patient
  end

  def qrda_export
    if params[:patients]
      # if patients are given, they're from the patient bank; use those patients
      records = Record.where(is_shared: true).find(params[:patients])
    else
      records = Record.by_user(current_user)
      unless current_user.portfolio?
        records = records.where({:measure_ids.in => [params[:hqmf_set_id]]})
      end
      measure = CQM::Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]})
    end

    qrda_errors = {}
    html_errors = {}

    stringio = Zip::ZipOutputStream::write_buffer do |zip|
      records.each_with_index do |patient, index|
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
        zip.puts measure_patients_summary(records, params[:results].values, qrda_errors, html_errors, measure)
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
      JSON.parse(params[:patient_details]), JSON.parse(params[:population_details]),
      JSON.parse(params[:statement_details]),
      params[:measure_hqmf_set_id])
    send_data package.to_stream.read, type: "application/xlsx", filename: "#{params[:file_name]}.xlsx"
  end

private

  def update_patient(patient)

    # FIXME: This code handles current confused state of client side patient/measure association; everything should use measure_ids only
    patient['measure_ids'] ||= params['measure_ids'] || []
    patient['measure_ids'] << params['measure_id'] unless patient['measure_ids'].include? params['measure_id'] || params['measure_id'].nil?

    ['first', 'last', 'gender', 'expired', 'birthdate', 'description', 'description_category', 'deathdate', 'notes', 'is_shared'].each {|param| patient[param] = params[param]}

    patient['ethnicity'] = {'code' => params['ethnicity'], 'name'=>Record::ETHNICITY_NAME_MAP[params['ethnicity']], 'codeSystem' => 'CDC Race'}
    patient['race'] = {'code' => params['race'], 'name'=>Record::RACE_NAME_MAP[params['race']], 'codeSystem' => 'CDC Race'}

    measure_period = {'id' => 'MeasurePeriod', 'start_date' => params['measure_period_start'].to_i, 'end_date' => params['measure_period_end'].to_i}

    # work around Rails regression with empty nested attributes in parameters: https://github.com/rails/rails/issues/8832
    params['source_data_criteria'] ||= []
    params['source_data_criteria'].each { |c| c[:value] ||= [] }

    patient['source_data_criteria'] = params['source_data_criteria'] + [measure_period]
    # TODO: we should probably get the target measure period on the patient builder view
    # patient['measure_period_start'] = measure_period['start_date']
    # patient['measure_period_end'] = measure_period['end_date']

    patient.expected_values = params['expected_values']

    patient['origin_data'] ||= []
    patient['origin_data'] << params['origin_data'] if params['origin_data']

    patient.user = current_user
    patient.rebuild!(params[:payer])

    patient
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
    Hash[array.map {|element| [element[key],element.except(key)]}]
  end

  def get_associated_measure(patient)
    CQM::Measure.where(hqmf_set_id: patient.measure_ids.first)
  end

  # TODO: update this once we are using new patient model and cqm-reports (its partially updated)
  def qrda_patient_export(patient, measure)
    options = {
      start_time: Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 1, 1),
      end_time: Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 12, 31)
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
  def measure_patients_summary(records, results, qrda_errors, html_errors, measure)
    # restructure differences for output
    results.each do |r|
      r[:differences] = convert_to_hash(:medicalRecordNumber, r[:differences].values)
      r[:differences].values.each {|d| d[:comparisons] = convert_to_hash(:name, d[:comparisons].values)}
    end
    results
    rendering_context = HealthDataStandards::Export::RenderingContext.new
    rendering_context.template_helper = HealthDataStandards::Export::TemplateHelper.new('html', 'patient_summary', Rails.root.join('lib', 'templates'))
    rendering_context.render(:template => 'index', :locals => {records: records, results: results, qrda_errors: qrda_errors, html_errors: html_errors, measure: measure})
  end

end
