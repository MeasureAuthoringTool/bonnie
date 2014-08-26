class Thorax.Views.MeasureDebug extends Thorax.Views.BonnieView
  template: JST['measure_debug']

  events:
    rendered: ->
      # Fill in the authenticity token
      @$("form input[name='authenticity_token']").val($("meta[name='csrf-token']").attr('content'))
      # When a tab is selected, change the population and re-calculate selected patients against population
      @$('a[data-toggle="tab"]').on 'shown.bs.tab', (e) =>
        @population = $(e.target).model()
        # Replace the existing results in-order
        for idx in [0...@results.length]
          existingResult = @results.at(idx)
          @results.remove existingResult
          @results.add @population.calculate(existingResult.patient), at: idx

  initialize: ->
    @results = new Thorax.Collection()
    @population = @model.get('populations').first()

  patientContext: (p) ->
    _(p.toJSON()).extend inMeasure: _(p.get('measure_ids')).contains @model.get('hqmf_set_id')

  togglePatient: (e) ->
    patient = $(e.target).model()
    if result = @results.findWhere(patient_id: patient.id)
      @results.remove result
    else
      @results.add @population.calculate(patient)
    $("textarea").val(Logger.logger.join("\n"))

  selectAll: ->
    @model.get('patients').each (p) => @results.add @population.calculate(p) unless @results.findWhere(patient_id: p.id)
    @$('button.toggle-patient').addClass('active')

  selectNone: ->
    @results.reset()
    @$('button.toggle-patient').removeClass('active')

  selectMeasurePatients: ->
    @selectNone()
    for p in @model.get('patients').select((p) => _(p.get('measure_ids')).contains @model.get('hqmf_set_id'))
      @results.add @population.calculate(p) unless @results.findWhere(patient_id: p.id)
      @$("button[data-model-cid='#{p.cid}']").addClass('active')
