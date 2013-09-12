mongoose = require('mongoose')
ObjectId = mongoose.Schema.ObjectId
require('./promotionTarget').PromotionTargetSchema

PromotionRequestSchema = new mongoose.Schema
  pushType : String
  title : String
  message: String
  startTime : Date
  location : String
  pageId: String
  pageAccessToken:String
  ticket_uri: String
  link: String
  caption:String
  promotionTime: Date
  promotionTarget : {type: ObjectId, ref:'promotionTarget'}
  media:[{type : ObjectId, ref : 'media'}]
  status : {
    postId:String
    code :
      type: String
      default: 'WAITING'
      enum: ['WAITING', 'COMPLETE', 'FAILED']
    retryCount:
      type: Number
      default: 0
    lastError: mongoose.Schema.Types.Mixed
    completedDate: Date
  }

module.exports = 
  PromotionRequest : mongoose.model('promotionRequest', PromotionRequestSchema, 'promotionRequest')
  PromotionRequestSchema : PromotionRequestSchema