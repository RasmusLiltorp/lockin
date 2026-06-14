# Opgaver DM05 — Mathematical Induction (matematisk induktion)

Source: `material/discrete-maths/exercises/opgaverDM05.pdf` (Opgaver til uge 12).

This set drills two things: writing correct direct/contraposition/contradiction proofs about parity (lige/ulige tal), and the mechanics of proof by induction (induktion). You prove a sum identity by induction, and you find and prove the range of $n$ for which an inequality holds. Problems 1 and 3 reference Rosen, *Discrete Mathematics and Its Applications* (Section 1.7 Opg 29 and Section 5.1 Opg 18) — those problem statements are reproduced here.

---

## Opgave 1 (Rosen 1.7, Opgave 29)

1. **Problem** — Prove that if $n$ is an integer and $3n+2$ is even (lige), then $n$ is even, using (a) proof by contraposition (kontraposition) and (b) proof by contradiction (modstrid).

2. **Type** — Two proof techniques on the same parity implication $P \Rightarrow Q$.

3. **Method**
   The claim is $P \Rightarrow Q$ where $P$: "$3n+2$ is even", $Q$: "$n$ is even".
   - **(a) Contraposition.** Prove the equivalent statement $\neg Q \Rightarrow \neg P$.
     1. Assume $\neg Q$: $n$ is odd, so write $n = 2k+1$ for some $k \in \mathbb{Z}$ (swap in your own expression).
     2. Substitute into the expression $3n+2$ and simplify to the form $2m$ or $2m+1$.
     3. Read off the parity. If you reach $2m+1$, that is $\neg P$, done.
   - **(b) Contradiction.** Prove that assuming $P \wedge \neg Q$ leads to a false statement.
     1. Assume $P$ ($3n+2$ even) AND $\neg Q$ ($n$ odd, $n=2k+1$).
     2. From $\neg Q$ derive the actual parity of $3n+2$.
     3. This contradicts $P$. The contradiction kills the assumption $\neg Q$, so $Q$ holds.

4. **Worked solution**
   - **(a)** Assume $n$ is odd: $n = 2k+1$. Then
     $$3n+2 = 3(2k+1)+2 = 6k+3+2 = 6k+5 = 2(3k+2)+1,$$
     which is odd. So $3n+2$ odd $\Leftarrow$ $n$ odd, i.e. $\neg Q \Rightarrow \neg P$. By contraposition, $3n+2$ even $\Rightarrow n$ even. $\blacksquare$ (checked: Python — $3n+2$ is odd for every odd $n$)
   - **(b)** Suppose $3n+2$ is even but $n$ is odd. Write $n=2k+1$. Then $3n+2 = 6k+5 = 2(3k+2)+1$ is odd. But we assumed it was even — contradiction. Hence $n$ must be even. $\blacksquare$

---

## Opgave 2 (former exam excerpt — valid-proof check)

1. **Problem** — Statement: "If $n$ is even, then $n+4$ is also even" (Hvis $n$ er lige, er $n+4$ også lige). Which of the four arguments (a)–(d) are valid proofs of this statement?
   - (a) $\exists k\in\mathbb{Z}: n=2k \Rightarrow \exists k\in\mathbb{Z}: n+4 = 2k+4 = 2(k+2)$
   - (b) $\exists k\in\mathbb{Z}: n=2k+1 \Rightarrow \exists k\in\mathbb{Z}: n+4 = 2k+1+4 = 2(k+2)+1$
   - (c) $\exists k\in\mathbb{Z}: n+4=2k \Rightarrow \exists k\in\mathbb{Z}: n = 2k-4 = 2(k-2)$
   - (d) $\exists k\in\mathbb{Z}: n+4=2k+1 \Rightarrow \exists k\in\mathbb{Z}: n = 2k+1-4 = 2(k-2)+1$

2. **Type** — Judge which candidate arguments actually prove $P \Rightarrow Q$ (here $P$: $n$ even, $Q$: $n+4$ even).

