mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Business= require('./business').BusinessSchema
User = require('./user').UserSchema

WidgetSchema = new Schema
  name: String
  filters: Boolean
  limit:Number
  type: {
    type:String
    enum:["event-by-location","event-by-business"]
    required:true
    default:'event-by-location'
  }
  geo: {
    'type':
      type: String,
      required: true,
      enum: ['Point', 'LineString', 'Polygon'],
      default: 'Point'
    coordinates: [Number]
  } 
  businessId: {type:ObjectId, ref:'business'}
  radius : Number
  tags : [String]
  user: {type:ObjectId, ref:'user'}

module.exports = 
  Widget : mongoose.model('widget', WidgetSchema, 'widget')
  WidgetSchema: WidgetSchema
