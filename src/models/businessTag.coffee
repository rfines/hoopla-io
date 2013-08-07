mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

BusinessTagSchema = new Schema
  text:
    type: String
    required: true
    trim: true
  slug:
    type: String
    required: true
    trim: true
    uppercase: true

module.exports = 
  EventCategory : mongoose.model("businessTag", BusinessTagSchema, 'businessTag')
