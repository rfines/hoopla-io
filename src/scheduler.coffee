calculateSchedules = require('./jobs/calculateSchedules')
promoteEvents = require('./jobs/promoteEvents')
createIndexes = require('./jobs/createIndexes')
addBusinessToAdmin = require('./jobs/addBusinessesToAdmin')
fiveMinutes = 300000

module.exports.start = ->
  calculateSchedules.runOnce()
  #promoteEvents.runOnce()
  #createIndexes.runOnce()
  #addBusinessToAdmin.runOnce()
  #setInterval calculateSchedules.runOnce, fiveMinutes
  #setInterval promoteEvents.runOnce, fiveMinutes