# Simple Induction (Simpel induktion)

Source: `material/discrete-maths/slides/Noter5.pdf` (5 pages, handwritten).

These notes cover **mathematical induction (induktion)**, not relations. The file is a worked-example sheet: it finishes a recap example from last time ($2^n < n!$), states the simple-induction schema and its variants, and runs two more proofs (angle sum in a convex $n$-gon, and the geometric sum $\sum 2^i$). Note: the assignment expected this file to cover relations — it does not. The actual topic is induction.

---

## Recap example: $2^n < n!$ (Eks 5.1.6)

**Claim:** $2^n < n!$ for all integers (heltal) $n \ge 4$.

### Numerical check
- $n=4$: $2^4 = 2\cdot2\cdot2\cdot2 = 16 < 24 = 4\cdot3\cdot2\cdot1 = 4!$
- $n=5$: $2^5 = 2\cdot2\cdot2\cdot2\cdot2 = 32 < 120 = 5\cdot4\cdot3\cdot2\cdot1 = 5!$
- $n=6$: $2^6 = 2\cdot2\cdot2\cdot2\cdot2\cdot2 = 64 < 720 = 6\cdot5\cdot4\cdot3\cdot2\cdot1 = 6!$

The intuition shown: $2^4 < 4! \Rightarrow 2^5 < 5! \Rightarrow 2^6 < 6! \Rightarrow \dots$ — each case implies the next, which is exactly what induction formalizes.

### Proof by induction over $n$ (Bevis ved induktion over $n$)

**Basis** ($n=4$): $2^4 = 16 < 24 = 4!$. True.

**Induction step (Induktionsskridt):** For every $k \ge 4$:
$$2^k < k! \quad \text{(induktionsantagelse / induction hypothesis)}$$
$$\Downarrow$$
$$2 \cdot 2^k < (k+1) \cdot k! \quad \text{since } k+1 \ge 5 > 2$$
$$\Updownarrow$$
$$2^{k+1} < (k+1)!$$

The step multiplies the left side by $2$ and the right side by $(k+1)$. Because $k+1 \ge 5 > 2$, multiplying the (larger) right side by the larger factor keeps the inequality strict. $\square$

### Same step written as a chain (page 2)

You don't have to build the induction step as a direct proof (et direkte bevis). You can instead start from the left side of the inequality you want and apply the induction hypothesis along the way:
$$
\begin{aligned}
2^{k+1} &= 2 \cdot 2^k \\
&< 2 \cdot k! && \text{by ind. hyp. (ifølge ind. ant.)} \\
&< (k+1) \cdot k! && \text{since } k+1 > 2 \\
&= (k+1)!
\end{aligned}
$$
Same result, cleaner presentation. This style is usually easier for inequality proofs.

---

## The simple-induction schema (Simpel induktion)

To **prove $P(n)$ for all $n \ge m$:**

- **Basis:** prove $P(m)$.
- **Induction step (Induktionsskridt):** prove $P(k) \Rightarrow P(k+1)$ for $k \ge m$.
  - Here $P(k)$ is the **induction hypothesis (induktionsantagelse)**.

$m$ is the starting point — it need not be $0$ or $1$ (the example above used $m=4$).

### Equivalent variants (Eller …)

The step can be reindexed in several equivalent ways:

1. **Standard:** prove $P(k) \Rightarrow P(k+1)$ for $k \ge m$.

2. **Shifted down:** prove $P(k-1) \Rightarrow P(k)$ for $k \ge m+1$.
   For Eks 5.1.6 this would read:
   $$
   \begin{aligned}
   2^{k-1} &< (k-1)! && \text{(hypothesis, for } k \ge 5\text{)}\\
   \Downarrow\quad 2\cdot 2^{k-1} &< k \cdot (k-1)! && \text{since } k \ge 5 > 2 \\
   \Updownarrow\quad 2^{k} &< k!
   \end{aligned}
   $$

3. **Shifted up:** prove $P(k+1) \Rightarrow P(k+2)$ for $k \ge m-1$.

