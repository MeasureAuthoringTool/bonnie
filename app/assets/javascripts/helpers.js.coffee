# add a log handler to push data out to the console in a template
Handlebars.registerHelper 'log', (message) -> console.log(message)

# add a helper for formatting dates
Handlebars.registerHelper 'moment', (date, format) -> moment(date).format(format)
