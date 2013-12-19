_ = require 'lodash'
RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')
cloudinaryService = require('../services/cloudinaryService')
restify = require 'restify'
class MediaController extends RestfulController
  model : require('hoopla-io-core').Media

  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : securityConstraints.hasAuthUser
    destroy : securityConstraints.hasAuthUser
  constructor : (@name) ->
    super(@name)

  hooks: require('./hooks/mediaHooks')

  uploads:(req,res, next) =>
    if req.body
      med = new @model()
      if @security.create(req.authUser, med)
        @hooks.create.pre
          target: med
          req: req
          res: res
          success: ()=>
            cloudinaryService.uploadImage req.body, (error,result) =>
              if error
                console.log error
                res.status = 400
                res.send({ success: false, error: error }, { 'Content-type': 'application/json' }, 400)
                next()
              else
                med.url = result.url
                med.save (err, media) ->
                  if (err)
                    console.log err 
                    res.status = 400
                    res.send({ success: false, error: err }, { 'Content-type': 'application/json' }, 400)
                    next()
                  else
                    res.status = 200
                    res.send({ success: true, media:media }, { 'Content-type': 'application/json' }, 200)
                    next()
      else
        next new restify.NotAuthorizedError("You are not permitted to perform this operation.")  
    else
      res.status = 400
      res.send(JSON.stringify({ success: false, error: "No file sent!" }, { "Content-type": "application/json" }, 400))
      next()

  media:(req, res, next)=>
    if req.params.id
      @model.find {"user": req.params.id}, {}, {lean:true}, (err, doc)=>
        if err
          res.status = 400
          res.send({ success: false, error: "Could not find media for this user." }, { 'Content-type': 'application/json' }, 400)
          next()
        else
          res.stats =200
          res.send doc, { 'Content-type': 'application/json' }, 200
          next()
  module.exports = new MediaController    