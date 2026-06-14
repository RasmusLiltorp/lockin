# Dynamic Programming (Part 1)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/dynamicProgrammingSlides.pdf` (Danish: "Dynamisk programmering")

This deck introduces dynamic programming as a method for combinatorial optimization problems. It frames DP as a special case of divide-and-conquer where subproblems shrink by only O(1) and repeat across the recursion tree, which makes naive recursion exponential. The fix is to store subproblem solutions in a table so each is solved once. The whole idea is built up through one worked example: the rod-cutting / gold-chain problem (Malte's problem), covering the recurrence, bottom-up table filling, solution reconstruction, and memoization.

## Combinatorial optimization problems

A **combinatorial structure** is a structure built from a finite number of parts. Examples:
- A route from A to B.
- Packing a truck or container ship.
- A teaching schedule.
- A production plan for y orders and x production machines.

A **combinatorial optimization problem** asks for the best such structure among many possible ones. Matching examples:
- Fastest route from A to B.
- Most profitable packing of a truck / container ship.
- Teaching schedule with the least teaching after 16:00.
- Production plan with the fewest missed delivery deadlines.

Intro example given on the first content slide: given a pile of Lego bricks, what is the tallest wall of width 10 you can build?

## What dynamic programming is

Dynamic programming [Bellman, 1950–57] is a method for developing algorithms for combinatorial optimization problems. It is a **special case of divide-and-conquer**: a recursive method that builds solutions to larger problems from solutions to smaller problems.

Observation contrasting two kinds of recursion:
- **Normal recursive methods**: subproblems are typically about half the size, and there are no repetitions of subproblems at different places in the recursion tree.
- **Some recursive methods**: subproblems are reduced in size by only **one** (O(1)). This often causes the same subproblem to recur at different places in the recursion tree, which often makes the running time exponential.

### The core idea

Make a **table of solutions to subproblems**, so each subproblem is solved only once. This normally changes the running time from exponential to polynomial.

More generally, "dynamic programming" means: developing recursive solutions for optimization problems where some subproblems shrink by only O(1), then using the table idea above to implement the recursion efficiently.

The creative part is finding the recursive description of the solution. Using the table idea afterward is roughly the same from problem to problem.

### How to find the recursion (attack plan)

1. Find a good description of the **size** of a problem, expressed by one, two, or more integer indices. This gives a table with one, two, or more dimensions.
2. Analyze how an optimal solution for a given problem size must consist of a **"last part"** and **"the rest"**, where you can argue that "the rest" must itself be an optimal solution for a smaller problem of the same type. This yields a recursive description of solutions.

The last property is called having **optimal subproblems** (optimal substructure).

## Worked example: Malte's problem (rod cutting)

You have a gold chain with n links. It can be split into smaller lengths (totaling n links, so no link is lost). A goldsmith buys gold chains of different lengths at different prices.

Price table given in the slides:

| length i (links) | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|
| price p_i (1000 kr) | 1 | 5 | 8 | 9 | 10 | 17 | 17 | 20 | 24 | 26 |

(The price for length 10, p_10 = 26, appears on the later example/solution slides.)

Goal: how should you split your long chain to maximize the total sale price?

Worked enumeration shown for a chain of length n = 4. All 2^(4-1) = 8 splittings and their summed prices:
- `4` (no cut) → p_4 = 9
- `1 + 3` → 1 + 8 = 9
- `2 + 2` → 5 + 5 = 10
- `3 + 1` → 8 + 1 = 9
- `1 + 1 + 2` → 1 + 1 + 5 = 7
- `1 + 2 + 1` → 1 + 5 + 1 = 7
- `2 + 1 + 1` → 5 + 1 + 1 = 7
- `1 + 1 + 1 + 1` → 1 + 1 + 1 + 1 = 4

Best here is 2 + 2 = 10. Note the slide treats ordered arrangements as distinct (e.g. 1+3, 3+1, and the three 1+1+2 orderings are listed separately), which is where the 2^(n-1) count comes from.

The slide's main numeric point: there are **2^(n-1)** different splittings of a chain of length n, so trying them all is not an efficient algorithm.

### Optimal subproblems

Any splitting of a chain of length n must consist of:
- A **last piece** of length k ≤ n.
- A splitting of **the rest**, i.e. a splitting of a chain of length n − k.

**Observation (optimal subproblems):** In an optimal splitting of the chain of length n, the splitting of the rest must itself be optimal for a chain of length n − k. Proof idea (exchange argument): if there were a strictly better splitting of the rest, you could substitute it and thereby improve the optimal splitting of the length-n chain — contradiction.

Let r(n) = value of an optimal splitting of a chain of length n. Clearly **r(0) = 0**. We want r(n) for n > 0.

### Deriving the recurrence

An optimal splitting T for length n consists of:
- A last piece of length k ≤ n.
- An optimal splitting of the rest (length n − k).

So the value of T is `r(n) = p_k + r(n − k)`. This smells like recursion — but we don't know k.

Fix: for each i = 1...n, let T_i be the splitting consisting of a last piece of length i plus an optimal splitting of the rest. The value of T_i is `p_i + r(n − i)`.

T_k has value p_k + r(n − k), the same as T, so T_k is optimal for length n. Therefore:
- At least one of T_1, T_2, ..., T_n is optimal for length n.
- No T_i can have value better than optimal.

This gives the recurrence:

```
r(n) = max ( p_i + r(n - i) )   for 1 <= i <= n
r(0) = 0
```

## Why naive recursion is bad

r(n) is mathematically defined recursively from smaller instances. But is recursion a good *algorithmic* solution? No.

The recursion tree (slide shows it for n = 4) has repeated subproblems all over: solving r(4) calls r(3), r(2), r(1), r(0); r(3) again calls r(2), r(1), r(0); and so on. The same subproblem appears in many places.

By induction, the number of nodes in the recursion tree is:

```
1 + (1 + 2 + 4 + ... + 2^(n-1)) = 2^n
```

So the running time is **Θ(2^n)**. The problem is repetition among the subproblems' subproblems.

## Bottom-up table filling

Instead, focus on a table of the optimal solution values. Start with r(0) = 0:

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| r(n) | 0 | | | | | | | | | | |

A cell r(n) can be filled using `r(n) = max_{1<=i<=n} (p_i + r(n - i))` once all earlier cells are filled. The slide draws this dependency as arrows from cell n (e.g. r(7)) back to all cells r(0)...r(6). Since each r(n) depends only on smaller indices, we can compute **bottom-up**, for increasing n.

### Pseudocode

```
r[0] = 0
for n = 1 to N:
    max = -infinity
    for i = 1 to n:
        x = p[i] + r[n - i]
        if x > max:
            max = x
    r[n] = max
```

Two loops: the outer loop walks the table cell by cell, the inner loop computes the max for each cell.

### Complexity

Time = O(1 + 2 + 3 + ... + N) = **Θ(N^2)**, where N is the last index. Space **Θ(N)** for the table.

### Filled example

Using the recurrence and the prices p_i, fill r(n) (computed right to left / increasing n):

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| r(n) | 0 | 1 | 5 | 8 | 10 | 13 | 17 | 18 | 22 | 25 | 27 |

(Check: r(4) = max(p_1+r(3), p_2+r(2), p_3+r(1), p_4+r(0)) = max(1+8, 5+5, 8+1, 9+0) = 10. r(10) = 27, e.g. via 6 + 2 + 2 = 17 + 5 + 5 = 27.)

## Reconstructing the actual solution

r(n) is only the *value* of the optimal solution. To get the solution itself (the individual lengths the chain is broken into), also store **s(n)** = the length of the last piece in an optimal solution for length n, i.e. the i that achieved the max in the recurrence.

Table from the slide (prices repeated for reference, p_10 = 26):

| length n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
|---|---|---|---|---|---|---|---|---|---|---|---|
| optimal value r(n) | 0 | 1 | 5 | 8 | 10 | 13 | 17 | 18 | 22 | 25 | 27 |
| last length s(n) | 0 | 1 | 2 | 3 | 2 | 2 | 6 | 1 | 2 | 3 | 2 |

### Reconstruction code

```
while n > 0:
    print s[n]
    n = n - s[n]
```

For n = 10 the solution is **6, 2, 2** (s[10]=2 → n=8; s[8]=2 → n=6; s[6]=6 → n=0).

## Memoization

Recursion alone: Θ(2^n). Structured table filling: Θ(n^2). Can the two be combined? Yes — top-down recursion that caches results in the table (memoization).

```
GuldKæde(n):
    if n = 0:
        return 0
    else if r[n] already filled in table:
        return r[n]
    else:
        x = max_{1<=i<=n} ( p_i + GuldKæde(n - i) )
        r[n] = x
        return x
```

An arrow in the dependency figure (a subproblem depending on another) becomes an edge in the recursion tree exactly once — the first time that subproblem is reached. So memoization has the **same running time Θ(n^2)** and **space Θ(n)** as bottom-up filling, just with a somewhat worse constant factor in practice.