4. Or any further reindexing — all are the same proof with the index relabeled. Pick whichever makes the algebra cleanest.

---

## Example: angle sum in a convex $n$-gon (Vinkelsum i en konveks $n$-kant)

**Claim (Påstand):** the angle sum in a convex $n$-gon (konveks $n$-kant) is $(n-2)\cdot 180$, for $n \ge 3$.

### Small cases
- Triangle ($n=3$): $180$.
- Quadrilateral ($n=4$): split into two triangles, $180+180 = 360$.
- Pentagon ($n=5$): $360+180 = 540$.
- Hexagon ($n=6$): $540+180 = 720$.

Each added edge adds one more triangle, i.e. $+180$.

### Proof by induction over $n$

**Basis** ($n=3$): a triangle has angle sum $180 = (3-2)\cdot 180$. True.

**Induction hypothesis (Ind. ant.):** a convex $k$-gon has angle sum $(k-2)\cdot 180$, where $k \ge 3$.

**Induction step (Ind. skridt):** for $k \ge 3$, a convex $(k+1)$-gon can be split into a convex $k$-gon and a triangle (en 3-kant), because it has at least 4 corners (hjørner). Cut off one corner with a diagonal: the big piece is a $k$-gon with angle sum $(k-2)\cdot 180$ (by ind. hyp.), the cut-off piece is a triangle with $180$.

So the angle sum of the $(k+1)$-gon is:
$$(k-2)\cdot 180 + 180 = (k-1)\cdot 180 = ((k+1)-2)\cdot 180$$
which matches the formula for $n = k+1$. $\square$

---

## Example: geometric sum $\sum_{i=0}^{n} 2^i = 2^{n+1}-1$ (Eks 5.1.3)

**Claim:** $\displaystyle\sum_{i=0}^{n} 2^i = 2^{n+1}-1$ for all $n \in \mathbb{N}$.

That is (d.v.s.):
$$2^0 + 2^1 + \dots + 2^n = 2^{n+1}-1 \quad \text{for all } n \in \mathbb{N}.$$
Call this statement $P(n)$.

### Cases checked (verification, not yet the full induction proof)
- $P(0)$ (Basis): $2^0 = 1$ and $2^1 - 1 = 2-1 = 1$. ✓
- $P(1)$: $2^0 + 2^1 = 2^2 - 1$. Using $P(0)$: $(2^1-1) + 2^1 = 2\cdot 2^1 - 1 = 2^2 - 1$. ✓
- $P(2)$: $2^0+2^1+2^2 = 2^3-1$. Using $P(1)$: $(2^2-1) + 2^2 = 2\cdot 2^2 - 1 = 2^3 - 1$. ✓
- $P(3)$: $2^0+2^1+2^2+2^3 = 2^4-1$. Using $P(2)$: $(2^3-1) + 2^3 = 2\cdot 2^3 - 1 = 2^4 - 1$. ✓

Pattern of each step: take the previous sum $2^k - 1$, add the next term $2^k$, get $2\cdot 2^k - 1 = 2^{k+1}-1$. That is the induction step in disguise.

The notes stop here: **"Fortsættes næste gang …"** (continued next time) — the formal induction proof of $\sum 2^i$ is finished in the next lecture.

---

## Quick reference

| Piece | Danish | What to write |
|-------|--------|---------------|
| Base case | Basis | Prove $P(m)$ |
| Hypothesis | Induktionsantagelse | Assume $P(k)$ |
| Step | Induktionsskridt | Prove $P(k) \Rightarrow P(k+1)$ |
| Proof by induction | Bevis ved induktion | over $n$ |

Tips from the sheet:
- For inequalities, the chain style ("start from the LHS, apply hypothesis, bound the rest") is usually cleanest.
- The starting index $m$ is whatever the claim needs (here $4$ and $3$, not $0$).
- The step can be reindexed freely ($P(k-1)\Rightarrow P(k)$, etc.) — choose the cleanest algebra.
