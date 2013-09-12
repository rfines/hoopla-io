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
        @hooks.destroy.pre
          req:req
          res:res
          target:target
          fail: ()->
              res.send {success:false,message:"This media is in use."}, { 'Content-type': 'application/json' }, 400
              next()
          success: ()=>  
            target.remove (err, doc) =>
              if err
                console.log err
              else 
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
    originalBody = JSON.parse(JSON.stringify(req.body))
    delete req.body._id
    @model.findById req.params.id, {}, {}, (err, target) =>
      if @security.update(req.authUser, target)
        @hooks.update.pre
          target:target
          req: req
          success: () =>
            target.update req.body, (err, doc) =>
              if err
                res.send 400, err
              else
                @hooks.update.post
                  target : target
                  req : req
                  res : res
                  success: =>
                    if @populate?.length > 0
                      out = target.toObject()
                      for x in @populate
                        out[x] = originalBody[x]
                      res.send 200, out
                    else
                      res.send 200, doc
                    next()               
      else
        return next new restify.NotAuthorizedError("You are not permitted to perform this operation.")        

  create: (req, res, next) =>
      originalBody = JSON.parse(JSON.stringify(req.body))
      @hooks.create.pre 
        req : req
        res : res
        success: =>
          target = new @model(req.body)
          if @security.create(req.authUser, target)
            target.validate (err) =>
              if err
                res.send 400, err.errors
                next()
              else
                target.save (err, doc) =>
                  if err
                    res.send 400, err
                  else
                    @hooks.create.post 
                      target : target
                      req : req
                      res : res
                      success: =>
                        if @populate?.length > 0
                          out = doc.toObject()
                          for x in @populate
                            out[x] = originalBody[x]
                          res.send 201, out
                        else
                          res.send 201, doc
                        next()
          else
            next new restify.NotAuthorizedError("You are not permitted to perform this operation.")       


module.exports = RestfulController