class Thorax.Views.MeasureUploadSummary extends Thorax.Views.BonnieView
  template: JST['measure_upload_summary']
  
  
  initialize: ->
    @upload_data = undefined
    $.get('/measures/upload_summary?id='+@summaryId, @loadUpdateSummary)

  events:
    'click .patient-link': 'patientSelected'

  loadUpdateSummary: (data) =>
    @upload_data = data
    
    #Handlebars is wierd about dynamic information, so this hash contains everything needed to create the modal for N populations.
    #number_of_populations is the numer of population sets in this measure
    #thisPopulation contains all the information specific to each population within the Measure 
      #1. Info about the jQuery Knob
      #2. An array of all the patients who changed (Their name, before status, after status...etc)
      #3. General calculations about the patients in that measure (how many passed, failed...etc)
    #hqmf_set_id is pretty obvious
    #array_of_population_titles is an array containing all the names of the populations (if there was more than one population)  
    @summary_of_all_information = {number_of_populations: @upload_data.number_of_populations, thisPopulation: (0 for [1..@upload_data.number_of_populations]), hqmf_set_id: @upload_data.hqmf_set_id, array_of__population_titles: @upload_data.array_of_population_titles}

    #Loop through each Population
    for eachPopulation, index in @upload_data.array_of_populations
      @eachPatientInfo = eachPopulation   #An array of all the patients who changed (Their name, before status, after status...etc)
      @generalPatientInfo = @upload_data.array_of_patient_numbers_information[index]   #General calculations about the patients in that measure (how many passed, failed...etc)
      #All the info needed for jQuery Knob
      @jquery_knob_info = {before: {}, after: {}}
      @jquery_knob_info.before.done = true
      @jquery_knob_info.before.matching = 1
      @jquery_knob_info.before.percent = @upload_data.array_of_patient_numbers_information[index].percent_passed_before
      if (@upload_data.array_of_patient_numbers_information[index].total_patient_size == 0)
        @jquery_knob_info.before_status = 'new'
      else 
        if (@upload_data.array_of_patient_numbers_information[index].percent_passed_before == 100.00)
          @jquery_knob_info.before.status = 'pass'
        else
          @jquery_knob_info.before.status = 'fail'
          
      @jquery_knob_info.after.done = true
      @jquery_knob_info.after.matching = 1
      @jquery_knob_info.after.percent = @upload_data.array_of_patient_numbers_information[index].percent_passed_after
      if (@upload_data.array_of_patient_numbers_information[index].total_patient_size == 0)
        @jquery_knob_info.after_status = 'new'
      else 
        if (@upload_data.array_of_patient_numbers_information[index].percent_passed_after == 100.00)
          @jquery_knob_info.after.status = 'pass'
        else
          @jquery_knob_info.after.status = 'fail'    
          
      @summary_of_all_information.thisPopulation[index] = [@jquery_knob_info, @eachPatientInfo, @generalPatientInfo]
    #console.log @summary_of_all_information
    @render()
    return
  
  #Event for if the link on the modal is clicked
  patientSelected: =>  
    @trigger "patient:selected"
    
    
