class PatientsController < ApplicationController
  before_filter :authenticate_user!

  RACE_NAME_MAP={'1002-5' => 'American Indian or Alaska Native','2028-9' => 'Asian','2054-5' => 'Black or African American','2076-8' => 'Native Hawaiian or Other Pacific Islander','2106-3' => 'White','2131-1' => 'Other'}
  ETHNICITY_NAME_MAP={'2186-5'=>'Not Hispanic or Latino', '2135-2'=>'Hispanic Or Latino'}

  # Index method used for patient bank, returning all shared patient records
  def index
    records = Record.where(is_shared: true).to_a
    # Some gymnastics to deal with a 1+N problem, so we don't need additional queries for each
    # record for cms_id and user_email; prepopulate these values using lookup tables, with lookups
    # for email by user_id and cms_id by user_id and measure_id
    user_ids = records.map(&:user_id).uniq
    users = User.only(:_id, :email).find(user_ids)
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

   # get the change history of patients for a measure (by HQMF Set ID)
  def history
    # get all previous versions of this measure, ordering by version
    # TODO add by_user(current_user) clause into query
    @measure_patients = Record.by_user(current_user).where({:measure_ids.in => [ params[:id] ]}).order_by(updated_at: :desc)
    results = []
    @measure_id = params[:id]
    @measure_patients.each_with_index do |patient,index|
      results << {}
      results[-1]['label'] = "#{patient.first} #{patient.last}"
      results[-1]['times'] = []
      
      #results[-1]['times'] << change
      curr_expected = []
      curr_actual = []
      
      
      
      # if this patient has no history we need to create a initial patient creation and leave
      if patient.history_tracks.count == 0
        change = {}
        # change['result'] = 'pass' # or 'fail'
        # for updateTime, we use the ObjectId generation time (because created_at is nil)
        change['updateTime'] = (patient._id.generation_time.tv_sec * 1000)
        change['changed'] = 'Initial Patient Creation'
        
        calc_results = calculate_value_results(filter_values_by_measure(patient.actual_values),
          filter_values_by_measure(patient.expected_values))
        
        change['result'] = calc_results[:result]
        change['results'] = calc_results[:results]
        change['values'] = calc_results[:values]
        
        results[-1]['times'] << change
        
      else
        # if the patient was created before history_tracking. the first tracker will be update instead of create
        # make an Initial patient for this 
        if patient.history_tracks.first.action == 'update'
          change = {}
          # change['result'] = 'pass' # or 'fail'
          # for updateTime, we use the ObjectId generation time (because created_at is nil)
          change['updateTime'] = (patient._id.generation_time.tv_sec * 1000)
          change['changed'] = 'Initial Patient Creation'
          
          # TODO: figure out how to get values for this.
          calc_results = calculate_value_results(filter_values_by_measure(patient.actual_values),
            filter_values_by_measure(patient.expected_values))
          
          change['result'] = calc_results[:result]
          change['results'] = calc_results[:results]
          change['values'] = calc_results[:values]
          
          results[-1]['times'] << change
        end
        # LOOP for each version of the patient
        patient.history_tracks.each do |track|
          curr_actual = filter_values_by_measure(track.modified['actual_values']) if track.modified['actual_values']
          curr_expected = filter_values_by_measure(track.modified['expected_values']) if track.modified['expected_values']
          
          # next if track.original.empty? # skip if this is the creation one
          @calc_values = {
            curr_actual: curr_actual,
            curr_expected: curr_expected
          }
          
          change = {}
          # change['result'] = 'pass' # or 'fail'
          change['updateTime'] = (track.updated_at.tv_sec * 1000)
          
          calc_results = calculate_value_results(curr_actual, curr_expected)
          
          change['result'] = calc_results[:result]
          change['results'] = calc_results[:results]
          change['values'] = calc_results[:values]
          description = ''
          
          if track.action == 'create'
            description = 'Initial Patient Creation'
          else 
            # loop through each of the attributes that were tracked on this change
            track.tracked_changes.each do |key, value|
              # puts key
              # puts "   " + value.to_s
              if key == 'actual_values'
                @calc_values.store(:from_act, value['from'])
                @calc_values.store(:to_act, value['to'])
              end

              if key == 'expected_values'
                @calc_values.store(:from_exp, value['from'])
                @calc_values.store(:to_exp, value['to'])
              end
              description += "Changes in #{key.gsub('_',' ')}: "
              description += history_changes(value['from'],value['to']) if key == 'source_data_criteria'
              description += history_changes_singles(key, value['from'], value['to']) unless value['from'].class == Array
              # history_changes_results(key, value['from'], value['to'], curr_actual, curr_expected, change['result']) unless key.index('value').nil?
              description += "<br/>"
            end
          end
          @calc_values[:curr_expected] = curr_expected
          @calc_values[:curr_actual] = curr_actual
          change['changed'] = description
          results[-1]['times'] << change
        end  # end LOOP
      end # end no history
    end # end patient loop
   render :json => results
  end

  def history_changes(from,to)
    changes = {}
    return '' unless from
    removed = from.map{ |x|x['id'] } - to.map{ |x|x['id']}
    changes['Removed'] = removed.join(', ') if !removed.empty?

    added = to.map{|x|x['id']} - from.map{|x|x['id']}
    changes['Added'] = added.join(', ') if !added.empty?

    changes['Changed'] = ''
    change_keys = to.map{|x|x['id']} - (added + removed)
    change_keys.each do |key|
      original = from.select{|x|x['id']==key}.first
      updated = to.select{|x|x['id']==key}.first
      diffs = updated.easy_diff(original)
      description = diffs.map{|x|x.keys}.flatten.uniq.join(', ')
      changes['Changed'] += "<br/>\n&nbsp;&nbsp;- #{key} #{description}"
    end

    narrative = ''
    changes.each do |key,value|
      narrative += "#{key} #{value}<br/>\n"
    end
    narrative
  end

  def history_changes_singles(field, from, to)
    narrative = ''
    if field.index('date').nil?
      narrative = "#{field} changed from #{from} to #{to}"
    else
      narrative = "#{field} changed from #{Time.at(from).strftime("%m/%d/%Y")} to #{Time.at(to).strftime("%m/%d/%Y")}"
    end
    narrative
  end

  def history_changes_results(field, from, to, acts, exps, fordot)
    puts "The from is #{from}"
    # binding.pry
    blah = {}
    unless from.nil?
      from.each do |pops|
        me = {}
        pops.to_a[2..pops.size - 1].each { |k, v| me[k.to_sym] = { field.to_sym => v } } # need to find a way to filter out measure_id and population_index
        blah[pops['population_index']] = me
      end # from.each
    end
    meh = {}
    unless to.nil?
      # acts = to if field == 'actual_values'
      # exps = to if field == 'expected_values'
      to.each do |pops|
        me = {}
        pops.to_a[2..pops.size - 1].each { |k, v| me[k.to_sym] = { field.to_sym => v } }
        meh[pops['population_index']] = me
      end # to.each
    end

    result = []
    evald = ''
    exps.each do |pop| # Run through excepted in case there are more logic populations in actual
      pop.keys[2..pop.size - 1].each do |k|
        if pop[k] == acts[pop['population_index']][k]
          evald = 'pass'
        else
          evald = 'fail'
          break
        end
      end
      result << evald
      fordot = result
    end

    # finale = { from: blah, to: meh }
    # if @big_finale.empty?
    #   @big_finale = finale
    # else
    #   finale.map do |ftk, ftv| # for from and to
    #     ftv.map do |pk, pv| # for each strat population
    #       pv.map do |plk, plv| # for each logic population
    #         @big_finale[ftk][pk][plk].store(plv.keys.first.to_sym, plv.values.first) if @big_finale[ftk][pk][plk].class != NilClass
    #       end # for each logic population
    #     end # for each strat population
    #   end # for from and to
    # end # @big_finale.empty?

    return acts, exps, fordot
  end



  # Returns the expected or actuals for the measure that this is being processed
  def filter_values_by_measure(values)
    if !values
      return []
    end
    result = []
    values.each do |value|
      result << value if value['measure_id'] == @measure_id
    end
    result
  end
  
  # takes the actual and expected values and determines the pass_fail situation for each population_set
  # returns the overall result and result for each population set
  def calculate_value_results(actual, expected)
    
    # TODO: determine what to do when actual is empty, just use expected
    actual = expected unless actual
    
    results = { result: 'pass', results: [], values: [] }
    
    # iterate through each actual for each population set
    actual.each do |pop_actual|
      pop_index = pop_actual['population_index']
      pop_expected = expected.find { |exp| exp['population_index'] == pop_index }
      
      pop_result = 'pass'
      pop_values = { population_index: pop_index }
      
      # compare each value
      HQMF::Measure::LogicExtractor::POPULATION_MAP.each_pair do |logic_code, logic_name|
        actual_value = pop_actual.fetch(logic_code, nil)
        expected_value = pop_expected.fetch(logic_code, 0)
        
        next if !actual_value
        
        pop_values[logic_code] = { expected: expected_value, actual: actual_value }
        
        if actual_value != expected_value
          pop_result = 'fail'
          results[:result] = 'fail'
        end
      end
      
      results[:results][pop_index] = pop_result
      results[:values][pop_index] = pop_values
    end
    
    return results
  end
  
  # wrap patientData in stratifications
  # var patientData = [
  #   {label: "Jack Sparrow", times: [{result:"pass", updateTime: 1451606400000}, 
  #                               {result:"pass", updateTime: 1451952000000, changed: "Measure Updated"}, 
  #                               {result:"fail", updateTime: 1452556800000, changed: "Encounter Added, Name Changed"}, 
  #                               {result:"pass", updateTime: 1453075200000, changed: "Measure Updated"}
  #                               ]},
  #   {label: "Jack Skellington", times: [{result:"fail", updateTime: 1451692800000}, 
  #                               {result:"fail", updateTime: 1451952000000, changed: "Measure Updated"},
  #                               {result:"fail", updateTime: 1452384000000, changed: "Name Changed"}, 
  #                               {result:"pass", updateTime: 1453075200000, changed: "Measure Updated"},
  #                               {result:"pass", updateTime: 1453079200000, changed: "Medication Removed"}
  #                               ]},
  #   {label: "Jack Sprat", times: [{result:"pass", updateTime: 1451865600000}, 
  #                               {result:"pass", updateTime: 1451952000000, changed: "Measure Updated"}, 
  #                               {result:"pass", updateTime: 1453075200000, changed: "Measure Updated"}
  #                               ]}
  # ];

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
      measure = Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]})
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
        measure = Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first
        zip.put_next_entry("#{measure.cms_id}_patients_results.html")
        zip.puts measure_patients_summary(records, params[:results].values, qrda_errors, html_errors, measure)
      end
    end
    cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload
    stringio.rewind
    filename = if params[:hqmf_set_id] then "#{Measure.by_user(current_user).where({:hqmf_set_id => params[:hqmf_set_id]}).first.cms_id}_patient_export.zip" else "bonnie_patient_export.zip" end
    send_data stringio.sysread, :type => 'application/zip', :disposition => 'attachment', :filename => filename
  end

  def excel_export

    # Grab all records for the given measure
    measure = Measure.where(hqmf_set_id: params[:hqmf_set_id], user_id: current_user.id).first
    records = Record.by_user(current_user).where({:measure_ids.in => [params[:hqmf_set_id]]})   
    
    # Only generate excel document if there are patients for the given measure.
    if records.length > 0
      cookies[:fileDownload] = "true" # We need to set this cookie for jquery.fileDownload
      package = PatientExport.export_excel_file(measure, records, params[:results])
      send_data package.to_stream.read, type: "application/xlsx", filename: "#{measure.cms_id}.xlsx"
    else
      render nothing: true
    end 
  end

private

  def update_patient(patient)

    # FIXME: This code handles current confused state of client side patient/measure association; everything should use measure_ids only
    patient['measure_ids'] ||= params['measure_ids'] || []
    patient['measure_ids'] << params['measure_id'] unless patient['measure_ids'].include? params['measure_id'] || params['measure_id'].nil?

    ['first', 'last', 'gender', 'expired', 'birthdate', 'description', 'description_category', 'deathdate', 'notes', 'is_shared'].each {|param| patient[param] = params[param]}

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
    patient.actual_values = params['actual_values']

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
    qrda_exporter = HealthDataStandards::Export::Cat1.new
    qrda_exporter.export(patient, measure, start_time, end_time)
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
