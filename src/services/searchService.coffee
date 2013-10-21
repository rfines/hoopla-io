ElasticSearchClient = require("elasticsearchclient")
url = require("url")
CONFIG = require('config')
elasticSearchClient = {}
_ = require 'lodash'
index = 'hoopla'
Business = require('hoopla-io-core').Business
init= () ->
  u = process.env.SEARCHBOX_URL || CONFIG.elasticSearch
  connectionString = url.parse(u)
  serverOptions =
    host: connectionString.hostname
    port: connectionString.port

  if connectionString.auth
    serverOptions.auth =
      username: connectionString.auth.split(":")[0]
      password: connectionString.auth.split(":")[1]

  elasticSearchClient = new ElasticSearchClient(serverOptions)

deleteIndex = (cb) ->
  elasticSearchClient.deleteIndex(index).exec ->
    elasticSearchClient.createIndex(index).exec cb


indexBusiness = (business, cb, throttle) ->
  doc = 
    name : business.name
    description : business.description
  elasticSearchClient.index(index, "business", doc, business._id.toString()
  ).on('data', (d) ->
    if throttle
      setTimeout ->
        cb null if cb
      , 800
    else
      cb null if cb
  ).on('error', (err) ->
    setTimeout ->
      cb null if cb
    , 800
  ).exec()

indexEvent = (event, cb, throttle) ->
  businessName= ''
  if event.business
    Business.findById event.business, {name:1},{lean:true},(err,bus)=>
      console.log err if err
      businessName = bus?.name
      doc =
        name : event.name
        description : event.description
        bands : event.bands
        businessName:businessName  
      elasticSearchClient.index(index, "event", doc, event._id.toString()  
      ).on('data', (d) ->
        if throttle
          setTimeout ->
            cb null if cb
          , 800
        else
          cb null if cb
      ).on('error', (err) ->
        if throttle
          setTimeout ->
            cb null if cb
          , 800
        else
          cb null if cb
      ).exec()  

findBusinesses = (term, cb) ->
  qryObj = 
    size: 100
    query: 
      "fuzzy_like_this" :
        "fields" : ["name", "description"]
        "like_text" : "#{term}"
        "min_similarity" : "0.7"
  elasticSearchClient.search(index, "business", qryObj).on("data", (data) ->
    cb null, JSON.parse(data).hits.hits
  ).on("error", (error) ->
    cb error
  ).exec()

findEvents = (term, cb) ->
  qryObj = 
    size: 100
    query: 
      "fuzzy_like_this" :
        "fields" : ["name", "description", 'bands','businessName']
        "like_text" : "#{term}"
        "min_similarity" : "0.7"
  elasticSearchClient.search(index, "event", qryObj).on("data", (data) ->
    cb null, JSON.parse(data).hits.hits
  ).on("error", (error) ->
    cb error
  ).exec()
find = (type, term, cb) ->
  if type is 'business'
    findBusinesses term, cb
  else
    findEvents term, cb

module.exports =
  init : init
  indexBusiness : indexBusiness
  findBusinesses : findBusinesses
  indexEvent : indexEvent
  findEvents : findEvents
  deleteIndex : deleteIndex
  find : find