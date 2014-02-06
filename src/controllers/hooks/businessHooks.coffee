async = require 'async'
_ = require 'lodash'
hookLibrary = require('./hookLibrary')
imageManipulation = require('../helpers/imageManipulation')

module.exports = exports = 
  UserService : require('../../services/data/userService')
  
  create:
    pre : (options) ->
      if not options.req.body.sources?
        options.req.body.sources = [{sourceType:'hoopla', lastUpdated: new Date()}]
      hookLibrary.unpopulate(options)
    post : (options) ->  
      admins=["info@localruckus.com", "pittsburgks@localruckus.com", "manhattanks@localruckus.com"]
      options.req.authUser.businessPrivileges = options.req.authUser.businessPrivileges || []
      if admins.indexOf(options.req.authUser.email) != -1
        options.req.authUser.businessPrivileges.push {business : options.target, role : 'ADMIN_COLLABORATOR'}
      else
        options.req.authUser.businessPrivileges.push {business : options.target, role : 'OWNER'}
      options.req.authUser.save (err) ->
        options.success() if options.success
  update:
    pre : (options) ->
      if not options.req.body.sources?
        options.req.body.sources = [{sourceType:'hoopla', lastUpdated: new Date()}]
      hookLibrary.unpopulate(options)
    post : hookLibrary.default
  search:
    pre : hookLibrary.default
    post : hookLibrary.default
  destroy:
    pre : hookLibrary.default
    post : (options) =>
      removePriv = (user, cb) ->
        user.businessPrivileges = _.filter user.businessPrivileges, (item) ->
          not item.business.equals(options.resource._id)
        user.save (err) ->
          cb err
      exports.UserService.getByBusinessPrivileges options.resource._id, (err, users) ->
        async.each users, removePriv, (err) ->
          options.success() if options.success
  get :
    pre:hookLibrary.default
    post:(options, target, callback)=>
      h = options.req.params.height if options.req.params.height
      w = options.req.params.width if options.req.params.width
      c = options.req.params.imageType if options.req.params.imageType
      if target.media and target.media.length >0 
        target.media[0].url = imageManipulation.resize(w, h, target.media[0].url,c)
        callback(target)
      else
        callback(target)