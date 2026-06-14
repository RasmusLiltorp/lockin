# SE4-DMAD June 2024

Source: `material/discrete-maths/old-exam/Uddrag af eksamen i SE4-DMAD juni 2024.pdf` (SE4-DMAD, eksamen juni 2024). No official answer key; solutions worked out here.

Overview: a multiple-choice exam excerpt. Topics are propositional logic / tautologies, predicate logic with quantifiers, proof techniques (direct, contrapositive), relation properties (reflexive/symmetric/antisymmetric/transitive), and equivalence relations. For each question you decide which listed sub-statements are true.

---

## Question 1 (3%) — Tautologies

1. **Problem.** Let $p,q$ be propositions. Which statements are tautologies (sande uanset sandhedsværdier — true for all truth values)?
   - 1.a: If $p$ is false, then $p \land q$ is false.
   - 1.b: If $p$ is false, then $p \Rightarrow q$ is false.
   - 1.c: $p \land q$ is true iff $\lnot p \lor \lnot q$ is false.

2. **Type.** Propositional logic, tautology check.

3. **Method (any instance).**
   1. Translate each statement into a formula. "If A then B" = $A \Rightarrow B$; "A iff B" = $A \Leftrightarrow B$.
   2. A statement is a tautology iff it is true on every row of the truth table (here 4 rows: the input is the two vars $p,q$).
   3. Build the table or find one counterexample row. One false row kills it.

4. **Worked solution.**
   - 1.a: $\lnot p \Rightarrow \lnot(p\land q)$. If $p$ false, $p\land q$ is false regardless of $q$, so the conclusion always holds. **Tautology — TRUE.**
   - 1.b: $\lnot p \Rightarrow \lnot(p\Rightarrow q)$. But when $p$ is false, $p\Rightarrow q$ is *true* (vacuously), so $\lnot(p\Rightarrow q)$ is false. Counterexample $p=F$: the implication's conclusion is false while premise true. **Not a tautology — FALSE.**
   - 1.c: $(p\land q) \Leftrightarrow \lnot(\lnot p \lor \lnot q)$. By De Morgan $\lnot(\lnot p\lor\lnot q)=p\land q$, so both sides identical. **Tautology — TRUE.**

   **Answer: 1.a and 1.c are tautologies; 1.b is not.** (checked: Python)

---

## Question 2 (3%) — True statements about logic

1. **Problem.** Let $p,q$ be propositions. Which are true?
   - 2.a: $p\Rightarrow q$ is equivalent to $\lnot p \lor q$.
   - 2.b: $(p\Rightarrow q)\land(\lnot p\Rightarrow\lnot q)$ is equivalent to $p\Leftrightarrow q$.
   - 2.c: The truth table for $p\lor(\lnot p\land q)$ has 8 rows.

2. **Type.** Logical equivalence + truth-table sizing.

3. **Method (any instance).**
   1. For "$X$ equivalent to $Y$": check $X\Leftrightarrow Y$ is a tautology (compare columns of a truth table).
   2. Number of rows in a truth table $= 2^{(\text{number of distinct propositional variables})}$.

4. **Worked solution.**
   - 2.a: Standard implication law: $p\Rightarrow q \equiv \lnot p\lor q$. **TRUE.**
   - 2.b: $(p\Rightarrow q)\land(\lnot p\Rightarrow\lnot q)$. $\lnot p\Rightarrow\lnot q \equiv q\Rightarrow p$. So the conjunction is $(p\Rightarrow q)\land(q\Rightarrow p)=p\Leftrightarrow q$. **TRUE.**
   - 2.c: Only two variables $p,q$, so $2^2=4$ rows, not 8. **FALSE.**

   **Answer: 2.a and 2.b true; 2.c false.** (checked: Python)

---

## Question 3 (6%) — Quantified statements

1. **Problem.** Which statements over $\mathbb{Z}$ are true?
   - 3.a: $\forall n\in\mathbb{Z}: (n\ge 2 \Rightarrow 2n>3)$
   - 3.b: $\lnot\forall n\in\mathbb{Z}: n=2 \;\Leftrightarrow\; \forall n\in\mathbb{Z}: n\ne 2$
   - 3.c: $\exists n\in\mathbb{Z}: n\ne 3$
   - 3.d: $\forall n\in\mathbb{Z}:\exists k\in\mathbb{Z}: n>2k$
   - 3.e: $\exists k\in\mathbb{Z}:\forall n\in\mathbb{Z}: n>2k$
   - 3.f: $\lnot\exists n\in\mathbb{Z}:\forall k\in\mathbb{Z}: n>2k \;\Leftrightarrow\; \forall n\in\mathbb{Z}:\exists k\in\mathbb{Z}: n\le 2k$

