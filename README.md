# gitver
Auto generate version number by git log and tag

This is a Nodejs library.

## Usage

```
var gv = require('git-tag-version')

gv.current(function(version){
    console.log(version) // expect: 0.0.1
})
```

If recent `git tag` is v0.0.2, then function will return 0.0.2 or 0.0.3.dev

## LICENSE
Under [MIT](LICENSE)
