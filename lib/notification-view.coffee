{View} = require 'atom'
util = require 'util'

module.exports =
class NotificationView extends View

  @content: ->
    @div class: 'jscrambler-status inline-block', =>
      @span class: 'build-status', outlet: 'status', tabindex: -1, 'JScrambling...'

  initialize: ->
    @attach()

  attach: ->
    atom.workspaceView.statusBar.appendLeft(this)

  config: ->
    @set 'Please configure JScrambler in your Atom\'s configuration'

  destroy: ->
    @detach()

  fail: (error) ->
    @set 'JScrambler ' + error.message or util.inspect error

  set: (msg) ->
    @find('.build-status').text msg
