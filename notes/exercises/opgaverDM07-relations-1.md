# DM07 — Relations I (Rosen 9.1, 9.3)

Source: `material/discrete-maths/exercises/opgaverDM07.pdf` (SDU SE4-DMAD, uge 15).

This set drills the basics of binary relations: writing a relation as a set of ordered pairs, testing the five properties (reflexive, symmetric, antisymmetric, transitive, irreflexive), representing relations with zero-one matrices, composing relations via boolean matrix products, and counting relations of a given type. Rosen problems referenced: 9.1 #1, #3, #7; 9.3 #1, #18, #31.

The assigned items are: 9.1 #1 a–c, #3 a,b,d, #7 a,c,f; 9.3 #1b, #18b, #31. Note: *irrefleksiv* (irreflexive) is defined on Rosen p. 609.

---

## Reference: the five properties

For a relation `R` on a set `A` (so `R ⊆ A×A`):

- **Reflexive (refleksiv):** `(a,a) ∈ R` for all `a ∈ A`.
- **Irreflexive (irrefleksiv):** `(a,a) ∉ R` for all `a ∈ A`.
- **Symmetric (symmetrisk):** `(a,b) ∈ R ⇒ (b,a) ∈ R`.
- **Antisymmetric (antisymmetrisk):** `(a,b) ∈ R ∧ (b,a) ∈ R ⇒ a = b`. (Equivalently: no pair of distinct elements relate both ways.)
- **Transitive (transitiv):** `(a,b) ∈ R ∧ (b,c) ∈ R ⇒ (a,c) ∈ R`.

Reflexive and irreflexive are not opposites: a relation can be neither (some loops present, some missing).

---

## Opgave 9.1.1 — Is the relation reflexive, symmetric, antisymmetric, transitive?

**Problem.** `R` is a relation on the set of all people. For each definition decide which of the four properties (reflexive, symmetric, antisymmetric, transitive) it has.
- (a) `(a,b) ∈ R` iff `a` is taller than `b` (*a er højere end b*).
- (b) `(a,b) ∈ R` iff `a` and `b` were born on the same day (*født samme dag*).
- (c) `(a,b) ∈ R` iff `a` has the same first name as `b` (*samme fornavn*).

**Type.** Test the four properties of a relation given by a verbal (natural-language) definition.

**Method.** For each property, check the defining condition against the verbal rule:
1. **Reflexive:** does the rule hold for `a` compared with itself? Plug `b = a`.
2. **Symmetric:** if the rule holds for `(a,b)`, is it forced for `(b,a)`? Swap the roles.
3. **Antisymmetric:** can two *distinct* people relate both ways? If yes → not antisymmetric.
4. **Transitive:** if `aRb` and `bRc`, does `aRc` follow? Chain two instances.
Give one concrete counterexample to kill a property; give a general argument to confirm one.

**Worked solution.**

(a) **taller than.** Reflexive: no — `a` is not taller than `a`. Symmetric: no — if `a` taller than `b`, then `b` is not taller than `a`. Antisymmetric: yes (vacuously) — you can never have both `a>b` and `b>a` for distinct people, so the implication holds trivially. Transitive: yes — `a` taller than `b` and `b` taller than `c` gives `a` taller than `c`. So: **antisymmetric and transitive only.**

(b) **born same day.** Reflexive: yes — `a` born same day as `a`. Symmetric: yes — same-day is mutual. Antisymmetric: no — two different people born the same day relate both ways. Transitive: yes — same day is an equality of birthdate, which chains. So: **reflexive, symmetric, transitive** (an equivalence relation).

(c) **same first name.** Same structure as (b): **reflexive, symmetric, transitive** (equivalence relation). Not antisymmetric (two different people named "Anne" relate both ways).

---

## Opgave 9.1.3 — Relations on {1,2,3,4}: which properties?

**Problem.** Determine whether each relation `R` on `{1,2,3,4}` is reflexive, symmetric, antisymmetric, and/or transitive.
- (a) `R = {(2,2),(2,3),(2,4),(3,2),(3,3),(3,4)}`
- (b) `R = {(1,1),(1,2),(2,1),(2,2),(3,3),(4,4)}`
- (d) `R = {(1,2),(2,3),(3,4)}`

**Type.** Test the four properties of a relation given explicitly as a set of pairs on a finite set.

