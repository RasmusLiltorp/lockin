# Relations: properties and closures (Relationer, Kapitel 9)

Source: `material/discrete-maths/slides/Noter7.pdf` (8 handwritten pages, Danish).

Note on scope: the file was filed under "equivalence relations / partitions," but the actual content is Chapter 9 on relations — recap of matrix and graph representation, the four properties (reflexive, symmetric, antisymmetric, transitive) from Section 9.1, and reflexive/symmetric closures from Section 9.4. No equivalence relations or partitions appear here. These notes follow what is in the document.

---

## Recap (Sidste gang): representing a relation

A relation $R$ on $A$ is a subset $R \subseteq A \times A$. Two ways to represent it: a 0/1 matrix and a directed graph.

### Example: strict less-than $R_<$

$A = \{1,2,3,4\}$, $R_< = \{(a,b) \in A \times A \mid a < b\}$
$= \{(1,2),(1,3),(1,4),(2,3),(2,4),(3,4)\}$.

Matrix (rows/cols indexed $1..4$, entry $1$ iff $(i,j)\in R$):

$$
\begin{bmatrix}
0&1&1&1\\
0&0&1&1\\
0&0&0&1\\
0&0&0&0
\end{bmatrix}
$$

Graph: vertices $1,2,3,4$ with an arrow $i \to j$ for each pair. No self-loops (nothing on the diagonal).

### Example: less-than-or-equal $R_\le$

$A = \{1,2,3,4\}$, $R_\le = \{(a,b) \in A \times A \mid a \le b\}$
$= \{(1,1),(1,2),(1,3),(1,4),(2,2),(2,3),(2,4),(3,3),(3,4),(4,4)\}$.

This is $R_<$ plus the four diagonal pairs $(1,1),(2,2),(3,3),(4,4)$.

Matrix:

$$
\begin{bmatrix}
1&1&1&1\\
0&1&1&1\\
0&0&1&1\\
0&0&0&1
\end{bmatrix}
$$

Graph: same arrows as $R_<$ plus a self-loop at every vertex.

---

## Section 9.1: Properties (Afsnit 9.1: Egenskaber)

### Def. 9.1.3 — Reflexive (refleksiv)

$R$ a relation on $A$. $R$ is reflexive if
$$(a,a) \in R \quad \text{for all } a \in A.$$

How to spot it:
- Matrix: the whole main diagonal is $1$ (all diagonal entries are $1$).
- Graph: every vertex has a self-loop.

### Def. 9.1.4 — Symmetric (symmetrisk)

$R$ a relation on $A$. $R$ is symmetric if
$$(a,b) \in R \;\Rightarrow\; (b,a) \in R \quad \text{for all } a,b \in A.$$

How to spot it:
- Matrix: symmetric across the main diagonal (entry $i,j$ equals entry $j,i$).
- Graph: every edge goes both directions (every arrow has its reverse).

#### Example: same parity $R_{par}$

$A=\{1,2,3,4\}$, $R_{par} = \{(a,b) \mid a \text{ and } b \text{ have the same parity (samme paritet)}\}$
$= \{(1,1),(1,3),(2,2),(2,4),(3,1),(3,3),(4,2),(4,4)\}$.

Matrix:

$$
\begin{bmatrix}
1&0&1&0\\
0&1&0&1\\
1&0&1&0\\
0&1&0&1
\end{bmatrix}
$$

Graph splits into two pieces: the odd group $\{1,3\}$ (fully linked both ways plus self-loops) and the even group $\{2,4\}$ (same).

#### Which relations are symmetric

- Symmetric: same parity, $=$, $|\cdot|$ (some distance/absolute relation), $\ne$.
- Not symmetric: $<$, $\le$, $|$ (divides).

### Def. 9.1.4 (second) — Antisymmetric (antisymmetrisk)

$R$ a relation on $A$. $R$ is antisymmetric if
$$(a,b) \in R \;\wedge\; (b,a) \in R \;\Rightarrow\; a=b \quad \text{for all } a,b \in A.$$

The document shows three equivalent rewrites (each line follows from the previous by logical equivalence):

1. $a \ne b \;\Rightarrow\; (a,b) \notin R \;\vee\; (b,a) \notin R$
2. $(a,b) \in R \;\Rightarrow\; (b,a) \notin R \;\vee\; a = b$
3. $(a,b) \in R \;\wedge\; a \ne b \;\Rightarrow\; (b,a) \notin R$

Reading of (3): if a non-diagonal pair is in $R$, its reverse is not. Antisymmetric is not the negation of symmetric.

#### Which relations fall where

- Antisymmetric: $<$, $\le$, $=$, $|$ (divides).
- Symmetric: $=$, same parity.
- Neither: $\{(1,1),(1,2),(2,1),(1,3)\}$ — has $(1,2)$ and $(2,1)$ with $1\ne2$ (breaks antisymmetry), but lacks $(3,1)$ for $(1,3)$ (breaks symmetry).

