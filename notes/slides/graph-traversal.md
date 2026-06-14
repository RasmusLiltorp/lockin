# Graphs and Graph Traversal

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/graphTraversalSlides.pdf`

This deck sets up graphs and their computer representations, then builds one generic traversal skeleton and shows that all standard traversals (BFS, DFS, priority search) are just different rules for picking the next gray node and the next edge. It proves the generic traversal reaches everything reachable from the start, derives BFS (shortest paths in edge count) and DFS (timestamps, edge classification, white-path lemma), and ends with DAGs, the cycle/back-edge connection, and topological sort.

## Graphs: basic definitions

- A graph is a set \(V\) of **vertices** (knuder), often \(V \subseteq \mathbb{N}\), and a set \(E \subseteq V \times V\) of **edges** (kanter), i.e. pairs of vertices.
- **Directed graph** (orienteret): edges are ordered pairs.
- **Undirected graph** (uorienteret): edges are unordered pairs.
- **Weighted graph** (vægtet): each edge has a number attached.
- Notation: \(n = |V|\), \(m = |E|\).
- Edge-count bounds:
  - Directed: \(0 \le m \le n^2\).
  - Undirected: \(0 \le m \le (n^2 + n)/2\).
- Further graph terminology is in the first two pages of appendix B.4 of the textbook.

Graphs model many things: utility networks (phone, power, oil, water), road networks (intersections = vertices, roads = edges), friends/followers on social media, web pages, co-authorships.

### Algorithmic questions on graphs (examples)

- How to represent a graph on a computer (data structure)?
- Is there a path between two given vertices?
- What is a shortest path between two given vertices?
- What is a smallest subset of edges that still keeps all vertices connected?
- What is a largest subset of edges that shares no vertices?

The running example question for this deck: does a path exist between two given vertices?

## Data structures for graphs

Two representations: **adjacency lists** and **adjacency matrix**.

- Adjacency lists: the list for \(u\) contains \(v\) for every edge \((u,v) \in E\).
- Vertices are represented as integers between 1 and \(n\) (or 0 and \(n-1\)).
- Space:
  - Adjacency lists: \(O(n + m)\).
  - Adjacency matrix: \(O(n^2)\).
- Default for this course (unless stated otherwise): adjacency lists. Also the most common in practice.
- An undirected edge is stored as **two** directed edges. So for implementation, undirected graphs are just a special case of directed graphs.

## Graph traversal

**Task:** given a graph in adjacency-list form, visit all vertices and edges. Goal is to examine various properties of the graph.

**General idea:** visit a start vertex \(s\). Then use edges in the adjacency lists of visited vertices to visit more vertices.

**Vertex coloring** to track progress:

- **White:** not yet visited.
- **Gray:** visited, but not all edges in its adjacency list used.
- **Black:** visited, all edges in its adjacency list used.

A vertex's life cycle is white → gray → black. When the algorithm stops, every vertex is either white or black (no gray left).

### Generic traversal from one start vertex

```
GenericGraphTraversal1(s)
  make s gray and all other vertices white
  while there exist gray vertices:
    choose a gray vertex v                       (*)
    if v's adjacency list is used up:
      make v black
    else:
      choose an unused edge (v, u) from v's adjacency list   (*)
      if u is white:
        make u gray
```

The two `(*)` choices are exactly where the variants differ. Three variants come later in the course:

- **Breadth-First-Search (BFS)**
- **Depth-First-Search (DFS)**
- **Priority-Search** (Dijkstra's algorithm, A*)

### How far do we reach? (single start)

**Theorem:** if there is a path from \(s\) to \(v\), then \(v\) is black (hence visited) when `GenericGraphTraversal1(s)` stops.

**Proof:** when the algorithm stops every vertex is white or black. \(s\) started gray, so it is now black. All other vertices started white. Suppose \(v\) is still white. Then along the path there is at least one edge \((u,w)\) with \(u\) black and \(w\) white. But \(u\) can only be black if edge \((u,w)\) was used, which made \(w\) gray, so \(w\) must now be black — contradiction. So \(v\) must be black. ∎

### Reaching the whole graph

Wrap the single-source traversal in an outer loop:

```
GenericGraphTraversalGlobal()
  make all vertices white
  for all vertices s:
    if s is white:
      GenericGraphTraversal2(s)

