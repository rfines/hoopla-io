_ = require 'lodash'
promotionRequest = require('../models/promotionRequest').PromotionRequest
mongoService = require '../services/mongoService'
async = require 'async'
ss = require '../services/socialService'

mongoService.init()

module.exports.runOnce = ->
  console.log 'hi'
  promote = (item, cb) ->
    ss.publish item, (err) ->
      console.log err
      if err
        item.update {$set : {'status.code' : 'FAILED', 'status.lastError' : err}, $inc : {'status.retryCount' : 1}}, (err) ->
          cb err
      else        
        item.update {$set : {'status.code' : 'COMPLETE', 'status.completedDate' : new Date()}}, (err) ->
          cb(err)
  q = promotionRequest.find { 'status.code' : {$ne : 'COMPLETE'}, 'status.retryCount' : {$lt : 3}}
  q.populate('promotionTarget')
  q.exec (err, data) ->
    console.log err
    console.log data
    async.eachLimit data, 10, promote, (err) ->
      if err
        console.log err
        process.exit 1
      else
        process.exit 0


