mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

ContactSchema = new Schema
  contactName:
    type: String
    trim: true
  contactPhone:
    type: String
    trim: true
  contactEmail:
    type: String
    trim: true

module.export = 
  Contact : mongoose.model('contact', ContactSchema)
  ContactSchema : ContactSchema