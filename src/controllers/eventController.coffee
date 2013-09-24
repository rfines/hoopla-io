_ = require 'lodash'
SearchableController = require('./searchableController')
securityConstraints = require('./helpers/securityConstraints')

class EventController  extends SearchableController
  model : require('../models/event').Event
  type: 'event'
  hooks: require('./hooks/eventHooks')
  promoRequest : require('../models/promotionRequest').PromotionRequest
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
          console.log err
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
module.exports = new EventController()