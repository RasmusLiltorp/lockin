# DM04 — Proof Methods (Rosen 1.7)

Source: `material/discrete-maths/exercises/opgaverDM04.pdf` (week 11; Rosen Section 1.7, problems 1, 5, 17, 18, 36, 41, plus 7 and 42 if time).

This set drills the standard proof techniques for number-theoretic statements: direct proof (direkte bevis), proof by contraposition (kontraposition), proof by contradiction (modstrid), and prove-or-disprove (counterexamples / modeksempel). Almost every problem is about parity (lige/ulige) of integers or rationality (rationel/irrationel) of reals. The recurring tools are: write an even integer as `2k`, an odd integer as `2k+1`, a rational number as `p/q` with integers `p,q` and `q≠0`.

The PDF only lists problem numbers, so the statements below are the Rosen 1.7 (7th ed.) problems those numbers point to.

---

## Opgave 1 — sum of two odd integers is even

**Problem.** Use a direct proof (direkte bevis) to show that the sum of two odd integers is even (summen af to ulige heltal er lige).

**Type.** Direct proof of a universally quantified parity statement.

**Method (works for any "if odd/even ... then odd/even" sum/product claim):**
1. Take arbitrary integers and write each in its algebraic form: odd = `2k+1`, even = `2k`. Swap-in: which inputs, odd or even.
2. Form the expression the claim is about (here a sum).
3. Simplify and factor out a 2 (for "even") or write as `2·something + 1` (for "odd").
4. Conclude the expression has the claimed form, so the statement holds for all such integers.

**Worked solution.**
Let `m` and `n` be odd. Then `m = 2a+1` and `n = 2b+1` for some integers `a,b`.
`m + n = (2a+1) + (2b+1) = 2a + 2b + 2 = 2(a+b+1)`.
`a+b+1` is an integer, so `m+n = 2·(integer)`, which is even. ∎ (checked: Python — brute-forced all `a,b` in `[-50,50]`)

---

## Opgave 5 — m+n and n+p even ⟹ m+p even

**Problem.** Prove that if `m+n` and `n+p` are even integers, where `m,n,p` are integers, then `m+p` is even. What kind of proof did you use?

**Type.** Direct proof from two parity hypotheses.

**Method:**
1. Turn each hypothesis into algebra (`even = 2k`). Swap-in: the given even quantities.
2. Combine the hypotheses (add/subtract) to manufacture the target expression.
3. Factor out 2 to show the target is even.

**Worked solution.**
`m+n = 2s` and `n+p = 2t` for integers `s,t`.
Add them: `(m+n)+(n+p) = m + 2n + p = 2s + 2t`.
So `m + p = 2s + 2t - 2n = 2(s+t-n)`. Since `s+t-n` is an integer, `m+p` is even. ∎
This is a **direct proof** (direkte bevis). (checked: Python — all `m,n,p` in `[-20,20]` with both hypotheses give `m+p` even)

---

## Opgave 17 — n³+5 odd ⟹ n even

**Problem.** Show that if `n` is an integer and `n³ + 5` is odd, then `n` is even, by (a) proof by contraposition, (b) proof by contradiction.

**Type.** Same conditional proved two ways: contraposition (kontraposition) and contradiction (modstrid).

**Method — contraposition** (for `p → q`):
1. Write the contrapositive `¬q → ¬p`. Swap-in: negate hypothesis and conclusion. Here `¬q = "n is odd"`, `¬p = "n³+5 is even"`.
2. Assume `¬q`, prove `¬p` by direct computation.

**Method — contradiction** (for `p → q`):
1. Assume `p ∧ ¬q`, i.e. hypothesis true and conclusion false.
2. Derive a contradiction (two incompatible parities of the same number).

**Worked solution.**
(a) Contrapositive: "if `n` is odd then `n³+5` is even."
Let `n = 2k+1`. Then `n³` is odd (odd·odd·odd = odd). Concretely `n³ + 5 = odd + odd = even`: `n³` odd means `n³ = 2j+1`, so `n³+5 = 2j+6 = 2(j+3)`, even. The contrapositive holds, so the original holds. ∎

(b) Suppose `n³+5` is odd **and** `n` is odd. If `n` is odd then `n³` is odd, so `n³+5 = odd+odd = even`. That contradicts `n³+5` being odd. So the assumption fails and `n` must be even. ∎ (checked: Python — every `n` in `[-100,100]` with `n³+5` odd is even; and every odd `n` gives `n³+5` even)

---

## Opgave 18 — 3n+2 even ⟹ n even

**Problem.** Prove that if `n` is an integer and `3n+2` is even, then `n` is even, by (a) contraposition, (b) contradiction.

**Type.** Conditional proved by contraposition and by contradiction (same template as Opg 17).

