class UserService
  User : require('../../models/user').User

  getByAppToken : (apiKey, token, cb) ->
    console.log {'authTokens.apiKey' : apiKey, 'authTokens.authToken' : token}
    @User.findOne {'authTokens.apiKey' : apiKey, 'authTokens.authToken' : token}, {}, {}, (err, data) ->
      console.log "Token #{token}"
      console.log err
      console.log data
      cb err, data

  getByBusinessPrivileges: (businessId, cb) ->
    @User.find {'businessPrivileges.business' : businessId}, cb


module.exports = new UserService()
