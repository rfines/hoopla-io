cp = require('child_process')

task "dev", ->
  console.log 'run dev server'
  cp.spawn 'nodemon', ['./src/app.coffee'], customFds: [0..2]

task "test", "run tests", ->
  REPORTER = "spec"
  cp.exec "NODE_ENV=test 
    ./node_modules/.bin/mocha 
    --recursive
    --compilers coffee:coffee-script
    --reporter #{REPORTER}
    --require coffee-script 
    --require test/test_helper.coffee
    --colors
  ", (err, output) ->
    throw err if err
    console.log output

#mocha --recursive --compilers coffee:coffee-script --require coffee-script --require test/test_helper.coffee