_ = require 'lodash'
RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')

class SocialMediaAccountController extends RestfulController
  model : require('../models/socialMediaAccount').SocialMediaAccount
  getFields : {}
  hooks : require('./hooks/restfulHooks.coffee')

  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : securityConstraints.hasAuthUser
    destroy : securityConstraints.hasAuthUser

  constructor : (@name) ->
    super(@name)

module.exports = new SocialMediaAccountController()