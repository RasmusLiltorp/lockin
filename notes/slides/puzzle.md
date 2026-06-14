# Analysis of Algorithms for the Swap Puzzle

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/puzzleSlides.pdf`

This deck uses a sliding-tile-style "swap puzzle" (ombytningspuslespil) as a motivating problem to introduce algorithm analysis. The goal is to find the exact optimal number of swaps needed to solve a puzzle of n tiles. The key idea is to model a board as a permutation, decompose that permutation into cycles, and prove that the minimum number of swaps is exactly n − k, where k is the number of cycles. It ends with the expected number of cycles in a random permutation (the harmonic number H_n).

## The puzzle and the motivating questions (slide 2)

You play a swap puzzle on the course website. Each move swaps two tiles. The slides pose the questions the rest of the deck answers:

- Which algorithm do you use?
- What are the best- and worst-case running times for a puzzle with n tiles?
- Is the running time related to how many tiles already start in the correct position?
- Is the "greedy algorithm" (put one tile in place per step) optimal, or can you sometimes do better by occasionally *not* placing a tile, so that a later swap places two at once?
- More generally: can we describe the best possible algorithm precisely?

The answer to the greedy question: greedy is optimal in number of swaps. But you can also reach the optimum by sometimes placing two tiles in a single swap (joining two correctly-placed tiles), as long as every swap is within a single cycle. See the conclusion on slide 6.

## Model of the puzzle (slide 3)

Model the tiles as the numbers 1, 2, 3, ..., n. Tile number t is the tile that belongs in position t (tiles are numbered by their target position).

The slide shows a 4x4 board (n = 16):

```
 5 10 14  3            1  2  3  4
 1 11  9 15     →      5  6  7  8
 8  7  2 12            9 10 11 12
 4 13  6 16           13 14 15 16
```

Left is the scrambled start, right is the solved board (each tile in its position).

A board can also be modeled as an array / list of length n. Indices (gray) start at 1:

```
index:  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16
value:  5 10 14  3  1 11  9 15  8  7  2 12  4 13  6 16
```

This array form is the one used in the programming exercises.

Definition — permutation: an arrangement of the numbers 1, 2, ..., n in an array of length n is a permutation.

## The greedy algorithm and its analysis (slide 4)

Problem: solve the puzzle using as few swaps as possible.

Greedy idea: while some tile is out of place, pick a misplaced tile and swap it with whatever tile currently sits in its correct position. That swap puts the picked tile in its home position.

```
WHILE not all tiles in place:
    pick a tile that is not in place
    swap it with the tile occupying its target position
```

Three counting bounds, all from the same observation that no swap ever moves a tile *out* of a correct position under greedy:

1. Max swaps for n tiles. Each swap puts at least one tile in place and no tile leaves its place. So at most n swaps.

2. Max swaps when t tiles already start correct. Same argument, with n − t tiles still to fix. At most n − t swaps.

3. Min swaps when t tiles already start correct. A single swap places at most two tiles. So at least (n − t)/2 swaps.

So the cost sits between (n − t)/2 and n − t. The bounds differ by only a factor of two.

## Cycles (slide 5)

The (n − t)/2 to (n − t) analysis is already fairly tight, but cycles give an exact answer.

Observation: a permutation gives a natural collection of cycles. Let tile (number) t point to the position where it belongs, namely the position with index t. Following these pointers traces out cycles.

The slide shows a 3x4 example board whose tiles form 4 cycles labelled A, B, C, D:

```
        C
   9  3  8  7
A  1  2 12 11  D
   5 10  6  4
        B
