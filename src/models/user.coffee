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
  username: String
  name: String
  password:
    type: String
    required: true
  encryptionMethod:
    type: String
    enum: ['SHA1','BCRYPT']
  businessPrivileges: [BusinessPrivileges]

  #Items for migration only
  legacyProfiles:[String] 
    

module.exports = 
  User : mongoose.model('user', UserSchema)