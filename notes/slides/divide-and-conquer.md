# Divide-and-Conquer Algorithms: Analysis

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/divideAndConquerSlides.pdf`

This deck analyzes divide-and-conquer (recursive) algorithms for correctness and especially running time. It introduces recursion trees, recurrence equations, the recursion-tree method for solving recurrences, and the Master Theorem with its three cases. It works five recurrences by hand, shows when the Master Theorem does not apply, and proves that floors and ceilings in a recurrence do not change the asymptotic running time.

## Divide-and-Conquer: the idea

Same thing as recursive algorithms. Three steps:

1. **Divide** the problem into smaller subproblems of the same type.
2. **Conquer** by recursion: call the algorithm on the smaller inputs.
3. **Combine** the subproblem solutions into a solution for the whole problem.

Base case: problems of size O(1) are solved directly, without recursion.

This is a general algorithm-design method. For each new algorithm you develop step 1 and step 3. Step 2 is always the same. The base-case solution also has to be developed but is usually trivial.

### General structure of divide-and-conquer code

```
if base case (n = O(1)):
    work
else:
    work
    recursive call
    work
    recursive call
    work
```

There need not always be two recursive calls. Some recursive algorithms make just one, some make more than two.

### Examples

**Mergesort:**
- Split input into two parts X and Y (trivial).
- Sort each part separately (recursion).
- Merge the two sorted parts into one sorted part (the real work).
- Base case: n ≤ 1 (trivial).

**Quicksort:**
- Split input into two parts X and Y so that X ≤ Y (the real work).
- Sort each part separately (recursion).
- Return X followed by Y (trivial).
- Base case: n ≤ 1 (trivial).

**Inorder traversal of a binary search tree:** two recursive calls (left and right subtree) with O(1) work between them (printing the key of the current node).

Note the contrast: in mergesort the real work is in the combine step; in quicksort the real work is in the divide step.

## What happens when a divide-and-conquer algorithm runs

**Local flow of control** (for one call):
- Base case: just do work.
- Non-base case: work, recursive call, work, recursive call, work — interleaving local work with the recursive calls.

**Global flow of control:** the calls form a branching structure. Control enters a call, dives into a child call, comes back, dives into the next child, comes back, then returns.

### Recursion trees

The flow of control can be drawn as a tree with one node per call of the code.
- Base-case calls are **leaves**.
- Non-base-case calls are **internal nodes**.
- The tree's **fanout** (number of children per node) equals the number of recursive calls in the code.

These are called recursion trees.

At any moment, execution (the "red path") has reached some node v. The call that v corresponds to is currently running. All calls on the path from v up to the root are paused. Each paused call's state (variable contents, which command it reached, etc.) is kept on a **stack** so the calls don't get mixed up. Calls for all other nodes in the tree are either fully done or not yet started.

- Calling a child in the recursion tree = **push** onto the stack.
- Finishing a node's execution = **pop** from the stack.

## Correctness of divide-and-conquer algorithms

Argue correctness **bottom-up** in the recursion tree:
- Argue that base-case calls answer correctly (usually trivial).
- For a non-base-case call, argue that *if* the recursive calls answer correctly, *then* together with the local work the current call answers correctly.

So correctness for large inputs follows from correctness for smaller inputs plus the actions that build a large-input solution out of the smaller-input solutions.

Formally this is **induction on input size**. The recursion's base case is the induction base case. The actual argument is specific to each algorithm and is usually developed together with the algorithm — in practice it is hard to find the algorithm without also seeing why it works.

## Recurrence equations

We want running times of recursive algorithms, described first by recurrence equations.

Let T(n) be the worst-case running time on input of size n. If a recursive algorithm makes **a** recursive calls, each on a subproblem of size **n/b**, and does **Θ(f(n))** local work, then:

\[
T(n) = \begin{cases} a \cdot T(n/b) + \Theta(f(n)) & \text{if } n > 1 \\ \Theta(1) & \text{if } n \le 1 \end{cases}
\]

The last line is always the same and is often omitted. It is also often left implicit that we use asymptotic notation, so we write f(n) instead of Θ(f(n)) and 1 instead of Θ(1).

**Example:** Mergesort makes two recursive calls of size n/2 and does Θ(n) local work, so its recurrence is

\[
T(n) = 2T(n/2) + n
\]

## Finding running time from a recurrence

A recurrence describes T(n) recursively (in terms of T on smaller sizes). We want a **direct expression** — a function of n — for T(n).

The total work of a recursive algorithm equals the **sum of the local work over all nodes** in its recursion tree. So we want that sum.

### The recursion-tree method

Annotate each node of the recursion tree with:
- the input size for the call at that node, and
- the resulting work done in that node.

Then sum the work over all nodes like this:
1. Find the **height** of the tree (number of layers).
2. Sum each layer of the recursion tree on its own.
3. Sum the resulting per-layer values over all layers.

## Math facts used in the examples

**Geometric sum** (for c > 1):
\[
1 + c + c^2 + \cdots + c^k = \frac{c^{k+1}-1}{c-1} = c^k \cdot \frac{c - 1/c^k}{c-1} = \Theta(c^k).
\]
Concrete case c = 2:
\[
1 + 2 + 4 + 8 + \cdots + 2^k = 2^{k+1}-1 = 2^k(2 - 1/2^k) = \Theta(2^k).
\]
Remember it as: **if the terms of a sum change exponentially, the whole sum is dominated by the largest term.** Growing exponentially → largest term is the last term. Falling exponentially → largest term is the first term.

Proof (not exam material): set S = 1 + c + ... + c^k. Then S(c−1) = S·c − S = (c + ... + c^{k+1}) − (1 + ... + c^k) = c^{k+1} − 1, so S = (c^{k+1}−1)/(c−1).

**Other facts:**
- \((a^b)^c = a^{bc} = (a^c)^b\)
- \(a^{\log_b n} = n^{\log_b a}\)
- \(\log_b a = \log_c a / \log_c b\) (e.g. \(\log_b a = \ln a / \ln b\))

The last fact lets you compute \(\log_b a\) on a calculator that only has ln. It can also be written \(\log_b x = \frac{1}{\log_c b}\cdot \log_c x\), which shows logarithms with different bases differ only by a constant factor: \(\log_b x = \Theta(\log_c x)\).

Proof of middle fact (not exam): \(a^{\log_b n} = (b^{\log_b a})^{\log_b n} = (b^{\log_b n})^{\log_b a} = n^{\log_b a}\).

## Worked example 1: T(n) = 2T(n/2) + n

a = 2, b = 2, f(n) = n. The recursion tree is a full binary tree.

Layer i: there are 2^i nodes, each of input size n/2^i, each doing n/2^i work. Per-layer sum = 2^i · (n/2^i) = n. Every layer does the same work n. The tree has log₂ n + 1 layers, so the total is **Θ(n log n)**. This is the "all layers equal" case: total = (number of layers) × (per-layer sum).

## Worked example 2: T(n) = 3T(n/2) + n

a = 3, b = 2, f(n) = n. Recursion tree has fanout 3.

Layer i: 3^i nodes, each of size n/2^i doing n/2^i work. Per-layer sum = 3^i · (n/2^i) = n·(3/2)^i. This grows exponentially down the tree, so the **bottom layer dominates**. To get the bottom layer's sum you need the tree height. Result is \(T(n) = \Theta(n^{\log_2 3}) = \Theta(n^{1.5849\ldots})\). This is the "grows exponentially downward" case.

## Worked example 3: T(n) = 3T(n/4) + n²

a = 3, b = 4, f(n) = n². Recursion tree has fanout 3, depth ~log₄ n.

Layer i: 3^i nodes, each of size n/4^i doing (n/4^i)² = n²/16^i work. Per-layer sum = 3^i · n²/16^i = n²·(3/16)^i. This shrinks exponentially down the tree (= grows exponentially going up), so the **top layer dominates**. Result is \(T(n) = \Theta(n^2)\). This is the "decreases exponentially downward" case.

### The three representative cases

These three examples are representative. Usually one of these holds:
1. All layers have roughly equal sum → total = (height) × (per-layer sum).
2. Layer sums grow exponentially downward → bottom layer dominates (need the height to find it).
3. Layer sums shrink exponentially downward (grow exponentially upward) → top layer dominates.

A generic solution to these three cases is the **Master Theorem** (textbook p. 102–103; 3rd edition p. 94).

Most recursive algorithms have a recurrence that fits the Master Theorem. If it does not fit, try the recursion-tree method directly (you can also do that even when it does fit).

## Master Theorem

The recurrence
\[
T(n) = aT(n/b) + f(n)
\]
has the following solution, where \(\alpha = \log_b a\):

1. If \(f(n) = O(n^{\alpha - \epsilon})\) for some \(\epsilon > 0\), then \(T(n) = \Theta(n^{\alpha})\).
2. If \(f(n) = \Theta(n^{\alpha}(\log n)^k)\) for some \(k \ge 0\), then \(T(n) = \Theta(n^{\alpha}(\log n)^{k+1})\).
3. If \(f(n) = \Omega(n^{\alpha + \epsilon})\) for some \(\epsilon > 0\), then \(T(n) = \Theta(f(n))\).

**Extra condition for case 3:** there must also exist a c < 1 and an n₀ such that \(a \cdot f(n/b) \le c \cdot f(n)\) for all n ≥ n₀ (the regularity condition).

In short: the case is decided by the relation between the growth rates of f(n) and \(n^{\alpha}(\log n)^k\) (with k ≥ 0).
- Equal → case 2.
- f(n) smaller (by at least a factor \(n^{\epsilon}\)) → case 1.
- f(n) larger (by at least a factor \(n^{\epsilon}\)) → case 3 (if the extra condition holds).

The cases map onto the three recursion-tree behaviors: case 1 = bottom dominates, case 2 = all layers equal (k=0) or near-equal, case 3 = top dominates. The Master Theorem is a precomputed recursion-tree method covering many recurrences.

### Master Theorem on example 1

T(n) = 2T(n/2) + n. a=2, b=2, f(n)=n, α = log₂ 2 = 1.
f(n) = n = Θ(n¹) = Θ(n¹(log n)⁰) = Θ(n^α (log n)⁰), so k = 0.
Case 2 → T(n) = Θ(n^α (log n)^{0+1}) = **Θ(n log n)**.

### Master Theorem on example 2

T(n) = 3T(n/2) + n. a=3, b=2, f(n)=n, α = log₂ 3 = ln3/ln2 = 1.5849...
f(n) = n = O(n^{1.5849...−ε}) = O(n^{α−ε}) for e.g. ε = 0.1.
Case 1 → T(n) = Θ(n^α) = **Θ(n^{1.5849...})**.

### Master Theorem on example 3

T(n) = 3T(n/4) + n². a=3, b=4, f(n)=n², α = log₄ 3 = ln3/ln4 = 0.7924...
f(n) = n² = Ω(n^{0.7924...+ε}) = Ω(n^{α+ε}) for e.g. ε = 0.1.
Case 3 → T(n) = Θ(f(n)) = **Θ(n²)**.
Check extra condition: with c = 3/16 < 1 and n₀ = 1, a·f(n/b) = 3(n/4)² = (3/16)n² ≤ c·n² = c·f(n) for all n ≥ 1. Holds.

## Worked example 4: T(n) = 2T(n/2) + n log n

a = 2, b = 2, f(x) = x log x. Fanout 2.

**Recursion-tree analysis.** The i-th layer does \(n \log(n/2^i)\) work, which equals \(n(\log n - \log 2^i) = n(\log n - i)\). This falls as i grows, so every layer does at most as much as the first layer (i = 0). The first layer does n log n work and there are log n layers, so total work is **O(n log² n)**.

Now look at the top half of the layers, i = 1, 2, ..., k = ½ log n. The work per layer falls as i grows, so each of these does at least as much as the last of them (layer k). Layer k does
\[
n(\log n - k) = n(\log n - \tfrac12 \log n) = \tfrac12 n \log n.
\]
There are k = ½ log n such layers, each doing at least ½ n log n work, so total is **Ω(n log² n)**.

Together: total work is **Θ(n log² n)**.

**Master Theorem on example 4.** a=2, b=2, f(n)=n log n, α = log₂ 2 = 1.
f(n) = n log n = Θ(n¹(log n)¹) = Θ(n^α(log n)¹), so k = 1.
Case 2 → T(n) = Θ(n^α(log n)^{1+1}) = **Θ(n(log n)²)**. (Often written Θ(n log² n).)

## When the Master Theorem cannot be used

For the DM507 exam it is enough to:
- use the Master Theorem when it applies, and
- recognize situations where it cannot be applied.

The Master Theorem requires **all recursive calls to have the same size n/b**. Example 5 violates this.

## Worked example 5: T(n) = T(n/3) + T(2n/3) + n

This is the running time of an algorithm doing O(n) local work with two recursive calls, one of size n/3 and one of size 2n/3. The two calls have different sizes, so the recurrence is **not** of the Master Theorem form T(n) = aT(n/b) + f(n). The Master Theorem cannot be used. But the recursion-tree method still works (the solution below is not exam material).

**Recursion-tree analysis.** A node with input size x does f(x) = x work. Its two children have sizes x/3 and 2x/3, doing x/3 and 2x/3 work. Since x/3 + 2x/3 = x, a node's work equals the sum of its children's work.

So the sum of work in layer k equals the sum of work in layer k+1 whenever layer k+1 is a **full** layer (every node in layer k has two children). Therefore every full layer has the same total work. For the root's layer that sum is clearly n, so every full layer sums to n. There are log₃ n full layers (the shortest root-to-leaf path divides by 3 each step), so total work is **Ω(n log n)**.

For non-full layers the sum can only be smaller (leaves have no children, so their input size is not passed down), i.e. at most n. There are log_{3/2} n layers in total (the longest path divides by 3/2 each step), so total work is **O(n log n)**.

All together: total work is **Θ(n log n)**.

(Uses that logarithms of different bases differ by a constant factor, so log₃ n and log_{3/2} n are both Θ(log n).)

## Floors and ceilings in recurrences

We wrote Mergesort's recurrence as
\[
T(n) = 2T(n/2) + n. \tag{1}
\]
But if n is odd the two recursive calls cannot be exactly equal in size. The real recurrence is
\[
T(n) = T(\lceil n/2 \rceil) + T(\lfloor n/2 \rfloor) + n. \tag{2}
\]
Does this difference matter for the running time? **No** — shown below.

For a path down the tree, let \(n_i\) be the input size at layer i (root layer = 0).

For T(n) = 2T(n/2) + n:
\[
n_0 = n,\quad n_1 = n/2,\quad n_2 = n/2^2,\quad n_3 = n/2^3,\ \ldots,\ n_i = n/2^i.
\]

For T(n) = T(⌈n/2⌉) + T(⌊n/2⌋) + n, using \(x - 1 < \lfloor x \rfloor \le x \le \lceil x \rceil < x + 1\):
\[
n_0 = n
\]
\[
n_1 \le \lceil n_0/2 \rceil < n/2 + 1
\]
\[
n_2 \le \lceil n_1/2 \rceil < (n/2 + 1)/2 + 1 = n/2^2 + 1/2 + 1
\]
\[
n_3 < n/2^3 + 1/2^2 + 1/2 + 1
\]
\[
\ldots,\quad n_i < n/2^i + 1/2^{i-1} + \cdots + 1/2 + 1
\]
and symmetrically with floors:
\[
n_1 \ge \lfloor n_0/2 \rfloor > n/2 - 1,\quad \ldots,\quad n_i > n/2^i - (1/2^{i-1} + \cdots + 1/2 + 1).
\]

The parenthesized term is \(1 + c + c^2 + \cdots + c^{i-1}\) for c = 1/2, which by the geometric-sum fact equals
\[
\frac{(1/2)^i - 1}{1/2 - 1} = \frac{1 - (1/2)^i}{1/2} = 2 - (1/2)^{i-1} < 2.
\]

So for the floor/ceiling recurrence:
\[
n/2^i - 2 < n_i < n/2^i + 2.
\]
The input sizes \(n_i\) at any layer i differ from the clean n/2^i by only ±2.

For all functions f we meet, \(f(n+2) = O(f(n))\). For such functions we get the **same asymptotic running time** whether we analyze the recurrence with or without floors/ceilings.

Examples:
- f(n) = n: f(n+2) = n + 2 = O(n).
- f(n) = n²: f(n+2) = (n+2)² = n² + 2n + 4 = O(n²).
- f(n) = log n: f(n+2) = log(n+2) ≤ log 2n = 1 + log n = O(log n).
- f(n) = 2ⁿ: f(n+2) = 2^{n+2} = 4·2ⁿ = O(2ⁿ).
