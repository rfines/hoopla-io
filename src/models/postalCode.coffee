mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
GeoSchema = require('./geo').GeoSchema

PostalCodeSchema = new Schema
  code:
    type: String
  city: 
    type: String
  state:
    type: String
  geo: [GeoSchema]

module.exports = 
  PostalCode : mongoose.model('postalCode', PostalCodeSchema)