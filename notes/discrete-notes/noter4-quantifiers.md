# Proof Methods (continued) and Induction — Noter4

Source: `material/discrete-maths/slides/Noter4.pdf` (handwritten Danish lecture notes, 10 pages).

Heads-up: the filename says "quantifiers", but this document is not about quantifiers. It continues proof techniques — proof by contraposition (kontrapositionsbevis), proof by contradiction (modstridsbevis), proof by cases / splitting (split op), proof terminology (theorem/lemma/corollary), and then opens Section 5.1 on induction proofs (induktionsbeviser). Quantifier symbols ($\forall$, $\exists$) appear only as shorthand inside the proofs. The notes lean on examples carried over from earlier (Eks. 1.7.1).

---

## 1. Eks 1.7.9 — proof by contraposition (kontraposition)

Claim. For every $n \in \mathbb{Z}$:
$$n^2 \text{ odd (ulige)} \implies n \text{ odd (ulige)}.$$

### Why a direct proof fails here

A direct proof would start from $n^2$ odd, i.e. $n^2 = 2k+1$, giving $n = \pm\sqrt{2k+1}$ — and then you're stuck (the "??"). The square root leads nowhere.

### Switch to contraposition

Contraposition swaps the roles. Instead of $p \implies q$ you prove $\neg q \implies \neg p$. Here that puts $n$ in the assumption and $n^2$ in the conclusion, the same setup as Eks. 1.7.1:
$$n \text{ even (lige)} \implies n^2 \text{ even (lige)}.$$

### Proof (kontraposition)

The chain (read top to bottom; each step is an equivalence $\Leftrightarrow$ except the implication marked, and the middle block is a direct proof):

$$
\begin{aligned}
&\neg(n \text{ ulige}) \\
\Leftrightarrow\ & n \text{ lige} \\
\Leftrightarrow\ & \exists k \in \mathbb{Z}: n = 2k \qquad \text{(by Def. 1.7.1)} \\
\Rightarrow\ & \exists k \in \mathbb{Z}: n^2 = 4k^2 \\
\Leftrightarrow\ & \exists k \in \mathbb{Z}: n^2 = 2\cdot 2k^2,\quad 2k^2 \in \mathbb{Z} \text{ since } k \in \mathbb{Z} \\
\Leftrightarrow\ & n^2 \text{ lige} \\
\Leftrightarrow\ & \neg(n^2 \text{ ulige})
\end{aligned}
$$

The bracketed middle steps ($n$ lige $\Rightarrow$ $n^2$ lige) are themselves a direct proof (direkte bevis). $\square$

---

## 2. Combining 1.7.1 and 1.7.9 — biconditional

Eks. 1.7.1 ($n$ lige $\Rightarrow n^2$ lige, equivalently $n$ ulige $\Rightarrow n^2$ ulige) together with Eks. 1.7.9 ($n^2$ ulige $\Rightarrow n$ ulige) give both directions:
$$n^2 \text{ ulige} \iff n \text{ ulige}.$$
Said differently: $n$ and $n^2$ always have the same parity (samme paritet).

This is the standard pattern: prove a $\Leftrightarrow$ by proving each $\Rightarrow$ direction separately.

---

## 3. Modstridsbevis — proof by contradiction (example: birthdays)

Claim. There are two participants in this lecture who have their birthday in the same month.

### Proof (modstrid)

Assume for contradiction (antag til modstrid) that no month has two birthdays. Then there are at most 12 participants — contradiction (the lecture has more than 12). $\square$

### NB on wording

"Two birthdays" means *at least* two (mindst to), not *exactly* two (præcis to). The pigeonhole-style argument only needs "at least two".

---

## 4. Modstridsbevis — triangle inequality example

Claim. For every right triangle (retvinklet trekant) with legs $a>0$, $b>0$ and hypotenuse $c$:
$$c < a+b.$$

### Proof (modstrid)

Assume for contradiction that there exists a right triangle with $c \ge a+b$. Then:

