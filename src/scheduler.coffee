calculateSchedules = require('./jobs/calculateSchedules')
promoteEvents = require('./jobs/promoteEvents')
fiveMinutes = 300000

module.exports.start = ->
  calculateSchedules.runOnce()
  promoteEvents.runOnce()
  setInterval calculateSchedules.runOnce, fiveMinutes
  setInterval promoteEvents.runOnce, fiveMinutes