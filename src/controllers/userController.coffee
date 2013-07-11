mongoose = require 'mongoose'
Model = require('../models/user').User

create = (req, res, next) ->
  res.status(201)
  model = new Model({email: 'adamIsTheBestEver@gmail.com '})
  model.businessPrivileges.push
    businessId : new mongoose.Types.ObjectId()
    role : 'OWNER'
  model.save (err) ->
    res.send model
    next()

destroy = (req, res, next) ->
  Model.findByIdAndRemove req.params.id, (err, doc) ->
    res.send(204)
    next()
  

module.exports = 
  create : create
  destroy: destroy