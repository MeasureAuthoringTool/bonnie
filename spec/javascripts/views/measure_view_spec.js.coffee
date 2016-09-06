describe 'MeasureView', ->

  beforeEach ->
    @measure = bonnie.measures.findWhere(cms_id: 'CMS156v2')

    # Add some overlapping codes to the value sets to exercise the overlapping value sets feature
    # We add the overlapping codes after 10 non-overlapping codes to provide regression for a bug
    @vs1 = @measure.valueSets().findWhere(display_name: 'Annual Wellness Visit')
    @vs2 = @measure.valueSets().findWhere(display_name: 'Office Visit')
    for n in [1..10]
      @vs1.get('concepts').push { code: "ABC#{n}", display_name: "ABC", code_system_name: "ABC" }
      @vs2.get('concepts').push { code: "XYZ#{n}", display_name: "XYZ", code_system_name: "XYZ" }
    @vs1.get('concepts').push { code: "OVERLAP", display_name: "OVERLAP", code_system_name: "OVERLAP" }
    @vs2.get('concepts').push { code: "OVERLAP", display_name: "OVERLAP", code_system_name: "OVERLAP" }
    # Clear the fixtures cache so that getJSONFixture does not return stale/modified fixtures
    jasmine.getJSONFixtures().clearCache()
    @patient = new Thorax.Models.Patient getJSONFixture('patients.json')[0], parse: true
    @measure.get('patients').add @patient
    @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
    @measureView = @measureLayoutView.showMeasure()
    @measureView.appendTo 'body'

  afterEach ->
    # Remove the 11 extra codes that were added for value set overlap testing
    @vs1.get('concepts').splice(-11, 11)
    @vs2.get('concepts').splice(-11, 11)
    @measureView.remove()

  it 'renders measure details', ->
    expect(@measureView.$el).toContainText @measure.get('title')
    expect(@measureLayoutView.$el).toContainText @measure.get('cms_id')
    expect(@measureView.$el).toContainText @measure.get('description')

  it 'renders measure populations', ->
    expect(@measureView.$('[data-toggle="tab"]')).toExist()
    expect(@measureView.$('.rationale-target')).toBeVisible()
    expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).not.toHaveClass('collapsed')
    @measureView.$('[data-toggle="collapse"]').not('.value_sets').click()
    expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).toHaveClass('collapsed')
    @measureView.$('[data-toggle="tab"]').not('.value_sets').last().click()
    expect(@measureView.$('[data-toggle="collapse"]').not('.value_sets')).not.toHaveClass('collapsed')


  it 'renders value sets and codes', ->
    expect(@measureView.$('.value_sets')).toExist()
    expect(@measureView.$('.value_sets')).toBeVisible()

    expect(@measureView.$('#data_criteria')).toExist()
    expect(@measureView.$('#data_criteria')).toBeVisible()
    expect(@measureView.$('#data_criteria').find('[data-toggle="collapse"].value_sets')).toExist()
    expect(@measureView.$('#data_criteria').find('.row.collapse')).toExist()
    # should only show 10 code results at a time
    longTables = @measureView.$('#data_criteria').find('tbody').filter ->
      return $(@).children('tr').length > 10
    expect(longTables).not.toExist()

    expect(@measureView.$('#supplemental_criteria')).toExist()
    expect(@measureView.$('#supplemental_criteria')).toBeVisible()
    expect(@measureView.$('#supplemental_criteria').find('[data-toggle="collapse"].value_sets')).toExist()
    expect(@measureView.$('#supplemental_criteria').find('.row.collapse')).toExist()

    expect(@measureView.$('#overlapping_value_sets')).toBeVisible()
    expect(@measureView.$('#overlapping_value_sets').find('[data-toggle="collapse"].value_sets')).toExist()
    expect(@measureView.$('#overlapping_value_sets').find('.row.collapse')).toExist()
    expect(@measureView.$('#overlapping_value_sets')).toContainText 'OVERLAP'

    expect(@measureView.$('[data-toggle="collapse"].value_sets')).toHaveClass('collapsed')
    @measureView.$('[data-toggle="collapse"].value_sets').click()
    expect(@measureView.$('[data-toggle="collapse"].value_sets')).not.toHaveClass('collapsed')

  it 'renders patient results', ->
    expect(@measureView.$('.patient')).toExist()
    expect(@measureView.$('.toggle-result')).not.toBeVisible()
    expect(@measureView.$('.btn-show-coverage')).not.toBeVisible()
    @measureView.$('[data-call-method="expandResult"]').click()
    expect(@measureView.$('.toggle-result')).toBeVisible()
    expect(@measureView.$('.btn-show-coverage')).toBeVisible()

  # makes sure the calculation percentage hasn't changed.
  # should be 33% for CMS156v2 with given test patients as of 1/4/2016
  it 'computes coverage', ->
    expect(@measureView.$('.dial')).toHaveAttr('value', '33')
