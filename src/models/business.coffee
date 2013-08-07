mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Contact = require('./contact')
Media = require('./media').MediaSchema
SocialMediaLink = require('./socialMediaLink').SocialMediaLinkSchema

BusinessSchema = new Schema
  name: 
    type: String
    required: true
    trim: true
  description:
    type: String
    required: true
    trim: true
  hours:
    type: String
  createdAt: 
    type: Date
    default: Date.now 
  lastModifiedAt:
    type: Date
    default: Date.now
  tags:[String]
  website:
    type: String
    required: false
    trim: true
  createdBy: ObjectId
  media:[{type : ObjectId, ref : 'media'}]
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
  socialMediaLinks:[SocialMediaLink]
  legacyId: String
  legacyCreatedBy:
    type: Number
    required: true  

module.exports = 
  Business : mongoose.model('business', BusinessSchema,'business')


