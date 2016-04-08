var command, exec;

exec = require('child_process').exec;

command = function(cmd, cb) {
  return exec(cmd, {
    cwd: __dirname
  }, function(err, stdout, stderr) {
    return cb(stdout.split('\n').join(''));
  });
};

module.exports = {
  branch: function(cb) {
    return command('git rev-parse --abbrev-ref HEAD', cb);
  },
  long: function(cb) {
    return command('git rev-parse HEAD', cb);
  },
  tag: function(cb) {
    return command('git describe --always --tag --abbrev=0', cb);
  }
};
