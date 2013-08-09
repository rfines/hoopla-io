module.exports = exports =
  scheduleService : require('../../services/schedulingService')
  update:
    post : (event) =>
      exports.scheduleService.calculate event, (err, occurrences) ->
        if not err
          event.occurrences = occurrences
          event.save()
  create:
    post : (event) =>
      exports.scheduleService.calculate event, (err, occurrences) ->
        if not err
          event.occurrences = occurrences
          event.save()
  search:
    pre : (req, res, cb) =>
      cb null
    post : (req, res, cb) =>    
      cb null