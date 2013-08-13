sinon = require 'sinon'

describe "User Routes", ->
  controller = {}
  req= {}
  res = {}
  next = {}

  before (done) ->
    done()

  beforeEach (done) ->
    controller = require('../../src/controllers/userController')
    mockedUser = {
      "_id" : "520a403f5fd0c6000000a609",
      "businessPrivileges" : [{
          "business" : "520a404c5fd0c6000000a9fa",
          "role" : "OWNER",
          "_id" : "520a410a5fd0c6000000af80"
        }]
    }
    controller.model = {
      findById:(id, fields, opts, next)->
        if id
          next null, mockedUser
    }
    
    mockedBusiness = 
    {
        "name": "Buttonwood Art Space",
        "_id": "520a404c5fd0c6000000a9fa"
    }

    controller.businessModel = {
      find: (query, fields, options, next)->
        next null, mockedBusiness
    }
    req.params = {}
    req.params.id = "520a403f5fd0c6000000a609"
    res = 
      send: ( (status, body) ->)
    done()

  it 'should return an error if no id is present', (done)->
    req.params.id = null
    res.status = 400
    res.body = 'Missing Required Parameter'
    controller.businesses req,res, (err, data)->
      if err
        console.log err
      else
        res.status.should.equal 400
        res.body.should.equal 'Missing Required Parameter'
        done()