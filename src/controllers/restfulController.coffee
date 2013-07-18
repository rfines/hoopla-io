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
        res.send data
        next()
    else
      @Model.findById req.params.id, (err, data) ->
        res.send data
        next()

  getSecret : (req, res, next) =>
    res.send {Hello : 'Secret'}
    next()  

module.exports = RestfulController