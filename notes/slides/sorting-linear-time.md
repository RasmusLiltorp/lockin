# Sorting in Linear Time?

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/sortingInLinearTimeSlides.pdf`

This deck proves that any comparison-based sorting algorithm needs \(\Omega(n \log n)\) comparisons in the worst case, using the decision-tree model. It then shows two algorithms that beat that bound by not using comparisons: counting sort, which sorts integers in a small range in \(O(n+k)\), and radix sort, which sorts \(d\)-digit integers in \(O(d(n+k))\) by repeatedly applying a stable sort digit by digit. The radix-sort examples show how the same fixed-width integers can be re-grouped into different bases to make the sort run in \(O(n)\).

## The lower bound for comparison-based sorting

This is a lower bound for *all* sorting algorithms, so it needs a precise definition of what a sorting algorithm is. The proof works for the comparison-based class.

A comparison-based sorting algorithm:
- **Basic operation:** compare two input elements and, based on the outcome, choose between two ways to continue.
- **Answer:** the rearrangement that must be done to reach sorted order.
- **ID of an element:** its *original* position (index) in the input.

If we annotate every input element with its original position up front, then in any concrete algorithm (e.g. insertion sort) we can always track which two IDs are being compared.

Annotation example:

```
F, A, C, B, E, D  →  (F,1), (A,2), (C,3), (B,4), (E,5), (D,6)
```

## Decision trees

A decision tree is the precise model that defines "comparison-based sorting algorithm".

- **Internal node labels:** the IDs (original input indices) of the two elements being compared. Written `i:j`.
- **Leaf labels** (the answer when the algorithm stops): the rearrangement needed to reach sorted order, given as a list of IDs (original indices). Written e.g. \(\langle 1,2,3 \rangle\).
- **Worst-case running time:** the longest root-to-leaf path = the height of the tree.

Each comparison has two outcomes (the slide labels the edges \(\le\) and \(>\)), so the tree is binary.

Worked tree from the slide (3 elements, comparisons by index):

```
                1:2
          ≤  /        \  >
          2:3          1:3
        ≤ /  \ >      ≤/   \>
  <1,2,3>   1:3   <2,1,3>   2:3
          ≤/  \>          ≤/  \>
    <1,3,2>  <3,1,2>  <2,3,1>  <3,2,1>
```

This tree has \(3! = 6\) leaves, one per possible sorted ordering.

Insertion sort, selection sort, merge sort, quicksort and heapsort can all be described this way.

## The lower bound proof

For a fixed set of \(n\) elements there are \(n! = 1\cdot 2\cdot 3\cdot 4\cdot 5 \cdots n\) different inputs (orderings of the elements).

If the algorithm (tree) must sort all of them, it needs at least \(n!\) leaves. Otherwise two different inputs would reach the same leaf (same answer), and for at least one of them that answer would be wrong.

A tree of height \(h\) has at most \(2^h\) leaves (the full binary tree of height \(h\) has exactly that many). So:

\[
2^h \ge \text{number of leaves} \ge n!
\]

Taking logs:

\[
h \ge \log(n!) = \log(1\cdot 2\cdot 3 \cdots n) = \log 1 + \log 2 + \cdots + \log n
\]

Keep only the upper half of the terms (the terms from \(n/2\) to \(n\)), each of which is at least \(\log(n/2)\), and there are \(n/2\) of them:

\[
\ge \frac{n}{2}\cdot \log\!\left(\frac{n}{2}\right) = \frac{n}{2}\big(\log n - 1\big)
\]

So worst-case running time = tree height \(h = \Omega(n \log n)\).

The point: no comparison-based sort can beat \(\Omega(n \log n)\). To go faster you must not use comparisons.

## Counting sort

Assumes keys are integers of size up to \(k\). Then the elements themselves can be used as array indices — that is the trick, and it is different from comparing elements.

**Problem:** sort \(n\) integers with values between 0 and \(k\) (inclusive).

Arrays used:
- Input array \(A\) (length \(n\)).
- Output array \(B\) (length \(n\)).
- Counter array \(C\) (length \(k+1\)), one counter per possible value.

### Idea

1. Count how many times each value occurs (fill \(C\)).
2. Turn the counts into a running total (prefix sum), so \(C[i]\) becomes the number of elements \(\le i\). That tells you the final position of the last element with value \(i\).
3. Walk \(A\) from the back, place each element at its position in \(B\), and decrement its counter.

### Pseudocode

```
COUNTING-SORT(A, n, k)
1   let B[1:n] and C[0:k] be new arrays
2   for i = 0 to k
3       C[i] = 0
4   for j = 1 to n
5       C[A[j]] = C[A[j]] + 1
6   // C[i] now contains the number of elements equal to i
7   for i = 1 to k
8       C[i] = C[i] + C[i-1]
9   // C[i] now contains the number of elements less than or equal to i
10  // Copy A to B, starting from the end of A
11  for j = n downto 1
12      B[C[A[j]]] = A[j]
13      C[A[j]] = C[A[j]] - 1   // to handle duplicate values
14  return B
```

### Worked example (from the slide)

Input \(A = [2, 5, 3, 0, 2, 3, 0, 3]\) (indices 1..8), with \(k = 5\).

(a) After counting (step 5), \(C[0..5] = [2, 0, 2, 3, 0, 1]\) — there are two 0s, zero 1s, two 2s, three 3s, zero 4s, one 5.

(b) After the prefix-sum loop (step 8), \(C[0..5] = [2, 2, 4, 7, 7, 8]\) — counts of elements \(\le i\).

(c)–(f) Placing elements from the back of \(A\) into \(B\) and decrementing the relevant counter each time:
- (c) Place \(A[8]=3\): \(C[3]=7\), so \(B[7]=3\), then \(C[3]\to 6\). \(C = [2,2,4,6,7,8]\).
- (d) Place \(A[7]=0\): \(C[0]=2\), so \(B[2]=0\), then \(C[0]\to 1\). \(C = [1,2,4,6,7,8]\).
- (e) Place \(A[6]=3\): \(C[3]=6\), so \(B[6]=3\), then \(C[3]\to 5\). \(C = [1,2,4,5,7,8]\).
- (f) Final result \(B = [0, 0, 2, 2, 3, 3, 3, 5]\).

### Complexity and stability

- **Time:** \(O(n + k)\). The two count loops are \(O(k)\) and \(O(n)\); the placement loop is \(O(n)\).
- **Space:** \(O(n + k)\) for \(B\) and \(C\).
- **Stable:** elements with equal values keep their relative order. This is because the final loop runs *backwards* through \(A\), and the decrement of \(C\) places later-occurring equal elements at later positions in \(B\).

Stability is what makes counting sort usable as the inner sort of radix sort.

## Radix sort

**Problem:** sort \(n\) integers, all with \(d\) digits in base (radix) \(k\). The digits are integers in \(\{0, 1, 2, \dots, k-1\}\).

### Idea

Sort one digit at a time, starting from the least significant (rightmost) digit, using a stable sort for each pass.

### Pseudocode

```
RADIX-SORT(A, d)
    for i = 1 to d
        use a stable sort to sort A on digit i from the right
