window.Bonnie ||= {}
Bonnie.util ||= {}
Bonnie.util.getDurationBetween = (start_date, end_date) ->
  # Formats duration between a start_date and an end_date and returns that value as a string (e.g. "2 years, 3 months")
  # (both start and end date must be moments from Moment.js)
  if !start_date.isSame(end_date)
    terms = []
    for unit in ['years', 'months', 'days', 'hours', 'minutes']
      duration = end_date.diff(start_date, "#{unit}")
      end_date.subtract(duration, "#{unit}")
      if duration > 0
        terms.push if duration > 1 then  "#{duration} #{unit}" else "#{duration} #{unit}".slice(0,-1) # Remove plural if necessary
      break if terms.length > 1 # Only return two values (e.g. "13 years, 2 months" instead of "13 years, 2 months, 3 days, 1 hour, 3 minutes")
    terms.join(', ')
  else
    "0 minutes"
