{exec} = require 'child_process'

command = (cmd, cb) ->
  exec cmd, {cwd: __dirname}, (err, stdout, stderr) ->
    cb stdout.split('\n').join('')

module.exports =
  branch: (cb) ->
    command 'git rev-parse --abbrev-ref HEAD', cb

  long: (cb) ->
    command 'git rev-parse HEAD', cb

  tag: (cb) ->
    command 'git describe --always --tag --abbrev=0', cb
