path =
  public: 'src/main/resources/public/'
  src: 'src/main/js/'
  js: 'wsock.js'
  css: 'wsock.css'
  bower: 'bower_components/'
  npm: 'node_modules/'

gulp = require 'gulp'
coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
cssnano = require 'gulp-cssnano'
remove = require 'gulp-rimraf'
require 'colors'

log = (error) ->
  console.log [
    "BUILD FAILED: #{error.name ? ''}".red.underline
    '\u0007' # beep
    "#{error.code ? ''}"
    "#{error.message ? error}"
    "in #{error.filename ? ''}"
    "gulp plugin: #{error.plugin ? ''}"
  ].join '\n'
  this.end()

gulp.task 'clean', ->
  gulp.src(path.public, read: false)
    .pipe(remove force: true)

gulp.task 'clear', ['clean'], ->
  gulp.src("#{path.src}**/*.js", read: false)
    .pipe(remove force: true)

gulp.task 'coffee', ->
  gulp.src("#{path.src}**/*.coffee", base: path.src)
    .pipe(coffee bare: true)
      .on('error', log)
    .pipe(gulp.dest path.src)

gulp.task 'js', ['coffee'], ->
  gulp.src([
      "#{path.bower}sockjs-client/dist/sockjs-0.3.4.js"
      "#{path.npm}stompjs/lib/stomp.js"
      "#{path.src}**/*.js"
    ])
    .pipe(concat path.js)
    .pipe(uglify())
    .pipe(gulp.dest path.public)

gulp.task 'css', ->
  gulp.src([
      "#{path.npm}bootstrap/dist/css/bootstrap.css"
      "#{path.src}**/*.css"
    ])
    .pipe(concat path.css)
    .pipe(cssnano())
    .pipe(gulp.dest path.public)

gulp.task 'html', ->
  gulp.src("#{path.src}**/*.html", base: path.src)
    .pipe(gulp.dest path.public)

gulp.task 'default', ['coffee', 'js', 'css', 'html']

gulp.task 'watch', ['default'], ->
  gulp.watch "#{path.src}**/*.coffee", ['coffee']
  gulp.watch "#{path.src}**/*.js", ['js']
  gulp.watch "#{path.src}**/css", ['css']
  gulp.watch "#{path.src}**/*.html", ['html']