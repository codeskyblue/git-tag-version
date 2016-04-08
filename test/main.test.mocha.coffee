chai = require 'chai'

gitrev = require '../src'

describe 'gitrev', ->

  it 'should branch() == master', (done) ->
    gitrev.branch (branch) ->
      chai.expect(branch).to.equal('master')
      done()

  it 'should long() length 40', (done) ->
    gitrev.long (sha) ->
      chai.expect(sha).have.length(40)
      done()
