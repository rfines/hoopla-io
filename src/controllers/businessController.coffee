_ = require 'lodash'
mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')
SearchableController = require('./searchableController')


class BusinessController extends SearchableController
  type: 'business'
  model : require('../models/business').Business
  builder : require('./helpers/QueryComponentBuilder')
  searchService : require('../services/searchService')

  constructor : (@name) ->
    super(@name)

module.exports = new BusinessController()