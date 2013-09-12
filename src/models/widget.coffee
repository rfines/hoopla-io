mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Business= require('./business').BusinessSchema
User = require('./user').UserSchema

WidgetSchema = new Schema
  widgetType: {
    type:String
    enum:["event-by-location","event-by-business"]
    required:true
    default:'event-by-location'
  }
  name: String
  filters: Boolean
  limit:Number
  location: {
    address: {type: String}
    neighborhood : String
    geo: {
      'type':
        type: String,
        enum: ['Point', 'LineString', 'Polygon'],
        default: 'Point'
      coordinates: [Number]
    }    
  }
  businesses: [{type:ObjectId, ref:'business'}]
  radius : Number
  tags : [String]
  user: {type:ObjectId, ref:'user'}
  height: Number
  width: Number
  widgetStyle: {
    type:String
    enum: ['dark','light']
  }
  accentColor: String

module.exports = 
  Widget : mongoose.model('widget', WidgetSchema, 'widget')
  WidgetSchema: WidgetSchema
