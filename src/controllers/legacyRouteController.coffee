_ = require 'lodash'
mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')
SearchableController = require('./searchableController')
TagMap= require('../services/data/categoryMap')
postalCodeService = require('../services/postalCodeService')

###
routes to implement:
/api/getevents?apiKey=blah&eventType=4&categories="some list of categories"&zipcode=64105&radius=25&cost=100&start=10/29/1981&end=10/31/1981&imageHeight=200&imageWidth=200

the result should look like this:
{success:true, date:[{
  id:
  name:
  email:
  contactName:
  phone:
  website:
  venueId:
  venueName:
  address:(as one string)
  latitude:
  longitude:
  startDate:
  endDate:
  nextOccurrenceDate:
  startTime:
  endTime:
  isRecurring:
  image: (url to the image)
  categories: (one string, comma separated)
  description:
  venueImage: (url to image)
  ticketUrl:
  detailsUrl: (link to details page on local ruckus)
}]

/api/get-event?apiKey=somekey&id=123&imageWidth=200&imageHeight=200

success:true, data:{
  id:
  name:
  email:
  contactName:
  phone:
  website:
  venueId:
  venueName:
  address:(as one string)
  latitude:
  longitude:
  startDate:
  endDate:
  nextOccurrenceDate:
  startTime:
  endTime:
  isRecurring:
  image: (url to the image)
  categories: (one string, comma separated)
  description:
  venueImage: (url to image)
  ticketUrl:
  detailsUrl: (link to details page on local ruckus)
}
###

class LegacyRouteController extends SearchableController
  model : require('../models/event').Event
  builder : require('./helpers/QueryComponentBuilder')
  searchService : require('../services/searchService')
  scheduleService : require('../services/schedulingService')
  type: 'event'
  populate:['media','business','host', "business.media", "host.media"]
  
  transformRequest : (req,res, cb)->
    if req.params 
      zipcode = req.params.zipcode || 64105
      postalCodeService.get zipcode, (err, doc) ->
        console.log err if err
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
        x.start = x.legacySchedules[0]?.start || x.schedules[0].start || x.fixedOccurrences[0].start
        x.end =  x.legacyEndDate
        if imageH and imageW
          x.image = @transformImageUrl x.media[0].url, imageH, imageW
          x.venueImage = @transformImageUrl x.business.media[0] || x.host.media[0], imageH, imageW
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

  constructor : (@name) ->
    super(@name)
    @hooks.search.pre = (req,res, cb) =>
      @transformRequest req, res, (err, data) ->
        if err
          console.log err
          cb err, null
        else
          cb null, req
    @hooks.search.post =(data,res, cb) =>
      @transformResponse data, data.imageHeight, data.imageWidth, (err, newData) ->
        if err
          console.log err
          cb err,null
        else
          cb null, newData

module.exports = new LegacyRouteController()