Note $=$ is both symmetric and antisymmetric.

### Def. 9.1.5 — Transitive (transitiv)

$R$ a relation on $A$. $R$ is transitive if
$$(a,b) \in R \;\wedge\; (b,c) \in R \;\Rightarrow\; (a,c) \in R \quad \text{for all } a,b,c \in A.$$

#### Worked check

Is $\{(1,3),(2,4),(3,4)\}$ transitive? No: $(1,3)\in R$ and $(3,4)\in R$, but $(1,4)\notin R$.

#### Which relations are transitive

- Transitive: $\le$, $<$, $=$, $|$ (divides).
- Not transitive: $\ne$; and $S = \{(1,2),(2,3),(3,4)\}$ (e.g. $(1,2),(2,3)\in S$ but $(1,3)\notin S$).

---

## Exercise: classify three relations on $\{1,2,3\}$

For each, the task is matrix representation, graph representation, and which of the four properties hold. The document leaves these blank — solutions below.

$R_1 = \{(1,3),(2,2),(3,1)\}$
- Matrix: $\begin{bmatrix}0&0&1\\0&1&0\\1&0&0\end{bmatrix}$
- Reflexive: no ($(1,1),(3,3)$ missing). Symmetric: yes ($(1,3)\&(3,1)$, $(2,2)$). Antisymmetric: no ($(1,3),(3,1)$, $1\ne3$). Transitive: no ($(1,3),(3,1)$ but $(1,1)\notin R_1$).

$R_2 = \{(1,1),(1,2),(1,3),(3,1),(3,2),(3,3)\}$
- Matrix: $\begin{bmatrix}1&1&1\\0&0&0\\1&1&1\end{bmatrix}$
- Reflexive: no ($(2,2)$ missing). Symmetric: no ($(1,2)$ in, $(2,1)$ not). Antisymmetric: no ($(1,3),(3,1)$, $1\ne3$). Transitive: yes. Only $1$ and $3$ have outgoing pairs, so check chains through them: $(1,3),(3,1)\Rightarrow(1,1)$ ok; $(1,3),(3,2)\Rightarrow(1,2)$ ok; $(3,1),(1,2)\Rightarrow(3,2)$ ok; $(3,1),(1,3)\Rightarrow(3,3)$ ok. All present.

$R_3 = \{(1,1),(1,2),(2,2),(3,1),(3,2),(3,3)\}$
- Matrix: $\begin{bmatrix}1&1&0\\0&1&0\\1&1&1\end{bmatrix}$
- Reflexive: yes (diagonal all in). Symmetric: no ($(1,2)$ in, $(2,1)$ not). Antisymmetric: yes (no opposite off-diagonal pair both present). Transitive: yes ($(3,1),(1,2)\Rightarrow(3,2)$ ok; $(3,2),(2,2)\Rightarrow(3,2)$ ok; $(1,1),(1,2)\Rightarrow(1,2)$ ok; all hold).

(These solutions are worked out here; verify against your own reading since the page is blank.)

---

## Section 9.4: Closures (Afsnit 9.4: Lukninger)

### Reflexive closure (refleksiv lukning)

$R$ a relation on $A$. The reflexive closure of $R$ is
$$r(R) = R \cup \{(a,a) \mid a \in A\}.$$

You get it by adding exactly the diagonal pairs $R$ is missing to become reflexive — nothing more.

#### Example on $\{1,2,3,4\}$

$R = \{(1,3),(2,2),(2,3),(3,1),(3,3)\}$.
$r(R) = R \cup \{(1,1),(2,2),(3,3),(4,4)\}$ — but $(2,2),(3,3)$ already present, so the genuinely new pairs are $(1,1)$ and $(4,4)$.
$r(R) = \{(1,1),(1,3),(2,2),(2,3),(3,1),(3,3),(4,4)\}$.

#### Example on $\mathbb{N}$

$R_< = \{(a,b) \mid a < b\}$.
$r(R_<) = R_< \cup \{(a,a) \mid a \in \mathbb{N}\} = \{(a,b) \in \mathbb{N}\times\mathbb{N} \mid a \le b\} = R_\le$.

### Symmetric closure (symmetrisk lukning)

The symmetric closure of a relation $R$ is
$$s(R) = R \cup \{(b,a) \mid (a,b) \in R\}.$$

Add the reverse of every pair already in $R$.

#### Examples

- $s(\{(1,3),(2,2),(2,3),(3,1)\}) = \{(1,3),(2,2),(2,3),(3,1),(3,2)\}$. (Only $(2,3)$ was missing its reverse $(3,2)$; $(1,3)/(3,1)$ already paired, $(2,2)$ is its own reverse.)
- $s(R_<) = R_< \cup R_> = R_{\ne}$ (less-than plus greater-than gives "not equal").
- $s(R_\le) = R_\le \cup R_\ge = A \times A$ (every pair).
- $s(\text{same parity}) = \text{same parity}$ (already symmetric, closure changes nothing).
