_ = require('lodash')
User = require('hoopla-io-core').User
Business = require('hoopla-io-core').Business
Event = require('hoopla-io-core').Event
async = require('async')
moment = require('moment')
twoDaysAgo = moment.utc().startOf('month')

checkUser = (item) ->
  return moment.utc(item._id.getTimestamp()).isAfter(twoDaysAgo)

module.exports.runOnce = (onComplete) ->
  report = []
  buildUserStats = (user, cb) ->
    o = {userId : user._id, email: user.email}
    o.signupDate = moment.utc(user._id).format('MM/DD/YYYY')
    businessIds = _.pluck user.businessPrivileges, 'business'
    Business.find {_id : {$in : businessIds}}, {}, {lean:true}, (err, businesses) ->
      
      o.businesses = _.pluck businesses, 'name'
      Event.count {business : {$in : _.pluck(businesses, '_id')}}, (err, count) ->
        o.eventCount = count
        report.push o
        cb null
  User.find {}, {}, {lean:true}, (err, users) ->
    newUsers = _.filter users, checkUser
    async.each newUsers, buildUserStats, ->
      console.log report
      onComplete() if onComplete