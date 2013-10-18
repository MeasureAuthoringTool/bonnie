describe 'MatrixView', ->

  beforeEach ->
    @measures = Fixtures.Measures
    @patients = new Thorax.Collections.Patients getJSONFixture('patients.json')
    @matrixView = new Thorax.Views.Matrix(measures: @measures, patients: @patients)
    @matrixView.render()

  it 'renders correctly', ->
    @measures.each (m) =>
      @patients.each (p) =>
        expect(@matrixView.$el).toContainText m.id
        expect(@matrixView.$el).toContainText "#{p.get('last')}, #{p.get('first')}"

  it 'calcuates correctly', ->
    calculation = @matrixView.calculateAsynchronously()
    waitsFor -> calculation.state() == 'resolved'
    runs ->
      expect(@matrixView.$el).toContainText "DEN"
      expect(@matrixView.$el).toContainText "NUM"
