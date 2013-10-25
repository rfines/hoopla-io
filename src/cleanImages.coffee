cloudinary = require 'cloudinary'
Media = require('hoopla-io-core').Media
Event = require('hoopla-io-core').Event
_ = require 'lodash'
async = require 'async'

cleanMedia = ->
  console.log 'doing it'
  cloudinary.config global.cloudinary
  deleteResources = (data) ->
    urls = _.pluck data.resources, 'url'
    ids = _.pluck data.resources, 'public_id'
    delResources = []
    index = 0
    if urls.length > 0
      findMedia = (url, cb)=>
        Media.findOne {url:url}, {_id:1},{lean:true},(err,doc)->
          console.log doc
          index = index+1
          if err
            console.log err
            cb err, null
          else if doc?._id
            cb null, null
          else
            delResources.push(ids[index])
            cb null, url
      async.each urls,findMedia, (err)->
        console.log err if err
        deleteResources = (resourcesToDelete, callback)=>
          cloudinary.api.delete_resources resourcesToDelete.join(','), (data)  ->
            console.log "removed: #{resourcesToDelete.length}"
            callback null, true
        console.log delResources.length
        if delResources.length >100
          chunks = chunkArray delResources, 100  
          async.each chunks, deleteResources, (err)=>
            console.log err if err
            process.exit(code=0)
        else
          deleteResources(delResources, (err,result)=>
            if err
              console.log err
            else process.exit(code=0)
          )
    else
      console.log 'no resources to remove'
      process.exit(code=10)
  cloudinary.api.resources deleteResources, {max_results:1500}
run= ->
  cleanMedia()
chunkArray=(array, chunkSize, cb)=>
  returnArray = []
  i = 0
  j = array.length
  while i < j
    temparray = array.slice(i, i + chunkSize)
    returnArray.push temparray
    i += chunkSize
  return returnArray
    
module.exports=
  run:run