**Method.** Let `A = {1,2,3,4}` (swap in your own set/pairs).
1. **Reflexive:** check all loops `(1,1),(2,2),(3,3),(4,4)` are present. Missing one → not reflexive.
2. **Symmetric:** for every `(a,b)` with `a≠b`, check `(b,a)` is also there. One mismatch → not symmetric.
3. **Antisymmetric:** look for a distinct pair `(a,b)` AND `(b,a)`. Found → not antisymmetric. None → antisymmetric.
4. **Transitive:** for every `(a,b),(b,c)` check `(a,c) ∈ R`. One gap → not transitive.

**Worked solution.**

(a) `{(2,2),(2,3),(2,4),(3,2),(3,3),(3,4)}`.
- Reflexive: no — `(1,1)` missing.
- Symmetric: no — `(2,4) ∈ R` but `(4,2) ∉ R`.
- Antisymmetric: no — `(2,3)` and `(3,2)` both present, `2≠3`.
- Transitive: check chains. `(2,3),(3,2) ⇒ (2,2)` ✓; `(2,3),(3,4) ⇒ (2,4)` ✓; `(3,2),(2,3) ⇒ (3,3)` ✓; `(3,2),(2,4) ⇒ (3,4)` ✓. No gap → **transitive**.
- Result: **transitive only.** (checked: Python)

(b) `{(1,1),(1,2),(2,1),(2,2),(3,3),(4,4)}`.
- Reflexive: yes — all four loops present.
- Symmetric: yes — `(1,2)` and `(2,1)` both there; loops are self-symmetric.
- Antisymmetric: no — `(1,2)` and `(2,1)` both present.
- Transitive: `(1,2),(2,1) ⇒ (1,1)` ✓; `(2,1),(1,2) ⇒ (2,2)` ✓; rest are loops. **Transitive**.
- Result: **reflexive, symmetric, transitive** (equivalence relation). (checked: Python)

(d) `{(1,2),(2,3),(3,4)}`.
- Reflexive: no — no loops at all.
- Symmetric: no — `(1,2) ∈ R`, `(2,1) ∉ R`.
- Antisymmetric: yes — no distinct pair appears both ways.
- Transitive: no — `(1,2),(2,3) ∈ R` but `(1,3) ∉ R`.
- Result: **antisymmetric only.** (checked: Python)

---

## Opgave 9.1.7 — Relations on the set of all people

**Problem.** `R` is a relation on the set of all people. Decide reflexive / symmetric / antisymmetric / transitive (and note irreflexive where relevant).
- (a) `(a,b) ∈ R` iff `a` is taller than `b` (*højere end*).
- (c) `(a,b) ∈ R` iff `a` and `b` were born on the same day (*født samme dag*).
- (f) `(a,b) ∈ R` iff `a` and `b` have a common grandparent (*fælles bedsteforælder*).

**Type.** Test properties of a verbally-defined relation on an infinite set.

**Method.** Same recipe as 9.1.1: test each property with `b=a` (reflexive), role-swap (symmetric), distinct two-way pair (antisymmetric), chaining (transitive). For "common X" relations watch transitivity carefully — sharing is usually not transitive.

**Worked solution.**

