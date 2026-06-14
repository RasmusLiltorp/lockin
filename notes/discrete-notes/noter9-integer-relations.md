# Equivalence Classes and Partial Orders (Ækvivalensklasser og partielle ordninger)

Source: `material/discrete-maths/slides/Noter9.pdf` (handwritten)

This set finishes equivalence relations and starts partial orders (partielle ordninger). It covers equivalence classes on the integers/naturals, the theorem linking equivalence relations to partitions (Sætning 9.5.2), the definition of a partial order, Hasse diagrams, comparability, total orders, and lexicographic ordering.

## Recap: equivalence relation (ækvivalensrelation)

A relation is an equivalence relation if it is **reflexive (refleksiv)**, **symmetric (symmetrisk)**, and **transitive (transitiv)** — all three.

Quick check examples from the slide:
- $=$ and "same parity" (samme paritet) are equivalence relations (check mark).
- $\le$ and $\ne$ are NOT (cross mark).

If $(a,b)\in R$, then $a$ and $b$ are called **equivalent (ækvivalente)**.

### Equivalence class (ækvivalensklasse)

$$[a]_R = \{\, b \mid a \text{ and } b \text{ are equivalent} \,\}$$

This set is called $a$'s equivalence class. $a$ is a representative of it.

## Worked examples of equivalence classes

### Example: same parity on $\mathbb{N}$
$R = \{(a,b) \mid a \text{ and } b \text{ have the same parity (samme paritet)}\}$

- $[0]_R = \{0,2,4,6,\dots\} = [2]_R = [4]_R = \dots$ (the even numbers)
- $[1]_R = \{1,3,5,7,\dots\} = [3]_R = [5]_R = \dots$ (the odd numbers)

So $\mathbb{N}$ splits into exactly 2 classes (evens / odds). Diagram: a circle split into two halves, $\{0,2,4,\dots\}$ on one side, $\{1,3,5,\dots\}$ on the other.

### Example: congruence mod 3 on $\mathbb{N}$
$R = \{(a,b) \mid a \bmod 3 = b \bmod 3\}$

- $[0]_R = \{0,3,6,9,\dots\} = [3]_R = [6]_R = \dots$
- $[1]_R = \{1,4,7,10,\dots\} = [4]_R = [7]_R = \dots$
- $[2]_R = \{2,5,8,11,\dots\} = [5]_R = [8]_R = \dots$

3 classes, one per remainder. Diagram: a circle split into 3 wedges.

### Example: equality on $\mathbb{N}$
$R = \{(a,b) \mid a = b\}$

- $[0]_R = \{0\}$, $[1]_R = \{1\}$, $[2]_R = \{2\}$, $\dots$

Each element is its own class. Infinitely many singleton classes. This is the finest possible equivalence relation.

## Sætning 9.5.2 — equivalence relations vs. partitions

For any set $A$:

1. For every equivalence relation $R$ on $A$, the equivalence classes of $A$ form a **partition (partitionering)** of $A$ — a disjoint splitting (disjunkt opdeling).
2. For every partition $P$ of $A$, there exists an equivalence relation $R$ on $A$ such that the sets in $P$ are exactly $R$'s equivalence classes.

The two directions are inverses: equivalence relations and partitions are the same thing.

### Proof of (1)

Two things to show: the classes are disjoint, and together they cover all of $A$.

**The classes are disjoint (disjunkt).** Either $[a]$ and $[b]$ are completely separate, or $[a]=[b]$ — nothing in between. Proof by contradiction (modstrid): assume $[a]$ and $[b]$ are different but NOT disjoint, so they share some elements (picture two overlapping circles with $x,y$ in the overlap).

First, all elements of one class are equivalent to each other. Take $x \in [a]$ and $y \in [a]$. By Def. 9.5.3 (definition of equivalence class) this gives $xRa \land aRy$. Using $R$ symmetric on the first, then $R$ transitive, we get $xRy$.

Now use that with the overlap. We have $xRy$ (just derived) and $y \in [b]$. Then $xRy \land yRb$, and by $R$ transitive $xRb$, and by $R$ symmetric $x \in [b]$. So any $x$ in $[a]$ is also in $[b]$ — contradiction with the assumption that they were different. Hence different classes must be disjoint.

**The classes cover all of $A$.** For every $a \in A$ we have $a \in [a]$, because $R$ is reflexive ($aRa$). So no element is left out.

Together: disjoint + covering = a partition. $\blacksquare$

### Proof of (2)

Let $P$ be a partition of $A$. Define
$$R = \{(a,b) \mid a \text{ and } b \text{ belong to the same set (samme mængde) in } P\}.$$

Show $R$ is an equivalence relation:

