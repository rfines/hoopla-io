service = require('../../src/services/routingService')

describe "Restify Services", ->
  
  it "should rewrite delete methods to the destroy handler", (done) ->
    server = {
      del : (url, handler) ->
        handler()
      on : (->)
    }
    controller = {
      destroy: ->
        done()
    }
    routes = [
      ['del', '/user/:id', controller]
    ]
    service.init(server, routes)


  it "should rewrite post methods to the create handler", (done) ->
    server = {
      post : (url, handler) ->
        handler()
      on : (->)
    }
    controller = {
      create: ->
        done()
    }
    routes = [
      ['post', '/user', controller]
    ]
    service.init(server, routes)    