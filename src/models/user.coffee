mongoose = require('mongoose')
Schema = mongoose.Schema
ObjectId = mongoose.Schema.ObjectId

BusinessPrivileges = new Schema
  businessId: 
    type: ObjectId
    required: true
  role: 
    type: String
    enum: ['OWNER','COLLABORATOR']

UserSchema = new Schema
  email:
    type: String
    required: true
    lowercase: true
    trim: true
  name: String
  password:
    type: String
  encryptionMethod:
    type: String
    enum: ['SHA1','BCRYPT']
  businessPrivileges: [BusinessPrivileges]
  applications : [
    {
      name : String
      legacyKey : String
      apiKey : String
      apiSecret : String
    }
  ]
  legacyId:String
  legacyProfiles:[String] 

    

module.exports = 
  User : mongoose.model('user', UserSchema, 'user')