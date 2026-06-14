# Nested Quantifiers and Proof Methods (Sections 1.5 & 1.7)

Source: material/discrete-maths/slides/Noter3.pdf (SE4-DMAD, Discrete Mathematics, in Danish).

Note: despite the filename, this set of notes does NOT cover induction. It covers nested quantifiers (Afsnit 1.5: Indlejrede kvantorer) and proof methods (Afsnit 1.7: Bevismetoder). Sections covered: quantifier order, swapping equal quantifiers, negating nested quantifiers, direct/contraposition/contradiction proofs, and the even/odd (parity) definitions.

---

## Section 1.5 — Nested quantifiers (Indlejrede kvantorer)

An open statement (åbent udsagn) can have more than one free variable (fri variabel).

### Example: a two-variable predicate

`P(x,y): x + y = 0`

- `P(2,-2)` = S (true / sand)
- `P(2,0)` = F (false / falsk)

So a predicate with two free variables only becomes true/false once both are fixed.

### Reading a nested quantifier

`∀x ∈ Z: ∃y ∈ Z: x + y = 0`  is **true** (S).

How to read it:
- For every `x ∈ Z` (For hvert x): find some `y ∈ Z` with `x + y = 0`.
- Choose `y = -x`. The `y` is allowed to depend on `x` (y må gerne afhænge af x).

This is the key point of `∀∃`: the inner witness can be chosen per outer value.

### Does quantifier order matter? (Har kvantorernes orden betydning?)

Yes. Swap the two quantifiers above:

`∃y ∈ Z: ∀x ∈ Z: x + y = 0`  is **false** (F).

How to read it:
- Find one `y ∈ Z` such that every `x ∈ Z` satisfies `x + y = 0`.
- Now we must pick a single `y` that works for all `x ∈ Z` at once. No such `y` exists, so it is false.

Takeaway: `∀x ∃y P` and `∃y ∀x P` are not the same. With `∃y ∀x`, the `y` is fixed before `x` ranges, so it cannot adapt to `x`.

### Example: quantifier order with a real-world predicate

Universes:
- `S`: the set of participants in SE4-DMAD (mængden af deltagere)
- `H`: the set of hobbies (mængden af hobbies)
- `P(s,h)`: "s has h as a hobby" (s har h som hobby)

Two readings:

- `∀s ∈ S: ∃h ∈ H: P(s,h)` — "Every participant in SE4-DMAD has a hobby." Each person can have a different hobby.
- `∃h ∈ H: ∀s ∈ S: P(s,h)` — "There is one hobby that all participants in SE4-DMAD have." A single shared hobby.

The second is a stronger claim than the first.

### Example: equal quantifiers can be reordered (Ens kvantorer)

When the quantifiers are the same, you may swap their order freely:

```
∀x ∈ Z: ∀y ∈ Z: (x > y  ⇒  x ≥ y+1)
  ⇕
∀y ∈ Z: ∀x ∈ Z: (x > y  ⇒  x ≥ y+1)
  ⇕
∀x,y ∈ Z:        (x > y  ⇒  x ≥ y+1)
```

The last rewrite (collapsing to `∀x,y ∈ Z`) is valid because `x` and `y` have the **same universe** (samme univers). This works for two `∀`s, and likewise for two `∃`s.

Summary reference in the textbook: Tabel 1.5.1 (p. 63).

### Example: negating nested quantifiers (Negering)

Push the negation inward, flipping each quantifier (`∀ ↔ ∃`) as it passes, until it lands on the predicate.

```
¬∃y ∈ Z: ∀x ∈ Z: x + y = 0
  ⇕
∀y ∈ Z: ¬∀x ∈ Z: x + y = 0
  ⇕
∀y ∈ Z: ∃x ∈ Z: x + y ≠ 0
```

Rule: `¬∃` becomes `∀`, `¬∀` becomes `∃`, and the final `¬(x+y=0)` becomes `x+y ≠ 0`.

