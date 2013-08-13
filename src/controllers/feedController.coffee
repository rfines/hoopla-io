_ = require 'lodash'
RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')
SearchQuery = require('./helpers/SearchQuery')

class FeedController extends RestfulController
  model : require('../models/feed').Feed
  event : require('../models/event').Event
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
      criteria = new SearchQuery().ofCoordinates(data.geo.coordinates[0], data.geo.coordinates[1]).within(data.radius).build()
      @event.find criteria, {}, {lean:true}, (err, data) ->
        res.send 200, data

module.exports = new FeedController()