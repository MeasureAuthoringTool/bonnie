# add a log handler to push data out to the console in a template, plus a debug helper
Handlebars.registerHelper 'log', (message) -> console.log(message)
Handlebars.registerHelper 'debug', -> debugger

# add a helper for formatting dates
Handlebars.registerHelper 'moment', (date, format) -> moment.utc(date).format(format)

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

# Adds support for repeating a block N number of times
# Provides @index context variable (indexed at 1 rather than 0)
Handlebars.registerHelper 'times', (n, opts) ->
  if n
    out = ''
    for index in [1..n]
      out += opts.fn(this, data: { index: index })
  else
    out = opts.inverse(this)

  return out
Handlebars.registerHelper 'lookup', (obj, field) ->
  obj && obj[field]

Handlebars.registerHelper 'ifIn', (obj, arr, options) ->
  if obj in arr
    options.fn(this)
  else
    options.inverse(this)

###
Takes a shorthand population name and renders it such
that screen readers will read out the complete name
###
Handlebars.registerHelper 'populationName', (population) =>
  return '' unless population?
  return new Handlebars.SafeString Thorax.Models.Measure.PopulationMap[population]

###
Takes a number and subtracts another number from it.
###
Handlebars.registerHelper 'subtract', (a, b) ->
  return a - b

Handlebars.registerHelper 'sum', (a, b) ->
  a + b