return if window.location.hash != '#bar'
vzdelani = d3.csv.parse ig.data.vzdelani, (row) ->
  row.name = row.typ
  for field in <[abs prac]>
    row[field] = parseInt row[field], 10
  row.nezamestnani = row.prac / row.abs
  row

vzdelani.sort (a, b) -> b.nezamestnani - a.nezamestnani
maxHeight = 280
nezamestnaniScale = d3.scale.linear!
  ..domain [0 0.3]
  ..range [0 maxHeight]
absolventiScale = -> Math.round it / 78946 * 34
container = d3.select ig.containers.base
  ..attr \class "ig bar-chart-container"
barContainer = container.append \ol
  ..attr \class \bar-chart
  ..selectAll \li .data vzdelani .enter!append \li
    ..append \span
      ..attr \class \title
      ..html (.name)
    ..append \div
      ..attr \class \bar-nezamestnani
      ..style \height -> "#{nezamestnaniScale it.nezamestnani}px"
      ..append \span
        ..attr \class \value
        ..html (it, i) ->
          o = "#{ig.utils.formatNumber it.nezamestnani * 100, 1} %"
          if i == 0 then o += "<span><br>nezam.</span>"
          o
    ..append \div
      ..attr \class \boxes-absolventi
      ..selectAll \div .data (-> [0 to absolventiScale it.abs]) .enter!append \div
      ..append \span
        ..attr \class \value
        ..html (it, i) ->
          o = ig.utils.formatNumber it.abs
          if i == 0 then o += "<span><br>absolv.</span>"
          o
container.append \ul
  ..attr \class \legend
  ..append \li
    ..html "Střední a vyšší odborné vzdělání"
  ..append \li
    ..html "Univerzitní vzdělání"
  ..append \li
    ..html "Všeobecné vzdělání"
