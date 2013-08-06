CONFIG = require('config')
process.env.MANDRILL_APIKEY = process.env.MANDRILL_APIKEY || CONFIG.email.mandrill.apiKey
process.env.MANDRILL_USERNAME = process.env.MANDRILL_APIKEY || CONFIG.email.mandrill.apiKey
Mandrill = require("mandrill-api").Mandrill

module.exports.send  = (options, cb) ->
  console.log 'send function'
  options =
    message: 
      'to' : [{email:'england@localrucks.com', 'name' : 'Adam England'}]
    template_name : 'password-reset-request'
    template_content : [{PASSWORD_RESET_URL  : 'http://www.adamnengland.com'}]
  m = new Mandrill()
  m.messages.sendTemplate options,  (info) ->
    console.log info
