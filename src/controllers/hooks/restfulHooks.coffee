hookLibrary = require('./hookLibrary')

module.exports = exports =
  create:
    pre : hookLibrary.default
    post : hookLibrary.default
  update:
    pre : hookLibrary.default
    post : hookLibrary.default
  search:
    pre : (req, res, cb) =>
      cb null
    post : (req, res, cb) =>    
      cb null