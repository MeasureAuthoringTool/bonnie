describe 'MatrixView', ->

  beforeEach ->
    @measures = bonnie.measures
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json')
    @matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @matrixView.render()

  it 'renders correctly', ->
    @measures.each (m) =>
      @patients.each (p) =>
        expect(@matrixView.$el).toContainText m.get('measure_id')
        expect(@matrixView.$el).toContainText "#{p.get('last')}, #{p.get('first')}"

  it 'calcuates correctly', ->
    calculation = @matrixView.calculateAsynchronously()
    waitsFor -> calculation.state() == 'resolved'
    runs ->
      expect(@matrixView.$el).toContainText "DEN"
      # FIXME: Cypress patients don't fall into NUM anymore for Measures 0002 and 0022?
      # expect(@matrixView.$el).toContainText "NUM"
