mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('../restfulController')
SearchQuery = require('./SearchQuery')

class QueryComponentBuilder

  postalCodeService : require('../../services/postalCodeService')
  geoCoder : require('../../services/geocodingService')

  validateSearchQuery : (params) ->
    if not params.ll and not params.near
      return {'message': 'The request parameters do not contain a near field or ll field.'}

  coordinates: (params, cb) =>
    if(params.ll)
      ll = params.ll.split(',')
      centerCoordinates = {latitude : parseFloat(ll[1]), longitude: parseFloat(ll[0])}
      cb null, centerCoordinates

  tags: (params, cb) =>
    if params.tags
      tags = params.tags.split(',')
      cb null, tags
    else
      cb null, ""

  maxCost : (params, cb) =>
    if params.maxCost
      maxCost = parseFloat(params.maxCost)
      cb null, maxCost
    else
      cb null, ""

  betweenDates : (params, cb) =>
    if params.start and params.end
      cb null, {start:params.start, end: params.end}
    else if params.start and not params.end
      cb null, {start:params.start}
    else
      cb null,""

  buildSearchQuery : (params, cb) =>
    errors = @validateSearchQuery(params)
    console.log errors
    if errors 
      cb errors, null
    else
      async.parallel {
        coordinates : (cb) =>
          @coordinates(params, cb)
        tags : (cb) =>
          @tags(params,cb)
        maxCost : (cb) =>
          @maxCost(params, cb)
        betweenDates : (cb) =>
          @betweenDates(params, cb)
      }, (err, results) ->
        if err
          cb err, null
        else
          distance = params.radius || 40234
          q = new SearchQuery().within(distance)
          if results.coordinates
            q.ofCoordinates(results.coordinates.longitude, results.coordinates.latitude) 
          if results.tags.length
            q.withTags(results.tags)
          if results.maxCost
            q.withCost results.maxCost
          if results.betweenDates
            q.betweenDates(results.betweenDates.start,results.betweenDates.end)
          cb null, results.coordinates, q.build()

  module.exports = new QueryComponentBuilder
