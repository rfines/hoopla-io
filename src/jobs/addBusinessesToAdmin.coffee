_ = require 'lodash'
scheduleService = require('../services/schedulingService')
business = require('../models/business').Business
async = require 'async'
user = require('../models/user').User

module.exports.runOnce = (onComplete) ->

  user.findOne {'email': 'info@localruckus.com'}, {}, {}, (err, adminUser)=>
    currentPrivs = adminUser.get('businessPrivileges')
    business.find {}, {_id:1}, {lean:true}, (err, allBusinesses) =>
      out = _.map allBusinesses, (b) ->
        return {
          role: 'ADMIN_COLLABORATOR'
          business: b._id
        }
      adminUser.update {$set : {businessPrivileges : out}}, (err, out) =>
        onComplete() if onComplete