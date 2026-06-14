# DM03 — Predicate Logic: Quantifiers and Negation

Source: `material/discrete-maths/exercises/opgaverDM03.pdf` (SE4-DMAD, uge 10). Rosen problems are from Section 1.5 (Nested Quantifiers), 7th edition.

This set drills nested quantifiers (∀, ∃): reading mixed quantifier statements in English, deciding the truth value of statements over a stated domain (N, Z, R), and negating quantified statements by pushing ¬ inward. The two exam problems test the same skills — order of quantifiers matters, and you negate by swapping each quantifier and negating the predicate.

> Note on Rosen wording: the PDF only cites problem numbers, so the statements below are the Section 1.5 problems from Rosen's 7th edition. If your edition numbers differ, the *method* is what carries over — swap in your own predicate/domain.

---

## Opgave 1 — Afsnit 1.5, Opgave 9 a–d

**Problem.** Let $P(x,y)$ be "Student $x$ has taken class $y$" (Da: "Studerende $x$ har taget kursus $y$"). Domain of $x$ = all students in your class; domain of $y$ = all computer-science courses at your school. Express each quantification in English.
- a) $\exists x\, \exists y\, P(x,y)$
- b) $\exists x\, \forall y\, P(x,y)$
- c) $\forall x\, \exists y\, P(x,y)$
- d) $\exists y\, \forall x\, P(x,y)$

**Type.** Translate nested-quantifier logic into natural language.

**Method (any instance).**
1. Read the quantifiers left to right; that is the order of "binding."
2. Map each symbol: $\forall x$ = "for every $x$ / every student", $\exists x$ = "there is some $x$ / some student". Do the same for $y$.
3. A leading $\exists x \forall y$ means "one fixed $x$ works for all $y$"; a leading $\forall x \exists y$ means "each $x$ may use its own $y$." Watch this distinction — it is the whole point.
4. State it as one clean English sentence.

**Worked solution.**
- a) $\exists x \exists y\,P(x,y)$: "Some student in your class has taken some computer-science course." (At least one student–course pair exists.)
- b) $\exists x \forall y\,P(x,y)$: "There is a student in your class who has taken every computer-science course offered." (One student covers all courses.)
- c) $\forall x \exists y\,P(x,y)$: "Every student in your class has taken at least one computer-science course." (Each student has some course, possibly different ones.)
- d) $\exists y \forall x\,P(x,y)$: "There is a computer-science course that every student in your class has taken." (One course taken by all students.)

Compare b and d: b = one student / all courses; d = one course / all students. Order of $\exists$ and $\forall$ flips the meaning.

---

## Opgave 2 — Afsnit 1.5, Opgave 19 (which statements are true?)

**Problem.** Domain of every variable = all real numbers $\mathbb{R}$. Determine the truth value of each.
- a) $\forall x\, \exists y\,(x^2 = y)$
- b) $\forall x\, \exists y\,(x = y^2)$
- c) $\exists x\, \forall y\,(xy = 0)$
- d) $\exists x\, \exists y\,(x + y \neq y + x)$
- e) $\forall x\,(x \neq 0 \rightarrow \exists y\,(xy = 1))$
- f) $\exists x\, \forall y\,(y \neq 0 \rightarrow xy = 1)$

**Type.** Decide truth value of nested-quantifier statements over a numeric domain.

**Method (any instance).**
1. Process quantifiers outside-in. For $\forall$ you must handle *every* value; one counterexample makes it false. For $\exists$ you only need *one* witness; finding one makes that part true.
2. For "$\forall x \exists y\,(\ldots)$": treat $x$ as fixed/arbitrary, then try to give $y$ as a formula in $x$. If a formula always works → true.
3. For "$\exists x \forall y\,(\ldots)$": try to find one $x$ that makes the inner $\forall y$ statement hold for all $y$. If you find it → true; if you can argue no single $x$ works → false.
4. To kill a $\forall$, exhibit one concrete counterexample. To kill an $\exists$, argue no value can work.

**Worked solution.**
- a) **True.** Fix any $x$; choose $y = x^2$. Then $x^2 = y$ holds. A witness $y$ exists for every $x$.
- b) **False.** Counterexample $x = -1$: we would need a real $y$ with $y^2 = -1$. No real square is negative, so no $y$ exists. The $\forall x$ fails.
- c) **True.** Choose $x = 0$. Then $0\cdot y = 0$ for every $y$, so the inner $\forall y$ holds. One witness $x$ suffices.
- d) **False.** Addition of reals is commutative, $x + y = y + x$ for all $x,y$, so $x+y \neq y+x$ never happens. No witness pair exists.
- e) **True.** Take any $x \neq 0$; choose $y = 1/x$ (defined since $x\neq 0$). Then $xy = 1$. If $x = 0$ the implication is vacuously true. Holds for all $x$.
- f) **False.** We would need one fixed $x$ with $xy = 1$ for *every* nonzero $y$. That forces $x = 1/y$, which changes with $y$ — no single $x$ works. (E.g. if $x$ fixes $y=1$ so $x=1$, then $y=2$ gives $xy=2\neq 1$.)

**True:** a, c, e. **False:** b, d, f. (checked: Python)

---

## Opgave 3 — Afsnit 1.5, Opgave 39

**Problem.** Find a common domain for the variables $x$, $y$, $z$ for which the statement
$$\forall x\, \forall y\,((x \neq y) \rightarrow \forall z\,((z = x) \lor (z = y)))$$
is true, and another common domain for which it is false.

