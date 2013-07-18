restify = require 'restify'
ApiUsage = require('../models/apiUsage').ApiUsage

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
      u = new ApiUsage()
      u.method = route.methods[0] if route.methods and route.methods.length > 0
      u.status = response.statusCode if response.statusCode
      u.url = route.spec.path if route.spec.path
      u.save()

getHandlerFunction = (method, options) ->
  handlerFunction = method
  handlerFunction = methodRewrite[method] if methodRewrite[method]
  if options
    handlerFunction = options.handler || handlerFunction
  handlerFunction

module.exports =
	init : init