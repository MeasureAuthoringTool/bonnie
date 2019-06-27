# Input view for composite types such as Id, FacilityLocation and Component and future Entities.
class Thorax.Views.InputCompositeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/composite']

  # Expected options to be passed in using the constructor options hash:
  #   initialValue - string - Optional. Initial value of composite.
  #   schema - MongooseSchema - Mongoose schema type.
  #   cqmValueSets - Array<CQM.ValueSet> - All valuesets on the measure.
  #   codeSystemMap - The mapping of code systems oids to code system names.
  #   typeName = The name of the type we should be constructing
  initialize: ->
    @value = null

    @componentViews = []
    @schema.eachPath (path, info) =>
      # go on to the next one if it is an attribute that should be skipped
      return if Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES.includes(path)

      type = @_determineType(path, info)
      view = @_createInputViewForType(type, path)
      if view?
        @listenTo(view, 'valueChanged', @handleComponentUpdate)

      @componentViews.push {
        title: path
        name: path # TODO get pretty names made
        view: view
        showPlaceholder: !view?
        type: type
      }

  _determineType: (path, info) ->
    # If it is an interval, it may be one of DateTime or one of Quantity
    if info.instance == 'Interval'
      if path == 'referenceRange'
        return 'Interval<Quantity>'
      else
        return 'Interval<DateTime>'

    # If it is an embedded type, we have to make guesses about the type
    else if info.instance == 'Embedded'
      if info.schema.paths.namingSystem? # if this has namingSystem assume it is QDM::Id
        return 'Id'
      else
        return '???' # TODO: Handle situation of unknown type better.
    else
      return info.instance

  _createInputViewForType: (type, placeholderText) ->
    inputView = switch type
      when 'Interval<DateTime>' then new Thorax.Views.InputIntervalDateTimeView()
      when 'Interval<Quantity>' then new Thorax.Views.InputIntervalQuantityView()
      when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: false })
      when 'Time' then new Thorax.Views.InputTimeView({ allowNull: false })
      when 'Quantity' then new Thorax.Views.InputQuantityView()
      when 'Code' then new Thorax.Views.InputCodeView({ cqmValueSets: @cqmValueSets, codeSystemMap: @codeSystemMap })
      when 'String' then new Thorax.Views.InputStringView({ allowNull: false, placeholder: placeholderText })
      when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ allowNull: false, placeholder: placeholderText })
      when 'Decimal' then new Thorax.Views.InputDecimalView({ allowNull: false, placeholder: placeholderText })
      when 'Ratio' then new Thorax.Views.InputRatioView()
      when 'Any' then new Thorax.Views.InputAnyView({ attributeName: placeholderText, cqmValueSets: @cqmValueSets, codeSystemMap: @codeSystemMap })
      else null

  handleComponentUpdate: ->
    componentsValues = @_getAllComponentValuesIfValid()
    if componentsValues?
      # if everything is valid then make the type
      if cqm.models[@typeName]
        @value = new cqm.models[@typeName](componentsValues)
      else
        console.error("Could not find constructor cqm.models.#{@typeName}")
      @trigger 'valueChanged', @
    else
      # if invalid values exist, null value out if needed and trigger event
      if @value != null
        @value = null
        @trigger 'valueChanged', @

  # grabs all the component values as an object or null if there is one that is invalid
  _getAllComponentValuesIfValid: ->
    newAttrs = {}
    for componentView in @componentViews
      if componentView.view.hasValidValue()
        newAttrs[componentView.name] = componentView.view.value
      else
        return null

    return newAttrs

  # checks if the value in this view is valid. returns true or false. this is used by the attribute entry view to determine
  # if the add button should be active or not
  hasValidValue: ->
    @value?