$$
\begin{aligned}
& c \ge a+b \\
\Rightarrow\ & c^2 \ge (a+b)^2, \quad \text{since } a,b,c \ge 0 \\
& c^2 \ge a^2 + b^2 + 2ab \\
& c^2 > a^2 + b^2, \quad \text{since } 2ab > 0.
\end{aligned}
$$

But $c^2 > a^2 + b^2$ contradicts Pythagoras ($c^2 = a^2 + b^2$). $\square$

Key move: squaring is monotone for nonnegative numbers, and the $2ab$ term is strictly positive, so $\ge$ becomes a strict $>$.

---

## 5. Further tricks — splitting up (split op)

### 5a. Split into sub-results (del-resultater)

A biconditional splits into two implications:
$$p \iff q \quad\equiv\quad (p \implies q) \wedge (q \implies p) \qquad \text{(as in Eks. 1.7.9 / the combined result)}.$$

A chain of biconditionals splits into a cycle of implications:
$$p_1 \iff p_2 \iff p_3 \quad\equiv\quad p_1 \implies p_2 \implies p_3 \implies p_1.$$
Proving the cycle proves all three are equivalent.

### 5b. Split into cases (specialtilfælde)

Floor/ceiling notation (NB):
- $\lfloor\ \rfloor$ rounds down (runder ned) — floor.
- $\lceil\ \rceil$ rounds up (runder op) — ceiling.

Claim.
$$\forall n \in \mathbb{Z}:\quad \left\lfloor \frac{n+1}{2} \right\rfloor \ge \frac{n}{2}.$$

### Proof (two direct proofs, one per case)

**Case 1: $n$ odd (ulige).** Then $n+1$ is even, so $\frac{n+1}{2}$ is an integer and the floor does nothing:
$$\left\lfloor \frac{n+1}{2}\right\rfloor = \frac{n+1}{2} > \frac{n}{2}.$$

**Case 2: $n$ even (lige).** Then $\frac{n}{2}$ is an integer:
$$\left\lfloor \frac{n+1}{2}\right\rfloor = \left\lfloor \frac{n}{2} + \frac{1}{2}\right\rfloor = \frac{n}{2}.$$

Both cases satisfy the inequality, so it holds for all $n$. $\square$

---

## 6. Terminology (lidt terminologi)

- **Sætning (theorem):** an important statement that *has been proven* true. If it is not yet proven, it is only a **påstand / conjecture**.
- **Lemma:** a helper theorem (hjælpesætning). Used to structure a long proof.
- **Korollar (corollary):** a consequence theorem (følgesætning) — a statement that follows immediately from a theorem.

---

## 7. Summary of proof methods (opsummering)

### Direct proof (direkte bevis)

Shape: build a chain of implications and conclude the implication.
$$\big(p \implies p_1 \implies p_2 \cdots \implies p_n \implies q\big) \implies (p \implies q).$$
Mapped onto the odd-square example:
- $p$ = "$n$ ulige" → $\exists k \in \mathbb{Z}: n = 2k+1$
- intermediate → $\exists k \in \mathbb{Z}: n^2 = 4k^2 + 4k + 1$, then $n^2 = 2(2k^2 + 2k) + 1$
- $q$ = "$n^2$ ulige".

### Contraposition proof (kontrapositionsbevis)

Shape:
$$(p \implies q) \iff (\neg q \implies \neg p).$$
Mapped: $p = $ "$n^2$ ulige", $q = $ "$n$ ulige". So $\neg q = $ "$n$ lige" and $\neg p = $ "$n^2$ lige"; you prove $n$ lige $\implies n^2$ lige instead.

### Contradiction proof (modstridsbevis)