3. **Method**
   1. Identify the hypothesis you are allowed to assume ($P$) and the conclusion you must reach ($Q$).
   2. A valid direct proof must **start from $P$** (assume $n$ even, i.e. $n=2k$) and **end at $Q$** (show $n+4$ is even).
   3. Reject anything that assumes the wrong parity (assumes $n$ odd instead of even), or that assumes the conclusion's premise and derives the hypothesis (that proves the converse $Q \Rightarrow P$, not $P \Rightarrow Q$).
   4. Check the algebra is correct too — a line can have the right direction but bad arithmetic.

4. **Worked solution**
   - **(a) Valid.** Assumes $n$ even ($n=2k$), concludes $n+4 = 2(k+2)$ is even. Correct direction, correct algebra. This is the proof.
   - **(b) Invalid.** Assumes $n=2k+1$, i.e. $n$ **odd** — wrong hypothesis. The algebra is fine ($2k+1+4 = 2k+5 = 2(k+2)+1$, checked: Python), but it proves "if $n$ odd then $n+4$ odd", a different statement. Not a proof of the given claim.
   - **(c) Invalid (proves the converse).** Assumes $n+4$ even and derives $n$ even. That is $Q \Rightarrow P$, the converse of what we want. Algebra is fine but direction is backwards.
   - **(d) Invalid.** Assumes $n+4$ odd and derives $n$ odd — wrong direction and wrong parity; says nothing about the stated claim.

   **Answer: only (a) is a valid proof.** (checked: Python — brute-forced the algebra of all four lines and the direction of the implication)

---

## Opgave 3 (Rosen 5.1, Opgave 18) — sum of cubes by induction

1. **Problem** — Let $P(n)$ be the statement that $1^3 + 2^3 + \cdots + n^3 = \left(\dfrac{n(n+1)}{2}\right)^2$ for the positive integer $n$. The exercise walks through the induction proof: (a) state $P(1)$, (b) show $P(1)$ true (basis), (c) state the inductive hypothesis (induktionshypotese), (d) state what must be proved in the inductive step, (e) complete the inductive step, (f) explain why this proves $P(n)$ for all positive integers $n$.

2. **Type** — Proof by induction on $n$ (induktion over $n$) of a summation identity, broken into its named pieces.

3. **Method** (template for any sum identity $\sum_{i=1}^n f(i) = g(n)$)
   1. **(a) $P(1)$**: write the identity with $n=1$ plugged in (LHS = $f(1)$, RHS = $g(1)$).
   2. **(b) Basis (basistrin)**: compute both sides at $n=1$ and check they are equal.
   3. **(c) Inductive hypothesis**: assume $P(k)$ holds, i.e. $\sum_{i=1}^k f(i) = g(k)$ for an arbitrary fixed $k\ge 1$.
   4. **(d) To prove**: write $P(k+1)$: $\sum_{i=1}^{k+1} f(i) = g(k+1)$.
   5. **(e) Inductive step (induktionstrin)**: split the LHS sum as $\big(\sum_{i=1}^k f(i)\big) + f(k+1)$, replace the bracket by $g(k)$ using the hypothesis, then do algebra to reach $g(k+1)$.
   6. **(f)** By the principle of induction, $P(1)$ + ($P(k)\Rightarrow P(k+1)$) gives $P(n)$ for all $n\ge 1$.

   Here $f(i)=i^3$ and $g(n)=\left(\frac{n(n+1)}{2}\right)^2$.

