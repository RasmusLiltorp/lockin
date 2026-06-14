# Lockin — SE4-DMAD exam compendium

Master index of all course material for **SE4-DMAD** (Discrete Mathematics + Algorithms & Data Structures, SDU).

The exam is a **digital open-notes MCQ test**: textbooks, slides, notes and formula sheets are allowed; internet and chatbots are not. This repo builds a single clickable reference (`main.typ` → `main.pdf`) organized **by problem type**, with the recurring exam questions worked out underneath each type so you only swap in new numbers on the day.

This README is the navigation hub: it lists every file we have, grouped by category, with a one-line description. Per-file deep-dive notes (Phase 2) get linked from the coverage tables as we write them.

---

## How the material is organized

The course has two halves, reflected in the folders:

- **Discrete Mathematics** — logic, proofs, induction, quantifiers, relations. Material in [`material/discrete-maths/`](material/discrete-maths/).
- **Algorithms & Data Structures** — sorting, divide & conquer, dynamic programming, greedy, graphs, trees. Slides in [`material/slides/`](material/slides/).

Plus old exams (both halves), exam rules, and a logarithm refresher.

---

## 1. Algorithms & Data Structures — lecture slides

Located in [`material/slides/allSlidesF26/`](material/slides/allSlidesF26/). Each topic exists in two variants:
- `OriginalSlides/` — slides with build/pause animations.
- `SlidesWithNoPauses/` — same content, flattened (better for searching/printing).

Combined single-file versions:
- [`originalSlidesAllInOne.pdf`](material/slides/originalSlidesAllInOne.pdf) — every original slide deck in one PDF.
- [`slidesWithNoPausesAllInOne.pdf`](material/slides/slidesWithNoPausesAllInOne.pdf) — every no-pauses deck in one PDF.

| Deck | Topic |
|---|---|
| `introSlides.pdf` | Course introduction |
| `puzzleSlides.pdf` | Motivating puzzles / problem-solving warmup |
| `algoritmeAnalyseIntro.pdf` | Introduction to algorithm analysis |
| `asymptoticAnalysis.pdf` | Asymptotic analysis — Big-O, Ω, Θ |
| `invariantSlides.pdf` | Loop invariants & correctness proofs |
| `talReprSlides.pdf` | Number representation (tal-repræsentation) |
| `maxSumSlides.pdf` | Maximum subarray sum problem |
| `sortingSlides.pdf` | Comparison sorting — insertion, merge, quick, heapsort |
| `sortingInLinearTimeSlides.pdf` | Linear-time sorting — counting, radix, bucket |
| `divideAndConquerFirstIntroSlides.pdf` | Divide & conquer — first introduction |
| `divideAndConquerSlides.pdf` | Divide & conquer & recurrences (Master theorem) |
| `strassenSlides.pdf` | Strassen's matrix multiplication |
| `dynamicProgrammingSlides.pdf` | Dynamic programming (part 1) |
| `dynamicProgrammingSlides2.pdf` | Dynamic programming (part 2) |
| `greedySlides.pdf` | Greedy algorithms |
| `pqSlides.pdf` | Priority queues & heaps |
| `dictionarySlides.pdf` | Dictionaries — hashing / search structures |
| `augmentedBSTSlides.pdf` | Augmented binary search trees |
| `disjointSetsSlides.pdf` | Disjoint sets / union-find |
| `graphTraversalSlides.pdf` | Graph traversal — BFS & DFS |
| `connectedComponentsSlides.pdf` | Connected components |
| `mstSlides.pdf` | Minimum spanning trees — Kruskal, Prim |
| `shortestPathsSlides.pdf` | Shortest paths — Dijkstra, Bellman-Ford |

> Topic labels are inferred from deck names; Phase 2 confirms each deck's exact contents.

---

## 2. Discrete Mathematics — lecture notes

Located in [`material/discrete-maths/slides/`](material/discrete-maths/slides/). Danish. (`Noter` = "notes".)

