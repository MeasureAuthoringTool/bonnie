describe 'CQL', ->
  beforeEach ->
    bonnie.measures = new Thorax.Collections.Measures()
    jasmine.getJSONFixtures().clearCache()
    @measure = loadFhirMeasure('fhir_measures/CMS124/CMS124.json')
    bonnie.measures.add @measure
    testDenexcepPass = getJSONFixture('fhir_patients/CMS124/patient-DenExclPass-HospiceOrderDuringMP.json')
    testDenomPass = getJSONFixture('fhir_patients/CMS124/patient-denom-EXM124.json')
    @patient1 = new Thorax.Models.Patient testDenexcepPass, parse: true
    @patient2 = new Thorax.Models.Patient testDenomPass, parse: true

  describe 'Coverage', ->
    describe 'first patient has correct', ->
      beforeEach ->
        @measure.get('patients').add @patient1
        @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
        @measureView = @measureLayoutView.showMeasure()
        @cqlMeasurePopulationLogic = @measureView.logicView

      it 'initial population', ->
        initialPopulation = $(@cqlMeasurePopulationLogic.$(".cql-statement")[0])
        expect(initialPopulation.find('[data-define-name]').text()).toContain("define \"Initial Population\"")
        expect(initialPopulation.find(".clause-covered").length).toBe(27)
        expect(initialPopulation.find(".clause-uncovered").length).toBe(1)

      it 'denominator', ->
        denominator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[1])
        expect(denominator.find('[data-define-name]').text()).toContain("define \"Denominator\"")
        expect(denominator.find(".clause-covered").length).toBe(2)
        expect(denominator.find(".clause-uncovered").length).toBe(0)

      it 'denominator exception', ->
        denomException = $(@cqlMeasurePopulationLogic.$(".cql-statement")[2])
        expect(denomException.find('[data-define-name]').text()).toContain("define \"Denominator Exclusion\"")
        expect(denomException.find(".clause-covered").length).toBe(5)
        expect(denomException.find(".clause-uncovered").length).toBe(2)

      it 'numerator', ->
        numerator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[3])
        expect(numerator.find('[data-define-name]').text()).toContain("define \"Numerator\"")
        expect(numerator.find(".clause-covered").length).toBe(0)
        expect(numerator.find(".clause-uncovered").length).toBe(6)

      it 'define "Absence of Cervix"', ->
        absenceOfCervix = $(@cqlMeasurePopulationLogic.$(".cql-statement")[4])
        expect(absenceOfCervix.find('[data-define-name]').text()).toContain("define \"Absence of Cervix\"")
        expect(absenceOfCervix.find(".clause-covered").length).toBe(0)
        expect(absenceOfCervix.find(".clause-uncovered").length).toBe(39)

      it 'define "Cervical Cytology Within 3 Years"', ->
        cervicalCytology = $(@cqlMeasurePopulationLogic.$(".cql-statement")[5])
        expect(cervicalCytology.find('[data-define-name]').text()).toContain("define \"Cervical Cytology Within 3 Years\"")
        expect(cervicalCytology.find(".clause-covered").length).toBe(0)
        expect(cervicalCytology.find(".clause-uncovered").length).toBe(32)

      it 'define "HPV Test Within 5 Years for Women Age 30 and Older"', ->
        hpvTest = $(@cqlMeasurePopulationLogic.$(".cql-statement")[6])
        expect(hpvTest.find('[data-define-name]').text()).toContain("define \"HPV Test Within 5 Years for Women Age 30 and Older\"")
        expect(hpvTest.find(".clause-covered").length).toBe(0)
        expect(hpvTest.find(".clause-uncovered").length).toBe(51)

      it 'define "Qualifying Encounters"', ->
        qualifyingEncounters = $(@cqlMeasurePopulationLogic.$(".cql-statement")[7])
        expect(qualifyingEncounters.find('[data-define-name]').text()).toContain("define \"Qualifying Encounters\"")
        expect(qualifyingEncounters.find(".clause-covered").length).toBe(21)
        expect(qualifyingEncounters.find(".clause-uncovered").length).toBe(5)

      it 'define "Has Hospice"', ->
        hasHospice = $(@cqlMeasurePopulationLogic.$(".cql-statement")[8])
        expect(hasHospice.find('[data-define-name]').text()).toContain("define \"Has Hospice\"")
        expect(hasHospice.find(".clause-covered").length).toBe(21)
        expect(hasHospice.find(".clause-uncovered").length).toBe(58)

    describe 'both patients have correct', ->
      beforeEach ->
        @measure.get('patients').add @patient1
        @measure.get('patients').add @patient2
        @population = @measure.get('populations').first()
        @measureLayoutView = new Thorax.Views.MeasureLayout(measure: @measure, patients: @measure.get('patients'))
        @measureView = @measureLayoutView.showMeasure()
        @cqlMeasurePopulationLogic = @measureView.logicView

      it 'initial population', ->
        initialPopulation = $(@cqlMeasurePopulationLogic.$(".cql-statement")[0])
        expect(initialPopulation.find('[data-define-name]').text()).toContain("define \"Initial Population\"")
        expect(initialPopulation.find(".clause-covered").length).toBe(27)
        expect(initialPopulation.find(".clause-uncovered").length).toBe(1)

      it 'denominator', ->
        denominator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[1])
        expect(denominator.find('[data-define-name]').text()).toContain("define \"Denominator\"")
        expect(denominator.find(".clause-covered").length).toBe(2)
        expect(denominator.find(".clause-uncovered").length).toBe(0)

      it 'denominator exception', ->
        denomException = $(@cqlMeasurePopulationLogic.$(".cql-statement")[2])
        expect(denomException.find('[data-define-name]').text()).toContain("define \"Denominator Exclusion\"")
        expect(denomException.find(".clause-covered").length).toBe(5)
        expect(denomException.find(".clause-uncovered").length).toBe(2)

      it 'numerator', ->
        numerator = $(@cqlMeasurePopulationLogic.$(".cql-statement")[3])
        expect(numerator.find('[data-define-name]').text()).toContain("define \"Numerator\"")
        expect(numerator.find(".clause-covered").length).toBe(0)
        expect(numerator.find(".clause-uncovered").length).toBe(6)

      it 'define "Absence of Cervix"', ->
        absenceOfCervix = $(@cqlMeasurePopulationLogic.$(".cql-statement")[4])
        expect(absenceOfCervix.find('[data-define-name]').text()).toContain("define \"Absence of Cervix\"")
        expect(absenceOfCervix.find(".clause-covered").length).toBe(0)
        expect(absenceOfCervix.find(".clause-uncovered").length).toBe(39)

      it 'define "Cervical Cytology Within 3 Years"', ->
        cervicalCytology = $(@cqlMeasurePopulationLogic.$(".cql-statement")[5])
        expect(cervicalCytology.find('[data-define-name]').text()).toContain("define \"Cervical Cytology Within 3 Years\"")
        expect(cervicalCytology.find(".clause-covered").length).toBe(24)
        expect(cervicalCytology.find(".clause-uncovered").length).toBe(8)

      it 'define "HPV Test Within 5 Years for Women Age 30 and Older"', ->
        hpvTest = $(@cqlMeasurePopulationLogic.$(".cql-statement")[6])
        expect(hpvTest.find('[data-define-name]').text()).toContain("define \"HPV Test Within 5 Years for Women Age 30 and Older\"")
        expect(hpvTest.find(".clause-covered").length).toBe(0)
        expect(hpvTest.find(".clause-uncovered").length).toBe(51)

      it 'define "Qualifying Encounters"', ->
        qualifyingEncounters = $(@cqlMeasurePopulationLogic.$(".cql-statement")[7])
        expect(qualifyingEncounters.find('[data-define-name]').text()).toContain("define \"Qualifying Encounters\"")
        expect(qualifyingEncounters.find(".clause-covered").length).toBe(22)
        expect(qualifyingEncounters.find(".clause-uncovered").length).toBe(4)

      it 'define "Has Hospice"', ->
        hasHospice = $(@cqlMeasurePopulationLogic.$(".cql-statement")[8])
        expect(hasHospice.find('[data-define-name]').text()).toContain("define \"Has Hospice\"")
        expect(hasHospice.find(".clause-covered").length).toBe(21)
        expect(hasHospice.find(".clause-uncovered").length).toBe(58)

  describe 'Errors', ->
    beforeEach ->
      @measure.get('patients').add @patient1
      @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient1, measure: @measure)
      @patientBuilder.render()
      @patientBuilder.appendTo('body')

    afterEach ->
      @patientBuilder.remove()

    it 'clears coloring if patient starts erroring', ->
      expect($($(".cql-statement")[0]).find('[data-define-name]').text()).toContain("define \"Initial Population\"")
      # Initial calculation shows highlighting
      expect($($(".cql-statement")[0]).find('.clause-true').length).toBe(27)
      # Updates to patient show highlighting if no errors
      @patient1.materialize()
      @measure.get('populations').at(0).calculate(@patient1)
      @patientBuilder.populationLogicView.showRationale(@patient1)
      expect($($(".cql-statement")[0]).find('.clause-true').length).toBe(27)
      @measure.get('cqmMeasure').measure_period = null
      # Updates to patient show no highlighting if error occurs
      @patient1.materialize()
      @measure.get('populations').at(0).calculate(@patient1)
      @patientBuilder.populationLogicView.showRationale(@patient1)
      expect($($(".cql-statement")[0]).find('.clause-true').length).toBe(0)

  describe 'Coloring', ->
    describe 'first patient has correct', ->
      beforeEach ->
        @measure.get('patients').add @patient1
        @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient1, measure: @measure)
        @patientBuilder.render()

      it 'initial population', ->it 'initial population', ->
        initialPopulation = $(@patientBuilder.$(".cql-statement")[0])
        expect(initialPopulation.find('[data-define-name]').text()).toContain("define \"Initial Population\"")
        expect(initialPopulation.find(".clause-true").length).toBe(27)
        expect(initialPopulation.find(".clause-false").length).toBe(1)

      it 'denominator', ->
        denominator = $(@patientBuilder.$(".cql-statement")[1])
        expect(denominator.find('[data-define-name]').text()).toContain("define \"Denominator\"")
        expect(denominator.find(".clause-true").length).toBe(2)
        expect(denominator.find(".clause-false").length).toBe(0)

      it 'denominator exception', ->
        denomException = $(@patientBuilder.$(".cql-statement")[2])
        expect(denomException.find('[data-define-name]').text()).toContain("define \"Denominator Exclusion\"")
        expect(denomException.find(".clause-true").length).toBe(5)
        expect(denomException.find(".clause-false").length).toBe(2)

      it 'numerator', ->
        numerator = $(@patientBuilder.$(".cql-statement")[3])
        expect(numerator.find('[data-define-name]').text()).toContain("define \"Numerator\"")
        expect(numerator.find(".clause-true").length).toBe(0)
        expect(numerator.find(".clause-false").length).toBe(0)

      it 'define "Absence of Cervix"', ->
        absenceOfCervix = $(@patientBuilder.$(".cql-statement")[4])
        expect(absenceOfCervix.find('[data-define-name]').text()).toContain("define \"Absence of Cervix\"")
        expect(absenceOfCervix.find(".clause-true").length).toBe(0)
        expect(absenceOfCervix.find(".clause-false").length).toBe(39)

      it 'define "Cervical Cytology Within 3 Years"', ->
        cervicalCytology = $(@patientBuilder.$(".cql-statement")[5])
        expect(cervicalCytology.find('[data-define-name]').text()).toContain("define \"Cervical Cytology Within 3 Years\"")
        expect(cervicalCytology.find(".clause-true").length).toBe(0)
        expect(cervicalCytology.find(".clause-false").length).toBe(0)

      it 'define "HPV Test Within 5 Years for Women Age 30 and Older"', ->
        hpvTest = $(@patientBuilder.$(".cql-statement")[6])
        expect(hpvTest.find('[data-define-name]').text()).toContain("define \"HPV Test Within 5 Years for Women Age 30 and Older\"")
        expect(hpvTest.find(".clause-true").length).toBe(0)
        expect(hpvTest.find(".clause-false").length).toBe(0)

      it 'define "Qualifying Encounters"', ->
        qualifyingEncounters = $(@patientBuilder.$(".cql-statement")[7])
        expect(qualifyingEncounters.find('[data-define-name]').text()).toContain("define \"Qualifying Encounters\"")
        expect(qualifyingEncounters.find(".clause-true").length).toBe(21)
        expect(qualifyingEncounters.find(".clause-false").length).toBe(4)

      it 'define "Has Hospice"', ->
        hasHospice = $(@patientBuilder.$(".cql-statement")[8])
        expect(hasHospice.find('[data-define-name]').text()).toContain("define \"Has Hospice\"")
        expect(hasHospice.find(".clause-true").length).toBe(21)
        expect(hasHospice.find(".clause-false").length).toBe(58)

    describe 'second patient has correct', ->
      beforeEach ->
        @measure.get('patients').add @patient2
        @patientBuilder = new Thorax.Views.PatientBuilder(model: @patient2, measure: @measure)
        @patientBuilder.render()

      it 'initial population', ->it 'initial population', ->
        initialPopulation = $(@patientBuilder.$(".cql-statement")[0])
        expect(initialPopulation.find('[data-define-name]').text()).toContain("define \"Initial Population\"")
        expect(initialPopulation.find(".clause-true").length).toBe(27)
        expect(initialPopulation.find(".clause-false").length).toBe(1)

      it 'denominator', ->
        denominator = $(@patientBuilder.$(".cql-statement")[1])
        expect(denominator.find('[data-define-name]').text()).toContain("define \"Denominator\"")
        expect(denominator.find(".clause-true").length).toBe(2)
        expect(denominator.find(".clause-false").length).toBe(0)

      it 'denominator exception', ->
        denomException = $(@patientBuilder.$(".cql-statement")[2])
        expect(denomException.find('[data-define-name]').text()).toContain("define \"Denominator Exclusion\"")
        expect(denomException.find(".clause-true").length).toBe(0)
        expect(denomException.find(".clause-false").length).toBe(7)

      it 'numerator', ->
        numerator = $(@patientBuilder.$(".cql-statement")[3])
        expect(numerator.find('[data-define-name]').text()).toContain("define \"Numerator\"")
        expect(numerator.find(".clause-true").length).toBe(0)
        expect(numerator.find(".clause-false").length).toBe(6)

      it 'define "Absence of Cervix"', ->
        absenceOfCervix = $(@patientBuilder.$(".cql-statement")[4])
        expect(absenceOfCervix.find('[data-define-name]').text()).toContain("define \"Absence of Cervix\"")
        expect(absenceOfCervix.find(".clause-true").length).toBe(0)
        expect(absenceOfCervix.find(".clause-false").length).toBe(39)

      it 'define "Cervical Cytology Within 3 Years"', ->
        cervicalCytology = $(@patientBuilder.$(".cql-statement")[5])
        expect(cervicalCytology.find('[data-define-name]').text()).toContain("define \"Cervical Cytology Within 3 Years\"")
        expect(cervicalCytology.find(".clause-true").length).toBe(24)
        expect(cervicalCytology.find(".clause-false").length).toBe(8)

      it 'define "HPV Test Within 5 Years for Women Age 30 and Older"', ->
        hpvTest = $(@patientBuilder.$(".cql-statement")[6])
        expect(hpvTest.find('[data-define-name]').text()).toContain("define \"HPV Test Within 5 Years for Women Age 30 and Older\"")
        expect(hpvTest.find(".clause-true").length).toBe(0)
        expect(hpvTest.find(".clause-false").length).toBe(51)

      it 'define "Qualifying Encounters"', ->
        qualifyingEncounters = $(@patientBuilder.$(".cql-statement")[7])
        expect(qualifyingEncounters.find('[data-define-name]').text()).toContain("define \"Qualifying Encounters\"")
        expect(qualifyingEncounters.find(".clause-true").length).toBe(21)
        expect(qualifyingEncounters.find(".clause-false").length).toBe(4)

      it 'define "Has Hospice"', ->
        hasHospice = $(@patientBuilder.$(".cql-statement")[8])
        expect(hasHospice.find('[data-define-name]').text()).toContain("define \"Has Hospice\"")
        expect(hasHospice.find(".clause-true").length).toBe(0)
        expect(hasHospice.find(".clause-false").length).toBe(79)