```

### Worked example (from the slide)

7 integers with 3 digits in base 10. Each column is the array state; the shaded digit is the one being sorted in that pass. Sorting proceeds right digit → middle digit → left digit:

```
start    by 1s    by 10s   by 100s
329      720      720      329
457      355      329      355
657      436      436      436
839      457      839      457
436      657      355      657
720      329      457      720
355      839      657      839
```

After the third pass the array is fully sorted.

### Complexity

- **Time:** \(O(d(n + k))\) if counting sort is used inside the loop (each of the \(d\) passes is a counting sort on \(n\) elements with \(k\) possible digit values).

### Correctness

Loop invariant: after the \(i\)-th iteration of the for-loop, \(A\) is sorted if you only look at the \(i\) rightmost digits.

Because each pass uses a *stable* sort, sorting on a higher digit preserves the order already established by the lower digits when the higher digits tie. So once all \(d\) digits are processed the whole array is sorted.

## Choosing the base: radix sort vs counting sort

The same fixed-width integers can be split into digits in different bases. The sorted order is the same regardless of how you group the bits/digits, but the running time changes. The deck gives two parallel examples.

### Example: base-10 integers of width 12

Values like `486 239 123 989` (12 decimal digits).

- **As one 12-digit number, counting sort:** time \(O(n + 10^{12})\). This is \(O(n)\) only if \(n \ge 10^{12} = 1{,}000{,}000{,}000{,}000\).
- **As 2 digits in base \(10^6\), radix sort:** time \(O(2(n + 10^6))\). This is \(O(n)\) if \(n \ge 10^6 = 1{,}000{,}000\).
- **As 4 digits in base \(10^3\), radix sort:** time \(O(4(n + 10^3))\). This is \(O(n)\) if \(n \ge 10^3 = 1{,}000\).

### Example: base-2 integers of width 32

Values like `11011001 10011000 01101000 10110101` (32 bits).

- **As one 32-bit number, counting sort:** time \(O(n + 2^{32})\). \(O(n)\) only if \(n \ge 2^{32} = 4{,}294{,}967{,}296\).
- **As 2 digits in base \(2^{16}\), radix sort:** time \(O(2(n + 2^{16}))\). \(O(n)\) if \(n \ge 2^{16} = 65{,}536\).
- **As 4 digits in base \(2^8\), radix sort:** time \(O(4(n + 2^8))\). \(O(n)\) if \(n \ge 2^8 = 256\).

**Takeaway:** breaking a wide integer into more, smaller digits lowers the \(k\) term (the count-array size) at the cost of more passes \(d\). Choosing more digits makes the algorithm hit linear time \(O(n)\) for far smaller \(n\). Counting sort is the \(d=1\) special case of this family.
