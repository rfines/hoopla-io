_ = require 'lodash'
SearchableController = require('./searchableController')
securityConstraints = require('./helpers/securityConstraints')
imageManipulation = require('./helpers/imageManipulation')

class BusinessController extends SearchableController
  type: 'business'
  model : require('hoopla-io-core').Business
  searchService : require('../services/searchService')
  events : require('hoopla-io-core').Event
  promoTarget: require('hoopla-io-core').PromotionTarget
  populate:['media']
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
    fields = @calculateGetFields(req.authApp)
    if req.params.id and not req.query.ids
      query = 
        business: req.params.id
      if req.params.start
        query['occurrences'] =
        $elemMatch : 
          start: 
            $gte: req.params.start
      q = @events.find query, fields,{lean:true}
      q.populate(@populate.join(' '))
      q.exec (err, result)=>
        if err
          res.send 400, err
          next()
        else
          result = @rewriteImageUrl req, result
          res.send 200, result
          next()
    else
      res.send 400, "Invalid request."
      next()
  addPromotionTarget: (req,res,next)=>
    if req.body
      target = new @promoTarget(req.body)
      target.save (err)=>
        business = @model.findByIdAndUpdate req.params.id, {$push: {'promotionTargets': target}}, (er, doc)->
          res.send 200, doc
          next()
    else
      res.send 500
      next()

  allVenues : (req, res, next) =>
    fields = @calculateGetFields(req.authApp)  
    fields.name = 1
    fields.location=1
    q = @model.find {}, fields, {lean:true}
    q.populate(@populate.join(' '))
    q.exec (err, data) ->
      res.send data
      next()
      
  calculateGetFields:(app)=>
    fields = {}
    if app and not app.privileges is 'PRIVILEGED'
      fields = {'promotionTargets':0,'promotionRequests':0, 'legacyCreatedBy':0, 'legacyId':0, sources: 0}
    return fields

  rewriteImageUrl : (req, originalList) =>
    return _.map originalList, (item) ->
      if item.media and item.media[0]?.url
        h = req.params.height if req?.params?.height
        w = req.params.width if req?.params?.width
        c = req.params.imageType if req?.params?.imageType
        item.media[0].url = imageManipulation.resize(w, h, item.media[0].url,c)
      return item

module.exports = new BusinessController()