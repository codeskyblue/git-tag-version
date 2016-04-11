{exec} = require 'child_process'
semver = require 'semver'
Promise = require 'bluebird'


command = (cmd, cb) ->
  return new Promise (resolve, reject) ->
    exec cmd, (err, stdout, stderr) ->
      if err
        reject(err)
        return
      result = stdout.trim()
      resolve(result)
      if cb
        cb result

Gitver = () ->

Gitver.prototype.tag = (cb) ->
  command 'git describe --always --tag --abbrev=0', cb


Gitver.prototype.longSha = (cb) ->
  command 'git rev-parse HEAD', cb

Gitver.prototype.shortSha = (cb) ->
  this.directory().then (gitDir) ->
    command 'git log -n1 --pretty=format:%h', cb

Gitver.prototype.logInner = (cb) ->
  tags = []
  command 'git log --format=%h%x00%s%x00%d'
  .then (logOutput) ->
    console.log logOutput
    logOutput.split(/\r?\n/).forEach (line) ->
      console.log line.split('\x00')

Gitver.prototype.tags = (cb) ->
  command 'git tag -l'
  .then (output) ->
    res = output.split('\n')
    cb and cb res
    return res

# Gitver.prototype.isGitInstalled = (cb) ->
#   command('git --version').then(true).catch(false)

Gitver.prototype.directory = (cb) ->
  command 'git rev-parse --git-dir', cb

Gitver.prototype.tag = (cb) ->
  this.longSha().then (sha) ->
    command 'git name-rev --tags --name-only ' + sha, cb
  # command 'git describe --always --tag --abbrev=0', cb

Gitver.prototype.current = (cb) ->
  that = this
  return this.tag().then (tagName) ->
    if tagName != "undefined"
      # FIXME: this should exclude none version name, like prerelease
      verName = semver.clean tagName
      if cb
        cb verName
      return verName

    # Find the lastest tag name and return
    return that.tags().then (names) ->
      return Promise.filter names, (name) ->
        return semver.clean(name)
    .then (names) ->
      names = names.map (name) ->
        return semver.clean name
      return names.sort semver.rcompare
    .then (names) ->
      if names.length >= 1
        parts = names[0].split('.')
        lastNum = parseInt(parts[parts.length-1], 10) + 1
        parts[parts.length-1] = '' + lastNum
        return parts.join('.') + '.dev'
      return '0.0.1.dev'
    .then (verName) ->
      if cb
        cb verName
      return verName


module.exports = new Gitver()