class PatientsController < ApplicationController
  before_filter :authenticate_user!

  RACE_NAME_MAP={'1002-5' => 'American Indian or Alaska Native','2028-9' => 'Asian','2054-5' => 'Black or African American','2076-8' => 'Native Hawaiian or Other Pacific Islander','2106-3' => 'White','2131-1' => 'Other'}
  ETHNICITY_NAME_MAP={'2186-5'=>'Not Hispanic or Latino', '2135-2'=>'Hispanic Or Latino'}

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

  def export
    records = Record.by_user(current_user)
    unless current_user.portfolio?
      records = records.where({:measure_ids.in => [params[:hqmf_set_id]]})
    end

    qrda_exporter = HealthDataStandards::Export::Cat1.new
    html_exporter = HealthDataStandards::Export::HTML.new

    measure = Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).map(&:as_hqmf_model)
    start_time = Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 1, 1)
    end_time = Time.new(Time.zone.at(APP_CONFIG['measure_period_start']).year, 12, 31)

    # if we have results we want to write a summary
    summary_content = get_summary_content(measure, records, params[:results].values) if (params[:results])

    stringio = Zip::ZipOutputStream::write_buffer do |zip|
      records.each_with_index do |patient, index|
        zip.put_next_entry(File.join("qrda","#{index+1}_#{patient.last}_#{patient.first}.xml"))
        zip.puts qrda_exporter.export(patient, measure, start_time, end_time)
        zip.put_next_entry(File.join("html","#{index+1}_#{patient.last}_#{patient.first}.html"))
        if current_user.portfolio?
          zip.puts html_exporter.export(patient)
        else
          zip.puts html_exporter.export(patient, measure)
        end
      end
      if summary_content
        zip.put_next_entry("#{measure.first.cms_id}_results.html")
        zip.puts summary_content
      end
    end

    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload

    stringio.rewind
    send_data stringio.sysread, :type => 'application/zip', :disposition => 'attachment', :filename => "#{measure.first.cms_id}_patient_export.zip"

  end

private

  def update_patient(patient)

    # FIXME: This code handles current confused state of client side patient/measure association; everything should use measure_ids only
    patient['measure_ids'] ||= params['measure_ids'] || []
    patient['measure_ids'] << params['measure_id'] unless patient['measure_ids'].include? params['measure_id'] || params['measure_id'].nil?

    ['first', 'last', 'gender', 'expired', 'birthdate', 'description', 'description_category', 'deathdate'].each {|param| patient[param] = params[param]}

    patient['ethnicity'] = {'code' => params['ethnicity'], 'name'=>ETHNICITY_NAME_MAP[params['ethnicity']], 'codeSystem' => 'CDC Race'}
    patient['race'] = {'code' => params['race'], 'name'=>RACE_NAME_MAP[params['race']], 'codeSystem' => 'CDC Race'}

    measure_period = {'id' => 'MeasurePeriod', 'start_date' => params['measure_period_start'].to_i, 'end_date' => params['measure_period_end'].to_i}

    # work around Rails regression with empty nested attributes in parameters: https://github.com/rails/rails/issues/8832
    params['source_data_criteria'] ||= []
    params['source_data_criteria'].each { |c| c[:value] ||= [] }

    patient['source_data_criteria'] = params['source_data_criteria'] + [measure_period]
    # TODO: we should probably get the target measure period on the patient builder view
    # patient['measure_period_start'] = measure_period['start_date']
    # patient['measure_period_end'] = measure_period['end_date']

    patient.expected_values = params['expected_values']

    patient.user = current_user
    patient.bundle = current_user.bundle

    patient.rebuild!(params[:payer])

    patient
  end

  def get_summary_content(measure, records, results)
    # restructure differences for output
    results.each do |r|
      r[:differences] = convert_to_hash(:medicalRecordNumber, r[:differences].values)
      r[:differences].values.each {|d| d[:comparisons] = convert_to_hash(:name, d[:comparisons].values)}
    end

    rendering_context = HealthDataStandards::Export::RenderingContext.new
    rendering_context.template_helper = HealthDataStandards::Export::TemplateHelper.new('html', 'patient_summary', Rails.root.join('lib', 'templates'))
    rendering_context.render(:template => 'index', :locals => {records: records, results: results, measure: measure.first})
  end

  def convert_to_hash(key, array)
    Hash[array.map {|element| [element[key],element.except(key)]}]
  end

end
