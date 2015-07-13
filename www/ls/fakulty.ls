return if window.location.hash != '#fakulty'
container = d3.select ig.containers.base
  ..attr \class "ig fakulty"
univerzity = []
lastUniverzita = null
d3.csv.parse ig.data.fakulty, (row) ->
  row.abs = parseInt row.abs, 10
  row.up = parseInt row.up, 10
  if isNaN row.up
    return
  row.ratio = row.up / row.abs
  row.name = row['škola']
  if row.uni == "T"
    univerzita = row
      ..fakulty = []
    lastUniverzita := univerzita
    univerzity.push univerzita
  else
    univerzita = lastUniverzita
    univerzita.fakulty.push row
  row

univerzity .= filter (.abs > 50)
univerzity.sort (a, b) -> b.ratio - a.ratio
for univerzita in univerzity
  univerzita.fakulty.sort (a, b) -> b.ratio - a.ratio

lineHeight = 42px
widthScale = -> it / univerzity.0.ratio * 300px

container.append \ol
  ..attr \class \fakulty
  ..selectAll \li .data univerzity .enter!append \li
    ..attr \data-i (d, i) -> i
    ..append \span .html (.name)
      ..attr \class \name
    ..append \div
      ..attr \class \bar
      ..style \width -> "#{widthScale it.ratio}px"
      ..append \span
        ..attr \class \value
        ..html -> "#{ig.utils.formatNumber it.ratio * 100, 1} %"
        ..filter (.fakulty.length)
          ..append \a
            ..attr \class \more
            ..attr \href \#
            ..html "Zobrazit fakulty"
            ..on \click (d, i) ->
              d3.event.preventDefault!
              listItems
                .filter -> it is d
                .classed \active yes
          ..append \a
            ..attr \class \less
            ..attr \href \#
            ..html "Skrýt fakulty"
            ..on \click (d, i) ->
              d3.event.preventDefault!
              listItems
                .filter -> it is d
                .classed \active no

    ..filter (.fakulty.length)
      ..append \ol
        ..selectAll \li .data (.fakulty) .enter!append \li
          ..append \span
            ..attr \class \name
            ..html (.name)
          ..append \div
            ..attr \class \bar
            ..style \width -> "#{widthScale it.ratio}px"
            ..append \span
              ..attr \class \value
              ..html -> "#{ig.utils.formatNumber it.ratio * 100, 1} %"

listItems = container.selectAll "ol.fakulty > li"
