class PatientsController < ApplicationController
  before_filter :authenticate_user!
  prepend_view_path(Rails.root.join('lib/templates/'))

  def update
    old_patient = CQM::Patient.by_user(current_user).find(params[:_id])
    begin
      updated_patient = CQM::Patient.new(params["cqmPatient"])
    rescue Mongoid::Errors::UnknownAttribute
      render json: {status: "error", messages: "Patient not properly structured for creation."}, status: :internal_server_error
      return
    end
    populate_measure_ids_if_composite_measures(updated_patient)
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
          zip.put_next_entry(File.join("qrda","#{index+1}_#{patient.familyName}_#{patient.givenNames[0]}.xml"))
          zip.puts qrda
        rescue Exception => e
          qrda_errors[patient.id] = e
        end
        # attach the HTML export, or the error
        begin
          html = QdmPatient.new(patient,true).render
          zip.put_next_entry(File.join("html","#{index+1}_#{patient.familyName}_#{patient.givenNames[0]}.html"))
          zip.puts html
        rescue Exception => e
          html_errors[patient.id] = e
        end
      end
      # add the summary content if there are results
      if (params[:results] && !params[:patients])
        measure = CQM::Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first
        zip.put_next_entry("#{measure.cms_id}_patients_results.html")
        zip.puts measure_patients_summary(patients, params[:results], qrda_errors, html_errors, measure)
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
    render_to_string partial: "index.html.erb", locals: {measure: measure, results: results, records: patients, html_errors: html_errors, qrda_errors: qrda_errors}
  end

end
