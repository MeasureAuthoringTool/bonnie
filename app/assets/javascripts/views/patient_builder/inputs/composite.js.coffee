# Input view for composite types such as Id, FacilityLocation and Component and future Entities.
class Thorax.Views.InputCompositeView extends Thorax.Views.BonnieView
  template: JST['patient_builder/inputs/composite']

  # Mapping of type to list of attributes that should allow null values
  @OPTIONAL_ATTRS = {
    'DiagnosisComponent': ['rank', 'presentOnAdmissionIndicator'],
    'PatientEntity': ['identifier'], # 'id' should also be here, but mongoid will autogenerate one so we require
    'CarePartner': ['identifier', 'relationship'], # 'id' same as above
    'Practitioner': ['identifier', 'role', 'specialty', 'qualification'], # 'id' same as above
    'Organization': ['identifier', 'type'], # 'id' same as above
    'Identifier': ['namingSystem', 'value'],
  }

  # Expected options to be passed in using the constructor options hash:
  #   schema - MongooseSchema - Mongoose schema type.
  #   cqmValueSets - Array<CQM.ValueSet> - All valuesets on the measure.
  #   codeSystemMap - The mapping of code systems oids to code system names.
  #   typeName = The name of the type we should be constructing
  #   defaultYear = The default year if there is a DateTime input view
  #   allowNull = Whether or not this input should allow no entry
  initialize: ->
    @value = null

    @componentViews = []
    @schema.eachPath (path, info) =>
      # go on to the next one if it is an attribute that should be skipped. Note that we want to include id here.
      return if _.without(Thorax.Models.SourceDataCriteria.SKIP_ATTRIBUTES, 'id').includes(path)

      type = @_determineType(path, info)
      view = @_createInputViewForType(type, path, info)
      if view?
        @listenTo(view, 'valueChanged', @handleComponentUpdate)

      @componentViews.push {
        title: Thorax.Models.SourceDataCriteria.ATTRIBUTE_TITLE_MAP[path] || path
        name: path
        view: view
        showPlaceholder: !view?
        type: type
      }
    @showLabels = @typeName != 'Identifier'

    if !@hasOwnProperty('allowNull')
      @allowNull = false

  events:
    rendered: ->
      @handleComponentUpdate()

  _determineType: (path, info) ->
    # If it is an interval, it may be one of DateTime or one of Quantity
    if info.instance == 'Interval'
      if path == 'referenceRange'
        return 'Interval<Quantity>'
      else
        return 'Interval<DateTime>'

    # If it is an embedded type, we have to make guesses about the type
    else if info.instance == 'Embedded'
      if info.schema.paths.namingSystem? # if this has namingSystem assume it is QDM::Identifer
        return 'Identifier'
      else
        return '???' # TODO: Handle situation of unknown type better.
    else
      return info.instance

  _createInputViewForType: (type, attributeName, info) ->
    inputView = switch type
      when 'Interval<DateTime>' then new Thorax.Views.InputIntervalDateTimeView({ allowNull: @_attrShouldAllowNull(attributeName), defaultYear: @defaultYear })
      when 'Interval<Quantity>' then new Thorax.Views.InputIntervalQuantityView({ allowNull: @_attrShouldAllowNull(attributeName) })
      when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: @_attrShouldAllowNull(attributeName), defaultYear: @defaultYear })
      when 'Time' then new Thorax.Views.InputTimeView({ allowNull: @_attrShouldAllowNull(attributeName) })
      when 'Quantity' then new Thorax.Views.InputQuantityView({ allowNull: @_attrShouldAllowNull(attributeName) })
      when 'Code' then new Thorax.Views.InputCodeView({ cqmValueSets: @cqmValueSets, codeSystemMap: @codeSystemMap, allowNull: @_attrShouldAllowNull(attributeName) })
      when 'String' then new Thorax.Views.InputStringView({ placeholder: attributeName, allowNull: @_attrShouldAllowNull(attributeName) })
      when 'Integer', 'Number' then new Thorax.Views.InputIntegerView({ placeholder: attributeName, allowNull: @_attrShouldAllowNull(attributeName) })
      when 'Decimal' then new Thorax.Views.InputDecimalView({ placeholder: attributeName, allowNull: @_attrShouldAllowNull(attributeName) })
      when 'Ratio' then new Thorax.Views.InputRatioView({ allowNull: @_attrShouldAllowNull(attributeName) })
      when 'Any' then new Thorax.Views.InputAnyView({ attributeName: attributeName, cqmValueSets: @cqmValueSets, codeSystemMap: @codeSystemMap, allowNull: @_attrShouldAllowNull(attributeName), defaultYear: @defaultYear })
      when 'Identifier' then new Thorax.Views.InputCompositeView({ schema: info.schema, typeName: type, allowNull: @_attrShouldAllowNull(attributeName)})
      else null

  _attrShouldAllowNull: (attributeName) ->
    return Thorax.Views.InputCompositeView.OPTIONAL_ATTRS[@typeName]?.includes(attributeName)

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
    @allowNull || @value?
