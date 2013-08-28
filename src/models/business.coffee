mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Contact = require('./contact')
Media = require('./media').MediaSchema
SocialMediaLink = require('./socialMediaLink').SocialMediaLinkSchema
require('./promotionTarget').PromotionTargetSchema

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
  tags:[String]
  website:
    type: String
    required: false
    trim: true
  createdBy: ObjectId
  media:[{type : ObjectId, ref : 'media'}]
  contactName: String
  contactPhone: String
  contactEmail: String
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
  socialMediaLinks:[SocialMediaLink]
  promotionTargets: [{type:ObjectId, ref : 'promotionTarget'}]
  legacyId: String
  legacyCreatedBy: String


module.exports = 
  Business : mongoose.model('business', BusinessSchema,'business')
  BusinessSchema: BusinessSchema


