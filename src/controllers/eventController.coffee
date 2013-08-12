_ = require 'lodash'
SearchableController = require('./searchableController')
securityConstraints = require('./helpers/securityConstraints')

class EventController  extends SearchableController
  model : require('../models/event').Event
  type: 'event'
  populate: ['media']
  hooks: require('./hooks/eventHooks')
  
  security: 
    get : securityConstraints.anyone
    destroy : (authenticatedUser, event) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.businessId?.equals(event.businessId)
      return not _.isUndefined(ownerMatch)      
    update : (authenticatedUser, target) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.businessId?.equals(event.businessId)
      return not _.isUndefined(ownerMatch)  
    create : (authenticatedUser, target) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv?.businessId?.equals(event.businessId)
      return not _.isUndefined(ownerMatch)  

  constructor : (@name) ->
    super(@name)  

module.exports = new EventController()