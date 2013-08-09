_ = require 'lodash'
mongoose = require 'mongoose'
async = require('async')
geolib = require('geolib')
RestfulController = require('./restfulController')
SearchQuery = require('./helpers/SearchQuery')
SearchableController = require('./searchableController')

class LegacyRouteController extends SearchableController
  model : require('../models/event').Event
  scheduleService : require('../services/schedulingService')
  type: 'event'
  populate:['media','business','host', "business.media", "host.media"]
  hooks: require('./hooks/legacyHooks')

  constructor : (@name) ->
    super(@name)

module.exports = new LegacyRouteController()

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