expansions = {
  'ENTERTAINMENT':['ATTRACTIONS', 'AMUSEMENT', 'ARCADES', 'GALLERIES', 'BOWLING', 'BREWERIES', 'CASINOS', 'CHILDREN', 'COMEDY','FESTIVALS', 'FARMERS', 'ORCHARDS','FINEARTS','GOLF' , 'HISTORIC', 'LIBRARY', 'MOVIE', 'MUSEUMS', 'NIGHTLIFE', 'PARKS', 'PERFORMING','PERFORMINGARTS', 'PETS',"SPORTS", 'SHOPPING', 'STADIUM', 'THEATERES', 'UNIQUE', 'WINERIES', 'ZOOS','CLASSICROCK', 'FOLK', 'ALTERNATIVE', 'CLASSICAL', 'ELECTRONICA', 'INDIE', 'POP', 'ROCK', 'ACOUSTIC', 'JAZZ', 'RAP', 'BLUES', 'COUNTRY', 'METAL', 'REGGAE', 'PROGRESSIVE', 'PUNK', 'ROCKABILLY', 'HOLIDAY', "ALTERNATIVE", "BLUES", "AMERICANA", "CHILD", "CHRISTIAN", "DANCE", "EXPERIMENTAL", "RAP", "INDIE", "LATIN", "NEWAGE", "REGGAE", "SOUL", "ROCKABILLY","TRIBUTE","VARIOUS","WORLD", 'EXHIBITS', 'EXPOS', 'BARGAMES', 'DRINK', 'HISTORICAL', 'BUSINESS', 'CHARITY', 'TEENS', 'NEIGHBORHOOD', 'ENTREPRENEUR', 'FAITH', 'FAMILY', 'FAIRS', 'FILM', 'FOODS', 'WELLNESS', 'HOLIDAY', 'LGBT', 'LITERARY', 'CONCERTS', 'OTHER', 'PETS', 'POLITICAL','SCHOOL', 'SCIENCE', 'SHOPPING', 'FITNESS','VISUAL', 'PROFESSIONAL', "COMMUNITY"]
  'ARTS' : ['CHARITY','COMEDY','FILM','FINEARTS','FOODS', 'FESTIVALS','HISTORICAL','LITERARY','PERFORMING','PERFORMINGARTS','MULTICULTURE']
  'FAMILY-AND-CHILDREN' : ['TEENS','CHILDRENS','FAMILY', 'MULTICULTURE','LIBRARY']
  'FOOD-AND-DRINK' : ['BEER','COCKTAILS','FOOD','WINE']
  'MUSIC' : ['CLASSICROCK', 'FOLK', 'ALTERNATIVE', 'CLASSICAL', 'ELECTRONICA', 'INDIE', 'POP', 'ROCK', 'ACOUSTIC', 'JAZZ', 'RAP', 'BLUES', 'COUNTRY', 'METAL', 'REGGAE', 'PROGRESSIVE', 'PUNK', 'ROCKABILLY', 'HOLIDAY', "ALTERNATIVE", "BLUES", "AMERICANA", "CHILD", "CHRISTIAN", "DANCE", "EXPERIMENTAL", "RAP", "INDIE", "LATIN", "NEWAGE", "REGGAE", "SOUL", "ROCKABILLY","TRIBUTE","VARIOUS","WORLD"]
}

TagMap= require('../../services/data/categoryMap')
Media = require('hoopla-io-core').Media
mongoose = require('mongoose')
ObjectId = mongoose.Schema.ObjectId
_ = require 'lodash'
moment = require 'moment'
hookLibrary = require('./hookLibrary')
EventUtil = require('../../utils/eventUtils')
async = require 'async'

