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
  username:
    type:String
    required:false
  name:
    type:String
    required:false
  password:
    type:String
    required:true
  legacyProfiles:[String] 
  userCredential:
    type: ObjectId
  businessPrivileges: [BusinessPrivileges]
    

module.exports = 
  User : mongoose.model('user', UserSchema)