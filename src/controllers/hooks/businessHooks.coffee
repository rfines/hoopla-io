module.exports =
  create:
    pre : (resource, req, res, cb) =>
      cb null
    post : (business, req, res, cb) ->  
      req.authUser.businessPrivileges.push {businessId : business._id, role : 'OWNER'}
      req.authUser.save (err) ->
        cb() if cb
  update:
    pre : (resource, req, res, cb) =>
      cb null
    post : (target) =>
  search:
    pre : (req, res, cb) =>
      cb null
    post : (req, res, cb) =>    
      cb null        