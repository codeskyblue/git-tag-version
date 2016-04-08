{exec} = require 'child_process'
semver = require 'semver'


command = (cmd, cb) ->
  exec cmd, {cwd: __dirname}, (err, stdout, stderr) ->
    cb stdout.split('\n').join('')

long = (cb) ->
  command 'git rev-parse HEAD', cb

tag = (cb) ->
  command 'git describe --always --tag --abbrev=0', cb


module.exports =
  branch: (cb) ->
    command 'git rev-parse --abbrev-ref HEAD', cb

  long: long

  tag: (cb) ->
    command 'git describe --always --tag --abbrev=0', cb

  current: (cb) ->
    clean_cb = (name) ->
      cb semver.clean(name)

    callback = (name) ->
      if name == "undefined"
        tag (name) ->
          if name.length == 40
            clean_cb "0.0.1"
          else
            name = semver.clean(name)
            ms = name.split('.')
            ms[ms.length-1] = parseInt(ms[ms.length-1], 10) + 1 + ''
            cb ms.join('.') + '.dev'
      else
        clean_cb name

    long (sha) ->
      command "git name-rev --tags --name-only " + sha, callback
