bcrypt = require 'bcrypt'
WORK_FACTOR = 12

encrypt = (password, callback) ->
  bcrypt.hash password, WORK_FACTOR, (err, hash) ->
  	callback(hash) if callback

check = (password, encrypted, onPass, onFail) ->
  bcrypt.compare password, encrypted, (err, res) ->
  	if res 
  	  onPass()
  	else
  		onFail()

module.exports = 
  encrypt : encrypt
  check: check