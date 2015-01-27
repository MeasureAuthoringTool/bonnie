# add a log handler to push data out to the console in a template, plus a debug helper
Handlebars.registerHelper 'log', (message) -> console.log(message)
Handlebars.registerHelper 'debug', -> debugger

# add a helper for formatting dates
Handlebars.registerHelper 'moment', (date, format) -> moment.utc(date).format(format)

# helper for displaying complexity score in graphical form
Handlebars.registerHelper 'complexityIcon', (score) ->
  return '' unless score?
  good = '<i class="good fa fa-2x fa-check-circle"></i>'
  exclamation = '<i class="exclamation fa fa-2x fa-exclamation-triangle"></i> '
  return new Handlebars.SafeString(good) if score <= 10
  return new Handlebars.SafeString(exclamation) if score <= 20
  return new Handlebars.SafeString(exclamation + exclamation) if score <= 50
  return new Handlebars.SafeString(exclamation + exclamation + exclamation)

# Is the current user an admin or portfolio user? For convenience in deciding what UI
# elements to display, not trustable for security purposes
Handlebars.registerHelper 'ifAdmin', (options) ->
  if bonnie.isAdmin then options.fn(this) else options.inverse(this)
Handlebars.registerHelper 'ifPortfolio', (options) ->
  if bonnie.isPortfolio then options.fn(this) else options.inverse(this)

Handlebars.registerHelper 'ifCond', (v1, operator, v2, options) ->
  switch operator
    when '==' 
      if (v1 == v2) then options.fn(this) else options.inverse(this)
    when '!=' 
      if (v1 != v2) then options.fn(this) else options.inverse(this)
    when '<'
      if (v1 < v2) then options.fn(this) else options.inverse(this)
    when '<='
      if (v1 <= v2) then options.fn(this) else options.inverse(this)
    when '>'
      if (v1 > v2) then options.fn(this) else options.inverse(this)
    when '>='
      if (v1 >= v2) then options.fn(this) else options.inverse(this)
    when '&&'
      if (v1 && v2) then options.fn(this) else options.inverse(this)
    when '||'
      if (v1 || v2) then options.fn(this) else options.inverse(this)
    else return options.inverse(this)
