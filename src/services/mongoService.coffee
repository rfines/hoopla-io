mongoose = require('mongoose')
CONFIG = require('config')

init = ->
  db = process.env.MONGOHQ_URL || CONFIG.database
  mongoose.connect db
  mongoose.connection.on 'error', (err) ->
    console.log err

module.exports =
  init : init