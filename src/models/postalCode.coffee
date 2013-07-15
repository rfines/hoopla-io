mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

GeoSchema = new Schema
  'type':
    type: String,
    required: true,
    enum: ['Point', 'LineString', 'Polygon'],
    default: 'Point'
  coordinates: [Number]

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