GenericGraphTraversal2(s)
  make s gray (and the rest white at the very first call)
  while there exist gray vertices:
    choose a gray vertex v                       (*)
    if v's adjacency list is used up:
      make v black
    else:
      choose an unused edge (v, u) from v's adjacency list   (*)
      if u is white:
        make u gray
```

**Running time:** if each `(*)` choice takes \(O(1)\), the total running time is \(O(n + m)\).

Justification: each edge can be chosen only once, so all the work done in the `else` branch totals \(O(m)\). Everything else totals \(O(n)\).

**Theorem (per call):** if at the start of a call `GenericGraphTraversal2(s)` there is a path of white vertices from \(s\) to \(v\) (including \(v\)), then \(v\) is black when that call stops.

**Proof:** before and after each call, every vertex is white or black. So the same proof as for `GenericGraphTraversal1(s)` applies. ∎

### Remembering who discovered whom (predecessors / π)

When a vertex \(u \ne s\) is visited for the first time, it stores in `u.π` the vertex that discovered it (its **predecessor**). `u.π` is set at most once (after init to NIL), because \(u\) is made gray at the same moment.

```
GenericGraphTraversalGlobalWithParents()
  make all vertices white and set their π to NIL
  for all vertices s:
    if s is white:
      GenericGraphTraversal3(s)

GenericGraphTraversal3(s)
  make s gray
  while there exist gray vertices:
    choose a gray vertex v                       (*)
    if v's adjacency list is used up:
      make v black
    else:
      choose an unused edge (v, u) from v's adjacency list   (*)
      if u is white:
        make u gray
        set u.π = v
```

**Theorem (tree structure):** the vertices discovered (made non-white) in one call `GenericGraphTraversal3(s)` form a tree with \(s\) as root and π as parent pointers. For each path from a vertex \(v\) to the root in the tree, the same path exists in the graph but in the opposite direction (from \(s\) to \(v\)).

**Proof:** this statement is an invariant maintained during the run of `GenericGraphTraversal3(s)`. ∎

Notes:

- In the global version `GenericGraphTraversal3(s)` is called repeatedly; each call gives one tree.
- Trees from different calls share no vertices (a vertex only joins a tree if it is white, after which it is non-white).
- Together the trees contain all vertices of the graph (only white vertices are not in a tree, but all vertices are black at the end).

## BFS — Breadth-First-Search

**Strategy:** keep the gray vertices in a **QUEUE**, and use up a vertex's adjacency list immediately. Add a variable `v.d` to every vertex \(v\) (`d` for distance).

Most common is the version without the Global part — for BFS we usually care about one specific \(s\) rather than covering the whole graph.

**Invariant:** queue = all gray vertices.

```
BFS(G, s)
  for each vertex u in G.V - {s}:
    u.color = WHITE
    u.d = ∞
    u.π = NIL
  s.color = GRAY
  s.d = 0
  s.π = NIL
  Q = ∅
  Enqueue(Q, s)
  while Q ≠ ∅:
    u = Dequeue(Q)
    for each v in G.Adj[u]:
      if v.color == WHITE:
        v.color = GRAY
        v.d = u.d + 1
        v.π = u
        Enqueue(Q, v)
    u.color = BLACK
