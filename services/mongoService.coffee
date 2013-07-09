CONFIG = require('config')
User = require('../models/user').User

init = ->
  mongoose = require('mongoose')
  mongoose.connect(CONFIG.database)
  ###
  u = new User({email: 'adamIsTheBestEver@gmail.com '})
  u.save (err) ->
    console.log err
  ###


module.exports =
  init : init