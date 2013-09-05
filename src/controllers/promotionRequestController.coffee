RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')

class PromotionRequestController extends RestfulController
  model : require('../models/promotionRequest').PromotionRequest
  getFields : {}
  hooks : require('./hooks/restfulHooks.coffee')

  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : securityConstraints.hasAuthUser
    destroy : securityConstraints.hasAuthUser

  constructor : (@name) ->
    super(@name)
  
module.exports = new PromotionRequestController()