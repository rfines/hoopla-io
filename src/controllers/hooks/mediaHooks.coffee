async = require 'async'
_ = require 'lodash'
hookLibrary = require('./hookLibrary')
cloudinary = require 'cloudinary'
utils = require '../helpers/imageManipulation'

module.exports = exports = 
  UserService : require('../../services/data/userService')
  create:
    pre : (options)=>
      if options.target
        options.target.user = options.req.authUser
      else
        options.target.user = options.req.authUser
      options.success() if options.success
    post : hookLibrary.default
  update:
    pre : hookLibrary.default
    post : hookLibrary.default
  search:
    pre : hookLibrary.default
    post : hookLibrary.default
  destroy:
    pre : (options)=>
      if options.target
        business = require('../../models/business').Business
        event = require('../../models/event').Event
        found = false
        business.find {media: options.target._id}, {},{lean:true}, (err,doc)=>
          if err
            console.log err
            options.fail()
          else if doc.length > 0
            found = true
            options.fail()
          else
            event.find {media:options.target._id}, {},{lean:true}, (error, docs)=>
              if error
                options.error = error
                options.fail()
              else if docs.length > 0
                found = true
                options.fail()
              else
                id = utils.getId(options.target.url)
                if _.isObject(id)
                  stId = id.toString()
                  stId = stId.split('.')[0]
                else
                  stId = id.split('.')[0]
                cloudinary.api.delete_resources([stId], (result)=>
                  if _.has result.deleted, stId
                    ob = result.deleted[stId.toString()]
                    if ob is 'not_found' or ob is 'deleted'
                      options.success()
                    else
                      options.fail()
                  else
                    options.fail()
                )

    post : hookLibrary.default
