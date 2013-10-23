_ = require 'lodash'
business = require('hoopla-io-core').Business
user = require('hoopla-io-core').User

module.exports.runOnce = (onComplete) ->
  user.findOne {'email': 'info@localruckus.com'}, {}, {}, (err, adminUser)=>
    currentPrivs = adminUser.get('businessPrivileges')
    business.find {'sources.sourceType':'hoopla'}, {_id:1}, {lean:true}, (err, allBusinesses) =>
      out = _.map allBusinesses, (b) ->
        return {
          role: 'ADMIN_COLLABORATOR'
          business: b._id
        }
      adminUser.update {$set : {businessPrivileges : out}}, (err, out) =>
        onComplete() if onComplete