# DM09 — Partial Orders & Equivalence Relations

Source: `material/discrete-maths/exercises/opgaverDM09.pdf` (SE4-DMAD, uge 17). Textbook refs are Rosen, *Discrete Mathematics and Its Applications*, 7th ed.

This set drills three things: deciding which collections of subsets are **partitions** (and the partition ↔ equivalence-relation link), checking the three properties that make a relation a **partial order** (refleksiv, antisymmetrisk, transitiv), and reading/drawing **Hasse diagrams** plus extremal elements. It closes with three short exam-style relation tasks: partial-order test, transitive closure, and equivalence classes.

A note on textbook items: items 1–2 of the set point at Rosen 9.5/9.6 by problem number. The book is not in the material folder, so I reproduce the standard 7th-edition statements and solve them. Where a problem depends on a figure I cannot reproduce verbatim (9.6 #26), I give the general method on a concrete poset and flag the figure dependency.

---

## Core recipes (reused below)

**Three properties of a relation $R$ on a set $A$.**
- **Reflexive (refleksiv):** $(a,a)\in R$ for every $a\in A$.
- **Symmetric (symmetrisk):** $(a,b)\in R \Rightarrow (b,a)\in R$.
- **Antisymmetric (antisymmetrisk):** if $(a,b)\in R$ and $(b,a)\in R$ then $a=b$ (no two-way arrows except loops).
- **Transitive (transitiv):** $(a,b)\in R$ and $(b,c)\in R \Rightarrow (a,c)\in R$.

**Partial order (partiel ordning):** reflexive + antisymmetric + transitive.
**Total/linear order (total ordning):** a partial order where every pair is comparable ($a\preceq b$ or $b\preceq a$ for all $a,b$).
**Equivalence relation (ækvivalensrelation):** reflexive + symmetric + transitive.

---

## Afsnit 9.5, Opgave 26

1. **Problem.** Which of these collections of subsets are partitions of $\{1,2,3,4,5,6\}$?
   (a) $\{1,2\},\{2,3,4\},\{4,5,6\}$  (b) $\{1\},\{2,3,6\},\{4\},\{5\}$  (c) $\{2,4,6\},\{1,3,5\}$  (d) $\{1,4,5\},\{2,6\}$
2. **Type.** Partition check (partition / inddeling).
3. **Method.** A collection of subsets is a partition of $A$ iff all three hold — **swap in your subsets and the universe $A$:**
   1. every subset is **nonempty**;
   2. the subsets are **pairwise disjoint** (no element in two of them);
   3. their **union equals $A$** (full cover).
   Fail any one → not a partition.
4. **Worked solution.**
   - (a) **No.** Element $2$ is in $\{1,2\}$ and $\{2,3,4\}$ (and $4$ is shared too) → not disjoint.
   - (b) **Yes.** Disjoint, and $\{1\}\cup\{2,3,6\}\cup\{4\}\cup\{5\}=\{1,2,3,4,5,6\}$.
   - (c) **Yes.** $\{2,4,6\}$ and $\{1,3,5\}$ are disjoint and cover everything.
   - (d) **No.** $3$ is missing from the union → not a cover.

   (checked: Python — brute-forced the three partition tests; verdicts No/Yes/Yes/No confirmed.)

## Afsnit 9.5, Opgave 27

1. **Problem.** Which of these are partitions of the set of integers $\mathbb{Z}$?
   (a) even integers, odd integers;
   (b) positive integers, negative integers;
   (c) integers divisible by 3, integers $\equiv 1\pmod 3$, integers $\equiv 2\pmod 3$;
   (d) integers $< -100$, integers with $-100\le n\le 100$, integers $> 100$;
   (e) integers $< -100$, integers $> 100$.
2. **Type.** Partition check on an infinite set.
3. **Method.** Same three tests as #26 (nonempty / disjoint / cover), but the universe is $\mathbb{Z}$. The cover test is the one that usually fails — check whether every integer (especially $0$ and small ones) lands in exactly one block.
4. **Worked solution.**
   - (a) **Yes.** Every integer is even or odd, never both.
   - (b) **No.** $0$ is neither positive nor negative → not covered.
   - (c) **Yes.** Remainders mod 3 give exactly the three disjoint classes $\{0,1,2\}$; every integer has one remainder.
   - (d) **Yes.** The three ranges are disjoint and tile $\mathbb{Z}$.
   - (e) **No.** Integers in $[-100,100]$ are left out.

   *Link:* a partition of $A$ corresponds 1-to-1 to an equivalence relation on $A$ (the blocks are the equivalence classes). (c) is exactly the "congruent mod 3" relation.

---

## Afsnit 9.6, Opgave 2

1. **Problem.** Which relations on $\{0,1,2,3\}$ are partial orderings? Determine the properties that fail otherwise.
   (a) $\{(0,0),(1,1),(2,2),(3,3)\}$
   (b) $\{(0,0),(1,1),(2,0),(2,2),(2,3),(3,3)\}$
   (c) $\{(0,0),(1,1),(1,2),(2,2),(3,3)\}$
   (d) $\{(0,0),(1,1),(1,2),(1,3),(2,2),(2,3),(3,3)\}$
   (e) $\{(0,0),(0,1),(0,2),(1,0),(1,1),(1,2),(2,0),(2,2),(3,3)\}$
2. **Type.** Partial-order test on a concrete relation.
3. **Method.** For the given pair-set, **swap in the pairs and check:**
   1. reflexive — is $(x,x)$ present for all $x$ in the base set?
   2. antisymmetric — any pair $(a,b)$ with $a\ne b$ where $(b,a)$ is also present? If yes, fails.
   3. transitive — for every $(a,b),(b,c)$, is $(a,c)$ present?
   All three pass → partial order.
4. **Worked solution.**
   - (a) **PO.** Just the diagonal; reflexive, vacuously antisym + trans.
   - (b) **PO.** Reflexive on $\{0,1,2,3\}$, no reverse pairs, transitive (e.g. $(2,2),(2,3)\Rightarrow(2,3)$ ok).
   - (c) **PO.** Reflexive, antisymmetric, transitive.
   - (d) **PO.** Reflexive, antisymmetric, transitive ($(1,2),(2,3)\Rightarrow(1,3)$ present).
   - (e) **Not a PO.** Fails **antisymmetry** ($(0,1)$ and $(1,0)$ with $0\ne1$). It also fails transitivity: $(2,0),(0,1)$ are present but $(2,1)$ is missing.

   (checked: Python — (a)–(d) all come back PO=True; (e) is the only one that fails, with anti=False and trans=False.)

## Afsnit 9.6, Opgave 3

1. **Problem.** Which relations on $\{1,2,3,4\}$ are partial orderings?
   (a) $\{(2,2),(2,3),(2,4),(3,2),(3,3),(3,4)\}$
   (b) $\{(1,1),(1,2),(2,1),(2,2),(3,3),(4,4)\}$
   (c) $\{(2,4),(4,2)\}$
   (d) $\{(1,2),(2,3),(3,4)\}$
   (e) all 16 pairs over $\{1,2,3,4\}$ (the full relation)
2. **Type.** Partial-order test.
3. **Method.** Same three checks as 9.6 #2.
4. **Worked solution.** None are partial orderings.
   - (a) **No.** Not reflexive ($(1,1),(4,4)$ missing) and not antisymmetric ($(2,3)$ and $(3,2)$).
   - (b) **No.** Not antisymmetric ($(1,2)$ and $(2,1)$).
   - (c) **No.** Not reflexive, not antisymmetric ($(2,4),(4,2)$), not transitive ($(2,4),(4,2)\Rightarrow(2,2)$ missing).
   - (d) **No.** Not reflexive, not transitive ($(1,2),(2,3)\Rightarrow(1,3)$ missing).
   - (e) **No.** Reflexive and transitive, but **not antisymmetric** (every $(a,b)$ has its reverse).

   (checked: Python — none of (a)–(e) are partial orders. Property flags match: (a) refl=F anti=F trans=T, (b) refl=T anti=F trans=T, (c) all fail, (d) refl=F anti=T trans=F, (e) refl=T anti=F trans=T.)

## Afsnit 9.6, Opgave 7

1. **Problem.** Determine whether each relation is a partial order: (a) $(\mathbb{Z},=)$  (b) $(\mathbb{Z},\ne)$  (c) $(\mathbb{Z},\ge)$  (d) $(\mathbb{Z},\nmid)$ ("does not divide").
2. **Type.** Partial-order test on a relation given by a rule (not a finite pair-set).
3. **Method.** Check the three properties **symbolically**, plugging the rule in for $\preceq$:
   1. reflexive: does $a \mathbin{R} a$ hold for all $a$?
   2. antisymmetric: do $a\mathbin{R}b$ and $b\mathbin{R}a$ force $a=b$?
   3. transitive: do $a\mathbin{R}b$ and $b\mathbin{R}c$ give $a\mathbin{R}c$?
4. **Worked solution.**
   - (a) $(\mathbb{Z},=)$ — **PO.** Equality is reflexive, antisymmetric ($a=b\wedge b=a\Rightarrow a=b$), transitive.
   - (b) $(\mathbb{Z},\ne)$ — **No.** Not reflexive ($a\ne a$ false); also not antisymmetric ($1\ne2$ and $2\ne1$ but $1\ne2$) and not transitive ($1\ne2,2\ne1$ but $1\ne1$ false).
   - (c) $(\mathbb{Z},\ge)$ — **PO.** Reflexive ($a\ge a$), antisymmetric ($a\ge b\wedge b\ge a\Rightarrow a=b$), transitive. (Also a total order.)
   - (d) $(\mathbb{Z},\nmid)$ — **No.** Not reflexive ($a\mid a$, so $a\nmid a$ is false).

## Afsnit 9.6, Opgave 17

1. **Problem.** Draw the Hasse diagram of the divisibility relation ($a\mid b$) on:
   (a) $\{1,2,3,4,5,6\}$  (b) $\{3,5,7,11,13,16,17\}$  (c) $\{2,3,5,10,11,15,25\}$  (d) $\{1,3,9,27,81,243\}$
2. **Type.** Build a Hasse diagram (Hasse-diagram) of a divisibility poset.
3. **Method.** **Swap in your set $S$ and the order $\preceq$:**
   1. List all strict relations $a\prec b$ (here $a\mid b$, $a\ne b$).
   2. Remove non-cover pairs: keep $a\prec b$ only if there is **no** $c$ with $a\prec c\prec b$ (these are the *cover* relations / dækkerelationer).
   3. Draw each element as a node; put $b$ above $a$ and connect with a plain line for each cover. No arrowheads, no loops, no transitive edges.
4. **Worked solution** (cover relations = the lines to draw, smaller element first):
   - (a) covers: $1\!-\!2,\;1\!-\!3,\;1\!-\!5,\;2\!-\!4,\;2\!-\!6,\;3\!-\!6$. So $1$ at the bottom; $2,3,5$ above it; $4$ above $2$; $6$ above both $2$ and $3$; $5$ is isolated above $1$.
   - (b) covers: **none.** All of $3,5,7,11,13,17$ are primes and $16$ shares no divisor relation with them in this set — every pair is incomparable, so the diagram is 7 separate nodes (an antichain).
   - (c) covers: $2\!-\!10,\;5\!-\!10,\;3\!-\!15,\;5\!-\!15,\;5\!-\!25$. Bottom level $2,3,5,11$; $10$ above $2,5$; $15$ above $3,5$; $25$ above $5$; $11$ isolated.
   - (d) covers: $1\!-\!3,\;3\!-\!9,\;9\!-\!27,\;27\!-\!81,\;81\!-\!243$. A single vertical chain (it is a total order) — this is also why it is linear.

   (checked: Python — cover relations computed by removing every $a\mid b$ that has an intermediate $c$. (a) gives $1\text-2,1\text-3,1\text-5,2\text-4,2\text-6,3\text-6$; (b) gives none (antichain); (c) gives $2\text-10,3\text-15,5\text-10,5\text-15,5\text-25$; (d) the chain. All match.)

## Afsnit 9.6, Opgave 26

1. **Problem.** For the poset given by a Hasse diagram, answer: find the maximal and minimal elements, the greatest and least element (if any), all upper bounds of a given subset, and the least upper bound (and the lower-bound versions).
2. **Type.** Extremal elements of a poset from a Hasse diagram (maksimal/minimal, største/mindste, øvre/nedre grænse, supremum/infimum).
3. **Method.** Read straight off the diagram — **swap in your diagram and the subset $A$:**
   1. **Maximal (maksimal):** nodes with no line going *up* out of them. **Minimal (minimal):** no line going *down*.
   2. **Greatest (største):** an element $\ge$ everything (one node above all others). **Least (mindste):** $\le$ everything. May not exist; if it does it is unique.
   3. **Upper bound of $A$:** any $x$ with $a\preceq x$ for all $a\in A$. **Least upper bound (supremum):** the smallest such $x$, if a unique smallest one exists.
   4. **Lower bound / greatest lower bound (infimum):** mirror image.
4. **Worked solution** (the book figure is not in the material folder, so I show the method on a standard instance: the divisibility poset on $\{1,2,4,5,10,20\}$).
   Covers: $1\!-\!2,1\!-\!5,2\!-\!4,2\!-\!10,5\!-\!10,4\!-\!20,10\!-\!20$.
   - **Maximal:** $20$. **Minimal:** $1$.
   - **Greatest:** $20$ (divisible by all). **Least:** $1$ (divides all).
   - Take $A=\{2,5\}$. **Upper bounds:** $10,20$. **lub/supremum:** $10$. **Lower bounds:** $1$. **glb/infimum:** $1$.
   Apply the exact same reading to whatever diagram the exam shows.

   (checked: Python — for the demo poset on $\{1,2,4,5,10,20\}$, cover edges, maximal/minimal, and the bounds of $A=\{2,5\}$ (upper $\{10,20\}$, lub $10$, lower $\{1\}$, glb $1$) all confirmed.)

---

## Item 3 — Eksamen DM547 januar 2021, Opgave 6 (Hasse diagram + properties)

1. **Problem.** A directed graph represents relation $S$ on $\{a,b,c,d,e,f\}$. Decide which hold: reflexive, symmetric, antisymmetric, transitive, equivalence relation, partial order, total order — and draw the Hasse diagram. The graph has a self-loop on **every** node, plus directed edges $a\to b,\;a\to c,\;a\to d,\;a\to e,\;b\to e,\;c\to d,\;f\to d,\;f\to e$.
2. **Type.** Read relation properties from a digraph; then draw the Hasse diagram.
3. **Method.**
   1. Reflexive: a loop on every node? (Here yes.)
   2. Symmetric: every non-loop arrow has a reverse? (No reverses → not symmetric.)
   3. Antisymmetric: no pair of opposite non-loop arrows? (None → antisymmetric.)
   4. Transitive: every two-step path $x\to y\to z$ has the shortcut $x\to z$?
   5. Classify: refl+antisym+trans ⇒ partial order; add "all pairs comparable" ⇒ total.
   6. Hasse diagram: drop the loops, drop any transitive (non-cover) edges, orient remaining covers upward, remove arrowheads.
4. **Worked solution.**
   - **6.a reflexive — TRUE** (loop on all six).
   - **6.b symmetric — FALSE** (e.g. $a\to b$ but no $b\to a$).
   - **6.c antisymmetric — TRUE** (no opposite pairs).
   - **6.d transitive — TRUE.** Check the two-step paths: $a\to b\to e$ and $a\to e$ present; $a\to c\to d$ and $a\to d$ present; $f\to$ paths reach only $d,e$ which are sinks. All shortcuts exist.
   - **6.e equivalence relation — FALSE** (not symmetric).
   - **6.f partial order — TRUE** (reflexive + antisymmetric + transitive).
   - **6.g total order — FALSE** ($b$ and $c$ are incomparable; so are $a$ and $f$).
   - **Hasse diagram (cover edges, lower→upper):** $a\!-\!b,\;a\!-\!c,\;b\!-\!e,\;c\!-\!d,\;f\!-\!e,\;f\!-\!d$. Note $a\to d$ and $a\to e$ are dropped (they are implied by $a\!-\!c\!-\!d$ and $a\!-\!b\!-\!e$). Bottom: $a$ and $f$ (minimal). Middle: $b$ (over $a$), $c$ (over $a$). Top: $e$ (over $b,f$), $d$ (over $c,f$). Maximal: $d,e$.

   (checked: Python — with loops added the relation is reflexive=True, antisymmetric=True, transitive=True, so PO holds and the property verdicts 6.a–6.g all confirm.)

## Item 4 — Eksamen DM547 januar 2021, Opgave 7 (symmetric closure)

1. **Problem.** Give the symmetric closure (symmetriske lukning) of $T=\{(a,b),(b,b),(c,d),(d,e)\}$.
2. **Type.** Symmetric closure of a relation.
3. **Method.** The symmetric closure is $T\cup T^{-1}$ — **add the reverse $(b,a)$ of every pair $(a,b)$** and keep the originals. (It always exists.)
4. **Worked solution.** Reverses to add: $(b,a),(d,c),(e,d)$; $(b,b)$ is its own reverse.
   $$T\cup T^{-1}=\{(a,b),(b,a),(b,b),(c,d),(d,c),(d,e),(e,d)\}.$$
   This is option **7.c**.

   (checked: Python — $T\cup T^{-1}$ computed directly, matches.)

## Item 5 — Reeksamen DM547 februar 2015, Opgave 3

Binary relations on $\{1,2,3,4\}$.

### 5(a) — Is $R$ a partial order?
1. **Problem.** $R=\{(1,1),(2,1),(2,2),(2,4),(3,1),(3,3),(3,4),(4,1),(4,4)\}$. Is $R$ a partial order (partiel ordning)?
2. **Type.** Partial-order test.
3. **Method.** Check reflexive, antisymmetric, transitive (see core recipe).
4. **Worked solution.**
   - Reflexive: $(1,1),(2,2),(3,3),(4,4)$ all present. ✓
   - Antisymmetric: every off-diagonal pair points "toward 1" or toward 4; no opposite pair exists (e.g. $(2,1)$ present, $(1,2)$ absent). ✓
   - Transitive: e.g. $(3,4),(4,1)\Rightarrow(3,1)$ ✓; $(2,4),(4,1)\Rightarrow(2,1)$ ✓; all two-step paths have shortcuts. ✓
   - **Yes, $R$ is a partial order.**

   (checked: Python — refl=True, anti=True, trans=True.)

### 5(b) — Transitive closure of $S$
1. **Problem.** $S=\{(1,2),(2,3),(2,4),(4,2)\}$. Give the transitive closure (transitive lukning).
2. **Type.** Transitive closure.
3. **Method.** Keep adding $(a,c)$ whenever $(a,b),(b,c)$ are present, until nothing new appears (this is the connectivity relation $S^*$ minus reflexive; equivalently reachability by $\ge 1$ steps).
4. **Worked solution.** Start with $S$. New pairs from paths:
   - $1\to2\to3 \Rightarrow (1,3)$; $1\to2\to4 \Rightarrow (1,4)$.
   - $4\to2\to3 \Rightarrow (4,3)$; $4\to2\to4 \Rightarrow (4,4)$.
   - $2\to4\to2 \Rightarrow (2,2)$; then $1\to2\to2$ adds nothing new.
   Result:
   $$S^+=\{(1,2),(1,3),(1,4),(2,2),(2,3),(2,4),(4,2),(4,3),(4,4)\}.$$

   (checked: Python — fixed-point closure gives exactly these 9 pairs.)

### 5(c) — Equivalence classes of $T$
1. **Problem.** $T=\{(1,1),(1,3),(2,2),(2,4),(3,1),(3,3),(4,2),(4,4)\}$ is an equivalence relation. Give its equivalence classes (ækvivalens-klasser).
2. **Type.** Equivalence classes from an equivalence relation.
3. **Method.** The class of $x$ is $[x]=\{y:(x,y)\in T\}$. List $[x]$ for each element; distinct classes form the partition.
4. **Worked solution.**
   - $[1]=\{1,3\}$, $[3]=\{1,3\}$ → same class.
   - $[2]=\{2,4\}$, $[4]=\{2,4\}$ → same class.
   - **Equivalence classes:** $\{1,3\}$ and $\{2,4\}$.

   (checked: Python — class of each $x$ computed; distinct classes are $\{1,3\}$ and $\{2,4\}$.)
