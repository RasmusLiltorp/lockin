# Asymptotic Analysis of Algorithm Running Times

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/asymptoticAnalysis.pdf`

This deck builds the machinery for comparing algorithm running times by growth rate. It first checks that RAM-model analysis matches measured running times on real machines, then argues why multiplicative constants don't matter when growth rates differ. It defines the five asymptotic relations (O, Ω, Θ, o, ω), gives limit-based tools for proving them, and ends with three worked loop-analysis examples.

## Why we analyze running time

We want to judge algorithms before spending time implementing them. Two main questions:

- Does the algorithm solve the task (is it correct)?
- Is the algorithm efficient (what is the running time)?

These slides focus on the second question.

A running time is the number of basic operations the algorithm performs in the RAM model, for worst-case input. That count is a growing function \(f(n)\) of the input size \(n\). Plan:

1. Check how well theoretical RAM-model analysis matches observed running time on real computers.
2. Introduce asymptotic analysis as a tool to compare \(f(n)\) across algorithms at a deliberately (im)precise level.

Goal: coarse-sort algorithms by the growth rate of their running times, so we avoid implementing ones that have no chance of being fastest.

## Analysis vs. reality (measured experiments)

The slides run three Java programs and plot measured time divided by the predicted growth term. If the analysis is right, that ratio should flatten to a constant.

### Linear

```
for(long i=1; i<=n; i++){
    total = total + 1;
}
```

Analysis: `Tid(n) = c1·n + c0`. Then

\[
\frac{Tid(n)}{n} = \frac{c_1 n + c_0}{n} = c_1 + \frac{c_0}{n}
\]

The plot of (measured time)/n is roughly flat around 2.8e-06 ms for \(n\) up to ~4.5e9. The x-axis is input size \(n\); the y-axis is (measured time)/n.

### Quadratic

```
for(long i=1; i<=n; i++){
    for(long j=1; j<=n; j++){
        total = total + 1;
    }
}
```

Analysis: `Tid(n) = (c2·n + c1)·n + c0 = c2·n² + c1·n + c0`. The plot of (measured time)/n² is roughly flat (around 2.6e-06 to 4.4e-06 ms) for \(n\) up to ~70000.

### Cubic

```
for(long i=1; i<=n; i++){
    for(long j=1; j<=n; j++){
        for(long k=1; k<=n; k++){
            total = total + 1;
        }
    }
}
```

Analysis: `Tid(n) = ((c3·n + c2)·n + c1)·n + c0 = c3·n³ + c2·n² + c1·n + c0`. The plot of (measured time)/n³ is roughly flat for \(n\) up to ~2000.

### Conclusion of the experiment

RAM-model analysis seems to predict real running time fairly well, at least for the tested examples.

## Linear vs. quadratic vs. cubic

A double-logarithmic plot of measured time for the three programs over \(n\) from 100 to 1e10 shows that \(n\), \(n^2\), \(n^3\) give very different efficiencies. The analysis actually contains a number of constants we usually can't know precisely (e.g. \(c_1 n + c_0\)). Question raised: do these constants matter?

## Multiplicative constants

Multiplicative constants don't matter when the growth rate differs. Example functions:

- \(f(n) = 3000n\), \(g(n) = 4000n\)
- \(h(n) = 3n^2\), \(k(n) = 4n^2\)

Does \(3000n\) beat \(4n^2\)? Yes:

\[
3000n < 4n^2 \iff 3000 < 4n \iff 750 < n
\]

So past \(n = 750\), the linear function wins. In general a linear term always beats a quadratic term eventually:

\[
c_1 n < c_2 n^2 \iff c_1/c_2 < n
\]

## Growth rate and the coarse-sort principle

We want to compare functions' essential growth rate while ignoring multiplicative constants. Stated principle:

> If two algorithms A and B have growth rates where B always (for large \(n\)) loses to A, no matter which multiplicative constants appear in the growth-rate expressions, then there is usually no point in implementing B.

We don't need to know the constants to make this judgment. So we can do running-time analysis without worrying about the exact size of the constants involved.

## Asymptotic notation: the class of a function

The tool ignores multiplicative constants. The principle: for a function \(f(n)\), treat all its scalings

\[
\{c \cdot f(n) \mid \text{all } c > 0\}
\]

as equally good. This set is called \(f(n)\)'s **class**.

From this we define five relations for the growth rate of functions, matching the five classic order relations on numbers:

| Order relation | Asymptotic symbol | Spoken | Meaning (growth rate) |
|----------------|-------------------|--------|------------------------|
| \(\le\) | \(O\) | "O" | \(f \le g\) |
| \(\ge\) | \(\Omega\) | "Omega" | \(f \ge g\) |
| \(=\) | \(\Theta\) | "Theta" | \(f = g\) |
| \(<\) | \(o\) | "little o" | \(f < g\) |
| \(>\) | \(\omega\) | "little omega" | \(f > g\) |

### The five definitions (principles)

- **O**: \(f \le g\) in growth rate. \(f(n)\) grows at most as fast as functions from \(g(n)\)'s class.
- **Ω (Omega)**: \(f \ge g\) in growth rate. \(f(n)\) grows at least as fast as functions from \(g(n)\)'s class.
- **Θ (Theta)**: \(f = g\) in growth rate. \(f(n)\) grows exactly as fast as functions from \(g(n)\)'s class.
- **o (little o)**: \(f < g\) in growth rate. \(f(n)\) grows slower than all functions from \(g(n)\)'s class.
- **ω (little omega)**: \(f > g\) in growth rate. \(f(n)\) grows faster than all functions from \(g(n)\)'s class.

## These relations behave like order relations

The definitions behave like the order relations on numbers. Examples (with the number analogue):

- \(f(n) = o(g(n)) \Rightarrow f(n) = O(g(n))\) (cf. \(x < y \Rightarrow x \le y\))
- \(f(n) = \Theta(g(n)) \Rightarrow f(n) = O(g(n))\) (cf. \(x = y \Rightarrow x \le y\))
- \(f(n) = O(g(n)) \iff g(n) = \Omega(f(n))\) (cf. \(x \le y \iff y \ge x\))
- \(f(n) = o(g(n)) \iff g(n) = \omega(f(n))\) (cf. \(x < y \iff y > x\))
- \(f(n) = O(g(n))\) and \(f(n) = \Omega(g(n)) \Rightarrow f(n) = \Theta(g(n))\) (cf. \(x \le y\) and \(x \ge y \Rightarrow x = y\))

## Asymptotic analysis in practice: two limit theorems

Most asymptotic relations between functions \(f\) and \(g\) can be settled by two theorems (provable from the definitions):

\[
\text{(1)}\quad \text{If } \frac{f(n)}{g(n)} \to k > 0 \text{ as } n \to \infty, \text{ then } f(n) = \Theta(g(n))
\]

\[
\text{(2)}\quad \text{If } \frac{f(n)}{g(n)} \to 0 \text{ as } n \to \infty, \text{ then } f(n) = o(g(n))
\]

Worked examples:

\[
\frac{20n^2 + 17n + 312}{n^2} = \frac{20 + 17/n + 312/n^2}{1} \to \frac{20+0+0}{1} = 20 \quad (n \to \infty)
\]

So \(20n^2 + 17n + 312 = \Theta(n^2)\) by (1).

\[
\frac{20n^2 + 17n + 312}{n^3} = \frac{20/n + 17/n^2 + 312/n^3}{1} \to \frac{0+0+0}{1} = 0 \quad (n \to \infty)
\]

So \(20n^2 + 17n + 312 = o(n^3)\) by (2).

## Two facts from math: polynomials vs. exponentials and logs

**Fact (3):** For all \(a > 0\) and \(b > 1\):

\[
\frac{n^a}{b^n} \to 0 \quad (n \to \infty)
\]

So every polynomial is \(o()\) of every exponential function. Example:

\[
\frac{n^{100}}{2^n} \to 0 \quad (n \to \infty), \quad \text{hence } n^{100} = o(2^n)
\]

**Fact (4):** For all \(a, d > 0\) and \(c > 1\):

\[
\frac{(\log_c n)^a}{n^d} \to 0 \quad (n \to \infty)
\]

So every logarithm (even raised to any power) is \(o()\) of every polynomial. Example:

\[
\frac{(\log n)^3}{n^{0.5}} \to 0 \quad (n \to \infty), \quad \text{hence } (\log n)^3 = o(n^{0.5})
\]

### Why (4) reduces to (3) (not curriculum / "ikke pensum")

For \(c > 1\) and \(d > 0\), set \(N = \log_c(n)\) and \(b = c^d\). Then

\[
\frac{(\log_c n)^a}{n^d} = \frac{N^a}{(c^{\log_c n})^d} = \frac{N^a}{c^{d \log_c n}} = \frac{N^a}{(c^d)^{\log_c n}} = \frac{N^a}{(c^d)^N} = \frac{N^a}{b^N}
\]

Since \(\log_c(n)\) is increasing and unbounded, \(n \to \infty\) is the same as \(N = \log_c(n) \to \infty\). So this is exactly fact (3) in \(N\).

## Ranking of common functions by growth rate

Using rules (1)–(4) you can show these functions are in increasing growth rate (more precisely, each is \(o()\) of the next):

\[
1,\ \log n,\ \sqrt{n},\ n,\ n\log n,\ n\sqrt{n},\ n^2,\ n^3,\ n^{10},\ 2^n
\]

(Listed as an exercise for the tutorial sessions.) Note \(n\sqrt{n}\) (i.e. \(n^{1.5}\)) sits between \(n\log n\) and \(n^2\).

## Dominating terms

For functions with several terms (parts added together), the term(s) with the largest growth rate determine the overall growth rate. Example functions:

- \(f(n) = 700n^2\), \(g(n) = 7n^3\)
- \(h(n) = 600n^2 + 500n + 400\), \(k(n) = 6n^3 + 5n^2 + 4n + 3\)

Confirmed by limit calculations:

\[
\frac{6n^3 + 5n^2 + 4n + 3}{7n^3} = \frac{6 + 5/n + 4/n^2 + 3/n^3}{7} \to \frac{6}{7} \quad \Rightarrow\ 6n^3 + 5n^2 + 4n + 3 = \Theta(7n^3)
\]

\[
\frac{600n^2 + 500n + 400}{700n^2} = \frac{600 + 500/n + 400/n^2}{700} \to \frac{600}{700} = \frac{6}{7} \quad \Rightarrow\ 600n^2 + 500n + 400 = \Theta(700n^2)
\]

\[
\frac{600n^2 + 500n + 400}{6n^3 + 5n^2 + 4n + 3} = \frac{600/n + 500/n^2 + 400/n^3}{6 + 5/n + 4/n^2 + 3/n^3} \to \frac{0}{6} = 0 \quad \Rightarrow\ 600n^2 + 500n + 400 = o(6n^3 + 5n^2 + 4n + 3)
\]

## Worked example 1: single loop with step 2

```
Algoritme1(n)
    i = 1
    while i <= n
        i = i + 2
