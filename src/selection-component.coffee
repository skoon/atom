React = require 'react'
{div} = require 'reactionary'

module.exports =
SelectionComponent = React.createClass
  displayName: 'SelectionComponent'

  render: ->
    {editor, screenRange, lineHeight} = @props
    {start, end} = screenRange
    rowCount = end.row - start.row + 1
    startPixelPosition = editor.pixelPositionForScreenPosition(start)
    endPixelPosition = editor.pixelPositionForScreenPosition(end)

    div className: 'selection',
      if rowCount is 1
        @renderSingleLineRegions(startPixelPosition, endPixelPosition)
      else
        @renderMultiLineRegions(startPixelPosition, endPixelPosition, rowCount)

  renderSingleLineRegions: (startPixelPosition, endPixelPosition) ->
    {lineHeight} = @props

    [
      div className: 'region', key: 0, style:
        top: startPixelPosition.top
        height: lineHeight
        left: startPixelPosition.left
        width: endPixelPosition.left - startPixelPosition.left
    ]

  renderMultiLineRegions: (startPixelPosition, endPixelPosition, rowCount) ->
    {lineHeight} = @props
    regions = []
    index = 0

    # First row, extending from selection start to the right side of screen
    regions.push(
      div className: 'region', key: index++, style:
        top: startPixelPosition.top
        left: startPixelPosition.left
        height: lineHeight
        right: 0
    )

    # Middle rows, extending from left side to right side of screen
    if rowCount > 2
      regions.push(
        div className: 'region', key: index++, style:
          top: startPixelPosition.top + lineHeight
          height: (rowCount - 2) * lineHeight
          left: 0
          right: 0
      )

    # Last row, extending from left side of screen to selection end
    regions.push(
      div className: 'region', key: index, style:
        top: endPixelPosition.top
        height: lineHeight
        left: 0
        width: endPixelPosition.left
    )

    regions
