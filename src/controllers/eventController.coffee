mongoose = require 'mongoose'

class EventController
  #Model : require('../models/event').Event

  constructor : (@name) ->

  get : (req, res, next) =>
  	res.send {Hello : 'World6'}
  	next()

  getSecret : (req, res, next) =>
  	res.send {Hello : 'Secret'}
  	next()	

module.exports = new EventController()