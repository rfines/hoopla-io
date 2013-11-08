tokenService = require './services/tokenService'
secret = tokenService.generateSecret()
key = tokenService.generateKey()
console.log secret
console.log key