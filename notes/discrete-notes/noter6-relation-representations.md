# Relations: definitions and representations (matrices, graphs)

Source: `material/discrete-maths/slides/Noter6.pdf` (SE4-DMAD, Discrete Maths). 7 pages.

The first part finishes two induction proofs from chapter 5 (sum of powers of 2, and tiling a deficient chessboard with L-trominoes). The second part opens Chapter 9 on relations (Kapitel 9: Relationer): relation from A to B, relation on A, terminology, and three ways to represent a relation — set notation, graphs, matrices. The relation-representation material is the main topic; the induction proofs are recap.

---

## Part 1 — Induction recap (Kapitel 5)

### Eks 5.1.3 — sum of powers of 2

Claim: $\sum_{i=0}^{n} 2^i = 2^{n+1} - 1$ for all $n \in \mathbb{N}$.

Written out (d.v.s. = "det vil sige", i.e.): $2^0 + 2^1 + \dots + 2^n = 2^{n+1} - 1$. Call this statement $P(n)$.

Checks by hand:
- $P(0)$: $2^0 = 1 = 2^1 - 1$. (Basis)
- $P(1)$: $2^0 + 2^1 = 2^2 - 1$. LHS $= (2^1 - 1) + 2^1 = 2\cdot 2^1 - 1 = 2^2 - 1$. OK.
- $P(2)$: $2^0+2^1+2^2 = 2^3 - 1$. LHS $= (2^2 - 1) + 2^2 = 2\cdot 2^2 - 1 = 2^3 - 1$. OK.
- $P(3)$: $2^0+2^1+2^2+2^3 = 2^4 - 1$. LHS $= (2^3 - 1) + 2^3 = 2\cdot 2^3 - 1 = 2^4 - 1$. OK.

The pattern: from $P(k-1)$ you add the next term $2^k$ to both sides. $2^k - 1 + 2^k = 2\cdot 2^k - 1 = 2^{k+1} - 1$, which is exactly $P(k)$.

**Proof (by induction over $n$):**
- **Basis ($n=0$):** $2^0 = 1 = 2^1 - 1$. True.
- **Induction step (induktionsskridt), for $k \ge 1$:** assume $P(k-1)$ holds, i.e. $2^0 + 2^1 + \dots + 2^{k-1} = 2^k - 1$. Add $2^k$ to both sides:
$$2^0 + 2^1 + \dots + 2^{k-1} + 2^k = 2^k - 1 + 2^k = 2\cdot 2^k - 1 = 2^{k+1} - 1.$$
That is $P(k)$. $\square$

The notes draw the "domino effect" (Domino-effekt): $P(0) \Rightarrow P(1) \Rightarrow P(2) \Rightarrow P(3) \Rightarrow \dots$, where the basis gives $P(0)$ and the step at $k=1,2,3,\dots$ pushes each domino over.

### Eks 5.1.14 — tiling a deficient chessboard with L-trominoes

Claim: a $2^n \times 2^n$ chessboard ($n \ge 1$) with one field (felt) removed can be covered by L-shaped trominoes (the bent 3-cell pieces, "brikker") without overlap and without sticking out over the edge.

Small cases checked by drawing: $n=1$ (one tromino covers the 3 remaining cells of a $2\times2$ board), $n=2$ ($4\times4$), $n=3$ ($8\times8$). All OK.

**Proof (by induction over $n$):**
- **Basis ($n=1$):** a $2\times2$ board with one cell removed is exactly one L-tromino. True.
- **Induction hypothesis (ind. ant., $n = k-1$, $k \ge 2$):** a $2^{k-1} \times 2^{k-1}$ board with one field removed can be covered by L-trominoes.
- **Induction step (ind. skridt, $k \ge 2$):** split the $2^k \times 2^k$ board into four quadrants (kvadrater) of size $2^{k-1} \times 2^{k-1}$. The removed cell sits in one quadrant. Place one tromino at the center so it covers one cell in each of the three quadrants that don't already have a hole. Now every one of the four quadrants is missing exactly one cell, so by the induction hypothesis each can be covered. $\square$

---

## Part 2 — Kapitel 9: Relations (Relationer)

Relations describe connections (sammenhænge) between elements of one or more sets. Used e.g. in databases.

