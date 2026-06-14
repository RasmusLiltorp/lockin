# Algorithms for the Max Sum Problem

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/maxSumSlides.pdf`

This deck introduces the maximum subarray sum problem and develops three algorithms for it, going from \(\Theta(n^3)\) down to \(\Theta(n)\) (Kadane's algorithm). It motivates the problem with stock analysis, shows how a maximum-product question turns into a maximum-sum question using logarithms, and proves each algorithm correct by an observation that lets the next algorithm reuse the previous one's work.

## The Max Sum problem

Given an array (list) of numbers, you look at sums of *segments* (subarrays — contiguous slices). The question: which segment has the largest sum?

The slide shows a 16-element array (indices 0..15):

```
idx:  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15
val:  6 -1  2 -4  5  3 -1  2 -6  0  8 12 -4  6  8  4
```

The highlighted segment from index 3 to 10 gives the sum

\[
(-4) + 5 + 3 + (-1) + 2 + (-6) + 0 + 8 = 7
\]

Called "a simple and fundamental problem."

**Definition.** The empty segment of length zero is also a legal segment, with value 0. This matters: it means the answer is never negative — if every element is negative, the best segment is the empty one with value 0.

## Motivation: stock analysis

The slide shows a euroinvestor.dk price chart as motivation. The data has this form — daily percentage changes for a company X:

```
2023.02.20  2023.02.21  2023.02.22  2023.02.23  2023.02.24  2023.02.25  2023.02.26
   +2%         -3%         +8%         -1%         -3%         +3%        +11%
```

Question: in which period would it have been best to own the stock?

### Percentage arithmetic

- 1000 kr rising 3% becomes \(1000 \cdot 1.03 = 1030\) kr.
- 1000 kr falling 2% becomes \(1000 \cdot 0.98 = 980\) kr.
- 1000 kr first rising 3% then falling 2% becomes \(1000 \cdot 1.03 \cdot 0.98 = 1009.40\) kr.

So percentage changes *multiply*. For the period 02.21 to 02.25 (the -3%, +8%, -1%, -3%, +3% days, marked on the slide), the stock changes by a factor

\[
0.97 \cdot 1.08 \cdot 0.99 \cdot 0.97 \cdot 1.03
\]

Converting each daily percentage change into a multiplier:

```
+2%   -3%   +8%   -1%   -3%   +3%   +11%
1.02  0.97  1.08  0.99  0.97  1.03  1.11
```

So the real question becomes: **which segment has the largest product?**

## From maximum product to maximum sum

Logarithms are increasing functions, so for any positive numbers

\[
0.94 \cdot 1.05 \cdot 0.99 \le 0.96 \cdot 1.03 \cdot 1.01
\]

if and only if

\[
\log(0.94 \cdot 1.05 \cdot 0.99) \le \log(0.96 \cdot 1.03 \cdot 1.01).
\]

Since \(\log(x \cdot y) = \log(x) + \log(y)\), this holds if and only if

\[
\log(0.94) + \log(1.05) + \log(0.99) \le \log(0.96) + \log(1.03) + \log(1.01).
\]

So the segment with the largest *product* in the multiplier array is the same segment as the one with the largest *sum* in the array of logs. Applying \(\log\) to each multiplier:

```
1.02      0.97      1.08      0.99      0.97      1.03      1.11
log values:
0.0286   -0.0439    0.1110   -0.0145   -0.0439    0.0426    0.1506
```

Taking logs turns the max-product problem into a max-sum problem on these numbers (which is why the rest of the deck only solves max sum).

## Algorithms for MaxSum: the brute-force idea

We need the sum of all segments. The natural algorithm straight from the definition: for all \(i\) and all \(j \ge i\), compute the sum from \(i\) up to and including \(j\). A third index \(k\) walks from \(i\) to \(j\) to add up the elements.

### Algorithm 1 — MaxSum1, \(\Theta(n^3)\)

Three nested loops: pick start \(i\), pick end \(j\), then sum elements \(k\) from \(i\) to \(j\) from scratch.

```
MaxSum1(n)
  maxSoFar = 0
  for i = 0 to n - 1
    for j = i to n - 1
      sum = 0
      for k = i to j
        sum += A[k]
      maxSoFar = max(maxSoFar, sum)
  return maxSoFar
