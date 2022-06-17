# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require jquery/dist/jquery.min
#= require jquery_ujs
#= require bootstrap/dist/js/bootstrap.min
#= require bootstrap-datepicker/js/bootstrap-datepicker
#= require bootstrap-timepicker/js/bootstrap-timepicker
#= require jquery-ui-1.11.4.custom
#= require twbs-pagination/jquery.twbsPagination.min
#= require handlebars/handlebars
#= require underscore/underscore-min
#= require backbone/backbone-min
#= require backbone.paginator/lib/backbone.paginator.min
#= require cqm-execution/dist/browser
#= require thorax/thorax
#= require moment/min/moment.min
#= require d3/d3
#= require d3-tip/index
#= require jQuery-Knob/js/jquery.knob
#= require jquery-selectboxit/src/javascripts/jquery.selectBoxIt.min
#= require jquery.fileDownload/src/Scripts/jquery.fileDownload
#= require jquery-placeholder/jquery.placeholder.min
#= require jquery-color/jquery.color
#= require bootstrap-file-input/bootstrap.file-input
#= require MutationObserver-shim/dist/mutationobserver.min
#= require tinymce
#= require rxjs/dist/bundles/rxjs.umd.js
#
#= require costanza/js/costanza
#= require costanza/thorax
#
#= require helpers
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./helpers
#= require_tree ./views
#= require calculator
#= require cqm_calculator
#= require calculator_selector
#= require router
#= require_self
#= require_tree .

# Make all JST templates available as Handlebars templates, so the {{template 'foo'}} helper works as expected
Handlebars.templates[name] = template for name, template of JST

# add the rails authenticity token to Backbone.sync
Backbone.sync = _.wrap Backbone.sync, (originalSync, method, model, options) ->
  if (method == 'create' || method == 'update' || method == 'delete')
    options.beforeSend = _.wrap options.beforeSend, (originalBeforeSend, xhr) ->
      xhr.setRequestHeader 'X-CSRF-Token', $("meta[name='csrf-token']").attr('content')
      originalBeforeSend(xhr) if originalBeforeSend
  originalSync method, model, options

window.bonnie = new BonnieRouter()
# We call Backbone.history.start() after all the measures are loaded, in app/views/layouts/application.html.erb
