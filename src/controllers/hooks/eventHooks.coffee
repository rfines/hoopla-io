expansions = {
  'ENTERTAINMENT':['ATTRACTIONS', 'AMUSEMENT', 'ARCADES', 'GALLERIES', 'BOWLING', 'BREWERIES', 'CASINOS', 'CHILDREN', 'COMEDY','FESTIVALS', 'FARMERS', 'ORCHARDS','FINEARTS','GOLF' , 'HISTORIC', 'LIBRARY', 'MOVIE', 'MUSEUMS', 'NIGHTLIFE', 'PARKS', 'PERFORMING','PERFORMINGARTS', 'PETS',"SPORTS", 'SHOPPING', 'STADIUM', 'THEATERES', 'UNIQUE', 'WINERIES', 'ZOOS','CLASSICROCK', 'FOLK', 'ALTERNATIVE', 'CLASSICAL', 'ELECTRONICA', 'INDIE', 'POP', 'ROCK', 'ACOUSTIC', 'JAZZ', 'RAP', 'BLUES', 'COUNTRY', 'METAL', 'REGGAE', 'PROGRESSIVE', 'PUNK', 'ROCKABILLY', 'HOLIDAY', "ALTERNATIVE", "BLUES", "AMERICANA", "CHILD", "CHRISTIAN", "DANCE", "EXPERIMENTAL", "RAP", "INDIE", "LATIN", "NEWAGE", "REGGAE", "SOUL", "ROCKABILLY","TRIBUTE","VARIOUS","WORLD", 'EXHIBITS', 'EXPOS', 'BARGAMES', 'DRINK', 'HISTORICAL', 'BUSINESS', 'CHARITY', 'TEENS', 'NEIGHBORHOOD', 'ENTREPRENEUR', 'FAITH', 'FAMILY', 'FAIRS', 'FILM', 'FOODS', 'WELLNESS', 'HOLIDAY', 'LGBT', 'LITERARY', 'CONCERTS', 'OTHER', 'PETS', 'POLITICAL','SCHOOL', 'SCIENCE', 'SHOPPING', 'FITNESS','VISUAL', 'PROFESSIONAL', "COMMUNITY"]
  'ARTS' : ['CHARITY','COMEDY','FILM','FINEARTS','FOODS', 'FESTIVALS','HISTORICAL','LITERARY','PERFORMING','PERFORMINGARTS','MULTICULTURE']
  'FAMILY-AND-CHILDREN' : ['TEENS','CHILDRENS','FAMILY', 'MULTICULTURE','LIBRARY']
  'FOOD-AND-DRINK' : ['BEER','COCKTAILS','FOOD','WINE']
  'MUSIC' : ['CLASSICROCK', 'FOLK', 'ALTERNATIVE', 'CLASSICAL', 'ELECTRONICA', 'INDIE', 'POP', 'ROCK', 'ACOUSTIC', 'JAZZ', 'RAP', 'BLUES', 'COUNTRY', 'METAL', 'REGGAE', 'PROGRESSIVE', 'PUNK', 'ROCKABILLY', 'HOLIDAY', "ALTERNATIVE", "BLUES", "AMERICANA", "CHILD", "CHRISTIAN", "DANCE", "EXPERIMENTAL", "RAP", "INDIE", "LATIN", "NEWAGE", "REGGAE", "SOUL", "ROCKABILLY","TRIBUTE","VARIOUS","WORLD"]
}
hookLibrary = require('./hookLibrary')
async = require 'async'

module.exports = exports =
  create:
    pre : (options) ->
      if not options.req.body.sources?
        options.req.body.sources = [{type:'hoopla'}]
      hookLibrary.unpopulate(options)
    post : (options) ->
      searchService.indexEvent options.target
      options.success() if options.success
  update:
    pre : (options) ->
      if not options.req.body.sources?
        options.req.body.sources = [{type:'hoopla'}]
      hookLibrary.unpopulate(options)
    post : (options) ->
      searchService.indexEvent options.target
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