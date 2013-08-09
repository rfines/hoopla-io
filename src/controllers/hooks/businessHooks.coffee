async = require 'async'
_ = require 'lodash'

module.exports = exports = 
  UserService : require('../../services/data/userService')
  create:
    pre : (resource, req, res, cb) =>
      cb null
    post : (business, req, res, cb) ->  
      req.authUser.businessPrivileges.push {businessId : business._id, role : 'OWNER'}
      req.authUser.save (err) ->
        cb() if cb
  update:
    pre : (resource, req, res, cb) =>
      cb null
    post : (target) =>
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
          not item.businessId.equals(options.resource._id)
        user.save (err) ->
          cb err
      exports.UserService.getByBusinessPrivileges options.resource._id, (err, users) ->
        async.each users, removePriv, (err) ->
          options.success() if options.success