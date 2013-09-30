CONFIG = require 'config'
_ = require 'lodash'
request = require("request")
mailchimp = require("mailchimp-api")
mc={}
listId = ''
init = ()=>
  mc = new mailchimp.Mailchimp(CONFIG.email.mailchimp.apiKey)
  mc.lists.list({filters:{list_id:CONFIG.email.mailchimp.listId}},(data)=>
    listId = data.data[0].id

  )
  resp = {mailChimp: mc, listId:listId }
  return resp
addToEmailList=(email)=>
  mc.lists.subscribe
    id:listId
    email: 
      email:
        email
    double_optin: false
    send_welcome: false
    , ((data)=>
      return true
    ),(error)=>
        if error.error
          console.log error.error
        else 
          console.log "Error subscribing"
        return false
      

module.exports=
  init:init
  addToEmailList:addToEmailList