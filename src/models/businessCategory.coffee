mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

BusinessSubCategorySchema = new Schema 
  name:
    type: String
    trim: true
    required: true
  code:
    type: String
    required: true
    trim: true
    uppercase: true

BusinessCategorySchema = new Schema
  name: 
    type: String
    required: true
    trim: true
  code:
    type: String
    required: true
    trim: true
    uppercase: true
  subCategories:[BusinessSubCategorySchema]

module.exports = 
  BusinessCategory : mongoose.model("businessCategory", BusinessCategorySchema, "businessCategory")
