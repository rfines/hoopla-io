_ = require 'lodash'
SearchableController = require('./searchableController')
securityConstraints = require('./helpers/securityConstraints')


class BusinessController extends SearchableController
  type: 'business'
  model : require('../models/business').Business
  searchService : require('../services/searchService')
  events : require('../models/event').Event
  promoTarget: require('../models/promotionTarget').PromotionTarget

  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : (authenticatedUser, business) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv.business?.equals(business._id)
      return not _.isUndefined(ownerMatch)
    destroy : (authenticatedUser, business) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv.business?.equals(business._id) and priv.role is 'OWNER'
      return not _.isUndefined(ownerMatch)

  hooks : require('./hooks/businessHooks')

  constructor : (@name) ->
    super(@name)

  getEvents : (req,res,next) =>
    if req.params.id and not req.query.ids
      @events.find {"business": req.params.id}, {},{lean:true}, (err, result)->
        if err
          res.send 400, err
          next()
        else
          res.send 200, result
          next()
    else if req.query.additional_ids
      ids = req.query.additional_ids.split ','
      if _.indexOf(ids, req.params.id) is -1 and req.params.id
        ids.push req.params.id
      @events.find {"business":{$in : ids}}, {}, {lean:true}, (err, result)->
        if err
          res.send 400, err
          next()
        else
          res.send 200, result
          next()
    else
      res.send 400, "Invalid request."
      next()
  addPromotionTarget: (req,res,next)=>
    if req.body
      if req.body._id
        console.log "here is an id"
      else
        target = new @promoTarget(req.body)
        target.save (err)=>
          business = @model.findByIdAndUpdate req.params.id, {$push: {'promotionTargets': target}}, (er, doc)->
            console.log er
            console.log doc
            res.send 201
            next()
    else
      res.send 500
      next()
module.exports = new BusinessController()