# DM06 — Induction with inequality proofs

Source: `material/discrete-maths/exercises/opgaverDM06.pdf` (Opgaver til uge 13, SE4-DMAD, F26). Textbook problems are from Rosen, *Discrete Mathematics and Its Applications*, Section 5.1 (Mathematical Induction).

This set drills mathematical induction (matematisk induktion). Three textbook problems cover an alternating-sum equality, a strict inequality ($2^n>n^2$), and a closed form for a power sum. The exam excerpt asks you to spot which of six "proofs" are valid induction arguments — the real skill here is recognizing broken base cases, wrong-direction induction steps, and false inequality steps.

---

## Opgave 5.1.11

1. **Problem** — Prove that $1^2 - 2^2 + 3^2 - \cdots + (-1)^{n-1}n^2 = \dfrac{(-1)^{n-1}n(n+1)}{2}$ for every positive integer $n$.

2. **Type** — Induction on $n$, proving an equality (summationsformel).

3. **Method** (works for any "prove $\sum = $ closed form" by induction):
   1. **Basis**: plug the smallest $n$ (here $n=1$) into both sides, check they match.
   2. **Induction hypothesis (IH)**: assume the formula holds for some $n=k$.
   3. **Induction step**: write the sum for $n=k+1$ as (sum up to $k$) + (new term). Replace the sum-up-to-$k$ part by the IH closed form. Algebraically simplify to the closed form with $k+1$ substituted.
   4. Conclude by induction it holds for all $n\geq$ basis.
   - Swap-in points: the term formula $(-1)^{n-1}n^2$ and the target closed form.

4. **Worked solution**:
   - **Basis** $n=1$: LHS $=1^2=1$. RHS $=\frac{(-1)^0\cdot1\cdot2}{2}=1$. Match.
   - **IH**: assume $\sum_{i=1}^{k}(-1)^{i-1}i^2 = \frac{(-1)^{k-1}k(k+1)}{2}$.
   - **Step** $n=k+1$: add the new term $(-1)^{k}(k+1)^2$:
     $$\frac{(-1)^{k-1}k(k+1)}{2} + (-1)^{k}(k+1)^2.$$
     Factor $(-1)^{k}(k+1)$:
     $$=(-1)^{k}(k+1)\left[-\frac{k}{2}+(k+1)\right]=(-1)^{k}(k+1)\cdot\frac{k+2}{2}=\frac{(-1)^{k}(k+1)(k+2)}{2}.$$
     This is the closed form with $k+1$ in place of $n$ (since $(-1)^{(k+1)-1}=(-1)^k$). Done.
   - Verified numerically for $n=1..7$. (checked: Python — LHS = RHS for $n=1..29$)

---

## Opgave 5.1.49

1. **Problem** — Prove that $2^n > n^2$ for every integer $n > 4$ (i.e. $n\geq5$).

2. **Type** — Induction on $n$, proving a strict inequality (ulighed).

3. **Method** (works for any "prove $f(n)>g(n)$ for $n\geq n_0$"):
   1. **Basis**: check the inequality at $n=n_0$ (here $n_0=5$). Do not start lower — the claim is false for $2\leq n\leq4$.
   2. **IH**: assume $f(k)>g(k)$ for some $k\geq n_0$.
   3. **Step**: bound $f(k+1)$ from below using the IH, then show that bound is $>g(k+1)$. For doubling sequences, write $2^{k+1}=2\cdot2^k$ and apply IH; then prove $2k^2\geq(k+1)^2$ holds on the range.
   4. Conclude for all $n\geq n_0$.
   - Swap-in points: the functions $f,g$ and the start value $n_0$.

4. **Worked solution**:
   - **Basis** $n=5$: $2^5=32>25=5^2$. True. (Note $n=2,3,4$ fail: $4\not>4$, $8\not>9$, $16\not>16$ — that is why $n_0=5$.)
   - **IH**: assume $2^k>k^2$ for some $k\geq5$.
   - **Step**: $2^{k+1}=2\cdot2^k>2k^2$ (by IH). It is enough to show $2k^2\geq(k+1)^2$ for $k\geq5$:
     $$2k^2-(k+1)^2 = k^2-2k-1 = (k-1)^2-2 \geq (5-1)^2-2 = 14 > 0.$$
     So $2^{k+1}>2k^2\geq(k+1)^2$, i.e. $2^{k+1}>(k+1)^2$. Done.
   - Verified numerically: holds for all $n\geq5$. (checked: Python — true for $n=5..59$, fails at $n=2,3,4$ as expected)

---

## Opgave 5.1.70

1. **Problem** — Prove that $\displaystyle\sum_{j=1}^{n} j^4 = \frac{n(n+1)(2n+1)(3n^2+3n-1)}{30}$ for every positive integer $n$.

2. **Type** — Induction on $n$, proving a closed-form power-sum formula (summationsformel).

3. **Method** — same recipe as 5.1.11: check basis, assume IH at $k$, add the $(k+1)^4$ term to the IH closed form, factor out the common $(k+1)$, and match to the closed form at $k+1$.

