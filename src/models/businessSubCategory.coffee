mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

BusinessSubCategorySchema = new Schema 
  name:
    type: String
    trim: true
    required: true

module.exports = 
  BusinessSubCategory : mongoose.model('businessSubCategory', BusinessSubCategorySchema)