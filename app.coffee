restify = require("restify")
server = restify.createServer(name: "ruckus.io-api")
server.listen 8080

eventController = require './controllers/eventController'

routes = [
  ['get', '/event/:id', eventController]
  ['get', '/event/:id/secret', eventController, {handler: 'getSecret'}]
]

for x in routes
  method = x[0]
  handlerFunction = x[0]
  path = x[1]
  controller = x[2]
  if x[3]
    handlerFunction = x[3].handler || handlerFunction
  server[method] path, controller[handlerFunction]