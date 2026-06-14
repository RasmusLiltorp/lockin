# Strassen's Algorithm

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/strassenSlides.pdf`

The deck builds up to Strassen's matrix multiplication. It reviews matrix addition and the naive multiplication algorithm, derives a straightforward recursive divide-and-conquer multiplication and shows it gives no speedup (\(\Theta(n^3)\)), then presents Strassen's 1969 trick that does \(2 \times 2\) block multiplication with only 7 recursive multiplications instead of 8, dropping the running time to \(O(n^{2.81})\).

All matrices in the deck are \(n \times n\) square matrices, where \(n\) is the side length.

## Matrix basics (review)

A matrix is a square block of numbers. Example given:

```
[1 6 4]
[2 5 7]
[9 1 1]
```

This is a \(3 \times 3\) matrix.

## Matrix addition

Add entrywise. Worked example from the slide:

```
[1 6 4]   [3 2 1]   [1+3 6+2 4+1]   [ 4 8 5]
[2 5 7] + [4 3 2] = [2+4 5+3 7+2] = [ 6 8 9]
[9 1 1]   [5 4 3]   [9+5 1+4 1+3]   [14 5 4]
```

Time: \(\Theta(n^2)\). This is optimal because the output itself has size \(n^2\) — you can't beat the cost of just writing the answer.

## Naive matrix multiplication

Standard row-times-column product. Entry \(C[i][j]\) is the dot product of row \(i\) of \(A\) with column \(j\) of \(B\).

Worked entries from the slide (using the two matrices above):
- Entry at row 2, column 3: \(33 = 2 \cdot 1 + 5 \cdot 2 + 7 \cdot 3\).
- Entry at row 3, column 2: \(25 = 9 \cdot 2 + 1 \cdot 3 + 1 \cdot 4\).

Time: \(\Theta(n^3)\) — there are \(n^2\) output entries and each costs \(n\) multiply-adds.

The slide poses the open questions: is \(\Theta(n^3)\) optimal? Are there other algorithms? Unlike addition, the lower bound is not obviously \(n^2\), so there is room to ask.

## Recursive (divide-and-conquer) multiplication

Split each \(n \times n\) matrix into four \(n/2 \times n/2\) blocks:

```
A = [A11 A12]    B = [B11 B12]    C = [C11 C12]
    [A21 A22]        [B21 B22]        [C21 C22]
```

The product blocks follow the same rule as scalar \(2 \times 2\) multiplication, but with matrix products and matrix sums:

```
A11·B11 + A12·B21 = C11
A11·B12 + A12·B22 = C12
A21·B11 + A22·B21 = C21
A21·B12 + A22·B22 = C22
```

The slide highlights one of these (\(A_{11} \cdot B_{12} + A_{12} \cdot B_{22} = C_{12}\)) to show why: row band \(i\) of \(A\) times column band \(j\) of \(B\) lands in block position \((i,j)\) of \(C\), exactly mirroring the scalar formula.

### Cost breakdown

- Additions: each is local work on \(n/2 \times n/2\) matrices, costing \(\Theta((n/2)^2) = \Theta(n^2)\).
- Multiplications: 8 recursive calls to matrix multiplication on \(n/2 \times n/2\) matrices. Base case is \(n = 1\), which is just multiplication of two numbers.

Recurrence:

```
T(n) = 8·T(n/2) + n^2
```

### Solving with the Master theorem

- \(a = 8\), \(b = 2\), so \(\alpha = \log_b(a) = \log_2(8) = 3\).
- \(f(n) = n^2\).

Since \(n^2 = O(n^{\alpha - 0.1})\), we are in Case 1, so

```
T(n) = Θ(n^α) = Θ(n^3)
```

Same as the naive algorithm — no improvement. The slide literally comments "Øv." (Danish for "darn"). The point: the obvious recursion buys nothing because 8 sub-multiplications is exactly the work the cubic method already does.

## Strassen [1969]

The fix is to compute the four \(C\) blocks using only **7** sub-multiplications instead of 8. The trade is more additions/subtractions, but those are cheap (\(\Theta(n^2)\)), and cutting recursive calls from 8 to 7 is what moves the exponent.

### Step 1: the 10 sums (the \(S_i\))

Each \(S_i\) is an addition or subtraction of two blocks:

```
S1 = B12 − B22      S6  = B11 + B22
S2 = A11 + A12      S7  = A12 − A22
S3 = A21 + A22      S8  = B21 + B22
S4 = B21 − B11      S9  = A11 − A21
S5 = A11 + A22      S10 = B11 + B12
```

Time to compute all of them: \(\Theta((n/2)^2) = \Theta(n^2)\), since both addition and subtraction cost this.

### Step 2: the 7 products (the \(P_i\))

```
P1 = A11 · S1
P2 = S2  · B22
P3 = S3  · B11
P4 = A22 · S4
P5 = S5  · S6
P6 = S7  · S8
P7 = S9  · S10
```

These are the 7 recursive calls to matrix multiplication on \(n/2 \times n/2\) matrices.

### Step 3: recombine into the four output blocks

```
P5 + P4 − P2 + P6 = A11·B11 + A12·B21   (= C11)
        P1 + P2   = A11·B12 + A12·B22   (= C12)
        P3 + P4   = A21·B11 + A22·B21   (= C21)
P5 + P1 − P3 − P7 = A21·B12 + A22·B22   (= C22)
```

These right-hand sides are exactly the four block formulas from the naive recursion, so the \(P_i\) really do produce \(C\).

### Verification example (from the slide)

Check the \(C_{12}\) formula by expanding:

\(P_1 + P_2 = A_{11} \cdot S_1 + S_2 \cdot B_{22} = A_{11} \cdot (B_{12} - B_{22}) + (A_{11} + A_{12}) \cdot B_{22}\)

Expand: \(A_{11}B_{12} - A_{11}B_{22} + A_{11}B_{22} + A_{12}B_{22} = A_{11} \cdot B_{12} + A_{12} \cdot B_{22}\).

That matches \(C_{12}\). The same kind of cancellation verifies the other three. (Note: the matrix products here are not commutative, so the order of factors in each \(P_i\) matters — the expansion above respects it.)

So once \(P_1, \dots, P_7\) are known, the output can be assembled in \(O(n^2)\) time (just block additions and subtractions).

### Running time

Recurrence:

```
T(n) = 7·T(n/2) + n^2
```

Master theorem:
- \(a = 7\), \(b = 2\), so \(\alpha = \log_b(a) = \log_2(7) = 2.80735\ldots\)
- \(f(n) = n^2\).

Since \(n^2 = O(n^{\alpha - 0.1})\), Case 1 again, giving

```
T(n) = Θ(n^α) = O(n^2.81)
```

Better than the naive \(\Theta(n^3)\) algorithm. The whole gain comes from 7 vs 8 recursive multiplications, since \(\log_2 7 < \log_2 8 = 3\).
