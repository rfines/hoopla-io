_ = require 'lodash'

module.exports.default = (options) ->
  options.success() if options.success

module.exports.unpopulate =  (options)=>
  if options.req.body.media?.length > 0  and options.req.body.media?.indexOf('_id') != -1
    options.req.body.media = _.pluck(options.req.body.media, '_id')
    _.each(options.req.body.media, (element, index)->
      options.req.body.media[index] = element.toString()
    )
  if options.req.body.promotionTargets?.length > 0 and options.req.body.promotionTargets?.indexOf('_id') != -1
    options.req.body.promotionTargets = _.pluck(options.req.body.promotionTargets, '_id')
    _.each(options.req.body.promotionTargets, (element, index)->
      options.req.body.promotionTargets[index] = element.toString()
    )    
  options.success() if options.success