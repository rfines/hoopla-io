_ = require 'lodash'

module.exports.default = (options) ->
  options.success() if options.success

module.exports.unpopulate =  (options)=>
  if options.req.body.media?.length > 0
    _.each(options.req.body.media, (element, index)->
      options.req.body.media[index] = element._id.toString()
    )
  if options.req.body.promotionTargets?.length > 0
    _.each(options.req.body.promotionTargets, (element, index)->
      options.req.body.promotionTargets[index] = element._id.toString()
    )    
  options.success() if options.success