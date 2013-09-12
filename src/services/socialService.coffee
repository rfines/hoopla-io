CONFIG = require('config')
graph = require('fbgraph')
moment = require 'moment'
twit = require('twit')
_ = require('lodash')
_request = require('request')
Events = require('../models/event').Event
eventUtils = require('../utils/eventUtils')
moment = require 'moment'

facebookPost = (promotionRequest, cb) ->
  content = promotionRequest.message  
  page = promotionRequest.pageId
  event = Events.findOne {'promotionRequests':promotionRequest._id}, {},{lean:true}, (err,doc)=>
    if err
      console.log err
      cb err, null
    else
      nextOcc = eventUtils.nextOccurrence(doc)
      console.log nextOcc
      wallPost = {
        message: content
        caption: "Date: #{nextOcc.format('MMM DD, YYYY')}\nTime: #{moment(nextOcc).format("h:mm A")}"
        name: promotionRequest.title
        description: "#{doc.location.address}"
        link: promotionRequest.link
        picture: promotionRequest.media[0]?.url
      }
      console.log "Posting status update to feed with this id:"
      console.log page
      if page?.length > 0 && promotionRequest.pageAccessToken.length > 0
        graph.setAccessToken promotionRequest.pageAccessToken
        url="#{page}/feed/"
      else
        graph.setAccessToken promotionRequest.promotionTarget?.accessToken
        url="me/feed/"
      graph.post "#{url}", wallPost, (err, res) ->
        console.log err?.message
        console.log res
        cb(err,res?.id)


facebookEvent = (pr, cb) ->
  console.log pr
  event = {
    name : pr.title
    start_time: moment(pr.startTime).toDate().toISOString()
    description : pr.message
    ticket_uri: pr.ticket_uri
    picture: pr.media[0]?.url
    location: pr.location

  }
  page = pr.pageId
  if page?.length > 0 && pr.pageAccessToken.length > 0
    graph.setAccessToken pr.pageAccessToken
    url="#{page}/events/"
  else
    graph.setAccessToken pr.promotionTarget?.accessToken
    url="me/events/"
  
  graph.post "#{url}", event, (err, res) ->
      console.log err?.message 
      console.log res
      cb(err, res.id)

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
    console.log reply
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