restify = require 'restify'
ApiUsage = require('hoopla-io-core').ApiUsage

methodRewrite = 
  del : 'destroy'
  post : 'create'
  put : 'update'

init = (server, routes) ->
  for x in routes
    method = x[0]
    handlerFunction = x[0]
    path = x[1]
    controller = x[2]
    handlerFunction = getHandlerFunction(method, x[3])
    server[method] path, controller[handlerFunction]
  
  server.on "after", (request, response, route, error) ->
    if route and response
      authorization = request.authorization
      u = new ApiUsage()
      u.method = route.methods[0] if route.methods and route.methods.length > 0
      u.status = response.statusCode if response.statusCode
      u.url = route.spec.path if route.spec.path
      u.apiToken = authorization.basic.username
      u.save()

  unknownMethodHandler = (req, res) ->
    if req.method.toLowerCase() is "options"
      allowHeaders = ["Accept", "Accept-Version", "Content-Type", "Api-Version", "Origin", "X-Requested-With", 'Authorization']
      res.methods.push "OPTIONS"  if res.methods.indexOf("OPTIONS") is -1
      res.header "Access-Control-Allow-Credentials", true
      res.header "Access-Control-Allow-Headers", allowHeaders.join(", ")
      res.header "Access-Control-Allow-Methods", res.methods.join(", ")
      res.header "Access-Control-Allow-Origin", req.headers.origin
      res.send 204
    else
      res.send new restify.MethodNotAllowedError()

  server.on "MethodNotAllowed", unknownMethodHandler      

getHandlerFunction = (method, options) ->
  handlerFunction = method
  handlerFunction = methodRewrite[method] if methodRewrite[method]
  if options
    handlerFunction = options.handler || handlerFunction
  handlerFunction

module.exports =
	init : init