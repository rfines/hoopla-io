mongoose = require 'mongoose'

class RestfulController

  search : (req, res, next) =>
    query = {}
    @Model.find query, (err, data) ->
      res.send data
      next()

  get : (req, res, next) =>
    @Model.findById req.params.id, (err, data) ->
      res.send data
      next()

  getSecret : (req, res, next) =>
    res.send {Hello : 'Secret'}
    next()  

module.exports = RestfulController