PostalCode = require('../models/postalCode').PostalCode
cache = require('../services/cacheService')

module.exports.get = (code, cb) ->
  cache.get "POSTALCODE:#{code}" , (error, value, extras) ->
      if not error and not value
        console.log 'actually looking up a postal code'
        PostalCode.findOne {'code':code}, {}, {lean:true}, (err,doc) ->
          cache.setex "POSTALCODE:#{code}", 2592000, JSON.stringify(doc)
          cb(err, doc) if cb
      else
        cb null, JSON.parse(value)