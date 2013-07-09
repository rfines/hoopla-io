get = (req, res, next) ->
	res.send {Hello : 'World4'}
	next()

getSecret = (req, res, next) ->
	res.send {Hello : 'Secret'}
	next()	

module.exports = 
	get : get
	getSecret : getSecret