| File | Topic |
|---|---|
| [`Noter1.pdf`](material/discrete-maths/slides/Noter1.pdf) | Logic — propositions, truth tables, logical operators (~15 pp) |
| [`Noter2.pdf`](material/discrete-maths/slides/Noter2.pdf) | Proof methods — direct, contraposition, strategies |
| [`Noter3.pdf`](material/discrete-maths/slides/Noter3.pdf) | Mathematical induction, proving inequalities, well-ordering |
| [`Noter4.pdf`](material/discrete-maths/slides/Noter4.pdf) | Quantifiers — universal/existential, nested quantifiers |
| [`Noter5.pdf`](material/discrete-maths/slides/Noter5.pdf) | Relations — properties (reflexive/symmetric/transitive), equivalence, partial orders |
| [`Noter6.pdf`](material/discrete-maths/slides/Noter6.pdf) | Relation representations (matrices, graphs), equivalence classes |
| [`Noter7.pdf`](material/discrete-maths/slides/Noter7.pdf) | Equivalence relations, partitions of sets |
| [`Noter8.pdf`](material/discrete-maths/slides/Noter8.pdf) | Closures of relations — reflexive/symmetric/transitive closure |
| [`Noter9.pdf`](material/discrete-maths/slides/Noter9.pdf) | Relations on integers, modular congruence, integer equivalence classes |

---

## 3. Discrete Mathematics — exercise sets

Located in [`material/discrete-maths/exercises/`](material/discrete-maths/exercises/). Danish. (`opgaver` = "exercises".)

| File | Topic |
|---|---|
| [`opgaverDM01.pdf`](material/discrete-maths/exercises/opgaverDM01.pdf) | Propositional logic — propositions, operators, truth tables |
| [`opgaverDM02.pdf`](material/discrete-maths/exercises/opgaverDM02.pdf) | Logical equivalences & implication — tautologies, contradictions |
| [`opgaverDM03.pdf`](material/discrete-maths/exercises/opgaverDM03.pdf) | Predicate logic — quantifiers, negating quantified statements |
| [`opgaverDM04.pdf`](material/discrete-maths/exercises/opgaverDM04.pdf) | Proof methods (Rosen §1.7) |
| [`opgaverDM05.pdf`](material/discrete-maths/exercises/opgaverDM05.pdf) | Mathematical induction — basis & inductive step |
| [`opgaverDM06.pdf`](material/discrete-maths/exercises/opgaverDM06.pdf) | Induction continued — inequality proofs |
| [`opgaverDM07.pdf`](material/discrete-maths/exercises/opgaverDM07.pdf) | Relations I (Rosen §9.1, §9.3) |
| [`opgaverDM08.pdf`](material/discrete-maths/exercises/opgaverDM08.pdf) | Relations II — transitive closure, special relations (Rosen §9.4–9.5) |
| [`opgaverDM09.pdf`](material/discrete-maths/exercises/opgaverDM09.pdf) | Partial orders & equivalence relations — Hasse diagrams, equivalence classes |

---

## 4. Old exams — MCQ (current exam format)

Located in [`material/old-exam/mcq/`](material/old-exam/mcq/). Word documents, biennial. **These are the highest-value source** — the MCQ exam reuses recurring question types, and these are actual past questions to template.

| File | Year |
|---|---|
| [`juni2015.docx`](material/old-exam/mcq/juni2015.docx) | June 2015 |
| [`juni2017.docx`](material/old-exam/mcq/juni2017.docx) | June 2017 |
| [`juni2019.docx`](material/old-exam/mcq/juni2019.docx) | June 2019 |
| [`juni2021.docx`](material/old-exam/mcq/juni2021.docx) | June 2021 |
| [`juni2023.docx`](material/old-exam/mcq/juni2023.docx) | June 2023 |
| [`juni2025.docx`](material/old-exam/mcq/juni2025.docx) | June 2025 |

---

## 5. Old exams — discrete-math (with answer keys)

Located in [`material/discrete-maths/old-exam/`](material/discrete-maths/old-exam/). Excerpts ("Uddrag") from past discrete-math exams. Note the two files marked **Facit** are answer keys.

| File | Exam |
|---|---|
| [`Uddrag af eksamen i DM547 januar 2019.pdf`](material/discrete-maths/old-exam/Uddrag%20af%20eksamen%20i%20DM547%20januar%202019.pdf) | DM547 Jan 2019 |
| [`Uddrag af eksamen i DM547 januar 2019 (Facit).pdf`](material/discrete-maths/old-exam/Uddrag%20af%20eksamen%20i%20DM547%20januar%202019%20(Facit).pdf) | DM547 Jan 2019 — **answer key** |
| [`Uddrag af eksamen i DM547 januar 2021.pdf`](material/discrete-maths/old-exam/Uddrag%20af%20eksamen%20i%20DM547%20januar%202021.pdf) | DM547 Jan 2021 |
| [`Uddrag af reeksamen i DM547 marts 2019.pdf`](material/discrete-maths/old-exam/Uddrag%20af%20reeksamen%20i%20DM547%20marts%202019.pdf) | DM547 re-exam March 2019 |
| [`Uddrag af eksamen i SE4-DMAD juni 2024.pdf`](material/discrete-maths/old-exam/Uddrag%20af%20eksamen%20i%20SE4-DMAD%20juni%202024.pdf) | SE4-DMAD June 2024 |