2. **Type.** Predicate logic, nested quantifiers, negation of quantifiers.

3. **Method (any instance).**
   1. $\forall$: true unless you find one counterexample. $\exists$: true if you find one witness.
   2. Nested $\forall n\,\exists k$: $k$ may depend on $n$ (pick $k$ per $n$). $\exists k\,\forall n$: one fixed $k$ must work for all $n$ — much stronger.
   3. Quantifier negation: $\lnot\forall x\,P \equiv \exists x\,\lnot P$ and $\lnot\exists x\,P \equiv \forall x\,\lnot P$.
   4. For a $\Leftrightarrow$, evaluate both sides to T/F, then T⇔T or F⇔F = true; T⇔F = false.

4. **Worked solution.**
   - 3.a: $n\ge2\Rightarrow 2n\ge4>3$, true for every $n$. **TRUE.**
   - 3.b: LHS $\lnot\forall n: n=2$ — "not all integers equal 2" is **true**. RHS $\forall n: n\ne2$ — "every integer $\ne 2$" is **false** (since $2\ne2$ fails). $T\Leftrightarrow F$. **FALSE.**
   - 3.c: e.g. $n=0\ne3$. **TRUE.**
   - 3.d: For each $n$ pick $k$ with $k<n/2$, e.g. $k=n-1$ gives $2k=2n-2$ and $n>2n-2 \Leftrightarrow n<2$ — not always. Cleaner: $k$ can depend on $n$, so just take any $k$ below $n/2$ (e.g. $k=\lfloor n/2\rfloor-1$, then $2k\le n-2<n$). Always possible. **TRUE.**
   - 3.e: One fixed $k$ with $n>2k$ for *all* $n$ is impossible (take $n=2k$). **FALSE.**
   - 3.f: LHS $\lnot\exists n\,\forall k: n>2k$. Inner $\exists n\,\forall k: n>2k$ is false (no single $n$ beats $2k$ for all $k$, since $k$ can be huge). So $\lnot(\text{false})=$ **true**. RHS $\forall n\,\exists k: n\le2k$ — for each $n$ pick $k$ large, true. $T\Leftrightarrow T$. **TRUE.**

   **Answer: 3.a, 3.c, 3.d, 3.f true; 3.b, 3.e false.** (checked: Python; 3.e is false over all of $\mathbb{Z}$ since any fixed $k$ fails at $n=2k$.)

---

## Question 4 (5%) — Valid proofs that "n odd ⇒ 3n odd"

1. **Problem.** Which options correctly prove: for any integer $n$, if $n$ is odd (ulige) then $3n$ is odd?
   - 4.a: $n$ odd $\Rightarrow n=2k+1$; $3n=3(2k+1)=2(3k+1)+1$ → $3n$ odd. (direct)
   - 4.b: $n=2k+1$; $3n=2n+n=2n+2k+1=2(n+k)+1$ → odd. (direct)
   - 4.c: assume $3n$ even, $3n=2k$; $n=3n-2n=2k-2n=2(k-n)$ → $n$ even. (contrapositive)
   - 4.d: $n$ even $\Rightarrow n=2k$; $3n=2\cdot 3k$ → $3n$ even.
   - 4.e: assume $3n$ odd, $3n=2k+1$; $n=3n-2n=2(k-n)+1$ → $n$ odd.

2. **Type.** Evaluating proof strategies (direct vs contrapositive vs irrelevant).

3. **Method (any instance).**
   1. Statement is $P\Rightarrow Q$ (here $P=$ "$n$ odd", $Q=$ "$3n$ odd").
   2. A **direct** proof assumes $P$, derives $Q$. Valid.
   3. A **contrapositive** proof assumes $\lnot Q$, derives $\lnot P$ (here: $3n$ even ⇒ $n$ even). Valid and equivalent.
   4. Reject anything proving a *different* statement: the converse $Q\Rightarrow P$, the inverse $\lnot P\Rightarrow\lnot Q$, or an unrelated claim. Also check the algebra is sound.

