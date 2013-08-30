async = require 'async'
_ = require 'lodash'
hookLibrary = require('./hookLibrary')

module.exports = exports = 
  UserService : require('../../services/data/userService')
  create:
    pre : (options)=>
      if options.target
        options.target.user = options.req.authUser
      else
        options.target.user = options.req.authUser
      options.success() if options.success
    post : hookLibrary.default
  update:
    pre : hookLibrary.default
    post : hookLibrary.default
  search:
    pre : hookLibrary.default
    post : hookLibrary.default

