RestfulController = require('./restfulController')
_ = require 'lodash'
securityConstraints = require('./helpers/securityConstraints')
SearchQuery = require('./helpers/SearchQuery')

class WidgetController extends RestfulController
  model : require('../models/widget').Widget
  event : require('../models/event').Event
  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : securityConstraints.hasAuthUser
    destroy : securityConstraints.hasAuthUser
  getFields:{}
  hooks : require('./hooks/restfulHooks.coffee')
  constructor : (@name) ->
    super(@name)

  getResults : (req, res, next) =>
    id = req.params.id
    @model.findById id, (err, data) =>
      if data.businessId
        criteria = {'business': data.businessId}
      else
        criteria = new SearchQuery().ofCoordinates(data.geo.coordinates[0], data.geo.coordinates[1]).within(data.radius).withTags(data.tags).build()
      @event.find criteria, {}, {lean:true}, (err, data) ->
        if err 
          console.log err
          res.send err.code || 500, err.message || "Internal Error Occurred"
        else
          res.send 200, data
module.exports = new WidgetController()