---

## 6. Old exams — written (algorithms, older course codes)

Located in [`material/old-exam/oldexamwritten/`](material/old-exam/oldexamwritten/). Older *written* (non-MCQ) exams from predecessor courses DM02 / DM507. Useful for the algorithms half — the problems recur even though the format changed.

| File | Exam |
|---|---|
| [`dm02jan05.pdf`](material/old-exam/oldexamwritten/dm02jan05.pdf) | DM02 Jan 2005 |
| [`dm02jan06.pdf`](material/old-exam/oldexamwritten/dm02jan06.pdf) | DM02 Jan 2006 |
| [`dm507jan07.pdf`](material/old-exam/oldexamwritten/dm507jan07.pdf) | DM507 Jan 2007 |
| [`dm507jan08.pdf`](material/old-exam/oldexamwritten/dm507jan08.pdf) | DM507 Jan 2008 |
| [`dm507jun08.pdf`](material/old-exam/oldexamwritten/dm507jun08.pdf) | DM507 Jun 2008 |
| [`dm507jun09.pdf`](material/old-exam/oldexamwritten/dm507jun09.pdf) | DM507 Jun 2009 |
| [`dm507jun10.pdf`](material/old-exam/oldexamwritten/dm507jun10.pdf) | DM507 Jun 2010 |
| [`dm507jun11.pdf`](material/old-exam/oldexamwritten/dm507jun11.pdf) | DM507 Jun 2011 |
| [`dm507jun12.pdf`](material/old-exam/oldexamwritten/dm507jun12.pdf) | DM507 Jun 2012 |
| [`dm507jun13.pdf`](material/old-exam/oldexamwritten/dm507jun13.pdf) | DM507 Jun 2013 |
| [`dm507jun14.pdf`](material/old-exam/oldexamwritten/dm507jun14.pdf) | DM507 Jun 2014 |
| [`dm507jun15.pdf`](material/old-exam/oldexamwritten/dm507jun15.pdf) | DM507 Jun 2015 |
| [`jun16.pdf`](material/old-exam/oldexamwritten/jun16.pdf) | Jun 2016 |

---

## 7. Exam info & misc

| File | What it is |
|---|---|
| [`material/exam-info/SE4-DMAD_eksamensvejledning.pdf`](material/exam-info/SE4-DMAD_eksamensvejledning.pdf) | Official exam guide — rules, format, DE-Digital Eksamen + Observer walkthrough |
| [`material/noter/logaritmer.pdf`](material/noter/logaritmer.pdf) | Logarithm refresher — base-2 logs, log rules (product/quotient/power), used throughout algorithm analysis |

---

## Phase 2 — per-file deep-dive coverage

Goal: a detailed notes file for every document, listing **every topic it covers**, so no topic is missed. Tick each off here as written. Status: ⬜ not started · 🟨 in progress · ✅ done.

### Algorithms slides ✅ (all 23 written + verified → [`notes/slides/`](notes/slides/))
- ✅ [intro](notes/slides/intro.md) · ✅ [puzzle](notes/slides/puzzle.md) · ✅ [algorithm-analysis-intro](notes/slides/algorithm-analysis-intro.md) · ✅ [asymptotic-analysis](notes/slides/asymptotic-analysis.md) · ✅ [invariants](notes/slides/invariants.md) · ✅ [number-representation](notes/slides/number-representation.md)
- ✅ [max-subarray-sum](notes/slides/max-subarray-sum.md) · ✅ [sorting](notes/slides/sorting.md) · ✅ [sorting-linear-time](notes/slides/sorting-linear-time.md) · ✅ [divide-and-conquer-intro](notes/slides/divide-and-conquer-intro.md) · ✅ [divide-and-conquer](notes/slides/divide-and-conquer.md) · ✅ [strassen](notes/slides/strassen.md)
- ✅ [dynamic-programming-1](notes/slides/dynamic-programming-1.md) · ✅ [dynamic-programming-2](notes/slides/dynamic-programming-2.md) · ✅ [greedy](notes/slides/greedy.md) · ✅ [priority-queues](notes/slides/priority-queues.md) · ✅ [dictionaries](notes/slides/dictionaries.md) · ✅ [augmented-bst](notes/slides/augmented-bst.md) · ✅ [disjoint-sets](notes/slides/disjoint-sets.md)
- ✅ [graph-traversal](notes/slides/graph-traversal.md) · ✅ [connected-components](notes/slides/connected-components.md) · ✅ [mst](notes/slides/mst.md) · ✅ [shortest-paths](notes/slides/shortest-paths.md)

