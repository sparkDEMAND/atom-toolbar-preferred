path = require 'path'
fs = require 'fs-plus'
chokidar = require 'chokidar'
treeMatch = require 'tree-match-sync'
{ CompositeDisposable } = require 'atom'
treeIsInstalled = treeMatch.treeIsInstalled()
changeCase = require 'change-case'
module.exports =
  toolBar: null
  configFilePath: null
  currentGrammar: null
  currentProject: null
  buttonTypes: []
  watchList: []

  config:
    toolBarConfigurationFilePath:
      type: 'string'
      default: ''
    reloadToolBarWhenEditConfigFile:
      type: 'boolean'
      default: true
    useBrowserPlusWhenItIsActive:
      type: 'boolean'
      default: true

  activate: ->
    require('atom-package-deps').install('atom-toolbar-preferred')

    return unless @resolveConfigPath()

    @subscriptions = new CompositeDisposable
    @watcherList = []

    @resolveProjectConfigPath()
    @storeProject()
    @storeGrammar()
    @registerTypes()
    @registerCommand()
    @registerEvent()
    @registerWatch()
    @registerProjectWatch()

    @reloadToolbar(false)

  resolveConfigPath: ->
    @configFilePath = atom.config.get 'atom-toolbar-preferred.toolBarConfigurationFilePath'

    # Default directory
    @configFilePath = atom.configDirPath unless @configFilePath

    # If configFilePath is a folder, check for `toolbar.(json|cson|json5|js|coffee)` file
    unless fs.isFileSync(@configFilePath)
      @configFilePath = fs.resolve @configFilePath, 'toolbar', ['cson', 'json5', 'json', 'js', 'coffee']

    return true if @configFilePath

    unless @configFilePath
      @configFilePath = path.join atom.configDirPath, 'toolbar.cson'
      defaultConfig = '''
# This file is used by Atom Toolbar Preferred to create buttons on your Tool Bar.
# For more information how to use this package and create your own buttons,
#   read the documentation on https://atom.io/packages/atom-toolbar-preferred
[
  {
    type: 'button'
    tooltip: 'Open File'
    callback: 'application:open-file'
    icon: 'file-text'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Open Folder'
    dependency: 'atom-commander'
    callback: 'atom-commander:toggle-visible'
    icon: 'folder-open'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Save File'
    callback: 'core:save'
    icon: 'archive'
    iconset: 'ion'
  },
  {
    type: 'button'
    tooltip: 'List projects'
    dependency: 'project-manager'
    callback: 'project-manager:list-projects'
    icon: 'file-submodule'
  },
  {
    type: 'spacer'
  },
  {
    type: 'button'
    tooltip: 'Markdown Preview'
    dependency: 'markdown-preview'
    callback: 'markdown-preview:toggle'
    show: 'markdown'
    icon: 'social-markdown'
    iconset: 'ion'
  },
  {
    type: 'button'
    tooltip: 'HTML Preview'
    dependency: 'atom-html-preview'
    callback: 'atom-html-preview:toggle'
    show: 'html'
    icon: 'html5'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Find in Buffer'
    callback: 'find-and-replace:toggle'
    icon: 'search'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Project: To-Do List'
    callback: 'todo-show:find-in-project'
    icon: 'list-ul'
    iconset: 'fa'
  },
  {
    type: 'spacer'
  },
  {
    type: 'button'
    tooltip: 'Git Plus'
    dependency: 'git-plus'
    callback: 'git-plus:menu'
    icon: 'git-plain'
    iconset: 'devicon'
  },
  {
    type: 'button'
    tooltip: 'Git Projects'
    dependency: 'git-projects'
    callback: 'git-projects:toggle'
    icon: 'git'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Toggle Blame'
    dependency: 'blame'
    callback: 'blame:toggle'
    icon: 'sourcetree-plain'
    iconset: 'devicon'
  },
  {
    type: 'button'
    tooltip: 'Git Diff Details'
    dependency: 'git-diff-details'
    callback: 'git-diff-details:toggle-git-diff-details'
    icon: 'newspaper-o'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Merge Conflicts'
    dependency: 'merge-conflicts'
    callback: 'merge-conflicts:detect'
    icon: 'code-fork'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Git Time Machine'
    dependency: 'git-time-machine'
    callback: 'git-time-machine:toggle'
    icon: 'clock-o'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Open on Github'
    dependency: 'open-on-github'
    callback: 'open-on-github:repository'
    icon: 'github'
    iconset: 'fa'
  },
  {
    type: 'spacer'
  },
  {
    type: 'button'
    tooltip: 'Toggle Fullscreen'
    callback: 'window:toggle-full-screen'
    icon: 'arrow-expand-all'
    iconset: 'mdi'
  },
  {
    type: 'button'
    tooltip: 'Split screen - Vertically'
    callback: 'pane:split-right'
    icon: 'format-horizontal-align-center'
    iconset: 'mdi'
  },
  {
    type: 'button'
    tooltip: 'Split screen - Horizontally'
    callback: 'pane:split-down'
    icon: 'format-vertical-align-center'
    iconset: 'mdi'
  },
  {
    type: 'button'
    tooltip: 'Focus Active Pane'
    dependency: 'hey-pane'
    callback: 'hey-pane:toggle-focus-of-active-pane'
    icon: 'expand'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Split Diff'
    dependency: 'split-diff'
    callback: 'split-diff:toggle'
    icon: 'clone'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Toggle Sidebar'
    callback: 'tree-view:toggle'
    icon: 'sitemap'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Toggle Minimap'
    dependency: 'minimap'
    callback: 'minimap:toggle'
    icon: 'map'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Toggle Exposé'
    dependency: 'expose'
    callback: 'expose:toggle'
    icon: 'search-plus'
    iconset: 'fa'
  },
  {
    type: 'spacer'
  },
  {
    type: 'button'
    tooltip: 'Beautify'
    dependency: 'atom-beautify'
    callback: 'atom-beautify:beautify-editor'
    icon: 'magic'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Auto indent (selection)'
    callback: 'editor:auto-indent'
    icon: 'indent'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Fold All'
    callback: 'editor:fold-all'
    icon: 'angle-double-up'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Unfold All'
    callback: 'editor:unfold-all'
    icon: 'angle-double-down'
    iconset: 'fa'
  },
  {
    type: 'spacer'
  },
  {
    type: 'button'
    tooltip: 'Open Terminal'
    callback: 'term3:open-split-down'
    icon: 'terminal'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Run Script'
    callback: 'script:run'
    icon: 'play-circle'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Stop Script'
    callback: 'script:kill-process'
    icon: 'stop-circle'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Config Script'
    callback: 'script:run-options'
    icon: 'sliders'
    iconset: 'fa'
  },
  {
    type: 'spacer'
  },
  {
    type: 'button'
    tooltip: 'Reload Window'
    callback: 'window:reload'
    icon: 'refresh'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Toggle Developer Tools'
    callback: 'window:toggle-dev-tools'
    icon: 'bug'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Ask Stack'
    dependency: 'ask-stack'
    callback: 'ask-stack:ask-question'
    icon: 'stack-overflow'
    iconset: 'fa'
  }
  {
    type: 'button'
    tooltip: 'Open Command Palette'
    callback: 'command-palette:toggle'
    icon: 'bolt'
    iconset: 'fa'
  },
  {
    type: 'button'
    tooltip: 'Open Settings View'
    callback: 'settings-view:open'
    icon: 'ios-cog'
    iconset: 'ion'
  },
  {
    type: "spacer"
  },
  {
    type: "button"
    callback: "atom-toolbar-preferred:edit-config-file"
    tooltip: "Edit Tool Bar"
    icon: "tools"
  }
]
'''
      try
        fs.writeFileSync @configFilePath, defaultConfig
        atom.notifications.addInfo 'We created a Tool Bar config file for you...', detail: @configFilePath
        return true
      catch err
        @configFilePath = null
        atom.notifications.addError 'Something went wrong creating the Tool Bar config file! Please restart Atom to try again.'
        console.error err
        return false

  resolveProjectConfigPath: ->
    @projectToolbarConfigPath = null
    editor = atom.workspace.getActiveTextEditor()

    if editor?.buffer?.file?.getParent()?.path?
      projectCount = atom.project.getPaths().length
      count = 0
      while count < projectCount
        pathToCheck = atom.project.getPaths()[count]
        if editor.buffer.file.getParent().path.includes(pathToCheck)
          @projectToolbarConfigPath = fs.resolve pathToCheck, 'toolbar', ['cson', 'json5', 'json', 'js', 'coffee']
        count++

    if @projectToolbarConfigPath is @configFilePath
      @projectToolbarConfigPath = null

    return true if @projectToolbarConfigPath

  registerCommand: ->
    @subscriptions.add atom.commands.add 'atom-workspace',
      'atom-toolbar-preferred:edit-config-file': =>
        atom.workspace.open @configFilePath if @configFilePath

  registerEvent: ->
    @subscriptions.add atom.workspace.onDidChangeActivePaneItem (item) =>

      if @didChangeGrammar()
        @storeGrammar()
        @reloadToolbar()
        return

      if @storeProject()
        @switchProject()
        return


  registerWatch: ->
    if atom.config.get('atom-toolbar-preferred.reloadToolBarWhenEditConfigFile')
      watcher = chokidar.watch @configFilePath
        .on 'change', =>
          @reloadToolbar(true)
      @watcherList.push watcher

  registerProjectWatch: ->
    if @projectToolbarConfigPath and @watchList.indexOf(@projectToolbarConfigPath) < 0
      @watchList.push @projectToolbarConfigPath
      watcher = chokidar.watch @projectToolbarConfigPath
        .on 'change', (event, filename) =>
          @reloadToolbar(true)
      @watcherList.push watcher

  switchProject: ->
    @resolveProjectConfigPath()
    @registerProjectWatch()
    @reloadToolbar(false)

  registerTypes: ->
    typeFiles = fs.listSync path.join __dirname, '../types'
    typeFiles.forEach (typeFile) =>
      typeName = path.basename typeFile, '.coffee'
      @buttonTypes[typeName] = require typeFile

  consumeToolBar: (toolBar) ->
    @toolBar = toolBar 'atom-toolbar-preferred'
    @reloadToolbar(false)

  getToolbarView: ->
    # This is an undocumented API that moved in tool-bar@1.1.0
    @toolBar.toolBarView || @toolBar.toolBar

  reloadToolbar: (withNotification=false) ->
    return unless @toolBar?
    try
      @fixToolBarHeight()
      toolBarButtons = @loadConfig()
      @removeButtons()
      @addButtons toolBarButtons
      atom.notifications.addSuccess 'The tool-bar was successfully updated.' if withNotification
      @unfixToolBarHeight()
    catch error
      @unfixToolBarHeight()
      atom.notifications.addError 'Your `toolbar.json` is **not valid JSON**!'
      console.error error

  fixToolBarHeight: ->
    @getToolbarView().element.style.height = "#{@getToolbarView().element.offsetHeight}px"

  unfixToolBarHeight: ->
    @getToolbarView().element.style.height = null

  addButtons: (toolBarButtons) ->
    if toolBarButtons?
      devMode = atom.inDevMode()
      for btn in toolBarButtons

        if ( btn.hide? && @grammarCondition(btn.hide) ) or ( btn.show? && !@grammarCondition(btn.show) )
          continue

        continue if btn.mode and btn.mode is 'dev' and not devMode

        button = @buttonTypes[btn.type](@toolBar, btn) if @buttonTypes[btn.type]

        button.element.classList.add "tool-bar-mode-#{btn.mode}" if btn.mode

        if btn.style?
          for propName, v of btn.style
            button.element.style[changeCase.camelCase(propName)] = v

        if btn.className?
          ary = btn.className.split ","
          for val in ary
            button.element.classList.add val.trim()

        if ( btn.disable? && @grammarCondition(btn.disable) ) or ( btn.enable? && !@grammarCondition(btn.enable) )
          button.setEnabled false

  loadConfig: ->
    ext = path.extname @configFilePath

    switch ext
      when '.js', '.coffee'
        config = require(@configFilePath)
        delete require.cache[@configFilePath]

      when '.json'
        config = require @configFilePath
        delete require.cache[@configFilePath]

      when '.json5'
        require 'json5/lib/require'
        config = require @configFilePath
        delete require.cache[@configFilePath]

      when '.cson'
        CSON = require 'cson'
        config = CSON.requireCSONFile @configFilePath

    if @projectToolbarConfigPath
      ext = path.extname @projectToolbarConfigPath

      switch ext
        when '.js', '.coffee'
          projConfig = require(@projectToolbarConfigPath)
          delete require.cache[@projectToolbarConfigPath]

        when '.json'
          projConfig = require @projectToolbarConfigPath
          delete require.cache[@projectToolbarConfigPath]

        when '.json5'
          require 'json5/lib/require'
          projConfig = require @projectToolbarConfigPath
          delete require.cache[@projectToolbarConfigPath]

        when '.cson'
          CSON = require 'cson'
          projConfig = CSON.requireCSONFile @projectToolbarConfigPath

      for i of projConfig
        config.push projConfig[i]

    return config

  getActiveProject: () ->
    activePanePath = atom.workspace.getActiveTextEditor().getPath()
    projectsPath = atom.project.getPaths()

    for projectPath in projectsPath
      return projectPath if activePanePath.replace(projectPath, '') isnt activePanePath

    return activePanePath.replace /[^\/]+\.(.*?)$/, ''

  grammarCondition: (grammars) ->
    result = false
    grammarType = Object.prototype.toString.call grammars
    grammars = [grammars] if grammarType is '[object String]' or grammarType is '[object Object]'
    filePath = atom.workspace.getActiveTextEditor()?.getPath()

    for grammar in grammars
      reverse = false

      if Object.prototype.toString.call(grammar) is '[object Object]'
        if !treeIsInstalled
          atom.notifications.addError '[Tree](http://mama.indstate.edu/users/ice/tree/) is not installed, please install it.'
          continue

        if filePath is undefined
          continue

        activePath = @getActiveProject()
        options = if grammar.options then grammar.options else {}
        tree = treeMatch activePath, grammar.pattern, options
        return true if Object.prototype.toString.call(tree) is '[object Array]' and tree.length > 0
      else
        if /^!/.test grammar
          grammar = grammar.replace '!', ''
          reverse = true

        if /^[^\/]+\.(.*?)$/.test grammar
          result = true if filePath isnt undefined and filePath.match(grammar)?.length > 0
        else
          result = true if @currentGrammar? and @currentGrammar.includes grammar.toLowerCase()

      result = !result if reverse

      return true if result is true

    return false

  storeProject: ->
    editor = atom.workspace.getActiveTextEditor()
    if editor and editor?.buffer?.file?.getParent()?.path? isnt @currentProject
      if editor?.buffer?.file?.getParent()?.path?
        @currentProject = editor.buffer.file.getParent().path
      return true
    else
      return false

  storeGrammar: ->
    editor = atom.workspace.getActiveTextEditor()
    @currentGrammar = editor?.getGrammar()?.name.toLowerCase()

  didChangeGrammar: ->
    editor = atom.workspace.getActiveTextEditor()
    editor and editor.getGrammar().name.toLowerCase() isnt @currentGrammar

  removeButtons: ->
    @toolBar.removeItems() if @toolBar?

  deactivate: ->
    @watcherList.forEach (watcher) ->
      watcher.close()
    @watcherList = null
    @subscriptions.dispose()
    @subscriptions = null
    @removeButtons()

  serialize: ->
