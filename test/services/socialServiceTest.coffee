mongoose = require 'mongoose'
sinon = require 'sinon'
CONFIG = require 'config'
socialService = require '../../src/services/socialService'
#,{"_id":'51f690f372e5875c3f00ca16', url:"http://res.cloudinary.com/durin-software/image/upload/v1375113455/p3ux4buvr7ayhbeykoiq.jpg"}
describe "Social Service Tests", ->
  promotionRequest = {}
  promotionTarget = {}
  ###
  it "should post a tweet to the users twitter account without an image", (done)->
    promotionRequest=
      "_id" : '23434'
      pushType:"TWITTER-POST"
      promotionTarget: { 
        "_id" : '123'
        accountType: 'TWITTER'
        accessToken:  CONFIG.twitter.my_access_token
        accessTokenSecret: CONFIG.twitter.my_access_token_secret
      }
      message: 'Test tweet from Hoopla.io'
      location: 'Robs Bar and Grill'
      status: {}
    socialService.publish promotionRequest, (err, reply)->
      err.should.equal(null)
      done()

  it "should post a tweet to the users twitter account with images", (done)->
    promotionRequest=
      "_id" : '23434'
      pushType:"TWITTER-POST"
      promotionTarget: { 
        "_id" : '123'
        accountType: 'TWITTER'
        accessToken:  CONFIG.twitter.my_access_token
        accessTokenSecret: CONFIG.twitter.my_access_token_secret
      }
      message: 'Test tweet from Hoopla.io with images.'
      location: 'Robs Bar and Grill'
      media : [{"_id":'51f690f372e5875c3f00ca17', url:"http://res.cloudinary.com/durin-software/image/upload/v1375113455/p3ux4buvr7ayhbeykoiq.jpg"}]
      status: {}
    socialService.publish promotionRequest, (err, reply)->
      err.should.equal(null)
      done()
  ###