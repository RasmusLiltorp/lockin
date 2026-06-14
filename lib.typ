// Components and theme for the Lockin compendium.
// Design: monochrome, spacious, easy to read cold. No coloured fills.
// Group with whitespace and thin gray hairlines. Math gets its own display blocks.

#let ink = rgb("#111111")
#let soft = rgb("#5b5b5b")
#let hair = rgb("#d8d8d8")

// A value you change from one exam to the next. Subtle underline, no colour.
#let swap(body) = box(
  outset: (bottom: 2pt),
  stroke: (bottom: 0.6pt + soft),
)[#text(weight: "bold")[#body]]

// Display equation with room around it. Use for every formula worth its own line.
#let eq(body) = block(width: 100%, above: 14pt, below: 14pt)[
  #align(center)[#body]
]

// Step-by-step recipe: a heading-like title and a numbered list, well spaced.
#let recipe(title: "Sådan løser du den", ..steps) = block(
  width: 100%, breakable: true, above: 16pt, below: 16pt,
)[
  #text(weight: "bold", size: 11pt)[#title]
  #v(7pt)
  #enum(tight: false, spacing: 11pt, ..steps.pos())
]

// Aside. Thin gray left rule, generous spacing, no fill.
#let note(body) = block(
  width: 100%, breakable: true, above: 13pt, below: 13pt,
  inset: (left: 12pt), stroke: (left: 1pt + hair),
)[#text(weight: "bold")[Bemærk. ] #body]

// Common trap. Heavier black left rule so it reads differently from a note, no fill.
#let trap(body) = block(
  width: 100%, breakable: true, above: 13pt, below: 13pt,
  inset: (left: 12pt), stroke: (left: 2pt + ink),
)[#text(weight: "bold")[Fælde. ] #body]

// A worked exam question, quoted as the exam phrases it.
// `prompt` = the question text (verbatim). `options` = array of answer choices
// shown exactly as on the exam (optional). `answer` = the correct choice.
// `worked` = a short solution.
#let qcard(source: "", prompt: [], options: (), answer: [], worked: []) = block(
  width: 100%, breakable: true, above: 18pt, below: 18pt,
)[
  // Register this question so the problem index can list and link to it.
  #metadata((source: source, prompt: prompt)) <qcard>
  #line(length: 100%, stroke: 0.4pt + hair)
  #v(7pt)
  #text(size: 9pt, fill: soft)[#source]
  #v(7pt)
  #prompt
  #if options.len() > 0 {
    v(6pt)
    enum(numbering: "(a)", tight: true, spacing: 5pt, ..options)
  }
  #v(9pt)
  #text(weight: "bold")[Svar. ] #answer
  #if worked != [] {
    v(7pt)
    block[#text(weight: "bold")[Fremgangsmåde. ] #worked]
  }
]

// Part divider on its own page.
#let part(name) = {
  pagebreak(weak: true)
  heading(level: 1, numbering: none, name)
}
