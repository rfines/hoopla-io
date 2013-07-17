mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

MediaSchema= new Schema
    url:
      type:String
      required:false

module.exports=
  Media: mongoose.model('media',MediaSchema, 'media')
  MediaSchema : MediaSchema