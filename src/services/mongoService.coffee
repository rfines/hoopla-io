mongoose = require('mongoose')
CONFIG = require('config')

init = ->
  mongoose.connect CONFIG.database
  mongoose.connection.on 'error', (err) ->
    console.log err

module.exports =
  init : init