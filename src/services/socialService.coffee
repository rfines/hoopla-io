CONFIG = require('config')
graph = require('fbgraph')
moment = require 'moment'
twit = require('twit')
_ = require('lodash')
_request = require('request')
Events = require('../models/event').Event
eventUtils = require('../utils/eventUtils')
moment = require 'moment'
bitly = require 'bitly'

facebookPost = (promotionRequest, cb) ->
  content = promotionRequest.message  
  page = promotionRequest.pageId
  event = Events.findOne {'promotionRequests':promotionRequest._id}, {},{lean:true}, (err,doc)=>
    if err
      cb err, null
    else
      nextOcc = eventUtils.nextOccurrence(doc)
      wallPost = {
        message: content
        caption: "Date: #{nextOcc.format('MMM DD, YYYY')}\nTime: #{moment(nextOcc).format("h:mm A")}"
        name: promotionRequest.title
        description: "#{doc.location.address}"
        link: promotionRequest.link
        picture: promotionRequest.media[0]?.url
      }
      if page? and promotionRequest.pageAccessToken?
        graph.setAccessToken promotionRequest.pageAccessToken
        url="#{page}/feed/"
      else
        graph.setAccessToken promotionRequest.promotionTarget?.accessToken
        url="me/feed/"
      graph.post "#{url}", wallPost, (err, res) ->
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
  console.log page
  console.log pr.pageAccessToken
  if page? and pr.pageAccessToken?
    console.log 'if block'
    graph.setAccessToken pr.pageAccessToken
    url="#{page}/events/"
  else
    console.log 'else block'
    graph.setAccessToken pr.promotionTarget?.accessToken
    url="me/events/"
  graph.post "#{url}", event, (err, res) ->
    console.log '3'
    cb(err, res?.id)

twitterPost = (pr, cb) ->
  tw = new twit({ 
    consumer_key:CONFIG.twitter.consumer_key,
    consumer_secret:CONFIG.twitter.consumer_secret,
    access_token:pr.promotionTarget.accessToken,
    access_token_secret: pr.promotionTarget.accessTokenSecret
  })

  if pr.media?.length > 0
    bitlyShorten pr.media[0].url, (err, url)=>
      status = {status:pr.message+'\n'+ url }
      tw.post 'statuses/update', status, (error, reply)->
        if error
          cb error, null
        else
          cb null, reply?.id
  else
    status = {status:pr.message}
    tw.post 'statuses/update', status, (error, reply)->
      if error
        cb error, null
      else
        cb null, reply?.id

bitlyShorten=(url, cb)=>
  bit = new bitly(CONFIG.bitly.username, CONFIG.bitly.apiKey)
  bit.shorten url, (err,response) =>
    if not response.status_code is 200
      cb err, ''
    else
      cb null, response.data.url

module.exports.publish = (promotionRequest, cb) ->
  console.log promotionRequest.pushType
  switch promotionRequest.pushType
    when 'FACEBOOK-EVENT' then facebookEvent(promotionRequest, cb)
    when 'FACEBOOK-POST' then facebookPost(promotionRequest, cb)
    when 'TWITTER-POST' then twitterPost(promotionRequest, cb)
    else
      cb "Unsupported type error"