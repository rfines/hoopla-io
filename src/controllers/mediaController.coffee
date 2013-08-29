_ = require 'lodash'
RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')
cloudinaryService = require('../services/cloudinaryService')

class MediaController extends RestfulController
  model : require('../models/media').Media

  security: 
    get : securityConstraints.anyone
    create : securityConstraints.hasAuthUser
    update : (authenticatedUser, business) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv.business?.equals(business._id)
      return not _.isUndefined(ownerMatch)
    destroy : (authenticatedUser, business) ->
      ownerMatch = _.find authenticatedUser.businessPrivileges, (priv) ->
        return priv.business?.equals(business._id) and priv.role is 'OWNER'
      return not _.isUndefined(ownerMatch)
  constructor : (@name) ->
    super(@name)

  hooks: require('./hooks/mediaHooks')

  uploads:(req,res, next) =>
    if (req.body)
      console.log req.authUser
      med = new @model()
      @hooks.create.pre
        target: med
        req: req
        res: res
        success: ()=>
          cloudinaryService.uploadImage req.body, (error,result) =>
            if error
              console.log error
              console.log("Error!: " + error)
              res.status = 400
              res.send({ success: false, error: error }, { 'Content-type': 'application/json' }, 400)
              next()
            else
              med.url = result.url
              med.save (err, media) ->
                if (err) 
                  console.log("Error!: " + err.toString())
                  res.status = 400
                  res.send({ success: false, error: err }, { 'Content-type': 'application/json' }, 400)
                  next()
                else
                  console.log('File Uploaded! ');
                  res.status = 200
                  res.send({ success: true, media:media }, { 'Content-type': 'application/json' }, 200)
                  next()
    else
      res.status = 400
      res.send(JSON.stringify({ success: false, error: "No file sent!" }, { "Content-type": "application/json" }, 400))
      next()

  media:(req, res, next)=>
    if req.params.id
      @model.find {"user": req.params.id}, {}, {lean:true}, (err, doc)=>
        if err
          console.log err
          res.status = 400
          res.send({ success: false, error: "Could not find media for this user." }, { 'Content-type': 'application/json' }, 400)
          next()
        else
          console.log "Media returning to user"
          res.stats =200
          res.send({ success: true, media:doc }, { 'Content-type': 'application/json' }, 200)
          next()

  

  module.exports = new MediaController
    