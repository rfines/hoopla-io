graph = require('fbgraph')
moment = require 'moment'

facebookPost = (socialMediaPushRequest, cb) ->
  content = socialMediaPushRequest.content  
  graph.setAccessToken socialMediaPushRequest.socialMediaAccount.accessToken
  wallPost = {
    message: content
  }

  graph.post "me/feed", wallPost, (err, res) ->
    cb()

facebookEvent = (socialMediaRequest, cb) ->
  event = {
    name : 'Adams Super Party'
    start_time: moment().add('d', 7).toISOString()
  }
  graph.post "me/events", event, (err, res) ->
    console.log err
    console.log res
    cb()

module.exports.publish = (socialMediaPushRequest, cb) ->
  switch socialMediaPushRequest.pushType
    when 'FACEBOOK-EVENT' then facebookEvent(socialMediaPushRequest, cb)
    when 'FACEBOOK-POST' then facebookPost(socialMediaPushRequest, cb)
    else
      console.log 'unsupported type'
    


 