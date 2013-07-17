mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

BusinessSubCategorySchema = new Schema 
  name:
    type: String
    trim: true
    required: true

BusinessCategorySchema = new Schema
  name: 
    type: String
    required: true
    trim: true
  subCategories:[BusinessSubCategorySchema]

module.exports = 
  BusinessCategory : mongoose.model("businessCategory", BusinessCategorySchema, "businessCategory")
