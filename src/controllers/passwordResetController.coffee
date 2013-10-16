CONFIG = require('config')
mongoose = require 'mongoose'
ss = require('../services/searchService')
async = require 'async'
Business = require('hoopla-io-core').Business
Event = require('hoopla-io-core').Event

class PasswordResetController

  passwordReset : require('hoopla-io-core').PasswordReset
  emailService : require('../services/emailService')
  tokenService : require '../services/tokenService'
  bcryptService : require('../services/bcryptService')
  user : require('hoopla-io-core').User

  constructor : (@name) ->

  requestResetEmail : (req, res, next) =>  
    body = req.body
    pr = new @passwordReset()
    pr.email = body.email
    pr.requestDate = new Date()
    @user.findOne {email: body.email}, {}, {lean:true}, (err, doc) =>
      if not doc
        templateName = 'password-reset-request-bad-user'
      else
        templateName = 'password-reset-request'
      pr.token = @tokenService.generateWithTimestamp(12)
      pr.save (err, data) =>
        emailOptions =
          message: 
            'to' : [{email:pr.email}]
            'global_merge_vars' : [
              {name : 'PASSWORD_RESET_URL', content : "#{CONFIG.hooplaIoWeb.pwResetUrl}?token=#{pr.token}"}
              {name : 'EMAIL', content : pr.email}
              {name : 'REGISTER_URL', content : "#{CONFIG.hooplaIoWeb.registerUrl}"}
            ]
          template_name : templateName
          template_content : []
        @emailService.send emailOptions, ->    
          res.send 201
          next()  

  resetPassword : (req, res, next) =>
    body = req.body
    @passwordReset.findOne {email: body.email, token : body.token}, {_id:1}, {}, (err, reset) =>
      if not err and reset?._id
        @user.findOne {email : body.email}, {}, {}, (err, u) =>
          if not err and u?._id
            @bcryptService.encrypt body.password, (encrypted) =>
              u.update { $set : {password: encrypted, encryptionMethod: 'BCRYPT'}}, {}, (err) =>
                reset.update {completedDate : new Date()}, {}, (err) ->
                  res.send 200
                  next()
          else
            res.send 401
            next()
      else
        res.send 401
        next()

module.exports =  new PasswordResetController()

