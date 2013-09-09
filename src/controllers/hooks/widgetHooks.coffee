hookLibrary = require('./hookLibrary')

module.exports = exports =
  create:
    pre : (options)=>
      options.req.body.user = options.req.authUser
      options.success() if options.success
    post : hookLibrary.default
  update:
    pre : hookLibrary.default
    post : hookLibrary.default
  search:
    pre : hookLibrary.default
    post : hookLibrary.default
  destroy:
    pre : hookLibrary.default
    post : hookLibrary.default