Shape:
$$(\neg p \implies F) \implies p,$$
i.e. assume $\neg p$, derive a falsehood $F$, conclude $p$.
- Birthdays: $\neg p = $ "$\neg\exists$ month with $\ge 2$ birthdays" leads to "$\le 12$ persons" ($F$); conclusion $p = $ "$\exists$ month with $\ge 2$ birthdays".
- Triangle: $\neg p = \exists$ triangle with $c \ge a+b$ leads to $\exists$ triangle with $c^2 > a^2+b^2$ ($F$, against Pythagoras); conclusion $p = \forall$ triangle $c < a+b$.

---

## 8. Section 5.1 — induction proofs (induktionsbeviser)

Used to prove **parametrised statements** (parametriserede udsagn). Often used to prove correctness of iterative or recursive algorithms.

### Eks 5.1.6 — motivating example

Claim. $2^n < n!$ for all integers $n \ge 4$. ($n$ is the parameter.)

Start with small values to see the pattern:

| $n$ | $2^n$ | value | $n!$ | value | check |
|----|-------|-------|------|-------|-------|
| 4 | $2\cdot2\cdot2\cdot2$ | 16 | $4\cdot3\cdot2\cdot1$ | 24 | $16 < 24$ |
| 5 | $2\cdot2\cdot2\cdot2\cdot2$ | 32 | $5\cdot4\cdot3\cdot2\cdot1$ | 120 | $32 < 120$ |
| 6 | $2^6$ | 64 | $6!$ | 720 | $64 < 720$ |

Going from $n$ to $n+1$: the left side multiplies by 2 every time; the right side multiplies by a larger and larger number ($n+1$). So once the inequality holds it stays satisfied (uligheder forbliver opfyldt) as $n$ grows.

This gives the induction step idea: for every $k \ge 4$, if the inequality holds for $n=k$, it also holds for $n=k+1$.

### The induction proof

Statement (boxed): $2^n < n!$ for all integers $n \ge 4$.

**Proof (by induction on $n$).**

**Basis (n=4):**
$$2^4 = 16 < 24 = 4!.$$

**Induction step (induktionsskridt):** for every $k \ge 4$, assume $2^k < k!$ (the induction hypothesis, induktionsantagelse). Multiply both sides by 2:
$$2 \cdot 2^k < 2 \cdot k! < (k+1)\cdot k!$$
where $\underbrace{2\cdot 2^k}_{=\,2^{k+1}}$ and $\underbrace{(k+1)\cdot k!}_{=\,(k+1)!}$, and the second inequality holds because $2 < k+1$ (true since $k \ge 4$). So $2^{k+1} < (k+1)!$. $\square$

How the dominoes fall:
$$
\begin{aligned}
&2^4 < 4! && \text{(Basis)}\\
&2^4 < 4! \implies 2^5 < 5! && (k=4)\\
&2^5 < 5! \implies 2^6 < 6! && (k=5)\\
&2^6 < 6! \implies 2^7 < 7! && (k=6)\\
&\quad\vdots
\end{aligned}
$$

Exercise left in the notes: prove $2^{n+1} < n!$ for $n \ge 5$.

---

## 9. Simple induction (simpel induktion) — the template

To prove $P(n)$ for all $n \ge m$:

- **Basis:** prove $P(m)$.
- **Induction step (induktionsskridt):** prove $P(k) \implies P(k+1)$ for all $k \ge m$. Here $P(k)$ is the **induction hypothesis** (induktionsantagelse).

(Variant: prove $P(k-1) \implies P(k)$ for $k \ge m+1$, or similar reindexings.)

What you have proven, laid out:
$$
\begin{aligned}
&P(m) && \text{(Basis)}\\
&P(m) \implies P(m+1) && (\text{ind. step, } k=m)\\
&P(m+1) \implies P(m+2) && (k=m+1)\\
&P(m+2) \implies P(m+3) && (k=m+2)\\
&\quad\vdots
\end{aligned}
$$

### Domino analogy (domino-effekt)

- In the basis you show the $m$-th tile (brik) can be tipped over.
- In the induction step you show the tiles stand close enough together that tipping one tips all the following ones.
