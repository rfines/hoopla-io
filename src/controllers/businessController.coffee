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
  searchService : require('../services/searchService')

  security: 
    create : (authenticatedUser, target) ->
      return authenticatedUser
    update : (authenticatedUser, target) ->
      return authenticatedUser
    destroy : (authenticatedUser, target) ->
      return authenticatedUser            

  hooks : require('./hooks/businessHooks')

  constructor : (@name) ->
    super(@name)

module.exports = new BusinessController()