Mandrill = require("mandrill-api").Mandrill

module.exports.send  = (code, cb) ->
  console.log 'send function'
  m = new Mandrill()
  params =
    message: 
      'to' : [{email:'england@localrucks.com', 'name' : 'Adam England'}]
    template_name : 'password-reset-request'
    template_content : [{PASSWORD_RESET_URL  : 'http://www.adamnengland.com'}]
  m.messages.sendTemplate params,  (info) ->
    console.log info
