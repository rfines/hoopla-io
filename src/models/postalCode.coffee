mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

PostalCodeSchema = new Schema
  code:
    type: String
  city: 
    type: String
  state:
    type: String
  latitude:
    type: Number
  longitude:
    type: Number

module.exports = 
  PostalCode : mongoose.model('postalCode', PostalCodeSchema)