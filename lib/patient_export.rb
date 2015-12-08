class PatientExport

  #List of attributes we want to print to excel.
  @@attributes = ['notes', 'first', 'last', 'birthdate', 'expired', 'deathdate',
          'ethnicity', 'race', 'gender']

  def export_excel_file(measure, records)

    @@expected_values = measure.populations[0].keys

    Axlsx::Package.new do |p|
      p.workbook do |wb|
        #Create styles.
        bg_color = "DDDDDD"
        fg_color = "000033"
        header_border = { :style => :thick, :color =>"000066", :edges => [:bottom] }
        styles = wb.styles
        default = styles.add_style(:sz => 14)
        rotated_style = styles.add_style(:b => true,
                                        :sz => 12,
                                        :alignment => {:textRotation => 60, :horizontal => :center, :vertical => :bottom},
                                        :border => header_border,
                                        :fg_color => fg_color,
                                        :bg_color => bg_color)
        text_center = styles.add_style(:b => true, :sz => 14, :alignment => {:horizontal => :center}, :b => true)
        header = styles.add_style(:b => true,
                                  :sz => 14,
                                  :alignment => {:wrap_text => true},
                                  :border => header_border,
                                  :fg_color => fg_color,
                                  :bg_color => bg_color)
        header_dc = styles.add_style(:b => true,
                                  :sz => 12,
                                  :alignment => {:wrap_text => true},
                                  :border => header_border,
                                  :fg_color => fg_color,
                                  :bg_color => bg_color)

        wb.add_worksheet(:name => "#{measure.cms_id} Patients") do |sheet|
          #Generate a list of all the headers we want.
          headers = @@expected_values*2 + @@attributes + generate_data_criteria_headers(measure)

          #Add top row
          sheet.add_row ['Answer Key'], style:[text_center]
          sheet.merge_cells "A1:#{@@expected_values.length.excel_column}1"
          #Creates the labels for the top row. And adds styles.
          header_column_styles = Array.new(headers.length+2, header_dc)
          header_column_styles[0..@@expected_values.length*2] = Array.new(@@expected_values.length*2, rotated_style) # Rotated style for population columns
          header_column_styles[@@expected_values.length*2..(@@expected_values.length*2+@@attributes.length)] = Array.new(@@attributes.length, header) # Style with larger text for attributes
          sheet.add_row(headers, style: header_column_styles)
          # Adds the "Expected Value" and "Actual Value" labels
          population_headings = Array.new(@@expected_values.length*2, nil)
          population_headings[0] = 'Expected Value'
          population_headings[@@expected_values.length] = 'Actual Value'
          sheet.add_row(population_headings, style: text_center)
          sheet.merge_cells "A3:#{@@expected_values.length.excel_column}3"
          sheet.merge_cells "#{(@@expected_values.length+1).excel_column}3:#{(@@expected_values.length*2).excel_column}3"

          #Writes one row per record
          generate_rows(sheet, records, measure)

          #Specifies column widths
          column_widths = Array.new(headers.length+2, 25)
          column_widths[0..@@expected_values.length*2] = Array.new(@@expected_values.length*2, 6) # Narrower width for the population columns
          column_widths[@@expected_values.length*2..(@@expected_values.length*2+@@attributes.length)] = Array.new(@@attributes.length, 16) # Width for attributes
          sheet.column_widths *column_widths

          sheet["A4:#{headers.length.excel_column}#{records.length+3}"].each { |c| c.style = default }
        end
      end
      p.serialize('test.xlsx')
    end
  end

  def generate_data_criteria_headers(measure)
    logic_extractor = HQMF::Measure::LogicExtractor.new()
    logic_extractor.population_logic(measure)
    data_criteria_headers = Array.new()

    @@data_criteria_keys = Array.new()
    measure.data_criteria.each do |key, value|
      data_criteria_headers.push(logic_extractor.data_criteria_logic(key).map(&:strip).join(' '))
      @@data_criteria_keys.push(key)
    end
    data_criteria_headers
  end

  def generate_rows(sheet, records, measure)

    @@expected_values = measure.populations[0].keys

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
        patient_attributes.push(patient['expected_values'][0][value])
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
            if value != false
              patient_attributes.push("True")
            else
              patient_attributes.push("False")
            end
          end
        rescue => e
          calculation_exception = "Measure calculation exception: #{e.message}"
        end
      end
      sheet.add_row patient_attributes, :height => 20
    end
  end
end
