mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
BusinessSubCategory = require("../models/businessSubCatgeory").SubCategory

BusinessCategorySchema = new Schema
  name: 
    type: String
    required: true
    trim: true
  subCategories:[BusinessSubCategory]
module.export = 
  BusinessCategory : mongoose.model("businessCategory", BusinessCategorySchema)
