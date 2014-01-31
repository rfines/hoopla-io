RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')
ss = require('../services/socialService')

class PromotionRequestController extends RestfulController
  model : require('hoopla-io-core').PromotionRequest
  getFields : {}
  hooks : require('./hooks/restfulHooks.coffee')
  populate:['media', 'promotionTarget']

  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : securityConstraints.hasAuthUser
    destroy : securityConstraints.hasAuthUser

  constructor : (@name) ->
    super(@name)
  getPromotionAnalytics:(req,res,cb)=>
    if req.params.id
      @model.findOne req.params.id, @getFields, {lean:true}, (err, doc)=>
        if err
          console.log err
          res.send err, 400
        else
          analytics = {}
          ss.readFacebookPostInsights doc, (error, insights)=>
            if error
              console.log error
              res.send error, 400
            else
              analytics.facebook = insights
              res.send analytics, 200
module.exports = new PromotionRequestController()