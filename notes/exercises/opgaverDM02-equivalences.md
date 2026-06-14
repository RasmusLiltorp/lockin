# DM02 — Logical Equivalences, Tautologies, Contradictions

Source: `material/discrete-maths/exercises/opgaverDM02.pdf` (SE4-DMAD, uge 9). References Rosen, *Discrete Mathematics and Its Applications*, "Afsnit 1.4" (Propositional Equivalences in some editions).

This set drills propositional logic: building truth tables (sandhedstabel), proving logical equivalences (logisk ækvivalens) using De Morgan and distributive laws, recognising tautologies (tautologi) and contradictions (modstrid), and classifying compound statements. The core skill is deciding whether a statement is always true, always false, or neither (kontingens).

> Note on numbering: the PDF cites Rosen problems 5, 11, 16, 35, 53, 62 from "Afsnit 1.4" but does not reprint them. Edition numbering differs (Propositional Equivalences is 1.3 in 7th/8th ed.). The statements below are the standard problems for these numbers in the propositional-equivalences section, matching the set's stated topic. If your edition prints a different statement for a given number, the **Method** still applies verbatim — swap in your statement.

---

## Opgave 1 — Rosen problems

### Opgave 5 — Verify a De Morgan law by truth table

**Problem.** Use a truth table (sandhedstabel) to verify the first De Morgan law: `¬(p ∧ q) ≡ ¬p ∨ ¬q`.

**Type.** Prove logical equivalence by truth table.

**Method (works for any `A ≡ B`).**
1. List every variable. With `n` variables the table has `2^n` rows.
2. Add one column per variable, then build up sub-columns for each connective inside `A` and inside `B`.
3. Compute the final column for `A` and the final column for `B`.
4. If the two final columns are **identical row-for-row**, then `A ≡ B`. Any differing row disproves equivalence.

**Worked solution.** Swap-in: `A = ¬(p ∧ q)`, `B = ¬p ∨ ¬q`.

| p | q | p∧q | ¬(p∧q) | ¬p | ¬q | ¬p∨¬q |
|---|---|-----|--------|----|----|-------|
| T | T |  T  |   F    | F  | F  |   F   |
| T | F |  F  |   T    | F  | T  |   T   |
| F | T |  F  |   T    | T  | F  |   T   |
| F | F |  F  |   T    | T  | T  |   T   |

Columns `¬(p∧q)` and `¬p∨¬q` match in all 4 rows. So `¬(p ∧ q) ≡ ¬p ∨ ¬q`. Verified. (checked: Python)

---

### Opgave 11 — Show a statement is a tautology

**Problem.** Show that `(p ∧ q) → p` is a tautology (tautologi).

**Type.** Prove a compound statement is a tautology.

**Method (works for any statement `S`).**
1. Build the truth table for `S` over its `2^n` rows.
2. If the final column is **all T**, `S` is a tautology. (All F → contradiction/modstrid; mixed → contingency/kontingens.)
3. Shortcut for `X → Y`: it is false only when `X` is true and `Y` is false. Show that case is impossible.

**Worked solution.** Swap-in: `S = (p ∧ q) → p`.

| p | q | p∧q | (p∧q)→p |
|---|---|-----|---------|
| T | T |  T  |    T    |
| T | F |  F  |    T    |
| F | T |  F  |    T    |
| F | F |  F  |    T    |

Final column all T → tautology. Shortcut: the antecedent `p∧q` is true only when `p` is true, and then the consequent `p` is true, so it never goes T→F. (checked: Python)

---

### Opgave 16 — Show an implication is a tautology

**Problem.** Show that `[(p → q) ∧ (q → r)] → (p → r)` is a tautology (the hypothetical syllogism / transitivity of implication).

**Type.** Prove a tautology (truth table or conditional-world argument).

**Method.** Same as Opgave 11. For an implication, the fast route is: assume the whole thing is false, derive a contradiction.
1. Assume `[(p → q) ∧ (q → r)] → (p → r)` is **false**.
2. Then antecedent is T and consequent `p → r` is F.
3. `p → r` false means `p = T`, `r = F`.
4. From `p → q` true with `p = T` we get `q = T`. From `q → r` true with `q = T` we get `r = T`. Contradiction with `r = F`.
5. No false row exists → tautology.

**Worked solution.** The contradiction in steps 3–4 above closes the only candidate false row. Truth-table check over all 8 rows confirms the final column is all T. Tautology. (checked: Python)

---

### Opgave 35 — Negation via De Morgan / biconditional identity

**Problem.** Show `¬(p ↔ q) ≡ p ↔ ¬q`.

**Type.** Prove logical equivalence (truth table or known identities).

**Method.** Truth table as in Opgave 5, or rewrite `↔` as `(p → q) ∧ (q → p)` then push the negation in with De Morgan.

**Worked solution.** Swap-in: `A = ¬(p ↔ q)`, `B = p ↔ ¬q`.

| p | q | p↔q | ¬(p↔q) | ¬q | p↔¬q |
|---|---|-----|--------|----|------|
| T | T |  T  |   F    | F  |  F   |
| T | F |  F  |   T    | T  |  T   |
| F | T |  F  |   T    | F  |  T   |
| F | F |  T  |   F    | T  |  F   |

