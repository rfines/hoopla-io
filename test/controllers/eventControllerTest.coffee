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
      businessId : new mongoose.Types.ObjectId()
    }
    controller.security.destroy(authUser, event).should.be.false
    done()

  it 'should allow destroy when the user has business privileges that match the events business', (done) ->
    bid = new mongoose.Types.ObjectId()
    authUser = {
      businessPrivileges : [{businessId : bid, role:'COLLABORATOR'}]
    }
    event = {
      businessId : bid
    }
    controller.security.destroy(authUser, event).should.be.true
    done()    
    
  
