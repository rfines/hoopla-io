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
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}}}
    done()
  
  it "should build search query for latitude, longitude, distance, tags", (done) ->
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).withTags(["ATTRACTIONS","AMUSEMENT","ARCADES"]).build()
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}}, 'tags' :{$in: ["ATTRACTIONS","AMUSEMENT","ARCADES"]}}
    done()

  it "should build search query for latitude, longitude, distance and cost", (done) ->
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).withCost("20.00").build()
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}},'maxCost' :{$lte: '20.00'}}
    done()

  it "should build search query for latitude, longitude, distance, cost, and start date", (done) ->
    start = new Date("8/5/2013 15:00:00")
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).withCost("20.00").betweenDates(start).build()
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}},'maxCost' :{$lte: '20.00'}, 'occurrences':{$gte:start}}
    done()

  it "should build search query for latitude, longitude, distance, cost, and both dates", (done) ->
    start = new Date("8/5/2013 15:00:00")
    end = new Date("8/8/2013 18:00:00")
    q = new SearchQuery().within(25).ofLongitude(-93.5).ofLatitude(40.01).withCost("20.00").betweenDates(start,end).build()
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 25}},'maxCost' :{$lte: '20.00'}, 'occurrences':{$gte:start, $lte:end}}
    done()


  it "should transform longitude/latitude parameter for search", (done) ->
    q = new SearchQuery().buildFromParams({ll:'-93.5,40.01'})
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 40234}}}
    done()

  it "should transform longitude/latitude parameter for search", (done) ->
    q = new SearchQuery().buildFromParams {ll:'-94.595033,39.102704'}
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704 ]},$maxDistance : 40234}}}
    done()    

  it "should build a query using ll and maxdistance", (done) ->
    q = new SearchQuery().buildFromParams {ll:'-94.595033,39.102704', radius: 10}
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704]}, $maxDistance : 10}}}
    done()


  it "should transform longitude/latitude parameter for search", (done) ->
    q = new SearchQuery().buildFromParams {ll:'-93.5,40.01'}
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -93.5, 40.01 ]},$maxDistance : 40234}}}
    done()

  it "should transform longitude/latitude parameter for search", (done) ->
    q = new SearchQuery().buildFromParams {ll:'-94.595033,39.102704'}
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704 ]},$maxDistance : 40234}}}
    done()    

  it "should handle event tags correctly as well as location", (done) ->
    q = new SearchQuery().buildFromParams {ll:'-94.595033,39.102704', radius: 10, tags:"PETS,FOOD"}
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ -94.595033,39.102704]}, $maxDistance : 10}}, 'tags':{$in:["PETS","FOOD"]}}
    done()

  it "should handle maxdistance with float values and cost", (done) ->
    q = new SearchQuery().buildFromParams {ll: '1.01,1.01', radius: 10.1, maxCost: '20.00'}
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}, 'maxCost':{$lte : 20.00}}
    done() 

  it "should handle maxdistance with float values and start date", (done) ->
    start = new Date("8/5/2013 15:00:00")
    q = new SearchQuery().buildFromParams {ll: '1.01,1.01', radius: 10.1, start: start}
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}, 'occurrences':{$gte : start}}
    done()  

  it "should handle maxdistance with float values and both dates", (done) ->
    start = new Date("8/5/2013 15:00:00")
    end = new Date("8/8/2013 18:00:00")
    q = new SearchQuery().buildFromParams {ll: '1.01,1.01', radius: 10.1, start: start, end: end}
    q.should.eql {'location.geo':{$near:{ $geometry :{ type : "Point" ,coordinates : [ 1.01, 1.01 ]}, $maxDistance : 10.1}}, 'occurrences':{$gte : start, $lte :end}}
    done()              

