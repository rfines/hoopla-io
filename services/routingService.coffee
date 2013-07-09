init = (server, routes) ->
  for x in routes
    method = x[0]
    handlerFunction = x[0]
    path = x[1]
    controller = x[2]
    if x[3]
      handlerFunction = x[3].handler || handlerFunction
    server[method] path, controller[handlerFunction]

module.exports =
	init : init