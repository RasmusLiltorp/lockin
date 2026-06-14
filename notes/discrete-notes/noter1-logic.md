# Logic: Propositions, Truth Tables, Logical Operators

Source: `material/discrete-maths/slides/Noter1.pdf` (SE4-DMAD, Discrete Mathematics half, sections 1.1, 1.3, 1.4).

This is lecture 1 of the discrete maths track. It covers propositions (udsagn), the six logical operators and their truth tables, logical equivalence between implication and its contrapositive, biconditional, De Morgan's laws, XOR, operator precedence, the tautology/contradiction/contingency classification, and number-set notation. The S/F coloring in the source is Danish: **S = sand (true)**, **F = falsk (false)**.

---

## 0. Course context (front matter)

The course is *Diskret Matematik, Algoritmer & Datastrukturer*. Topics (Emner):

- **Logik (Logic)** — chapter 1.
- **Bevismetoder (Proof methods)** — chapters 1+5.
- **Relationer (Relations)** — chapter 9.

Logic subtopics: logical operators (logiske operatorer), truth tables (sandhedstabeller), equivalences (ækvivalenser) — all in one day; quantifiers (kvantorer) — next two weeks.

Proof methods (three weeks): direct proof (direkte bevis), contrapositive proof (kontrapositionsbevis), contradiction proof (modstridsbevis), induction proof (induktionsbevis).

Relations (three weeks): properties (reflexive, symmetric, antisymmetric, transitive), closures (lukninger), equivalence relation (reflexive + symmetric + transitive), partial order (partiel ordning: reflexive + antisymmetric + transitive).

This file only covers the logic content (the rest is just the syllabus overview).

---

## 1. Proposition (Logisk udsagn)

**Definition.** A proposition (logisk udsagn) is a statement (påstand) that is either true (sand) or false (falsk) — exactly one of the two.

Examples:
- `1 + 1 = 2` → S (true)
- `3 > 5` → F (false)

---

## 2. Logical operators (Logiske operatorer)

The six operators (connectives) used: `¬  ∧  ∨  ⇒  ⇔  ⊕`.

Negation example:
- `¬(1 + 1 = 2)` ≡ `1 + 1 ≠ 2` → F
- `¬(3 > 5)` ≡ `3 ≤ 5` → S

All operators are defined via truth tables (sandhedstabeller).

### 2.1 Negation (Negering)

`¬p` is p's negation: "ikke p" / "p er falsk".

| p | ¬p |
|---|----|
| S | F  |
| F | S  |

### 2.2 Conjunction (Konjunktion)

`p ∧ q`: p and q are **both** true (begge sande). Danish "og" = and.

### 2.3 Disjunction (Disjunktion)

`p ∨ q`: **at least one** of p and q is true (mindst et af p og q er sandt). Danish "eller" = or. This is inclusive or.

Combined truth table for ∧ and ∨:

| p | q | p ∧ q | p ∨ q |
|---|---|-------|-------|
| S | S | S     | S     |
| S | F | F     | S     |
| F | S | F     | S     |
| F | F | F     | F     |

Example of compound propositions (sammensatte udsagn):
- `1 + 1 = 2 ∧ 3 > 5` → F (because 3 > 5 is false)
- `1 + 1 = 2 ∨ 3 > 5` → S (because 1+1=2 is true)

---

## 3. Implication (Implikation / betinget udsagn)

`p ⇒ q`: "p medfører q" (p implies q). English: implication / conditional statement.

Terminology for the parts:
- **p** = hypothesis / assumption (hypotese / antagelse) — also premise / antecedent.
- **q** = conclusion / consequence (konklusion / konsekvens).

Notation note: the book uses `→`; the course more commonly uses `⇒`.

Truth table:

| p | q | p ⇒ q |
|---|---|-------|
| S | S | S     |
| S | F | F     |
| F | S | S     |
| F | F | S     |

The only false row is S ⇒ F. A false hypothesis makes the implication true regardless of q (vacuously true). Rule of thumb from the notes: *"Hvis I ikke kan bevise, det er falsk, er det sandt"* — if you can't prove it false, it's true.

