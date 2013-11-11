badwordsRegExp = require('badwords/regexp')

module.exports.forEvent = (event, business) ->
  score = 0
  if business.count is 1
    score = score + 1
  if event.name.toLowerCase().indexOf('test') > -1
    score = score + 1
  if event.description?.toLowerCase().indexOf('test') > -1
    score = score + 1    
  nameProfanity = event.name.toLowerCase().match(badwordsRegExp)
  if nameProfanity?.length > 0
    score = score + 1
  descriptionProfanity = event.description?.toLowerCase().match(badwordsRegExp)
  if descriptionProfanity?.length > 0
    score = score + 1
  return score