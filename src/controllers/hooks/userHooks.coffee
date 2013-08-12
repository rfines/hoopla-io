hookLibrary = require('./hookLibrary')

module.exports = exports = 
  bcryptService : require('../../services/bcryptService')
  create:
    pre : (user, req, res, cb) ->
      exports.bcryptService.encrypt user.password, (encrypted) ->
        user.password = encrypted
        user.encryptionMethod = 'BCRYPT'
        cb()
    post: hookLibrary.default
  update:
    pre : hookLibrary.default
    post : hookLibrary.default    
    post : hookLibrary.default    