```

### Worked example (slide 19)

The slide animates BFS on the CLRS-style undirected graph with vertices \(r, s, t, u, v, w, x, y\), starting from \(s\). The queue contents and the assigned `d` values evolve frame by frame:

- Start: \(Q = [s]\), \(s.d = 0\).
- After processing \(s\): its neighbors \(r\) and \(w\) get `d = 1`, \(Q = [r, w]\) (shown as `r w` with values `1 1`).
- Next frames dequeue `r`, then `w`, pushing the next layer: \(v\) gets `d = 2` (from \(r\)), then \(t\) and \(x\) get `d = 2` (from \(w\)). Queue passes through states like `w v`, `v t x`, `t x v`.
- The layer with `d = 2` (`x v` etc.) is processed, pushing `d = 3` vertices \(u\) and \(y\): queue states `x u`, `u y`, `y`.
- Final frame: queue empty, every vertex labeled with its shortest-edge distance from \(s\): the levels come out as 0 (\(s\)), 1 (\(r, w\)), 2 (\(v, t, x\)), 3 (\(u, y\)).

The bold edges in each frame are the BFS tree edges (the π pointers).

### BFS properties

**Running time:** \(O(n + m)\). Same proof as `GenericGraphTraversalGlobal`, since the `(*)` choices in BFS take \(O(1)\). BFS is often called on a single \(s\) (no Global part), which can only lower the running time.

**Tree theorem extended with distances:** the discovered vertices form a tree rooted at \(s\) with π parent pointers, and for each tree path from \(v\) to the root the same path exists reversed in the graph, **and** `v.d` equals the number of edges on that path.

**Proof:** this is an invariant maintained during the run of `BFS(G, s)`. ∎

- `v.d` is set at most once (after init to ∞): it is only set while \(v\) is white, and \(v\) becomes non-white at the same moment.
- The non-white vertices are exactly those with `v.d ≠ ∞` (an invariant).

### BFS computes shortest paths

**Definition:** \(\delta(s, v)\) = length of a shortest path, measured in number of edges, from \(s\) to \(v\). If no path exists, \(\delta(s, v) = \infty\).

**Theorem:** when BFS stops, `v.d = `\(\delta(s, v)\) for all vertices \(v\). So BFS finds shortest paths (in edge count) from \(s\) to every \(v\).

#### Proof

Possible values of \(\delta(s,v)\) are \(0, 1, 2, 3, \dots\) and \(\infty\).

- For \(v\) with \(\delta(s,v) = \infty\): no path from \(s\) to \(v\), so \(v\) is never discovered (there is a path in the graph from \(s\) to every discovered vertex). So the init value `v.d = ∞` is never changed, and `v.d = `\(\delta(s,v)\) holds for these.
- For the rest, \(\delta(s,v) = i < \infty\). Prove by induction on \(i\) that \(\delta(s,v) = i \Rightarrow\) `v.d = `\(\delta(s,v)\) when BFS stops.

**Two observations:**

1. Because of how a queue works, for \(i = 0, 1, 2, \dots\) BFS dequeues all vertices with `d`-value \(i\) while enqueuing all vertices with `d`-value \(i+1\), then continues with the next \(i\). So the `d`-values of dequeued vertices increase **monotonically**.
2. We already know \(\delta(s,v) \le \) `v.d`, since there is a path of length `v.d` in the graph when `v.d < ∞` (i.e. when \(v\) is non-white), and the claim is clear when `v.d = ∞`.

**Induction:**

- **Base (\(i = 0\)):** if \(\delta(s,v) = 0\) then \(v = s\), and BFS sets `s.d = 0`.
- **Step (\(i > 0\)):** assume \(\delta(s,v) = i-1 \Rightarrow\) `v.d = `\(\delta(s,v)\); show \(\delta(s,v) = i \Rightarrow\) `v.d = `\(\delta(s,v)\).
  - If \(\delta(s,v) = i\), a path of length \(i\) from \(s\) to \(v\) exists. The second-to-last vertex \(u\) on it has \(\delta(s,u) = i-1\) (if \(u\) had a shorter route, so would \(v\)).
  - By induction `u.d = `\(\delta(s,u)\). When \(u\) was dequeued, \(v\) (a neighbor of \(u\)) was either undiscovered (white) and now discovered by \(u\), or already discovered from some vertex \(t\) already dequeued, which by observation 1 has `t.d ≤ u.d`.
  - In BFS, \(v\) gets a `d`-value one larger than the `d`-value of the vertex discovering it. So whether \(v\) is taken by \(u\) or by \(t\), `v.d` is set to at most `u.d + 1 = `\(\delta(s,u) + 1 = (i-1)+1 = i = \delta(s,v)\). By observation 2, `v.d` is at least \(\delta(s,v)\). Together, `v.d = `\(\delta(s,v)\). ∎

## DFS — Depth-First-Search

**Strategy:** keep gray vertices in a **STACK**, and advance minimally in the adjacency list each time we look at a vertex.

The stack is implicit in the recursive formulation (it equals the recursion stack), but can also be coded explicitly. The stack elements are the gray vertices, each with a partially traversed adjacency list (the progress of the `for` loop in DFS-Visit). The `DFS(G)` driver corresponds to the Global part from earlier.

DFS adds **timestamps** to every vertex \(u\): `u.d` for discovery (white → gray) and `u.f` for finish (gray → black). Here `u.d` is **not** "distance".

```
DFS(G)
  for each vertex u in G.V:
    u.color = WHITE
    u.π = NIL
  time = 0
  for each vertex u in G.V:
    if u.color == WHITE:
      DFS-Visit(G, u)

