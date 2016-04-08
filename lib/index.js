var command, exec, long, semver, tag;

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

tag = function(cb) {
  return command('git describe --always --tag --abbrev=0', cb);
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
        return tag(function(name) {
          var ms;
          if (name.length === 40) {
            return clean_cb("0.0.1");
          } else {
            name = semver.clean(name);
            ms = name.split('.');
            ms[ms.length - 1] = parseInt(ms[ms.length - 1], 10) + 1 + '';
            return cb(ms.join('.') + '.dev');
          }
        });
      } else {
        return clean_cb(name);
      }
    };
    return long(function(sha) {
      return command("git name-rev --tags --name-only " + sha, callback);
    });
  }
};
