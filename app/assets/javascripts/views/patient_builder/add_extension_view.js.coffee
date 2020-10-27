# View for displaying the extensions on the Resource/DataCriteria
class Thorax.Views.AddExtensionView extends Thorax.Views.BonnieView
  template: JST['patient_builder/add_extension']

  initialize: ->
    @valueTypes = @getValueTypes()
    @dataElement = @model.get('dataElement')
    @url = null
    debugger
    # default selected type view is date
    #@selectedValueTypeView = new Thorax.Views.InputDateTimeView({ allowNull: false, defaultYear: 2020 })

  events:
    'change input[name="url"]': 'validateUrl'
    'change select[name="value"]': 'valueTypeChange'

  validateUrl: (e) ->
    @url = $(e.target).val()
    @toggleAddBtn()

  toggleAddBtn: ->
    if @url && /^\S+$/.test(@url)
      @$('#add_extension').removeAttr('disabled')
    else
      @$('#add_extension').attr('disabled', 'disabled')

  valueTypeChange: (e) ->
    newValueType = $(e.target).val()
    if newValueType != ""
      @selectedValueType = newValueType
    else
      @selectedValueType = null
    @_createViewForSelectedType()
    @render()
    @toggleAddBtn()

  # sets up view for the selected value Type.
  _createViewForSelectedType: ->
    # remove the existing view if there is one
    @selectedValueTypeView.remove() if @selectedValueTypeView?
    if @selectedValueType
      @selectedValueTypeView = switch @selectedValueType
        when 'Date' then new Thorax.Views.InputDateView({ allowNull: false, defaultYear: 2020 })
        when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: false, defaultYear: 2020 })
        when 'Period' then new Thorax.Views.InputPeriodView({ defaultYear: 2020})
        when 'Decimal' then new Thorax.Views.InputDecimalView({ allowNull: false })
        when 'Integer' then new Thorax.Views.InputIntegerView({ allowNull: false })
        when 'PositiveInt' then new Thorax.Views.InputPositiveIntegerView()
        when 'UnsignedInt' then new Thorax.Views.InputUnsignedIntegerView()
        when 'Boolean' then new Thorax.Views.InputBooleanView()
        when 'Quantity' then new Thorax.Views.InputQuantityView()
        when 'Duration' then new Thorax.Views.InputDurationView()
        when 'Age' then new Thorax.Views.InputAgeView()
        when 'Range' then new Thorax.Views.InputRangeView()
        when 'Ratio' then new Thorax.Views.InputRatioView()
        when 'String' then new Thorax.Views.InputStringView({ allowNull: false })
        when 'id' then new Thorax.Views.InputIdView()
        else null
      @showInputViewPlaceholder = !@selectedValueTypeView?
    else
      @selectedValueTypeView = null

  addExtension: (e) ->
    e.preventDefault()
    if @url != ""
      extensionUrl = cqm.models.PrimitiveUri.parsePrimitive(@url)
      extension = new cqm.models.Extension()
      extension.url = extensionUrl;
      extension.value = @_getExtensionValue()

      if (@dataElement.fhir_resource.extension)
        @dataElement.fhir_resource.extension.push(extension)
      else
        @dataElement.fhir_resource.extension = [extension]

      @trigger 'extensionModified', @
      # reset back to no selections
      @$('input[name="url"]').val('')
      @$('select[name="value"]').val('--')
      @selectedValueType = null
      @url = null
      @_createViewForSelectedType()
      @render()

  _getExtensionValue: ->
    value = @selectedValueTypeView.value
    if @selectedValueType
      @selectedValue = switch @selectedValueType
        when 'Date'
          DataCriteriaHelpers.getPrimitiveDateForCqlDate(value)
        when 'DateTime'
          DataCriteriaHelpers.getPrimitiveDateTimeForCqlDateTime(value)
        when 'Decimal'
          cqm.models.PrimitiveDecimal.parsePrimitive(value)
        when 'String', 'id'
          value?.trim()
        when 'Period', 'Boolean', 'Integer', 'PositiveInt', 'UnsignedInt', 'Duration', 'Age', 'Range', 'Ratio', 'Quantity'
          value
        else null
    @selectedValue

  removeValue: (e) ->
    # TODO: after display view
    attributeName = $(e.target).data('attribute-name')
    @trigger 'attributesModified', @

  getValueTypes: ->
    return [
      'Age',
      'Boolean',
      'Canonical',
      'Code',
      'CodeableConcept',
      'Coding',
      'DataRequirement',
      'Date',
      'DateTime',
      'Decimal',
      'Dosage',
      'Duration',
      'Id',
      'Identifier',
      'Instant',
      'Integer',
      'Period',
      'PositiveInt',
      'Quantity',
      'Range',
      'Ratio',
      'Reference',
      'String',
      'Time',
      'Timing',
      'UnsignedInt'
    ]
