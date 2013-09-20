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
  hooks : require('./hooks/widgetHooks.coffee')
  constructor : (@name) ->
    super(@name)

  getResults : (req, res, next) =>
    id = req.params.id
    fields = {}
    @model.findById id, (err, data) =>
      if data
        if data.widgetType is 'event-by-business'
          criteria = {'business': {$in : data.businesses}}
        else
          sq = new SearchQuery().ofCoordinates(data.location.geo.coordinates[0], data.location.geo.coordinates[1]).within(data.radius)
          sq.withTags(data.tags) if data.tags and data.tags.legnth > 0
          criteria = sq.build()
        criteria['occurrences.start'] = {$gte : new Date()}
        q = @event.find criteria, fields, {lean:true}
        q.populate('business', 'name')
        q.exec (err, data) ->
          if err 
            res.send err.code || 500, err.message || "Internal Error Occurred"
          else
            res.send 200, data
          next()
      else
        res.send 404
        next()

  getForUser : (req, res, next) =>
    if req.params.id
      @model.find {"user": req.params.id}, {}, {lean:true}, (err, widgets)=>
        if err
          res.status = 400
          res.send({ success: false, error: "Could not find widgets for this user." }, { 'Content-type': 'application/json' }, 400)
          next()
        else
          res.send 200, widgets
          next()  
          
module.exports = new WidgetController()