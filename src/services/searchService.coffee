ElasticSearchClient = require("elasticsearchclient")
url = require("url")
CONFIG = require('config')
elasticSearchClient = {}
_ = require('underscore')
index = 'hoopla'

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

deleteIndex = () ->
  elasticSearchClient.deleteIndex(index).exec()

indexBusiness = (business, cb) ->
  elasticSearchClient.index(index, "business",
    id: business._id.toString()
    name : business.name
    description : business.description
  ).on('data', (data) ->
    cb()
  ).exec()

indexEvent = (event, cb) ->
  elasticSearchClient.index(index, "event",
    id: event._id.toString()
    name : event.name
    description : event.description
    bands : event.bands
  ).on('data', (data) ->
    cb()    
  ).exec()  

findBusinesses = (term, cb) ->
  qryObj = 
    size: 100
    query: 
      "fuzzy_like_this" :
        "fields" : ["name", "description"]
        "like_text" : "#{term}"
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
        "fields" : ["name", "description", 'bands']
        "like_text" : "#{term}"
  elasticSearchClient.search(index, "event", qryObj).on("data", (data) ->
    cb null, JSON.parse(data).hits.hits
  ).on("error", (error) ->
    cb error
  ).exec()

module.exports =
  init : init
  indexBusiness : indexBusiness
  findBusinesses : findBusinesses
  indexEvent : indexEvent
  findEvents : findEvents
  deleteIndex : deleteIndex