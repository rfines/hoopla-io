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

facebookEvent = (promotionRequest, cb) ->
  event = {
    name : 'Adams Super Party'
    start_time: moment().add('d', 7).toISOString()
  }
  graph.post "me/events", event, (err, res) ->
    console.log err
    console.log res
    cb(err)

module.exports.publish = (promotionRequest, cb) ->
  console.log promotionRequest
  switch promotionRequest.pushType
    when 'FACEBOOK-EVENT' then facebookEvent(promotionRequest, cb)
    when 'FACEBOOK-POST' then facebookPost(promotionRequest, cb)
    else
      console.log 'unsupported type'
    


 