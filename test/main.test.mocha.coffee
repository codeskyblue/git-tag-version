chai = require 'chai'
mlog = require 'mocha-logger'

gitver = require '../src'

describe 'gitver', ->

  it 'should branch() == master', (done) ->
    gitver.branch (branch) ->
      chai.expect(branch).to.equal('master')
      done()

  it 'should long() length 40', (done) ->
    gitver.long (sha) ->
      chai.expect(sha).have.length(40)
      done()

  it 'should get recent tag version', (done) ->
    gitver.current (ver) ->
      # chai.expect(ver)
      mlog.log("the grow version is:", ver)
      done()
