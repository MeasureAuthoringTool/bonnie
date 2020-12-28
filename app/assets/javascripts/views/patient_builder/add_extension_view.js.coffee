# View that adds the extensions for the Resource/DataCriteria
class Thorax.Views.AddExtensionsView extends Thorax.Views.BonnieView
  template: JST['patient_builder/add_extensions']

  initialize: ->
    @valueTypes = @getValueTypes()
    @dataElement = @model.get('dataElement')
    @url = null

  events:
    'change input[name="url"]': 'validateUrl'
    'change select[name="value_type"]': 'valueTypeChange'

  validateUrl: (e) ->
    @url = $(e.target).val()
    @toggleAddBtn()

  toggleAddBtn: ->
    if @url && /^\S+$/.test(@url) && (@selectedValueTypeView?.hasValidValue() || !@selectedValueTypeView?)
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
      @measurementYear = @parent.measure.getMeasurePeriodYear()
      @selectedValueTypeView = switch @selectedValueType
        when 'Date' then new Thorax.Views.InputDateView({ allowNull: false, defaultYear: @measurementYear })
        when 'DateTime' then new Thorax.Views.InputDateTimeView({ allowNull: false, defaultYear: @measurementYear })
        when 'Period' then new Thorax.Views.InputPeriodView({ defaultYear: @measurementYear})
        when 'Decimal' then new Thorax.Views.InputDecimalView({ allowNull: false })
        when 'String' then new Thorax.Views.InputStringView({ allowNull: false })
        when 'Integer' then new Thorax.Views.InputIntegerView({ allowNull: false })
        when 'PositiveInt' then new Thorax.Views.InputPositiveIntegerView()
        when 'UnsignedInt' then new Thorax.Views.InputUnsignedIntegerView()
        when 'Boolean' then new Thorax.Views.InputBooleanView()
        when 'Quantity' then new Thorax.Views.InputQuantityView()
        when 'Duration' then new Thorax.Views.InputDurationView()
        when 'Age' then new Thorax.Views.InputAgeView()
        when 'Range' then new Thorax.Views.InputRangeView()
        when 'Ratio' then new Thorax.Views.InputRatioView()
        else null
      @showInputViewPlaceholder = !@selectedValueTypeView?
      @listenTo(@selectedValueTypeView, 'valueChanged', @toggleAddBtn) if @selectedValueTypeView?
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
      @$('select[name="value_type"]').val('--')
      @selectedValueType = null
      @url = null
      @_createViewForSelectedType()
      @render()

  _getExtensionValue: ->
    value = @selectedValueTypeView?.value
    if @selectedValueType
      @selectedValue = switch @selectedValueType
        when 'Date'
          DataCriteriaHelpers.getPrimitiveDateForCqlDate(value)
        when 'DateTime'
          DataCriteriaHelpers.getPrimitiveDateTimeForCqlDateTime(value)
        when 'Period', 'Boolean', 'Integer', 'PositiveInt', 'UnsignedInt', 'Decimal', 'Duration', 'String', 'Age', 'Range', 'Ratio', 'Quantity', 'Id', 'Canonical'
          value
        else null
    @selectedValue

  getValueTypes: ->
    return [
      'Age',
      'Boolean',
#      'Canonical',
#      'Code',
#      'CodeableConcept',
#      'Coding',
#      'DataRequirement',
      'Date',
      'DateTime',
      'Decimal',
#      'Dosage',
      'Duration',
#      'Id',
#      'Identifier',
#      'Instant',
      'Integer',
      'Period',
      'PositiveInt',
      'Quantity',
      'Range',
      'Ratio',
      'Reference',
      'String',
#      'Time',
#      'Timing',
      'UnsignedInt'
    ]
