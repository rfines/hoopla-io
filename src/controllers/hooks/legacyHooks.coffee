TagMap= require('../../services/data/categoryMap')
_ = require 'lodash'
moment = require 'moment'
hookLibrary = require('./hookLibrary')
  
module.exports = exports =
  postalCodeService : require('../../services/postalCodeService')
  transformRequest : (req,res, cb)->
    if req.params 
      zipcode = req.params.zipcode || 64105
      exports.postalCodeService.get zipcode, (err, doc) ->
        req.params.ll = "#{doc.geo.coordinates[0]},#{doc.geo.coordinates[1]}"
        delete req.params.near
        delete req.params.zipcode
        if req.params.cost
          realcost = 0
          switch req.params.cost
            when '0' then realcost = 0.00
            when '10' then realcost = 10.00
            when '20' then realcost = 20.00
            when '35' then realcost = 35.00
            when '50' then realcost = 50.00
            when '100' then realcost = 100.00
            else realcost = 100.00
          req.params.cost = realcost
        if req.params.categories
          cats = req.params.categories.split ','
          delete req.params.categories
          tags=[]
          for c in cats
            tags.push TagMap[c]
          req.params.tags = tags
        cb null, req
    else
      errors = {code: 400, message: "Invalid request"}
      cb errors, null
    
  transformResponse:(data, imageH, imageW,cb) ->
    if data
      result = {success: 'true', data:[]}
      addr = {}
      inverted = _.invert TagMap
      eventData = []
      if not _.isArray(data)
        eventData.push data
      else
        eventData = data
      for x in eventData
        ca = []
        for i in x.tags
          ca.push inverted[i]
        x.id = x.legacyId || x._id
        x.categories = ca.join ', '
        x.contactName = x.contactName
        x.venueId = x.legacyBusinessId || x.legacyHostId || x.business.legacyId || x.business._id
        x.venueName = x.business.name
        x.start = x.legacySchedules?[0]?.start || x.schedules?[0]?.start || x.fixedOccurrences?[0]?.start
        x.end =  x.legacyEndDate
        if imageH and imageW
          if x.media
            x.image = exports.transformImageUrl x.media[0]?.url, imageH, imageW
          if x.business?.media
            x.venueImage = exports.transformImageUrl x.business.media[0] || x.host.media[0], imageH, imageW
        else
          x.image = x.media[0]?.url
          x.venueImage = x.business.media?[0]?.url || ""
        x.startTime = new moment(x.start).format('hh:mm A')
        x.endTime = new moment(x.legacyEndDate).format('hh:mm A')
        x.phone = x.contactPhone
        x.email = x.contactEmail
        x.address = x.location.address
        x.latitude = x.location.geo.coordinates[1]
        x.longitude = x.location.geo.coordinates[0]
        if x.eventType is 'FOOD'
          x.detailsUrl = "http://localruckus.com/food-and-drink/details/#{x.legacyId}/"
        else if x.eventType is 'MUSIC'
          x.detailsUrl = "http://localruckus.com/live-music/details/#{x.legacyId}/"
        else
          x.detailsUrl = "http://localruckus.com/arts-and-culture/details/#{x.legacyId}/"
        delete x.location
        delete x.business
        delete x.createdAt
        delete x.lastModifiedAt
        delete x.media
        delete x.schedules
        delete x.fixedOccurrences
        delete x.socialMediaLinks
        delete x.tags
        delete x.occurrences
        delete x.legacySchedule
        delete x.legacyId
        delete x.contacts
        delete x.eventType
        delete x.__v
        delete x._id
        delete x.legacyEndDate
        delete x.legacyImage
        delete x.ticketingLinks
        result.data.push x
      cb null, result

  transformImageUrl: (url, h, w)=>
    if url
      u = url
      t = u.split('/')
      a = t.indexOf('upload')
      t[a+1] = "h_#{h},w_#{w}"
      return t.join('/')

  search:
    pre : (options) =>
      exports.transformRequest options.req, options.res, (err, data) ->
        if err
          options.error(err, null) if options.error
        else
          options.success() if options.success
    post : (options) =>
      exports.transformResponse options.res.body, options.res.body.imageHeight, options.res.body.imageWidth, (err, newData) ->
        if err
          options.error(err, null) if options.error
        else
          options.res.body = newData
          options.success() if options.success
  get:
    pre : hookLibrary.default
    post : (options) =>
      exports.transformResponse options.res.body, options.res.body.imageHeight, options.res.body.imageWidth, (err, newData) ->
        if err
          options.error(err, null) if options.error
        else
          options.res.body = newData
          options.success() if options.success