Readings of `p ⇒ q`:
- p medfører q (p implies q)
- Hvis p, så q (if p, then q)
- q, hvis p (q if p)
- **p er en tilstrækkelig betingelse for q** (p is a sufficient condition for q)

### 3.1 Worked example — Lene/dates

Reading `date ⇒ statement`:
- `13. feb. ⇒ Lene forelæser` → S
- `13. feb. ⇒ Lene giver kage` → F
- `12. feb. ⇒ Lene forelæser` → S
- `12. feb. ⇒ Lene giver kage` → S (hypothesis "12. feb." is false on the lecture day, so the implication holds vacuously)

### 3.2 Worked example — quantified implications (section 1.4)

`∀x ∈ ℤ` reads "for ethvert heltal x gælder" (for every integer x).

`∀x ∈ ℤ: x > 0 ⇒ 2x ≥ x` → **S** (true). Checking cases:
- x = 1: S ⇒ S → S
- x = 0: F ⇒ S → S
- x = −1: F ⇒ F → S

`∀x ∈ ℤ: x ≥ −1 ⇒ 2x ≥ x` → **F** (false). Counterexample:
- x = −1: S ⇒ F → F (since x ≥ −1 holds but 2(−1) = −2 ≥ −1 is false). One false instance kills the ∀ statement.

### 3.3 Worked example — train ticket

- b: "Du har købt billet" (you have bought a ticket)
- t: "Du kan tage toget" (you can take the train)
- `b ⇒ t`: if you bought a ticket, you can take the train.

What if you did NOT buy a ticket? The statement says nothing (maybe you have a travel card / rejsekort). What if you canNOT take the train? Then you did not buy a ticket (because if you had, you could take it). This is the contrapositive: `b ⇒ t ≡ ¬t ⇒ ¬b`.

---

## 4. Contrapositive and the equivalence `p ⇒ q ≡ ¬q ⇒ ¬p`

Truth table proving the equivalence:

| p | q | p ⇒ q | ¬q | ¬p | ¬q ⇒ ¬p |
|---|---|-------|----|----|---------|
| S | S | S     | F  | F  | S       |
| S | F | F     | S  | F  | F       |
| F | S | S     | F  | S  | S       |
| F | F | S     | S  | S  | S       |

The `p ⇒ q` column and the `¬q ⇒ ¬p` column are identical, so:

**`p ⇒ q ≡ ¬q ⇒ ¬p`** (Tabel 1.3.7, line 2, p. 29).

This equivalence motivates two more readings of `p ⇒ q`:
- p kun hvis q (p only if q)
- **q er en nødvendig betingelse for p** (q is a necessary condition for p) — note this is the necessary-condition reading, distinct from the sufficient-condition reading in 3.

### 4.1 Naming the related conditionals

For `p ⇒ q`:
- **`¬q ⇒ ¬p`** = the **contrapositive** (kontrapositive udsagn). Equivalent to `p ⇒ q` (shown above).
- **`q ⇒ p`** = the **converse** (omvendte udsagn).
- **`¬p ⇒ ¬q`** = the **inverse** (inverse udsagn). Equivalent to the converse `q ⇒ p`.

The notes flag that the equivalence `p ⇒ q ≡ ¬q ⇒ ¬p` returns later with contrapositive proofs (kontrapositionsbeviser).

---

## 5. Biconditional (Biimplikation)

`p ⇔ q`: p and q have the **same truth value** (samme sandhedsværdi); p is equivalent to q (ensbetydende med).

Truth table, plus the decomposition into two implications:

| p | q | p ⇔ q | p ⇒ q | q ⇒ p | (p⇒q) ∧ (q⇒p) |
|---|---|-------|-------|-------|----------------|
| S | S | S     | S     | S     | S              |
| S | F | F     | F     | S     | F              |
| F | S | F     | S     | F     | F              |
| F | F | S     | S     | S     | S              |

The `p ⇔ q` column matches the `(p⇒q) ∧ (q⇒p)` column, so:

**`p ⇔ q ≡ (p ⇒ q) ∧ (q ⇒ p)`** (Tabel 1.3.8).