**Method.** Identical recipe to Opgave 17 — only the expression `3n+2` changes.

**Worked solution.**
(a) Contrapositive: "if `n` is odd then `3n+2` is odd."
Let `n = 2k+1`. Then `3n+2 = 3(2k+1)+2 = 6k+3+2 = 6k+5 = 2(3k+2)+1`, which is odd. So the contrapositive holds, hence the original. ∎

(b) Suppose `3n+2` is even and `n` is odd. With `n = 2k+1`, `3n+2 = 6k+5 = 2(3k+2)+1` is odd — contradicting that `3n+2` is even. So `n` is even. ∎ (checked: Python — every `n` in `[-100,100]` with `3n+2` even is even; identity `6k+5 = 2(3k+2)+1` confirmed)

---

## Opgave 36 — product of two irrationals

**Problem.** Prove or disprove (bevis eller modbevis): the product of two irrational numbers is irrational.

**Type.** Prove-or-disprove → disprove by counterexample (modeksempel).

**Method (prove-or-disprove for a "for all" claim):**
1. Try to find a counterexample first; a single one disproves a universal claim. Swap-in: the operation/property in the claim.
2. Pick "nice" irrationals whose combination collapses to something rational.
3. Exhibit the counterexample explicitly and verify the result is rational.

**Worked solution.**
**False.** Counterexample: `√2 · √2 = 2`. Here `√2` is irrational but the product `2` is rational. So the product of two irrationals need not be irrational. ∎ (Another: `√2 · √8 = √16 = 4`.) (checked: Python — `√2·√2 = 2.0`, `√2·√8 = 4.0`)

---

## Opgave 41 — (nonzero rational) × (irrational)

**Problem.** Prove or disprove: the product of a nonzero rational number and an irrational number is irrational (et rationelt tal forskelligt fra 0 gange et irrationelt tal er irrationelt).

**Type.** Prove-or-disprove → true, proved by contradiction.

**Method (proof by contradiction for "X is irrational"):**
1. Assume the result is rational, i.e. write it as `p/q` with integers `p,q`, `q≠0`. Swap-in: the quantity claimed irrational.
2. Use the rational hypotheses (also written `a/b`) to solve for the supposedly-irrational factor.
3. Show that factor comes out rational — contradicting its irrationality.

**Worked solution.**
**True.** Let `r` be rational and nonzero, `x` irrational. Write `r = a/b` with integers `a,b`, `a≠0`, `b≠0`.
Suppose for contradiction the product `rx` is rational: `rx = c/d`, integers `c,d`, `d≠0`.
Then `x = (rx)/r = (c/d)/(a/b) = (cb)/(da)`. Since `a≠0` and `d≠0`, `da≠0`, and `cb, da` are integers — so `x` is rational. Contradiction. Hence `rx` is irrational. ∎
(The hypothesis `r≠0` is needed: it guarantees `a≠0`, so dividing by `r` is legal.)

---

## Opgave 7 — irrational + rational is irrational

**Problem.** Use a proof by contradiction to prove that the sum of an irrational number and a rational number is irrational.

**Type.** Proof by contradiction (modstrid) that a value is irrational.

**Method.** Same contradiction recipe as Opg 41, but with a sum instead of a product (subtract instead of divide).

**Worked solution.**
Let `x` be irrational and `r` rational, `r = a/b` (integers `a,b`, `b≠0`).
Suppose for contradiction `x + r` is rational: `x + r = c/d` (integers `c,d`, `d≠0`).
Then `x = (x+r) - r = c/d - a/b = (cb - ad)/(db)`. Here `cb-ad` and `db` are integers and `db≠0`, so `x` is rational — contradicting that `x` is irrational. Therefore `x + r` is irrational. ∎

---

## Opgave 42 — x irrational, x ≥ 0 ⟹ √x irrational

**Problem.** Prove that if `x` is irrational and `x ≥ 0`, then `√x` is irrational.

**Type.** Conditional about irrationality — cleanest by contraposition (kontraposition).

**Method (contraposition for "if x irrational then f(x) irrational"):**
1. Prove the contrapositive: "if `f(x)` is rational then `x` is rational."
2. Assume `f(x)` rational, write as `p/q`, and show `x` is then rational (closure of rationals under the relevant operation — here squaring).

**Worked solution.**
Contrapositive: "if `√x` is rational then `x` is rational." (Need `x ≥ 0` so `√x` is a real number.)
Assume `√x` is rational: `√x = p/q`, integers `p,q`, `q≠0`. Then `x = (√x)² = p²/q²`. Both `p²` and `q²` are integers and `q²≠0`, so `x` is rational.
The contrapositive holds, so the original statement holds: `x` irrational (and `≥0`) forces `√x` irrational. ∎