4. **Worked solution.**
   - 4.a: Direct, algebra correct ($3(2k+1)=6k+3=2(3k+1)+1$). **VALID.**
   - 4.b: Direct, algebra correct. **VALID.**
   - 4.c: Contrapositive ($3n$ even ⇒ $n$ even), algebra correct: $n=3n-2n=2k-2n=2(k-n)$. This is exactly $\lnot Q\Rightarrow\lnot P$. **VALID.**
   - 4.d: Proves "$n$ even ⇒ $3n$ even" — the *inverse*, a different statement. **NOT a valid proof.**
   - 4.e: Assumes $3n$ odd and concludes $n$ odd, i.e. proves $Q\Rightarrow P$ (the *converse*). Does not prove $P\Rightarrow Q$. **NOT a valid proof.**

   **Answer: 4.a, 4.b, 4.c are correct proofs; 4.d and 4.e are not.** (checked: logic — direct, direct, contrapositive valid; 4.d proves the inverse, 4.e the converse.)

---

## Question 5 (4%) — Properties of a relation

1. **Problem.** On $\{a,b,c,d\}$ with
   $$R=\{(a,a),(a,b),(b,c),(b,d),(c,a),(c,c),(c,d),(d,a)\}.$$
   Decide: 5.a reflexive, 5.b symmetric, 5.c antisymmetric, 5.d transitive.

2. **Type.** Relation property checking.

3. **Method (any instance).**
   1. **Reflexive (refleksiv):** every $(x,x)$ present for all elements. Check the diagonal.
   2. **Symmetric (symmetrisk):** for every $(x,y)\in R$ also $(y,x)\in R$.
   3. **Antisymmetric (antisymmetrisk):** no pair $x\ne y$ with both $(x,y)$ and $(y,x)$ in $R$.
   4. **Transitive (transitiv):** whenever $(x,y)$ and $(y,z)$ in $R$, also $(x,z)\in R$.
   5. For each, hunt one counterexample.

4. **Worked solution.**
   - 5.a Reflexive: need $(a,a),(b,b),(c,c),(d,d)$. $(b,b)$ and $(d,d)$ missing. **FALSE.**
   - 5.b Symmetric: $(a,b)\in R$ but $(b,a)\notin R$. **FALSE.**
   - 5.c Antisymmetric: scan all $x\ne y$ pairs — no pair has both directions (e.g. $(a,b)$ in, $(b,a)$ out; $(b,c)$ in, $(c,b)$ out; etc.). **TRUE.**
   - 5.d Transitive: $(a,b)$ and $(b,c)$ in $R$ but $(a,c)\notin R$. **FALSE.**

   **Answer: only 5.c (antisymmetric) is true.** (checked: Python)

---

## Question 6 (4%) — Which relations are equivalence relations

1. **Problem.** On $\{a,b,c\}$, which are equivalence relations (ækvivalensrelationer)?
   - 6.a: $\{(a,a),(b,b),(c,c)\}$
   - 6.b: $\{(a,a),(a,b),(b,a),(b,b)\}$
   - 6.c: $\{(a,a),(a,b),(b,b),(c,c)\}$
   - 6.d: $\{(a,a),(a,b),(b,b),(b,c),(c,c)\}$
   - 6.e: $\{(a,a),(a,b),(b,a),(b,b),(c,c)\}$

2. **Type.** Equivalence-relation test.

3. **Method (any instance).**
   An equivalence relation is reflexive + symmetric + transitive. Check all three; fail any one and it's out.
   1. Reflexive: all $(x,x)$ present for every element of the base set (here $a,b,c$).
   2. Symmetric: every $(x,y)$ has its mirror $(y,x)$.
   3. Transitive: $(x,y),(y,z)\Rightarrow(x,z)$.

4. **Worked solution.**
   - 6.a: diagonal only. Reflexive yes, symmetric yes, transitive yes. **Equivalence.**
   - 6.b: missing $(c,c)$ → not reflexive on $\{a,b,c\}$. **No.**
   - 6.c: has $(a,b)$ but not $(b,a)$ → not symmetric. **No.**
   - 6.d: has $(a,b)$ no $(b,a)$ → not symmetric (also transitivity would fail). **No.**
   - 6.e: reflexive ($aa,bb,cc$), symmetric ($ab$&$ba$), transitive (the $\{a,b\}$ block plus $c$ alone). **Equivalence.**

   **Answer: 6.a and 6.e are equivalence relations.** (checked: Python)
