_ = require 'lodash'
moment = require 'moment'
nextOccurrence = (event) ->
  if event?.occurrences and _.first(event?.occurrences)?.start
    m = moment(_.first(event.occurrences).start)
    m.local()
    if m.isAfter(moment().startOf('day'))
      return m
  return undefined


module.exports = 
  nextOccurrence : nextOccurrence