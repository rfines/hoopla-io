module.exports.anyone = (authUser, target) ->
  true

module.exports.hasAuthUser = (authenticatedUser, target) ->
  return authenticatedUser