- **Reflexive (refleksiv):** any $a \in A$ belongs to the same set as itself.
- **Symmetric (symmetrisk):** for any pair $b,c \in A$, if $b$ is in the same set as $c$, then $c$ is in the same set as $b$.
- **Transitive (transitiv):** for all $d,e,f \in A$, if $d$ is in the same set as $e$, and $e$ in the same set as $f$, then $d$ is in the same set as $f$.

So $R$ is an equivalence relation, and its classes are exactly the blocks of $P$. $\blacksquare$

## Partial orders (Partielle ordninger) — afsnit 9.6

### Def. 9.6.1 — partial order
If a relation $R$ on a set $A$ is **reflexive (refleksiv)**, **antisymmetric (antisymmetrisk)**, and **transitive (transitiv)**, it is called a **partial order (partiel ordning)**.

The pair $(A,R)$ is called a **partially ordered set / poset (partielt ordnet mængde)**.

(Contrast with equivalence relation: same reflexive + transitive, but swap *symmetric* for *antisymmetric*.)

Examples:
- Partial orders (check): $\le$, $=$, $\mid$ (divides), $\subseteq$.
- NOT partial orders (cross), with the failing property noted:
  - $<$ fails reflexivity (ikke refleksiv).
  - $\ne$ fails transitivity (ikke transitiv).
  - $\subset$ (strict) fails reflexivity (ikke refleksiv).
  - "same parity" (samme paritet) fails antisymmetry (ikke antisymmetrisk).

### Example: divisibility on $\{1,2,3,4,5,6\}$
$R = \{(a,b) \mid a \mid b\}$ ("a divides b") on $\{1,2,3,4,5,6\}$.

Drawn as a directed graph: every node has a self-loop (red loops = consequences of **reflexivity**), and there are arrows like $1\to$ everything, $2\to 6$, $3\to 6$ (blue arrows = consequences of **transitivity**). $1$ divides all; $2$ divides $4$ and $6$; $3$ divides $6$.

## Hasse diagram (Hasse-diagram)

Same as the relation graph, but cleaned up:
- **Leave out edges** that follow from reflexivity and transitivity (omit self-loops and any edge implied by a chain).
- **Draw $a$ below $b$ when $aRb$** (smaller element underneath).

Hasse diagram for divisibility on $\{1,2,3,4,5,6\}$:
- $1$ at the bottom.
- $2$, $3$, $5$ above $1$ (all divisible by 1; 5 sits over 1 only).
- $4$ above $2$; $6$ above both $2$ and $3$.

```
   6     4
  / \    |
 3   2   5
      \ /
       1     (1 also connects up to 3, 5)
```
Reading: $1\mid2$, $1\mid3$, $1\mid5$, $2\mid4$, $2\mid6$, $3\mid6$. The edge $1\mid6$ is omitted because it follows by transitivity through $2$ or $3$.

### Def. 9.6.2 — comparable (sammenlignelige)
Let $\preceq$ be a partial order. If $a \preceq b$ **or** $b \preceq a$, then $a$ and $b$ are called **comparable (sammenlignelige)**.

(If neither holds, they are incomparable — e.g. $2$ and $3$ under divisibility.)

### Def. 9.6.3 — total order (total ordning)
Let $(A,\preceq)$ be a poset. If **all** pairs $a,b \in A$ are comparable, then $\preceq$ is called a **total order (total ordning)**.

Examples:
- Total order (check): $\le$.
- NOT total (cross): $=$, $\mid$, $\subseteq$, $<$. (These are partial but leave some pairs incomparable; note $<$ also isn't even a partial order because it isn't reflexive.)

### Example: $\le$ on $\{1,2,3,4,5\}$
$R = \{(a,b) \mid a \le b\}$ on $\{1,2,3,4,5\}$ is a total order. Its Hasse diagram is a single vertical chain:
```
5
|
4
|
3
|
2
|
1
```

## Lexicographic ordering (Leksikografisk ordning)

Build an order on pairs (or tuples) from two partial orders $\preceq_1$ and $\preceq_2$.

Strict versions:
- $a \prec_1 b$ means $a \preceq_1 b \land a \ne b$.
- $a \prec_2 b$ means $a \preceq_2 b \land a \ne b$.

Definition for pairs:
$$(a_1,a_2) \prec (b_1,b_2) \quad\text{if}\quad a_1 \prec_1 b_1 \ \text{ or } \ (a_1 = b_1 \text{ and } a_2 \prec_2 b_2).$$

Compare the first component first; only break ties with the second.

Examples:
- Coordinate pairs (Koordinat-sæt): $(1,4) \prec (2,3)$ because $1 < 2$ (first component decides). $(1,2) \prec (1,3)$ because the first components tie at $1$ and $2 < 3$.
- Dictionary (Ordbog): `abe < bil` (because `a` before `b`), and `abe < absolut` (prefix `ab` ties, then `e` before `s`).
