class PatientExport

	#List of attributes we want to print to excel.
	@@attributes = ['description', '_id', 'first', 'last', 'birthdate',  'description_category',
				  'ethnicity','expired', 'gender' , 'languages', 'deathdate',
				  'notes', 'race', 'source_data_criteria','medical_record_number', 'procedures', 'encounters', 'medications',
				  'conditions', 'insurance_providers']
	#List of expected values for (Answer Key)
	@@expected_values = ['IPP', 'DENOM', 'DENEX', 'NUMER', 'NUMEX', 'DENEXCEP']


	def export_excel_file(records)
 		Axlsx::Package.new do |p|
 			p.workbook do |wb|
 				#Create styles.
 	            styles = wb.styles
 	            rotated_style = styles.add_style(:alignment => {:textRotation => 60, :horizontal => :center, :vertical => :center}, :style => Axlsx::STYLE_THIN_BORDER)
 	            text_center = styles.add_style(:alignment => {:horizontal => :center}, :b => true)
 	            
 				wb.add_worksheet(:name => "Sheet 1") do |sheet|
  					headers = @@expected_values + @@attributes

 	            	#Add top row 
		 	    	sheet.add_row ['Answer Key'], style:[text_center]
		    		sheet.merge_cells "A1:F1"
					#Creates the labels for the top row. And adds styles.
		 			sheet.add_row(headers, style:[rotated_style,rotated_style,rotated_style,rotated_style,rotated_style,rotated_style])    	
					sheet.add_row ['Expected Value'], style:[text_center]
					sheet.merge_cells "A3:F3"

					#Populates the patient data
					records.each do |patient|
		    			patient_attributes = Array.new
		    			@@expected_values.each do |value|
		    				patient_attributes.push(patient['expected_values'][0][value])
		    			end
		       			@@attributes.each do |attr_name| 
		    	    		patient_attributes.push(patient[attr_name])
		    			end
						sheet.add_row patient_attributes
		    		end
		    		sheet.column_widths 6,6,6,6,6,6,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10
  				end
  			end
  			p.serialize('test.xlsx')
  		end
 	end
end