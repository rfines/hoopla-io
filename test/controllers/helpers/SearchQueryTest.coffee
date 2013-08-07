mongoose = require 'mongoose'
sinon = require 'sinon'
SearchQuery = require('../../../src/controllers/helpers/SearchQuery')

describe "Operations for Search Query Builder", ->
  controller = {}
  modelSpy = {}

  before (done) ->  
    done()

  it "should build search query for latitude, longitude and distance", (done) ->
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).build()
    q.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}}}
    done()
  
  it "should build search query for latitude, longitude, distance, categories, and subCategories", (done) ->
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).inCategories(["ATTRACTIONS"]).inSubCategories(["AMUSEMENT","ARCADES"]).build()
    q.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}}, 'categories' :{$in: ["ATTRACTIONS"]}, 'subCategories' :{$in: ["AMUSEMENT","ARCADES"]}}
    done()

  it "should build search query for latitude, longitude, distance and cost", (done) ->
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).withCost("20.00").build()
    q.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}},'maxCost' :{$lte: '20.00'}}
    done()
  it "should build search query for latitude, longitude, distance, cost, and start date", (done) ->
    start = new Date("8/5/2013 15:00:00")
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).withCost("20.00").betweenDates(start).build()
    q.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}},'maxCost' :{$lte: '20.00'}, 'occurrences':{$gte:start}}
    done()
  it "should build search query for latitude, longitude, distance, cost, and both dates", (done) ->
    start = new Date("8/5/2013 15:00:00")
    end = new Date("8/8/2013 18:00:00")
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).withCost("20.00").betweenDates(start,end).build()
    q.should.eql {'geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}},'maxCost' :{$lte: '20.00'}, 'occurrences':{$gte:start, $lte:end}}
    done()

