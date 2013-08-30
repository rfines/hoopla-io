cloudinary = require('cloudinary')
CONFIG = require('config')
StringReader = require('../utils/StringReader')

init = ->
  cloudinary.config({
    cloud_name:CONFIG.cloudinary.cloud_name
    api_key : CONFIG.cloudinary.api_key
    api_secret : CONFIG.cloudinary.api_secret
  })

uploadImage = (data, cb) =>
  stream = cloudinary.uploader.upload_stream (result) ->
    if result.error
      cb result.error, null
    else
      cb null, result
  reader = new StringReader(data)
  reader.on('data', stream.write)
  reader.on('end', stream.end)
  reader.resume()
      
module.exports =
  init : init
  uploadImage: uploadImage
