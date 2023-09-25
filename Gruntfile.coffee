module.exports = (grunt) ->
	grunt.loadNpmTasks "grunt-contrib-clean"
	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-execute"
	grunt.loadNpmTasks "grunt-contrib-watch"

	grunt.registerTask "compile", ["clean", "coffee"]
	grunt.registerTask "default", ["watch"]

	grunt.initConfig
		midiFile: grunt.option "midi"
		firstIdle: grunt.option "firstIdle"

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
				options: args: ["<%= midiFile %>", "<%= firstIdle %>"]

		watch:
			coffee:
				files: "src/**/*.coffee"
				tasks: ["compile", "execute"]
				options:
					atBegin: true
					interrupt: true