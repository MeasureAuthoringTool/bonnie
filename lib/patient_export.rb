# Generates a formatted Excel document of Patients for the given measure and records. 
class PatientExport

  # List of attributes we want to print to excel
  DISPLAYED_ATTRIBUTES = ['notes', 'last', 'first', 'birthdate', 'expired', 'deathdate', 'ethnicity', 'race', 'gender']


  # Given a number, calculate the textual column name in excel (ie 1 -> A, 27 -> AA)
  def self.excel_column(number)
    return "" if number < 1
    result = 'A'
    (number - 1).times { result.next! }
    result
  end

  # calc_results is a map of population/stratifications -> patients -> definitions -> results
  def self.export_excel_cql_file(calc_results, patient_details, population_details, statement_details, measure_hqmf_set_id)
    Axlsx::Package.new do |package|
      package.workbook do |workbook|        
        styles = workbook.styles

        ## ADD AN ERROR SHEET SHEET IF THERE ARE NO RESULTS
        if calc_results.length == 0
          error_row = ["Measure has no patients, please re-export with patients"]
          workbook.add_worksheet(name: "Error") do |sheet|
            sheet.add_row(error_row)
          end
          next # in case of no results, we can skip adding the key
        end


        ## ADD THE KEY SHEET TO THE BEGINNING OF THE DOCUMENT
        workbook.add_worksheet(name: "KEY") do |sheet|
          key_style = styles.add_style(:sz => 14, 
                                       :alignment => { :vertical => :center, :wrap_text => true })
          key_title_style = styles.add_style(:b => true,
                                             :sz => 20,
                                             :alignment => { :horizontal => :center, :vertical => :center},
                                             :border => { :style => :thin, :color => "DDDDDD", :edges => [:right] })
          false_info_style = styles.add_style(:alignment => { :vertical => :center, :wrap_text => true },
                                              :sz => 14,
                                              :border => { :style => :thin, :color => "DDDDDD", :edges => [:right] })
          cql_data_type_table_header = styles.add_style(:b => true,
                                                        :alignment => { :horizontal => :center },
                                                        :sz => 16,
                                                        :border => { :style => :thin, :color => "333333", :edges => [:bottom] })

          white_right_border = styles.add_style(:border => { :style => :thin,:color => "FFFFFF", :edges => [:left, :right] })

          sheet.add_row(["\nKEY\n","",""], style: key_title_style, height: 55)
          sheet.add_row(["NOTE: FALSE(...) indicates a false value. The type of falseness is specified in the parentheses.\nFor example, FALSE([]) indicates falseness due to an empty list.\nCells that are too long will be truncated due to limitations in Excel.","",""], 
                        style: false_info_style, height: 70)
          sheet.merge_cells("A1:C1") 
          sheet.merge_cells("A2:C2")

          sheet.add_row(["",""], style: white_right_border, height: 25)

          sheet.add_row(["CQL Data Type Formatting","",""], style: cql_data_type_table_header) #add title row
          sheet.merge_cells("A4:C4")

          cql_types_table=[
            ["CQL Type","Format","Example"],
  
            ["DateTime","MM/DD/YYYY h:mm AM/PM or MM/DD/YYYY","11/20/2012 8:00 AM"],
            ["Interval","INTERVAL: start value - end value","INTERVAL: 11/20/2010 - 11/20/2012 or INTERVAL: 1 - 4"],
            ["Code","CODE: system code","CODE: SNOMED-CT 8715000"],
            ["Quantity","QUANTITY: value unit","QUANTITY: 120 mm[Hg]"],
            ["QDM Data Criteria","QDM Datatype: Value Set\nSTART: MM/DD/YYYY h:mm AM/PM\nSTOP: MM/DD/YYYY h:mm AM/PM\nCODE: system code\n* STOP entry is optional\n* only the first code on the data criteria is shown","Medication, Order: Opioid Medications\nSTART: 01/01/2012 8:00 AM\nCODE: RxNorm 1053647"],
            ["List","[item one,\nitem two,\n...]","[Encounter, Performed: Emergency Department Visit\nSTART: 06/10/2012 5:00 AM\nSTOP: 06/10/2012 5:25 AM\nCODE: SNOMED-CT 4525004,\nEncounter, Performed: Emergency Department Visit\nSTART: 06/10/2012 9:00 AM\nSTOP: 06/10/2012 9:15 AM\nCODE: SNOMED-CT 4525004]"],
            ["Tuple","{\n  key1: value1,\n  key2: value2,\n  ...\n}","{\n  period: Interval: 06/29/2012 8:00 AM - 12/31/2012 11:59 PM,\n  meds: [Medication, Order: Opioid Medications\n        START: 06/29/2012 8:00 AM\n        CODE: RxNorm 996994],\n  cmd: 185\n}"]
          ]
          sheet.add_row(cql_types_table[0], :b => true, :sz => 14) #table headers
          cql_types_table[1..-1].each do |entry_row| #add content rows
            sheet.add_row(entry_row, style: key_style)
          end
        end
        
        ## ADD THE RESULTS SHEETS
        #calc_results is organized popKey->patientKey->results
        #popKey and patientKey can be used to lookup population and patient details in their respective maps
        # Define styles
        fg_color = "000033"
        header_border = { :style => :thick, :color => "000066", :edges => [:bottom] }
        default = styles.add_style(:sz => 14,
                                   :bg_color => "FFFFFFF",
                                   :border => { :style => :thin,
                                                :color => "DDDDDD",
                                                :edges => [:bottom] },
                                   :alignment => { :wrap_text => true })
        rotated_style = styles.add_style(:b => true,
                                         :sz => 12,
                                         :alignment => { :textRotation => 90 },
                                         :border => header_border,
                                         :fg_color => fg_color,
                                         :bg_color => "FFFFFFF")
        text_center = styles.add_style(:b => true,
                                       :sz => 14,
                                       :bg_color => "FFFFFFF",
                                       :alignment => { :horizontal => :center, :vertical => :center})
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
                                                  :color => "DDDDDD",
                                                  :edges => [:bottom] },
                                     :fg_color => "FF0000",
                                     :alignment => { :wrap_text => true })
        maximum_column_width = 75
        pop_index = 0
        calc_results.each do |pop_key, patients|
          
          population_criteria = CQM::Measure::ALL_POPULATION_CODES & population_details[pop_key]["criteria"]

          # Set worksheet titles based on population title length. If population title is more than 31 characters, use "Population [index]"
          worksheet_title = if population_details[pop_key]['title'].blank? || "#{pop_index + 1} - #{population_details[pop_key]['title']}".length > 31
                              "Population #{pop_index + 1}"
                            else
                              "#{pop_index + 1} - #{population_details[pop_key]['title']}"
                            end

          workbook.add_worksheet(name: worksheet_title) do |sheet|
            

            statement_to_column = {}
            header_row = population_criteria * 2 + DISPLAYED_ATTRIBUTES
            
            cur_column = 0
            population_details[pop_key]["statement_relevance"].each do |lib_key, statements|
              statements.each do |statement, relevance|
                if (relevance != "NA")
                  # Composite measures will have some statement results from the components, but
                  # the measure won't have statement details (excel headers) for them. 
                  # Fortunately we want to ignore those results, so we can just skip results that
                  # dont have corresponding details from the measure.
                  next if statement_details.dig(lib_key,statement).nil?
                  header_row.push(truncate_result(statement_details[lib_key][statement]))
                  statement_to_column[statement] = cur_column
                  cur_column = cur_column + 1
                end
              end
            end

            toplevel_headings = Array.new(header_row.length, nil)
            toplevel_headings[0] = "Expected"
            toplevel_headings[population_criteria.length] = "Actual"
            sheet.merge_cells "A1:#{excel_column(population_criteria.length)}1"
            sheet.merge_cells "#{excel_column(population_criteria.length+1)}1:#{excel_column(population_criteria.length * 2)}1"
            sheet.add_row(toplevel_headings, style: text_center, height: 30)

            
            header_column_styles = Array.new(header_row.length+1, header_dc)

            pop_cols_index_start = 0
            pop_cols_index_end = population_criteria.length * 2
            patient_cols_index_start = population_criteria.length * 2
            patient_cols_index_end = population_criteria.length * 2 + DISPLAYED_ATTRIBUTES.length - 1

            header_column_styles[pop_cols_index_start..pop_cols_index_end] = Array.new(population_criteria.length * 2, rotated_style) # Rotated style for population columns            
            header_column_styles[patient_cols_index_start..patient_cols_index_end] = Array.new(DISPLAYED_ATTRIBUTES.length, header)

            sheet.add_row(header_row, style: header_column_styles)

            column_widths = Array.new(header_row.length+1, 25)
            #Narrow columns for population results
            column_widths[pop_cols_index_start..pop_cols_index_end] = Array.new(population_criteria.length * 2, 6)
            #Wider columns for patient details
            column_widths[patient_cols_index_start..patient_cols_index_end] = Array.new(DISPLAYED_ATTRIBUTES.length, 16)

            sheet.column_widths *column_widths

            patients.each do |patient_key, patient|
              patient_data = []
              DISPLAYED_ATTRIBUTES.each do |field|
                patient_data.push(add_formatted_patient_field(patient_details[patient_key], field))
              end
              expected = []
              actual = []
              patient_expected_vals = patient_details[patient_key]["expected_values"].detect { |ev| ev["measure_id"]==measure_hqmf_set_id && ev["population_index"]==pop_index }
              population_criteria.each do |criteria|
                expected.push(patient_expected_vals[criteria])
                if criteria == "OBSERV"
                  actual.push(calc_results[pop_key][patient_key]['criteria']['observation_values'])
                else
                  actual.push(calc_results[pop_key][patient_key]["criteria"][criteria])
                end
              end

              statement_results = Array.new(statement_to_column.length, nil)
              patient["statement_results"].each do |lib, statements|
                statements.each do |statement, result|
                  if !statement_to_column[statement].nil?
                    if result.eql? "UNHIT"
                      statement_results[statement_to_column[statement]] = "Not Calculated"
                    else
                      statement_results[statement_to_column[statement]] = truncate_result(result)
                    end
                  end
                end
              end
              
              patient_row = expected + actual + patient_data + statement_results
              row_style = []
              if expected != actual
                row_style = Array.new(patient_row.length + 1, needs_fix)
              else
                row_style = Array.new(patient_row.length + 1, default)
              end

              sheet.add_row(patient_row, style: row_style)
            end
            # Enforce a maximum column width. Note this should be be done after all the cells have been added.
            sheet.column_info.each do |col|
              col.width = maximum_column_width if col.width > maximum_column_width
            end
          end
          pop_index = pop_index + 1
        end
      end
    end
  end

  # excel has a maximum character restriction on cells of 32,767 characters
  def self.truncate_result(result)
    if result.length >= 32700
      result[0...32700] + " <Entry Truncated To Fit Cell>"
    else
      result
    end
  end

  def self.add_formatted_patient_field(patient, value)
    if value == 'ethnicity'
      return CQM::Patient::ETHNICITY_NAME_MAP[patient[value]]
    elsif value == 'race'
      return CQM::Patient::RACE_NAME_MAP[patient[value]]
    elsif value == 'expired' && patient[value] == nil
      return false
    else
      return patient[value]
    end
  end
end
