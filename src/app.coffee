mongoService = require './services/mongoService'
restifyFactory = require './services/restifyFactory'

mongoService.init()
server = restifyFactory.build()

require('./services/cacheService')
require('./services/searchService').init()

console.log 'email time'
process.env.MANDRILL_APIKEY = '1Vv5fCA7NHi63vYkKvaa7g'
process.env.MANDRILL_USERNAME = 'app17015048@heroku.com'

#emailService = require('./services/emailService')
#emailService.send()