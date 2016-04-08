'use strict'

var gulp = require('gulp')
var gutil = require('gulp-util')
var mocha = require('gulp-mocha')
var coffee = require('gulp-coffee')
var coffeelint = require('gulp-coffeelint')

// Files
var src = 'src/**/*.coffee';
var tests = 'test/*.mocha.coffee';


// Coffee lint
gulp.task('lint', function(){
    gulp.src(src)
        .pipe(coffeelint())
        .pipe(coffeelint.reporter());
});

gulp.task('coffee', ['lint'], function(){
    return gulp.src(src)
        .pipe(coffee({
            bare: true
        })
        .on('error', gutil.log))
        .pipe(gulp.dest('lib'))
        .on('error', gutil.log);
})

// Run tests
gulp.task('test', ['coffee'], function(){
    require('coffee-script/register');
    return gulp.src(tests)
        .pipe(mocha({
            timeout: 10000,
            reporter: 'spec',
        }))
});

gulp.task('default', ['coffee']);
