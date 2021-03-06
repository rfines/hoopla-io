_ = require 'lodash'
promotionRequest = require('hoopla-io-core').PromotionRequest
async = require 'async'
moment = require 'moment'
ss = require '../services/socialService'

module.exports.runOnce = (onComplete) ->
  promote = (item, cb) ->
    ss.publish item, (erra,id) =>
      retryCount = item.status?.retryCount || 0
      if erra
        retryCount = retryCount+1
        item.update {$set : {'status.code' : 'FAILED', 'status.lastError' : erra}, $inc : {'status.retryCount' : retryCount}}, (erro) ->
          cb erro
      else
        if _.isObject id
          postId = id.id
        else 
          postId = id
        console.log "$$$$$$$$$$ POST ID $$$$$$$$$$$$$$$$$$"
        console.log postId
        item.update {$set : {'status.code' : 'COMPLETE','status.postId' :postId, 'status.completedDate' : new Date(),'status.retryCount' : retryCount}}, (error) ->
          console.log "promotion request updated to complete"
          cb(error)
  q = promotionRequest.find { 'status.code' : "WAITING",'promotionTime':{$lte :new Date()}, 'status.retryCount' : {$lt : 3}}
  q.populate('promotionTarget')
  q.populate('media')
  q.exec (errw, data) ->
    async.eachLimit data, 4, promote, (errn) ->
      onComplete() if onComplete


