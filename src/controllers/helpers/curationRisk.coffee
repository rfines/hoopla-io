module.exports.forEvent = (event, business) ->
  score = 0
  if business.count is 1
    score = score + 33
  if event.name.toLowerCase().indexOf('test') > -1
    score = score + 33
  return score