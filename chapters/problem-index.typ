#import "../lib.typ": *

== Find en opgave efter type

Hver gennemregnet eksamensopgave står her, sorteret efter opgavetype. Find den type du sidder fast i, klik på opgaven, og hop ned til løsningen. Du kan også søge efter et ord i opgaveteksten.

#context {
  // Keep this page's links clean: the global rule underlines every link, which
  // is too heavy when the link wraps a whole question.
  show link: it => it

  let cards = query(<qcard>)

  // Group each registered question under the level-2 heading (chapter) it sits in.
  let groups = ()         // array of (chapter: content, items: array)
  let order = ()          // chapter bodies in first-seen order
  for c in cards {
    let loc = c.location()
    let heads = query(selector(heading.where(level: 2)).before(loc))
    // Skip headings that are themselves part of the front matter (this very page).
    let chap = if heads.len() > 0 { heads.last().body } else { [Øvrige] }
    let key = repr(chap)
    if key not in order {
      order.push(key)
      groups.push((key: key, chapter: chap, items: ()))
    }
    let i = order.position(k => k == key)
    let tag = if "tag" in c.value { c.value.tag } else { "" }
    groups.at(i).items.push((loc: loc, prompt: c.value.prompt, tag: tag))
  }

  for g in groups {
    block(above: 16pt, below: 6pt)[
      #text(weight: "bold", size: 12pt)[#g.chapter]
      #v(2pt)
      #line(length: 100%, stroke: 0.4pt + hair)
    ]
    for it in g.items {
      block(above: 7pt, below: 7pt, breakable: false)[
        #link(it.loc)[
          #grid(
            columns: (auto, 1fr),
            gutter: 6pt,
            text(fill: soft)[#sym.triangle.r.filled],
            if it.tag != "" {
              stack(
                spacing: 3pt,
                text(size: 10pt, weight: "bold", fill: ink)[#it.tag],
                text(size: 8.5pt, fill: soft)[#it.prompt],
              )
            } else {
              text(size: 10pt, fill: ink)[#it.prompt]
            },
          )
        ]
      ]
    }
  }

  v(8pt)
  text(size: 9pt, fill: soft)[I alt #cards.len() opgaver.]
}
