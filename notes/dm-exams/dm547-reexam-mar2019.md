# DM547 re-exam March 2019

Source: `material/discrete-maths/old-exam/Uddrag af reeksamen i DM547 marts 2019.pdf` (excerpt / uddrag, DM547 re-exam March 2019).

Overview: five multiple-statement questions on predicate logic with quantifiers, negation of nested quantifiers, propositional equivalence, proof validity (even/odd), and relation properties. Every sub-statement below is marked true/false or valid/invalid with the reason. All checks were confirmed with Python.

---

## Spørgsmål 1 (13%)

1. **Problem.** "Hvilke udsagn er sande?" — Which propositions are true? `|` means "divides" (går op i). Eight statements over `Z`.
2. **Type.** Truth of quantified statements over the integers.
3. **Method.** For each statement: (i) read the quantifier prefix; (ii) for `∀`, try to find one counterexample — if you can, it is false, else argue it holds for every value; (iii) for `∃`, try to produce one witness — if you can, true, else argue none exists; (iv) for `∃!` (exactly one), find the solution set and check it has size exactly 1. Swap in the given inequality / divisibility relation.
4. **Worked solution.**

- **1.1** `∀n ∈ Z : n − 2 < n`. Subtract `n`: `−2 < 0`, always. **True.**
- **1.2** `∀n ∈ Z : (n < 0 ⇒ 2n < n)`. If `n < 0`, then `2n − n = n < 0`, so `2n < n`. **True.**
- **1.3** `∃n ∈ Z : 2n > 10n`. `2n > 10n ⇔ −8n > 0 ⇔ n < 0`. Witness `n = −1`. **True.**
- **1.4** `∃n ∈ Z : n − 2 = n`. Gives `−2 = 0`. No `n`. **False.**
- **1.5** `∃! n ∈ Z : 10n > 2n + 2`. `8n > 2 ⇔ n > 1/4 ⇔ n ≥ 1`. Infinitely many solutions, not unique. **False.**
- **1.6** `∃k ∈ Z : ∀n ∈ Z : k | n`. Take `k = 1`: `1 | n` for every integer `n`. (`k = −1` works too.) **True.**
- **1.7** `∀n ∈ Z : ∃k ∈ Z : 10 | (n + k)`. For any `n`, pick `k = −n`: then `n + k = 0` and `10 | 0`. **True.**
- **1.8** `∀n ∈ Z : ∀k ∈ Z : 100n > k`. Counterexample: `n = 0, k = 1` gives `0 > 1`, false. **False.**

**True: 1.1, 1.2, 1.3, 1.6, 1.7.**

---

## Spørgsmål 2 (2%)

1. **Problem.** Which proposition equals `¬(∃n ∈ Z : ∃k ∈ Z : kn = n + k)`?
2. **Type.** Negation of nested quantifiers (De Morgan for quantorer).
3. **Method.** Push the `¬` inward: each `∃` flips to `∀`, each `∀` flips to `∃`, and the innermost predicate gets negated. Swap in your own quantifier chain and predicate.
4. **Worked solution.** `¬∃n ∃k (kn = n+k) = ∀n ∀k ¬(kn = n+k) = ∀n ∈ Z : ∀k ∈ Z : kn ≠ n + k`.

**Answer: 2.8.**

---

## Spørgsmål 3 (13%)

1. **Problem.** Which propositions are equivalent to `¬(p ∧ q)`?
2. **Type.** Propositional equivalence (check by truth table).
3. **Method.** Compute the target column `¬(p ∧ q)` (true except when both `p,q` true). For each candidate, build its truth column over all four `(p,q)` rows and compare. Equal columns ⇒ equivalent. `¬(p∧q) ≡ ¬p ∨ ¬q` (De Morgan) is the anchor. Swap in your own target formula.
4. **Worked solution.** Target `¬(p∧q)` is false only at `p=q=T`.

- **3.1** `p ∨ q` — differs (true at `T,T`). No.
- **3.2** `¬p ∨ q` — false at `T,F`. No.
- **3.3** `¬p ∨ ¬q` — De Morgan, exact match. **Yes.**
- **3.4** `(p ⊕ q) ∨ (¬p ∧ ¬q)` — true except `T,T`. **Yes.**
- **3.5** `p ⇒ q` — false at `T,F`. No.
- **3.6** `p ⇒ ¬q` ≡ `¬p ∨ ¬q`. **Yes.**
- **3.7** `q ⇒ ¬p` ≡ `¬q ∨ ¬p`. **Yes.**
- **3.8** `p ⇔ ¬q` — false at `T,T` and `F,F`. No.

