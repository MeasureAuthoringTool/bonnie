describe 'MatrixView', ->

  beforeEach ->
    @matrixView = new Thorax.Views.Matrix(measures: Fixtures.Measures, patients: Fixtures.Patients)
    @matrixView.render()

  it 'renders correctly', ->
    expect(@matrixView.$el).toHaveText /0002/
    expect(@matrixView.$el).toHaveText /A, GP_Peds/

  it 'calcuates correctly', ->
    calculation = @matrixView.calculateAsynchronously()
    waitsFor -> calculation.state() == 'resolved'
    runs ->
      expect(@matrixView.$el).toHaveText /DEN/
      expect(@matrixView.$el).toHaveText /NUM/
