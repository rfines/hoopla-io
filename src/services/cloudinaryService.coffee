cloudinary = require('cloudinary')
CONFIG = require('config')
StringReader = require('../utils/StringReader')

init = ->
  cloudinary.config({
    cloud_name:CONFIG.cloudinary.cloud_name
    api_key : CONFIG.cloudinary.api_key
    api_secret : CONFIG.cloudinary.api_secret
  })
writeFile= (bytes,cb)=>
  fs = require('fs')
  fs.writeFile "/Node/images/tmp.jpg", bytes,null,null,null, (err) ->
    if err
      console.log err
      cb err, null
    else
      console.log "The file was saved!"
      cb null, "/Node/images/tmp.jpg"

uploadImage = (data, cb) =>
  writeFile data, (errors, results)=>
    if errors
      console.log errors
    else
      console.log "Wrote the file"
      stream = cloudinary.uploader.upload_stream (result) ->
        console.log result
        if result.error
          cb result.error, null
        else
          cb null, result
      console.log "getting reader"
      reader = new StringReader(data)
      console.log reader
      reader.on('data', stream.write)
      reader.on('end', stream.end)
      reader.resume()
      
module.exports =
  init : init
  uploadImage: uploadImage
  writeFile: writeFile