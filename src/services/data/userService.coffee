class UserService
  User : require('hoopla-io-core').User

  getByAppToken : (apiKey, token, cb) ->
    @User.findOne {'authTokens.apiKey' : apiKey, 'authTokens.authToken' : token}, {}, {}, (err, data) ->
      cb err, data

  getByBusinessPrivileges: (businessId, cb) ->
    @User.find {'businessPrivileges.business' : businessId}, cb


module.exports = new UserService()
