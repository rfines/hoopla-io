mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

PasswordResetSchema = new Schema
  requestDate : Date
  completedDate : Date
  token : String
  email : String

module.exports=
  PasswordReset: mongoose.model('passwordReset',PasswordResetSchema, 'passwordReset')
  PasswordResetSchema : PasswordResetSchema