```

(Figure 2: a puzzle whose tiles form 4 cycles A, B, C, D.) Tile 2 already sits in position 2, so it is a fixed point — a cycle of length 1. The arrows in the figure trace each cycle: a tile points to the index equal to its value, and you follow until you return to the start.

## Cycles and swaps (slide 6)

This slide states the lemmas/observations and the main theorem. Names follow the slide (Lemma 3, 4, 5, Theorem 1).

### Observation (Lemma 4): how a swap changes the cycle count

- Swapping two tiles **in the same cycle** increases the number of cycles by exactly one (the cycle splits in two).
- Swapping two tiles **in different cycles** decreases the number of cycles by exactly one (the two cycles merge into one).

Proof idea (from the figure): let the swapped tiles be x and y, on fields f1 and f2, whose correct placements are on fields f3 and f4 (possibly f3 = f2 and/or f4 = f1). The swap `swap(x, y)` either splits one cycle into two (reading the figure left to right) or merges two cycles into one (reading right to left). Either way the cycle count changes by exactly ±1.

### Observation (Lemma 3): when a tile is correct

A tile is in place ⇔ it lies in a cycle of length one (a fixed point).

Therefore: the puzzle is solved ⇔ there are exactly n cycles (every tile is its own length-1 cycle).

### Lemma 5: greedy swap count

The greedy algorithm needs exactly n − k swaps to solve a puzzle with n tiles and k cycles at the start.

Proof: greedy always swaps two tiles from the same cycle (it picks a misplaced tile x and swaps it with the tile y sitting in x's target position; y comes immediately after x in the cycle). By Lemma 4 each such same-cycle swap increases the cycle count by one. You start with k cycles and finish with n cycles (Lemma 3), so you perform exactly n − k swaps.

### Theorem 1 (main result)

To solve a puzzle with n tiles and k cycles at the start, exactly n − k swaps are required.

Proof:
- Upper bound (n − k swaps suffice): follows from Lemma 5 — greedy does it in n − k.
- Lower bound (you cannot do it with fewer): no swap can increase the cycle count by more than one (Lemma 4), and you must go from k cycles to n cycles. So you need at least n − k swaps.

### Conclusions on slide 6

- A puzzle with n tiles and k cycles in the start position requires at least n − k swaps, and can always be done in n − k swaps. (One way: the greedy algorithm, which at each step splits a cycle of length t into cycles of length t − 1 and 1.)
- An algorithm uses the optimal number of swaps (n − k) **if and only if** every swap is between two tiles that are in the same cycle.

That last point answers the greedy question from slide 2: greedy is optimal, and so is any other algorithm that never swaps across two different cycles.

## Expected number of cycles — random puzzles (slide 7)

Not all puzzles need the same number of swaps. By Theorem 1 the decisive quantity is the number of cycles k in the permutation. If permutations are chosen uniformly at random (all permutations equally likely), the slide gives the expected cycle count.

Theorem 2 (stated without proof here): the expected number of cycles in a random permutation of n tiles is the n-th harmonic number

\( H_n = \sum_{i=1}^{n} \frac{1}{i} \).

It follows that the expected optimal number of swaps for a random puzzle is

\( n - H_n = n - \sum_{i=1}^{n} \frac{1}{i} \).

H_n is the n-th harmonic number, approximated by

\( H_n \approx \ln n + \gamma + \frac{1}{2n} - \frac{1}{12 n^2} + \frac{1}{120 n^4} - \frac{1}{252 n^6} + \cdots \),

where \( \gamma = 0.577215664901\ldots \) is the Euler–Mascheroni constant.

### Simulation (the chart)

A simulation of 10,000,000 random permutations for n = 64 gives the distribution of the number of cycles. The bar chart (y-axis in %, peaking around 20%) shows the counts by number of cycles (x-axis "antal cykler" = number of cycles, 1 through 18):

| cycles | count | cycles | count | cycles | count |
|---|---|---|---|---|---|
| 1 | 148529 | 7 | 886375 | 13 | 1422 |
| 2 | 728362 | 8 | 418886 | 14 | 393 |
| 3 | 1632232 | 9 | 168591 | 15 | 95 |
| 4 | 2239366 | 10 | 59330 | 16 | 17 |
| 5 | 2144855 | 11 | 18833 | 17 | 2 |
| 6 | 1547248 | 12 | 5463 | 18 | 1 |

The distribution peaks around k = 4–5 cycles. Takeaway: for n = 64 you have to be very lucky to draw an easy input with k close to n. Most random puzzles have few cycles, so most need close to n swaps.

(Figure credit on the slide: Gerth Brodal.)
