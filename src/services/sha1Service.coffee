crypto = require('crypto')

check = (password, hashed, onPass, onFail) ->
  sha1hasher = crypto.createHash('sha1')
  sha1hasher.update(password, 'utf8')
  if hashed is sha1hasher.digest('hex') 
    onPass()
  else
    onFail()
    
module.exports = 
  check: check