**Type.** Construct domains making a quantified statement true / false (interpretation / model building).

**Method (any instance).**
1. Read what the statement asserts as a property of the domain. Here: whenever two distinct elements $x,y$ exist, *every* element $z$ equals one of them — i.e. the domain has at most two elements.
2. For TRUE: pick a domain that satisfies that property. (Edge case: if there are fewer than two distinct elements, the premise $x\neq y$ is never satisfiable, so the implication is vacuously true.)
3. For FALSE: pick a domain that violates it — find specific $x,y,z$ where the premise holds but the conclusion fails. (Need at least three distinct elements.)

**Worked solution.**
- The statement says: any two distinct elements are the *only* elements — so it is true exactly when the domain has at most two members.
- **True domain:** any set with $\le 2$ elements, e.g. $\{1, 2\}$ (or $\{0\}$, or $\emptyset$). With $\{1,2\}$: the only distinct pair is $1,2$, and every $z\in\{1,2\}$ equals $1$ or $2$. True.
- **False domain:** any set with $\ge 3$ elements, e.g. $\{1, 2, 3\}$. Take $x=1$, $y=2$ (distinct, premise holds), $z = 3$: then $z\neq x$ and $z\neq y$, so the conclusion fails. The whole statement is false.

---

## Opgave 4 — Exam February 2015

### 4a — Which statements are true?
**Problem.** $\mathbb{N} = \{0,1,2,\ldots\}$.
- i. $\forall x \in \mathbb{N}\, \exists y \in \mathbb{N}: x < y$
- ii. $\exists y \in \mathbb{N}\, \forall x \in \mathbb{N}: x < y$

**Type.** Truth value of nested quantifiers over $\mathbb{N}$; order-of-quantifiers trap.

**Method.** Same as Opgave 2: $\forall x \exists y$ lets $y$ depend on $x$; $\exists y \forall x$ demands one $y$ that beats every $x$.

**Worked solution.**
- i. **True.** Fix any $x \in \mathbb{N}$; choose $y = x+1 \in \mathbb{N}$. Then $x < x+1$. A larger natural always exists.
- ii. **False.** This claims a single natural $y$ greater than *every* natural $x$ — a largest natural number. $\mathbb{N}$ has no maximum (given any $y$, take $x = y$, then $x < y$ is false). So no such $y$.

Same predicate $x<y$, only the quantifier order changed, and the truth value flipped. i is true, ii is false. (checked: Python)

### 4b — Negate statement i, no ¬ allowed
**Problem.** Give the negation of i ($\forall x \in \mathbb{N}\, \exists y \in \mathbb{N}: x < y$) with the $\neg$ operator not appearing in the result.

**Type.** Negate a quantified statement and push the negation onto the predicate.

**Method (any instance).**
1. Move $\neg$ inward one quantifier at a time using $\neg\forall x\,P \equiv \exists x\,\neg P$ and $\neg\exists y\,Q \equiv \forall y\,\neg Q$. (Each quantifier flips.)
2. Finally negate the inner predicate directly — replace it with its opposite relation, no $\neg$ symbol. ($\neg(a<b)$ becomes $a \ge b$.)

**Worked solution.**
$$\neg\big(\forall x \in \mathbb{N}\, \exists y \in \mathbb{N}: x < y\big) \equiv \exists x \in \mathbb{N}\, \forall y \in \mathbb{N}: \neg(x<y) \equiv \boxed{\exists x \in \mathbb{N}\, \forall y \in \mathbb{N}: x \ge y}$$
In words: "there is a natural number $x$ that is greater than or equal to every natural number $y$" (a largest natural). This is false, as it should be — it is the negation of the true statement i.

---

## Opgave 5 — Exam January 2014

**Problem.** Give the truth value of each. $\mathbb{N} = \{0,1,2,\ldots\}$, $\mathbb{Z} = \{\ldots,-2,-1,0,1,2,\ldots\}$.
- a) $\forall x \in \mathbb{N}\, \forall y \in \mathbb{N}: x + y \ge 0$
- b) $\forall x \in \mathbb{Z}\, \forall y \in \mathbb{Z}: x + y \ge 0$
- c) $\forall x \in \mathbb{Z}\, \exists y \in \mathbb{Z}: x + y \ge 0$

**Type.** Truth value of quantified statements; same predicate, different domain / quantifier.

**Method.** For $\forall\forall$, the statement must hold for *all* pairs — one bad pair kills it. For $\forall x \exists y$, each $x$ may pick its own $y$.

**Worked solution.**
- a) **True.** Both $x,y \in \mathbb{N}$ are $\ge 0$, so $x+y \ge 0$ for every pair. The smallest case is $0+0 = 0 \ge 0$.
- b) **False.** Now $x,y$ range over all integers. Counterexample $x = -1$, $y = -1$: $x+y = -2 \ge 0$ is false. One pair breaks the $\forall$.
- c) **True.** Fix any $x \in \mathbb{Z}$; choose $y = -x \in \mathbb{Z}$. Then $x + y = 0 \ge 0$. (Or any $y \ge -x$.) A witness exists for every $x$.

Compare a and b: same statement, widening the domain from $\mathbb{N}$ to $\mathbb{Z}$ turns it false. Compare b and c: weakening $\forall y$ to $\exists y$ turns it true again. (checked: Python)
