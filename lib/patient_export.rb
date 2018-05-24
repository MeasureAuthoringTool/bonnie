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
  def self.export_excel_cql_file(calc_results, patient_details, population_details, statement_details)
    Axlsx::Package.new do |package|
      package.workbook do |workbook|
        # Define styles
        fg_color = "000033"
        header_border = { :style => :thick, :color => "000066", :edges => [:bottom] }
        styles = workbook.styles
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
                                                  :color =>"DDDDDD",
                                                  :edges => [:bottom] },
                                     :fg_color => "FF0000",
                                     :alignment => { :wrap_text => true })
        pop_index = 0
        
        if calc_results.length == 0
          error_row = ["Measure has no patients, please re-export with patients"]
          workbook.add_worksheet(name: "Error") do |sheet|
            sheet.add_row(error_row)
          end
        end
        
        #calc_results is organized popKey->patientKey->results
        #popKey and patientKey can be used to lookup population and patient details in their respective maps
        calc_results.each do |pop_key, patients|
          
          population_criteria = HQMF::PopulationCriteria::ALL_POPULATION_CODES & population_details[pop_key]["criteria"]

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
                  header_row.push(statement_details[lib_key][statement])
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
              population_criteria.each do |criteria|
                expected.push(patient_details[patient_key]["expected_values"][pop_index][criteria])
                if criteria == "OBSERV"
                  observ_expected = patient_details[patient_key]["expected_values"][pop_index][criteria]
                  observ_actual = calc_results[pop_key][patient_key]['criteria']['values']
                  if observ_expected.nil? && observ_actual == []
                    actual.push(nil)
                  else
                    actual.push(observ_actual)
                  end
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
                      statement_results[statement_to_column[statement]] = result
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
          end
          pop_index = pop_index + 1
        end
      end
    end
  end

  def self.add_formatted_patient_field(patient, value)
    if value == 'ethnicity'
      return Record::ETHNICITY_NAME_MAP[patient[value]]
    elsif value == 'race'
      return Record::RACE_NAME_MAP[patient[value]]
    elsif value == 'birthdate' || value == 'deathdate'
      time = Time.at(patient[value]).strftime("%m/%d/%Y") unless patient[value].nil?
      return time
    elsif value == 'expired' && patient[value] == nil
      return false
    else
      return patient[value]
    end
  end
end
