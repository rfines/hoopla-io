Stream = require("stream")

class StringReader extends Stream
  constructor: (str) ->
    @data = str
    @setEncoding('base64')
  destroy: ->
    delete @data
  setEncoding: (encoding) ->
    @encoding = encoding
  pause: ->
  resume : ->
    if @encoding and Buffer.isBuffer(@data)
      @emit "data", @data.toString(@encoding)
    else
      @emit "data", @data
      @emit "end"
      @emit "close"
module.exports = StringReader