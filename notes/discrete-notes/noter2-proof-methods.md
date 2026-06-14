# Quantifiers (Kvantorer) — Section 1.4

Source: `material/discrete-maths/slides/Noter2.pdf` (8 handwritten pages, SE4-DMAD discrete maths).

Note on topic: the file was expected to cover proof methods, but the actual content is **quantifiers** (Section 1.4): predicates / propositional functions, the universal quantifier (∀), the existential quantifier (∃), domain notation, quantifier precedence, and negation of quantified statements (De Morgan's laws for quantifiers). These notes follow the real content.

---

## Recap from last time (Sidste gang)

Listed as context before the new material:

- **Logical operators (Logiske operatorer)** with precedence hierarchy (præcedens hierarki): ¬, ∧, ∨, ⇒, ⇔, ⊕.
- **Truth tables (Sandhedstabeller).**
- **Equivalences (Ækvivalenser)** — Table 1.3.6–8. Example: $p \Rightarrow q \;\equiv\; \neg q \Rightarrow \neg p$ (contrapositive).
- **Tautology, contradiction, contingency (Tautologi, modstrid, kontingens).** Examples:
  - $p \Rightarrow p$ — tautology.
  - $p \Leftrightarrow \neg p$ — contradiction (modstrid).
  - $p \Rightarrow \neg p$ — contingency.

---

## Quantifiers — overview (Kvantorer)

Two quantifiers:

- **∀ — universal quantifier (Alkvantor)**, read "for all" ("For alle").
- **∃ — existential quantifier (Eksistenskvantor)**, read "there exists" ("Der eksisterer").

---

## Predicates / propositional functions (Åbent udsagn)

A statement with a **free variable (fri variabel)** is an **open statement (åbent udsagn)**, also called a **propositional function**. Plugging a value into the variable turns it into a proposition with a definite truth value.

Notation: $P(x)$.

**Example:** $P(x): 2x > x$. Here $x$ is the free variable; $2x > x$ is the open statement.

Plugging in values:

| Call | Statement | Truth value |
|------|-----------|-------------|
| $P(-1)$ | $-2 > -1$ | F (falsk) |
| $P(0)$ | $0 > 0$ | F |
| $P(1)$ | $2 > 1$ | S (sand) |
| $P(2)$ | $4 > 2$ | S |

And $P(1) \wedge P(2) \wedge P(3) \wedge \dots$ is **S** (true). This infinite conjunction is exactly what the universal quantifier captures.

(S = sand = true, F = falsk = false.)

---

## The universal quantifier (Alkvantoren)

The universal quantifier turns an infinite conjunction into one statement:

$$P(1) \wedge P(2) \wedge P(3) \wedge \dots \;\;\Longleftrightarrow\;\; \forall x \in \mathbb{Z}^+ : P(x) \;\;\Longleftrightarrow\;\; \forall x \in \mathbb{Z}^+ : 2x > x$$

Parts of $\forall x \in \mathbb{Z}^+ : 2x > x$:

- **∀** = the universal quantifier (Alkvantor / universal quantifier), "for all" ("for alle").
- **$x \in \mathbb{Z}^+$** names the **universe / domain (univers / domæne)**. Sometimes omitted if understood (udelades sommetider, hvis det er underforstået).
- **:** reads "such that / holds" ("gælder"). Some omit the colon (the textbook does), some use a comma instead.
- **$x$** is the **bound variable (bunden variabel)**.
- **$2x > x$** is the statement (udsagn).

Three equivalent English readings of $\forall x \in \mathbb{Z}^+ : 2x > x$:

- "For all $x$ in the set of positive integers, $2x > x$ holds."
- "For all positive integers $x$, $2x > x$ holds."
- "For every positive integer $x$, $2x > x$ holds."

### Example with a restricted domain

$Q(x): 2x > x + 4$.

This chain shows four equivalent ways to express the same true ∀ statement, narrowing the domain into a condition:

$$Q(5) \wedge Q(6) \wedge Q(7) \wedge \dots \quad \text{(S)}$$
$$\Longleftrightarrow \forall x \in \{5,6,7,\dots\} : 2x > x+4$$
$$\Longleftrightarrow \forall x \in \mathbb{Z},\, x \geq 5 : 2x > x+4$$
$$\Longleftrightarrow \forall x \in \mathbb{Z} : (x \geq 5 \;\Rightarrow\; 2x > x+4)$$

Key pattern (boxed "Notation" in the notes): a **restricted domain on a ∀ becomes an implication** $\Rightarrow$. "For all $x$ with property $A$, $B$ holds" = $\forall x : (A \Rightarrow B)$.

Contrast — over the full positive integers it is **false**:

$$\forall x \in \mathbb{Z}^+ : Q(x) \;\Longleftrightarrow\; Q(1) \wedge Q(2) \wedge Q(3) \wedge \dots \quad \text{(F)}$$

(e.g. $Q(1): 2 > 5$ is false, so the conjunction fails.)

---

## The existential quantifier (Eksistenskvantoren)

The existential quantifier turns an infinite **disjunction** into one statement:

$$Q(1) \vee Q(2) \vee Q(3) \vee \dots \quad (\text{S}) \;\;\Longleftrightarrow\;\; \exists x \in \mathbb{Z}^+ : Q(x)$$

Parts:

- **∃** = existential quantifier (Eksistenskvantor / existential quantifier), "there exists" ("Der eksisterer").
- **:** reads "such that" ("sådan at").

Examples (with $Q(x): 2x > x+4$):

- $\exists x \in \mathbb{Z} : Q(x)$ — **S** (true).
- Restricted-domain chain, all equivalent and **S**:
$$\exists x \in \{10,11,12,\dots\} : Q(x)$$
$$\Longleftrightarrow \exists x \in \mathbb{Z},\, x \geq 10 : Q(x)$$
$$\Longleftrightarrow \exists x \in \mathbb{Z} : (x \geq 10 \;\wedge\; Q(x))$$
- $\exists x \in \mathbb{Z},\, x \leq 2 : Q(x)$ — **F** (false).

Key pattern: a **restricted domain on a ∃ becomes a conjunction** $\wedge$. "There exists $x$ with property $A$ such that $B$" = $\exists x : (A \wedge B)$.

(Contrast with ∀, which uses $\Rightarrow$. This pairing — ∀ with ⇒, ∃ with ∧ — is the thing to remember.)

---

## Quantifier precedence (Præcedens)

Quantifiers have **higher precedence (højere præcedens)** than the operators from last time (¬, ∧, ∨, ⇒, ⇔, ⊕).

**Example:**

$$\forall x \in \mathbb{Z} : (x < 2 \;\Rightarrow\; -x > -2)$$

The parentheses are **not redundant** (parenteserne er ikke overflødige). Because ∀ binds tighter, without parentheses the ∀ would only attach to $x < 2$, not to the whole implication.

---

## Negation of quantified statements (Negering af kvantificerede udsagn)

**Setup example:**
- $S$: the set of participants in SE4-DMAD (mængden af deltagere).
- $P(x)$: "$x$ attends this lecture" ($x$ deltager i denne forelæsning).

The two negation rules:

$$\neg\,\forall x \in S : P(x) \quad\Longleftrightarrow\quad \exists x \in S : \neg P(x)$$
$$\neg\,\exists x \in S : P(x) \quad\Longleftrightarrow\quad \forall x \in S : \neg P(x)$$

In words: "not everyone attends" = "someone does not attend"; "no one attends" = "everyone does not attend".

### Worked negation 1

$$\neg\,\forall x \in \mathbb{Z} : 2x > x$$
$$\Longleftrightarrow \exists x \in \mathbb{Z} : \neg(2x > x)$$
$$\Longleftrightarrow \exists x \in \mathbb{Z} : 2x \leq x$$

The negation moves inside and flips $>$ to $\leq$.

### Worked negation 2

$$\neg\,\exists x \in \mathbb{Z}^- : 2x > x$$
$$\Longleftrightarrow \forall x \in \mathbb{Z}^- : \neg(2x > x)$$
$$\Longleftrightarrow \forall x \in \mathbb{Z}^- : 2x \leq x$$

($\mathbb{Z}^-$ = negative integers.)

---

## De Morgan's laws for quantifiers (De Morgans Love for Kvantorer)

The general rules (boxed in the notes):

$$\neg\,\forall x : P(x) \;\equiv\; \exists x : \neg P(x)$$
$$\neg\,\exists x : P(x) \;\equiv\; \forall x : \neg P(x)$$

Notation: $\nexists$ is also written instead of $\neg \exists$ ("Man skriver også $\nexists$ i stedet for $\neg\exists$").

### Worked example

$$\neg\,\forall x \in \mathbb{N} : (2x \geq 4 \;\vee\; 2x < 2^x)$$
$$\Longleftrightarrow \exists x \in \mathbb{N} : (2x < 4 \;\wedge\; 2x \geq 2^x) \quad \text{(S, e.g. } x = 1)$$

Notice the full De Morgan cascade: ¬∀ becomes ∃, then ¬ pushes inside the parentheses, flipping ∨ to ∧ and negating each inner statement ($2x \geq 4$ becomes $2x < 4$, and $2x < 2^x$ becomes $2x \geq 2^x$). Witness: $x = 1$ gives $2 < 4$ (true) and $2 \geq 2$ (true), so the conjunction holds and the statement is **S**.

---

## Cheat sheet

- Open statement / propositional function: $P(x)$, has a free variable.
- ∀ = "for all", an infinite ∧; restricted domain → implication $\Rightarrow$.
- ∃ = "there exists", an infinite ∨; restricted domain → conjunction $\wedge$.
- Quantifiers bind tighter than ¬ ∧ ∨ ⇒ ⇔ ⊕ — use parentheses.
- Negation: push ¬ inward, swap ∀ ↔ ∃, negate the inner statement. $\nexists \equiv \neg\exists$.
