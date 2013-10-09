mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId
Business = require('./business').BusinessSchema

UserSchema = new Schema
  userType:
    type: String
    enum: ['BUSINESS','PUBLISHER']
  email:
    type: String
    required: true
    lowercase: true
    trim: true
  firstName: String
  lastName: String
  address1: String
  address2: String
  city: String
  state: String
  postalCode: String
  phone: String
  password:
    type: String
  encryptionMethod:
    type: String
    enum: ['SHA1','BCRYPT']
  businessPrivileges: [
    business: {type:ObjectId, ref:'business'}
    role: 
      type: String
      enum: ['OWNER','COLLABORATOR', 'ADMIN_COLLABORATOR']
  ]
  applications : [
    {
      name : String
      legacyKey : String
      apiKey : String
      apiSecret : String
      privileges: 
        type: String
        enum: ['PRIVILEGED', 'STANDARD']
    }
  ]
  authTokens : [{apiKey:String, authToken:String}]
  legacyId:String
  legacyProfiles:[String] 

module.exports = 
  User : mongoose.model('user', UserSchema, 'user')