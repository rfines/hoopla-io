mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Media = require('./media').MediaSchema
Contact = require('./contact').ContactSchema
SocialMediaLinks = require('./socialMediaLink').SocialMediaLinkSchema
Business= require('./business').BusinessSchema
PromotionRequest = require('./promotionRequest').PromtionRequestSchema

OccurrenceSchema = new Schema
  start: Date
  end: Date
,
  id: false
  _id : false

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
  fixedOccurrences: [
    {
      start: Date
      end: Date
    }
  ]  
  schedules: [
    {
      hour: Number
      minute:Number
      duration:Number
      dayOfWeekCount : [Number]
      dayOfWeek: [Number]
      start: Date
      end: Date
    }
  ]
  occurrences:[OccurrenceSchema]
  nextOccurrence: {start: Date, end:Date}
  prevOccurrence: {start: Date, end:Date}
  scheduleText: String
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
  tzOffset : Number

EventSchema.pre 'save', (next) ->
  scheduleService = require('../services/schedulingService')
  scheduleService.calculate @, (err, out) =>
    if not err
      @occurrences = out.occurrences if out.occurrences?
      @scheduleText = out.scheduleText
      @nextOccurrence = out.nextOccurrence
      @prevOccurrence = out.prevOccurrence
    next()
EventSchema.pre 'update', (next) ->
  scheduleService = require('../services/schedulingService')
  scheduleService.calculate @, (err, out) =>
    if not err
      @occurrences = out.occurrences if out.occurrences?
      @scheduleText = out.scheduleText
      @nextOccurrence = out.nextOccurrence
      @prevOccurrence = out.prevOccurrence      
    next()

module.exports = 
  Event : mongoose.model('event', EventSchema, 'event')


