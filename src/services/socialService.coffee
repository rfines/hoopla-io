CONFIG = require('config')
graph = require('facebook-complete')
moment = require 'moment'
twit = require('twit')
_ = require('lodash')
_request = require('request')
Events = require('hoopla-io-core').Event
eventUtils = require('../utils/eventUtils')
moment = require 'moment'
bitly = require 'bitly'

facebookPost = (promotionRequest, cb) ->
  content = promotionRequest.message  
  page = promotionRequest.pageId
  des = ""
  if promotionRequest.description
    des = promotionRequest.description
  else
    des = promotionRequest.caption
  wallPost = {
    message: content
    caption: promotionRequest.caption
    name: promotionRequest.title
    description: des
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
  if pr.title.length > 74
    pr.title = textCutter(70,pr.title)
  event = {
    name : pr.title
    start_time: moment(pr.startTime).utc().toDate().toISOString()
    description : pr.caption
    ticket_uri: pr.ticket_uri
    picture: pr.media[0]?.url
    location: pr.location
    edit: pr.edit if pr.edit
  }
  page = pr.pageId 
  if page? and pr.pageAccessToken?
    graph.setAccessToken pr.pageAccessToken
    url="#{page}/events/"
  else
    graph.setAccessToken pr.promotionTarget?.accessToken
    url="me/events/"
  graph.postEvent "#{url}", event, (err, res) ->
    cb(err, res.id)

module.exports.readFacebookPostInsights = (pr,cb)=>
  if pr.status?.postId
    page = pr.pageId
    if page? and pr.pageAccessToken?
      graph.setAccessToken pr.pageAccessToken
    else
      graph.setAccessToken pr.promotionTarget?.accessToken
    url = "#{pr.status.postId}/insights"
    graph.readInsights url,(err,response)=>
        cb err, response
  else
    cb {success:false, message:"Insights are only available for items already posted"}, null

module.exports.batchFacebookRequests = (ev, cb)=>
  if ev.promotionRequests and ev.promotionRequests.length >0
    batch = []
    ids = []
    pr = {}
    console.log ev.promotionRequests.length
    iterator = (element, index, list)=>
      if element.status.postId and element.pushType.indexOf 'FACEBOOK-POST'
        pr = element
        ids.push element.status.postId
        batch.push encodeURIComponent(JSON.stringify({"method":"GET", "relative_url":"#{element.status.postId}/insights"}))

    _.each ev.promotionRequests, iterator
    if batch.length>0
      if pr.pageAccessToken and pr.pageId
        graph.setAccessToken pr.pageAccessToken
      else
        graph.setAccessToken pr.promotionTarget?.accessToken
      graph.batch {batch:batch}, (err, insights)=>
        console.log err
        console.log insights
        cb err, insights

twitterPost = (pr, cb) ->
  tw = new twit({ 
    consumer_key:CONFIG.twitter.consumer_key,
    consumer_secret:CONFIG.twitter.consumer_secret,
    access_token:pr.promotionTarget.accessToken,
    access_token_secret: pr.promotionTarget.accessTokenSecret
  })
  if pr.link
    bitlyShorten pr.link, (err, url)=>
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

detectUrl = (text, cb)=>
  exp = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
  text.replace exp, (match)->
    bitlyShorten match, (err, shorter)=>
      return shorter
      cb null, text

textCutter = (i, text) ->
  short = text.substr(0, i)
  return short.replace(/\s+\S*$/, "")  if /^\S/.test(text.substr(i))
  short

module.exports.publish = (promotionRequest, cb) ->
  switch promotionRequest.pushType
    when 'FACEBOOK-EVENT' then facebookEvent(promotionRequest, cb)
    when 'FACEBOOK-POST' then facebookPost(promotionRequest, cb)
    when 'TWITTER-POST' then twitterPost(promotionRequest, cb)
    else
      cb "Unsupported type error"