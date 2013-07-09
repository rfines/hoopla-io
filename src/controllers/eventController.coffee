get = (req, res, next) ->
	res.send {Hello : 'World5'}
	next()

getSecret = (req, res, next) ->
	res.send {Hello : 'Secret'}
	next()	

module.exports = 
	get : get
	getSecret : getSecret