module.exports = (grunt) ->
	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-execute"
	grunt.loadNpmTasks "grunt-contrib-watch"

	grunt.registerTask "compile", ["clean", "coffee"]
	grunt.registerTask "default", ["watch"]
	grunt.initConfig
		clean: [".js"]

		coffee:
			compile:
				expand: true
				cwd: "#{__dirname}/src"
				src: ["**/*.coffee"]
				dest: ".js/"
				ext: ".js"

		execute:
			run:
				src: [".js/main.js"]
			exit:
				src: ["exit.js"]

		watch:
			coffee:
				files: "src/**/*.coffee"
				tasks: ["compile", "execute:run"]
				options:
					atBegin: true
					interrupt: true