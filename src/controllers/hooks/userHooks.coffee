hookLibrary = require('./hookLibrary')

module.exports = exports = 
  bcryptService : require('../../services/bcryptService')
  collaboratorRequest : require('../../models/collaboratorRequest').CollaboratorRequest
  create:
    pre : (user, req, res, cb) ->
      exports.bcryptService.encrypt user.password, (encrypted) ->
        user.password = encrypted
        user.encryptionMethod = 'BCRYPT'
        cb()
    post: (user, cb) ->
      exports.collaboratorRequest.findOne {email: user.email}, {}, {}, (err, collab) ->
        if collab
          collab.completedDate = new Date()
          collab.save (errors)->
            if errors
              console.log errors
              cb errors, null
            else
              user.businessPrivileges.push
                business: collab.businessId
                role: 'COLLABORATOR'
              user.save (error)->
                if error
                  console.log error
                  cb error, null
                else
                  cb null, null
        else
          cb {code:401,message:"Could not find collaboration request."}, null

  update:
    pre : hookLibrary.default
    post : hookLibrary.default    
    post : hookLibrary.default    