_ = require 'lodash'
RestfulController = require('./restfulController')
securityConstraints = require('./helpers/securityConstraints')
cloudinaryService = require('../services/cloudinaryService')
Media = require('../models/media')

class MediaController extends RestfulController
  model = require('../models/media')

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
 
  uploads:(req,res, next) =>
    console.log req.body
    if (req.body)
      cloudinaryService.uploadImage req.body, (error,result) ->
        if error
          console.log error
          console.log(">> Error!: " + error)
          res.status = 401
          res.send({ success: false, error: error }, { 'Content-type': 'application/json' }, 401)
          next()
        else
          model = new Media({ url : result.url}).save (err, media) ->
            if (err) 
              console.log(">> Error!: " + err.toString())
              res.status = 401
              res.send({ success: false, error: err }, { 'Content-type': 'application/json' }, 401)
              next()
            else
              console.log('File Uploaded! ');
              res.status = 200
              res.send({ success: true, media:media }, { 'Content-type': 'application/json' }, 200)
              next()
    else
      res.status = 401
      res.send(JSON.stringify({ success: false, error: "No file sent!" }, { "Content-type": "application/json" }, 401))
      next()

  

  module.exports = new MediaController
    