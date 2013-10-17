async = require 'async'
_ = require 'lodash'
hookLibrary = require('./hookLibrary')

module.exports = exports = 
  UserService : require('../../services/data/userService')
  create:
    pre : (options) ->
      if not options.req.body.sources?
        options.req.body.sources = [{type:'hoopla'}]
      hookLibrary.unpopulate(options)
    post : (options) ->  
      options.req.authUser.businessPrivileges = options.req.authUser.businessPrivileges || []
      options.req.authUser.businessPrivileges.push {business : options.target, role : 'OWNER'}
      options.req.authUser.save (err) ->
        options.success() if options.success
  update:
    pre : (options) ->
      if not options.req.body.sources?
        options.req.body.sources = [{type:'hoopla'}]
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