Readings of `p ⇔ q`:
- p hvis og kun hvis q (p if and only if q) — the "⇐" part is "p hvis q", the "⇒" part is "p kun hvis q".
- p iff q.
- p er en nødvendig og tilstrækkelig betingelse for q (necessary AND sufficient) — "nødvendig" is the "⇐" direction, "tilstrækkelig" is the "⇒" direction.

Worked example (train):
`b ⇔ t ≡ (b ⇒ t) ∧ (t ⇒ b) ≡ (b ⇒ t) ∧ (¬b ⇒ ¬t)` — "Du kan tage toget, hvis og kun hvis du har billet."

---

## 6. De Morgan's laws (De Morgans Love)

Reasoning given in the notes:
- `¬(p ∧ q)`: if p and q are not both true, then at least one of them is false → `¬p ∨ ¬q`.
- `¬(p ∨ q)`: if not at least one of p, q is true, then both must be false → `¬p ∧ ¬q`.

**The laws** (Tabel 1.3.2 and 1.3.6):

- **`¬(p ∧ q) ≡ ¬p ∨ ¬q`**
- **`¬(p ∨ q) ≡ ¬p ∧ ¬q`**

Proof references in the notes: `¬(p∧q)` proof is Opgave 1.3.6; `¬(p∨q)` proof is Tabel 1.3.3.

Note from the notes: tables 1.3.6–1.3.8 (p. 29) are useful (er nyttige).

---

## 7. Exclusive or (Eksklusiv eller / XOR)

`p ⊕ q`: **enten** p **eller** q (either p or q, but not both); p and q have **different** truth values (forskellige sandhedsværdier).

Truth table:

| p | q | p ⊕ q |
|---|---|-------|
| S | S | F     |
| S | F | S     |
| F | S | S     |
| F | F | F     |

Equivalent forms given:
- `p ⊕ q ≡ ¬(p ⇔ q)`
- `p ⊕ q ≡ ¬p ⇔ q`
- `p ⊕ q ≡ (p ∧ ¬q) ∨ (¬p ∧ q)`

---

## 8. Operator precedence (Præcedens hierarki)

Order, highest to lowest: **`¬  ∧  ∨  ⇒  ⇔`**.

Caveat from the notes: there is no agreement on where `⊕` sits in the hierarchy — use parentheses (brug parenteser).

Worked evaluations with `p ≡ S, q ≡ F, r ≡ F`:
- `¬p ∧ q`: ¬p = F, so F ∧ F → **F**.
- `p ∨ q ∧ r`: ∧ binds tighter, so q ∧ r = F ∧ F = F, then p ∨ F = S ∨ F → **S**.
- `p ∧ q ⇔ q ∨ r`: left p ∧ q = S ∧ F = F, right q ∨ r = F ∨ F = F, then F ⇔ F → **S**.

---

## 9. More terminology: tautology, contradiction, contingency

**Tautologi (Tautology).** A compound proposition (sammensat udsagn) that is **true** regardless of the truth values of its variables — i.e. the truth table column is S in every row.
Examples: `p ∨ ¬p`; `(p ⇒ q) ⇔ (¬q ⇒ ¬p)`.

**Modstrid (Contradiction).** A compound proposition that is **false** regardless of variable values — F in every row of the truth table.
Examples: `p ∧ ¬p`; `(p ⇒ q) ⊕ (¬q ⇒ ¬p)` (false because the two sides are equivalent, so their XOR is always F).

**Kontingens (Contingency).** Neither tautology nor contradiction — at least one row with S and at least one row with F.
Examples: `p ∨ q`; `p ⇒ q`.

---

## 10. Notation: number sets (Lidt notation)

Integers (Heltal):
- **ℤ** = {…, −2, −1, 0, 1, 2, …} — all integers (alle heltal).
- **ℤ⁺** = {1, 2, 3, …} — positive integers (positive heltal).
- **ℤ⁻** = {−1, −2, −3, …} — negative integers (negative heltal).

Natural numbers (Naturlige tal):
- **ℕ** = {0, 1, 2, …}. Remark: some define ℕ = {1, 2, 3, …} (i.e. excluding 0).

Rational numbers (Rationale tal):
- **ℚ** = { m/n | m ∈ ℤ, n ∈ ℤ⁺ }.

Real numbers (Reelle tal):
- **ℝ**.
