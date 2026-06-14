# Greedy Algorithms (Grådige algoritmer)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/greedySlides.pdf`

The deck introduces the greedy paradigm for combinatorial optimization: build a solution piece by piece by always taking the locally best choice. It works through three case studies — activity/booking scheduling (greedy works), the knapsack problem (fractional works, 0-1 does not), and Huffman coding for prefix-free compression. The recurring theme is that a greedy choice needs a proof, usually an exchange/swap argument or a loop invariant, before you can trust it gives a global optimum.

## The greedy paradigm

A general algorithm-construction principle ("paradigm") for combinatorial optimization problems. Idea: build the solution bit by bit, always choosing what looks like the "best choice" right now, without thinking about the rest of the solution. You hope that local optimization yields global optimization.

Pseudocode template:

```
Start with an empty structure S
While S is not a solution:
    Choose the building block x that looks best right now
    S = S with x added
Return S
```

The method requires two things to be made precise:
1. A definition of "the best choice right now" (the greedy choice).
2. A proof that repeated use of this choice ends in an optimal solution.

The hope (local optimum -> global optimum) does not hold automatically. You must prove it per problem.

## Activity / booking scheduling

### Problem

- Input: a collection of booking requests for one resource, each with a start time and an end time.
- Output: a largest possible set of non-overlapping bookings.

The slide shows a timeline with 12 non-overlapping requests and asks whether 12 is the maximum. It is, but that is not obvious by eye, so you need an algorithm. Try the greedy method.

### Candidate greedy choices

A still-selectable activity must not overlap any already-chosen activity in S. Among the remaining non-overlapping activities, proposals for which to pick:

- The shortest activity.
- The activity that overlaps the fewest other (remaining) activities.
- The activity that starts first.
- The activity that finishes first.

The first three can be defeated by counterexamples (left as exercises) — they do not always reach a global optimum. The fourth one (finish first) works for all inputs, and the deck proves it.

### The algorithm (earliest finish time)

Greedy choice: among remaining activities with no overlap with already-chosen ones, take the one that finishes first.

```
Sort activities by increasing finish time
For each activity a in that order:
    If a overlaps an already-chosen activity:
        Skip a
    Else
        Choose a
```

The slide illustrates the picked set on the timeline (the chosen bars form a maximal non-overlapping chain, each starting after the previous one ends).

### Correctness invariant

Invariant to prove:

> There exists an optimal solution OPT that contains the activities chosen by the algorithm so far.

Why the invariant gives correctness when the algorithm finishes: the algorithm's chosen activities lie inside some optimal OPT. By how the algorithm works, every non-chosen activity overlaps one of the chosen ones, so the algorithm's solution cannot be extended and still be valid. So OPT cannot be larger than the algorithm's solution, hence the algorithm's solution equals OPT.

### Proof of the invariant (induction)

**Basis:** Clear before the first iteration of the for-loop, since no activity is chosen yet.

**Step:** Let OPT be the optimal solution from the induction hypothesis before the iteration. Show there is an optimal OPT' satisfying the hypothesis after the iteration.

- **If-case (skip):** The algorithm chooses nothing new, so OPT can be used as OPT'.
- **Else-case (choose):** Take the activities sorted by increasing finish time \(a_1, a_2, \dots, a_n\). Let \(a_i\) be the algorithm's most recently chosen activity, and \(a_j\) the activity chosen in this iteration. By the invariant, OPT contains \(a_i\). In OPT, \(a_i\) cannot be the last (else OPT could be extended with \(a_j\)). Let \(a_k\) be the next activity in OPT after \(a_i\). Since \(a_j\) is the first activity (in the sorted order) after \(a_i\) that does not overlap \(a_i\), we have \(j \le k\). If \(j = k\), use OPT as OPT'. Otherwise swap \(a_k\) out of OPT for \(a_j\). This causes no overlap with the other activities in OPT (they either stop before \(a_i\), or stop after \(a_k\) — in the latter case they start after \(a_k\) and hence after \(a_j\)), and keeps the same size. So after the swap we have a new optimal OPT' satisfying the invariant.
- Note: in the first iteration \(a_i\) does not exist, but set \(j = 1\) and argue similarly. ∎

### Running time

Sorting + O(n). So O(n log n) overall (sort dominates).

## The knapsack problem (Rygsæksproblemet)

### Setup

A knapsack that can carry W kg. Items each with a value and a weight. Goal: take as much value as possible without exceeding the weight limit.

Example table from the slide:

