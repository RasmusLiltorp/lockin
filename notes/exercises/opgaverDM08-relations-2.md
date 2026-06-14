# Relations II — Closures, Equivalence Relations, Partitions (opgaverDM08)

Source: `material/discrete-maths/exercises/opgaverDM08.pdf` (uge 16; Rosen sections 9.4–9.5).

This set drills the three closures of a relation (reflexive, symmetric, transitive) and the algorithm-free way to compute them, then equivalence relations (ækvivalensrelationer): testing the three properties, finding equivalence classes (ækvivalensklasser), and recognising partitions (partitioner). Closures = smallest superset with the wanted property; equivalence classes = the blocks of the induced partition.

> Note on textbook references: the SDU sheet only cites "Afsnit 9.4: Opgave 1" and "Afsnit 9.5: Opgave 1, 2, 21, 22, 24" — the actual problem statements live in Rosen (*Discrete Mathematics and Its Applications*, 7th ed.), which is not in the repo. The statements below are the standard Rosen 7th-edition wordings for those exercise numbers. If your edition numbers differently, the **Method** in each entry still applies verbatim — only the **input relation** changes.

---

## Opgave 1 (Rosen 9.4 #1) — three closures of a relation

**Problem.** Let $R$ be the relation on $\{1,2,3,4\}$ with
$$R=\{(1,2),(2,3),(3,4),(2,1),(3,2),(4,3)\}.$$
Find the reflexive, symmetric, and transitive closures of $R$ (the sheet adds the transitive one and asks for the graph of $R$ and of each closure).

**Type.** Compute reflexive / symmetric / transitive closure (lukning) of a finite relation.

