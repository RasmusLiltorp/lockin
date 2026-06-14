# Analysis of Algorithms (Introduction)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/algoritmeAnalyseIntro.pdf`

This deck sets up what it means to analyze an algorithm in SE4-DMAD. It defines correctness as the minimum requirement, introduces the RAM model of computation, explains why we measure worst-case running time as a function of input size, and motivates comparing functions by their growth rate — the lead-in to asymptotic notation.

## Course focus

In DM507 / DM578 / DS814 / SE4-DMAD the work is to:

- Describe existing algorithms.
- Develop new algorithms.
- Assess / analyze algorithms.

The driving question of this deck: when we analyze an algorithm, what should we focus on?

## Correctness is the minimum requirement

Before any quality comparison, an algorithm must be correct. Two conditions:

- It stops on all inputs (never an infinite loop / never runs forever).
- It produces correct output when it stops (i.e. it actually answers the problem).

Correct algorithms can still differ in quality along several axes:

- Speed (running time).
- Space usage.
- Complexity of the implementation.
- Extra properties that are specific to the problem.

This course focuses on speed.

## Ingredients of algorithm analysis

To analyze an algorithm you need four things:

- **Model of the problem.** Defined individually per problem, but usually straightforward.
- **Model of the machine.** We use the RAM model (next section).
- **A measure of quality.** We focus on time usage.
- **Mathematical tools.** This course uses, among others: asymptotic notation, invariants, induction, and recurrence equations (rekursionsligninger).

## The RAM model

The RAM (Random Access Machine) model is the abstract machine we analyze against. It has two parts: a CPU connected to a memory.

- **Memory:** one large array of cells, each cell holding a single number or character. A list / array is just many neighboring cells.
- **CPU:** has a fixed set of basic operations:
  - plus, minus, multiply, compare, ... on the contents of two cells.
  - move content between two cells.
  - jump in the program (this is what gives loops, branching, and function/method calls).

Key assumption: **all basic operations are assumed to take the same amount of time.**

From this the two cost measures are:

- **Time** of an algorithm = number of basic operations executed.
- **Space** of an algorithm = maximum number of memory cells occupied.

## Which input do we measure on?

For a given input size \(n\) there are usually many concrete inputs, and an algorithm typically runs for different amounts of time on each.

Example problem — **Sorting** = put \(n\) elements into increasing order.

For \(n = 8\), four of the many possible input lists:

```
7,2,3,1,8,5,4,6
1,8,2,7,3,6,4,5
1,2,3,4,5,6,7,8
8,7,6,5,4,3,2,1
```

Each of these generally takes a different amount of time. So: which inputs do we use to judge the time usage?

### Worst / average / best case

For inputs of a fixed size \(n\):

- **Worst case** = max running time over all inputs of size \(n\).
- **Average case** = average running time over some distribution of inputs of size \(n\).
- **Best case** = min running time over all inputs of size \(n\).

The slide draws a bar chart: each bar is the running time of one input of the (same) size \(n\). The top dashed line marks the worst case (tallest bar), the lower dashed line marks the average.

### Why worst case

- **Worst case gives a guarantee.** It is also often representative of the average case, though it can be more pessimistic.
- **Average case:** which input distribution do you assume? Why is that distribution realistic/relevant? The analysis is often mathematically hard to carry out.
- **Best case:** usually gives little relevant information.

Takeaway stated on the slide: **almost all analyses in this course are worst case.**

## Different input sizes

Worst-case running time is normally a **growing function** of the input size \(n\). The slide shows groups of bars for increasing \(n\) with a red curve rising through them — the running time grows as \(n\) grows.

## Growth rate (voksehastighed)

So an analysis must produce a **function \(f(n)\)** of the input size \(n\).

To compare the running times of algorithms we therefore compare functions: we want to study how two functions \(f(n)\) and \(g(n)\) grow as \(n\) increases.

In particular we want to recognize when, say, \(g(n)\) will always exceed \(f(n)\) once \(n\) is large enough. Then we say \(g(n)\) has a **larger growth rate** than \(f(n)\), and we normally prefer the algorithm with running time \(f(n)\).

Reason this matters: for small \(n\) almost every algorithm is fast, so it is the running time for **large \(n\)** that is interesting. (The slide's plot shows \(f\) and \(g\) crossing for small \(n\), but \(g\) ending up above \(f\) for large \(n\).)

### Functions ordered by increasing growth rate

The slide lists, slowest-growing first:

\[
1,\quad \log n,\quad \sqrt{n},\quad n,\quad n \log n,\quad n\sqrt{n},\quad n^2,\quad n^3,\quad n^{10},\quad 2^n
\]

### How different these are in practice

Assume the CPU does \(10^9\) operations per second. The table shows the largest input size \(n\) you can handle if the algorithm performs \(f(n)\) CPU operations and must finish within the given time budget.

| budget | \(n\) | \(n \log n\) | \(n^2\) | \(n^3\) | \(n^{10}\) | \(2^n\) |
|---|---|---|---|---|---|---|
| 1 minute | \(6.0 \cdot 10^{10}\) | \(1.9 \cdot 10^{9}\) | 245,000 | 3,910 | 12 | 36 |
| 1 month | \(2.6 \cdot 10^{15}\) | \(5.7 \cdot 10^{13}\) | 50,900,000 | 137,000 | 35 | 51 |

Read this as: with an \(n^2\) algorithm and a one-minute budget you can handle inputs up to about 245,000; with a \(2^n\) algorithm even a whole month only gets you to \(n = 51\). Giving an exponential algorithm vastly more time barely increases the size of problem it can solve (36 → 51), while for the slow-growing functions the feasible \(n\) jumps enormously.

## Asymptotic growth rate (preview)

The deck closes by flagging that a **formal definition of asymptotic growth rate** for functions comes later. That will be the tool used to compare the running times of algorithms.
