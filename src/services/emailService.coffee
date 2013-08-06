CONFIG = require('config')
process.env.MANDRILL_APIKEY = process.env.MANDRILL_APIKEY || CONFIG.email.mandrill.apiKey
process.env.MANDRILL_USERNAME = process.env.MANDRILL_APIKEY || CONFIG.email.mandrill.apiKey
Mandrill = require("mandrill-api").Mandrill

module.exports.send  = (options, cb) ->
  m = new Mandrill()
  m.messages.sendTemplate options,  (info) ->
    cb() if cb