**Method (swap in your own $R$ and base set $A$).**
1. **Reflexive closure (refleksiv lukning):** $R \cup \Delta$ where $\Delta=\{(a,a)\mid a\in A\}$. Just add every missing loop.
2. **Symmetric closure (symmetrisk lukning):** $R \cup R^{-1}$ where $R^{-1}=\{(b,a)\mid (a,b)\in R\}$. Add the reverse of every edge.
3. **Transitive closure (transitiv lukning):** $R^* = R \cup R^2 \cup R^3 \cup \dots$. On an $n$-element set stop at $R^{[n]}=R\cup R^2\cup\dots\cup R^n$ (Rosen Thm: connectivity relation). Practically: keep adding $(a,c)$ whenever $(a,b)$ and $(b,c)$ are present, until nothing new appears. (Warshall's algorithm is the systematic version.)
4. Each closure is the **smallest** relation containing $R$ that has the property.

**Worked solution.** $A=\{1,2,3,4\}$.

*Reflexive closure* — add $(1,1),(2,2),(3,3),(4,4)$:
$$\{(1,1),(1,2),(2,1),(2,2),(2,3),(3,2),(3,3),(3,4),(4,3),(4,4)\}.$$

*Symmetric closure* — $R$ is already symmetric here (every edge already has its reverse: $(1,2)/(2,1)$, $(2,3)/(3,2)$, $(3,4)/(4,3)$), so
$$R^{\text{sym}}=R=\{(1,2),(2,1),(2,3),(3,2),(3,4),(4,3)\}.$$

*Transitive closure* — $R$ links $1\!-\!2\!-\!3\!-\!4$ in both directions, so every pair becomes reachable. Result is all of $A\times A$ (16 pairs):
$$R^{+}=\{(i,j)\mid i,j\in\{1,2,3,4\}\}.$$
(checked: Python — reflexive/symmetric/transitive closures all match.)

*Graphs (digrafer).* $R$: a path $1\leftrightarrow2\leftrightarrow3\leftrightarrow4$ (double arrows). Reflexive closure: same path plus a loop at each vertex. Symmetric closure: identical to $R$ (already symmetric). Transitive closure: the complete directed graph on 4 vertices with all loops (every vertex points to every vertex including itself).

---

## Opgave 2 — transitive closure of a given relation

**Problem.** Find the transitive closure of
$$R=\{(1,1),(2,3),(3,2),(3,4),(3,5),(5,1)\}.$$

**Type.** Transitive closure of a finite relation.

**Method.** Same step 3 as above: treat $R$ as a digraph and add $(a,c)$ for every directed path $a\to\dots\to c$ of length $\ge 1$. Equivalent: $a\,R^+\,b$ iff there is a path from $a$ to $b$. Easiest by hand: list, for each start vertex, every vertex you can reach following arrows.

**Worked solution.** Reachability per start vertex:
- From **1**: $1\to1$ (loop only). Reach: $\{1\}$.
- From **2**: $2\to3\to\{2,4,5\}$, and $3\to5\to1$. Reach: $\{1,2,3,4,5\}$.
- From **3**: $3\to\{2,4,5\}$, $2\to3$, $5\to1$. Reach: $\{1,2,3,4,5\}$.
- From **4**: no outgoing arrows. Reach: $\{\}$ (no new pairs).
- From **5**: $5\to1\to1$. Reach: $\{1\}$.

So
$$R^{+}=\{(1,1),\;(2,1),(2,2),(2,3),(2,4),(2,5),\;(3,1),(3,2),(3,3),(3,4),(3,5),\;(5,1)\}.$$
(12 pairs. (checked: Python — transitive closure computed by iterating to a fixpoint.))

---

## Opgave 3a (Rosen 9.5 #1) — which relations are equivalence relations

**Problem.** Which of these relations on $\{0,1,2,3\}$ are equivalence relations (ækvivalensrelationer)? For those that are not, say which property is missing.
- (a) $\{(0,0),(1,1),(2,2),(3,3)\}$
- (b) $\{(0,0),(0,2),(2,0),(2,2),(2,3),(3,2),(3,3)\}$
- (c) $\{(0,0),(1,1),(1,2),(2,1),(2,2),(3,3)\}$
- (d) $\{(0,0),(1,1),(1,3),(2,2),(2,3),(3,1),(3,2),(3,3)\}$
- (e) $\{(0,0),(0,1),(0,2),(1,0),(1,1),(1,2),(2,0),(2,2),(3,3)\}$

**Type.** Test the three equivalence-relation properties on a concrete relation.

**Method (swap in your own relation and base set $A$).**
1. **Reflexive (refleksiv):** check $(a,a)\in R$ for **every** $a\in A$. One missing loop kills it.
2. **Symmetric (symmetrisk):** for every $(a,b)\in R$ check $(b,a)\in R$. One missing reverse kills it.
3. **Transitive (transitiv):** for every pair $(a,b),(b,c)\in R$ check $(a,c)\in R$. One missing shortcut kills it.
4. Equivalence relation $\iff$ all three hold. If not, report exactly which of the three fail.

**Worked solution.**
- (a) refl ✓, sym ✓, trans ✓ (only the diagonal). **Equivalence relation.**
- (b) reflexive **fails** ($(1,1)$ missing); transitive **fails** ($(0,2),(2,3)\Rightarrow(0,3)$ missing). **Not** an equivalence relation (lacks reflexive and transitive).
- (c) refl ✓, sym ✓, trans ✓. **Equivalence relation.**
- (d) refl ✓, sym ✓, transitive **fails** ($(1,3),(3,2)\Rightarrow(1,2)$ missing). **Not** (lacks transitive).
- (e) refl ✓, symmetric **fails** ($(1,2)$ present, $(2,1)$ missing), transitive **fails**. **Not** (lacks symmetric and transitive).

So the equivalence relations are **(a) and (c)**. (checked: Python — properties and classes brute-forced over all pairs.)

---

## Opgave 3b (Rosen 9.5 #2) — which relations are equivalence relations

**Problem.** Which of these relations on $\{0,1,2,3\}$ are equivalence relations? Name the missing properties for the rest.
- (a) $\{(0,0),(1,1),(2,2),(3,3),(0,1),(0,2),(1,0),(2,0)\}$
- (b) $\{(0,0),(1,1),(1,2),(2,1),(2,2),(3,3)\}$
- (c) $\{(0,0),(0,1),(0,2),(1,0),(1,1),(1,2),(2,0),(2,1),(2,2),(3,3)\}$
- (d) $\{(0,0),(1,1),(1,3),(2,2),(2,3),(3,1),(3,2),(3,3)\}$
- (e) $\{(0,0),(0,1),(0,2),(0,3),(1,0),(1,1),(1,2),(1,3),(2,0),(2,2),(3,0),(3,3)\}$

**Type.** Same as 3a — test reflexive/symmetric/transitive.

**Method.** Identical recipe to Opgave 3a.

**Worked solution.**
- (a) refl ✓, sym ✓, transitive **fails** ($(1,0),(0,2)\Rightarrow(1,2)$ missing). **Not** (lacks transitive).
- (b) refl ✓, sym ✓, trans ✓. **Equivalence relation.**
- (c) refl ✓, sym ✓, trans ✓. **Equivalence relation.**
- (d) refl ✓, sym ✓, transitive **fails** ($(1,3),(3,2)\Rightarrow(1,2)$ missing). **Not** (lacks transitive).
- (e) refl ✓, symmetric **fails** ($(1,2)$ and $(1,3)$ present, reverses $(2,1),(3,1)$ missing), transitive **fails**. **Not** (lacks symmetric and transitive).

Equivalence relations: **(b) and (c)**. (checked: Python)

---

## Opgave 3c (Rosen 9.5 #21) — equivalence classes of the relations in #1

**Problem.** For the relations in Opgave 3a (Rosen #1) that are equivalence relations, list the equivalence classes (ækvivalensklasser).

**Type.** Compute equivalence classes from an equivalence relation.

**Method (swap in the equivalence relation $R$ on $A$).**
1. Only the ones that passed all three tests have classes (here: (a) and (c)).
2. The class of $a$ is $[a]=\{x\in A\mid (a,x)\in R\}$ — everything related to $a$.
3. Compute $[a]$ for one unused element at a time; classes partition $A$, so once an element is in some class skip it.

**Worked solution.**
- (a): every element relates only to itself $\Rightarrow$ classes $\{0\},\{1\},\{2\},\{3\}$ (four singletons).
- (c): $0$ alone; $1$ and $2$ related ($\{1,2\}$); $3$ alone $\Rightarrow$ classes $\{0\},\{1,2\},\{3\}$. (checked: Python)

---

## Opgave 3d (Rosen 9.5 #22) — equivalence classes of the relations in #2

**Problem.** For the relations in Opgave 3b (Rosen #2) that are equivalence relations, list the equivalence classes.

**Type.** Compute equivalence classes.

**Method.** Same recipe as 3c: take the ones that passed (here (b) and (c)), compute $[a]=\{x\mid (a,x)\in R\}$.

**Worked solution.**
- (b): classes $\{0\},\{1,2\},\{3\}$.
- (c): $0,1,2$ all mutually related $\Rightarrow \{0,1,2\}$; $3$ alone $\Rightarrow \{3\}$. Classes: $\{0,1,2\},\{3\}$. (checked: Python)

---

## Opgave 3e (Rosen 9.5 #24) — which collections partition the integers

**Problem.** Which of these collections of subsets are partitions (partitioner) of $\mathbb{Z}$?
- (a) the even integers and the odd integers
- (b) the positive integers and the negative integers
- (c) integers divisible by 3, integers $\equiv 1 \pmod 3$, integers $\equiv 2\pmod 3$
- (d) integers $<-100$, integers with $|n|\le 100$, integers $>100$
- (e) integers not divisible by 3, the even integers, integers $\equiv 3\pmod 6$

**Type.** Recognise a partition of a set.

**Method (swap in your own collection of subsets of a universe $U$).** A collection $\{A_i\}$ is a partition of $U$ iff:
1. **No empty block:** every $A_i\neq\varnothing$.
2. **Cover:** $\bigcup_i A_i = U$ — every element of $U$ lies in at least one block.
3. **Disjoint:** $A_i\cap A_j=\varnothing$ for $i\neq j$ — no element in two blocks.
Quick test: each $x\in U$ must land in **exactly one** block. One uncovered element breaks (2); one shared element breaks (3).

**Worked solution.**
- (a) **Partition.** Every integer is even or odd, never both.
- (b) **Not.** $0$ is neither positive nor negative — fails cover.
- (c) **Partition.** Residues $0,1,2$ mod 3 are exactly the three blocks; every integer hits one.
- (d) **Partition.** $|n|\le100$ covers $-100\dots100$; $<-100$ covers $\le-101$; $>100$ covers $\ge101$. No gaps, no overlap.
- (e) **Not.** Blocks overlap: e.g. $2$ is even **and** not divisible by 3, so it sits in two blocks — fails disjoint. Cover actually holds: every integer is in at least one block (any multiple of 3 is even, or else $\equiv3\pmod6$, and everything else is not divisible by 3). So $\mathbb{Z}$ is covered but the blocks aren't disjoint. (checked: Python — 0 uncovered integers, but many shared.)

Partitions: **(a), (c), (d)**. (checked: Python)
