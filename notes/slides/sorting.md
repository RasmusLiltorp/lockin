# Sorting (Sortering)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/sortingSlides.pdf` (38 slides, Danish).

This deck covers comparison-based sorting. It introduces the sorting problem, then walks through Insertion sort, Selection sort, Merge / Mergesort, Quicksort, and Heapsort with pseudocode, worked examples, and running-time analysis. It ends by comparing the three \(O(n \log n)\) algorithms (Quicksort, Mergesort, Heapsort) on worst-case guarantees and in-place behaviour, and mentions Introsort.

## The sorting problem

- Input: \(n\) numbers.
- Output: the same \(n\) numbers in sorted order.
- Example: `6, 2, 9, 4, 5, 1, 4, 3 → 1, 2, 3, 4, 4, 5, 6, 9`.

Why it matters: many tasks are faster on sorted data (dictionaries, phone address lists). Sorting is often a building block inside algorithms for other problems. Called "a fundamental and central task."

Algorithms named in the course: Insertion sort, Selection sort, Bubble sort, Mergesort, Quicksort, Heapsort, Radix sort, Counting sort. All of these appear somewhere in the course.

### Conventions used in the course
- Sorted order can be ascending or descending. This course always uses ascending (precisely: non-decreasing). To sort descending, flip every comparison.
- Input lives in a Python list or a C#/Java array.
- Real elements have a sort key plus extra payload. The key can be an integer, a float, or anything comparable (e.g. strings). The slides show elements only as integers.

## Insertion sort

Problem: sort an array. Idea matches sorting a hand of cards: keep a sorted prefix and insert each next element into its correct place within it.

Correctness argument (loop invariant): the "yellow" part of the array is always sorted. That part grows by one each iteration, so the algorithm terminates, and when it stops every element is sorted.

Pseudocode:

```
INSERTION-SORT(A, n)
1  for i = 2 to n
2      key = A[i]
3      // Insert A[i] into the sorted subarray A[1 .. i-1].
4      j = i - 1
5      while j > 0 and A[j] > key
6          A[j + 1] = A[j]
7          j = j - 1
8      A[j + 1] = key
```

Worked example (slides), array `[5, 2, 4, 6, 1, 3]`:
- (a) start `5 2 4 6 1 3`
- (b) insert 2: `2 5 4 6 1 3`
- (c) insert 4: `2 4 5 6 1 3`
- (d) insert 6 (already in place): `2 4 5 6 1 3`
- (e) insert 1: `1 2 4 5 6 3`
- (f) insert 3: `1 2 3 4 5 6`

### Running time

The slide annotates each line with a cost \(c_1 \dots c_8\) and a number of executions. Let \(t_i\) = how many times the inner while-loop test runs at step \(i\). Then \(t_i - 1\) is how many times the loop body runs (= how many elements the \(i\)-th element must pass during insertion). Note \(1 \le t_i \le i\). Set \(c = c_1 + c_2 + \dots + c_8\).

- Best case: \(t_i = 1\) for all \(i\) (input already sorted). Total time \(\le c \cdot n\), i.e. \(O(n)\).
- Worst case: \(t_i = i\) for all \(i\) (input reverse sorted). Total time \(\le c \cdot n^2\), because

\[
\sum_{i=2}^{n} i \le 1 + 2 + 3 + \dots + n = \frac{(n+1)n}{2} = \frac{n^2 + n}{2} \le \frac{2n^2}{2} = n^2.
\]

So worst case is \(O(n^2)\).

## Selection sort

Another simple, natural sorting algorithm.

Pseudocode (as given):

```
indListe = input
udListe = empty list
while indListe not empty:
    find smallest element x in indListe
    move x from indListe to the end of udListe
```

Correctness: clearly produces sorted output. Each element taken out is \(\le\) all elements taken out after it.

Running time: the smallest element is found \(n\) times in total. A simple way to find the smallest is linear search, looking once at each remaining element. So time is
\[
\le c \cdot (n + (n-1) + (n-2) + \dots + 1) \le c \cdot n^2,
\]
i.e. \(O(n^2)\).

## Merge

