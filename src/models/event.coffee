mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Contact = require('./contact')
Address = require('./address')
Ticket = require('./ticket')
SocialMediaLinks = require('./socialMediaLinks')
Media = require('./media')

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
  media:[Media]
  contact: [Contact]
  address: Address
  ticket:Ticket
  socialMediaLinks:[SocialMediaLinks]

  business:
    type: ObjectId
    required:false


module.exports = 
  Event : mongoose.model('event', EventSchema)


