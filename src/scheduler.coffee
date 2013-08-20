schedule = require('node-schedule')
calculateSchedules = require('./jobs/calculateSchedules')
promoteEvents = require('./jobs/promoteEvents')
fiveMinutes = 300000

module.exports.start = ->
  calculateSchedules.runOnce()
  promoteEvents.runOnce()

  schedule.scheduleJob "*/5 * * * *", calculateSchedules.runOnce
  schedule.scheduleJob "*/5 * * * *", promoteEvents.runOnce
