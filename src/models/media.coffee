mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

MediaSchema= new Schema
  url:
    type:String
    required:false
modeul.export=
  Media: mongoose.model('media',MediaSchema)