Problem:
- Input: two sorted sequences \(A\) and \(B\).
- Output: the same elements in one sorted sequence \(C\).
- Example: \(A = 2,4,5,7,8\) and \(B = 1,2,3,6\) \(\Rightarrow\) \(C = 1,2,2,3,4,5,6,7,8\).

You could sort \(A \cup B\) from scratch, but merging is faster:

```
Repeat:
    move the smaller of the two front elements of A and B to the end of C
```

Running time: \(\le c \cdot n\), i.e. \(O(n)\), where \(n\) = total number of elements in \(A\) and \(B\).

Correctness: Merge is a version of Selection sort that exploits the fact that \(A\) and \(B\) are sorted. The smallest element of the rest of \(A \cup B\) is always one of the two front elements, so it is found in constant time.

### Merge as part of an array

The two input lists are assumed to be neighbouring parts of the same array \(A\): namely \(A[p \dots q]\) and \(A[q+1 \dots r]\). They are first copied into temporary arrays \(L\) and \(R\). (Note: in the textbook \(A[p \dots q]\) means \(A[p], A[p+1], \dots, A[q]\), one element more than the nearly identical Python slice notation.)

Pseudocode:

```
MERGE(A, p, q, r)
1   n_L = q - p + 1                  // length of A[p .. q]
2   n_R = r - q                      // length of A[q+1 .. r]
3   let L[0 .. n_L - 1] and R[0 .. n_R - 1] be new arrays
4   for i = 0 to n_L - 1             // copy A[p .. q] into L[0 .. n_L - 1]
5       L[i] = A[p + i]
6   for j = 0 to n_R - 1             // copy A[q+1 .. r] into R[0 .. n_R - 1]
7       R[j] = A[q + 1 + j]
8   i = 0                            // i indexes smallest remaining element in L
9   j = 0                            // j indexes smallest remaining element in R
10  k = p                            // k indexes the location in A to fill
    // As long as each of L and R contains an unmerged element,
    // copy the smallest unmerged element back into A[p .. r].
11  while i < n_L and j < n_R
12      if L[i] <= R[j]
13          A[k] = L[i]
14          i = i + 1
15      else A[k] = R[j]
16          j = j + 1
17      k = k + 1
    // Having gone through one of L and R entirely,
    // copy the remainder of the other to the end of A[p .. r].
18  while i < n_L
19      A[k] = L[i]
20      i = i + 1
21      k = k + 1
22  while j < n_R
23      A[k] = R[j]
24      j = j + 1
25      k = k + 1
```

## Mergesort

Idea: build longer and longer sorted parts of the input by repeated merging.

Worked example (bottom-up merge tree), initial sequence `5 2 4 7 1 3 2 6`:
- pairs merged: `[2 5] [4 7] [1 3] [2 6]`
- next layer: `[2 4 5 7] [1 2 3 6]`
- final merge: `1 2 2 3 4 5 6 7`

### Why \(O(n \log n)\)

Each merge uses at most \(c \cdot n_1\) time, where \(n_1\) is the number of elements merged. All merges in one layer together use at most \(c \cdot (n_1 + n_2 + \dots) = c \cdot n\). This holds for every layer. There are \(\log_2 n\) layers in total, so total time is at most \(c \cdot n \cdot \log_2 n\).

### Why there are \(\log_2 n\) merge layers

Assume \(n\) is a power of 2. Count sorted lists after \(k\) merge layers:

| layer \(k\) | number of lists |
|---|---|
| 0 | \(n\) |
| 1 | \(n/2\) |
| 2 | \(n/2^2\) |
| 3 | \(n/2^3\) |
| \(k\) | \(n/2^k\) |

The algorithm stops when there is one sorted list:
\[
n/2^k = 1 \iff n = 2^k \iff \log_2 n = k.
\]

### Mergesort when \(n\) is not a power of 2

Each layer merges as many pairs as it can; there may be one leftover list that is not merged (it carries forward to the next layer). E.g. 12 lists become \(12/2 = 6\) lists, while 13 (= 12 + 1) lists become \(12/2 + 1 = 6 + 1 = 7\) lists.

