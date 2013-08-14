graph = require('fbgraph')
moment = require 'moment'

facebookPost = (promotionRequest, cb) ->
  content = promotionRequest.content  
  graph.setAccessToken promotionRequest.promotionTarget.accessToken
  wallPost = {
    message: content
  }
  graph.post "me/feed", wallPost, (err, res) ->
    cb(err)

facebookEvent = (pr, cb) ->
  event = {
    name : pr.title
    start_time: pr.startTime
    descrition : pr.message
  }
  graph.post "me/events", event, (err, res) ->
    cb(err)

twitterPost = (pr, cb) ->
  cb null

module.exports.publish = (promotionRequest, cb) ->
  switch promotionRequest.pushType
    when 'FACEBOOK-EVENT' then facebookEvent(promotionRequest, cb)
    when 'FACEBOOK-POST' then facebookPost(promotionRequest, cb)
    when 'TWITTER-POST' then twitterPost(promotionRequest, cb)
    else
      console.log 'unsupported type'