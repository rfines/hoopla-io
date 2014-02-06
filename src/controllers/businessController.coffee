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
  populate:['media','promotionTargets']
  User : require('hoopla-io-core').User
  admins:["info@localruckus.com", "pittsburgks@localruckus.com", "manhattanks@localruckus.com"]
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
  getBusinesses:(req,res,next)=>
    fields = @calculateGetFields(req.authApp)  
    fields.name = 1
    fields.location=1
    q = @model.find {}, fields,{lean:true}
    q.populate(@populate.join(' '))
    q.exec (err, result)=>
      if err
        res.send 401, err
        next()
      else
        res.send 200, result
        next()
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

  getUser:(req,res,next)=>
    if req.params?.id
      console.log req.params.id
      @User.find {"businessPrivileges":{$elemMatch:{"business":req.params.id, "role":"OWNER"}}}, {},{},(err, docs)=>
        if err
          res.send 401, err
          next()
        else
          res.send 200, docs
          next()
    else
      res.send 400
      next()
  transferOwnership:(req,res,next)=>
    if req.body?.newOwner and req.params?.id
      @model.findById req.params.id, {},{},(err,doc)=>
        if err
          res.send 401,err
          next()
        else
          
          @User.findOne {"email":req.body.newOwner},{},{},(error, targetOwner)=>
            if error
              res.send 400, error
              next()
            else
              role="OWNER"
              if not targetOwner
                f = {success:false, message:"Unable to find a user.", email:req.body.newOwner}
                res.send 200, f
                next()
              else if not req.body.oldOwner
                if @admins.indexOf(targetOwner.email)!=-1
                  role="ADMIN_COLLABORATOR"
                if !_.isArray(targetOwner.businessPrivileges)
                  targetOwner.set
                    businessPrivileges: [{'role':role, "business":doc._id}]
                else
                  targetOwner.businessPrivileges.push({'role':role, "business":doc._id})
                targetOwner.save (e_r,di)=>
                  if e_r
                    console.log e_r  
                    res.send 400, e_r
                    next()
                  else
                    f = {success:true, message:"Successfully transferred business to #{di.email}.", owner:di}
                    res.send 200,f
                    next()
              else
                if @admins.indexOf(targetOwner.email)!=-1
                  role="ADMIN_COLLABORATOR"
                @User.findOne {"email":req.body.oldOwner}, {},{},(e, oldOwner)=>
                  if e
                    res.send 401, e
                    next()
                  else
                    
                    bp={}
                    i = -1
                    if oldOwner.businessPrivileges.length > 1
                      _.each oldOwner.businessPrivileges, (item, index, list)=>
                        if item.business.toString() == doc._id.toString() and item.role.toString() == "OWNER"
                          bp = item
                          i = index
                    else if oldOwner.businessPrivileges?.length == 1
                      i =0
                    if i >=0
                      newPrivileges = oldOwner.businessPrivileges.splice(i, 1)
                      oldOwner.save (errors, dud) =>
                        if errors
                          res.send 401,errors
                          next()
                        else
                          if !_.isArray(targetOwner.businessPrivileges)
                            targetOwner.set
                              businessPrivileges: [{'role':role, "business":doc._id}]
                          else
                            targetOwner.businessPrivileges.push({'role':role, "business":doc._id})
                          targetOwner.save (e_r,did)=>
                            if e_r
                              console.log e_r  
                              res.send 400, e_r
                              next()
                            else
                              f = {success:true, message:"Successfully transferred business to #{did.email}.", owner:did}
                              res.send 200,f
                              next()
    else
      f={success:false}
      res.send 401, f
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