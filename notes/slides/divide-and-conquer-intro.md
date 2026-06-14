# Divide-and-Conquer Algorithms (First Introduction)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/divideAndConquerFirstIntroSlides.pdf`

This deck introduces divide-and-conquer as a general algorithm-design method and equates it with recursive algorithms. It lays out the three-step recipe (split, recurse, combine), shows the generic code skeleton with base case and recursive calls, then visualizes the control flow of a single call and the global control flow as a recursion tree. The last slide ties recursion trees to the call stack via push/pop.

## What divide-and-conquer is

Divide-and-conquer is the same thing as recursive algorithms. The slides state this directly: "Det samme som rekursive algoritmer." It is a general method for developing algorithms.

The method has three steps:

1. **Divide** — split the problem into smaller subproblems *of the same type*.
2. **Conquer (recurse)** — solve the subproblems by recursion, i.e. call the algorithm itself but on the smaller inputs.
3. **Combine** — build a solution to the whole problem from the solutions of the subproblems.

**Base case:** problems of the smallest size are solved directly, without recursion. Every recursive algorithm needs at least one base case so the recursion terminates.

## General code structure

The slides give a generic skeleton. "Lokalt arbejde" = local work (the non-recursive work done inside a single call).

```
If base case
    Local work (solve a base-size problem)
Else
    Local work        (e.g. build one or more subproblems)
    Recursive call
    Local work        (e.g. use the answer to build the next subproblem)
    Recursive call
    Local work        (solve the main problem from the subproblem answers)
```

Note on the number of recursive calls: there do not have to be exactly two. Some recursive algorithms have just one recursive call, and some have more than two. The skeleton above shows two only as an example. Local work can appear before, between, and after the recursive calls.

## Flow of control — local view (one call)

The slides show the flow of control for a single call of the algorithm, splitting it into two cases.

- **Base case:** the call just does some "Arbejde" (work) and returns. No recursive calls. One block of work, then control returns to the caller.
- **Non–base case:** the call interleaves work and recursion in this order:
  - Arbejde (work)
  - Rekursivt kald (recursive call) — control goes out and comes back
  - Arbejde (work)
  - Rekursivt kald (recursive call) — control goes out and comes back
  - Arbejde (work)

So in the non-base case, work segments are separated by recursive calls. Each recursive call hands control away and later returns it, and the call resumes with the next local-work segment.

## Global flow of control = recursion tree

Looking at all calls together, the global flow of control forms a **recursion tree** (rekursionstræ).

- **One node = one call of the algorithm.** The root is the original top-level call; each child is a recursive call made by its parent; leaves are base-case calls.
- The red arrows in the diagram trace the actual execution path: it enters the root, descends into the first child, runs that subtree fully, comes back up, descends into the next child, and so on, finally returning out of the root. This is a depth-first traversal of the tree.

### Relation to the call stack

Remember: all calls on the path from the root down to the currently active call are "in progress" but paused. Their local variables and other state are kept by the operating system on a **stack**, so that the executions of different calls do not get mixed together.

- **Calling a child** in the recursion tree = **push** onto the stack.
- **A child finishing** its execution = **pop** from the stack.

At any moment, the stack holds exactly the chain of calls from the root to the call running right now (the current root-to-node path), which is why each call's local state stays separate.
