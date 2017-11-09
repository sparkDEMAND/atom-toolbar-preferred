# Preferred Toolbar for Atom: _a tool-bar plugin_

[![Build Status](https://travis-ci.org/sparkDEMAND/atom-toolbar-preferred.svg?branch=master)](https://travis-ci.org/sparkDEMAND/atom-toolbar-preferred)
[![bitHound Overall Score](https://www.bithound.io/github/sparkDEMAND/atom-toolbar-preferred/badges/score.svg)](https://www.bithound.io/github/sparkDEMAND/atom-toolbar-preferred)
[![Greenkeeper badge](https://badges.greenkeeper.io/sparkDEMAND/atom-toolbar-preferred.svg)](https://greenkeeper.io/)
[![NSP Status](https://nodesecurity.io/orgs/sparkdemand/projects/020082d2-3575-4c2d-b21d-762625708731/badge)](https://nodesecurity.io/orgs/sparkdemand/projects/020082d2-3575-4c2d-b21d-762625708731)

[![APM License](https://img.shields.io/apm/l/atom-toolbar-preferred.svg)](https://github.com/sparkDEMAND/atom-toolbar-preferred/blob/27fd2c47ebe359d33fcf4f1a8e9ce9013e415c53/LICENSE )
[![APM Downloads](https://img.shields.io/apm/dm/atom-toolbar-preferred.svg)](https://atom.io/packages/atom-toolbar-preferred)
[![APM Version](https://img.shields.io/apm/v/atom-toolbar-preferred.svg)](https://atom.io/packages/atom-toolbar-preferred)


## About

This is a plugin for
the [Atom Tool Bar](https://atom.io/packages/tool-bar) package.

## Description

An Atom tool-bar plugin that builds upon the tool-bar package to provide preferred actions, including live previews, git, formatting, dev tools, IDE tools, and other popularly used actions while remaining uncluttered and intuitive.

It is a fully configurable toolbar compatible with any package. Configuration can be done with a `CSON`, `JSON`, `JSON5`, `js`, or `coffee` file
to perform specific actions in Atom or to open web sites in your default browser.

![screenshot](https://raw.githubusercontent.com/sparkDEMAND/atom-toolbar-preferred/master/screenshot_cson.png)

To edit your config file,
type `Atom Toolbar Preferred: Edit Config File` in the Atom command palette.

## Default Setup

### _**General Commands**_

- **open file**
- **open folder** (requires `atom-commander` package)
- **save file**
- **list projects** (requires `project-manager` package)

### _**Previews & Management**_

- **markdown preview** (requires `markdown-preview` package)
- **html preview** (requires `atom-html-preview` package)
- **find and replace**
- **project: ToDo list** (requires `todo-show` package)

### _**Git Commands**_

- **git command menu** (requires `git-plus` package)
- **git projects** (requires `git-projects` package)
- **show blame** (requires `blame` package)
- **show git diff details** (requires `git-diff-details` package)
- **show merge conflicts** (requires `merge-conflicts` package)
- **show git time machine** (requires `git-time-machine` package)
- **open on github** (requires `open-on-github` package)

### _**Viewing & Arranging**_

- **toggle fullscreen**
- **split screen - vertically**
- **split screen - horizontally**
- **focus active pane** (requires `hey-pane` package)
- **split diff** (requires `split-diff` package)
- **toggle sidebar**
- **toggle minimap** (requires `minimap` package)
- **toggle exposé** (requires `expose` package)

### _**Formatting**_

- **beautify** (requires `atom-beautify` package)
- **auto-indent**
- **fold all**
- **unfold all**

### _**IDE & Dev Tools**_

- **open a terminal (split bottom)** (requires `term3` package)
  - _config file can also be altered to use_
    1. _`term2` package_
    1. _`terminal-plus` package_
    1. _`platformio-ide-terminal` package_
  - _see [configuration](https://github.com/sparkDEMAND/atom-toolbar-preferred#configuration)._
- **open REST client** (requires `rest-client` package)
- **run script** (requires `script` package)
- **stop script** (requires `script` package)
- **configure script** (requires `script` package)


- **reload window**
- **toggle dev-tools**
- **ask stack-overflow** (requires `ask-stack`)


- **open command palette**
- **open settings view**

**Note**: The toolbar buttons that require other packages will appear when you have those packages installed.

## Installation

To use 'atom-toolbar-preferred', you have to first install the 'tool-bar' dependency package:

### Command Line

```bash
apm install tool-bar
```

Then you install the `atom-toolbar-preferred` package:

```bash
apm install atom-toolbar-preferred
```

## Options

1. You have the ability to include [custom entries](https://github.com/sparkDEMAND/atom-toolbar-preferred#configuration).
1. You also have the ability to load the [suggested defaults](https://github.com/sparkDEMAND/atom-toolbar-preferred#default-setup) along side your custom entries, or only the custom entries.

## Configuration

**Atom Preferred Toolbar** has four `type`s you can configure:

`button`, `url`, `function` and `spacer`.

1.  `button` creates default buttons for your toolbar.

     You can use it to set actions like `application:new-file`.

1.  `url` creates buttons pointing to specific web pages.

    Use this to open any web site, such as your GitHub notifications, in your default browser.

    If you have the package [browser-plus](https://atom.io/packages/browser-plus)
    installed, you can open links with atom. To enable this feature, check the corresponding box within Atom Toolbar Preferred's settings.

    Atom URI can also be used. For example; `atom://config/packages/atom-toolbar-preferred` will open Atom Toolbar Preferred's settings.

-   `function` creates buttons that can call a function with the previous target as a parameter

    In order to do this, the config file **must** be a `.js` or `.coffee` file that exports the array of buttons.

-   `spacer` adds separators between toolbar buttons.

### Features
- multiple callback
- function callback
- inline button styles
- add class(s) to buttons
- hide/disable a button in certain cases

### Example

```coffee
[
  {
    type: "url"
    tooltip: "Github Page"
    url: "https://github.com/"
    icon: "octoface"
  },
  {
    type: 'button'
    tooltip: 'List projects'
    dependency: 'project-manager'
    callback: 'project-manager:list-projects'
    icon: 'file-submodule'
  },
  {
    type: 'button'
    tooltip: 'Markdown Preview'
    dependency: 'markdown-preview'
    callback: 'markdown-preview:toggle'
    disable: '!markdown' # only show button for markdown files
    icon: 'social-markdown'
    iconset: 'ion'
  },
  {
    type: "function"
    tooltip: "Debug Target"
    callback: (target) ->
      console.dir target
    icon: "bug"
    iconset: "fa"
  },
  {
    type: "spacer"
  }
]
```

See more examples on [Wiki](https://github.com/sparkDEMAND/atom-toolbar-preferred/wiki) ✨

## Authors

| [![sparkDEMAND][sparkDEMAND avatar]](https://github.com/sparkDEMAND) | [![Jay Schwartz][jschwrtz avatar]](https://github.com/jschwrtz) |
| :-----------------------------------------------------------: | :-----------------------------------------------------------------: |
| [sparkDEMAND](https://github.com/sparkDEMAND) | [Jay Schwartz](https://github.com/jschwrtz) |

## License

[Apache-2.0](https://www.apache.org/licenses/LICENSE-2.0) @ [sparkDEMAND, LLC.](https://github.com/sparkDEMAND/)

[sparkDEMAND avatar]: https://avatars3.githubusercontent.com/u/30666313?s=400&u=345e76d27c1be4d8035bb23cd2db75e80acf6b9f&v=4
[jschwrtz avatar]: https://avatars3.githubusercontent.com/u/26683765?s=400&u=8f2394929ce8d484e04b36527e1351797e029fc6&v=4
