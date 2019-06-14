describe 'CQL', ->
  beforeAll ->
    bonnie.measures = new Thorax.Collections.Measures()
    jasmine.getJSONFixtures().clearCache()
    @measure = loadMeasureWithValueSets 'cqm_measure_data/special_measures/CMS10/CMS10v0.json', 'cqm_measure_data/special_measures/CMS10/value_sets.json'
    bonnie.measures.add @measure
    testDenexcepPass = getJSONFixture('patients/CMS10v0/Test_DenexcepPass.json')
    testIppPass = getJSONFixture('patients/CMS10v0/Test_IppPass.json')
    @patient1 = new Thorax.Models.Patient testDenexcepPass, parse: true
    @patient2 = new Thorax.Models.Patient testIppPass, parse: true

  describe 'Coverage', ->
    describe 'first patient has correct', ->
      beforeAll ->
        @measure.get('patients').add @patient1
        @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
        @measureView = @measureLayoutView.showMeasure()
        @cqlMeasurePopulationLogic = @measureView.logicView

      it 'inital population', ->
        initialPopulation = $(@cqlMeasurePopulationLogic.$(".cql-statement")[0])
        expect(initialPopulation.find(".clause-covered").length).toBe(5)
        expect(initialPopulation.find(".clause-uncovered").length).toBe(0)

      it 'denominator', ->
        denominator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[1])
        expect(denominator.find(".clause-covered").length).toBe(2)
        expect(denominator.find(".clause-uncovered").length).toBe(0)

      it 'numerator', ->
        numerator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[2])
        expect(numerator.find(".clause-covered").length).toBe(0)
        expect(numerator.find(".clause-uncovered").length).toBe(2)

      it 'denominator exception', ->
        denomException = $(@cqlMeasurePopulationLogic.$(".cql-statement")[3])
        expect(denomException.find(".clause-covered").length).toBe(2)
        expect(denomException.find(".clause-uncovered").length).toBe(0)

      it 'define "In Demographic"', ->
        inDemographic = $(@cqlMeasurePopulationLogic.$(".cql-statement")[4])
        expect(inDemographic.find(".clause-covered").length).toBe(5)
        expect(inDemographic.find(".clause-uncovered").length).toBe(0)

      it 'define "Encounter"', ->
        encounter = $(@cqlMeasurePopulationLogic.$(".cql-statement")[5])
        expect(encounter.find(".clause-covered").length).toBe(2)
        expect(encounter.find(".clause-uncovered").length).toBe(0)

      it 'define "Encounters during MP"', ->
        encountersDuringMP = $(@cqlMeasurePopulationLogic.$(".cql-statement")[6])
        expect(encountersDuringMP.find(".clause-covered").length).toBe(10)
        expect(encountersDuringMP.find(".clause-uncovered").length).toBe(0)

      it 'define "Medications Documented"', ->
        medicationsDocumented = $(@cqlMeasurePopulationLogic.$(".cql-statement")[7])
        expect(medicationsDocumented.find(".clause-covered").length).toBe(0)
        expect(medicationsDocumented.find(".clause-uncovered").length).toBe(15)

      it 'define "meds not documented for medical reason"', ->
        MedsNotDocumented = $(@cqlMeasurePopulationLogic.$(".cql-statement")[8])
        expect(MedsNotDocumented.find(".clause-covered").length).toBe(11)
        expect(MedsNotDocumented.find(".clause-uncovered").length).toBe(0)

    describe 'both patients have correct', ->
      beforeAll ->
        @measure.get('patients').add @patient1
        @measure.get('patients').add @patient2
        @population = @measure.get('populations').first()
        @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
        @measureView = @measureLayoutView.showMeasure()
        @cqlMeasurePopulationLogic = @measureView.logicView

      it 'inital population', ->
        initialPopulation = $(@cqlMeasurePopulationLogic.$(".cql-statement")[0])
        expect(initialPopulation.find(".clause-covered").length).toBe(5)
        expect(initialPopulation.find(".clause-uncovered").length).toBe(0)

      it 'denominator', ->
        denominator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[1])
        expect(denominator.find(".clause-covered").length).toBe(2)
        expect(denominator.find(".clause-uncovered").length).toBe(0)

      it 'numerator', ->
        numerator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[2])
        expect(numerator.find(".clause-covered").length).toBe(0)
        expect(numerator.find(".clause-uncovered").length).toBe(2)

      it 'denominator exception', ->
        denomException = $(@cqlMeasurePopulationLogic.$(".cql-statement")[3])
        expect(denomException.find(".clause-covered").length).toBe(2)
        expect(denomException.find(".clause-uncovered").length).toBe(0)

      it 'define "In Demographic"', ->
        inDemographic = $(@cqlMeasurePopulationLogic.$(".cql-statement")[4])
        expect(inDemographic.find(".clause-covered").length).toBe(5)
        expect(inDemographic.find(".clause-uncovered").length).toBe(0)

      it 'define "Encounter"', ->
        encounter = $(@cqlMeasurePopulationLogic.$(".cql-statement")[5])
        expect(encounter.find(".clause-covered").length).toBe(2)
        expect(encounter.find(".clause-uncovered").length).toBe(0)

      it 'define "Encounters during MP"', ->
        encountersDuringMP = $(@cqlMeasurePopulationLogic.$(".cql-statement")[6])
        expect(encountersDuringMP.find(".clause-covered").length).toBe(10)
        expect(encountersDuringMP.find(".clause-uncovered").length).toBe(0)

      it 'define "Medications Documented"', ->
        medicationsDocumented = $(@cqlMeasurePopulationLogic.$(".cql-statement")[7])
        expect(medicationsDocumented.find(".clause-covered").length).toBe(0)
        expect(medicationsDocumented.find(".clause-uncovered").length).toBe(15)

      it 'define "meds not documented for medical reason"', ->
        MedsNotDocumented = $(@cqlMeasurePopulationLogic.$(".cql-statement")[8])
        expect(MedsNotDocumented.find(".clause-covered").length).toBe(11)
        expect(MedsNotDocumented.find(".clause-uncovered").length).toBe(0)

  describe 'Coloring', ->
    describe 'first patient has correct', ->
      beforeAll ->
        @measure.get('patients').add @patient1
        @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient1, measure: @measure)
        @patientBuilder.render()

      it 'inital population', ->
        initialPopulation = $(@patientBuilder.$(".cql-statement")[0])
        expect(initialPopulation.find(".clause-true").length).toBe(5)
        expect(initialPopulation.find(".clause-false").length).toBe(0)

      it 'denominator', ->
        denominator = $(@patientBuilder.$(".cql-statement")[1])
        expect(denominator.find(".clause-true").length).toBe(2)
        expect(denominator.find(".clause-false").length).toBe(0)

      it 'numerator', ->
        numerator = $(@patientBuilder.$(".cql-statement")[2])
        expect(numerator.find(".clause-true").length).toBe(0)
        expect(numerator.find(".clause-false").length).toBe(2)

      it 'denominator exception', ->
        denomException = $(@patientBuilder.$(".cql-statement")[3])
        expect(denomException.find(".clause-true").length).toBe(2)
        expect(denomException.find(".clause-false").length).toBe(0)

      it 'define "In Demographic"', ->
        inDemographic = $(@patientBuilder.$(".cql-statement")[4])
        expect(inDemographic.find(".clause-true").length).toBe(5)
        expect(inDemographic.find(".clause-false").length).toBe(0)

      it 'define "Encounter"', ->
        encounter = $(@patientBuilder.$(".cql-statement")[5])
        expect(encounter.find(".clause-true").length).toBe(2)
        expect(encounter.find(".clause-false").length).toBe(0)

      it 'define "Encounters during MP"', ->
        encountersDuringMP = $(@patientBuilder.$(".cql-statement")[6])
        expect(encountersDuringMP.find(".clause-true").length).toBe(10)
        expect(encountersDuringMP.find(".clause-false").length).toBe(0)

      it 'define "Medications Documented"', ->
        medicationsDocumented = $(@patientBuilder.$(".cql-statement")[7])
        expect(medicationsDocumented.find(".clause-true").length).toBe(0)
        expect(medicationsDocumented.find(".clause-false").length).toBe(15)

      it 'define "meds not documented for medical reason"', ->
        MedsNotDocumented = $(@patientBuilder.$(".cql-statement")[8])
        expect(MedsNotDocumented.find(".clause-true").length).toBe(11)
        expect(MedsNotDocumented.find(".clause-false").length).toBe(0)

    describe 'second patient has correct', ->
      beforeAll ->
        @measure.get('patients').add @patient2
        @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient2, measure: @measure)
        @patientBuilder.render()

      it 'inital population', ->
        initialPopulation = $(@patientBuilder.$(".cql-statement")[0])
        expect(initialPopulation.find(".clause-true").length).toBe(5)
        expect(initialPopulation.find(".clause-uncofalsevered").length).toBe(0)

      it 'denominator', ->
        denominator = $(@patientBuilder.$(".cql-statement")[1])
        expect(denominator.find(".clause-true").length).toBe(2)
        expect(denominator.find(".clause-false").length).toBe(0)

      it 'numerator', ->
        numerator = $(@patientBuilder.$(".cql-statement")[2])
        expect(numerator.find(".clause-true").length).toBe(0)
        expect(numerator.find(".clause-false").length).toBe(2)

      it 'denominator exception', ->
        denomException = $(@patientBuilder.$(".cql-statement")[3])
        expect(denomException.find(".clause-true").length).toBe(0)
        expect(denomException.find(".clause-false").length).toBe(2)

      it 'define "In Demographic"', ->
        inDemographic = $(@patientBuilder.$(".cql-statement")[4])
        expect(inDemographic.find(".clause-true").length).toBe(5)
        expect(inDemographic.find(".clause-false").length).toBe(0)

      it 'define "Encounter"', ->
        encounter = $(@patientBuilder.$(".cql-statement")[5])
        expect(encounter.find(".clause-true").length).toBe(2)
        expect(encounter.find(".clause-false").length).toBe(0)

      it 'define "Encounters during MP"', ->
        encountersDuringMP = $(@patientBuilder.$(".cql-statement")[6])
        expect(encountersDuringMP.find(".clause-true").length).toBe(10)
        expect(encountersDuringMP.find(".clause-false").length).toBe(0)

      it 'define "Medications Documented"', ->
        medicationsDocumented = $(@patientBuilder.$(".cql-statement")[7])
        expect(medicationsDocumented.find(".clause-true").length).toBe(0)
        expect(medicationsDocumented.find(".clause-false").length).toBe(15)

      it 'define "meds not documented for medical reason"', ->
        MedsNotDocumented = $(@patientBuilder.$(".cql-statement")[8])
        expect(MedsNotDocumented.find(".clause-true").length).toBe(0)
        expect(MedsNotDocumented.find(".clause-false").length).toBe(11)
