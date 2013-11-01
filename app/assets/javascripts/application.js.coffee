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
#= require jquery/jquery.min
#= require bootstrap/dist/js/bootstrap.min
#= require jquery-ui-1.10.3.custom
#= require handlebars/handlebars
#= require underscore/underscore-min
#= require backbone/backbone-min
#= require thorax/thorax.min
#= require moment/min/moment.min.js
#
#= require helpers
#= require_tree ./templates
#= require_tree ./models
#= require_tree ./views
#= require router
#= require_self
#= require_tree .

# add the rails authenticity token to Backbone.sync
Backbone.sync = _.wrap(Backbone.sync, (sync, method, model, options) ->
  # only need a token for non-get requests 
  if (method == 'create' || method == 'update' || method == 'delete')
    # grab the token from the meta tag rails embeds and add that to the options data
    options.data = _.extend({}, options.data, {authenticity_token: $('meta[name="csrf-token"]')[0].content})
    options.processData = true
  # proxy the call to the old sync method 
  sync(method, model, options))

window.bonnie = new BonnieRouter()
# We call Backbone.history.start() after all the measures are loaded, in app/views/layouts/application.html.erb
