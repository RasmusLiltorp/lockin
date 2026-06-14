# Algorithms and Data Structures — Course Introduction

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/introSlides.pdf` (Rolf Fagerberg, Spring 2026).

This deck is the opening lecture. It introduces the course, explains how four overlapping courses (DM578, DM507, DS814, SE4-DMAD) share the same algorithms content, lays out format and exam rules, estimates workload, places the course in the wider picture of computer science, and lists the concrete topics that will be taught. No algorithms or proofs are presented yet — this is administrative and motivational, but the workload arithmetic and the topic list are worth knowing.

## Who teaches it and who takes it

Lecturer: Rolf Fagerberg, IMADA (Department of Mathematics and Computer Science). Research area: algorithms and data structures.

Participants come from many programmes at different points in their studies:
- BSc Computer Science (2nd sem.)
- BSc Artificial Intelligence (2nd sem.)
- BSc Software Engineering (4th sem.)
- BSc Mathematics-Economics (4th sem.)
- BSc Applied Mathematics (4th sem.)
- BSc Computer Science minor (6th sem.)
- MSc Data Science profile (2nd/8th sem.)

Point made on the slide: large diversity — different semesters, different amounts of prior programming and math.

## Three (four) courses in one

The same algorithms-and-data-structures lectures serve several course codes. They differ in what is bolted on and in the exam:

- **DM578**: Algorithms and data structures (7.5 ECTS). Written MC exam, 3 hours.
- **DM507 / DS814**: Algorithms and data structures (7.5 ECTS) + programming project in three parts (2.5 ECTS). Written MC exam, 3 hours.
- **SE4-DMAD**: Algorithms and data structures (7.5 ECTS) + discrete mathematics (2.5 ECTS). Written MC exam, **3 hours and 3 quarters** (i.e. 3 hours 45 minutes).

For SE4-DMAD the discrete math part has separate lectures (Lene Monrad Favrholdt) and exercise sessions, Fridays 10-12 over ten weeks. There is one ITS course room for DM507/DM578/DS814 and a separate one for SE4-DMAD.

## Course format

Common structure across all variants:
- **Prerequisites**: programming (Python or Java for DM578; Python for DM507/DS814; C# or Python for SE4-DMAD) plus "a little mathematical maturity".
- **Format**: lectures (f-timer) by Rolf Fagerberg (and Lene Monrad Favrholdt for SE4-DMAD), exercise sessions (e-timer) with an instructor, plus self-study and study groups.
- **Exam**: written exam in June, multiple-choice, **books and notes allowed but no programs and no internet**, graded on the Danish 7-point scale. Goal of the exam is to check knowledge of the material. The re-exam is **oral**.

Extra per variant:
- **DM507/DS814** add a project (2.5 ECTS, Python) in three parts, graded pass/fail (B/IB). The project does **not** have to be passed to sit the written exam. Its goal is to train transfer of the material into practice (programming).
- **SE4-DMAD**'s written exam counts as 10 ECTS overall (algorithms + discrete math).

## Materials

Textbook: Cormen, Leiserson, Rivest, Stein — *Introduction to Algorithms*, 4th edition, 2022 (CLRS). Reading and exercises will also be given against the 3rd edition.

On the course website: lecture slides, exercise problems, past exam sets, and the project.

## Expected workload

A per-occurrence breakdown of a typical study cycle (marked least/most important):
- Skim material before lecture: 0.5 h ⇐ least important
- Lecture: 2 h
- Read material after lecture: 1.5 h
- Exercises at home: 3 h ⇐ most important
- Exercises in class: 2 h ⇐ most important

That sums to 9 h per cycle. The cycle runs on average 1.5 times per week over 14 weeks. The slides then add one-off costs and compute totals.

**DM578**: \(14 \cdot 1.5 \cdot 9 + 40 + 3 = 232\) hours.
- Exam reading: 40 h, exam: 3 h.
- Reference: 7.5 ECTS = 1/8 year = 1650/8 = 206 h.

**DM507/DS814**: \(14 \cdot 1.5 \cdot 9 + 55 + 40 + 3 = 287\) hours.
- Project: 15 + 15 + 25 = 55 h, exam reading: 40 h, exam: 3 h.
- Reference: 10 ECTS = 1/6 year = 1650/6 = 275 h.

**SE4-DMAD**: \((14 \cdot 1.5 + 10 \cdot 0.5) \cdot 9 + 40 + 4 = 278\) hours.
- The cycle runs 1.5×/week over 14 weeks (Rolf) plus 0.5×/week over 10 weeks (Lene, discrete math).
- Exam reading: 40 h, exam: 4 h.
- Reference: 10 ECTS = 1/6 year = 1650/6 = 275 h.

The arithmetic: \((21 + 5)\cdot 9 = 234\), \(+40+4 = 278\). The ECTS figures all assume 1 full year of study = 1650 hours.

## The course's purpose and the big picture

General goal in IT: get a computer to perform a task. Related questions, each owned by different fields:
- **How are programs written?** — programming, programming languages, software engineering.
- **How should the program solve the task?** ⇐ this is DM507/DM578/... — algorithms and data structures, database systems, linear algebra with applications, data mining and machine learning.
- **(How well) is it even possible to solve the task?** — lower bounds, complexity, computability.
- **How does the machine running the task work?** — background in computer architecture and operating systems.

This course sits squarely on the second question.

## How should the program solve the task?

Two definitions stated on the slide:
- **Algorithm = method of solution.** Written down with appropriate precision: drawing, text, pseudo-code, etc.
- **Data structure = data + efficient operations on it.**

Three levels of "solving":
1. Invent one algorithm that solves the task.
2. Compare several algorithms that solve the task.
3. What is the best possible algorithm that solves the task?

## Developing and judging algorithms

Re-stated against the three levels:
1. **Invent an algorithm**: needs ideas, experience, and a toolbox of both existing algorithms and methods for building new ones.
2. **Compare algorithms**: needs a definition of quality (often quality = low time usage).
3. **Best possible algorithm**: the hardest level.

Two tools for these tasks:
- **Analysis** (thinking, arguments, proofs): good for levels 1, 2 and 3. Gives high confidence in correctness of the method/idea. Saves implementation work. The comparison it produces is unaffected by machine, language, programmer, and choice of test data.
- **Testing** (implementation, running tests): good for levels 1 and 2. Can explore ideas, catch implementation bugs, and shed light on things analysis does not capture.

Course emphasis: DM507/DM578/DS814/SE4-DMAD will focus most on **analysis**, somewhat less on implementation and testing. Analogy from the slide: in all building trades you analyze and plan before you build (e.g. the Great Belt Bridge).

## What about GenAI?

GenAI is a fast way to get code that might work. A university degree should equip you to judge the output of GenAI, which means you have to understand the principles yourself. Understanding comes from the brain working with the material, not the eyes. (In other words: reading GenAI output is not the same as learning.)

## Course objectives

- DM507 gives you a toolbox of algorithms for fundamental tasks, plus methods to develop and analyze new algorithms and variants of existing ones. (Slide shows a toolbox and a factory → tools image.)
- Exercises and programming projects increase your understanding of the tools and train you in using them.
- Along the way you may also get excited by smart and elegant ideas in algorithms and analyses.

## Concrete content of the course

**Algorithms:**
- Analysis of algorithms: correctness and running time (the analysis tool).
- Divide and conquer (algorithm-design method).
- Greedy algorithms (algorithm-design method).
- Dynamic programming (algorithm-design method).
- Concrete algorithms for sorting, graph problems (BFS, DFS, shortest paths, spanning trees, ...), file compression, matrix multiplication, ...

**Data structures:**
- Dictionaries (search trees and hashing).
- Priority queues (heaps).
- Disjoint sets.
