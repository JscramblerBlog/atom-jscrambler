_ = require 'underscore'
glob = require 'glob'
jScrambler = require 'jscrambler'
NotificationView = require './notification-view'
path = require 'path'
Q = require 'q'

module.exports =
  configDefaults:
    filesDest: ''
    keys:
      access: ''
      secret: ''

  activate: ->
    atom.workspaceView.command 'jscrambler:obfuscate-file', => @obfuscate 'file'
    atom.workspaceView.command 'jscrambler:obfuscate-project', => @obfuscate 'project'

  obfuscate: (type) ->
    # Return if an obfuscation is already in progress
    return if @promise? and not @promise.isFulfilled()

    # If there's no configuration notify the user
    if not config = atom.config.settings.jscrambler
      deferred = Q.defer()
      @promise = deferred.promise
      @notificationView = new NotificationView
      @notificationView.config()
      Q
        .delay 3000
        .then =>
          @notificationView.destroy() and delete @notificationView and @promise.resolve()
    # Else obfuscate
    else
      config.keys = accessKey: config.keys.access, secretKey: config.keys.secret
      if type is 'file' then @_obfuscateFile config
      if type is 'project' then @_obfuscateProject config

  onError: (error) ->
    # Notify the user that there was an error and wait
    @notificationView.fail error
    Q.delay 3000

  _obfuscateFile: (config) ->
    currentTab = atom.workspaceView.find '.pane.active .tab.active [data-path]'
    if currentTab and currentTab.length
      # Paths
      currFilePath = currentTab.data 'path'
      currFileName = path.basename currFilePath
      projectPath = atom.project.path
      relFilePath = currFilePath.substring projectPath.length
      filesDest = path.join projectPath, config.filesDest, relFilePath

      # Prepare options and JScramble
      options =
        params: (config.params? and _.extend config.params, {cwd: projectPath}) or {cwd: projectPath}
        filesSrc: [currFilePath]
        filesDest: filesDest

      # Notify the user
      @notificationView = new NotificationView

      @promise = jScrambler
        .process _.extend {}, config, options
        .catch (error) => @onError(error)
        .finally =>
          @notificationView.destroy()
          delete @notificationView

  _obfuscateProject: (config) ->
    # Paths
    projectPath = atom.project.path
    if projectPath?
      filesDest = path.join projectPath, config.filesDest
      nodeModulesPath = path.join projectPath, 'node_modules/'
      # Get all files inside of the project
      glob path.join(projectPath, '**/*'), (err, files) =>
        if not err
          # Iterate and filter each file into `filesSrc`
          filesSrc = files.filter (file) ->
            file.indexOf(filesDest) isnt 0 and file.indexOf(nodeModulesPath) isnt 0

          # Prepare options and JScramble
          options =
            params: (config.params? and _.extend config.params, {cwd: projectPath}) or {cwd: projectPath}
            filesSrc: filesSrc
            filesDest: filesDest

          # Notify the user
          @notificationView = new NotificationView

          @promise = jScrambler
            .process _.extend {}, config, options
            .catch (error) => @onError(error)
            .finally =>
              # Notify the user, again, but in another way
              @notificationView.destroy()
              delete @notificationView