DFS-Visit(G, u)
  time = time + 1
  u.d = time            // white vertex u just discovered
  u.color = GRAY
  for each v in G.Adj[u]:   // explore edge (u, v)
    if v.color == WHITE:
      v.π = u
      DFS-Visit(G, v)
  u.color = BLACK         // blacken u; it is finished
  time = time + 1
  u.f = time
```

### Worked example (slide 27)

The slide animates DFS on a small directed graph with vertices \(u, v, w, x, y, z\) (CLRS Figure 22.4), 16 frames (a)–(p). Each vertex ends labeled with its `d/f` interval and each edge is classified (B = back, F = forward, C = cross; tree edges are the bold recursion-tree edges). Final timestamps:

- \(u\): 1/8
- \(v\): 2/7
- \(x\): 4/5
- \(y\): 3/6
- \(w\): 9/12
- \(z\): 10/11

Edge labels appearing in the animation include a back edge B (e.g. \((x,v)\)), forward edge F, and cross edge C, matching the classification rules below.

### DFS properties

**Running time:** \(O(n + m)\). Same proof as `GenericGraphTraversalGlobal`, since the `(*)` choices in DFS take \(O(1)\).

Observe:

- Discovery (white → gray) of \(v\) = set `v.d` = call DFS-Visit on \(v\) = **push** \(v\) on the stack.
- Finish (gray → black) of \(v\) = set `v.f` = return from DFS-Visit on \(v\) = **pop** \(v\) from the stack.

`v.π` is set when DFS-Visit is called on \(v\). From this it follows that:

- The edges \((v.\pi, v)\) form exactly the recursion trees of DFS-Visit (one tree per call from DFS).
- The interval \([v.d, v.f]\) is the period \(v\) is on the stack.
- \(v\) is gray if and only if it is on the stack.

#### Parenthesis structure

How a stack works: if two vertices \(u\) and \(v\) are on the stack at the same time and \(v\) is on top, then \(v\) must be popped before \(u\) can be popped.

Since \([v.d, v.f]\) is exactly \(v\)'s time on the stack, for every pair of vertices \(u, v\) the intervals \([u.d, u.f]\) and \([v.d, v.f]\) are either:

- **disjoint** (\(u\) and \(v\) were never on the stack together), or
- one is **fully contained** in the other (they were on the stack together; the one with the larger interval got there first).

So discovery and finish times are **nested like parentheses**.

#### Edge classification

When an edge \((u, v)\) is examined from \(u\) (meaning \(u\) is on top of the stack), the cases are:

1. **Tree edges:** \(v\) is white. Ordering: \(u.d < v.d = \text{now} < v.f < u.f\).
2. **Back edges:** \(v\) is gray (on the stack, below \(u\); possibly \(u = v\) for a self-loop). Ordering: \(v.d \le u.d \le \text{now} < u.f \le v.f\).
3. **Forward edges:** \(v\) is black (no longer on the stack, but was there together with \(u\)). Ordering: \(u.d < v.d < v.f \le \text{now} < u.f\).
4. **Cross edges:** \(v\) is black (no longer on the stack, and was never there together with \(u\)). Ordering: \(v.d < v.f < u.d \le \text{now} < u.f\).

These cases can be recognized when the edge is examined during DFS, using the white/gray/black coloring plus (for cases 3 and 4) the `d`-values of the edge's two vertices — and those `d`-values have already been set by the time the edge is examined.

**Undirected graphs:** only tree edges and back edges occur (if each edge is classified the first time it is examined from one of its ends). Reason: if \(v\) is black then its whole adjacency list has been traversed, so \(u\) must already have been examined from \(v\), and the edge \((v,u)\) is already classified. So cases 3 and 4 cannot arise.

#### White-path lemma

**White-path lemma:** if there is a path of white vertices (including \(w\)) from \(u\) to \(w\) at time `u.d`, then \(u.d < w.d < w.f < u.f\).

**Proof:** since the path is white at time `u.d`, we have \(u.d \le v.d\) for every vertex \(v\) on the path. By the parenthesis structure of `d`/`f` times, for each such \(v\) either:

1. \(u.d \le v.d < v.f \le u.f\), or
2. \(u.d < u.f < v.d < v.f\).

Suppose (2) occurs. Let \(y\) be the first vertex on the path satisfying (2). Then \(y\) has a predecessor \(x\) on the path satisfying (1) (possibly \(x = u\), which satisfies (1)). But because of the edge \((x, y)\), \(y\) must be discovered before time `x.f`, contradicting that \(y\) satisfies (2). ∎

## DAGs and topological sorting

**DAG** = Directed Acyclic Graph: a directed graph with no cycles (kredse). Often used to model dependencies. The slide's example is the CLRS "getting dressed" DAG (undershorts, pants, belt, shirt, tie, jacket, socks, shoes, watch) with DFS timestamps shown.

**Topological sort** of a DAG: a linear ordering of the vertices so that all edges go from left to right. In the dressed example the order comes out (with `d/f` stamps): socks 17/18, undershorts 11/16, pants 12/15, shoes 13/14, watch 9/10, shirt 1/8, belt 6/7, tie 2/5, jacket 3/4.

### Cycle ⇔ back-edge

**Lemma:** a directed graph has a cycle ⇔ a back edge is found during a DFS traversal.

**Proof:**

- **⇒:** DFS (with the Global outer loop) discovers all vertices. Look at the first vertex \(v\) in the cycle that becomes gray; at time `v.d` all other vertices are white. By the white-path lemma, \(v.d < u.d < u.f < v.f\) for the last vertex \(u\) in the cycle (the one pointing to \(v\)), so the edge \((u, v)\) is declared a back edge (\(v\) is gray when this edge is examined).
- **⇐:** when a back edge is found there is a cycle made of zero or more tree edges (between vertices currently on the stack) plus one back edge.

### Finish-time ordering ⇔ back-edge

**Lemma:** for an edge \((u, v)\), \(u.f \le v.f\) ⇔ the edge is a back edge.

**Proof:** check the four edge cases (tree, back, forward, cross) and their orderings of `u.f` and `v.f` from the earlier slide.

**Corollary (of the two lemmas):** a graph is a DAG ⇔ DFS finds no back edges ⇔ ordering vertices by **decreasing finish time** gives a topological sort.

So this algorithm finds a topological sort of a DAG:

```
TOPOLOGICAL-SORT(G)
  call DFS(G) to compute finishing times v.f for each vertex v
  as each vertex is finished, insert it onto the front of a linked list
  return the linked list of vertices
```

**Time:** \(O(n + m)\).
