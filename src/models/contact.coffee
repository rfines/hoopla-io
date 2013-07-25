mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

ContactSchema = new Schema
  name:
    type: String
    trim: true
  phone:
    type: String
    trim: true
  email:
    type: String
    trim: true

module.export = 
  Contact : mongoose.model('contact', ContactSchema)
  ContactSchema : ContactSchema