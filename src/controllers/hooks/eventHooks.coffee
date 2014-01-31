expansions = {
  'ENTERTAINMENT':['ATTRACTIONS', 'AMUSEMENT', 'ARCADES', 'GALLERIES', 'BOWLING', 'BREWERIES', 'CASINOS', 'CHILDREN', 'COMEDY','FESTIVALS', 'FARMERS', 'ORCHARDS','FINEARTS','GOLF' , 'HISTORIC', 'LIBRARY', 'MOVIE', 'MUSEUMS', 'NIGHTLIFE', 'PARKS', 'PERFORMING','PERFORMINGARTS', 'PETS',"SPORTS", 'SHOPPING', 'STADIUM', 'THEATERES', 'UNIQUE', 'WINERIES', 'ZOOS','CLASSICROCK', 'FOLK', 'ALTERNATIVE', 'CLASSICAL', 'ELECTRONICA', 'POP', 'ROCK', 'ACOUSTIC', 'JAZZ', 'RAP', 'COUNTRY', 'METAL', 'REGGAE', 'PROGRESSIVE', 'PUNK', 'HOLIDAY', "HOLIDAYSEASONAL", "BLUES", "AMERICANA", "CHILD", "CHRISTIAN", "DANCE", "EXPERIMENTAL", "INDIE", "LATIN", "NEWAGE", "REGGAE", "SOUL", "ROCKABILLY","TRIBUTE","VARIOUS","WORLD", 'EXHIBITS', 'EXPOS', 'BARGAMES', 'DRINK', 'HISTORICAL', 'BUSINESS', 'CHARITY', 'TEENS', 'NEIGHBORHOOD', 'ENTREPRENEUR', 'FAITH', 'FAMILY', 'FAIRS', 'FILM', 'FOODS', 'WELLNESS', 'LGBT', 'LITERARY', 'CONCERTS', 'OTHER', 'POLITICAL','SCHOOL', 'SCIENCE', 'FITNESS','VISUAL', 'PROFESSIONAL', "COMMUNITY", "COLLEGE-SPORTS", "DRINK"]
  'ARTS' : ['CHARITY','COMEDY','FILM','FINEARTS','FOODS', 'FESTIVALS','HISTORICAL','LITERARY','PERFORMING','PERFORMINGARTS','MULTICULTURE']
  'FAMILY-AND-CHILDREN' : ['TEENS','CHILDRENS','FAMILY', 'MULTICULTURE','LIBRARY', "SPORTS", "COLLEGE-SPORTS"]
  'FOOD-AND-DRINK' : ['BEER','COCKTAILS','FOOD','WINE', "DRINK", "SEAFOOD","STEAKHOUSE",]
  'MUSIC' : ['CONCERTS', 'CONCERT','CLASSICROCK', 'FOLK', 'ALTERNATIVE', 'CLASSICAL', 'ELECTRONICA', 'INDIE', 'POP', 'ROCK', 'ACOUSTIC', 'JAZZ', 'RAP', 'BLUES', 'COUNTRY', 'METAL', 'REGGAE', 'PROGRESSIVE', 'PUNK', 'ROCKABILLY', 'HOLIDAY', "ALTERNATIVE", "BLUES", "AMERICANA", "CHILD", "CHRISTIAN", "DANCE", "EXPERIMENTAL", "RAP", "INDIE", "LATIN", "NEWAGE", "REGGAE", "SOUL", "ROCKABILLY","TRIBUTE","VARIOUS","WORLD"]
  'CAMPUS':[ "COLLEGE-SPORTS","CAMPUS-ONLY"]
}
searchService = require('../../services/searchService')
hookLibrary = require('./hookLibrary')
async = require 'async'
_ = require 'lodash'

module.exports = exports =
  create:
    pre : (options) ->
      if not options.req.body.sources?
        options.req.body.sources = [{sourceType:'hoopla', lastUpdated: new Date()}]
        options.req.body.createDate = new Date()
        options.req.body.createUser = options.req.authUser
      hookLibrary.unpopulate(options)
    post : (options) ->
      searchService.indexEvent options.target
      options.success() if options.success
  update:
    pre : (options) ->
      if not options.req.body.sources?
        options.req.body.sources = [{sourceType:'hoopla', lastUpdated: new Date()}]
      if not options.req.body.host
        options.req.body.host = undefined
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
          newTags = _.uniq newTags    
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