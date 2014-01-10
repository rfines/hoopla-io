_ = require 'lodash'
SearchableController = require('./searchableController')
securityConstraints = require('./helpers/securityConstraints')
calendarService = require('../services/calendarService')
moment = require 'moment'
fs = require 'fs'
ss = require('../services/socialService')
async = require('async')

class EventController  extends SearchableController
  model : require('hoopla-io-core').Event
  type: 'event'
  hooks: require('./hooks/eventHooks')
  promoRequest : require('hoopla-io-core').PromotionRequest
  promoTarget : require('hoopla-io-core').PromotionTarget
  fields: {schedules: 0}
  sort: {'nextOccurrence':1}
  populate:['media']
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
      target.event = req.params.id
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
  updatePromotionRequest : (req, res, next)=>
    if req.body and req.params.reqId
      req.body.edit = true
      @promoRequest.findByIdAndUpdate req.params.reqId,req.body,(err,doc)=>
        if err
          res.send 400, err
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
              res.setHeader("content-type","text/calendar;charset=UTF-8")
              res.setHeader("content-length" , result.length)
              res.send 200,result.toString('binary')
              next()
          )
  calculateGetFields:(app)=>
    fields = {}
    if app and not app.privileges is 'PRIVILEGED'
      fields = {'promotionRequests':0, 'schedules':0, 'fixedOccurrences':0, 'legacySchedule':0, 'legacyHostId':0, 'legacyId':0, 'legacyImage':0, 'legacyBusinessId':0, sources: 0}
    return fields
    
  getPromotionRequests:(req,res,cb)=>
    if req.params and req.params.id
      pop = ['media']
      q = @model.findOne {_id:req.params.id}, {}
      q.lean()
      q.populate(pop.join(' '))
      q.exec (err,doc)=>
        if err
          res.send 401, err
          next()
        else
          if doc.promotionRequests?.length > 0
            pop.push 'promotionTarget'
            z = @promoRequest.find {'_id':{$in:doc.promotionRequests}}, {}
            z.lean()
            z.populate(pop.join(' '))
            z.exec (error,docs)=>
              if error
                res.send 401, error
              else
                res.send 200, docs
          else
            res.send 200, doc.promotionRequests
    else
      res.send 500
  getAnalytics:(req,res,cb)=>
    if req.params and req.params.id
      pop = ["promotionRequests"]
      q = @model.findOne {_id:req.params.id}, {}
      q.lean()
      q.populate(pop.join(','))
      q.exec (err, doc)=>
        if err
          console.log err
          re.send err, 400
        else
          if doc.promotionRequests and doc.promotionRequests.length >0
            preqs= doc.promotionsRequests
            ss.batchFacebookRequests doc, (err, insights)=>
              if err
                console.log err
                res.send err, 400
              else
                console.log insights
                res.send insights, 200

module.exports = new EventController()