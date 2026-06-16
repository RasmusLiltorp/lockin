#import "lib.typ": *

#set document(title: "Lockin — SE4-DMAD compendium", author: "Rasmus Liltorp")
#set page(
  paper: "a4",
  margin: (x: 2.2cm, y: 2.4cm),
  numbering: "1",
  header: context {
    let heads = query(selector(heading.where(level: 2)).before(here()))
    if heads.len() > 0 {
      set text(size: 8.5pt, fill: rgb("#64748b"))
      heads.last().body
      h(1fr)
      [SE4-DMAD]
      line(length: 100%, stroke: 0.3pt + rgb("#cbd5e1"))
    }
  },
)
#set text(font: "New Computer Modern", size: 11pt, lang: "da", fill: ink)
#set par(justify: true, leading: 0.78em, spacing: 1.1em)
#set heading(numbering: none)

// --- heading styles (monochrome) ---
#show heading.where(level: 1): it => {
  set text(size: 24pt, fill: ink, weight: "bold")
  v(10pt)
  block(it.body)
  v(4pt)
  line(length: 100%, stroke: 1pt + ink)
  v(14pt)
}
#show heading.where(level: 2): it => {
  pagebreak(weak: true)
  set text(size: 17pt, fill: ink, weight: "bold")
  block(it.body)
  v(8pt)
}
#show heading.where(level: 3): it => {
  set text(size: 12pt, fill: ink, weight: "bold")
  v(12pt)
  block(it.body)
  v(2pt)
}
#show heading.where(level: 4): it => {
  set text(size: 11pt, fill: ink, weight: "bold")
  v(10pt)
  block(it.body)
  v(1pt)
}
#show link: it => underline(text(fill: ink)[#it])

// --- title page ---
#align(center + horizon)[
  #text(size: 40pt, weight: "bold", fill: ink)[Lockin]
  #v(6pt)
  #text(size: 14pt)[SE4-DMAD eksamenskompendium]
  #v(2pt)
  #text(size: 11pt, fill: rgb("#64748b"))[Diskret matematik + Algoritmer og datastrukturer]
  #v(30pt)
  #text(size: 10pt, fill: rgb("#64748b"))[
    Ordnet efter opgavetype. Hvert kapitel giver en genbrugelig opskrift, \
    derefter de tilbagevendende eksamensopgaver løst — bare indsæt de nye tal.
  ]
  #v(4pt)
  #text(size: 10pt)[Rasmus Liltorp]
]
#pagebreak()

// --- clickable table of contents ---
#outline(title: [Indhold], depth: 3, indent: auto)
#pagebreak()

// --- clickable index of every exam problem ---
#include "chapters/problem-index.typ"

// ============================================================
#part[Del I — Diskret matematik]
#include "chapters/logic.typ"
#include "chapters/predicate-logic.typ"
#include "chapters/proofs.typ"
#include "chapters/induction.typ"
#include "chapters/relations.typ"

#part[Del II — Algoritmer og datastrukturer]
#include "chapters/asymptotics.typ"
#include "chapters/recurrences.typ"
#include "chapters/sorting.typ"
#include "chapters/divide-and-conquer.typ"
#include "chapters/dynamic-programming.typ"
#include "chapters/greedy.typ"
#include "chapters/heaps.typ"
#include "chapters/search-structures.typ"
#include "chapters/disjoint-sets.typ"
#include "chapters/graph-traversal.typ"
#include "chapters/mst.typ"
#include "chapters/shortest-paths.typ"
#include "chapters/invariants.typ"

#part[Appendiks]
#include "chapters/appendix.typ"
