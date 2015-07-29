
{CompositeDisposable} = require 'atom'

module.exports =
  subscriptions: null

  activate: ->
    @subscriptions = new CompositeDisposable
    @subscriptions.add atom.commands.add 'atom-workspace',
      'flag:wrap', => @wrap()

  deactivate: ->
    @subscriptions.dispose()

  wrap: ->
    if editor = atom.workspace.getActiveTextEditor()
      grammar = editor.getGrammar()
      selection = editor.getSelectedText()
      startColumn = editor.getSelectedBufferRange().start.column

      flagWidth = 50
      fill = ' '
      if selection.length % 2 != 0
        selection += ' '

      paddingLength = (flagWidth - 2 - selection.length) // 2
      padding = Array(paddingLength + 1).join(fill)
      indent = Array(startColumn + 1).join(' ')

      switch grammar.name
        when 'HTML', 'CSS'
          side = '*'
          firstLine = '<!' + Array(flagWidth - 1).join('-')
          lastLine = Array(flagWidth).join('-') + '>'
        when 'JavaScript'
          side = '*'
          firstLine = '/' + Array(flagWidth).join('*')
          lastLine = Array(flagWidth).join('*') + '/'
        when 'Python'
          side = '#'
          firstLine = Array(flagWidth + 1).join('#')
          lastLine = Array(flagWidth + 1).join('#')
        else
          side = '*'
          firstLine = Array(flagWidth + 1).join('*')
          lastLine = Array(flagWidth + 1).join('*')

      flag = firstLine + '\n'
      flag += "#{indent}#{side}#{padding}#{selection}#{padding}#{side}\n"
      flag += indent + lastLine

      editor.insertText(flag)
