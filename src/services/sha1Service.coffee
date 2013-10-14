crypto = require('crypto')

check = (password, hashed, onPass, onFail) ->
  encrypt password, (match) =>
    if hashed and match
      if hashed.toUpperCase() is match.toUpperCase()
        onPass()
      else
        onFail()
    else
      onFail()
encrypt = (password, cb) ->
  sha1hasher = crypto.createHash('sha1')
  sha1hasher.update(password, 'utf8')
  cb sha1hasher.digest('hex') if cb
    
module.exports = 
  check: check
  encrypt: encrypt