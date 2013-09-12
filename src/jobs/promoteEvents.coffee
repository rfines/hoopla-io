_ = require 'lodash'
promotionRequest = require('../models/promotionRequest').PromotionRequest
async = require 'async'
ss = require '../services/socialService'

module.exports.runOnce = (onComplete) ->
  promote = (item, cb) ->
    ss.publish item, (err,id) ->
      if err
        item.update {$set : {'status.code' : 'FAILED', 'status.lastError' : err}, $inc : {'status.retryCount' : 1}}, (err) ->
          cb err
      else        
        item.update {$set : {'status.code' : 'COMPLETE','status.postId' :id, 'status.completedDate' : new Date()}}, (err) ->
          cb(err)
  q = promotionRequest.find { 'status.code' : {$ne : 'COMPLETE'},'promotionTime':{$lte :new Date()}, 'status.retryCount' : {$lt : 3}}
  q.populate('promotionTarget')
  q.populate('media')
  q.exec (err, data) ->
    async.eachLimit data, 10, promote, (err) ->
      onComplete() if onComplete


