TagMap= require('../../services/data/categoryMap')
_ = require 'lodash'
moment = require 'moment'
  
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
      if _.isArray(data)
        for x in data
          ca = []
          for i in x.tags
            ca.push inverted[i]
          x.id = x.legacyId || x._id
          x.categories = ca.join ', '
          x.contactName = x.contacts.name
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
          x.phone = x.contacts?.phone
          x.email = x.contacts?.email
          addr = x.address
          delete x.address
          x.address = "#{addr.line1} #{addr.city}, #{addr.state_province} #{addr.postal_code}"
          x.latitude = x.geo.coordinates[1]
          x.longitude = x.geo.coordinates[0]
          if x.eventType is 'FOOD'
            x.detailsUrl = "http://localruckus.com/food-and-drink/details/#{x.legacyId}/"
          else if x.eventType is 'MUSIC'
            x.detailsUrl = "http://localruckus.com/live-music/details/#{x.legacyId}/"
          else
            x.detailsUrl = "http://localruckus.com/arts-and-culture/details/#{x.legacyId}/"
          delete x.geo
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
      else if _.isObject(data)
        x = data
        ca = []
        for i in x.tags
          ca.push inverted[i]
        x.id = x.legacyId || x._id
        x.categories = ca.join ', '
        x.contactName = x.contacts.name
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
          x.image = x.media[0]?.url || ""
          x.venueImage = x.business.media?[0]?.url || ""
        x.startTime = new moment(x.start).format('h:mm:ss a')
        x.endTime = new moment(x.end).format('h:mm:ss a')
        x.phone = x.contacts?.phone
        x.email = x.contacts?.email
        addr = x.address
        delete x.address
        x.address = "#{addr.line1} #{addr.city}, #{addr.state_province} #{addr.postal_code}"
        x.latitude = x.geo.coordinates[1]
        x.longitude = x.geo.coordinates[0]
        if x.eventType is 'FOOD'
          x.detailsUrl = "http://localruckus.com/food-and-drink/details/#{x.legacyId}/"
        else if x.eventType is 'MUSIC'
          x.detailsUrl = "http://localruckus.com/live-music/details/#{x.legacyId}/"
        else
          x.detailsUrl = "http://localruckus.com/arts-and-culture/details/#{x.legacyId}/"
        delete x.geo
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
    pre : (req,res, cb) =>
      exports.transformRequest req, res, (err, data) ->
        if err
          cb err, null
        else
          cb null, req
    post : (req, res, cb) =>
      exports.transformResponse res.body, res.body.imageHeight, res.body.imageWidth, (err, newData) ->
        if err
          cb err,null
        else
          res.body = newData
          cb null
  get:
    pre : (req, res, cb) =>
      cb null, req
    post : (req, res, cb) =>
      exports.transformResponse res.body, res.body.imageHeight, res.body.imageWidth, (err, newData) ->
        if err
          cb err,null
        else
          console.log newData
          res.body = newData
          cb null
