class UserService
  User : require('../../models/user').User

  getByAppToken : (apiKey, token, cb) ->
    @User.findOne {'authTokens.apiKey' : apiKey, 'authTokens.authToken' : token}, {}, {}, (err, data) ->
      cb err, data

  getByBusinessPrivileges: (businessId, cb) ->
    @User.find {'businessPrivileges.businessId' : businessId}, cb


module.exports = new UserService()
