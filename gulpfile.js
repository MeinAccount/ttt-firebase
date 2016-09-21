const gulp = require('gulp');
const del  = require('del');
const exec = require('child_process').exec;

const concat   = require('gulp-concat');
const uglify   = require('gulp-uglify');
const sass     = require('gulp-sass');
const sassFail = require('gulp-sass-error').gulpSassError;
const htmlmin  = require('gulp-htmlmin');

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
 return gulp.src('src/public/main.scss')
   .pipe(sass({
     outputStyle: 'compressed'
   }).on('error', sassFail(true)))
   .pipe(gulp.dest('dist'));
});

gulp.task('html', function() {
  return gulp.src('src/public/*.html')
    .pipe(htmlmin({
      collapseWhitespace: true
    }))
    .pipe(gulp.dest('dist'))
});


gulp.task('dist', ['copy', 'js', 'sass', 'html']);
