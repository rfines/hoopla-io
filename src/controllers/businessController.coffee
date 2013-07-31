mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')
Category = require('../models/businessCategory').BusinessCategory
async = require 'async'

class BusinessController extends RestfulController
  
  model : require('../models/business').Business
  postalCodeService : require('../services/postalCodeService')
  geoCoder : require('../services/geocodingMQService')

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @buildSearchQuery req.params, (err, centerCoordinates,  result) =>
      @model.find result, {}, {lean:true}, (err, data) ->
        calcDistance = (item, cb) ->
          businessCoordinates = 
            longitude: item.geo.coordinates[0]
            latitude: item.geo.coordinates[1]
          item.distance = geolib.getDistance centerCoordinates, businessCoordinates
          cb null
        async.each data, calcDistance, (err) ->
          res.send data
          next()

  validateSearchQuery : (params) ->
    if not params.ll and not params.near
      return {'message': 'The request parameters do not contain a near field or ll field.'}

  buildLocationQueryPart : (params, cb) =>
    errors = @validateSearchQuery(params)
    if errors 
      cb errors, null
    else
<<<<<<< HEAD
      async.parallel {
        coordinates : (cb) =>
          @coordinates(params, cb)
      }, (err, results) ->
        if err
          cb err, null
        else
          distance = params.radius || 40234
          q = new SearchQuery().within(distance)
          if results.coordinates
            q.ofCoordinates(results.coordinates.longitude, results.coordinates.latitude) 
          cb null, results.coordinates, q.build()

  coordinates: (params, cb) =>
    if(params.ll)
      ll = params.ll.split(',')
      centerCoordinates = {latitude : parseFloat(ll[1]), longitude: parseFloat(ll[0])}
      cb null, centerCoordinates
    else if(params.near)
        if /^\d+$/.test(params.near)
          @postalCodeService.get params.near, (err, doc) ->
            centerCoordinates = {latitude : doc.geo.coordinates[1], longitude: doc.geo.coordinates[0]}
            cb null, centerCoordinates
=======
      if params.ll
        ll = params.ll.split(',')
        cb null, {longitude:parseFloat(ll[0]), latitude:parseFloat(ll[1])}
      else if(params.near)
        if /^\d+$/.test(params.near)
          @postalCodeService.get params.near, (err, doc) ->
            cb null, {longitude: doc.geo.coordinates[0], latitude: doc.geo.coordinates[1]}
>>>>>>> More searching
        else
          @geoCoder.geocodeAddress params.near, (err, result) ->
            if err
              cb err, null
            else
<<<<<<< HEAD
              centerCoordinates = {longitude : result.longitude, latitude : result.latitude}
              cb null, centerCoordinates  
=======
              cb null, {longitude: result.longitude, latitude: result.latitude}

  buildCategoryQueryPart : (params , cb) =>
    result = []
    translateCategories = (category, cb) =>
      for c in categories
        console.log c
        Category.findOne {name : c}, {_id : 1}, {lean:true}, (err,item) ->
          if err
            cb err, null
          else
            result.push(item._id)
          
    if params.categories
        async.each params.categories, @translateCategories, (err) ->
          if err
            cb err, null
          else
            cb null, result

  buildSubCategoryQueryPart : (params, cb) => 
    result = []
    translateSubCategories = (subCategories, cb) =>
      for c in subCategories.split(',')
        Category.findOne {'subCategories.name' : c}, {}, {lean:true}, (err,item) ->
          if err
            cb err, null
          else
            match = _.find(item.subCategories, (element) -> element == c)
            if match
              result.push(match._id)
    if params.subCategories
      async.each params.subCategories, @translateSubCategories, (err) ->
        if err
          cb err, null
        else
          cb null, result

  buildSearchQuery : (params, cb) =>
    errors = @validateSearchQuery(params)
    if errors 
      cb errors, null
    else
      distance = params.maxDistance || 25
 
    q = new SearchQuery().within(distance).miles()
    async.parallel {
      location: (callback) =>
        @buildLocationQueryPart params, callback
      categories: (callback) =>
        @buildCategoryQueryPart params, callback
      subCategories: (callback) =>
        @buildSubCategoryQueryPart params, callback

    },(err, results) =>
      q.ofLatitude(results.location.latitude)
      q.ofLongitude(results.location.longitude)
      if results.categories.length >0
        q.withCategories(results.categories)
      if results.subCategories.length > 0
        q.withSubCategories(results.subCategories)
  
    if params.keyword
      q.withKeyword(params.keyword)

    if errors
      cb errors, null
    else
      cb null, q.build()
>>>>>>> More searching

module.exports = new BusinessController()