### Example: negation — hobbies revisited

Same universes `S`, `H`, `P(s,h)` as above.

Negating the "everyone has a hobby" statement:

```
¬∀s ∈ S: ∃h ∈ H: P(s,h)
  ⇕
∃s ∈ S: ∀h ∈ H: ¬P(s,h)
```

In words: "There is (at least) one participant in SE4-DMAD who has no hobby at all." (Der er mindst en deltager ... som ikke har nogen hobby.)

Negating the "one shared hobby" statement:

```
¬∃h ∈ H: ∀s ∈ S: P(s,h)
  ⇕
∀h ∈ H: ∃s ∈ S: ¬P(s,h)
```

In words: "There is no hobby that is shared by all participants in SE4-DMAD." (Der er ingen hobby, som deles af alle deltagere.)

(Note: in the first block the slide writes `P(x,y)` instead of `P(s,h)` — a slide typo. The second block uses `P(s,h)` correctly.)

---

## Section 1.7 — Proof methods (Bevismetoder)

Three methods to prove an implication or a statement.

### Direct proof (Direkte bevis)

Uses the chain rule:

`(p ⇒ p₁ ⇒ p₂ ⇒ ... ⇒ pₙ ⇒ q)  ⇒  (p ⇒ q)`

to prove `p ⇒ q`. You assume `p` and walk forward through intermediate steps until you reach `q`.

### Proof by contraposition (Kontrapositionsbevis)

Uses the equivalence:

`(p ⇒ q)  ⇔  (¬q ⇒ ¬p)`

to prove `p ⇒ q`. Instead of proving `p ⇒ q` directly, prove `¬q ⇒ ¬p`. (The slide notes this equivalence was proved at the first lecture — bevist ved første forelæsning.)

### Proof by contradiction (Modstridsbevis)

Uses the equivalence:

`(¬p ⇒ F)  ⇔  p`

to prove `p`. Assume `¬p`; if that leads to a contradiction (F, falsk), then `p` must hold.

Justifying truth table:

| p | ¬p | ¬p ⇒ F |
|---|----|--------|
| S | F  | S      |
| F | S  | F      |

The column `¬p ⇒ F` matches the column `p` exactly, which is why `(¬p ⇒ F) ⇔ p`.

### Definition 1.7.1 — even, odd, parity

For every `n ∈ Z`:

- `n` is **even** (lige)  ⇔  `∃k ∈ Z: n = 2k`
- `n` is **odd** (ulige)  ⇔  `∃k ∈ Z: n = 2k+1`

Two integers have the **same parity** (samme paritet) if both are even, or both are odd.

Remark from the slide: these are teaching notes, kept as short as possible, so math notation and prose are sometimes mixed (e.g. writing `n er lige ⇔ ∃k ∈ Z: n = 2k`). You should not normally mix them like that in your own work.

### Example 1.7.1 — direct proof that odd squares are odd

Claim, for every `n ∈ Z`:

`n is odd  ⇒  n² is odd`   (here p = "n is odd", q = "n² is odd")

**Proof (direct):**

```
        n is odd
  (p)
   ⇕
        ∃k ∈ Z: n = 2k+1            , by Def. 1.7.1
  (p₁)
   ⇓
        ∃k ∈ Z: n² = 4k² + 4k + 1
  (p₂)
   ⇕
        ∃k ∈ Z: n² = 2(2k² + 2k) + 1
  (p₃)                  └─ (2k²+2k) ∈ Z, since k ∈ Z
   ⇓
        n² is odd                   , by Def. 1.7.1
  (q)
```

Squaring `n = 2k+1` gives `n² = 4k² + 4k + 1`. Factor out 2: `n² = 2(2k² + 2k) + 1`. Since `2k² + 2k ∈ Z`, this has the form `2·(integer) + 1`, so `n²` is odd by Def. 1.7.1. ∎
