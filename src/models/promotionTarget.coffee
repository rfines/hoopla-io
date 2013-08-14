mongoose = require('mongoose')
ObjectId = mongoose.Schema.ObjectId

PromotionTargetSchema = new mongoose.Schema
  accountType :
    type : String
    enum: ['TWITTER', 'FACEBOOK']
  accessToken: String
  accessTokenSecret: String

module.exports = 
  PromotionTarget : mongoose.model('promotionTarget', PromotionTargetSchema, 'promotionTarget')
  PromotionTargetSchema : PromotionTargetSchema