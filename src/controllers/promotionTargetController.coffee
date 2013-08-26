RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')

class PromotionTargetController extends RestfulController
  model : require('../models/promotionTarget').PromotionTarget
  getFields : {}
  hooks : require('./hooks/restfulHooks.coffee')

  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : securityConstraints.hasAuthUser
    destroy : securityConstraints.hasAuthUser

  constructor : (@name) ->
    super(@name)

module.exports = new PromotionTargetController()