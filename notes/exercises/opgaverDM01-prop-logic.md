# DM01 — Propositional Logic: Propositions, Operators, Truth Tables

Source: `material/discrete-maths/exercises/opgaverDM01.pdf` (Opgaver til uge 8, SE4-DMAD, SDU forår 2026).

This set drills the basics of propositional logic (udsagnslogik): translating between English and logical notation, the five core operators (∧, ∨, ¬, ⊕, →, ↔), building truth tables (sandhedstabeller), and the standard logical equivalences (logiske ækvivalenser) — De Morgan, commutativity, tautologies. Problems 1–2 point at exercises in Kenneth Rosen's *Discrete Mathematics and Its Applications*; problems 3–4 are standalone. The exact Rosen wording is reproduced below so the notes stand alone.

Operator key: ∧ = and (og), ∨ = or (eller), ¬ = not (ikke), ⊕ = exclusive or (XOR), → = implication (medfører), ↔ = biconditional (hvis og kun hvis).

---

## Section 1.1 (Afsnit 1.1)

### Opgave 1.1.5 — conditional truth values

**Problem.** Decide whether each conditional statement (betinget udsagn) is true or false.
(a) If 1+1=2, then 2+2=5. (b) If 1+1=3, then 2+2=4. (c) If 1+1=3, then 2+2=5. (d) If monkeys can fly, then 1+1=3.

**Type.** Evaluate an implication $p \to q$ from the truth of its parts.

**Method (works for any $p \to q$):**
1. Read off the truth value of the hypothesis $p$ (the "if" part) and the conclusion $q$ (the "then" part) from facts.
2. Apply the implication rule: $p \to q$ is **false only when $p$ is true and $q$ is false**. In all other cases it is true.
3. In particular, a false hypothesis makes the whole implication **vacuously true** (sandt på tom vis), no matter what $q$ is.

