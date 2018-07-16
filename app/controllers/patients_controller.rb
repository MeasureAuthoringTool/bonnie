class PatientsController < ApplicationController
  before_filter :authenticate_user!

  # Index method used for patient bank, returning all shared patient records
  def index
    records = Record.where(is_shared: true).to_a
    # Some gymnastics to deal with a 1+N problem, so we don't need additional queries for each
    # record for cms_id and user_email; prepopulate these values using lookup tables, with lookups
    # for email by user_id and cms_id by user_id and measure_id
    user_ids = records.map(&:user_id).uniq
    users = User.only(:_id, :email).where(:_id.in => user_ids)
    email_lookup = users.each_with_object({}) { |u, h| h[u.id] = u.email }
    measure_ids = records.map { |r| r.measure_ids.first }.uniq
    measures = Measure.only(:_id, :hqmf_set_id, :user_id, :cms_id).where(:hqmf_set_id.in => measure_ids, :user_id.in => user_ids)
    cms_lookup = measures.each_with_object(Hash.new { |h, k| h[k] = {} }) { |m, h| h[m.user_id][m.hqmf_set_id] = m.cms_id }
    records = records.select { |r| measures.map(&:hqmf_set_id).include? r.measure_ids.first } # select shared patients with existing measures
    records.each do |record|
      record.user_email = email_lookup[record.user_id]
      record.cms_id = cms_lookup[record.user_id][record.measure_ids.first]
    end
    render :json => MultiJson.encode(records.as_json(methods: [:cms_id, :user_email]))
  end

  def update
    patient = Record.by_user(current_user).find(params[:id]) # FIXME: will we have an ID attribute on server side?
    update_patient(patient)
    patient.save!
    render :json => patient
  end

  def create
    patient = update_patient(Record.new)
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
      if params[:isCQL]
        measure = CqlMeasure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]})
      else
        measure = Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]})
      end
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
        if params[:isCQL] == 'true'
          measure = CqlMeasure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first
        else
          measure = Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first
        end
        zip.put_next_entry("#{measure.cms_id}_patients_results.html")
        zip.puts measure_patients_summary(records, params[:results].values, qrda_errors, html_errors, measure)
      end
    end
    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload
    stringio.rewind
    if params[:isCQL] == 'true'
      measure = CqlMeasure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first
    else
      measure = Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first
    end
    filename = if params[:hqmf_set_id] then "#{measure.cms_id}_patient_export.zip" else "bonnie_patient_export.zip" end
    send_data stringio.sysread, :type => 'application/zip', :disposition => 'attachment', :filename => filename
  end

  def excel_export
    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload
    package = PatientExport.export_excel_cql_file(JSON.parse(params[:calc_results]), 
      JSON.parse(params[:patient_details]), JSON.parse(params[:population_details]),
      JSON.parse(params[:statement_details]))
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
    patient.bundle = current_user.bundle

    patient.rebuild!(params[:payer])

    patient
  end

  def convert_to_hash(key, array)
    Hash[array.map {|element| [element[key],element.except(key)]}]
  end

  def get_associated_measure(patient)
    Measure.where(hqmf_set_id: patient.measure_ids.first)
  end

  def qrda_patient_export(patient, measure)
    start_time = Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 1, 1)
    end_time = Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 12, 31)
    qrda_exporter = HealthDataStandards::Export::Cat1.new 'r3_1'
    qrda_exporter.export(patient, measure, start_time, end_time, nil, 'r3_1')
  end

  def html_patient_export(patient, measure)
    value_sets = measure.map(&:value_sets).flatten unless measure.empty?
    html_exporter = HealthDataStandards::Export::HTML.new
    html_exporter.export(patient, measure, value_sets)
  end

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
