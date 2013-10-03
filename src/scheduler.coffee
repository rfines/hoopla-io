calculateSchedules = require('./jobs/calculateSchedules')
promoteEvents = require('./jobs/promoteEvents')
createIndexes = require('./jobs/createIndexes')
fiveMinutes = 300000

module.exports.start = ->
  #calculateSchedules.runOnce()
  #promoteEvents.runOnce()
  createIndexes.runOnce()
  #setInterval calculateSchedules.runOnce, fiveMinutes
  #setInterval promoteEvents.runOnce, fiveMinutes