```

- **Correct?** Follows directly from the definition of the problem — it literally computes every segment's sum and keeps the max. `maxSoFar` starts at 0, which covers the empty segment.
- **Running time?** \(\Theta(n^3)\), by the same argument as "Algorithm 3" from the asymptotic-analysis examples (same loop structure: three nested loops over ranges).

## Observation that lets us speed up

The key reuse insight:

\[
(-4) + 5 + 3 + (-1) + 2 + (-6) + 0 = -1
\]
\[
\Downarrow
\]
\[
(-4) + 5 + 3 + (-1) + 2 + (-6) + 0 + 8 = (-1) + 8 = 7
\]

The sum of the segment ending at \(j\) equals the sum of the segment ending at \(j-1\) plus \(A[j]\). So you don't need to recompute the whole sum for each new \(j\) — one addition extends it.

### Improved idea (drops the inner k-loop)

Algorithm: for each fixed \(i\), compute the sums for increasing \(j\) using one new addition per sum.

### Algorithm 2 — MaxSum2, \(\Theta(n^2)\)

```
MaxSum2(n)
  maxSoFar = 0
  for i = 0 to n - 1
    sum = 0
    for j = i to n - 1
      sum += A[j]
      maxSoFar = max(maxSoFar, sum)
  return maxSoFar
```

- **Correct?** Follows from the definition plus the observation above (extend by one addition instead of resumming).
- **Running time?** \(\Theta(n^2)\), by roughly the same argument as "Algorithm 2" from the asymptotic-analysis examples (two nested loops).

## A new observation (toward linear time)

Adding the same constant to a set of numbers does not change which one is the maximum:

\[
x_1 \le x_2 \iff x_1 + 2 \le x_2 + 2
\]

From which it follows that

\[
\max\{x_1 + 2, x_2 + 2, \dots, x_i + 2\} = \max\{x_1, x_2, \dots, x_i\} + 2.
\]

**Idea:** can we look at segments in *piles* (Danish "bunker"), so that the new pile equals the old pile with every segment extended by the same value?

### The pile (bunke) idea

Let **pile \(i\)** be all segments that end at \(A[i]\)'s right edge. Then pile \(i\) equals pile \(i-1\) with every segment extended by the same value \(A[i]\), *plus* the empty segment:

- The empty segment is not an extension — its value is 0. (This is what lets the running max reset to 0 / never go negative.)
- Pile \(i-1\) with all segments extended by the same value \(A[i]\): by the observation above, the new max of those extended segments is (old max value) \(+\ A[i]\).

So if `maxEndingHere` is the best sum of a segment ending exactly at position \(i\), then

\[
\text{maxEndingHere}_i = \max(\text{maxEndingHere}_{i-1} + A[i],\ 0),
\]

the 0 coming from the empty segment option. The diagram (slide 15) shows, at boundary \(i\), the empty segment of value 0 plus all the previous pile's segments each pushed one cell to the right and increased by \(A[i]\).

### Algorithm 3 — MaxSum3 (Kadane's algorithm), \(\Theta(n)\)

```
MaxSum3(n)
  maxSoFar = 0
  maxEndingHere = 0
  for i = 0 to n - 1
    maxEndingHere = max(maxEndingHere + A[i], 0)
    maxSoFar = max(maxSoFar, maxEndingHere)
  return maxSoFar
```

- **Correct?** Follows from the problem definition plus the new observation, which guarantees we take the maximum over *all* segments — because every segment belongs to some pile, namely the pile for the index \(i\) where the segment ends. `maxEndingHere` tracks the best segment ending at \(i\); `maxSoFar` tracks the best over all positions seen.
- **Running time?** There are \(n\) iterations, each taking \(\Theta(1)\) time. Total: \(\Theta(n)\).
- **Space:** \(O(1)\) — two scalar variables, no extra array.

## Summary of the three algorithms

| Algorithm | Idea | Time |
|-----------|------|------|
| MaxSum1 | Brute force: resum every segment from scratch (3 loops) | \(\Theta(n^3)\) |
| MaxSum2 | For each start \(i\), extend the running sum by one addition per \(j\) | \(\Theta(n^2)\) |
| MaxSum3 | Piles: best segment ending at \(i\) = \(\max(\text{prev}+A[i],\,0)\) | \(\Theta(n)\) |

The progression is the point: each speedup comes from an observation that lets the algorithm reuse work the previous version threw away. The empty-segment-value-0 convention is what makes the `max(..., 0)` reset in MaxSum3 correct.
