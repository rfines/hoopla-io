mongoose = require('mongoose')
ObjectId = mongoose.Schema.ObjectId
socialMediaAccountSchema = require('./socialMediaAccount').SocialMediaAccountSchema

PromotionRequestSchema = new mongoose.Schema
  pushType : String
  title : String
  message: String
  startTime : Date
  location : String
  socialMediaAccount : {type: ObjectId, ref:'socialMediaAccount'}


module.exports = 
  PromotionRequest : mongoose.model('promotionRequest', PromotionRequestSchema, 'promotionRequest')
  PromotionRequestSchema : PromotionRequestSchema