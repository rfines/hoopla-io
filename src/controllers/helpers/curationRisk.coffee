badwordsRegExp = require('badwords/regexp')
riskWordsRegExp = /\b(test|sale|garage|birthday)\b/gi;

module.exports.forEvent = (event, business) ->
  score = 0
  reasons = []
  if business.count is 1
    score = score + 1
    reasons.push 'NEW BUSINESS'
  nameRisk = event.name?.toLowerCase().match(riskWordsRegExp)
  if nameRisk?.length > 0
    score = score + 1
    reasons.push 'NOT INTERESTING'
  descriptionRisk = event.description?.toLowerCase().match(riskWordsRegExp)
  if descriptionRisk?.length > 0
    score = score + 1    
    reasons.push 'NOT INTERESTING'
  nameProfanity = event.name.toLowerCase().match(badwordsRegExp)
  if nameProfanity?.length > 0
    score = score + 1
    reasons.push 'PROFANITY'
  descriptionProfanity = event.description?.toLowerCase().match(badwordsRegExp)
  if descriptionProfanity?.length > 0
    score = score + 1
    reasons.push 'PROFANITY'
  return { score : score, reasons : reasons}