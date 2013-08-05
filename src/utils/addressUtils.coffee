zoomOut = (address) ->
  tokens = address.split ','
  out = tokens[1..].join ','
  out.trim()

module.exports = 
  zoomOut : zoomOut