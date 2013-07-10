CONFIG = require('config')

init = ->
  mongoose = require('mongoose')
  mongoose.connect(CONFIG.database)


module.exports =
  init : init