describe 'MeasureImportView', ->
  beforeEach ->
    @measures = bonnie.measures
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')
    @measuresView = new Thorax.Views.Measures(collection: @measures)
    @measuresView.render()
    @measuresView.appendTo 'body'

  afterEach ->
    @measuresView.remove()
    $('.modal-backdrop').remove()

  describe 'handles measure import', ->
    beforeEach ->
      @measuresView.$('button[data-call-method="importMeasure"]').click()

    it 'renders dialog', ->
      $dialog = @measuresView.$('#importMeasureDialog')
      expect($dialog).toExist
      expect($dialog.find('.control-label:contains("Measure Data")').next().find('input').length).toEqual(1)
      expect($dialog.find('.control-label:contains("Type")').next().find('input').length).toBe(2)
      expect($dialog.find('.control-label:contains("Calculation")').next().find('input').length).toEqual(2)
      expect($dialog.find('#loadButton')).toBeDisabled()

  describe 'handles measure updating', ->
    beforeEach ->
      @measuresView.$('button[data-call-method="updateMeasure"]').first().click()

    it 'renders dialog', ->
      $dialog = @measuresView.$('#importMeasureDialog')
      expect($dialog).toExist
      expect($dialog.find('.control-label:contains("Measure Data")').next().find('input').length).toEqual(1)
      expect($dialog.find('.control-label:contains("Type")').next().find('input').length).toBe(2)
      expect($dialog.find('.control-label:contains("Calculation")').next().find('input').length).toEqual(2)
      expect($dialog.find('#loadButton')).not.toBeDisabled()

    it 'pre-populates selections', ->
      $dialog = @measuresView.$('#importMeasureDialog')
      typeVal = $dialog.find('.control-label:contains("Type")').next().find('input:checked').val()
      calcVal = $dialog.find('.control-label:contains("Calculation")').next().find('input:checked').val()

      expect(typeVal).toBe @measure.get('type')
      
      if @measure.get('episode_of_care') is false and @measure.get('continuous_variable') is false
        expect(calcVal).toBe 'patient'
      else if @measure.get('episode_of_care') is false
        expect(calcVal).toBe 'episode'
