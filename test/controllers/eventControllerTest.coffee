mongoose = require 'mongoose'
sinon = require 'sinon'
EventController = require('../../src/controllers/eventController')

describe "Operations for Event Routes", ->
  controller = {}

  before (done) ->  
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/eventController')
    done()

  it 'should not allow destroy when the user does not have business privileges that match the events business', (done) ->
    authUser = {
      businessPrivileges : [{}]
    }
    event = {
      business : new mongoose.Types.ObjectId()
    }
    controller.security.destroy(authUser, event).should.be.false
    done()

  it 'should allow destroy when the user has business privileges that match the events business', (done) ->
    bid = new mongoose.Types.ObjectId()
    authUser = {
      businessPrivileges : [{business : bid, role:'COLLABORATOR'}]
    }
    event = {
      business : bid
    }
    controller.security.destroy(authUser, event).should.be.true
    done()    
    
  
