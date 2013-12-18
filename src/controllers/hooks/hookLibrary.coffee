_ = require 'lodash'

module.exports.default = (options) ->
  options.success() if options.success

module.exports.unpopulate =  (options)=>
  if options.req.body.media != undefined and options.req.body.media?.length > 0
    _.each(options.req.body.media, (element, index)->
      console.log element
      options.req.body.media[index] = element._id.toString()
    )
  if options.req.body.promotionTargets?.length > 0
    _.each(options.req.body.promotionTargets, (element, index)->
      options.req.body.promotionTargets[index] = element._id.toString()
    )
  if options.req.body.businessPrivileges?.length > 0
    _.each(options.req.body.businessPrivileges, (element, index)->
      options.req.body.businessPrivileges[index].business = element.business._id.toString()
    )  
  options.success() if options.success