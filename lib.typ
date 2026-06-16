// Components and theme for the Lockin compendium.
// Design: monochrome, spacious, easy to read cold. No coloured fills.
// Group with whitespace and thin gray hairlines. Math gets its own display blocks.

#import "@preview/cetz:0.3.4"

#let ink = rgb("#111111")
#let soft = rgb("#5b5b5b")
#let hair = rgb("#d8d8d8")

// --- tiny inline graph diagrams (monochrome, for the cheat-sheet cards) ---
// A node: a small labelled circle at point `p`, registered under `name`.
#let gnode(p, name, label) = {
  import cetz.draw: *
  circle(p, radius: 0.18, name: name, fill: white, stroke: 0.6pt + ink)
  content(p, text(size: 6.5pt)[#label])
}
// A directed edge a -> b with an optional weight label on the midpoint.
// The label sits on a white box so the line does not run through it.
#let gedge(a, b, w: none) = {
  import cetz.draw: *
  line(a, b, mark: (end: "stealth", fill: ink, scale: 0.35), stroke: 0.55pt + ink)
  if w != none {
    content((a, 50%, b), box(fill: white, inset: 0.6pt, text(size: 6pt)[#w]))
  }
}
// Wrap a set of gnode/gedge calls into a centred mini-canvas.
#let gdiag(body) = align(center, cetz.canvas(length: 0.8cm, body))

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
  // Invisible anchor so the recipe shows up in the PDF outline (sidebar).
  #heading(level: 5, outlined: false, bookmarked: true)[#title]
  #text(weight: "bold", size: 11pt)[#title]
  #v(7pt)
  #enum(tight: false, spacing: 11pt, ..steps.pos())
]

// Aside: a small heading followed by normal prose. No box, no rule.
// `title` is a short heading for the point; defaults to "Bemærk".
#let note(title: [Bemærk], body) = block(
  width: 100%, breakable: true, above: 14pt, below: 14pt,
)[
  #text(weight: "bold", size: 11pt)[#title]
  #v(3pt)
  #body
]

// Common pitfall. Same plain styling; the heading carries the warning.
// `title` is a short heading; defaults to "Fælde".
#let trap(title: [Fælde], body) = block(
  width: 100%, breakable: true, above: 14pt, below: 14pt,
)[
  #text(weight: "bold", size: 11pt)[#title]
  #v(3pt)
  #body
]

// A worked exam question, quoted as the exam phrases it.
// `prompt` = the question text (verbatim). `options` = array of answer choices
// shown exactly as on the exam (optional). `answer` = the correct choice.
// `worked` = a short solution.
#let qcard(source: "", prompt: [], options: (), answer: [], worked: [], blueprint: [], tag: "") = block(
  width: 100%, breakable: true, above: 18pt, below: 18pt,
)[
  // Register this question so the problem index can list and link to it.
  #metadata((source: source, prompt: prompt, tag: tag)) <qcard>
  // Invisible anchor so the question shows up in the PDF outline (sidebar).
  #if tag != "" { heading(level: 5, outlined: false, bookmarked: true)[#tag] }
  #line(length: 100%, stroke: 0.4pt + hair)
  #v(7pt)
  #text(size: 9pt, fill: soft)[#source]
  #v(7pt)
  #prompt
  #if options.len() > 0 {
    v(6pt)
    enum(numbering: "(a)", tight: true, spacing: 5pt, ..options)
  }
  #v(10pt)
  #text(weight: "bold")[Svar. ] #answer
  // Blueprint: the reusable method for this question type, with blanks to fill in.
  #if blueprint != [] {
    v(11pt)
    block(breakable: true)[
      #text(weight: "bold", size: 11pt)[Skabelon — sæt dine egne tal ind]
      #v(5pt)
      #blueprint
    ]
  }
  // Worked: the concrete run-through, spaced out so it reads cold.
  #if worked != [] {
    v(11pt)
    block(breakable: true)[
      #text(weight: "bold", size: 11pt)[Gennemregning]
      #v(5pt)
      #worked
    ]
  }
]

// Part divider on its own page.
#let part(name) = {
  pagebreak(weak: true)
  heading(level: 1, numbering: none, name)
}