Columns `¬(p↔q)` and `p↔¬q` agree in all rows → equivalent. Meaning: negating a biconditional is the same as flipping one side. (checked: Python)

---

### Opgave 53 — Show two conditionals are equivalent

**Problem.** Show that `(p → r) ∧ (q → r) ≡ (p ∨ q) → r`.

**Type.** Prove logical equivalence.

**Method.** Truth table over `p, q, r` (8 rows), or chain known equivalences:
`(p → r) ∧ (q → r) ≡ (¬p ∨ r) ∧ (¬q ∨ r) ≡ (¬p ∧ ¬q) ∨ r ≡ ¬(p ∨ q) ∨ r ≡ (p ∨ q) → r`
(steps: material implication, distributive law, De Morgan, material implication back).

**Worked solution.** The algebraic chain above proves it directly. Truth-table check confirms both sides have the same final column over all 8 rows. Both sides are false exactly when `r = F` and at least one of `p, q` is T. (checked: Python)

---

### Opgave 62 — Resolution tautology

**Problem.** Show that `[(p ∨ q) ∧ (¬p ∨ r)] → (q ∨ r)` is a tautology (the resolution rule, resolutionsreglen).

**Type.** Prove a tautology.

**Method.** Assume false, derive contradiction (as in Opgave 16).
1. Assume false: antecedent T, consequent `q ∨ r` F → `q = F`, `r = F`.
2. `¬p ∨ r` true with `r = F` forces `¬p = T`, so `p = F`.
3. `p ∨ q` true, but `p = F` and `q = F` → `p ∨ q = F`. Contradiction.
4. No false row → tautology.

**Worked solution.** The contradiction in step 3 closes the only candidate false assignment. Truth-table check over 8 rows gives all T. Tautology. This is why resolution is sound: from `p ∨ q` and `¬p ∨ r` you may infer `q ∨ r`. (checked: Python)

---

## Opgave 2 — Classify P⇒Q, P⇐Q, P⇔Q for five pairs

**Problem.** For each pair of statements `P, Q` over propositions `p, q, r`, decide whether each of
(a) `P ⇒ Q`, (b) `P ⇐ Q`, (c) `P ⇔ Q`
is a tautology (tautologi), a contradiction (modstrid), or a contingency (kontingens).

**Type.** Classify compound statements (truth table over all rows).

**Method (works for any pair `P, Q`).**
1. List the variables actually used; table has `2^n` rows.
2. Compute a `P`-column and a `Q`-column.
3. For (a) `P ⇒ Q`: false only on rows with `P = T, Q = F`. For (b) `P ⇐ Q` (= `Q ⇒ P`): false only on rows with `Q = T, P = F`. For (c) `P ⇔ Q`: true exactly on rows where `P = Q`.
4. Read the resulting column: all T → tautologi, all F → modstrid, mixed → kontingens.
5. Quick rule: (a) is a tautologi iff `P` logically implies `Q`; (c) is a tautologi iff `P ≡ Q`.

**Worked solutions** (all five verified by computed truth tables, checked: Python).

**Pair 1.** `P: p ∨ q`, `Q: p ∧ q`.
- (a) `P ⇒ Q`: **kontingens** (true when `p∧q`, but e.g. `p=T,q=F` gives `P=T,Q=F`, false).
- (b) `P ⇐ Q`: **tautologi** (`p∧q` always implies `p∨q`).
- (c) `P ⇔ Q`: **kontingens** (differ when exactly one of `p,q` is true).

**Pair 2.** `P: ¬p ∨ q`, `Q: p ⇒ q`.
- These are the same statement: `p ⇒ q ≡ ¬p ∨ q`.
- (a) **tautologi**, (b) **tautologi**, (c) **tautologi**.

**Pair 3.** `P: ¬(p ∧ q)`, `Q: p ∨ q`.
- (a) `P ⇒ Q`: **kontingens** (`p=F,q=F` gives `P=T,Q=F`).
- (b) `P ⇐ Q`: **kontingens** (`p=T,q=T` gives `Q=T,P=F`).
- (c) `P ⇔ Q`: **kontingens**.

**Pair 4.** `P: (p ∨ q) ∧ (p ∨ r)`, `Q: p ∨ (q ∧ r)`.
- Distributive law: `P ≡ Q`.
- (a) **tautologi**, (b) **tautologi**, (c) **tautologi**.

**Pair 5.** `P: ¬p ⇒ q`, `Q: ¬q ⇒ p`.
- Both are equivalent to `p ∨ q` (contrapositive of each other).
- (a) **tautologi**, (b) **tautologi**, (c) **tautologi**.

Summary table:

| Pair | (a) P⇒Q | (b) P⇐Q | (c) P⇔Q |
|------|---------|---------|---------|
| 1 `p∨q` / `p∧q` | kontingens | tautologi | kontingens |
| 2 `¬p∨q` / `p⇒q` | tautologi | tautologi | tautologi |
| 3 `¬(p∧q)` / `p∨q` | kontingens | kontingens | kontingens |
| 4 `(p∨q)∧(p∨r)` / `p∨(q∧r)` | tautologi | tautologi | tautologi |
| 5 `¬p⇒q` / `¬q⇒p` | tautologi | tautologi | tautologi |
