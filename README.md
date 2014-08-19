# [atom](https://atom.io/)-jscrambler

[atom](https://atom.io/) integration with [JScrambler](https://jscrambler.com/)

## Usage

* Hit Cmd+Shift+O to scramble the currently active file
* Hit Cmd+Shift+Option+O to scramble the entire project

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
  	    'rename_local': '%DEFAULT%''
  	    'whitespace': '%DEFAULT%'

This configuration must be placed in your Atom's `config.cson` file (under Atom -> Open Your Config). You can find all parameters documentation in [here](https://github.com/auditmark/node-jscrambler).
