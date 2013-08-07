mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

EventTagSchema = new Schema
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
  EventTag : mongoose.model("eventTag", EventTagSchema, 'eventTag')