**Equivalent: 3.3, 3.4, 3.6, 3.7.**

---

## Spørgsmål 4 (12%)

1. **Problem.** Which arguments are valid proofs of: "If `n` is even, then `n + 4` is even" (Hvis `n` er lige, er `n + 4` også lige)?
2. **Type.** Direct-proof validity for a parity (even/odd) implication.
3. **Method.** A valid direct proof must (i) start by assuming the hypothesis ("`n` even", i.e. `n = 2k` for some `k ∈ Z`); (ii) derive the conclusion ("`n + 4` even", i.e. `= 2·(something)`); (iii) keep the direction hypothesis ⇒ conclusion. Reject if it assumes `n` odd, assumes the conclusion to prove the hypothesis (proves the converse), or has an algebra error. Swap in the actual hypothesis/conclusion forms.
4. **Worked solution.**

- **4.1** `n = 2k ⇒ n+4 = 2k+4 = 2(k+2)`. Right assumption, right conclusion. **Valid.**
- **4.2** assumes `n = 2k+1` (n odd) — wrong hypothesis. **Invalid.**
- **4.3** `n = 2(k−2) ⇒ n+4 = 2(k−2)+4 = 2k`. `2(k−2)` is still even, conclusion even. Just a reparametrized version of 4.1. **Valid.**
- **4.4** assumes `n+4 = 2k+1` (n+4 odd) — wrong, and wrong direction. **Invalid.**
- **4.5** assumes `n+4 = 2k` (the conclusion) and derives `n = 2(k−2)` (the hypothesis). Proves the converse. **Invalid.**
- **4.6** assumes `n+4 = 2(k+2)` (conclusion) and derives `n = 2k` (hypothesis). Converse again. **Invalid.**

**Valid proofs: 4.1, 4.3.**

---

## Spørgsmål 5 (13%)

1. **Problem.** `R = {(a, b) ∈ Z × Z | a² = b²}`. Which propositions are true?
2. **Type.** Relation membership + relation properties (reflexive / symmetric / anti-symmetric / transitive / equivalence / partial order).
3. **Method.** Membership: plug `(a,b)` into the defining condition (`a² = b²`). Properties — note `a² = b² ⇔ |a| = |b| ⇔ a = ±b`:
   - Reflexive (refleksiv): `a² = a²` always ⇒ holds.
   - Symmetric (symmetrisk): condition is symmetric in `a,b` ⇒ holds.
   - Anti-symmetric (anti-symmetrisk): need `aRb ∧ bRa ⇒ a = b`; fails if some `a ≠ b` with `a² = b²`.
   - Transitive (transitiv): `a²=b² ∧ b²=c² ⇒ a²=c²` ⇒ holds.
   - Equivalence: reflexive + symmetric + transitive.
   - Partial order: reflexive + anti-symmetric + transitive.
   Swap in your own relation condition.
4. **Worked solution.** Membership (`a² = b²`):

- **5.1** `(−10,100)`: `100 ≠ 10000`. **False.**
- **5.2** `(−3,−3)`: `9 = 9`. **True.**
- **5.3** `(−1,1)`: `1 = 1`. **True.**
- **5.4** `(2,4)`: `4 ≠ 16`. **False.**
- **5.5** `(10,−100)`: `100 ≠ 10000`. **False.**
- **5.6** `(10,−10)`: `100 = 100`. **True.**

Properties:

- **5.7 reflexive** — `a² = a²` always. **True.**
- **5.8 symmetric** — `a²=b² ⇒ b²=a²`. **True.**
- **5.9 anti-symmetric** — `(1,−1)` and `(−1,1)` both in `R` but `1 ≠ −1`. **False.**
- **5.10 transitive** — `a²=b², b²=c² ⇒ a²=c²`. **True.**
- **5.11 equivalence relation** — reflexive + symmetric + transitive all hold. **True.**
- **5.12 partial order** — needs anti-symmetry, which fails. **False.**

**True: 5.2, 5.3, 5.6, 5.7, 5.8, 5.10, 5.11.**
