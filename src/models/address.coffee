mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

AddressSchema = new Schema
  line1:
    type: String
    required: true
    lowercase: false
    trim: true
  line2:
    type: String
    required: false
    lowercase: false
    trim: true
  city:
    type: String
    required: true
    lowercase: false
    trim: true
  state_province:
    type: String
    required: true
    lowercase: false
    trim: true
  postal_code:
    type: String
    required: true
    lowercase: false
    trim: true
  latitude:
    type: Number
    required: true
  longitude:
    type: Number
    required:true

module.exports = 
  Address : mongoose.model('address', AddressSchema)