restify = require("restify")
securityConstraints = require('./helpers/securityConstraints')
Event = require('hoopla-io-core').Event

class CurationController

  getEventBatch : (req, res, next) =>  
    query = {}
    Event.find {}, {}, {limit: 100}, (err, data) ->
      res.send data
      next()

module.exports = new CurationController()
