class PatientExport

  def self.export_excel_file(measure, records)
    #List of attributes we want to print to excel.
    @@attributes = ['notes', 'first', 'last', 'birthdate', 'expired', 'deathdate',
            'ethnicity', 'race', 'gender']

    #Hash of populcation codes, and number of data criteria for each
    @@population_hash = Hash.new

    Axlsx::Package.new do |package|
      package.workbook do |workbook|

        # Styles
        fg_color = "000033"
        header_border = { :style => :thick, :color =>"000066", :edges => [:bottom] }
        styles = workbook.styles
        default = styles.add_style(:sz => 14,
                                  :bg_color => "FFFFFFF",
                                  :border => { :style => :thin,
                                              :color =>"DDDDDD",
                                              :edges => [:bottom] })
        rotated_style = styles.add_style(:b => true,
                                        :sz => 12,
                                        :alignment => {:textRotation => 90},
                                        :border => header_border,
                                        :fg_color => fg_color,
                                        :bg_color => "FFFFFFF")
        text_center = styles.add_style(:b => true,
                                        :sz => 14,
                                        :border => { :style => :thin, :color =>"000066" },
                                        :alignment => {:horizontal => :center, :vertical => :center})
        header = styles.add_style(:b => true,
                                  :sz => 14,
                                  :alignment => {:wrap_text => true},
                                  :border => header_border,
                                  :fg_color => fg_color,
                                  :bg_color => "FFFFFFF")
        header_dc = styles.add_style(:sz => 12,
                                  :alignment => {:wrap_text => true},
                                  :border => header_border,
                                  :fg_color => fg_color,
                                  :bg_color => "FFFFFFF")

        needs_fix = styles.add_style(:sz => 14,
                                  :bg_color => "FFFFFFF",
                                  :border => { :style => :thin,
                                              :color =>"DDDDDD",
                                              :edges => [:bottom] },
                                  :fg_color => "FF0000" )

        #Adding a new sheet per population
        measure.populations.each_with_index do |val, population_index| 
          @@expected_values = HQMF::PopulationCriteria::ALL_POPULATION_CODES & measure.populations[population_index].keys
          
          #Sheet name cannot be longer than 31 characters long. Replace with generic name if too long.
          worksheet_title = "#{val['title']} Patients".length > 31 ? "Population #{population_index+1}" : "#{val['title']} Patients" 

          workbook.add_worksheet(:name => worksheet_title) do |sheet|
            #Generate a list of all the headers we want.
            headers = @@expected_values*2 + @@attributes + generate_data_criteria_headers(measure)

            #Add top row with the "Expected Value" and "Actual Value" labels
            population_headings = Array.new(headers.length, nil)
            population_headings[0] = 'Expected'
            population_headings[@@expected_values.length] = 'Actual'

            heading_positions = {}
            previous_length = @@expected_values.length*2 + @@attributes.length

            HQMF::PopulationCriteria::ALL_POPULATION_CODES.each do |population|
              if @@population_hash[population] && @@population_hash[population] > 0
                population_headings[previous_length] = population
                heading_positions[population] = previous_length + 1
                previous_length += @@population_hash[population]
              end
            end

            # Adds first header column
            sheet.add_row(population_headings, style: text_center, height: 30)
            sheet.merge_cells "A1:#{@@expected_values.length.excel_column}1"
            sheet.merge_cells "#{(@@expected_values.length+1).excel_column}1:#{(@@expected_values.length*2).excel_column}1"
            HQMF::PopulationCriteria::ALL_POPULATION_CODES.each do |population|
              if @@population_hash[population] && @@population_hash[population] > 0
                start_position = heading_positions[population]
                start_column = start_position.excel_column
                end_column = (start_position + @@population_hash[population] - 1).excel_column
                sheet.merge_cells "#{start_column}1:#{end_column}1"
              end
            end

            # Adds second header column
            header_column_styles = Array.new(headers.length+2, header_dc)
            header_column_styles[0..@@expected_values.length*2] = Array.new(@@expected_values.length*2, rotated_style) # Rotated style for population columns
            header_column_styles[@@expected_values.length*2..(@@expected_values.length*2+@@attributes.length)] = Array.new(@@attributes.length, header) # Style with larger text for attributes
            sheet.add_row(headers, style: header_column_styles)

            #Writes one row per record
            generate_rows(sheet, records, measure, population_index)

            #Specifies column widths
            column_widths = Array.new(headers.length+2, 25)
            column_widths[0..@@expected_values.length*2] = Array.new(@@expected_values.length*2, 6) # Narrower width for the population columns
            column_widths[@@expected_values.length*2..(@@expected_values.length*2+@@attributes.length)] = Array.new(@@attributes.length, 16) # Width for attributes
            sheet.column_widths *column_widths

            # If not meeting expectations, make row red. else use default style
            for i in 1..records.length
              row = i + 2 # account for the two header rows
              if sheet["A#{row}"].value != sheet["#{(@@expected_values.length+1).excel_column}#{row}"].value
                sheet["A#{row}:#{headers.length.excel_column}#{row}"].each { |c| c.style = needs_fix }
              else
                sheet["A#{row}:#{headers.length.excel_column}#{row}"].each { |c| c.style = default }
              end
            end
          end
        end
      end
       package
    end
  end

  #Grabs all references of data_criteria. from the measure.
  def self.find_references(jsonData, references)
    if jsonData.is_a?(Hash)
      if jsonData.key?('preconditions')
        references = find_references(jsonData['preconditions'], references)
      elsif jsonData.key?('reference')
        references.push(jsonData['reference'])
      end
    else
      jsonData.each do |value|
        if value.key?('preconditions')
          references = find_references(value['preconditions'], references)
        else
          references.push(value['reference'])
        end
      end
    end
    references
  end

  #Extract a list of data criteria, including child criteria and temporal criteria.
  def self.extract_data_criteria(valuesArray, measure, criteria_list, is_temporal_references)
    valuesArray.each do |value|

      reference = is_temporal_references ? value['reference'] : value

      #Does not allow duplicates to be added
      unless criteria_list.include? reference #data_criteria['key']
        unless reference == "MeasurePeriod"
          criteria_list.push(reference) #data_criteria['key'])
        end
      end

      data_criteria = measure.data_criteria[reference]
      if data_criteria != nil
        if data_criteria.key?('children_criteria')
          criteria_list = extract_data_criteria(data_criteria['children_criteria'], measure, criteria_list, false)
        end
        if data_criteria.key?('temporal_references')
          criteria_list = extract_data_criteria(data_criteria['temporal_references'], measure, criteria_list, true)
        end
      end
    end
    criteria_list
  end

  def self.generate_data_criteria_headers(measure)
    logic_extractor = HQMF::Measure::LogicExtractor.new()
    logic_extractor.population_logic(measure)

    data_criteria_headers = Array.new()
    data_criteria_list = Array.new()
    @@data_criteria_keys = Array.new()

    HQMF::PopulationCriteria::ALL_POPULATION_CODES.each do |population|
      if measure.population_criteria.key?(population)
        references = Array.new()
        data_criteria_by_population = Array.new()
        #Using Recursion to get a list of references. Grabs references to data_criteria by population
        references = find_references(measure.population_criteria[population], references)
        data_criteria_by_population = extract_data_criteria(references, measure, data_criteria_by_population, false)

        #Setting population codes and length of each category
        @@population_hash[population] = data_criteria_by_population.length

        #Add the data criteria for current population to complete list
        data_criteria_list.push(*data_criteria_by_population)
      end
    end

    data_criteria_list.each do |key|
      data_criteria_headers.push(logic_extractor.data_criteria_logic(key).map(&:strip).join(' '))
      @@data_criteria_keys.push(key)
    end

    data_criteria_headers
  end

  def self.generate_rows(sheet, records, measure, population_index)

    #Setup the BonnieCalculator
    calculator = BonnieBackendCalculator.new
    begin
      calculator.set_measure_and_population(measure, 0, rationale: true)
    rescue => e
      setup_exception = "Measure setup exception: #{e.message}"
    end

    #Populates the patient data
    records.each do |patient|
      patient_attributes = Array.new
      @@expected_values.each do |value|
        patient_attributes.push(patient['expected_values'][population_index][value])
      end
      @@attributes.each do |value|
        if value == 'ethnicity'
          patient_attributes.push(patient[value]['name'])
        elsif value == 'race'
          patient_attributes.push(patient[value]['name'])
        elsif value == 'birthdate' || value == 'deathdate'
          time = Time.at(patient[value]).strftime("%m/%d/%Y") unless patient[value].nil?
          patient_attributes.push(time)
        else
          patient_attributes.push(patient[value])
        end
      end

      #Generate the calculated rationale for each patient against the measure.
      unless setup_exception
        begin
          result = calculator.calculate(patient)
          #Insert the results after the expected values but before the attributes
          actual_values = []
          @@expected_values.each do |key|
            actual_values.push(result[key])
          end
          patient_attributes.insert(@@expected_values.length, *actual_values)

          #Populate the values of each row, in the order that the headers were generated.
          @@data_criteria_keys.each do |key|
            value = result['rationale'][key]
            if value != false and value!= nil
              patient_attributes.push(true)
            else
              patient_attributes.push(value)
            end
          end
        rescue Exception => e
          #TODO what do we want to do if there is an error here.
          calculation_exception = "Measure calculation exception: #{e.message}"
        end
      end
      sheet.add_row patient_attributes, height: 24
    end
  end
end