(a) **taller than.** Same as 9.1.1(a): not reflexive (it's irreflexive — `a` never taller than itself), not symmetric, **antisymmetric** (vacuously), **transitive**.

(c) **born same day.** **Reflexive, symmetric, transitive**; not antisymmetric. Equivalence relation. (Same reasoning as 9.1.1(b).)

(f) **common grandparent.** 
- Reflexive: yes — `a` shares all grandparents with `a`. 
- Symmetric: yes — "share a grandparent" is mutual. 
- Antisymmetric: no — two distinct cousins share a grandparent both ways. 
- Transitive: **no.** Counterexample: `a` and `b` share grandparent on `a`'s mother's side; `b` and `c` share a *different* grandparent on `b`'s father's side; `a` and `c` need not share any grandparent. 
- Result: **reflexive and symmetric only** (not an equivalence relation, because transitivity fails).

---

## Opgave 9.3.1b — Properties from a zero-one matrix

**Problem.** Given the zero-one matrix `M_R` of a relation `R` on a finite set, determine whether `R` is reflexive, symmetric, antisymmetric. For (b):

```
M_R = | 0 1 0 |
      | 1 1 1 |
      | 0 1 0 |
```

**Type.** Read relation properties off a zero-one matrix (*nul-en-matrix*).

**Method.** Let `M = M_R` be `n×n` with entries `m_{ij} ∈ {0,1}` (swap in your matrix).
1. **Reflexive:** the whole main diagonal is 1, i.e. `m_{ii}=1` for all `i`.
2. **Symmetric:** `M` equals its transpose, i.e. `m_{ij}=m_{ji}` for all `i,j`.
3. **Antisymmetric:** for every `i≠j`, not both `m_{ij}=1` and `m_{ji}=1`. (At most one of each off-diagonal mirror pair is 1.)
4. (Transitive, if asked: check `M^{[2]} ≤ M` under boolean product — entry `1` in `M⊙M` forces `1` in `M`.)

**Worked solution.**
- Diagonal of `M_R` is `0,1,0` → not all 1 → **not reflexive**.
- `m_{12}=1=m_{21}`, `m_{23}=1=m_{32}`, `m_{13}=0=m_{31}` → matrix is symmetric → **symmetric**.
- Off-diagonal mirror pairs `(1,2)/(2,1)` are both 1 with `1≠2` → **not antisymmetric**.
- Result: **symmetric; not reflexive; not antisymmetric.**

(Verified with a boolean script: reflexive False, symmetric True, antisymmetric False.)

---

## Opgave 9.3.18b — Matrix of a composite / power relation

**Problem.** Given `M_R`, find the zero-one matrix of `R²` (i.e. `R∘R`) using the boolean product. Using the worked matrix

```
M_R = | 0 1 0 |
      | 0 0 1 |
      | 1 1 0 |
```

**Type.** Boolean (zero-one) matrix product for relation composition.

**Method.** To get `M_{R²} = M_R ⊙ M_R` (swap in your own `M_R`):
1. Use the **boolean product** `⊙`: entry `(i,j)` is `1` iff there exists `k` with `m_{ik}=1` AND `m_{kj}=1`; else `0`. (OR of ANDs — like ordinary matrix multiply but `+`→OR, `·`→AND.)
2. For `R^n` repeat: `M_{R^n} = M_R ⊙ M_R ⊙ … ` (`n` copies).
3. Reflexive-transitive ideas: `R` transitive iff `M_{R²} ≤ M_R` entrywise.

**Worked solution.** Row `i` of `M_R` ⊙ columns of `M_R`:
- Row 1 `(0,1,0)`: picks row 2 of `M_R` = `(0,0,1)` → `(0,0,1)`.
- Row 2 `(0,0,1)`: picks row 3 of `M_R` = `(1,1,0)` → `(1,1,0)`.
- Row 3 `(1,1,0)`: OR of rows 1 and 2 = `(0,1,0) OR (0,0,1)` = `(0,1,1)`.

```
M_{R²} = | 0 0 1 |
         | 1 1 0 |
         | 0 1 1 |
```
(Confirmed by script.) Method generalises to any given matrix in the actual assigned part — apply the same boolean product.

---

## Opgave 9.3.31 — Count the reflexive relations on an n-element set

**Problem.** How many reflexive relations are there on a set with `n` elements? (*Hvor mange refleksive relationer findes der på en mængde med n elementer?*)

**Type.** Counting relations of a given type (combinatorics on `A×A`).

**Method.** A relation on `A` is any subset of the `n²` cells of `A×A`; each cell is independently in or out, giving `2^(n²)` relations total. To count a *restricted* type, find how many cells are **forced** and how many are **free**, then the answer is `2^(free cells)`:
1. Total cells: `n²`. Diagonal cells: `n`. Off-diagonal cells: `n² − n`.
2. **Reflexive:** all `n` diagonal cells forced to 1 (no choice). The remaining `n² − n` off-diagonal cells are free → `2^(n² − n)`.
   (Same template: *irreflexive* = diagonal forced to 0 → also `2^(n²−n)`; *symmetric* = choose each mirror pair together → `2^(n(n+1)/2)`.)

**Worked solution.** Diagonal entries `(a,a)` must all be present → `n` cells fixed. The other `n²−n` entries are free. 

**Answer: `2^(n² − n)` reflexive relations.**

Check: `n=1 → 2^0 = 1`; `n=2 → 2^2 = 4`; `n=3 → 2^6 = 64`; `n=4 → 2^12 = 4096`. (Confirmed by script.)
