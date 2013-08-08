module.exports =
  create: 
    post : (business, req, res, next, cb) ->
      req.authUser.save (err) ->
        cb() if cb