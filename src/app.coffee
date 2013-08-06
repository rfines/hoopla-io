mongoService = require './services/mongoService'
restifyFactory = require './services/restifyFactory'

mongoService.init()
server = restifyFactory.build()

require('./services/cacheService')
require('./services/searchService').init()