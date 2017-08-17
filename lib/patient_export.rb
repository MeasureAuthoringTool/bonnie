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

  # calc_results is a map of population/stratifications -> patients -> definitions -> results
  def self.export_excel_cql_file(calc_results, patient_details, population_details, measure_details, statement_details)
    Axlsx::Package.new do |package|
      package.workbook do |workbook|
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
                                     
        pop_index = 0
        calc_results.each do |pop_key, patients|
          
          population_criteria = HQMF::PopulationCriteria::ALL_POPULATION_CODES & population_details[pop_key]["criteria"]

          worksheet_title = population_details[pop_key]["title"]
          workbook.add_worksheet(name: worksheet_title) do |sheet|

            toplevel_headings = Array.new(DISPLAYED_ATTRIBUTES.length + population_criteria.length*2)
            toplevel_headings[DISPLAYED_ATTRIBUTES.length] = "Expected"
            toplevel_headings[DISPLAYED_ATTRIBUTES.length + population_criteria.length] = "Actual"

            sheet.add_row(toplevel_headings, style: text_center, height: 30)

            statement_to_column = {}
            header_row = DISPLAYED_ATTRIBUTES + population_criteria*2
            
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

            sheet.add_row(header_row, style: text_center, height: 30)
            
            patients.each do |patient_key, patient|
              patient_data = []
              DISPLAYED_ATTRIBUTES.each do |field|
                patient_data.push(add_formatted_patient_field(patient_details[patient_key], field))
              end
              expected = []
              actual = []
              population_criteria.each do |criteria|
                expected.push(patient_details[patient_key]["expected_values"][pop_index][criteria])
                actual.push(calc_results[pop_key][patient_key]["criteria"][criteria])
              end

              statement_results = Array.new(statement_to_column.length, nil)
              patient["statement_results"].each do |lib, statements|
                statements.each do |statement, result|
                  if (!statement_to_column[statement].nil?)
                    if (result.eql? "UNHIT")
                      statement_results[statement_to_column[statement]] = "Not Calculated"
                    else
                      statement_results[statement_to_column[statement]] = result
                    end
                  end
                end
              end
              patient_row = patient_data + expected + actual + statement_results
              sheet.add_row(patient_row, height: 24)
            end
          end
        end
        pop_index = pop_index + 1
      end
    end
  end

  def self.add_formatted_patient_field(patient, value)
    if value == 'ethnicity'
      return patient[value]['name']
    elsif value == 'race'
      return patient[value]['name']
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
