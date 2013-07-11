restify = require 'restify'
ApiUsage = require('../models/apiUsage').ApiUsage

init = (server, routes) ->
  for x in routes
    method = x[0]
    handlerFunction = x[0]
    path = x[1]
    controller = x[2]
    if x[3]
      handlerFunction = x[3].handler || handlerFunction
    server[method] path, controller[handlerFunction]

  server.on "after", (request, response, route, error) ->
    u = new ApiUsage()
    u.method = route.method if route.method
    u.status = response.statusCode if response.statusCode
    u.url = route._url if route._url
    u.save()

module.exports =
	init : init