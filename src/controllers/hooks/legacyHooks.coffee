TagMap= require('../../services/data/categoryMap')
_ = require 'lodash'
  
module.exports = exports =
  postalCodeService : require('../../services/postalCodeService')
  transformRequest : (req,res, cb)->
    if req.params 
      zipcode = req.params.zipcode || 64105
      exports.postalCodeService.get zipcode, (err, doc) ->
        req.params.ll = "#{doc.geo.coordinates[0]},#{doc.geo.coordinates[1]}"
        req.params.near = undefined
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
      inverted = _.invert TagMap
      for x in data
        ca = []
        for i in x.tags
          ca.push inverted[i]
        x.categories = ca.join ', '
        x.contactName = x.contacts.name
        x.venueId = x.legacyBusinessId || x.legacyHostId || x.business.legacyId
        x.venueName = x.business.name
        x.start = x.legacySchedules?[0]?.start || x.schedules?[0]?.start || x.fixedOccurrences?[0]?.start
        x.end =  x.legacyEndDate
        if imageH and imageW
          x.image = exports.transformImageUrl x.media[0].url, imageH, imageW
          x.venueImage = exports.transformImageUrl x.business.media[0] || x.host.media[0], imageH, imageW
        x.phone = x.contacts.phone
        x.email = x.contacts.email
        x.address = "#{x.address.line1} #{x.address.city}, #{x.address.state_province} #{x.address.postal_code}"
        x.latitude = x.geo.coordinates[1]
        x.longitude = x.geo.coordinates[0]
        if x.eventType is 'FOOD'
          x.detailsUrl = "http://localruckus.com/food-and-drink/details/#{x.legacyId}/"
        else if x.eventType is 'MUSIC'
          x.detailsUrl = "http://localruckus.com/live-music/details/#{x.legacyId}/"
        else
          x.detailsUrl = "http://localruckus.com/arts-and-culture/details/#{x.legacyId}/"


        delete x.business
        delete x.createdAt
        delete x.lastModifiedAt
        delete x.media
        delete x.schedules
        delete x.fixedOccurrences
        delete x.socialMediaLinks
        delete x.tags
        delete x.occurrences
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

