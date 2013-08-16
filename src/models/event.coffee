mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Media = require('./media').MediaSchema
Contact = require('./contact').ContactSchema
TicketingLink = require('./ticketingLink').TicketingLinkSchema
SocialMediaLinks = require('./socialMediaLink').SocialMediaLinkSchema
Business= require('./business').BusinessSchema

EventSchema = new Schema
  name: 
    type: String
    required: true
    trim: true
  description:
    type: String
    required: true
    trim: true
  createdAt: 
    type: Date
    required: true
    default: Date.now 
  lastModifiedAt:
    type: Date
    required: true
    default: Date.now
  host: {type:ObjectId, ref:'business'}
  business : {type:ObjectId, ref:'business'}
  occurrences:[Date]
  tags: [String]
  cost: Number
  website:
    type: String
    required: false
    trim: true
  eventType:
    type: [String]
    enum: ['ENTERTAINMENT', 'ARTS', 'MUSIC','FAMILY','FOOD']
    required: false
  bands: [String]
  media:[{type : ObjectId, ref : 'media'}]
  contacts: [Contact]
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
  ticketingLinks:[TicketingLink]
  socialMediaLinks:[SocialMediaLinks]
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


