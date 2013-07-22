module.exports = (grunt) ->
  cp = require('child_process')
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-cafe-mocha"
  grunt.loadNpmTasks 'grunt-contrib-coffee'

  grunt.initConfig
    test:
      all:
        src: "test/**/*.coffee"
        options:
          ui: "tdd"
          growl: true
          reporter: "nyan"
          require: ["should"]

    run:
      cp.exec 'coffee ./src/app.coffee'

    dev:
      tests:
        files: ["!node_modules", "src/**/*.coffee", "test/**/*.coffee"]
        tasks: ["run"]

  grunt.registerTask "default", ["jshint", "test"]
  grunt.registerTask "test", "test"
  grunt.registerTask "dev", "dev"