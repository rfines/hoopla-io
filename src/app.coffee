CONFIG = require('config')
mongoService = require './services/mongoService'
restifyFactory = require './services/restifyFactory'
cloudinaryService = require './services/cloudinaryService'

mongoService.init()
cloudinaryService.init()
server = restifyFactory.build()

require('./services/cacheService')
require('./services/searchService').init()

require('./scheduler').start() if CONFIG.jobs.run