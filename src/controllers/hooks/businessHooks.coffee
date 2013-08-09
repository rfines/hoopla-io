module.exports =
  create: 
    post : (business, req, res, next, cb) ->
      req.authUser.businessPrivileges.push {businessId : business._id, role : 'OWNER'}
      req.authUser.save (err) ->
        cb() if cb