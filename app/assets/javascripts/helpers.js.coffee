# add a log handler to push data out to the console in a template, plus a debug helper
Handlebars.registerHelper 'log', (message) -> console.log(message)
Handlebars.registerHelper 'debug', -> debugger

# add a helper for formatting dates
Handlebars.registerHelper 'moment', (date, format) -> moment(date).format(format)

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
Takes a string and returns a slugified version by replacing any spaces with dashes and making all characters lowercase. This is useful for transforming phrases into strings formatted appropriately for HTML markup. e.g. "Population 2" to "population-2"
###
Handlebars.registerHelper 'slugify', (str, defaultStr='') ->
  str = str || defaultStr # sets str to the default value if str doesn't exist
  if str
    slug = str.replace(/[^\w\s]+/gi, '').replace(/ +/gi, '-')
    return slug.toLowerCase()
  else
    return ''

###
Subtracts an amount from a value.
###
Handlebars.registerHelper 'subtract', (value, amount) ->
  return value - amount