4. **Worked solution**:
   - **Basis** $n=1$: LHS $=1^4=1$. RHS $=\frac{1\cdot2\cdot3\cdot(3+3-1)}{30}=\frac{1\cdot2\cdot3\cdot5}{30}=1$. Match.
   - **IH**: assume $\sum_{j=1}^{k} j^4 = \frac{k(k+1)(2k+1)(3k^2+3k-1)}{30}$.
   - **Step** $n=k+1$: add $(k+1)^4$:
     $$\frac{k(k+1)(2k+1)(3k^2+3k-1)}{30} + (k+1)^4 = \frac{(k+1)\big[k(2k+1)(3k^2+3k-1)+30(k+1)^3\big]}{30}.$$
     The target is $\frac{(k+1)(k+2)(2k+3)(3(k+1)^2+3(k+1)-1)}{30} = \frac{(k+1)(k+2)(2k+3)(3k^2+9k+5)}{30}$.
     So we need $k(2k+1)(3k^2+3k-1)+30(k+1)^3 = (k+2)(2k+3)(3k^2+9k+5)$. Both sides expand to $6k^4+39k^3+91k^2+89k+30$, so they are equal. Hence the formula holds at $k+1$. Done.
   - Verified numerically for $n=1..6$. (checked: Python — LHS = RHS for $n=1..29$, and the polynomial identity holds)
   - **Tip**: at the exam you do not need to expand fully if you can factor cleanly. The safe move is to expand both the "IH + new term" and the "target at $k+1$" into the same standard polynomial and check they agree.

---

## Opgave 2 — Valid induction proofs for $2^n + 3^n < 4^n$, $n\geq2$

1. **Problem** — Exam excerpt (eksamensopgave). The claim is $2^n+3^n<4^n$ for $n\geq2$. Six candidate proofs (a)–(f) are given. Decide which are *valid* induction proofs (gyldige induktionsbeviser).

2. **Type** — Critique / validity check of induction arguments (vurder gyldigheden af induktionsbeviser).

3. **Method** — for each candidate, check the four things that can break:
   1. **Right base case?** The basis must be checked at the smallest $n$ in the claim (here $n=2$). Wrong/missing base case = invalid. (Check: $2^2+3^2=13<16=4^2$ holds; $n=1$ gives $5\not<4$, so $n=2$ is mandatory.)
   2. **Right direction?** The step must prove the $n{+}1$ case *from* the $n$ case (or the $n$ case from $n{-}1$). A step that derives the smaller-index statement from the larger one proves nothing.
   3. **Is the IH actually used, and used at the right index?** Applying the IH to $n+1$ when it was only assumed at $n$ is illegal.
   4. **Is every inequality/equality step true?** One false step kills the proof.
   - Swap-in point: the same checklist applies to any "is this a valid induction proof" exam question.

4. **Worked solution** — verdict per option:

   - **(a) VALID.** Basis $n=2$ correct. Step: from IH $2^n+3^n<4^n$, multiply by 4 (reversible): $4(2^n+3^n)<4^{n+1}$. Then $2^{n+1}+3^{n+1}=2\cdot2^n+3\cdot3^n \leq 4\cdot2^n+4\cdot3^n = 4(2^n+3^n) < 4^{n+1}$. The final $\Rightarrow$ is a true implication. (Verified $2^{n+1}+3^{n+1}\leq4(2^n+3^n)<4^{n+1}$ for $n=2..5$.)

   - **(b) INVALID.** The induction step is identical to (a) and is fine, but the **base case is $n=3$** while the claim starts at $n=2$. The case $n=2$ is never established, so the induction has a hole. Wrong base case.

   - **(c) VALID.** Basis $n=2$ correct. Step is stated "for $n\geq3$" and assumes the statement at $n-1$: $2^{n-1}+3^{n-1}<4^{n-1}$, multiplies by 4 to get $4(2^{n-1}+3^{n-1})<4^n$, and $2^n+3^n=2\cdot2^{n-1}+3\cdot3^{n-1}\leq4(2^{n-1}+3^{n-1})<4^n$. This is just (a) reindexed ($n-1\to n$ instead of $n\to n+1$); base $n=2$ plus step for $n\geq3$ covers all $n\geq2$. Correct.

   - **(d) INVALID.** Basis $n=2$ correct, but the step runs the **wrong direction**: it starts from $2^n+3^n<4^n$ and derives $2^{n-1}+3^{n-1}<4^{n-1}$ — the statement for a *smaller* index. Proving the $n-1$ case from the $n$ case adds nothing; it never propagates the claim upward. Useless step.

   - **(e) VALID.** Basis $n=2$ correct. Step: $2^{n+1}+3^{n+1}=2\cdot2^n+3\cdot3^n < 3(2^n+3^n) < 3\cdot4^n < 4^{n+1}$. First inequality: $2\cdot2^n<3\cdot2^n$, true. Second: IH, used at the correct index $n$. Third: $3\cdot4^n<4\cdot4^n=4^{n+1}$, true. Clean forward proof.

   - **(f) INVALID.** Two faults. The first step claims $\tfrac12\cdot2^{n+1}+\tfrac13\cdot3^{n+1} < \tfrac13(2^{n+1}+3^{n+1})$, which would require $\tfrac12<\tfrac13$ on the $2^{n+1}$ term — **false** (verified: $2^n+3^n=13 \not< 11.67$ at $n=2$). Also the IH is misapplied to $2^{n+1}+3^{n+1}$ when it was only assumed for index $n$. Broken inequality and wrong IH index.

   **Answer: the valid induction proofs are (a), (c), (e). The invalid ones are (b) wrong base case, (d) wrong direction, (f) false step + IH misuse.** (checked: Python — claim $2^n+3^n<4^n$ holds for $n\geq2$ and fails at $n=1$; chains in (a),(c),(e) verified; (f)'s step $13\not<11.67$ at $n=2$.)
