sinon = require 'sinon'
moment = require 'moment'
_ = require 'lodash'


describe "Legacy Routes", ->
  hooks = {}
  req = {}
  res = {}
  
  before (done) ->
    done()
  
  beforeEach (done) ->
    hooks = require('../../../src/controllers/hooks/legacyHooks')
    hooks.postalCodeService.get = (query, cb) ->
      cb null, {
        geo :
          coordinates : [1.123,1.123]
      }    
    done()

  it 'should transform the zipcode parameter to an LL parameter', (done)->
    req.params = {}
    req.params.zipcode = '64105'
    req.params.apiKey = 'CjV94IobahVjMt9'
    hooks.transformRequest req,res, (err,result) ->
      if err
        console.log err
      else
        result.should.eql {"params":{'apiKey' : 'CjV94IobahVjMt9', 'll': '1.123,1.123'}}
    done()

  it 'should transform the cost parameter to a usable float value', (done)->
    req.params = {}
    req.params.ll = '-94.595033,39.102704'
    req.params.apiKey = 'CjV94IobahVjMt9'
    req.params.cost = '20'
    hooks.transformRequest req,res, (err,result) ->
      if err
        console.log err
      else
        result.should.eql {"params":{ 'll': '1.123,1.123','apiKey' : 'CjV94IobahVjMt9', 'cost': 20.00}}
        done()

  it 'should transform the categories parameter to a usable set of tags', (done)->
    req.params = {}
    req.params.ll = '-94.595033,39.102704'
    req.params.apiKey = 'CjV94IobahVjMt9'
    req.params.categories = 'Beer'
    hooks.transformRequest req,res, (err,result) ->
      if err
        console.log err
      else
        result.should.eql {"params":{ 'll': '1.123,1.123','apiKey' : 'CjV94IobahVjMt9', 'tags': ['BEER']}}
        done()
 