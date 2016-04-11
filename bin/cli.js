#!/usr/bin/env node

var program = require('commander');
var version = require('../package.json').version;
var gitver = require('../lib');

program
  .version(version)

program
  .command('current')
  .description('get version through git')
  .action(function(){
    gitver.current(function(name){
      console.log(name)
    })
  })

program.parse(process.argv);