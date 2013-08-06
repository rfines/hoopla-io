CONFIG = require('config')
mongoose = require 'mongoose'
ss = require('../services/searchService')
async = require 'async'
Business = require('../models/business').Business
Event = require('../models/event').Event

class PasswordResetController

  PasswordReset : require('../models/passwordReset').PasswordReset
  emailService : require('../services/emailService')
  tokenService : require '../services/tokenService'

  constructor : (@name) ->

  requestResetEmail : (req, res, next) =>  
    body = req.body
    console.log body
    pr = new @PasswordReset()
    pr.email = body.email
    pr.token = @tokenService.generateWithTimestamp(12)
    pr.requestDate = new Date()
    pr.save (err, data) =>
      emailOptions =
        message: 
          'to' : [{email:pr.email}]
        template_name : 'password-reset-request'
        template_content : [{PASSWORD_RESET_URL  : "#{CONFIG.hooplaIoWeb.pwResetUrl}?token=#{pr.token}"}]
      console.log 'call send'
      @emailService.send emailOptions, ->    
        res.send 201
        next()  

  resetPassword : (req, res, next) =>
    next()

module.exports =  new PasswordResetController()

