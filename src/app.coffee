process.on 'uncaughtException', (err) ->
  console.log 'caught unhandled exception:'
  console.log err.stack || err
CONFIG = require('config')
mongoService = require './services/mongoService'
restifyFactory = require './services/restifyFactory'
cloudinaryService = require './services/cloudinaryService'

mongoService.init()
cloudinaryService.init()
server = restifyFactory.build()
mc = require('./services/mailchimpService').init()
require('./services/cacheService')
require('./services/searchService').init()

require('./scheduler').start() if CONFIG.jobs.run