General rule: if there are \(x\) lists before a merge layer, there are \(\lceil x/2 \rceil\) after.

Argument for the number of layers: take two input sizes \(n \le n'\). Since \(\lceil x/2 \rceil\) is an increasing function of \(x\), the number of lists in each layer for \(n'\) is never smaller than for \(n\). So the number of layers (until one list remains) for \(n'\) is never smaller than for \(n\). Set \(n'\) to the smallest power of 2 \(\ge n\). There are exactly \(\log_2 n'\) layers for \(n'\), hence at most that many for \(n\). Conversely, for \(n = 2^k + 1\) there are \(k + 1 = \lceil \log_2 n \rceil\) layers. So in general there are \(\lceil \log_2 n \rceil\) layers.

Table from the slide:

| \(n\) | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 | 16 | 17 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| \(\log_2 n\) | 2.807 | 3 | 3.169 | 3.321 | 3.459 | 3.584 | 3.700 | 3.807 | 3.906 | 4 | 4.087 |
| layers | 3 | 3 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 4 | 5 |

### Recursive pseudocode

```
MERGE-SORT(A, p, r)
1   if p >= r                    // zero or one element?
2       return
3   q = floor((p + r) / 2)       // midpoint of A[p .. r]
4   MERGE-SORT(A, p, q)          // recursively sort A[p .. q]
5   MERGE-SORT(A, q + 1, r)      // recursively sort A[q+1 .. r]
    // Merge A[p .. q] and A[q+1 .. r] into A[p .. r].
6   MERGE(A, p, q, r)
```

- `MERGE-SORT(A, p, r)` puts \(A[p \dots r]\) in sorted order.
- First call is `MERGE-SORT(A, 1, n)`, which sorts all of \(A\).
- `MERGE(A, p, q, r)` merges the two sorted subarrays \(A[p \dots q]\) and \(A[q+1 \dots r]\) into \(A[p \dots r]\).

Worked run example, input `[12, 3, 7, 9, 14, 6, 11, 2]`:
- divide into `[12 3 7 9]` and `[14 6 11 2]`
- keep dividing down to single elements
- merge back up to `[3 12] [7 9] [6 14] [2 11]`, then `[3 7 9 12] [2 6 11 14]`
- final merge: `[2 3 6 7 9 11 12 14]`

## Quicksort

[Hoare, 1960]

Contrast with Mergesort:

Mergesort:
- Split input into two parts \(X\) and \(Y\) (trivial).
- Sort each part separately (recursion).
- Merge the two sorted parts into one (the real work).
- Base case: \(n \le 1\) (already sorted, do nothing).

Quicksort:
- Split input into two parts \(X\) and \(Y\) so that \(X \le Y\) (the real work).
- Sort each part separately (recursion).
- Return \(X\) followed by \(Y\) (trivial).
- Base case: \(n \le 1\) (already sorted, do nothing).

Pseudocode:

```
QUICKSORT(A, p, r)
1   if p < r
        // Partition the subarray around the pivot, which ends up in A[q].
2       q = PARTITION(A, p, r)
3       QUICKSORT(A, p, q - 1)    // recursively sort the low side
4       QUICKSORT(A, q + 1, r)    // recursively sort the high side
```

- `QUICKSORT(A, p, r)` puts \(A[p \dots r]\) in sorted order.
- First call is `QUICKSORT(A, 1, n)`.
- `PARTITION(A, p, r)` picks an element \(x \in A\) and rearranges \(A[p \dots r]\) so that:
  \[
  A[q] = x, \quad A[p \dots q-1] \le x, \quad A[q+1 \dots r] > x.
  \]

### Partition

Idea: pick an element \(x\) to split on (here the last element of the array part). Build the two parts during a single pass over the array. Invariant during the scan: a prefix \(\le x\), then a part \(> x\), then unknown, with the pivot \(x\) at the far right.

Pseudocode:

```
PARTITION(A, p, r)
1   x = A[r]                       // the pivot
2   i = p - 1                      // highest index into the low side
3   for j = p to r - 1            // process each element other than the pivot
4       if A[j] <= x               // does this element belong on the low side?
5           i = i + 1              // index of a new slot in the low side
6           exchange A[i] with A[j]  // put this element there
7   exchange A[i + 1] with A[r]    // pivot goes just to the right of the low side
8   return i + 1                   // new index of the pivot
```

