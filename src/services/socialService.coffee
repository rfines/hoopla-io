CONFIG = require('config')
graph = require('fbgraph')
moment = require 'moment'
twit = require('twit')
_ = require('lodash')
_request = require('request')

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
  tw = new twit({ 
    consumer_key:CONFIG.twitter.consumer_key,
    consumer_secret:CONFIG.twitter.consumer_secret,
    access_token:pr.promotionTarget.accessToken,
    access_token_secret: pr.promotionTarget.accessTokenSecret
  })
  if pr.media
    status = {status:pr.message+' '+pr.media[0].url}
  else
    status = {status:pr.message}

  tw.post 'statuses/update', status, (error, reply)->
    if error
      cb error, null
    else
      console.log reply
      cb null, reply

module.exports.publish = (promotionRequest, cb) ->
  switch promotionRequest.pushType
    when 'FACEBOOK-EVENT' then facebookEvent(promotionRequest, cb)
    when 'FACEBOOK-POST' then facebookPost(promotionRequest, cb)
    when 'TWITTER-POST' then twitterPost(promotionRequest, cb)
    else
      cb "Unsupported type error"