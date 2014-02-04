User = require('hoopla-io-core').User
async = require('async')
moment = require('moment')
#, "pittsburgks@localruckus.com", "manhattanks@localruckus.com"
module.exports.runOnce = (onComplete) ->
  emails= ["info@localruckus.com", "pittsburgks@localruckus.com", "manhattanks@localruckus.com"]
  handler = (item,cb)=>
    u = User.findOne {email:item}, {}, {}, (e, d)=>
      if e
        console.log e
        cb e, null
      else if d
        async.each d.businessPrivileges, fixPrivileges, (err)=>
          if err
            console.log err
            cb "error", null
          else
            d.save (error, doc)=>
              if error
                console.log error
                cb error, null
              else
                cb null, doc
      else
        cb null, ""
  fixPrivileges = (item, cb)=>
    item.role="ADMIN_COLLABORATOR"
    cb null, "success"

  async.each emails, handler, (err)=>
    if err
      console.log err
    console.log "Completed"
    onComplete() if onComplete
