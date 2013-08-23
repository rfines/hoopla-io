_ = require 'lodash'
RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')

class MediaController extends RestfulController
  model = require('../models/media')

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
  constructor : (@name) ->
    super(@name)
  upload:(req,res, next)->
    savePath = 'https://res.cloudinary.com'
