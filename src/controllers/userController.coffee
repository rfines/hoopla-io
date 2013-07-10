mongoose = require 'mongoose'
User = require('../models/user').User

post = (req, res, next) ->
  u = new User({email: 'adamIsTheBestEver@gmail.com '})
  u.businessPrivileges.push
    businessId : new mongoose.Types.ObjectId()
    role : 'OWNER'
  u.save (err) ->
    res.send u
    next()
  


module.exports = 
  post : post