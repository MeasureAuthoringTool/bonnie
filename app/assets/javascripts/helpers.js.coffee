# add a log handler to push data out to the console in a template, plus a debug helper
Handlebars.registerHelper 'log', (message) -> console.log(message)
Handlebars.registerHelper 'debug', -> debugger

# add a helper for formatting dates
Handlebars.registerHelper 'moment', (date, format) -> moment(date).format(format)

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
