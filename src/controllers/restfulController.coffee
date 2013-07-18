mongoose = require 'mongoose'
_ = require 'lodash'

class RestfulController

  search : (req, res, next) =>
    query = {}
    @Model.find query, (err, data) ->
      res.send data
      next()

  get : (req, res, next) =>
    id = req.params.id
    checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$")
    if not checkForHexRegExp.test(id)
      @Model.findOne {legacyId : req.params.id}, (err, data) ->
        res.send 200, data
        next()
    else
      @Model.findById req.params.id, (err, data) ->
        res.send 200, data
        next()

  destroy: (req, res, next) =>
    @Model.remove {'_id' : req.params.id}, (err, doc) ->
      res.send(204)
      next()        

module.exports = RestfulController