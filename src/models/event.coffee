mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Contact = require('./contact').ContactSchema
TicketingLink = require('./ticketingLink').TicketingLinkSchema
SocialMediaLinks = require('./socialMediaLink').SocialMediaLinkSchema

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
  business : ObjectId
  occurrences:[Date]
  categories: [String]
  cost: Number
  website:
    type: String
    required: false
    trim: true
  eventType:
    type: [String]
    required: false
  bands: [String]
  media:[ObjectId]
  contacts: [Contact]
  address: {
    line1:
      type: String
      required: true
      trim: true
    line2:
      type: String
      trim: true
    city:
      type: String
      required: true
      trim: true
    state_province:
      type: String
      required: true
      trim: true
    postal_code:
      type: String
      required: true
      trim: true
  }
  geo: {
    'type':
      type: String,
      required: true,
      enum: ['Point', 'LineString', 'Polygon'],
      default: 'Point'
    coordinates: [Number]
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
    "periodDay": Number
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
  legacyImage: String


module.exports = 
  Event : mongoose.model('event', EventSchema, 'event')


