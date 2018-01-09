# Generates a formatted Excel document of Patients for the given measure and records. 
class PatientExport

  # List of attributes we want to print to excel
  DISPLAYED_ATTRIBUTES = ['notes', 'first', 'last', 'birthdate', 'expired', 'deathdate', 'ethnicity', 'race', 'gender']

  # Given a number, calculate the textual column name in excel (ie 1 -> A, 27 -> AA)
  def self.excel_column(number)
    return "" if number < 1
    result = 'A'
    (number - 1).times { result.next! }
    result
  end

  # Records cannot be less than 1
  def self.export_excel_file(measure, records, results)

    criteria_keys_by_population = measure.criteria_keys_by_population

    # COMMENTED OUT -- until we decide whether or not we want duplicate data.
    # Remove duplicates by population type
    #criteria_keys_by_population.each do | population_type, values | 
    #  values.uniq!
    #end

    criteria_key_header_lookup = self.create_criteria_key_header_lookup(measure, criteria_keys_by_population)

    Axlsx::Package.new do |package|
      package.workbook do |workbook|

        # Styles
        fg_color = "000033"
        header_border = { :style => :thick, :color => "000066", :edges => [:bottom] }
        styles = workbook.styles
        default = styles.add_style(:sz => 14,
                                   :bg_color => "FFFFFFF",
                                   :border => { :style => :thin,
                                                :color => "DDDDDD",
                                                :edges => [:bottom] })
        rotated_style = styles.add_style(:b => true,
                                         :sz => 12,
                                         :alignment => { :textRotation => 90 },
                                         :border => header_border,
                                         :fg_color => fg_color,
                                         :bg_color => "FFFFFFF")
        text_center = styles.add_style(:b => true,
                                       :sz => 14,
                                       :border => { :style => :thin, :color =>"000066" },
                                       :alignment => { :horizontal => :center, :vertical => :center })
        header = styles.add_style(:b => true,
                                  :sz => 14,
                                  :alignment => { :wrap_text => true },
                                  :border => header_border,
                                  :fg_color => fg_color,
                                  :bg_color => "FFFFFFF")
        header_dc = styles.add_style(:sz => 12,
                                     :alignment => { :wrap_text => true },
                                     :border => header_border,
                                     :fg_color => fg_color,
                                     :bg_color => "FFFFFFF")
        needs_fix = styles.add_style(:sz => 14,
                                     :bg_color => "FFFFFFF",
                                     :border => { :style => :thin,
                                                  :color =>"DDDDDD",
                                                  :edges => [:bottom] },
                                     :fg_color => "FF0000")

        # Adding a new sheet per population
        measure.populations.each_with_index do |population, population_index|
          population_criteria = HQMF::PopulationCriteria::ALL_POPULATION_CODES & population.keys
          # Find the data criteria keys that are associated with this particular population
          population_criteria_keys = []
          population_criteria.each do |pc|
            population_criteria_keys.concat(criteria_keys_by_population[population[pc]])
          end

          # Sheet name cannot be longer than 31 characters long. Replace with generic name if too long or not present.
          worksheet_title = if population['title'].blank? || "#{population['title']} Patients".length > 31
                              "Population #{population_index+1}"
                            else
                              "#{population['title']} Patients"
                            end

          workbook.add_worksheet(name: worksheet_title) do |sheet|
            # Generate a list of all the headers we want, translating criteria keys to their human readable form
            headers = population_criteria*2 + DISPLAYED_ATTRIBUTES + population_criteria_keys.map { |ck| criteria_key_header_lookup[ck] }

            # Add top row with the "Expected Value" and "Actual Value" labels
            toplevel_headings = Array.new(headers.length, nil)
            toplevel_headings[0] = 'Expected'
            toplevel_headings[population_criteria.length] = 'Actual'

            heading_positions = {}
            previous_length = population_criteria.length*2 + DISPLAYED_ATTRIBUTES.length
          
            population_criteria.each do |pc|
              if criteria_keys_by_population[population[pc]].length > 0
                toplevel_headings[previous_length] = pc
                heading_positions[pc] = previous_length + 1
                previous_length += criteria_keys_by_population[population[pc]].length
              end
            end

            # Adds first header column
            sheet.add_row(toplevel_headings, style: text_center, height: 30)
            sheet.merge_cells "A1:#{excel_column(population_criteria.length)}1"
            sheet.merge_cells "#{excel_column(population_criteria.length+1)}1:#{excel_column(population_criteria.length*2)}1"
      
            population_criteria.each do |pc|
              if criteria_keys_by_population[population[pc]].length > 0
                start_position = heading_positions[pc]
                start_column = excel_column(start_position)
                end_column = excel_column(start_position + criteria_keys_by_population[population[pc]].length - 1)
                sheet.merge_cells "#{start_column}1:#{end_column}1"
              end
            end

            # Adds second header column
            header_column_styles = Array.new(headers.length+2, header_dc)
            header_column_styles[0..population_criteria.length*2] = Array.new(population_criteria.length*2, rotated_style) # Rotated style for population columns
            header_column_styles[population_criteria.length*2..(population_criteria.length*2+DISPLAYED_ATTRIBUTES.length)] = Array.new(DISPLAYED_ATTRIBUTES.length, header) # Style with larger text for attributes
            sheet.add_row(headers, style: header_column_styles)

            # Writes one row per record
            generate_rows(sheet, records, measure, population_index, population_criteria, population_criteria_keys, results, criteria_keys_by_population)

            # Specifies column widths
            column_widths = Array.new(headers.length+2, 25)
            column_widths[0..population_criteria.length*2] = Array.new(population_criteria.length*2, 6) # Narrower width for the population columns
            column_widths[population_criteria.length*2..(population_criteria.length*2+DISPLAYED_ATTRIBUTES.length)] = Array.new(DISPLAYED_ATTRIBUTES.length, 16) # Width for attributes
            sheet.column_widths *column_widths

            # If not meeting expectations, make row red. else use default style
            records.length.times do |i|

              row = i + 3 # account for the two header rows

              # See if any of the expectations don't match
              mismatch = false
              population_criteria.length.times do |j|
                if sheet["#{excel_column(j+1)}#{row}"].value != sheet["#{excel_column(population_criteria.length+j+1)}#{row}"].value
                  mismatch = true
                end
              end

              if mismatch
                sheet["A#{row}:#{excel_column(headers.length)}#{row}"].each { |c| c.style = needs_fix }
              else
                sheet["A#{row}:#{excel_column(headers.length)}#{row}"].each { |c| c.style = default }
              end
            end
          end
        end
      end
       package
    end
  end

  # Given a measure and the criteria keys, return a lookup hash for the human readable name
  def self.create_criteria_key_header_lookup(measure, criteria_keys_by_population)
    logic_extractor = HQMF::Measure::LogicExtractor.new()
    logic_extractor.population_logic(measure)
    criteria_key_header_lookup = {}
    criteria_keys_by_population.each do |population_code, criteria_keys|
      criteria_keys.each do |ck|
        criteria_key_header_lookup[ck] = logic_extractor.data_criteria_logic(ck).map(&:strip).join(' ')
      end
    end
    criteria_key_header_lookup
  end

  def self.generate_rows(sheet, records, measure, population_index, population_categories, population_criteria_keys, results, criteria_keys_by_population)
    # Populates the patient data
    records.each do |patient|
      # Removes \" from beignning and end of the patient_id string 
      exported_results = MeasureExportedResults.new(patient.id.to_json.tr('\"',''), population_index, results)
      patient_row = []

      # populates the array with expected values for each population
      population_categories.each do |population_category|
        # Filter out the expected values that match the measure hqmf_set_id. Return the first object in the array.
        expected_values = patient[:expected_values].select{ |expected_values| expected_values[:measure_id] == measure.hqmf_set_id && 
                                                                              expected_values[:population_index] == population_index }.try(:first)
        # populate array with expected values
        if expected_values && expected_values[population_category] && expected_values[population_category] != []
          patient_row.push(expected_values[population_category])
        else
          patient_row.push(0)
        end
      end

      # populates the array with actual values for each population
      population_categories.each do |population_category|
        value = exported_results.value_for_population_type(population_category)
        if value == nil
          patient_row.push('X')
        else
          patient_row.push(value)
        end
      end

      DISPLAYED_ATTRIBUTES.each do |value|
        if value == 'ethnicity'
          patient_row.push(patient[value]['name'])
        elsif value == 'race'
          patient_row.push(patient[value]['name'])
        elsif value == 'birthdate' || value == 'deathdate'
          time = Time.at(patient[value]).strftime("%m/%d/%Y") unless patient[value].nil?
          patient_row.push(time)
        elsif value == 'expired' && patient[value] == nil
          patient_row.push(false)
        else
          patient_row.push(patient[value])
        end
      end

      # Generate a list of population types in order of the population_criteria_keys
      population_list = []
      criteria_keys_by_population.each do |key, list|
        list.each do |value| 
          population_list.push(key)
        end
      end

      # Populate the values of each row, in the order that the headers were generated.
      population_criteria_keys.each_with_index do |key, index|
        value = exported_results.get_criteria_value(key, population_list[index]) 
        patient_row.push(value)
      end

      sheet.add_row patient_row, height: 24

    end
  end
end
