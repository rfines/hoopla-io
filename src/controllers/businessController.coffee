mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')

class BusinessController extends RestfulController
  
  model : require('../models/business').Business
  postalCodeService : require('../services/postalCodeService')
  geoCoder : require('../services/geocodingMQService')

  constructor : (@name) ->
    super(@name)

  search : (req, res, next) =>
    @buildSearchQuery req.params, (err, centerCoordinates,  result) =>
      console.log result
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

  buildSearchQuery : (params, cb) =>
    console.log params
    errors = @validateSearchQuery(params)
    if errors 
      cb errors, null
    else
      async.parallel {
        coordinates : (cb) =>
          @coordinates(params, cb)
        categories : (cb) =>
          @categories(params,cb)
        subCategories : (cb) =>
          @subCategories(params, cb)
        
      }, (err, results) ->
        if err
          cb err, null
        else
          distance = params.radius || 40234
          q = new SearchQuery().within(distance)
          if results.coordinates
            q.ofCoordinates(results.coordinates.longitude, results.coordinates.latitude) 
          if results.categories.length
            q.inCategories(results.categories)
          if results.subCategories.length
            q.inSubCategories(results.subCategories)
          
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
        else
          @geoCoder.geocodeAddress params.near, (err, result) ->
            if err
              cb err, null
            else
              centerCoordinates = {longitude : result.longitude, latitude : result.latitude}
              cb null, centerCoordinates 

  categories: (params, cb) =>
    if params.categories
      categories = params.categories.split(',')
      cb null, categories
    else
      cb null, ""
  subCategories: (params, cb) =>
    if params.subCategories
      subCategories = params.subCategories.split(',')
      cb null, subCategories
    else
      cb null, ""
  
module.exports = new BusinessController()