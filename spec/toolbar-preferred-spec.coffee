AtomToolBarPreferred = require '../lib/atom-toolbar-preferred'
path = require 'path'
ToolBarCson = path.join __dirname, './toolbar.cson'

describe "AtomToolBarPreferred", ->
  [workspaceElement, atomToolBarPreferred, editor, toolBar, jsGrammar] = []

  beforeEach ->
    workspaceElement = atom.views.getView(atom.workspace)
    atom.config.set 'atom-toolbar-preferred.toolBarConfigurationFilePath', ToolBarCson

    waitsForPromise ->
      atom.packages.activatePackage('tool-bar').then (pack) ->
        toolBar = pack.mainModule

    waitsForPromise ->
      atom.packages.activatePackage('atom-toolbar-preferred').then (pack) ->
        atomToolBarPreferred = pack.mainModule

    waitsForPromise ->
      atom.packages.activatePackage('language-text')

    waitsForPromise ->
      atom.packages.activatePackage('language-javascript')

    waitsForPromise ->
      atom.workspace.open 'toolbar.cson'

    runs ->
      editor = atom.workspace.getActiveTextEditor()
      jsGrammar = atom.grammars.grammarForScopeName('source.js')
