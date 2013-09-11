CONFIG = require('config')
graph = require('fbgraph')
moment = require 'moment'
twit = require('twit')
_ = require('lodash')
_request = require('request')

facebookPost = (promotionRequest, cb) ->
  content = promotionRequest.message  
  page = promotionRequest.pageId
  wallPost = {
    message: content
  }
  console.log "Posting status update to feed with this id:"
  console.log page
  if page.length > 0 && promotionRequest.pageAccessToken.length > 0
    graph.setAccessToken promotionRequest.pageAccessToken
    graph.post "#{{page}}/feed/", wallPost, (err, res) ->
      console.log err?.message
      console.log res
      cb(err)
  else
    graph.setAccessToken promotionRequest.promotionTarget.accessToken
    graph.post "me/feed/", wallPost, (err, res) ->
      console.log err?.message
      console.log res
      cb(err)

facebookEvent = (pr, cb) ->
  event = {
    name : pr.title
    start_time: moment(pr.startTime).toDate().toISOString()
    description : pr.message
    picture: pr.media[0]?.url

  }
  page = pr.pageId
  if page.length > 0 && pr.pageAccessToken.length > 0
    graph.setAccessToken pr.pageAccessToken
    console.log page
    graph.post "#{{page}}/events", event, (err, res) ->
      console.log err?.message 
      console.log res
      cb(err)
  else
    graph.setAccessToken pr.promotionTarget.accessToken
    graph.post "me/events/", wallPost, (err, res) ->
      console.log err?.message
      console.log res
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