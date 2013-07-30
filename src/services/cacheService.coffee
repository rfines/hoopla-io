redis = require("redis")
client = undefined

getInstance = ->
  if process.env.REDISTOGO_URL
    rtg = require("url").parse(process.env.REDISTOGO_URL)
    client = redis.createClient(rtg.port, rtg.hostname)
    client.auth rtg.auth.split(":")[1]
  else
    client = redis.createClient()

  client.on "error", (err) ->
    console.log "Error " + err

module.exports = getInstance()  