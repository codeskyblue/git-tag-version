{exec} = require 'child_process'
semver = require 'semver'


command = (cmd, cb) ->
  exec cmd, {cwd: __dirname}, (err, stdout, stderr) ->
    cb stdout.split('\n').join('')

long = (cb) ->
  command 'git rev-parse HEAD', cb

tags = (cb) ->
  command 'git describe --abbrev=0 --tags', (output) ->
    _tags = output.trim().split('\n')
    if _tags.length == 1 and _tags[0] == ''
      _tags = []
    cb(_tags)


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
        tags (vers) ->
          console.log(vers.sort(semver.rcompare))
          if vers.length == 0
            clean_cb "0.0.1"
          else
            clean_cb vers[vers.length - 1]
      else
        clean_cb name

    long (sha) ->
      command "git name-rev --tags --name-only " + sha, callback
