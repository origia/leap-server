/*global module:false*/
module.exports = function(grunt) {

  grunt.initConfig({
    jshint: {
      gruntfile: {
        src: 'Gruntfile.js'
      }
    },
    nodeunit: {
      files: ['test/**/*_test.js']
    },
    watch: {
      gruntfile: {
        files: '<%= jshint.gruntfile.src %>',
        tasks: ['jshint:gruntfile']
      },
      coffee: {
        files: '<%= coffeelint.app %>',
        tasks: ['coffeelint:app', 'coffee:app']
      }
    },
    coffeelint: {
      app: ['app/**/*.coffee']
    },
    coffee: {
      app: {
        expand: true,
        flatten: true,
        cwd: 'app/',
        src: ['*.coffee'],
        dest: 'dist/',
        ext: '.js'
      }
    },
    nodemon: {
      dev: {
        script: 'dist/app.js',
        options: {
          watch: ['dist']
        }
      }
    },
    concurrent: {
      dev: {
        tasks: ['coffee', 'nodemon', 'watch'],
        options: {
          logConcurrentOutput: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-nodeunit');
  grunt.loadNpmTasks('grunt-contrib-jshint');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-coffeelint');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-nodemon');
  grunt.loadNpmTasks('grunt-concurrent');

  grunt.registerTask('default', ['jshint', 'nodeunit']);
  grunt.registerTask('server', ['concurrent:dev']);
};
