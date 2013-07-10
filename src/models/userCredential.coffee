mongoose = require('mongoose')

UserCredentailSchema = new mongoose.Schema
  password:
  	type: String
  	required: true
  encryptionMethod:
    type: String
    enum: ['SHA1','BCRYPT']

module.exports = 
  UserCredential : mongoose.model('userCredential', UserCredentailSchema)