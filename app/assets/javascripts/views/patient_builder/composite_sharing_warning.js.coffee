# Small view to detect and display codes that are selected in the patient elements that are not present in any
# value sets for this measure; the view is passed a patient and a measure, which are available in the @patient
# and @measure instance variables, which we just use to set up the appropriate context
class Thorax.Views.CompositeSharingWarning extends Thorax.Views.BonnieView

  template: JST['patient_builder/composite_sharing_warning']

  initialize: ->

  context: ->

