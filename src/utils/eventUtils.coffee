_ = require 'lodash'
moment = require 'moment'
nextOccurrence = (event) ->
  if event?.occurrences and _.first(event?.occurrences)?.start
    m = moment(_.first(event.occurrences).start)
    m.local()
    if m.isAfter(moment().startOf('day'))
      return m
  return undefined

transformDates=(params)=>
   if params.start
      params.start= parseDate(decodeURIComponent(params.start)).toISOString()
    if params.end
      params.end= parseDate(decodeURIComponent(params.end)).toISOString()
    return params
parseDate= (date)=>
  d = {}
  if moment(date).isValid() 
    d = moment(date)
  else
    d = moment(date,["MM-DD-YYYY hh:mma","MM/DD/YYYY hh:mma","MMM DD, YYYY HH:mm:ssa","MM/DD/YYYY hh:mmA","MMM DD, YYYY HH:mm:ssA","YYYY-MM-DD","YYYY-MM-DDTHH","YYYY-MM-DD HH","YYYY-MM-DDTHH:mm","YYYY-MM-DD HH:mm","YYYY-MM-DDTHH:mm:ss","YYYY-MM-DD HH:mm:ss","YYYY-MM-DDTHH:mm:ss.SSS","YYYY-MM-DD HH:mm:ss.SSS","YYYY-MM-DD HH:mm:ss.SSSZ","YYYY-MM-DDTHH:mm:ss.SSSZ","YYYY-MM-DDTHH:mm:ss Z","YYYY-MM-DD HH:mm:ss Z"])
  return d
module.exports = 
  nextOccurrence : nextOccurrence
  transformDates:transformDates
  parseDate:parseDate