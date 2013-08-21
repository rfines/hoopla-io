hookLibrary = require('./hookLibrary')

module.exports = exports = 
  bcryptService : require('../../services/bcryptService')
  collaboratorRequest : require('../../models/collaboratorRequest').CollaboratorRequest
  create:
    pre : (options) ->
      user = options.target
      exports.bcryptService.encrypt user.password, (encrypted) ->
        user.password = encrypted
        user.encryptionMethod = 'BCRYPT'
        options.success() if options.success
    post: (options) ->
      user = options.target
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
          options.error({code:401,message:"Could not find collaboration request."}) if options.error
  update:
    pre : hookLibrary.default
    post : hookLibrary.default    
  destroy:
    pre : hookLibrary.default
    post : hookLibrary.default    