Examples of relations:
- (student-no, name, address, education) — `(studie-nr, navn, adresse, uddannelse)`
- (student-no, course) — `(studie-nr, kursus)`
- train connection (tog-forbindelse)
- "is child of" (er barn af)
- $<$
- $=$

The last five (the binary ones) are **binary relations** (binære relationer). This course works only with binary relations.

### Def. 9.1.1 — relation from A to B

Let $A, B$ be sets. A **relation from $A$ to $B$** (relation fra A til B) is a subset of $A \times B$ (the Cartesian product, kartesiske produkt).

For the student example: $A$ = set of student-numbers, $B$ = set of courses. Or $A = B = \mathbb{Z}$. Or any other sets.

### Eks — $R_<$ on a finite set

$A = \{1,2,3,4\}$.
$$R_< = \{(a,b) \in A \times A \mid a < b\} = \{(1,2),(1,3),(1,4),(2,3),(2,4),(3,4)\}.$$

$R_<$ is a relation from $A$ to $A$. A relation from a set to itself is called a relation **on** $A$ (relation på A).

### Def. 9.1.2 — relation on A

Let $A$ be a set. A **relation on $A$** (relation på A) is a relation from $A$ to $A$, i.e. a subset of $A \times A$.

### Eks — $S_<$ on $\mathbb{Z}^+$

$$S_< = \{(a,b) \in \mathbb{Z}^+ \times \mathbb{Z}^+ \mid a < b\} = \{(1,2),(1,3),(2,3),(1,4),(2,4),(3,4),\dots\}.$$

$S_<$ is a relation on $\mathbb{Z}^+$ (infinite).

### Terminology and notation

Three equivalent ways to write the same fact for a relation $S_<$:
1. $(1,2) \in S_<$
2. $1 \; S_< \; 2$ (infix notation)
3. "1 is related to 2 through $S_<$" (1 er relateret til 2 gennem $S_<$)

Remark: $S_<$ is a relation. The pair $(1,2)$ is **not** a relation — it is an element of a relation.

---

## Afsnit 9.3 — Representation (Repræsentation)

A relation can be represented using:
- **set notation** (mængde-notation) — as above;
- **graphs** (grafer);
- **matrices** (matricer).

Graphs and matrices only work when $A$ is finite (hvis A er endelig).

### How the matrix is built

For a relation on $A = \{1,2,3,4\}$ the matrix is $4\times4$. Rows are indexed by the first element $a$, columns by the second element $b$. Entry $(a,b)$ is $1$ if $(a,b)$ is in the relation, else $0$.

### How the graph is built

One node (knude) per element of $A$. Draw a directed arrow (rettet kant) from $a$ to $b$ whenever $(a,b)$ is in the relation. A pair $(a,a)$ becomes a self-loop on node $a$.

### Eks — $R_<$ with $A = \{1,2,3,4\}$

$$R_< = \{(1,2),(1,3),(1,4),(2,3),(2,4),(3,4)\}.$$

Matrix representation (rows/cols ordered 1,2,3,4):

$$\begin{bmatrix} 0&1&1&1\\ 0&0&1&1\\ 0&0&0&1\\ 0&0&0&0 \end{bmatrix}$$

Strictly-upper-triangular: a $1$ exactly where row index $<$ column index. Diagonal is all $0$ because $a < a$ is never true.

Graph representation: nodes 1,2,3,4 with arrows $1\to2,\;1\to3,\;1\to4,\;2\to3,\;2\to4,\;3\to4$. No self-loops.

### Eks — $R_\le$ with $A = \{1,2,3,4\}$

$$R_\le = \{(a,b) \in A\times A \mid a \le b\} = \{(1,1),(1,2),(1,3),(1,4),(2,2),(2,3),(2,4),(3,3),(3,4),(4,4)\}.$$

This is $R_<$ plus the four diagonal pairs $(1,1),(2,2),(3,3),(4,4)$ (the ones added for $\le$, shown in red in the source).

Matrix representation:

$$\begin{bmatrix} 1&1&1&1\\ 0&1&1&1\\ 0&0&1&1\\ 0&0&0&1 \end{bmatrix}$$

Upper-triangular **including** the diagonal — same as the $R_<$ matrix but with $1$s down the main diagonal.

Graph representation: the same arrows as $R_<$, plus a self-loop at every node (1,2,3,4) for the diagonal pairs.
