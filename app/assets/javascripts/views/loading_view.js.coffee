###*
# Simple view that consists of a loading spinner. To be used as the mainView when a view that needs some asyncronously
# loaded data is loading said data.
###
class Thorax.Views.LoadingView extends Thorax.Views.BonnieView
  template: JST['loading_view']
