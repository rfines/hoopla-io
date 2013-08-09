module.exports = exports = 
  bcryptService : require('../../services/bcryptService')
  create:
    pre : (user, req, res, next, cb) ->
      exports.bcryptService.encrypt user.password, (encrypted) ->
        user.password = encrypted
        user.encryptionMethod = 'BCRYPT'
        cb()