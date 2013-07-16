Schema = mongoose.Schema

GeoSchema = new Schema
  'type':
    type: String,
    required: true,
    enum: ['Point', 'LineString', 'Polygon'],
    default: 'Point'
  coordinates: [Number]

module.exports =
  GeoSchema : GeoSchema