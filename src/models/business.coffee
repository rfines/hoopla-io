mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Contact = require('./contact')
Address = require('./address')
SocialMediaLinks = require('./socialMediaLinks')
Media = require('./media')

BusinessSchema = new Schema
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
  hours:
    type:String
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
    lowercase: false
    trim: true
  createdBy:
    type:Number
    required:true
  media:[Media]
  contact: [Contact]
  address: Address
  
  socialMediaLinks:[SocialMediaLinks]

module.exports = 
  Business : mongoose.model('business', BusinessSchema)


