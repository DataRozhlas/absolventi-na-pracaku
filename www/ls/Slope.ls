class ig.Slope
  (@parentElement) ->
    @_setDefaults!
    @_prepareElements!
    ig.Events @

  setData: (@data) ->
    allYValues = []
    linePointYs = for datum in @data
      pointY = @ycb datum
      allYValues.push pointY.0, pointY.1
      pointY

    @scale = d3.scale.linear!
      ..domain @scaleExtentCb allYValues
      ..range [@height, @marginObj.bottom]

    @linePointCoords = for yValues, i in linePointYs
      x1 = @marginObj.left
      x2 = @width
      [y1, y2] = yValues.map @scale
      datum = @data[i]
      {x1, x2, y1, y2, datum}

  y: (@ycb) ->

  x1: (@x1Position) ->

  x2: (@x2Position) ->

  margin: (@marginObj) ->
    @_calculateInnerDimensions!

  scaleExtent: (@scaleExtentCb) ->

  draw: ->
    @_drawGraph!
    @_drawInteractive!


  _drawGraph: ->
    @graphContainer
      ..append \g
        ..attr \class \lines
        ..selectAll \g.line .data @linePointCoords .enter!append \g
          ..attr \class \line
          ..append \line
            ..attr \x1 (.x1)
            ..attr \x2 (.x2)
            ..attr \y1 (.y1)
            ..attr \y2 (.y2)
          ..append \circle
            ..attr \cx (.x1)
            ..attr \cy (.y1)
            ..attr \r 3
          ..append \circle
            ..attr \cx (.x2)
            ..attr \cy (.y2)
            ..attr \r 3
          ..append \g
            ..attr \class "label label-start"
            ..attr \transform -> "translate(#{it.x1}, #{it.y1})"
          ..append \g
            ..attr \class "label label-end"
            ..attr \transform -> "translate(#{it.x2}, #{it.y2})"

  _drawInteractive: ->
    splitPoints = []
    for line in @linePointCoords
      splitPoints.push {x: line.x1, y: line.y1, point: line.datum}
      splitPoints.push {x: line.x2, y: line.y2, point: line.datum}
      splitPoints.push {x: (line.x2 + line.x1) / 2, y: (line.y1 + line.y2) / 2, point: line.datum}
    voronoi = d3.geom.voronoi!
      ..x (.x)
      ..y (.y)
      ..clipExtent [[0, 0], [@fullWidth, @fullHeight]]
    voronoiPolygons = voronoi splitPoints
      .filter -> it
    @interactiveContainer.selectAll \path .data voronoiPolygons .enter!append \path
      ..attr \d polygon
      ..on \mouseover ~> @emit \mouseover it.point.point
      ..on \touchstart ~> @emit \mouseover it.point.point
      ..on \mouseout ~> @emit \mouseout it.point.point
      ..on \click ~>
        @emit \click it.point.point

  _setDefaults: ->
    @ycb = -> [it.y1, it.y2]
    @scaleExtentCb = d3.extent
    @y1Label = (gElement, data) ->
      gElement.append \text
        ..html data.label
    @y2Label = (gElement, data) ->
      gElement.append \text
        ..html data.label
    @fullWidth = @parentElement.node!clientWidth
    @fullHeight = @parentElement.node!clientHeight
    @marginObj = top: 0 right: 0 bottom: 0 left: 0
    @_calculateInnerDimensions!

  _calculateInnerDimensions: ->
    @width = @fullWidth - @marginObj.left - @marginObj.right
    console.log @fullWidth, @width
    @height = @fullHeight - @marginObj.top - @marginObj.bottom

  _prepareElements: ->
    @element = @parentElement.append \div
      ..attr \class \slope

    @graphContainer = @element.append \svg
      ..attr \class \graph
      ..attr {width: @fullWidth, height: @fullHeight}

    @interactiveContainer = @element.append \svg
      ..attr \class \interactive
      ..attr {width: @fullWidth, height: @fullHeight}

polygon = -> "M#{it.join "L"}Z"
