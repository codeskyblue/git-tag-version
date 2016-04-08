# git-tag-version
Auto generate version number by git log and tag

This is a Nodejs library.

## Usage

```
var gv = require('git-tag-version')

gv.branch(function(branch){
    console.log(branch) // expect: master
})

## LICENSE
Under [MIT](LICENSE)
