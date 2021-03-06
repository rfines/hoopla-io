KEY_LENGTH = 20
SECRET_LENGTH = 40

generateKey = () ->
  generate(KEY_LENGTH)

generateSecret = () ->
  generate(SECRET_LENGTH)  

rn = (max) ->
  return Math.floor (Math.random() * max)

generate = (len) ->
  [num, alpb, alps] = ["0123456789", "ABCDEFGHIJKLMNOPQRSTUVWXTZ", "abcdefghiklmnopqrstuvwxyz"]
  [chars, key]      = [(alpb + num + alps).split(''),""]
  key += chars[rn(chars.length)] for i in [1..len]
  return key

generateWithTimestamp = (len) ->
  "#{generate(len)}_#{new Date().getTime()}"

module.exports = 
  generateKey : generateKey
  generateSecret : generateSecret
  generate : generate
  generateWithTimestamp : generateWithTimestamp