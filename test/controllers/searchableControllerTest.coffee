sinon = require 'sinon'
SearchableController = require('../../src/controllers/searchableController')


describe "Operations for Searchable Routes", ->
  controller = {}
  modelSpy = {}
  builder = {}
  mockedModel = {}
  mockedQuery = {}
  req = {}
  res = {} 
  before (done) ->  
    done()

  beforeEach (done) ->
    controller = new SearchableController()
    controller.type = 'event'
    controller.builder = {
      buildSearchQuery : (params)->
        return {}
    }
    mockedQuery = {
      skip: (x) ->
      limit: (x) ->
      populate: (x) ->
      exec: (x) ->
        x null, []
    }
    mockedModel = {
      find: (query, fields, options)->
        return mockedQuery
    }
    req = 
      params :
        ll : '1,1'
        near : '64105'
        keyword : 'myKeyword'
        height: 200
        width: 200
    res = 
      send: ( (status, body) ->)

    controller.model = mockedModel
    done()

  it 'should call elasticsearch when keyword is provided', (done) ->
    controller.searchService = 
      {
        find: (type, term, cb) ->
          cb null, []
      }
    
    spy = sinon.spy(controller.searchService, 'find')
    controller.search req, res, ->
      spy.calledWith('event', 'myKeyword').should.be.true
      done()

  it 'should not call elasticsearch when keyword is not provided', (done) ->
    req.params = {}
    controller.searchService = 
      {
        find: (type, term, cb) ->
          cb null, []
      }
    spy = sinon.spy(controller.searchService, 'find')
    controller.search req, res, ->
      spy.calledWith('event', 'myKeyword').should.be.false
      done()

  it "should correctly limit and skip if limit and skip params are passed", (done)->
    req = 
      params: 
        limit: 100
        skip: 1
        ll : '1,1'
    res = 
      send: ( (status, body) ->) 
    skipSpy = sinon.spy(mockedQuery, 'skip')
    limitSpy = sinon.spy(mockedQuery,'limit')
    controller.searchDatabase req, (err,data) ->
      skipSpy.calledWith(1).should.be.true
      limitSpy.calledWith(100).should.be.true
      done()

  it "should not use skip and limit if not passed", (done)->
    req.params = {ll : '1,1'}
    skipSpy = sinon.spy(mockedQuery, 'skip')
    limitSpy = sinon.spy(mockedQuery,'limit')
    controller.searchDatabase req, (err,data) ->
      skipSpy.called.should.be.false
      limitSpy.called.should.be.false
      done()

  it "should ignore the skip and limit parameters if keyword is passed", (done)->
    controller.searchService = 
    {
      find: (type, term, cb) ->
        cb null, []
    }
    req = 
      params:
        near: '64105'
        keyword: 'somekeyword'
        limit: 100
        skip: 2
        ll : '1,1'
    skipSpy = sinon.spy(mockedQuery, 'skip')
    limitSpy = sinon.spy(mockedQuery, 'limit')
    controller.search req,res, ->
      skipSpy.called.should.be.false
      limitSpy.called.should.be.false
      done()

  it "should not ignore the skip and limit parameters if keyword is not passed", (done)->
    req = 
      params:
        near: '64105'
        limit: 100
        skip: 2
        ll : '1,1'
    skipSpy = sinon.spy(mockedQuery, 'skip')
    limitSpy = sinon.spy(mockedQuery,'limit')
    controller.search req,res, ->
      skipSpy.called.should.be.true
      limitSpy.called.should.be.true
      done()

  it "should return an error if no near or ll param is passed", (done)->
    req = 
      params:
        limit: 100
        skip: 2
    controller.search req,res, ->
      console.log res
      res.status.should.equal 400
      done()
      
  it "should transform an image url to use the height and width parameters", (done)->
    mockedList = [{media:[{url:"http://res.cloudinary.com/durin-software/image/upload/v1375113455/p3ux4buvr7ayhbeykoiq.jpg"}]}]
    controller.rewriteImageUrl req, mockedList, (error, data)->
      if error
        console.log error
        done()
      else
        data[0].media[0].url.should.equal "http://res.cloudinary.com/durin-software/image/upload/h_200,w_200/p3ux4buvr7ayhbeykoiq.jpg"
        done()