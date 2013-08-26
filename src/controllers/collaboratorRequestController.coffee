CONFIG = require('config')
restify = require 'restify'


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
            if not e and b?._id
              u.businessPrivileges.push
                business: b
                role:"COLLABORATOR"
              u.save (err, doc)->
                if err
                  next(new restify.InternalError())
                else
                  res.send 200
                  next()
            else
              next(new restify.BadDigestError())
          else
            @sendInviteEmail body.email, b.name, (er, data) =>
              new @collaborator({email : body.email, requestDate : new Date(), businessId : body.business}).save (err, doc)=>
                if err
                  next(new restify.InternalError())
                else
                  res.send 200
                  next()
    else
      next(new restify.BadDigestError())     

  sendInviteEmail :(email, name, cb) =>
    emailOptions = 
      message: 
          'to' : [{email:email}]
          'global_merge_vars' : [{name : 'REGISTER_URL', content : "#{CONFIG.hooplaIoWeb.registerUrl}"},{name:'BUSINESS_NAME', content:"#{name}"}]
        template_name : 'add-business-collaborator'
        template_content : []
    @emailService.send emailOptions, (err)=>
      if err
        cb(err)
      else
        cb()

module.exports =  new CollaboratorRequestController()
