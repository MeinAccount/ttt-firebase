const gulp = require('gulp');
const del  = require('del');
const exec = require('child_process').exec;

const concat  = require('gulp-concat');
const uglify  = require('gulp-uglify');
const htmlmin = require('gulp-htmlmin');

const sass       = require('gulp-sass');
const sassFail   = require('gulp-sass-error').gulpSassError;
const sourcemaps = require('gulp-sourcemaps');
const prefixer   = require('gulp-autoprefixer');

gulp.task('clean', function() {
  return del([
    'dist',
    'src/public/Main.js'
  ]);
});

gulp.task('copy', function() {
  return gulp.src('src/public/assets/*')
    .pipe(gulp.dest('dist/assets'));
});

gulp.task('fonts', function() {
  return gulp.src('node_modules/materialize-css/fonts/**/*')
    .pipe(gulp.dest('dist/fonts'));
});


gulp.task('elm', function(cb) {
  const cmd = 'elm make src/Main.elm --output src/public/Main.js';
  exec(cmd, function (err, stdout, stderr) {
      console.log(stdout);
      console.log(stderr);
      cb(err);
    });
});

gulp.task('js', ['elm'], function() {
  return gulp.src('src/public/*.js')
    .pipe(concat('bundle.js'))
    .pipe(uglify())
    .pipe(gulp.dest('dist'));
});


gulp.task('sass', function () {
 return gulp.src('src/public/sass/main.scss')
   .pipe(sourcemaps.init())
     .pipe(sass({
       outputStyle: 'compressed'
     }).on('error', sassFail(true)))
     .pipe(prefixer())
   .pipe(sourcemaps.write())
   .pipe(gulp.dest('dist/css'));
});

gulp.task('html', function() {
  return gulp.src('src/public/*.html')
    .pipe(htmlmin({
      collapseWhitespace: true
    }))
    .pipe(gulp.dest('dist'))
});


gulp.task('dist', ['copy', 'fonts', 'js', 'sass', 'html']);

gulp.task('debug', ['copy', 'fonts', 'sass'], function() {
  gulp.watch('src/public/assets/*', ['copy']);
  gulp.watch('src/public/sass/*.scss', ['sass']);

  // launch reactor
  const exec = require('child_process').exec;
  const reactor = exec('elm-reactor');
  reactor.stdout.pipe(process.stdout);
  reactor.stderr.pipe(process.stdout);

  // launch static server
  // TODO: remove once reactor can serve fonts
  const staticServer = require('static-server');
  const server = new staticServer({
    rootPath: 'dist',
    port: 8001,
    cors: '*'
  });
  server.start(function() {
    console.log('Static server listening on ', server.port)
  });
});
