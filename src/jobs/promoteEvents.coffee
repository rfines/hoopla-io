_ = require 'lodash'
promotionRequest = require('hoopla-io-core').PromotionRequest
async = require 'async'
ss = require '../services/socialService'

module.exports.runOnce = (onComplete) ->
  promote = (item, cb) ->
    ss.publish item, (erra,id) =>
      retryCount = item.status?.retryCount
      retryCount = retryCount+1
      if erra
        item.update {$set : {'status.code' : 'FAILED', 'status.lastError' : erra}, $inc : {'status.retryCount' : retryCount}}, (erro) ->
          cb erro
      else
        if _.isObject id
          postId = id.id
        else 
          postId = id
        item.update {$set : {'status.code' : 'COMPLETE','status.postId' :postId, 'status.completedDate' : new Date(),'status.retryCount' : retryCount}}, (error) ->
          cb(error)
  q = promotionRequest.find { 'status.code' : {$ne : 'COMPLETE'},'promotionTime':{$lte :new Date()}, 'status.retryCount' : {$lt : 3}}
  q.populate('promotionTarget')
  q.populate('media')
  q.exec (errw, data) ->
    console.log data
    async.eachLimit data, 2, promote, (errn) ->
      onComplete() if onComplete


