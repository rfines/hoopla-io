_ = require 'lodash'

module.exports.default = (options) ->
  options.success() if options.success
module.exports.unpopulateMedia =  (options)=>
  if options.req.body.media?.length > 0 
    options.req.body.media = _.pluck(options.req.body.media, '_id')
    _.each(options.req.body.media, (element, index)->
      options.req.body.media[index] = element.toString()
    )
  options.success() if options.success