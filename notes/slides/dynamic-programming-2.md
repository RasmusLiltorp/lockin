# Dynamic Programming — More Examples

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/dynamicProgrammingSlides2.pdf`

This deck works through two classic dynamic programming problems: Longest Common Subsequence (LCS) and Matrix-Chain Multiplication (here called Multi-Matrix-multiplication). For each it shows how to build the recursive formula from an optimal-substructure argument, why plain recursion is too slow, how to fill a table bottom-up, the running time and space, and how to reconstruct an actual optimal solution by following stored choices backward.

---

## 1. Longest Common Subsequence (LCS)

### Vocabulary (slide 2)

- **Alphabet**: a set of characters, e.g. `{a,b,c,...,z}`, `{A,C,G,T}` (DNA), `{0,1}`.
- **String**: a sequence \(x_1 x_2 x_3 \ldots x_n\) of characters from an alphabet. Examples: `helloworld`, `GATAAATCTGGTCTTATTTCC`, `00101100101010001111`.
- **Subsequence**: a subset of the characters of a string, kept in the same order (not required to be contiguous). Example: `GATC` is a subsequence of `GATAAATCTC`.

### Problem (slide 3)

A **common subsequence** of two strings is a string that is a subsequence of both. Example: `GATC` (or `AGTTATTC` from another pairing) is common to `GATAAATCTC` and `AGTTATTC`.

**Longest Common Subsequence (LCS):** given two strings
- \(X = x_1 x_2 x_3 \ldots x_m\)
- \(Y = y_1 y_2 y_3 \ldots y_n\)

of lengths \(m\) and \(n\), find a longest common subsequence of them.

The length of the LCS measures similarity between strings (e.g. DNA strings). Also used in file-comparison tools (diff).

### Setting up the recursion (slide 4)

Define subproblems on prefixes:
- \(X_i = x_1 x_2 \ldots x_i\) for \(1 \le i \le m\).
- \(Y_j = y_1 y_2 \ldots y_j\) for \(1 \le j \le n\).
- \(X_0\) and \(Y_0\) are the empty string.
- \(\text{lcs}(i,j)\) = length of the LCS of \(X_i\) and \(Y_j\).

Goal: compute \(\text{lcs}(m,n)\). Need a recursive formula for \(\text{lcs}(i,j)\).

**Base case:** \(\text{lcs}(0,j) = \text{lcs}(i,0) = 0\) (one of the strings is empty).

### Optimal substructure — Case I: \(x_i = y_j\) (slides 5–6)

Look at a common subsequence \(Z = z_1 \ldots z_k\) of \(X_i\) and \(Y_j\). It splits into a last character \(z_k\) and a prefix \(Z' = z_1 \ldots z_{k-1}\). Because characters in \(Z\) must appear in the same order as in \(X\) and \(Y\), only the last character of \(Z\) can be matched to \(x_i\) and \(y_j\). So \(Z'\) is a common subsequence of \(X_{i-1}\) and \(Y_{j-1}\).

**Optimal-substructure claim (Case I):** if \(Z\) is an LCS of \(X_i\) and \(Y_j\), then \(Z'\) is an LCS of \(X_{i-1}\) and \(Y_{j-1}\).

*Proof idea:* if there were a longer common subsequence of \(X_{i-1}\) and \(Y_{j-1}\), append \(x_i (= y_j)\) to it to get a longer common subsequence of \(X_i\) and \(Y_j\) — contradiction.

Result for Case I:
- \(\text{lcs}(i,j) = \text{lcs}(i-1, j-1) + 1\).
- An LCS for \(X_{i-1}, Y_{j-1}\) with the character \(x_i (= y_j)\) appended is an LCS for \(X_i, Y_j\).

### Optimal substructure — Case II: \(x_i \neq y_j\) (slides 7–8)

A common subsequence \(Z = z_1 \ldots z_k\) of \(X_i, Y_j\) cannot have \(z_k\) matching both \(x_i\) and \(y_j\) (they differ). So \(Z\) must be a common subsequence of either \(X_{i-1}\) and \(Y_j\), or of \(X_i\) and \(Y_{j-1}\) (possibly both).

**Optimal-substructure claim (Case II):** if \(Z\) is an LCS of \(X_i, Y_j\), it is an LCS of either \(X_{i-1}, Y_j\) or \(X_i, Y_{j-1}\).

*Argument:* Let \(T_1\) be an LCS of \(X_{i-1}, Y_j\) and \(T_2\) an LCS of \(X_i, Y_{j-1}\). At least one of \(T_1, T_2\) is an LCS of \(X_i, Y_j\). Neither can be longer than the LCS of \(X_i, Y_j\) (both are subsequences of \(X_i\) and \(Y_j\)). If there were a longer common subsequence of \(X_{i-1}, Y_j\) or \(X_i, Y_{j-1}\), it would also be a longer common subsequence of \(X_i, Y_j\).

Result for Case II:
- \(\text{lcs}(i,j) = \max(\text{lcs}(i-1, j), \text{lcs}(i, j-1))\).
- If \(\text{lcs}(i-1,j) \ge \text{lcs}(i,j-1)\), an LCS of \(X_{i-1}, Y_j\) is also an LCS of \(X_i, Y_j\); symmetric for \(\le\) with \(X_i, Y_{j-1}\).

### The recursive formula (slide 9)

$$
\text{lcs}(i,j) =
\begin{cases}
0 & \text{if } i=0 \text{ or } j=0 \\
\text{lcs}(i-1,j-1) + 1 & \text{if } i,j > 0 \text{ and } x_i = y_j \\
\max(\text{lcs}(i-1,j),\ \text{lcs}(i,j-1)) & \text{if } i,j > 0 \text{ and } x_i \neq y_j
\end{cases}
$$

This gives a natural recursive algorithm, but subproblems' subproblems repeat: the same \(\text{lcs}(i,j)\) gets recomputed many times in the recursion tree, so plain recursion is very slow.

Two fixes:
- **Memoization:** keep a table with room for every possible \(\text{lcs}(i,j)\); store an answer the first time it is computed, then just look it up.
- **Dynamic programming:** fill that same table directly, bottom-up, in a structured order.

### Bottom-up table (slide 10)

Table is indexed by \(i = 0 \ldots m\) (rows) and \(j = 0 \ldots n\) (columns). Initialize row 0 and column 0 to all zeros (base case). Then fill the rest. Each cell \((i,j)\) depends on its three red neighbors: the diagonal \((i-1,j-1)\), the cell above \((i-1,j)\), and the cell to the left \((i,j-1)\). The order of filling (e.g. row by row) guarantees those three are already computed.

### Running time (slide 11)

- Table size: \(mn\).
- Cost to fill one cell: \(O(\text{max size of the red dependency graph}) = O(1)\) (a constant number of neighbors, one comparison/max).
- Total: \(O(mn)\).

### Reconstructing an actual LCS (slide 12)

\(\text{lcs}(m,n)\) is only the *length*. To recover an actual subsequence: for each cell store which of the three red arrows produced its value.

Follow the stored arrows backward from \(\text{lcs}(m,n)\):
- A **diagonal** arrow is a Case I step — print \(x_i (= y_j)\).
- Otherwise it is a Case II step (up or left) — print nothing.

This outputs an LCS of \(X\) and \(Y\) in reverse order in time \(O(m+n)\) (each step moves at least one index toward 0).

**Worked example (slide 12 table).** Strings down the rows (\(X\)) and across the columns (\(Y\)) are drawn from `{A,B,C,D}`. The filled table has rows \(i = 0..7\), columns \(j = 0..6\). Reading the final cell gives \(\text{lcs}(m,n) = 4\); following the diagonal arrows back spells out a length-4 common subsequence. (The slide shows the grid of 0/1/2/3/4 values with shaded cells marking the back-pointer path that reconstructs the LCS.)

### Space (slide 13)

- If you only need the **length** of the LCS: you only ever look one row back, so you can get by with \(\min\{m,n\}\) space (keep one row/column at a time).
- If you need an **actual LCS**: you must store the whole table to follow the path back, i.e. \(\Theta(mn)\) space.
- Note: Hirschberg (1975) gave a method that recovers an actual LCS in \(\min\{m,n\}\) space, but it is not part of the DM507 syllabus.

---

## 2. Matrix-Chain Multiplication (Multi-Matrix-multiplication)

### Cost of one matrix product (slide 14)

A \(p \times q\) matrix \(A_1\) times a \(q \times r\) matrix \(A_2\) can be multiplied in time \(O(pqr)\); the result is a \(p \times r\) matrix. (Each of the \(p \times r\) output entries is a dot product of length \(q\).)

Matrix multiplication is **associative**:
$$A_1 \cdot (A_2 \cdot A_3) = (A_1 \cdot A_2) \cdot A_3.$$

### Order matters for cost (slide 15)

Associativity means the result is the same, but the running time is **not**. Example:

| | \(A_1\) | \(A_2\) | \(A_3\) |
|---|---|---|---|
| dims | \(10 \times 100\) | \(100 \times 5\) | \(5 \times 50\) |

- \((A_2 \cdot A_3)\) produces a \(100 \times 50\) matrix; \((A_1 \cdot A_2)\) produces a \(10 \times 5\) matrix.
- Cost of \(A_1 \cdot (A_2 \cdot A_3)\): \(100\cdot5\cdot50 + 10\cdot100\cdot50 = 25{,}000 + 50{,}000 = 75{,}000\).
- Cost of \((A_1 \cdot A_2) \cdot A_3\): \(10\cdot100\cdot5 + 10\cdot5\cdot50 = 5{,}000 + 2{,}500 = 7{,}500\).

Same answer, 10x difference in work.

### The problem (slide 16)

For a product of \(n\) matrices
$$A_1 \cdot A_2 \cdot A_3 \cdots A_{n-1} \cdot A_n$$
with compatible dimensions

| \(A_1\) | \(A_2\) | \(A_3\) | ... | \(A_{n-1}\) | \(A_n\) |
|---|---|---|---|---|---|
| \(p_0 \times p_1\) | \(p_1 \times p_2\) | \(p_2 \times p_3\) | ... | \(p_{n-2} \times p_{n-1}\) | \(p_{n-1} \times p_n\) |

what is the cheapest order to multiply them in? (Note dimensions share the \(p_i\): the columns of \(A_i\) equal the rows of \(A_{i+1}\).)

### Computation trees (slide 17)

An order = a parenthesization = a binary computation tree. Leaves are the matrices in left-to-right order; each internal node is one multiplication of the product of its left subtree by the product of its right subtree. Examples:
- `A1(A2 A3)`
- `(A1 A2)A3`
- `A1((A2 A3)A4)`

### Optimal substructure and recurrence (slide 18)

Let \(m(i,j)\) = cost of the best way to multiply \(A_i, \ldots, A_j\).

**Optimal-substructure observation:** the subtrees under the root of an optimal tree must themselves be optimal computation trees.

Picture the root split at position \(k\): the left subtree multiplies \(A_i \ldots A_k\) and the right subtree multiplies \(A_{k+1} \ldots A_j\).
- Left subtree output dimension: \(p_{i-1} \times p_k\), cost \(m(i,k)\).
- Right subtree output dimension: \(p_k \times p_j\), cost \(m(k+1,j)\).
- Cost at the root (multiplying those two results): \(p_{i-1}\, p_k\, p_j\).

Try every split point \(k\), i.e. every way to break into \(A_i \ldots A_k\) and \(A_{k+1} \ldots A_j\):

$$
m(i,j) =
\begin{cases}
0 & \text{if } i = j \\
\displaystyle \min_{i \le k < j} \big\{\, m(i,k) + m(k+1,j) + p_{i-1}\, p_k\, p_j \,\big\} & \text{if } i < j
\end{cases}
$$

A single matrix (\(i=j\)) costs 0 to "multiply."

### Table and running time (slide 19)

Subproblems repeat, so build a table and fill it systematically. Goal: \(m(1,n)\).

- Table indexed by \(i, j\) with \(1 \le i \le j \le n\) (upper triangle); diagonal \(m(i,i) = 0\). Fill by increasing chain length so that for each cell, all \(m(i,k)\) and \(m(k+1,j)\) it needs are already known.
- Table size: \(O(n^2)\).
- Cost to fill one cell: \(O(\text{max size of red dependency graph}) = O(n)\) (each cell minimizes over up to \(n\) split points \(k\)).
- Total: \(O(n^2) \cdot O(n) = O(n^3)\).
- **Reconstruct an actual solution:** follow the optimal choices (the best split \(k\) stored at each cell) backward.

---

## Pattern shared by both examples

1. Define subproblems and a quantity to optimize (\(\text{lcs}(i,j)\), \(m(i,j)\)).
2. Prove optimal substructure: an optimal solution is built from optimal solutions of smaller subproblems.
3. Write a recurrence; observe overlapping subproblems make naive recursion blow up.
4. Fill a table bottom-up. Running time = (table size) × (cost per cell): LCS \(O(mn)\), matrix chain \(O(n^3)\).
5. To recover an actual solution, store the choice made at each cell and trace it backward.
