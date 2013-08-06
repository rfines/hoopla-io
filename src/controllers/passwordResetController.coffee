mongoose = require 'mongoose'
ss = require('../services/searchService')
async = require 'async'
Business = require('../models/business').Business
Event = require('../models/event').Event

class PasswordResetController

  PasswordReset : require('../models/passwordReset').PasswordReset
  
  constructor : (@name) ->

  requestResetEmail : (req, res, next) =>  
    body = JSON.parse(req.body.toString())
    console.log 'ready to save'
    pr = new @PasswordReset(body)
    pr.save (err, data) ->
      res.send 200
      next()  

  resetPassword : (req, res, next) =>
    next()

module.exports =  new PasswordResetController()

