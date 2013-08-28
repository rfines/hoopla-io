restify = require("restify")
securityConstraints = require('./helpers/securityConstraints')

class RestfulController
  getFields : {}

  security: 
    get : securityConstraints.anyone
    destroy : (authenticatedUser, target) ->
      true
    update : (authenticatedUser, target) ->
      true
    create : (authenticatedUser, target) ->
      true    

  hooks: require('./hooks/restfulHooks') 

  search : (req, res, next) =>  
    query = {}
    @model.find query, @getFields, (err, data) ->
      res.send data
      next()

  get : (req, res, next) =>
    id = req.params.id
    checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$")
    if not checkForHexRegExp.test(id)
      @model.findOne {legacyId : req.params.id}, @getFields, {lean : true}, (err, target) =>
        if @security.get(req.authUser, target)
          if not err and not target
            res.send 404
          else  
            res.send 200, target
          next()
        else
          return next new restify.NotAuthorizedError("You are not permitted to perform this operation.")
    else
      @model.findById req.params.id, @getFields, {lean : true}, (err, target) =>
        if @security.get(req.authUser, target)
          if not err and not target
            res.send 404
          else  
            res.send 200, target
          next()
        else
          return next new restify.NotAuthorizedError("You are not permitted to perform this operation.")

  destroy: (req, res, next) =>
    @model.findById req.params.id, {}, {}, (err, target) =>
      return next new restify.ResourceNotFoundError() if not target
      if @security.destroy(req.authUser, target)
        target.remove (err, doc) =>
          @hooks.destroy.post 
            resource : target
            req : req
            res : res
            success: () -> 
              res.send 204
              next()    
      else
        return next new restify.NotAuthorizedError("You are not permitted to perform this operation.")
  
  update: (req, res, next) =>
    delete req.body._id
    @model.findById req.params.id, {}, {}, (err, target) =>
      if @security.update(req.authUser, target)
        target.update req.body, (err, doc) =>
          @hooks.update.post
            target : target
            req : req
            res : res
            success: =>
              res.send(200, doc)
              next()               
      else
        return next new restify.NotAuthorizedError("You are not permitted to perform this operation.")        

  create: (req, res, next) =>
    target = new @model(req.body)
    if @security.create(req.authUser, target)
      @hooks.create.pre 
        target : target
        req : req
        res : res
        success: =>
          target.validate (err) =>
            if err
              errors = err.errors
              res.send 400, errors
              next()
            else
              target.save (err, doc) =>
                @hooks.create.post 
                  target : target
                  req : req
                  res : res
                  success: =>
                    res.send 201, doc
                    next()
    else
      next new restify.NotAuthorizedError("You are not permitted to perform this operation.")       


module.exports = RestfulController