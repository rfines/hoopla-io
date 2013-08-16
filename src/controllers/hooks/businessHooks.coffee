async = require 'async'
_ = require 'lodash'
hookLibrary = require('./hookLibrary')

module.exports = exports = 
  UserService : require('../../services/data/userService')
  create:
    pre : hookLibrary.default
    post : (business, req, res, cb) ->  
      req.authUser.businessPrivileges = req.authUser.businessPrivileges || []
      req.authUser.businessPrivileges.push {business : business, role : 'OWNER'}
      req.authUser.save (err) ->
        cb() if cb
  update:
    pre : hookLibrary.default
    post : hookLibrary.default
  search:
    pre : (req, res, cb) =>
      cb null
    post : (req, res, cb) =>    
      cb null        
  destroy:
    pre : (options) =>
      options.success() if options.success
    post : (options) =>
      removePriv = (user, cb) ->
        user.businessPrivileges = _.filter user.businessPrivileges, (item) ->
          not item.business.equals(options.resource._id)
        user.save (err) ->
          cb err
      exports.UserService.getByBusinessPrivileges options.resource._id, (err, users) ->
        async.each users, removePriv, (err) ->
          options.success() if options.success