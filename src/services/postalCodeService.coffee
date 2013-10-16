PostalCode = require('hoopla-io-core').PostalCode
cache = require('../services/cacheService')
_ = require 'lodash'

module.exports.get = (code, cb) ->
  cache.get "POSTALCODE:#{code}" , (error, value, extras) ->
      if error or (not value or value is 'null')
        PostalCode.findOne {'code':code}, {}, {lean:true}, (err,doc) ->
          cache.setex "POSTALCODE:#{code}", 2592000, JSON.stringify(doc)
          cb(err, doc) if cb
      else
        cb null, JSON.parse(value)