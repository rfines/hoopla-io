_ = require 'lodash'
RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')
SearchQuery = require('./helpers/SearchQuery')

class FeedController extends RestfulController
  model : require('hoopla-io-core').Feed
  event : require('hoopla-io-core').Event
  getFields : {}
  hooks : require('./hooks/restfulHooks.coffee')

  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : securityConstraints.hasAuthUser
    destroy : securityConstraints.hasAuthUser

  constructor : (@name) ->
    super(@name)

  getResults : (req, res, next) =>
    id = req.params.id
    @model.findById id, (err, data) =>
      if err
        res.send 401, err
      else
        criteria = new SearchQuery().ofCoordinates(data.geo.coordinates[0], data.geo.coordinates[1]).within(data.radius).withTags(data.tags).build()
        @event.find criteria, {}, {lean:true}, (err, d) ->
          if err
            res.send 400, err
          else
            res.send 200, d

module.exports = new FeedController()