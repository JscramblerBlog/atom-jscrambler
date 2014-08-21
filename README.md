# [atom](https://atom.io/)-[jscrambler](https://jscrambler.com/)

[JScrambler](https://jscrambler.com/) is a JavaScript obfuscation tool.

Obfuscate and minify your HTML5 and [Node.js](http://nodejs.org/) applications.

## Usage

* Hit Ctrl+Shift+O to scramble the currently active file
* Hit Ctrl+Shift+Option+O to scramble the entire project

You can also find this options in the contextual and packages menus.

## Configuration
    'jScrambler':
      # Must be relative to the project
      'filesDest': './dist'
      'keys':
        'accessKey': ''
        'secretKey': ''
      'params':
  	    'expiration_date': '2199-01-01'
  	    'rename_local': '%DEFAULT%'
  	    'whitespace': '%DEFAULT%'

This configuration must be placed in your Atom's `config.cson` file (under Atom -> Open Your Config). You can find all parameters documentation in [here](https://github.com/auditmark/node-jscrambler).