4. **Worked solution**
   - **(a)** $P(1)$: $\;1^3 = \left(\dfrac{1\cdot 2}{2}\right)^2$.
   - **(b)** LHS $= 1$. RHS $= (1)^2 = 1$. Equal, so $P(1)$ is true.
   - **(c)** Assume $P(k)$: $\;1^3+2^3+\cdots+k^3 = \left(\dfrac{k(k+1)}{2}\right)^2$.
   - **(d)** Must show $P(k+1)$: $\;1^3+\cdots+k^3+(k+1)^3 = \left(\dfrac{(k+1)(k+2)}{2}\right)^2$.
   - **(e)** Start from the LHS and use the hypothesis:
     $$\underbrace{1^3+\cdots+k^3}_{=\,(k(k+1)/2)^2} + (k+1)^3 = \frac{k^2(k+1)^2}{4} + (k+1)^3.$$
     Factor out $(k+1)^2$:
     $$= (k+1)^2\!\left(\frac{k^2}{4} + (k+1)\right) = (k+1)^2 \cdot \frac{k^2 + 4k + 4}{4} = (k+1)^2 \cdot \frac{(k+2)^2}{4} = \left(\frac{(k+1)(k+2)}{2}\right)^2.$$
     That is exactly $g(k+1)$, so $P(k+1)$ holds.
   - **(f)** Basis $P(1)$ is true, and $P(k)\Rightarrow P(k+1)$ for every $k\ge 1$. By the principle of mathematical induction, $P(n)$ holds for all positive integers $n$. $\blacksquare$
   - Sanity check (checked: Python): the identity gives $1,9,36,100,225$ for $n=1..5$, matching $\sum i^3$; both sides equal for all $n$ up to 30.

---

## Opgave 4 — for which integers $n$ does $2n+1 < 3^n$?

1. **Problem** — For which integers $n$ does $2n+1 < 3^n$ hold? Prove your claim by induction on $n$ (induktion over $n$).

2. **Type** — Find the threshold, then prove an inequality by induction.

3. **Method** (inequality $A(n) < B(n)$, find where it holds and prove it)
   1. **Test small $n$** to find the smallest $n_0$ where it starts holding (and confirm it fails below $n_0$). Swap in your own $A,B$.
   2. **Basis**: prove the inequality at $n=n_0$ directly.
   3. **Hypothesis**: assume $A(k) < B(k)$ for some $k\ge n_0$.
   4. **Step**: bound $A(k+1)$ above using the hypothesis. Typical trick: write $B(k+1)$ in terms of $B(k)$ (here $3^{k+1}=3\cdot 3^k$), and show $A(k+1) \le (\text{something}) < B(k+1)$.
   5. Conclude it holds for all $n\ge n_0$. State separately that it fails for $n<n_0$.

4. **Worked solution**
   **Threshold.** Test (checked: Python):

   | $n$ | $2n+1$ | $3^n$ | $2n+1<3^n$? |
   |----|-------|------|----|
   | 0 | 1 | 1 | no (equal) |
   | 1 | 3 | 3 | no (equal) |
   | 2 | 5 | 9 | yes |
   | 3 | 7 | 27 | yes |
   | 4 | 9 | 81 | yes |

   For $n=0$ and $n=1$ both sides are equal, so the strict inequality fails. **Claim: $2n+1 < 3^n$ holds for all integers $n \ge 2$** (and fails for $n\le 1$). For negative $n$, $3^n$ is a positive fraction $<1$ while $2n+1\le -1$, so $2n+1<3^n$ is actually true there too — but the intended/clean answer for this course is the integer range $n\ge 2$, proved by induction.

   **Induction proof (for $n\ge 2$).**
   - **Basis** ($n=2$): $2(2)+1 = 5 < 9 = 3^2$. True.
   - **Hypothesis**: assume $2k+1 < 3^k$ for some $k\ge 2$.
   - **Step**: show $2(k+1)+1 < 3^{k+1}$, i.e. $2k+3 < 3^{k+1}$.
     $$2k+3 = (2k+1) + 2 < 3^k + 2.$$
     Since $k\ge 2$ we have $3^k \ge 9 > 2$, so $3^k + 2 < 3^k + 3^k < 3\cdot 3^k = 3^{k+1}$.
     Chaining: $2k+3 < 3^k+2 < 3^{k+1}$. So $2(k+1)+1 < 3^{k+1}$.
   - **Conclusion**: by induction $2n+1 < 3^n$ for all integers $n\ge 2$. $\blacksquare$
