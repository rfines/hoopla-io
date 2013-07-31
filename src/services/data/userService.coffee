class UserService
  User : require('../../models/user').User

  getByAppToken : (apiKey, token, cb) ->
    @User.findOne {'authTokens.apiKey' : apiKey, 'authTokens.authToken' : token}, {}, {}, (err, data) ->
      cb err, data


module.exports = new UserService()
