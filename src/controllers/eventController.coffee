_ = require 'lodash'
mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')
SearchableController = require('./searchableController')

class EventController  extends SearchableController
  model : require('../models/event').Event
  builder : require('./helpers/QueryComponentBuilder')
  searchService : require('../services/searchService')
  scheduleService : require('../services/schedulingService')
  type: 'event'
  populate: ['media']
  hooks:
    update:
      post : (event) =>
        @scheduleService.calculate event, (err, occurrences) ->
          if err
            console.log err
          else
            event.occurrences = occurrences
            event.save()
    create:
      post : (event) =>
        @scheduleService.calculate event, (err, occurrences) ->
          if err
            console.log err
          else
            event.occurrences = occurrences
            event.save()
  constructor : (@name) ->
    super(@name)  

module.exports = new EventController()