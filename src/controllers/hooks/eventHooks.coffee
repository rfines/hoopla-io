hookLibrary = require('./hookLibrary')

module.exports = exports =
  scheduleService : require('../../services/schedulingService')
  update:
    pre : hookLibrary.default
    post : (event, req, res, cb) =>
      exports.scheduleService.calculate event, (err, occurrences) ->
        if not err
          event.occurrences = occurrences
          event.save()
          cb()
  create:
    pre : hookLibrary.default 
    post : (event, req, res, cb) =>
      exports.scheduleService.calculate event, (err, occurrences) ->
        if not err
          event.occurrences = occurrences
          event.save()
          cb()
  search:
    pre : (req, res, cb) =>
      cb null
    post : (req, res, cb) =>    
      cb null