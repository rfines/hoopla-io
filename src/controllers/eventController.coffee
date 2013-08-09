_ = require 'lodash'
SearchableController = require('./searchableController')

class EventController  extends SearchableController
  model : require('../models/event').Event
  type: 'event'
  populate: ['media']
  hooks: require('./hooks/eventHooks')
  
  constructor : (@name) ->
    super(@name)  

module.exports = new EventController()