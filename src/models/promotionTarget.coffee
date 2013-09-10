mongoose = require('mongoose')
ObjectId = mongoose.Schema.ObjectId

PromotionTargetSchema = new mongoose.Schema
  accountType :
    type : String
    enum: ['TWITTER', 'FACEBOOK']
  accessToken: String
  accessTokenSecret: String
  profileImageUrl: String
  profileName: String
  profileCoverPhoto:String
  profileId: String
  expiration: Date

module.exports = 
  PromotionTarget : mongoose.model('promotionTarget', PromotionTargetSchema, 'promotionTarget')
  PromotionTargetSchema : PromotionTargetSchema