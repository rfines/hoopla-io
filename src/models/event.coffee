mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Media = require('./media').MediaSchema
Contact = require('./contact').ContactSchema
SocialMediaLinks = require('./socialMediaLink').SocialMediaLinkSchema
Business= require('./business').BusinessSchema
PromotionRequest = require('./promotionRequest').PromtionRequestSchema

EventSchema = new Schema
  name: 
    type: String
    required: true
    trim: true
  description:
    type: String
    required: true
    trim: true
  host: {type:ObjectId, ref:'business'}
  business : {type:ObjectId, ref:'business', required:true}
  occurrences:[{
    start: Date
    end: Date
  }]
  promotionRequests:[{type:ObjectId, ref:'promotionRequest'}]
 
  tags: [String]
  cost: Number
  website:
    type: String
    required: false
    trim: true
  bands: [String]
  media:[{type : ObjectId, ref : 'media'}]
  contactName: String
  contactEmail: String
  contactPhone: String
  location: {
    address: {type: String, required: true}
    neighborhood : String
    geo: {
      'type':
        type: String,
        required: true,
        enum: ['Point', 'LineString', 'Polygon'],
        default: 'Point'
      coordinates: [Number]
    }
  }    
  ticketUrl: String
  socialMediaLinks: [SocialMediaLinks]
  schedules: [
    {
      hour: Number
      minute:Number
      duration:Number
      days: [Number]
      dayOfWeekCount : [Number]
      dayOfWeek: [Number]
      start: Date
      end: Date
    }
  ]
  fixedOccurrences: [
    {
      start: Date
      end: Date
    }
  ]  
  legacySchedule: {
    "dayNum": Number
    "period": Number
    "periodDay": [Number]
    "ordinal": Number
    "recurrenceInterval": Number
    "dayofweek": Number
    days: String
    start: Date
    end: Date
    hour: Number
    minute:Number
    duration:Number
  }
  legacyId: String
  legacyBusinessId: String  
  legacyHostId : String 
  legacyImage: String
  legacyEndDate: Date


module.exports = 
  Event : mongoose.model('event', EventSchema, 'event')


