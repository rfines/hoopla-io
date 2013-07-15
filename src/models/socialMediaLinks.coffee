mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

SocialMediaLinksSchema = new Schema
  target: 
    type:String
    required: false
  url:
    type:String
    required:false

module.export=
  SocialMediaLinks: mongoose.model('socialMediaLinks', SocialMediaLinksSchema)