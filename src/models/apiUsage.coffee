mongoose = require('mongoose')

ApiUsageSchema = new mongoose.Schema
  method:
    type: String
    required: true
  url:
    type: String
    required: true
  status:
    type: String
    required: true        

module.exports = 
  ApiUsage : mongoose.model('apiUsage', ApiUsageSchema)