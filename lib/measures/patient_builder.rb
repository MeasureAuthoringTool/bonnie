module Measures
  # Utility class for building test patients
  class PatientBuilder
    JAN_ONE_THREE_THOUSAND=32503698000000
  

    def self.rebuild_patient(patient)

      # clear out patient data
      if (patient.id)
        ['allergies', 'care_goals', 'conditions', 'encounters', 'immunizations', 'medical_equipment', 'medications', 'procedures', 'results', 'social_history', 'vital_signs'].each do |section|
          patient[section] = [] if patient[section]
        end
        patient.medical_record_number ||= Digest::MD5.hexdigest("#{patient.first} #{patient.last}")
      end

      values = Hash[
        *Measure.where({'measure_id' => {'$in' => patient['measure_ids'] || []}}).map{|m|
          m.value_sets.map do |value_set|
            
            preferred_set = nil
            filtered = HealthDataStandards::SVS::ValueSet.new(value_set.attributes)
            filtered.concepts.reject! {|c| c.black_list || !c.white_list}
            filtered['concepts'] = filtered.concepts
            preferred_set = filtered unless filtered.concepts.empty?
            preferred_set ||= value_set
            [value_set.oid, preferred_set]
          end
        }.map(&:to_a).flatten
      ]

      @data_criteria = Hash[
        *Measure.where({'measure_id' => {'$in' => patient['measure_ids'] || []}}).map{|m|
          m.source_data_criteria.reject{|k,v|
            ['patient_characteristic_birthdate','patient_characteristic_gender', 'patient_characteristic_expired'].include?(v['definition'])
          }
        }.map(&:to_a).flatten
      ]
      
      patient.source_data_criteria.each {|v|
        next if v['id'] == 'MeasurePeriod'
        data_criteria = HQMF::DataCriteria.from_json(v['id'], @data_criteria[v['id']])
        v['definition'] ||= data_criteria.definition # tmp, get definition and status onto source dc
        v['status'] ||= data_criteria.status # tmp, get definition and status onto source dc
        data_criteria.values = []
        result_vals = v['value'] || []
        result_vals = [result_vals] if !result_vals.nil? and !result_vals.is_a? Array 
        result_vals.each do |value|
          data_criteria.values << (value['type'] == 'CD' ? HQMF::Coded.new('CD', nil, nil, value['code_list_id']) : HQMF::Range.from_json('low' => {'value' => value['value'], 'unit' => value['unit']}))
        end if v['value']
        v['field_values'].each do |key, value|
          data_criteria.field_values ||= {}
          converted_time = Time.strptime(value['value'],"%m/%d/%Y %H:%M").to_time.strftime('%Y%m%d%H%M%S') if (value['type'] == 'TS') 
          data_criteria.field_values[key] = HQMF::DataCriteria.convert_value(value)
          data_criteria.field_values[key].value = converted_time if converted_time
        end if v['field_values']
        if v['negation'] == 'true'
          data_criteria.negation = true
          data_criteria.negation_code_list_id = v['negation_code_list_id']
        end
        low = {'value' => Time.at(v['start_date'].to_i / 1000).strftime('%Y%m%d%H%M%S'), 'type'=>'TS' }
        high = {'value' => Time.at(v['end_date'].to_i / 1000).strftime('%Y%m%d%H%M%S'), 'type'=>'TS' }
        high = nil if v['end_date'] == JAN_ONE_THREE_THOUSAND

        data_criteria.modify_patient(patient, HQMF::Range.from_json({'low' => low,'high' => high}), values.values)
      }
   

    end

    def self.get_data_criteria(measure_list)
      Hash[
        *Measure.where({'measure_id' => {'$in' => measure_list}}).map{|m|
          m.source_data_criteria.reject{|k,v|
            ['patient_characteristic_birthdate','patient_characteristic_gender', 'patient_characteristic_expired'].include?(v['definition'])
          }.each{|k,v|
            v['title'] += ' (' + m.measure_id + ')'
          }
        }.map(&:to_a).flatten
      ]
    end

    def self.missing_data_criteria(record, data_criteria)
      record.source_data_criteria.select {|e| data_criteria[e['id']].nil? && e['id'] != 'MeasurePeriod' }
    end

    def self.check_data_criteria!(record, data_criteria)
      dropped_data_criteria = []
      if (record.respond_to? :source_data_criteria)
        # check to see if there are any data criteria that we cannot find.  If there are, we want to remove them.
        dropped_source_criteria = Measures::PatientBuilder.missing_data_criteria(record, data_criteria)
        dropped_source_criteria.each do |dc|
          alternates = data_criteria.select {|key,value| value['code_list_id'] == dc['oid'] && value['status'] == dc['status'] && value['definition'] == dc['definition'] }.keys
          if (!alternates.empty?)
            alternate = (alternates.sort {|left, right| Text::Levenshtein.distance(left, dc['id']) <=> Text::Levenshtein.distance(right, dc['id'])}).first
            # update the source data criteria to set the alternate id with the closes id and a matching code set id
            puts "\talternate: #{alternate} for #{dc['id']}"
            dc['id'] = alternate
          end
        end

        dropped_ids = Measures::PatientBuilder.missing_data_criteria(record, data_criteria).map {|dc| dc['id'] }

        record.source_data_criteria.delete_if {|dc| dropped = dropped_ids.include? dc['id']; dropped_data_criteria << dc if dropped; dropped}
        
      end
      dropped_data_criteria
    end

  end


end
