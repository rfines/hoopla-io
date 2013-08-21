CONFIG = require('config')
mongoose = require 'mongoose'
async = require 'async'
class CollaboratorRequestController
  emailService : require('../services/emailService')
  user : require('../models/user').User
  collaborator : require('../models/collaboratorRequest').CollaboratorRequest
  business = require('../models/business').Business

  constructor : (@name) ->

  addCollaborator:(req, res, next) =>
    body = req.body
    if body.email and body.business
      @user.findOne {email : body.email}, {}, {}, (err, u) =>
        @business.findOne {"_id": body.business}, {}, {lean:true}, (e, b)=>
          if not err and u?._id
            console.log b.name
            if not e and b?._id
              console.log b.name
              u.businessPrivileges.push
                business: b
                role:"COLLABORATOR"
              console.log u
              u.save (err, doc)->
                if err
                  console.log err
                  res.send 401, JSON.stringify({"code": 401, "message": "#{err}"})
                  next()
                else
                  res.send 200, JSON.stringify({"code": 200, "message": "Collaborator added."})
                  next()
            else
              res.send 401, JSON.stringify({"code": 401, "message": "Invalid request"})
              next()
          else
            @sendInviteEmail body.email, b.name, (er, data) =>
              collab = new @collaborator()
              collab.email = body.email
              collab.requestDate= new Date()
              collab.businessId = body.business
              collab.save (err, doc)=>
                if err
                  console.log err
                  res.send 401, JSON.stringify({"code": 401, "message": "Something went wrong."})
                else
                  res.send 200, JSON.stringify({"code": 200, "message": "Collaborator added."})
            next()
    else
      res.send 401, JSON.stringify({"code": 401, "message": "Invalid request"}) 
      next()       
  sendInviteEmail :(email, name, cb) =>
    console.log email
    console.log name
    emailOptions = 
      message: 
          'to' : [{email:email}]
          'global_merge_vars' : [{name : 'REGISTER_URL', content : "#{CONFIG.hooplaIoWeb.registerUrl}"},{name:'BUSINESS_NAME', content:"#{name}"}]
        template_name : 'add-business-collaborator'
        template_content : []
    @emailService.send emailOptions, (err)=>
      if err
        console.log err 
        cb err, null
      else
        cb null,null
    cb 

module.exports =  new CollaboratorRequestController()
