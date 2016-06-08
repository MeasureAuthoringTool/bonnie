class Thorax.Views.PatientBuilderCompare extends Thorax.Views.BonnieView
  className: 'patient-compare'

  template: JST['patient_builder/patient_version_compare']

  options:
    serialize: { children: false }
    populate: { context: true, children: false }

  initialize: ->
    @populationLogicViewAfter = new Thorax.Views.BuilderPopulationLogic
    @populationLogicViewAfter.setPopulation @measure.get('displayedPopulation')
    @populationLogicViewAfter.showRationale @model
    
    @populationLogicViewBefore = new Thorax.Views.BuilderPopulationLogic
    @populationLogicViewBefore.setPopulation @measure.get('displayedPopulation')
    @populationLogicViewBefore.showRationale @model

