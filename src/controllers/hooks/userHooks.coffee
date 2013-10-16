hookLibrary = require('./hookLibrary')
mailchimpService = require '../../services/mailchimpService'
_ = require 'lodash'

module.exports = exports = 
  bcryptService : require('../../services/bcryptService')
  mailchimpService : require '../../services/mailchimpService'
  collaboratorRequest : require('hoopla-io-core').CollaboratorRequest
  create:
    pre : (options) ->
      exports.bcryptService.encrypt options.req.body.password, (encrypted) ->
        options.req.body.password = encrypted
        options.req.body.encryptionMethod = 'BCRYPT'
        options.success() if options.success
    post: (options) ->
      user = options.target
      added = exports.mailchimpService.addToEmailList(user.email)
      exports.collaboratorRequest.findOne {email: user.email}, {}, {}, (err, collab) ->
        if collab
          collab.completedDate = new Date()
          collab.save (err)->
            if err
              options.error(err) if options.error
            else
              user.businessPrivileges.push
                business: collab.businessId
                role: 'COLLABORATOR'
              user.save (error)->
                if error
                  options.error(error) if options.error
                else
                  options.success() if options.success
        else
          if options.error
            options.error({code:401,message:"Could not find collaboration request."}) 
          else
            options.success() if options.success

  update:
    pre :hookLibrary.unpopulate
    post : hookLibrary.default    
  destroy:
    pre : hookLibrary.default
    post : hookLibrary.default    
