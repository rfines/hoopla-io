_ = require 'lodash'
SearchableController = require('./searchableController')
securityConstraints = require('./helpers/securityConstraints')
calendarService = require('../services/calendarService')
moment = require 'moment'
fs = require 'fs'

class EventController  extends SearchableController
  model : require('hoopla-io-core').Event
  type: 'event'
  hooks: require('./hooks/eventHooks')
  promoRequest : require('hoopla-io-core').PromotionRequest
  fields: {schedules: 0}
  sort: {'nextOccurrence':1}
  
  security: 
    get : securityConstraints.anyone
    destroy : (authenticatedUser, event) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.business?.equals(event.business)
      return not _.isUndefined(ownerMatch)      
    update : (authenticatedUser, event) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.business?.equals(event.business)
      return not _.isUndefined(ownerMatch)  
    create : (authenticatedUser, event) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.business?.equals(event.business)
      return not _.isUndefined(ownerMatch)  

  constructor : (@name) ->
    super(@name)  

  addPromotionRequest : (req, res, next)=>
    if req.body
      target = new @promoRequest(req.body)
      target.save (err)=>
        if err
          res.send 400, err
          next()
        else
          event = @model.findByIdAndUpdate req.params.id, {$push: {'promotionRequests': target}}, (er, doc)=>
            if er
              res.send 400, er
              next()
            else
              res.send 200, doc
              next()
    else
      res.send 500
      next()
  getICalFile :(req, res, next)=>
    if req.body and req.params.id
      @model.findById req.params.id,{},{lean:true},(err,doc)=>
        if err
          res.send 401, err
          next()
        else
          start = moment.unix(req.params.start)
          end = moment.unix(req.params.end)
          calendarService.getCalendar('ical',doc,start,end,(err,result)=>
            if err
              res.send 400, err
              next()
            else
              res.setHeader("content-type","text/calendar;chaarset=UTF-8")
              res.setHeader("content-length" , result.length)
              res.send 200,result.toString('binary')
              next()
          )
  calculateGetFields:(app)=>
    fields = {}
    if app and not app.privileges is 'PRIVILEGED'
      fields = {'promotionRequests':0, 'schedules':0, 'fixedOccurrences':0, 'legacySchedule':0, 'legacyHostId':0, 'legacyId':0, 'legacyImage':0, 'legacyBusinessId':0}
    return fields
module.exports = new EventController()