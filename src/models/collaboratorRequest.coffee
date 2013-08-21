mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

CollaboratorRequestSchema = new Schema
  requestDate : Date
  completedDate : Date
  businessId : ObjectId
  email : String

module.exports=
  CollaboratorRequest: mongoose.model('collaboratorRequest',CollaboratorRequestSchema, 'collaboratorRequest')
  CollaboratorRequestSchema : CollaboratorRequestSchema
