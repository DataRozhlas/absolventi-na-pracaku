
obory = d3.csv.parse ig.data.obory, (row) ->
  row.name = row.typ
  for field in <[abs2001 abs2015 prac2001 prac2015]>
    row[field] = parseInt row[field], 10
  row.absolventi = [row.abs2001, row.abs2015]
  row.nezamestnani = [row.prac2001 / row.abs2001, row.prac2015 / row.abs2015]
  row
container = d3.select ig.containers.base
slope1Container = container.append \div
  ..attr \class \slope1
slope2Container = container.append \div
  ..attr \class \slope2

slope1 = new ig.Slope slope1Container
  ..y -> it.absolventi
  ..margin {left: 60, right: 60, top: 20, bottom: 15}
  ..scaleExtent (yValues) -> [0, d3.max yValues]
  ..setData obory
  ..draw!

slope2 = new ig.Slope slope2Container
  ..y -> it.nezamestnani
  ..margin {left: 60, right: 290, top: 20, bottom: 15}
  ..scaleExtent (yValues) -> [0, d3.max yValues]
  ..setData obory
  ..draw!

allLines = container.selectAll \g.line
for slope in [slope1, slope2]
  slope.on \mouseover, (datum) ->
    allLines.classed \active -> it.datum is datum

slope1.graphContainer.selectAll \g.label-start .append \text
  ..attr \text-anchor \end
  ..attr \x -15
  ..attr \y 4
  ..text -> ig.utils.formatNumber it.datum.abs2001
slope1.graphContainer.selectAll \g.label-end .append \text
  ..attr \x 15
  ..attr \y 4
  ..text -> ig.utils.formatNumber it.datum.abs2015
for slope in [slope1, slope2]
  slope
    ..x1Label.append \text
      ..text "2001"
      ..attr \text-anchor \middle
      ..attr \y 10
    ..x2Label.append \text
      ..text "2015"
      ..attr \text-anchor \middle
      ..attr \y 10

slope2.graphContainer.selectAll \g.label-start .append \text
  ..attr \text-anchor \end
  ..attr \x -15
  ..attr \y 4
  ..text ->
    "#{ig.utils.formatNumber it.datum.prac2001 / it.datum.abs2001 * 100, 1} %"

slope2.graphContainer
  ..selectAll \g.label-end
    ..append \text
      ..attr \x 15
      ..attr \y -4
      ..text ->
        "#{ig.utils.formatNumber it.datum.prac2015 / it.datum.abs2015 * 100, 1} % nezaměstnaných"
    ..append \text
      ..attr \x 15
      ..attr \y 14
      ..text -> it.datum.name

allLines.classed \active -> it.datum is obory[4]
