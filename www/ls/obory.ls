
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
  ..margin {left: 40, right: 50, top: 20, bottom: 20}
  ..scaleExtent (yValues) -> [0, d3.max yValues]
  ..setData obory
  ..draw!

slope2 = new ig.Slope slope2Container
  ..y -> it.nezamestnani
  ..margin {left: 40, right: 50, top: 20, bottom: 20}
  ..scaleExtent (yValues) -> [0, d3.max yValues]
  ..setData obory
  ..draw!

allLines = container.selectAll \g.line
for slope in [slope1, slope2]
  slope.on \mouseover, (datum) ->
    allLines.classed \active -> it.datum is datum
