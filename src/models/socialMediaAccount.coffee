mongoose = require('mongoose')
ObjectId = mongoose.Schema.ObjectId

SocialMediaAccountSchema = new mongoose.Schema
  accountType :
    type : String
    enum: ['TWITTER', 'FACEBOOK']
  accessToken: String
  accessTokenSecret: String

module.exports = 
  SocialMediaAccount : mongoose.model('socialMediaAccount', SocialMediaAccountSchema, 'socialMediaAccount')
  SocialMediaAccountSchema : SocialMediaAccountSchema