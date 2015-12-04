class PatientExport

	#List of attributes we want to print to excel.
	#@@attributes = ['description', '_id', 'first', 'last', 'birthdate',  'description_category',
	#			  'ethnicity','expired', 'gender' , 'languages', 'deathdate',
	#			  'notes', 'race', 'source_data_criteria','medical_record_number', 'procedures', 'encounters', 'medications',
	#			  'conditions', 'insurance_providers']
	@@attributes = ['description', '_id', 'first', 'last', 'birthdate',
				  'ethnicity','expired', 'gender' , 'languages', 'deathdate',
				  'notes', 'race', 'source_data_criteria']			  
	#List of expected values for (Answer Key)
	@@expected_values = ['IPP', 'DENOM', 'DENEX', 'NUMER', 'NUMEX', 'DENEXCEP']
	#Keys for data_criteria_headers.
	@@data_criteria_keys = Array.new()


	def export_excel_file(measure, records)
 		Axlsx::Package.new do |p|
 			p.workbook do |wb|
 				#Create styles.
 	            styles = wb.styles
 	            rotated_style = styles.add_style(:alignment => {:textRotation => 60, :horizontal => :center, :vertical => :center}, :style => Axlsx::STYLE_THIN_BORDER)
 	            text_center = styles.add_style(:alignment => {:horizontal => :center}, :b => true)
 	            
 				wb.add_worksheet(:name => "Sheet 1") do |sheet|
     				#Generate a list of all the headers we want.
     				headers = @@expected_values + @@attributes + generate_data_criteria_headers(measure)

 	            	#Add top row 
		 	    	sheet.add_row ['Answer Key'], style:[text_center]
		    		sheet.merge_cells "A1:F1"
					#Creates the labels for the top row. And adds styles.
		 			sheet.add_row(headers, style:[rotated_style,rotated_style,rotated_style,rotated_style,rotated_style,rotated_style])    	
					sheet.add_row ['Expected Value'], style:[text_center]
					sheet.merge_cells "A3:F3"

        			#Writes one row per record
 				    generate_rows(sheet, records, measure)
 				    
		    		sheet.column_widths 6,6,6,6,6,6,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
  				end
  			end
  			p.serialize('test.xlsx')
  		end
 	end

 	def generate_data_criteria_headers(measure)
 		logic_extractor = HQMF::Measure::LogicExtractor.new()
	    logic_extractor.population_logic(measure)
        data_criteria_headers = Array.new()

        measure.data_criteria.each do |key, value|
        	data_criteria_headers.push(logic_extractor.data_criteria_logic(key).map(&:strip).join(' '))
        	@@data_criteria_keys.push(key)
        end
        data_criteria_headers
  	end

 	def generate_rows(sheet, records, measure)
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
		    	else
		    		patient_attributes.push(patient[value])
		    	end
		    end

		    #Generate the calculated rationale for each patient against the measure.
		    unless setup_exception
      	    begin
      		  result = calculator.calculate(patient)

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
		    sheet.add_row patient_attributes
		end
 	end
end