# View that adds the extensions for the Resource/DataCriteria
class Thorax.Views.AddExtensionsView extends Thorax.Views.BonnieView
  template: JST['patient_builder/add_extensions']

  # dataElement - required data element
  # extensionsAccessor - is a required parameter, used to access resource's extensions: 'extension' | 'modifierExtension'
  initialize: ->
    @valueTypes = @getValueTypes()
    @url = null
    @validate()

  events:
    'keyup input[name="url"]': 'urlChange'
    'change input[name="url"]': 'urlChange'
    'input input[name="url"]': 'urlChange'
    'change select[name="value_type"]': 'valueTypeChange'
    rendered: ->
      @validate()

  urlChange: (e) ->
    @validate()

  valueTypeChange: (e) ->
    newValueType = $(e.target).val()
    if newValueType != ""
      @selectedValueType = newValueType
    else
      @selectedValueType = null
    @_createViewForSelectedType()
    @render()
    @validate()

  validate: ->
    urlInput = @$('input[name="url"]')
    @url = urlInput.val()
    @urlValid = @url && /^\S+$/.test(@url)
    if @urlValid
      urlInput.parent().removeClass('has-error')
    else
      urlInput.parent().addClass('has-error')
    if @urlValid && (@selectedValueTypeView?.hasValidValue() || !@selectedValueTypeView?)
      @$('.add_extension_btn').removeAttr('disabled')
    else
      @$('.add_extension_btn').attr('disabled', 'disabled')

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
      @listenTo(@selectedValueTypeView, 'valueChanged', @validate) if @selectedValueTypeView?
    else
      @selectedValueTypeView = null

  addExtension: (e) ->
    e.preventDefault()
    if @url != ""
      extensionUrl = cqm.models.PrimitiveUri.parsePrimitive(@url)
      extension = new cqm.models.Extension()
      extension.url = extensionUrl;
      extension.value = @_getExtensionValue()

      if (@getExtensions())
        @getExtensions().push(extension)
      else
        @setExtensions([extension])

      @trigger 'extensionModified', @
      # reset back to no selections
      @$('input[name="url"]').val('')
      @$('select[name="value_type"]').val('--')
      @selectedValueType = null
      @url = null
      @_createViewForSelectedType()
      @render()
      @validate()

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

  getExtensions: ->
    return @dataElement.fhir_resource?[@extensionsAccessor]

  setExtensions: (extensions) ->
    @dataElement.fhir_resource?[@extensionsAccessor] = extensions