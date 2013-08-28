hookLibrary = require('./hookLibrary')

module.exports = exports =
  scheduleService : require('../../services/schedulingService')
  create:
    pre : hookLibrary.unpopulateMedia
    post : (options) =>
      exports.scheduleService.calculate options.target, (err, occurrences) ->
        if not err
          options.target.occurrences = occurrences
          options.target.save()
          options.success() if options.success  
  update:
    pre : hookLibrary.unpopulateMedia
    post : (options) =>
      exports.scheduleService.calculate options.target, (err, occurrences) ->
        if not err
          options.target.occurrences = occurrences
          options.target.save()
          options.success() if options.success
  search:
    pre : hookLibrary.default
    post : hookLibrary.default
  destroy:
    pre : hookLibrary.default
    post : hookLibrary.default    