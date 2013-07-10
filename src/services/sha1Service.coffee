check = (password, hashed, onPass, onFail) ->
  crypto = require('crypto')
  sha1hasher = crypto.createHash('sha1')
  sha1hasher.update(password, 'utf8')
  newhash = sha1hasher.digest('hex')
  console.log newhash
  console.log hashed
  if hashed is newhash 
    onPass()
  else
    onFail()
module.exports = 
  check: check