mongoose = require('mongoose')
ObjectId = mongoose.Schema.ObjectId

FeedSchema = new mongoose.Schema
  feedType :
    type : String
    enum: ['BUSINESS', 'EVENT']
    default : 'EVENT'
  geo: {
    'type':
      type: String,
      required: true,
      enum: ['Point', 'LineString', 'Polygon'],
      default: 'Point'
    coordinates: [Number]
  } 
  radius : Number
  tags : [String]
  user: ObjectId


module.exports = 
  Feed : mongoose.model('feed', FeedSchema, 'feed')
  FeedSchema : FeedSchema