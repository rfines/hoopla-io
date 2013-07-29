memjs = require("memjs")
client = undefined

getInstance = ->
  if not client
    client = memjs.Client.create()
  return client

module.exports = getInstance()  