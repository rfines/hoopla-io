mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Contact = require('./contact')
TicketingLink = require('./ticket').TicketingLinkSchema
SocialMediaLinks = require('./socialMediaLinks').SocialMediaLinkSchema
Media = require('./media')
Business = require('./business')

EventSchema = new Schema
  name: 
    type: String
    required: true
    lowercase: false
    trim: true
  description:
    type: String
    required: true
    lowercase: false
    trim: true
  startDate:
    type: Date
    required: true
    default: Date.now
  endDate:
    type: Date
    required: false
    default: Date.now
  createdAt: 
    type: Date
    required: true
    default: Date.now 
  lastModifiedAt:
    type: Date
    required: true
    default: Date.now
  categories:
    type: [String]
    required: true
  website:
    type: String
    required: false
    lowercase: false
    trim: true
  createdBy:
    type:Number
    required:true
  eventType:
    type: [String]
    required: false
  bands: 
    type:[String]
    required: false
  media:[Media]
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
  venue:
    type: ObjectId


module.exports = 
  Event : mongoose.model('event', EventSchema)


