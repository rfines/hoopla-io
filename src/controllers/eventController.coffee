_ = require 'lodash'
mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')
SearchableController = require('./searchableController')

class EventController  extends SearchableController
  model : require('../models/event').Event
  type: 'event'
  populate: ['media']
  hooks: require('./hooks/eventHooks')
  
  constructor : (@name) ->
    super(@name)  

module.exports = new EventController()