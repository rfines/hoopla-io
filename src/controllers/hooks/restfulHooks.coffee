hookLibrary = require('./hookLibrary')

module.exports = exports =
  create:
    pre : hookLibrary.default
    post : hookLibrary.default
  update:
    pre : hookLibrary.default
    post : hookLibrary.default
  search:
    pre : hookLibrary.default
    post : hookLibrary.default
  destroy:
    pre : hookLibrary.default
    post : hookLibrary.default