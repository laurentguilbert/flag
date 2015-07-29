
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
      text = editor.getSelectedText()

      flagWidth = 50
      fill = ' '

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

      maxTextLength = flagWidth - side.length * 2
      text = text.substring(0, maxTextLength)
      if text.length % 2 != 0
        text += ' '

      paddingLength = (maxTextLength - text.length) // 2
      padding = Array(paddingLength + 1).join(fill)

      offsetLength = editor.getSelectedBufferRange().start.column
      offset = Array(offsetLength + 1).join(' ')

      flag = firstLine + '\n'
      flag += "#{offset}#{side}#{padding}#{text}#{padding}#{side}\n"
      flag += offset + lastLine

      editor.insertText(flag)