**Worked solution.**
- (a) $p$=T (1+1=2), $q$=F (2+2=5 is false). T→F = **false**.
- (b) $p$=F (1+1=3 false). False hypothesis → **true** (vacuously).
- (c) $p$=F (1+1=3 false). → **true** (vacuously).
- (d) $p$=F (monkeys can't fly). → **true** (vacuously).

### Opgave 1.1.13 — translate to English

**Problem.** Let $p$ = "The election is decided" and $q$ = "The votes have been counted." Express each compound proposition in ordinary English.
(a) $\neg p$ (b) $p \lor q$ (c) $\neg p \land q$ (d) $q \to p$ (e) $\neg q \to \neg p$ (f) $\neg p \to \neg q$ (g) $p \leftrightarrow q$ (h) $\neg q \lor (\neg p \land q)$.

**Type.** Notation → English translation.

**Method:** substitute the English clause for each variable, then read the operator: ¬ = "not / it is not the case that", ∧ = "and", ∨ = "or", → = "if … then …", ↔ = "if and only if".

**Worked solution.**
- (a) The election is not decided.
- (b) The election is decided, or the votes have been counted.
- (c) The election is not decided, but the votes have been counted.
- (d) If the votes have been counted, then the election is decided.
- (e) If the votes have not been counted, then the election is not decided.
- (f) If the election is not decided, then the votes have not been counted.
- (g) The election is decided if and only if the votes have been counted.
- (h) Either the votes have not been counted, or the election is not decided but the votes have been counted.

### Opgave 1.1.31 a, d — truth tables

**Problem.** Build the truth table for (a) $p \land \neg p$ and (d) $(p \lor \neg q) \to q$.

**Type.** Construct a truth table (sandhedstabel).

**Method (any formula):**
1. List the $n$ atomic variables; the table has $2^n$ rows. Write all combinations of T/F.
2. Add one column per subexpression, innermost first (negations, then ∧/∨, then →/↔).
3. Combine columns by the operator rules until you reach the full formula. The values that change between instances are the operator structure and which variables appear.

**Worked solution.**

(a) $p \land \neg p$ — one variable, 2 rows. Always false (a contradiction, modsigelse):

| p | ¬p | p∧¬p |
|---|----|------|
| T | F  | F    |
| F | T  | F    |

(d) $(p \lor \neg q) \to q$:

| p | q | ¬q | p∨¬q | (p∨¬q)→q |
|---|---|----|------|----------|
| T | T | F  | T    | T        |
| T | F | T  | T    | F        |
| F | T | F  | F    | T        |
| F | F | T  | T    | F        |

### Opgave 1.1.33 d — truth table

**Problem.** Build the truth table for $(p \lor q) \to (p \land q)$.

**Type.** Truth table.

**Method.** Same recipe as 1.1.31. Build $p\lor q$ and $p\land q$ separately, then connect with →.

**Worked solution.**

| p | q | p∨q | p∧q | (p∨q)→(p∧q) |
|---|---|-----|-----|-------------|
| T | T | T   | T   | T           |
| T | F | T   | F   | F           |
| F | T | T   | F   | F           |
| F | F | F   | F   | T           |

This formula is true exactly when $p$ and $q$ have the same truth value, so it equals $p \leftrightarrow q$.

---

## Section 1.3 (Afsnit 1.3)

### Opgave 1.3.6 — commutative laws by truth table

**Problem.** Use truth tables to verify the commutative laws (de kommutative love): (a) $p \lor q \equiv q \lor p$, (b) $p \land q \equiv q \land p$.

**Type.** Prove logical equivalence (logisk ækvivalens) via truth table.

**Method (any $A \equiv B$):**
1. Tabulate $A$ and $B$ over all $2^n$ rows of the shared variables.
2. If the two output columns match in every row, $A \equiv B$. If any row differs, they are not equivalent.

**Worked solution.**

(a)

| p | q | p∨q | q∨p |
|---|---|-----|-----|
| T | T | T   | T   |
| T | F | T   | T   |
| F | T | T   | T   |
| F | F | F   | F   |

Columns identical → $p\lor q \equiv q\lor p$. ✓

(b)

| p | q | p∧q | q∧p |
|---|---|-----|-----|
| T | T | T   | T   |
| T | F | F   | F   |
| F | T | F   | F   |
| F | F | F   | F   |

Columns identical → $p\land q \equiv q\land p$. ✓

### Opgave 1.3.7 a–b — De Morgan's laws

**Problem.** Use a truth table to verify De Morgan's laws (De Morgans love): (a) $\neg(p\land q) \equiv \neg p \lor \neg q$, (b) $\neg(p\lor q) \equiv \neg p \land \neg q$.

**Type.** Prove logical equivalence via truth table.

**Method.** Same as 1.3.6: tabulate both sides, compare columns.

**Worked solution.**

(a)

| p | q | p∧q | ¬(p∧q) | ¬p | ¬q | ¬p∨¬q |
|---|---|-----|--------|----|----|-------|
| T | T | T   | F      | F  | F  | F     |
| T | F | F   | T      | F  | T  | T     |
| F | T | F   | T      | T  | F  | T     |
| F | F | F   | T      | T  | T  | T     |

`¬(p∧q)` and `¬p∨¬q` match → equivalent. ✓

(b)

| p | q | p∨q | ¬(p∨q) | ¬p | ¬q | ¬p∧¬q |
|---|---|-----|--------|----|----|-------|
| T | T | T   | F      | F  | F  | F     |
| T | F | T   | F      | F  | T  | F     |
| F | T | T   | F      | T  | F  | F     |
| F | F | F   | T      | T  | T  | T     |

`¬(p∨q)` and `¬p∧¬q` match → equivalent. ✓

The pattern to memorize: pushing ¬ through a parenthesis flips the operator (∧↔∨) and negates each part.

### Opgave 1.3.11 a–c — show tautologies

**Problem.** Show that each statement is a tautology (tautologi) by truth table: (a) $(p\land q)\to p$, (b) $p\to(p\lor q)$, (c) $\neg p \to (p\to q)$.

**Type.** Prove a formula is a tautology (true in every row).

**Method (any formula):**
1. Build the full truth table.
2. If the final column is T in **every** row, it is a tautology. (A single F means it is not.)

**Worked solution.**

(a) $(p\land q)\to p$:

| p | q | p∧q | (p∧q)→p |
|---|---|-----|---------|
| T | T | T   | T       |
| T | F | F   | T       |
| F | T | F   | T       |
| F | F | F   | T       |

All T → tautology. ✓

(b) $p\to(p\lor q)$:

| p | q | p∨q | p→(p∨q) |
|---|---|-----|---------|
| T | T | T   | T       |
| T | F | T   | T       |
| F | T | T   | T       |
| F | F | F   | T       |

All T → tautology. ✓

(c) $\neg p \to (p\to q)$:

| p | q | ¬p | p→q | ¬p→(p→q) |
|---|---|----|-----|----------|
| T | T | F  | T   | T        |
| T | F | F  | F   | T        |
| F | T | T  | T   | T        |
| F | F | T  | T   | T        |

All T → tautology. ✓ (When ¬p is true, p is false, so p→q is automatically true.)

---

## Opgave 3 — which statements are true?

**Problem.** Decide which of the following are true.
(a) If $p$ is true and $q$ is false, then $p\land q$ is true.
(b) If $p$ is false, then $\neg p \lor q$ is true.
(c) If $p$ is true and $q$ is false, then $p\oplus q$ is true.
(d) If $p\lor q$ is true, then $p$ is necessarily also true.
(e) $p\lor q$ is true if and only if $p$ is true.
(f) If $p\land q$ is true, then $p\lor q$ is also true.
(g) If $p\Rightarrow q$ is true and $p$ is true, then $q$ is also true.
(h) If $p\Rightarrow q$ is true and $q$ is false, then $p$ is also false.

**Type.** Evaluate truth-claims about operator behavior; find a counterexample (modeksempel) to kill a false one.

**Method:** for each claim either (i) evaluate the operator directly under the stated values, or (ii) for a "necessarily/iff" claim, test all cases and produce a counterexample if one exists.

**Worked solution.**
- (a) **False.** $p\land q$ needs both true; T∧F = F.
- (b) **True.** $p$ false ⇒ $\neg p$ true ⇒ $\neg p\lor q$ true regardless of $q$.
- (c) **True.** XOR is true when exactly one is true; T⊕F = T.
- (d) **False.** Counterexample $p$=F, $q$=T: $p\lor q$ = T but $p$ = F.
- (e) **False.** Same counterexample $p$=F, $q$=T: left side T, right side F, so not equivalent.
- (f) **True.** If both true then $p\land q$ true and $p\lor q$ also true. (This is exactly tautology 1.3.11-style: $(p\land q)\to(p\lor q)$.)
- (g) **True.** Modus ponens (modus ponens): from $p\to q$ and $p$, conclude $q$.
- (h) **True.** Modus tollens (modus tollens): from $p\to q$ and $\neg q$, conclude $\neg p$.

So (b), (c), (f), (g), (h) are true; (a), (d), (e) are false.

## Opgave 4 — which logical equivalence does the student use?

**Problem.** The comic strip: the professor says "if you need any more help, my door is ALWAYS open." Later the student sees the door is closed and concludes "the door is closed, therefore I DON'T need any more help." Which logical equivalence is the student using?

**Type.** Identify the equivalence behind an inference.

**Method:** translate the spoken statement into $p\to q$, then identify which equivalent form the conclusion matches.

**Worked solution.**
Let $p$ = "you need more help" and $q$ = "the door is open." The professor states $p\to q$ ("if you need help, the door is open").
The student observes $\neg q$ (door closed) and concludes $\neg p$ (don't need help). That is the **contrapositive (kontraposition)**:
$$p\to q \;\equiv\; \neg q \to \neg p.$$
The student applies the contrapositive of the professor's implication (equivalently, this is reasoning by modus tollens). The contrapositive is logically valid, which is the joke — the conclusion follows correctly from the premise, even though the premise was just a figure of speech.
