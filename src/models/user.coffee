mongoose = require('mongoose')

UserSchema = new mongoose.Schema
  email:
    type: String
    required: true
    lowercase: true
    trim: true
  password:
  	type: String
  	required: true
  encryptionMethod:
    type: String
    enum: ['SHA1','BCRYPT']

module.exports = 
  User : mongoose.model('User', UserSchema)