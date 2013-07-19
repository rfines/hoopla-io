mongoose = require 'mongoose'
User = require('../models/user').User

authorize = (authorization, onAuthorized, onUnAuthorized) ->
  if authorization.basic and authorization.basic.username and authorization.basic.password
    q = {'applications.apiKey' : authorization.basic.username, 'applications.apiSecret' : authorization.basic.password}
    User.findOne q, (err, data) ->
      if data
        onAuthorized()
      else
        onUnAuthorized 'Invalid api key or secret.'
  else
    onUnAuthorized 'HTTP Basic Authorization is required.'

module.exports =
  authorize : authorize