mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Business = require('./business').BusinessSchema

UserSchema = new Schema
  email:
    type: String
    required: true
    lowercase: true
    trim: true
  firstName: String
  lastName: String
  password:
    type: String
  encryptionMethod:
    type: String
    enum: ['SHA1','BCRYPT']
  businessPrivileges: [
    business: {type:ObjectId, ref:'business'}
    role: 
      type: String
      enum: ['OWNER','COLLABORATOR']
  ]
  applications : [
    {
      name : String
      legacyKey : String
      apiKey : String
      apiSecret : String
    }
  ]
  authTokens : [{apiKey:String, authToken:String}]
  legacyId:String
  legacyProfiles:[String] 

module.exports = 
  User : mongoose.model('user', UserSchema, 'user')