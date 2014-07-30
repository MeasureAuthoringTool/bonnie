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

# A simple math helper for basic arithmetic operations within templates
# Useful for rendering indexes starting from 1
Handlebars.registerHelper 'math', (lvalue, operator, rvalue, options) ->
  lvalue = parseFloat(lvalue)
  rvalue = parseFloat(rvalue)
  return {
    '+' : lvalue + rvalue,
    '-' : lvalue - rvalue,
    '*' : lvalue * rvalue,
    '/' : lvalue / rvalue,
    '%' : lvalue % rvalue
  }[operator]
