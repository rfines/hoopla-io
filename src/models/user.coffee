mongoose = require('mongoose')

UserSchema = new mongoose.Schema
  email:
    type: String
    required: true
    lowercase: true
    trim: true

module.exports = 
  User : mongoose.model('user', UserSchema)