```

The loop has \(\lceil n/2 \rceil = \Theta(n)\) iterations. Each iteration takes between \(c_1\) and \(c_2\) time for unknown constants \(c_1, c_2\), i.e. \(\Theta(1)\) time. So the running time is \(\Theta(n \cdot 1) = \Theta(n)\).

The slide notes it skipped the first line and loop initialization. A more precise analysis would give something like \(c_1 n + c_0\), but we drop terms clearly dominated by others.

## Worked example 2: triangular nested loop

```
Algoritme2(n)
    s = 0
    for i = 1 to n
        for j = i downto 1
            s = s + 1
```

- **Upper bound:** \(n\) iterations of the outer loop; for each, at most \(n\) iterations of the inner loop; each inner iteration is \(\Theta(1)\). So running time is \(O(n \cdot n \cdot 1) = O(n^2)\).
- **Lower bound:** for \(i \ge n/2\) (that is, \(n/2\) iterations of the outer loop) there are at least \(n/2\) inner iterations. So running time is \(\Omega(n/2 \cdot n/2 \cdot 1) = \Omega(n^2)\).
- **Together:** \(\Theta(n^2)\).

Alternative analysis: the inner loop runs \(1 + 2 + 3 + \dots + n = \frac{(n+1)n}{2} = \Theta(n^2)\) times.

## Worked example 3: triple nested loop

```
Algoritme3(n)
    s = 0
    for i = 1 to n
        for j = i to n
            for k = i to j
                s = s + 1
```

- **Upper bound:** \(n\) outer iterations; for each, at most \(n\) middle iterations; for each, at most \(n\) inner iterations; each inner iteration \(\Theta(1)\). So running time is \(O(n \cdot n \cdot n \cdot 1) = O(n^3)\).
- **Lower bound:** for \(i \le n/4\) (that is, \(n/4\) outer iterations) there are \(n/4\) middle iterations with \(j \ge 3n/4\). For these, \(j - i \ge n/2\), so the inner loop has at least \(n/2\) iterations. So running time is \(\Omega(n/4 \cdot n/4 \cdot n/2 \cdot 1) = \Omega(n^3)\).
- **Together:** \(\Theta(n^3)\).

## Summary (working principle)

First compare algorithms' growth rates via asymptotic analysis, and normally implement only the one with the lowest growth rate. For two algorithms with the same growth rate, implement both and measure their running times.