| Item i   | 1  | 2  | 3  | 4  | 5  | 6 | 7  |
|----------|----|----|----|----|----|---|----|
| Weight wᵢ| 4  | 6  | 2  | 15 | 7  | 4 | 5  |
| Value vᵢ | 45 | 32 | 12 | 50 | 23 | 9 | 15 |

### Fractional knapsack — greedy works

In the "fractional" version, parts of items may be taken. It is solved greedily: choose items by decreasing "value density" = value/weight. A simple exchange argument shows the optimal solution can only look like the one the algorithm picks.

### 0-1 knapsack — greedy fails

This greedy algorithm does NOT work for the 0-1 version (only whole items may be taken). The slide shows a worked counterexample with three items and a knapsack of capacity 50:

- item 1: weight 10, value $60 (density 6)
- item 2: weight 20, value $100 (density 5)
- item 3: weight 30, value $120 (density 4)

Greedy by density takes item 1 then item 2: weight 30, value $160. It could also add item 1 + item 3 = weight 40, value $180. The actual 0-1 optimum is items 2 + 3 = weight 50, value $220. Greedy by density gives $160 (or $180), not the optimal $220. The slide also shows the fractional optimum on the same input: item 1 + item 2 + 20/30 of item 3 fills the full 50 kg for $240, beating any 0-1 packing.

This is the deck's example that "greedy choices" cannot just be assumed to work for all problems — local optimization does not always give global optimization.

## Bit patterns and character encoding

A bit pattern (e.g. `01101011 0001100101011011...`) has no meaning until interpreted. It can stand for letters, numbers (integers, floats), a computer instruction (program), pixels (image file), amplitude (sound file), and so on. Focus of the lecture: letters (and other characters).

### ASCII (fixed-width)

A classic representation. Examples:

```
a: 1100001
b: 1100010
c: 1100011
d: 1100100
```

Every character uses 7 bits (fixed-width codes).

## Huffman codes

### Motivation

Is fixed-width coding the shortest possible representation of a file of characters? It depends on the file's content. Example file with 6 characters and their frequencies (in thousands):

| Char                    | a   | b   | c   | d   | e    | f    |
|-------------------------|-----|-----|-----|-----|------|------|
| Frequency (thousands)   | 45  | 13  | 12  | 16  | 9    | 5    |
| Fixed-length codeword   | 000 | 001 | 010 | 011 | 100  | 101  |
| Variable-length codeword| 0   | 101 | 100 | 111 | 1101 | 1100 |

Fixed-width cost: \(3 \cdot (45{,}000 + 13{,}000 + \cdots + 5{,}000) = 300{,}000\) bits.

Variable-width cost: \(1 \cdot 45{,}000 + 3 \cdot 13{,}000 + \cdots + 4 \cdot 5{,}000 = 224{,}000\) bits.

Goal: shortest possible representation of a file. Saves disk space and transport time over a network.

### Prefix codes = trees

A codeword = a path in a binary tree: 0 means go left, 1 means go right.

Prefix-free code: no character's code is the start (prefix) of another character's code, so decoding is unambiguous. Characters correspond to nodes with zero children (leaves).

For a given file (characters and their frequencies), find the best variable-width prefix code. That is, with Cost(tree) = |encoded file|, find the tree with the lowest cost.

Optimal trees cannot have a node with only one child: every character in such a node's subtree could be shortened by one bit. So only nodes with two children or zero children occur. (The slide shows two example trees (a) and (b) — (a) is the suboptimal fixed-width-style tree, (b) the optimal Huffman tree.)

### Huffman's algorithm [David Huffman, 1952]

Build bottom-up (from smallest to largest frequencies) by repeatedly making this greedy choice: merge the two subtrees with the two smallest total frequencies.

```
Build a min-priority queue of n single-leaf trees, keyed by frequency
For n-1 iterations:
    x = ExtractMin   # smallest-weight tree
    y = ExtractMin   # next smallest-weight tree
    z = new tree with children x and y, weight = weight(x) + weight(y)
    Insert z
Return the one remaining tree
```

Worked example (frequencies f:5, e:9, c:12, b:13, d:16, a:45), step by step as shown on the slide:

- (a) Start: leaves f:5, e:9, c:12, b:13, d:16, a:45.
- (b) Merge f:5 and e:9 -> node 14. Trees: c:12, b:13, (14), d:16, a:45.
- (c) Merge c:12 and b:13 -> node 25. Trees: (14), d:16, (25), a:45.
- (d) Merge (14) and d:16 -> node 30. Trees: (25), (30), a:45.
- (e) Merge (25) and (30) -> node 55. Trees: a:45, (55).
- (f) Merge a:45 and (55) -> root 100. Final tree.

