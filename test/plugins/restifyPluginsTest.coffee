sinon = require 'sinon'
req = {}
res = {}

describe "Restify Plugins", ->
  modelSpy = {}
  plugins = {}
  req = 
    params :
      near : ''
  res = 
    send: ( (status, body) ->)     

  before (done) ->  
    done()

  beforeEach (done) ->
    plugins = require('../../src/plugins/restifyPlugins')
    modelSpy = 
      get : (code, cb) ->
        cb null, {geo: { type:'Point', coordinates:[1.001, 1.001]}}
    req.postalCodeService = modelSpy
    req.geoCoder = 
      geocodeAddress : (query, cb) ->
        cb null, {latitude : 1.01, longitude: 1.01}
    done()      

  it "should get the zip code coordinates from the database when the near param is passed with a postal code", (done) ->
    spy = sinon.spy(req.postalCodeService, "get");
    req.params.near = '64105'
    plugins.NearParamParser req, res, ->
      spy.calledWith('64105').should.be.true
      req.params.ll.should.eql '1.001,1.001'
      done()

  it "should build a query using near city,state", (done) ->
    req.params.near = 'Kansas City, MO'
    plugins.NearParamParser req, res, ->
      req.params.ll.should.eql '1.01,1.01'
      done()