Time: \(O(n)\), where \(n\) is the number of elements in \(A[p \dots r]\).

Worked example, array `[2, 8, 7, 1, 3, 5, 6, 4]` with pivot \(x = 4\):
- (a) start `2 8 7 1 3 5 6 4`
- scan: 2 ≤ 4 and 1 ≤ 4 and 3 ≤ 4 go to the low side
- final swap puts pivot 4 into place
- result: `[2 1 3] 4 [7 5 6 8]`, i.e. `2 1 3 4 7 5 6 8`, pivot at index returned.

### Quicksort running time

Depends on how the partitions split the input through the recursion. Two extremes of recursive-call sizes:
- Fully unbalanced: 0 and \(n - 1\).
- Fully balanced: \(\lceil (n-1)/2 \rceil\) and \(\lfloor (n-1)/2 \rfloor\).

- If all partitions are fully balanced: \(O(n \log n)\) (roughly the same analysis as Mergesort).
- If all partitions are fully unbalanced: \(O(n + (n-1) + (n-2) + \dots + 2 + 1) = O(n^2)\).

It can be shown these are respectively the best case and worst case for Quicksort.

Practical notes:
- In practice: running time \(O(n \log n)\) for almost all input.
- But: already-sorted input gives \(\Theta(n^2)\) if the pivot \(x\) is chosen as the last element (which the textbook does). Don't use that choice in practice.
- More robust pivot choices: the middle element, the median of several elements, a random element, or the median of several randomly chosen elements.
- Quicksort is in-place: uses no more space than the input array.
- The code is very efficient in practice. A well-implemented Quicksort is often the best all-round sorting algorithm (chosen in many libraries, e.g. C#, Java, C++/STL).

## Heapsort

[Williams, 1964]

A heap is:
1. a binary tree
2. with heap order
3. and heap shape
4. laid out in an array.

(Note: "heap" is also the name of a memory region used to allocate objects during a program's execution. The two uses are unrelated.)

### 1) Binary tree

A binary tree is either the empty tree, or a node \(v\) plus two subtrees (a right and a left one).

Terminology:
- \(v\) is the root of the tree.
- If \(v\) has a non-empty subtree, the root \(u\) of that subtree is a child of \(v\), and \(v\) is \(u\)'s parent.
- If both of \(v\)'s subtrees are empty, \(v\) is a leaf.
- Edges are the lines between children and parents.
- Parent/child generalizes naturally to ancestor and descendant.

Measures:
- Depth of a node = number of edges to the root.
- Height of a node = max number of edges to a leaf.
- Height of a tree = height of its root.
- Full (complete) binary tree = a tree where all layers are completely filled.

A full binary tree of height \(h\) has
\[
1 + 2 + 4 + 8 + \dots + 2^h = \sum_{i=0}^{h} 2^i = 2^{h+1} - 1
\]
nodes (formula A.6 p. 1142 / A.5 p. 1147), of which \(2^h\) are leaves.

### 2) Heap order

A binary tree with values in all nodes is max-heap-ordered if, for every node \(v\) with child \(u\):
\[
\text{value in } v \ge \text{value in } u.
\]

Equivalent definition: for every node \(v\) with descendant \(u\), value in \(v \ge\) value in \(u\).

In a max-heap-ordered tree the root holds the largest value in the tree.

If this holds with \(\le\) instead of \(\ge\), the tree is min-heap-ordered.

Example max-heap (array indices 1..10): `[16, 14, 10, 8, 7, 9, 3, 2, 4, 1]`. Root 16, its children 14 and 10, etc.

### 3) Heap shape

A binary tree has heap shape if all layers are completely filled except the last layer, where all nodes are as far left as possible. (A full tree has heap shape.)

For a heap-shaped tree of height \(h\) with \(n\) nodes:
\[
n > \text{nodes in a full tree of height } h - 1 = 2^h - 1,
\]
\[
n > 2^h - 1 \iff n + 1 > 2^h \iff \log_2(n+1) > h.
\]

### 4) Heap laid out in an array

A heap-shaped binary tree maps naturally onto an array by giving array indices to nodes via a top-down, left-to-right traversal of the layers.

Navigation by simple arithmetic. The node at position \(i\) has:
- its parent at position \(\lfloor i/2 \rfloor\),
- its children at positions \(2i\) and \(2i + 1\).

(Proved easily by induction.)

### Heap operations

- Max-Heapify: given a node whose two subtrees each already satisfy heap order, make the node's whole subtree satisfy heap order.
- Build-Max-Heap: turn \(n\) unordered input elements into a heap.

(For a min-heap the same operations exist with "min-" instead of "max-".)

### Max-Heapify

Task: given a node whose two subtrees each satisfy heap order, make the node's whole tree satisfy heap order.
- Problem: the node's value is smaller than one or both children's values.
- Solution: swap with the child holding the larger value, then run Max-Heapify on that child.

Pseudocode (with a built-in check not to look "too far" in the array, i.e. past position \(n\)):

```
MAX-HEAPIFY(A, i, n)
    l = LEFT(i)
    r = RIGHT(i)
    if l <= n and A[l] > A[i]
        largest = l
    else largest = i
    if r <= n and A[r] > A[largest]
        largest = r
    if largest != i
        exchange A[i] with A[largest]
        MAX-HEAPIFY(A, largest, n)
```

Time: \(O(\text{height of node})\).

### Build-Heap

Task: turn \(n\) unordered input elements into a heap.
- Idea: arrange the elements in heap shape, then bring the tree into heap order bottom-up.
- Observation: a tree of size one always satisfies heap order.

Pseudocode:

```
BUILD-MAX-HEAP(A, n)
    for i = floor(n / 2) downto 1
        MAX-HEAPIFY(A, i, n)
```

(The loop starts at \(\lfloor n/2 \rfloor\) because nodes past that index are leaves, which already satisfy heap order.)

Worked example, input array `[4, 1, 3, 2, 16, 9, 10, 14, 8, 7]`, which Build-Max-Heap turns into a valid max-heap by calling Max-Heapify on nodes \(\lfloor 10/2 \rfloor = 5\) down to 1.

Time: clearly \(O(n/2 \cdot \text{heap height}) = O(n \log_2 n)\). A better analysis gives \(\Theta(n)\).

### Heapsort

A form of selection sort that uses a heap to repeatedly extract the largest remaining element:

```
build a heap
repeat until heap is empty:
    remove root (which is the largest element in the heap)
    move the last element up as the new root
    restore heap structure by Max-Heapify on the new root
```

Pseudocode:

```
HEAPSORT(A, n)
    BUILD-MAX-HEAP(A, n)
    for i = n downto 2
        exchange A[1] with A[i]
        MAX-HEAPIFY(A, 1, i - 1)
```

How it works: the max is at \(A[1]\); swap it to the end (\(A[i]\)), shrink the heap to size \(i-1\), and re-heapify the root. The sorted region grows from the right.

Worked example: starting from the heap with root 16, repeated extraction produces the sorted array `[1, 2, 3, 4, 7, 8, 9, 10, 14, 16]`.

Time: \(O(n) + O(n \log n) = O(n \log n)\) (build heap + \(n\) heapify calls).

## Three \(O(n \log n)\) sorting algorithms

| | Worst case \(O(n \log n)\) | In-place |
|---|---|---|
| QuickSort | | ✓ |
| MergeSort | ✓ | |
| HeapSort | ✓ | ✓ |

- QuickSort is in-place but its worst case is \(\Theta(n^2)\).
- MergeSort guarantees \(O(n \log n)\) worst case but is not in-place.
- HeapSort is both in-place and worst-case \(O(n \log n)\).

But Heapsort runs slower than Mergesort and Quicksort because of inefficient memory use (random access).

Introsort [Musser, 1997]: use Quicksort, but during the recursion switch to Heapsort if the recursion gets too deep. This gives an in-place, worst-case \(O(n \log n)\) algorithm with good practical running time. It is the sorting algorithm in C# and in the C++ standard library (STL).