This matches the variable-length codewords above (a is the shortest at depth 1; f and e are deepest at length 4).

### Running time

Given a table of n characters and their frequencies, Huffman's algorithm runs n − 1 iterations. (There are n trees at start, one at the end, and each iteration decreases the count by exactly one.)

Using a min-priority queue (e.g. a heap), each iteration does:

- two ExtractMin operations,
- one Insert operation,
- O(1) other work.

Each priority-queue operation takes O(log n). So total running time over the n iterations is **O(n log n)**.

### Correctness

Summary: Huffman maintains a collection of trees F. The weight of a tree is the sum of the frequencies in its leaves. Each step merges the two trees with the smallest weights, until only one tree remains.

Invariant to prove:

> The trees in F can be merged into an optimal tree.

When the algorithm stops, F has only one tree, which by the invariant must be an optimal tree.

**Proof by induction over the number of steps.**

**Basis:** No steps taken. F consists of n trees, each a single leaf. These are the leaves of every tree, including optimal ones, so the invariant clearly holds.

**Induction step:** Assume the invariant holds before a step; show it holds after. Let the trees in F (before the step) be \(t_1, t_2, t_3, \dots, t_k\) ordered so that by weight \(t_1 \le t_2 \le t_3 \le \cdots \le t_k\), and the algorithm merges \(t_1\) and \(t_2\). By the induction hypothesis the trees can be merged into an optimal tree. Let T be the "top" of that tree — a tree whose leaves are the roots of \(t_1, t_2, t_3, \dots, t_k\).

**Case 1: the roots of \(t_1\) and \(t_2\) are siblings in T.** After merging \(t_1\) and \(t_2\), the new collection can still be assembled into the same optimal tree from the invariant before the step. So the invariant holds again.

**Case 2: the roots of \(t_1\) and \(t_2\) are not siblings in T.** Find another top-tree \(T'\) (another way of assembling the trees in F) that is also optimal and where \(t_1\) and \(t_2\) are siblings. For \(T'\) we are back in Case 1, and done.

Constructing \(T'\) from T: look at a deepest leaf in T. Since \(k \ge 2\) (else Huffman would be finished), the leaf has a parent. That parent has at least one subtree, so it has two (in optimal trees no node has exactly one subtree, as noted earlier). Its other subtree must be a leaf, otherwise the first leaf would not be a deepest leaf. So there are two leaves in T that are siblings and both of maximum depth. Let them hold the roots of \(t_i\) and \(t_j\), with \(i < j\).

The possible situations and the swap that produces \(T'\) from T (table on the slide, where columns 1, 2, 3... are sorted positions and i, j mark which trees sit at the two deepest sibling leaves):

| Situation                | Action giving T' from T            |
|--------------------------|------------------------------------|
| i and j at positions 1,2 | None (already Case 1)              |
| i at position 1, j later | Swap \(t_2\) and \(t_j\)           |
| i at position 2, j later | Swap \(t_1\) and \(t_j\)           |
| both i, j later          | Swap \(t_1\) with \(t_i\), and \(t_2\) with \(t_j\) |

Why a swap does not hurt (for swapping \(t_1\) and \(t_i\)): \(t_i\)'s root has at least the same depth as \(t_1\)'s root, and \(t_i\)'s total frequency is at least as large as \(t_1\)'s. So more characters in the file get shorter codewords than get longer ones. The change in codeword length is the same for both the lengthening and the shortening (the depth difference between \(t_1\) and \(t_i\)). So the encoded file's length does not increase under the swap — the tree cannot get worse. The same argument works for swapping \(t_1\) and \(t_j\), and for \(t_2\) and \(t_j\).

Since T was optimal before the swap, \(T'\) after the swap is also optimal, and \(t_1\) and \(t_2\) are siblings in \(T'\), as wanted. ∎

## Key takeaways

- Greedy needs both a defined greedy choice and a correctness proof.
- Activity selection: earliest-finish-time greedy is optimal; proof is a loop invariant ("some OPT contains the picks so far") plus an exchange argument. Runtime O(n log n) from sorting.
- Knapsack: greedy by value/weight is optimal for the fractional version, but fails for 0-1 (counterexample gives $160 vs optimal $220).
- Huffman: merge the two lowest-weight trees; gives an optimal prefix code in O(n log n) with a heap. Correctness by induction with an exchange argument on deepest sibling leaves.
- Optimal prefix-code trees are full binary trees (every internal node has exactly two children).
