describe 'MatrixView', ->

  beforeEach ->
    measuresCollection = new Thorax.Collection([Fixtures.Measures['0002']])
    @matrixView = new Thorax.Views.Matrix(measures: measuresCollection, patients: Fixtures.Patients)
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
