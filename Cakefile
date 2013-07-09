cp = require('child_process')

task "dev", ->
  console.log 'run dev server'
  cp.spawn 'supervisor', ['app.coffee'], customFds: [0..2]
