# Invariants (Loop Invariants and Correctness Proofs)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/invariantSlides.pdf`

The deck defines what a loop invariant is and shows how it is the tool both for finding an algorithm and for proving it correct. It walks through invariants for six algorithms seen earlier in the course (insertion sort, Quicksort partition, build-heap, heapsort, BST search, red-black tree rebalancing), then formalizes the idea, links it to induction (the domino principle), and ends with a fully concrete code-level example: finding the maximum element of an array.

## What an invariant is

Definition (slide 2): An invariant is a property that the algorithm maintains throughout (parts of) its execution.

It is often the core of both the idea behind the algorithm and the argument that the algorithm works.

The standard correctness argument has the same shape every time:
1. State an invariant that holds throughout the loop.
2. Describe the state when the loop stops (the termination condition).
3. Combine invariant + stop condition to conclude the algorithm produced the correct result.

## Example 1 — Insertion sort (slide 2)

The array is processed left to right. A "black field" marks the current element being inserted; everything left of it has already been placed.

Invariant: **everything to the left of the black field is sorted.**

When the loop stops: the whole array is to the left of the black field.

From the invariant it follows: the whole array is sorted. So the algorithm is correct.

The slide shows the worked figure across panels (a)–(f) on a 6-element array: the black field marks the element being inserted, and the sorted prefix to its left grows by one element each step until the whole array is sorted.

## Example 2 — Quicksort partition (slide 3)

Partition arranges a subarray relative to a pivot `x`. The figure uses pointers `p, i, j, r`: light-gray region holds values `≤ x`, dark-gray region holds values `> x`, and the part from `i` to `j` (white/"unrestricted") has not been examined yet.

Invariant: **light-gray part ≤ x < dark-gray part.**

When the loop stops: only `x` is white; the rest is either light-gray or dark-gray.

From the invariant it follows: the array is split into three parts — "≤ x", "> x", and `x` itself. So the algorithm is correct.

## Example 3 — Build-Heap (slide 4)

Build-Heap turns an arbitrary array into a heap by running heapify (sift-down) on nodes from high index toward the root. The "dark node" is the node currently being processed; the figure shows the tree across panels as the dark node moves up.

Invariant: **subtrees whose root has an index larger than the dark node satisfy heap order.**

When the loop stops: the root of the whole tree has an index larger than the dark node (i.e. the dark node has passed the root / processing reached index 1).

From the invariant it follows: the whole tree satisfies heap order. So the algorithm is correct.

## Example 4 — Heapsort (and any selection-sort-based sort) (slide 5)

The figure shows a heap shrinking: dark nodes are the sorted, finished portion (extracted maxima sitting at the back of the array); light nodes are still in the heap. The bottom panel shows the final sorted array `1 2 3 4 5 6 7 8 9 10`.

Invariant: **the dark part is sorted, and everything in the light part is ≤ the dark part.**

When the loop stops: the whole array is dark.

From the invariant it follows: the whole array is sorted. So the algorithm is correct.

This invariant is stated as covering "any selection-sort-based sorting" — heapsort is the heap-backed version, but the same invariant fits plain selection sort.

## Example 5 — Search in binary search trees (slide 6)

Search for key `k` descends from the root into one child at each step, walking into smaller and smaller subtrees.

Invariant: **if the searched element `k` exists, it is in the subtree we have arrived at.**

The algorithm must stop because we look at smaller and smaller subtrees (the subtree shrinks every step, so the process is finite).

When the algorithm stops: either `k` is found, or we have ended in an empty subtree.

In the empty-subtree case the invariant gives: `k` is not in the tree. So the algorithm is correct in both cases (found / not found).

## Example 6 — Red-black tree rebalancing (slide 7)

Two invariants, one per operation. Both track a single localized "problem" that gets pushed toward the root.

Invariant during rebalancing after **insertion** into a red-black tree:
> There can be two red nodes in a row on one path at one spot in the tree; apart from that, the red-black requirements hold. After `k` iterations there are `k` fewer black nodes between the problem and the root than at the start.