### Discrete-math notes ✅ (all 9 written + verified → [`notes/discrete-notes/`](notes/discrete-notes/))
- ✅ [noter1-logic](notes/discrete-notes/noter1-logic.md) · ✅ [noter2-proof-methods](notes/discrete-notes/noter2-proof-methods.md) · ✅ [noter3-induction](notes/discrete-notes/noter3-induction.md) · ✅ [noter4-quantifiers](notes/discrete-notes/noter4-quantifiers.md) · ✅ [noter5-relations](notes/discrete-notes/noter5-relations.md)
- ✅ [noter6-relation-representations](notes/discrete-notes/noter6-relation-representations.md) · ✅ [noter7-partitions](notes/discrete-notes/noter7-partitions.md) · ✅ [noter8-closures](notes/discrete-notes/noter8-closures.md) · ✅ [noter9-integer-relations](notes/discrete-notes/noter9-integer-relations.md)

### Discrete-math exercises ✅ (all 9 solved + Python-verified → [`notes/exercises/`](notes/exercises/))
- ✅ [opgaverDM01-prop-logic](notes/exercises/opgaverDM01-prop-logic.md) · ✅ [opgaverDM02-equivalences](notes/exercises/opgaverDM02-equivalences.md) · ✅ [opgaverDM03-predicate-logic](notes/exercises/opgaverDM03-predicate-logic.md) · ✅ [opgaverDM04-proof-methods](notes/exercises/opgaverDM04-proof-methods.md) · ✅ [opgaverDM05-induction](notes/exercises/opgaverDM05-induction.md)
- ✅ [opgaverDM06-induction-inequalities](notes/exercises/opgaverDM06-induction-inequalities.md) · ✅ [opgaverDM07-relations-1](notes/exercises/opgaverDM07-relations-1.md) · ✅ [opgaverDM08-relations-2](notes/exercises/opgaverDM08-relations-2.md) · ✅ [opgaverDM09-orders-equivalence](notes/exercises/opgaverDM09-orders-equivalence.md)

### Old exams — MCQ ✅ (all 6 transcribed from images + solved + Python-verified → [`notes/mcq/`](notes/mcq/))
- ✅ [juni2015](notes/mcq/juni2015.md) (29 Q) · ✅ [juni2017](notes/mcq/juni2017.md) (26 Q) · ✅ [juni2019](notes/mcq/juni2019.md) (30 Q) · ✅ [juni2021](notes/mcq/juni2021.md) (38 Q) · ✅ [juni2023](notes/mcq/juni2023.md) (36 Q) · ✅ [juni2025](notes/mcq/juni2025.md) (36 Q)

### Old exams — discrete-math ✅ (all 4 solved + verified → [`notes/dm-exams/`](notes/dm-exams/))
- ✅ [dm547-jan2019](notes/dm-exams/dm547-jan2019.md) (checked vs Facit) · ✅ [dm547-jan2021](notes/dm-exams/dm547-jan2021.md) · ✅ [dm547-reexam-mar2019](notes/dm-exams/dm547-reexam-mar2019.md) · ✅ [se4dmad-jun2024](notes/dm-exams/se4dmad-jun2024.md)

### Old exams — written ✅ (all 13 solved + Python-verified → [`notes/written-exams/`](notes/written-exams/))
- ✅ [dm02-jan2005](notes/written-exams/dm02-jan2005.md) · ✅ [dm02-jan2006](notes/written-exams/dm02-jan2006.md) · ✅ [dm507-jan2007](notes/written-exams/dm507-jan2007.md) · ✅ [dm507-jan2008](notes/written-exams/dm507-jan2008.md) · ✅ [dm507-jun2008](notes/written-exams/dm507-jun2008.md) · ✅ [dm507-jun2009](notes/written-exams/dm507-jun2009.md) · ✅ [dm507-jun2010](notes/written-exams/dm507-jun2010.md)
- ✅ [dm507-jun2011](notes/written-exams/dm507-jun2011.md) · ✅ [dm507-jun2012](notes/written-exams/dm507-jun2012.md) · ✅ [dm507-jun2013](notes/written-exams/dm507-jun2013.md) · ✅ [dm507-jun2014](notes/written-exams/dm507-jun2014.md) · ✅ [dm507-jun2015](notes/written-exams/dm507-jun2015.md) · ✅ [jun2016](notes/written-exams/jun2016.md)