module.exports = exports =
  postalCodeService : require('../../services/postalCodeService')
  transformRequest : (req,res, cb)->
    if req.params 
      if req.params.start or req.params.end
        req.params = EventUtil.transformDates(req.params)
      if req.params.radius
        req.params.radius = (req.params.radius * 1609.344)
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
        else if req.params.eventType
          eType = req.params.eventType
          expanded = ''
          switch eType
            when '0' then expanded = "FOOD-AND-DRINK"
            when '1' then expanded ="MUSIC"
            when '2' then expanded = "ARTS"
            when '3' then expanded = "ENTERTAINMENT"
            when '5' then expanded ="FAMILY-AND-CHILDREN"
            else expanded = undefined
          req.params.tags= expanded
          if req.params?.tags
            newTags = []
            expand = (t, cb) ->
              if expansions[t]
                for x in expansions[t]
                  newTags.push x      
              else
                newTags.push t    
              cb null
            async.each req.params.tags.split(','), expand, ->
              req.params.tags = newTags.join(',')
              cb null, req
          else
            cb null, req
        else
          cb null, req
    else
      errors = {code: 400, message: "Invalid request"}
      cb errors, null
    
  transformResponse:(data, imageH, imageW,cb) ->
    if data
      mediaObs = []
      result = {success: 'true', data:[]}
      addr = {}
      inverted = _.invert TagMap
      eventData = []
      if not _.isArray(data)
        eventData.push data
      else
        eventData = data
      media = (callback)-> 
        mediaIds = _.map eventData, (event) ->
          return event.host?.media?[0] || event.business?.media?[0]
        mediaIds = _.filter mediaIds, (item) ->
          return item?
        Media.find {_id : {$in : mediaIds}}, {}, {lean:true}, (err, docs) ->
          mediaObs = docs
          callback(null)  
          
      transform = (callback) ->
        transformSingleEvent = (x, eventCb)=>
          ca = []
          for i in _.uniq x.tags
            ca.push inverted[i]
          x.id = x.legacyId || x._id
          x.description = x.description || ''
          x.categories = ca.join ', '
          x.contactName = x.contactName
          x.venueId = x.host?._id || x.business?._id
          x.venueName = x.host?.name||x.business?.name
          if not x.cost
            x.cost = 0
          venImg = _.find mediaObs, (item)=>
            mediaImgId = x.host?.media?[0] || x.business?.media?[0]
            if not mediaImgId or not item?._id
              return false
            else
              return mediaImgId.equals(item._id)

          if imageH and imageW
            if x.media
              x.image = exports.transformImageUrl x.media[0]?.url, imageH, imageW
            x.venueImage = exports.transformImageUrl  venImg.url|| venImg.url, imageH, imageW
          else
            x.image = x.media?[0]?.url || "http://dashboard.hoopla.io/client/images/sprint-eureka-api-placeholder.gif"
            x.venueImage = venImg?.url || "http://dashboard.hoopla.io/client/images/sprint-eureka-api-placeholder.gif"
          x.startDate = moment(x.schedules?[0]?.start).utc().format('M/D/YYYY') || moment(x.fixedOccurrences?[0]?.start).utc().format('M/D/YYYY')
          if x.schedules?[0]?.end
            x.endDate =  moment(x.schedules?[0]?.end).utc().format('M/D/YYYY')
          else if x.fixedOccurrences.length > 0
            x.endDate =moment(x.fixedOccurrences[x.fixedOccurrences.length-1]?.end).utc().format('M/D/YYYY')
          else
            x.endDate = moment().add('years', 5).utc().format('M/D/YYYY') 
          if x.nextOccurrence?.start and x.nextOccurrence?.end
            x.startTime =moment(x.nextOccurrence?.start).utc().format('h:mm A')
            x.endTime = moment(x.nextOccurrence?.end).utc().format('h:mm A')
            x.nextOccurrence = moment(x.nextOccurrence?.start).utc().format('M/D/YYYY')
          else
            x.startTime=moment(x.prevOccurrence?.start).utc().format('h:mm A')
            x.endTime =  moment(x.prevOccurrence?.end).utc().format('h:mm A')
            x.nextOccurrence = moment(x.prevOccurrence?.start).utc().format('M/D/YYYY')
          x.phone = x.contactPhone
          x.email = x.contactEmail
          x.address = x.location.address
          x.latitude = x.location.geo.coordinates[1]
          x.longitude = x.location.geo.coordinates[0]
          x.isRecurring = x.schedules?.length > 0 
          x.detailsUrl = "http://localruckus.com/event/#{x._id}/"
          if not x.website or not x.website?.length > 0
            x.website =x.detailsUrl
            
          delete x.sources 
          delete x.prevOccurrence  
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
          delete x.ticketUrl
          delete x.host
          delete x.scheduleText
          delete x.promotionRequests
          delete x.tzOffset
          result.data.push x

          eventCb null
        async.each eventData, transformSingleEvent, (err)->
          callback(null)
    end=()->
      cb null, result
    async.series([
      media,
      transform,
      end
    ] )

  transformImageUrl: (url, h, w)=>
    if url
      u = url
      t = u.split('/')
      a = t.indexOf('upload')
      t[a+1] = "h_#{h},w_#{w}"
      return t.join('/')

  transformDates:(params)=>
     if params.start
        params.start= exports.parseDate(params.start).toISOString()
      if params.end
        params.end= exports.parseDate(params.end).toISOString()
      return params
  parseDate: (date)=>
    d = {}
    if moment(date).isValid() 
      d = moment(date)
    else
      d = moment(date,["MM-DD-YYYY hh:mma","MM/DD/YYYY hh:mma","MMM DD, YYYY HH:mm:ssa","MM/DD/YYYY hh:mmA","MMM DD, YYYY HH:mm:ssA","YYYY-MM-DD","YYYY-MM-DDTHH","YYYY-MM-DD HH","YYYY-MM-DDTHH:mm","YYYY-MM-DD HH:mm","YYYY-MM-DDTHH:mm:ss","YYYY-MM-DD HH:mm:ss","YYYY-MM-DDTHH:mm:ss.SSS","YYYY-MM-DD HH:mm:ss.SSS","YYYY-MM-DD HH:mm:ss.SSSZ","YYYY-MM-DDTHH:mm:ss.SSSZ","YYYY-MM-DDTHH:mm:ss Z","YYYY-MM-DD HH:mm:ss Z"])
    return d
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
