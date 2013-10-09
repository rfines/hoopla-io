mongoose = require 'mongoose'
User = require('../models/user').User
_ = require 'lodash'

authorize = (req, onAuthorized, onUnAuthorized) ->
  authorization = req.authorization
  if authorization.basic and authorization.basic.username and authorization.basic.password
    q = {'applications.apiKey' : authorization.basic.username, 'applications.apiSecret' : authorization.basic.password}
    User.findOne q, (err, data) ->
      if data
        app = _.find data.applications, (item)=>
          return item.apiKey is authorization.basic.username
        onAuthorized(app)
      else
        onUnAuthorized 'Invalid api key or secret.'
  else if req.params.apiKey
    q = {'applications.legacyKey': req.params.apiKey}
    User.findOne q,(err,data) ->
      if data
        app = _.find data.applications,{'legacyKey':req.params.apiKey}
        if app
          req.authorization = {basic: {username:app.apiKey, password:app.apiSecret}}
        onAuthorized(app)
      else
        onUnAuthorized 'Invalid api key.'
  else
    onUnAuthorized 'HTTP Basic Authorization is required.'

module.exports =
  authorize : authorize