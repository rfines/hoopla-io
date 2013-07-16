mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

EventCategorySchema = new Schema
  name:
    type: String
    required: true
    trim: true
module.export = 
  EventCategory = mongoose.model("eventCategory", EventCategorySchema)