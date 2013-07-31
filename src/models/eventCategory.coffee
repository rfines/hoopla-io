mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

EventCategorySchema = new Schema
  name:
    type: String
    required: true
    trim: true
  code:
    type: String
    required: true
    trim: true
    uppercase: true
module.exports = 
  EventCategory : mongoose.model("eventCategory", EventCategorySchema, 'eventCategory')
