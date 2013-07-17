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
  geo: {
    'type':
      type: String,
      required: true,
      enum: ['Point', 'LineString', 'Polygon'],
      default: 'Point'
    coordinates: [Number]
  }

module.exports = 
  PostalCode : mongoose.model('postalCode', PostalCodeSchema, 'postalCode')