Invariant during rebalancing after **deletion** from a red-black tree:
> There can be one "blackened" (doubly-black) node at one spot in the tree, and if the blackening is counted, the red-black requirements hold. After `k` iterations there are `k` fewer black nodes between the problem and the root than at the start.

The invariant proves several things that together make the algorithm correct:
- The same case analysis works every time (it always covers all possibilities, so the algorithm cannot get stuck as long as the problem is unsolved).
- The algorithm must stop: either the problem disappears, or it reaches the root (where it is easy to resolve). The "k fewer black nodes between problem and root" clause guarantees this — the distance to the root strictly decreases, so termination is forced.

## Invariants, more formally (slide 8)

An invariant for an algorithm is:
- A statement about the contents of memory (variables, arrays, ...) that is true after every step.
- At the algorithm's end, correctness can be derived from the statement (together with the circumstances that made the algorithm stop, i.e. the termination condition).

## Induction — proving the invariant holds (slide 9)

That an invariant holds after every step is proven by induction:

1. Invariant holds at the start.
2. Invariant holds before a step ⇒ invariant holds after the step.

⇒ Invariant always holds.

Here a "step" is usually one iteration of a loop. So in practice: prove 1) and 2).

Induction is the "domino principle":
1. Domino 1 falls.
2. Domino `k` falls ⇒ domino `k+1` falls.

⇒ All dominoes fall.

Mapping: (1) is the base case, (2) is the inductive step.

## Using invariants — two levels of detail (slide 10)

Invariants can be used at two levels, with a sliding transition between them:

1. As a tool to develop algorithm ideas. With the right invariant you capture the essence of the method, and the algorithm "just" has to be written so that this invariant is maintained.
2. As a tool to write down code (or detailed pseudocode) and prove that concrete code correct.

At level 1, softer descriptions (text, figures) are appropriate — the earlier examples (insertion sort, partition, build-heap, heapsort, BST search, red-black) illustrate level 1.

At level 2 you must state the invariant precisely in terms of the concrete variables from the code, and argue via the concrete code's changes to those variables. The next slide does level 2 on a simple example.

## Level-2 worked example — find the maximum element (slide 11)

Problem: find the largest element in an array `A`.

Idea: scan left to right, keeping the best value seen so far in `m`.

```
m = A[0]
i = 1
while i < A.length
    m = maximum(m, A[i])
    i = i + 1
return m
```

Invariant (stated in concrete code variables): **after the `k`-th iteration of the while-loop, `m` contains the largest value of `A[0..(i-1)]`.**

This is proven by induction on `k`.

Proof sketch matching the slide's invariant:
- Base (`k = 0`, before the loop): `m = A[0]` and `i = 1`, so `m` is the max of `A[0..0]`. Invariant holds.
- Step: before iteration `k+1`, `m` is the max of `A[0..i-1]`. The body sets `m = maximum(m, A[i])` then `i = i+1`, so afterward `m` is the max of `A[0..i-1]` for the new `i`. Invariant preserved.
- Termination: the loop stops when `i = A.length`, so `m` is the max of `A[0..A.length-1]`, the whole array.

Worked trace from the slide (array `A = [5, 12, 9, 15, 4, 1]`, indices 0–5):

| Iteration of while-loop | i | m (largest of A[0..i-1]) |
|---|---|---|
| 0 (before loop) | 1 | 5 |
| 1 | 2 | 12 |
| 2 | 3 | 12 |
| 3 | 4 | 15 |
| 4 | 5 | 15 |
| 5 | 6 | 15 |

After iteration 5, `i = 6 = A.length`, the loop exits, and `m = 15` is returned — the maximum of the array.

## Key takeaways

- An invariant is a property true after every step of the loop; pair it with the termination condition to get correctness.
- The proof technique behind "true after every step" is induction (base case + inductive step = domino principle).
- Level 1 (informal, picture-based) is for designing algorithms; level 2 (variables, code) is for proving concrete code correct.
- The "distance shrinks each iteration" clause (red-black, BST search) is what proves termination, not just correctness.
