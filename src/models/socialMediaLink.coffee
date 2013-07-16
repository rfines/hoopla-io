mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

SocialMediaLinkSchema = new Schema
  target: String
  url: String

module.export=
  SocialMediaLink: mongoose.model('socialMediaLink', SocialMediaLinkSchema)
  SocialMediaLinkSchema : SocialMediaLinkSchema