mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Contact = require('./contact')
SocialMediaLinks = require('./socialMediaLinks')
Media = require('./media')
GeoSchema = require('./geo').GeoSchema

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
  categories:
    type: [String]
    required: true
  subCategories:
    type:[String]
    required: true
  website:
    type: String
    required: false
    trim: true
  createdBy:
    type: Number
    required: true
  media: [Media]
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
  geo: [GeoSchema]
  socialMediaLinks:[SocialMediaLinks]

module.exports = 
  Business : mongoose.model('business', BusinessSchema)


