mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
BusinessSubCategory = require("./businessSubCategory").Schema

BusinessCategorySchema = new Schema
  name: 
    type: String
    required: true
    trim: true
  subCategories:[BusinessSubCategory]

module.exports = 
  BusinessCategory : mongoose.model("businessCategory", BusinessCategorySchema)
