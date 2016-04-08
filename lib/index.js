var command, exec, long, semver, tags;

exec = require('child_process').exec;

semver = require('semver');

command = function(cmd, cb) {
  return exec(cmd, {
    cwd: __dirname
  }, function(err, stdout, stderr) {
    return cb(stdout.split('\n').join(''));
  });
};

long = function(cb) {
  return command('git rev-parse HEAD', cb);
};

tags = function(cb) {
  return command('git describe --abbrev=0 --tags', function(output) {
    var _tags;
    _tags = output.trim().split('\n');
    if (_tags.length === 1 && _tags[0] === '') {
      _tags = [];
    }
    return cb(_tags);
  });
};

module.exports = {
  branch: function(cb) {
    return command('git rev-parse --abbrev-ref HEAD', cb);
  },
  long: long,
  tag: function(cb) {
    return command('git describe --always --tag --abbrev=0', cb);
  },
  current: function(cb) {
    var callback, clean_cb;
    clean_cb = function(name) {
      return cb(semver.clean(name));
    };
    callback = function(name) {
      if (name === "undefined") {
        return tags(function(vers) {
          console.log(vers.sort(semver.compare));
          if (vers.length === 0) {
            return cb("0.0.1");
          } else {
            return cb(vers[vers.length - 1]);
          }
        });
      } else {
        return cb(name);
      }
    };
    return long(function(sha) {
      return command("git name-rev --tags --name-only " + sha, callback);
    });
  }
};
