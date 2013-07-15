mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

ContactSchema = new Schema
  contactName:
    type: String
    required: false
    lowercase: false
    trim: true
  contactPhone:
    type: String
    required: false
    lowercase: false
    trim: true
  contactEmail:
    type: String
    required: false
    lowercase: false
    trim: true

module.export = 
  Contact : mongoose.model('contact', ContactSchema)