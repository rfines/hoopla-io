expansions = {
  'ARTS' : ['CHARITY','COMEDY','FILM','FINEARTS','FOODS', 'FESTIVALS','HISTORICAL','LITERARY','PERFORMING','PERFORMINGARTS']
  'FAMILY-AND-CHILDREN' : ['TEENS','CHILDRENS','FAMILY']
  'FOOD-AND-DRINK' : ['BEER','COCKTAILS','FOOD','WINE']
  'MUSIC' : ['CLASSICROCK','FOLK','ALTERNATIVE','CLASSICAL','ELECTRONICA','INDIE','POP','ROCK', 'ACOUSTIC', 'JAZZ', 'RAP', 'BLUES', 'COUNTRY', 'METAL','REGGAE','PROGRESSIVE','ROCKABILLY','HOLIDAY']
}
hookLibrary = require('./hookLibrary')
async = require 'async'

module.exports = exports =
  scheduleService : require('../../services/schedulingService')
  create:
    pre : hookLibrary.unpopulate
    post : (options) =>
      exports.scheduleService.calculate options.target, (err, occurrences) ->
        if not err
          options.target.occurrences = occurrences
          options.target.save()
          options.success() if options.success  
  update:
    pre : hookLibrary.unpopulate
    post : (options) =>
      exports.scheduleService.calculate options.target, (err, occurrences) ->
        if not err
          options.target.occurrences = occurrences
          options.target.save()
          options.success() if options.success
  search:
    pre : (options) ->
      if options.req.params?.tags
        newTags = []
        expand = (t, cb) ->
          if expansions[t]
            for x in expansions[t]
              newTags.push x      
          else
            newTags.push t    
          cb null
        async.each options.req.params.tags.split(','), expand, ->
          options.req.params.tags = newTags.join(',')
          options.success() if options.success
      else
        options.success() if options.success
    post : hookLibrary.default
  destroy:
    pre : hookLibrary.default
    post : hookLibrary.default  

