# Shortest Paths (Korteste veje)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/shortestPathsSlides.pdf` (27 slides)

This deck covers shortest paths in weighted graphs. It builds everything on one general technique — relaxation — and then derives the standard algorithms from it: Dijkstra (non-negative weights), the DAG algorithm, and Bellman-Ford-Moore (handles negative weights, detects negative cycles). It then moves to all-pairs shortest paths (Floyd-Warshall, Johnson) and finishes with A* as a tuned version of Dijkstra. Correctness throughout rests on two results: the path-relaxation lemma and the always-true bound \(\delta(s,v) \le v.d\).

## Setup and definitions

- Length of a path = sum of edge weights on the path.
- \(\delta(u,v)\) = length of a shortest path from \(u\) to \(v\). Set to \(\infty\) if no path exists.
- Single-source shortest-path (SSSP) problem: given \(s \in V\), find \(\delta(s,v)\) (and a concrete path of that length) for all \(v \in V\).

Optimal-substructure remark: prefixes of shortest paths are themselves shortest paths. If \(v_1, v_2, \dots, v_k\) is a shortest path from \(v_1\) to \(v_k\), then \(v_1, \dots, v_i\) is a shortest path from \(v_1\) to \(v_i\) for all \(i \le k\). Otherwise you could shorten the whole path.

### When is the problem well-defined

The problem is **not** well-defined if there is a cycle reachable from \(s\) with negative total weight. Then paths of arbitrarily low length exist (loop around the negative cycle as many times as you like).

If no such negative cycles exist, you can restrict to **simple paths** (no repeated vertices). There are finitely many simple paths (at most \(n!\)), so "length of a shortest path" is well-defined.

## Relaxation — the general technique

Idea: use edges to propagate information between vertices about lengths of known paths. This step is called **Relax** on an edge.

If \(u\) knows there is a path from \(s\) to \(u\) of length \(u.d\), and \((u,v)\) is an edge of weight \(w\), then there is a path of length \(u.d + w\) to \(v\). Relax asks: is that better than what \(v\) currently knows?

```
INIT-SINGLE-SOURCE(G, s)
    for each v in G.V
        v.d = inf
        v.pi = NIL
    s.d = 0

RELAX(u, v, w)
    if v.d > u.d + w(u, v)
        v.d = u.d + w(u, v)
        v.pi = u
```

Implementation detail: "\(\infty\)" must behave correctly under ">" and "+". Just using `Integer.MAX_VALUE` is not enough (it overflows on addition).

### Invariants of relaxation-based algorithms

Every algorithm in this deck starts with `INIT-SINGLE-SOURCE` and then changes \(v.d\) and \(v.\pi\) only via `RELAX`. For such algorithms:

**Invariant 1 (by induction on number of Relax calls):** If \(v.d < \infty\), there exists a path from \(s\) to \(v\) of length \(v.d\).

Consequences:
- \(\delta(s,v) \le v.d\) always holds. If \(v.d < \infty\) it follows from Invariant 1; if \(v.d = \infty\) it holds regardless of \(\delta(s,v)\).
- \(v.d\) can only decrease under Relax. So once \(\delta(s,v) = v.d\) at some point, \(v.d\) can never change again (and neither can \(v.\pi\), since both change together in the code).
- If \(\delta(s,v) = v.d\) for **all** vertices, no edge \((u,v)\) can be relaxed: \(v.d \le u.d + w(u,v)\) holds for every edge.

**Invariant 2 — the shortest-path tree (by induction on number of Relax calls):**
- The set \(S\) of vertices \(v\) whose \(v.d\) satisfies \(\delta(s,v) = v.d < \infty\) forms a tree, with \(v.\pi\) as parent pointers and \(s\) as root.
- For a vertex \(v\) in the tree, the path toward the root is the reverse of a graph path from \(s\) to \(v\) of length \(\delta(s,v)\).

Proof of Invariant 2:
- **Basis:** right after init, \(s\) is the only vertex with \(v.d < \infty\). Since \(s.d = 0\) and \(s.\pi = \text{NIL}\), \(S = \{s\}\), a tree of size one, provided \(\delta(s,s) = 0\). (\(\delta(s,s) \ne 0\) is only possible if \(s\) lies on a negative cycle; then every reachable vertex has \(\delta = -\infty\) and \(S\) is always empty, so nothing to show.)
- **Inductive step:** if the IF-test in Relax is false, no \(v.d\) changes, \(S\) is unchanged. If the test is true, \(v.d\) and \(v.\pi\) change for exactly one vertex \(v\). \(v\) was not in \(S\) before (members of \(S\) can't change). There's only something to prove if \(v\) joins \(S\), i.e. \(\delta(s,v) = v.d\) afterward. Let \((u,v)\) be the relaxed edge with weight \(w\). Then \(\delta(s,v) = v.d = u.d + w\). This forces \(\delta(s,u) = u.d\) (a shorter path to \(u\) would give a shorter path to \(v\)) and \(u.d < \infty\) (else Relax wouldn't happen). So \(u\) is in \(S\), in the tree by the induction hypothesis, and gets \(v\) as a child. The statement holds again. □

## Dijkstra's algorithm [1959]

Solves SSSP with **all edge weights \(\ge 0\)**. Greedy: builds up the set \(S\) of vertices with correct \(v.d\) and \(v.\pi\) one at a time, using a priority queue \(Q\).

```
DIJKSTRA(G, w, s)
    INIT-SINGLE-SOURCE(G, s)
    S = {}
    Q = G.V              // insert all vertices into Q
    while Q != {}
        u = EXTRACT-MIN(Q)
        S = S ∪ {u}
        for each vertex v in G.Adj[u]
            RELAX(u, v, w)     // a decrease in v.d is a DECREASE-KEY in Q
```

**Invariant:** when \(u\) is added to \(S\) (extracted by Extract-Min), \(u.d = \delta(s,u)\) — provided all edge weights are \(\ge 0\). Proof of the invariant is an induction done on the board. The invariant gives correctness, since all vertices end up in \(S\).

**Running time:** \(n\) Inserts (or one Build-Heap), \(n\) Extract-Min, \(m\) Decrease-Key (inside Relax). With a heap priority queue this is \(O(m \log n)\).

### Worked example (slide 10)

Graph with source \(s\) on the left, edges: \(s \to t\) (10), \(s \to y\) (5), \(t \to y\) (2), \(t \to x\) (1), \(y \to t\) (3), \(y \to x\) (9), \(y \to z\) (2), \(x \to z\) (4), \(z \to x\) (6), \(z \to s\) (7). The six panels (a)-(f) show the queue being processed in order \(s, y, t, x, z\). Final distances: \(s=0\), \(y=5\), \(t=8\), \(x=9\), \(z=7\). Bold edges form the shortest-path tree; the shaded vertex in each panel is the one just extracted.

## Path-relaxation lemma

Dijkstra assumes non-negative weights. The next algorithms handle negative weights (but not negative cycles, which make the problem undefined). They rely on this lemma.

**Lemma:** If \(s = v_1, v_2, \dots, v_k = v\) is a shortest path from \(s\) to \(v\), and an algorithm performs Relax on the edges \((v_1,v_2), (v_2,v_3), \dots, (v_{k-1},v_k)\) in that order (with any number of other Relax calls interleaved), then \(\delta(s,v) = v.d\) after the last of these Relax calls.

**Proof:** By induction on \(i\): after Relax on edge \((v_{i-1}, v_i)\) in the sequence, \(v_i.d\) is at most the sum of the weights of the first \(i-1\) edges of the path. So after the last Relax, \(v.d \le \delta(s,v)\) (the path is a shortest path to \(v\)). Since \(\delta(s,v) \le v.d\) always holds, \(\delta(s,v) = v.d\). □

## Algorithm for DAGs

Recall: DAG = Directed Acyclic Graph. A topological sort can be found via DFS in \(O(n+m)\).

```
DAG-SHORTEST-PATHS(G, w, s)
    topologically sort the vertices
    INIT-SINGLE-SOURCE(G, s)
    for each vertex u, taken in topologically sorted order
        for each vertex v in G.Adj[u]
            RELAX(u, v, w)
```

**Running time:** \(O(n+m)\).

**Theorem:** when the algorithm stops, \(v.d = \delta(s,v)\) for all \(v \in V\).

**Proof:** For a vertex \(v\) reachable from \(s\): every vertex on a shortest path to \(v\) is relaxed in topological order, so by the path-relaxation lemma the correct \(\delta\) values are set along that path. For unreachable vertices, \(\infty = \delta(s,v)\), and correctness follows from \(\delta(s,v) \le v.d\) always holding. (No negative-cycle worry: a DAG has no cycles at all.)

### Worked example (slide 13)

Linear DAG drawn left to right with vertices \(r, s, t, x, y, z\). Edges include \(r \to s\) (5), \(r \to t\) (3), \(s \to t\) (2), \(s \to x\) (6), \(t \to x\) (7), \(t \to y\) (4), \(t \to z\) (2), \(x \to y\) (-1), \(x \to z\) (1), \(y \to z\) (-2). Source is \(s\); \(r\) stays at \(\infty\) because it precedes \(s\) in topological order. Panels (a)-(g) relax vertices in topological order. Final distances from \(s\): \(s=0\), \(t=2\), \(x=6\), \(y=5\), \(z=3\). Note negative edges are fine here.

## Bellman-Ford-Moore [1956-57-58]

Solves SSSP with **negative weights allowed**, and detects negative cycles reachable from \(s\).

```
BELLMAN-FORD(G, w, s)
    INIT-SINGLE-SOURCE(G, s)
    for i = 1 to |G.V| - 1
        for each edge (u, v) in G.E
            RELAX(u, v, w)
    for each edge (u, v) in G.E
        if v.d > u.d + w(u, v)
            return FALSE
    return TRUE
```

**Running time:** \(O(nm)\) — the first loop runs \(n-1\) times over all \(m\) edges.

### Worked example (slide 15)

Vertices \(s, t, x, y, z\). Edges: \(s \to t\) (6), \(s \to y\) (7), \(t \to x\) (5), \(t \to y\) (8), \(t \to z\) (-4), \(x \to t\) (-2), \(y \to x\) (-3), \(y \to z\) (9), \(z \to x\) (7), \(z \to s\) (2). Relaxation order each pass:
`(t,x), (t,y), (t,z), (x,t), (y,x), (y,z), (z,x), (z,s), (s,t), (s,y)`.
Panels (a)-(e) show distances converging. Final distances from \(s\): \(s=0\), \(t=2\), \(x=4\), \(y=7\), \(z=-2\).

### Correctness

**Loop invariant:** after \(i\) iterations of the first for-loop, \(v.d = \delta(s,v)\) for all vertices \(v\) that have a shortest path using at most \(i\) edges. This follows directly from the path-relaxation lemma.

**Theorem:** if a negative cycle reachable from \(s\) exists, Bellman-Ford returns FALSE. Otherwise it returns TRUE, and \(v.d = \delta(s,v)\) for all \(v \in V\) when it stops.

**Proof, Case 1 (no negative cycle reachable from \(s\)):** Every vertex reachable from \(s\) has a simple shortest path, using at most \(n-1\) edges. By the invariant, \(v.d = \delta(s,v)\) for those vertices when the first loop ends. Vertices not reachable from \(s\) already satisfy it after init. So \(v.d = \delta(s,v)\) for all vertices. Once that holds, no Relax can change any \(v.d\), so the IF in the second loop never fires and the algorithm returns TRUE.

**Proof, Case 2 (a negative cycle \(C\) reachable from \(s\)):** First, any vertex reachable from \(s\) is reachable via a simple path (at most \(n\) vertices). By induction on \(i\): after \(i\) iterations of the first loop, the first \(i+1\) vertices on that simple path have finite \(d\). So all vertices on \(C\) have \(v.d < \infty\) when the loop ends.

Suppose Bellman-Ford does **not** return FALSE in Case 2. Then at termination, for the cycle \(C = v_1, \dots, v_k\) (with \(v_{k+1} = v_1\)):
\[ v_{i+1}.d \le v_i.d + w(v_i, v_{i+1}), \quad 1 \le i \le k. \]
Summing over the cycle:
\[ \sum_{i=1}^{k} v_i.d \le \sum_{i=1}^{k} v_i.d + \sum_{i=1}^{k} w(v_i, v_{i+1}). \]
Since all \(v_i.d < \infty\), the two distance sums are equal **and** finite, so they cancel:
\[ 0 \le \sum_{i=1}^{k} w(v_i, v_{i+1}), \]
contradicting that \(C\) is a negative cycle. So the algorithm must return FALSE. □

## All-pairs shortest paths

All-pairs shortest-path (APSP) problem: for all \(s \in V\), find \(\delta(s,v)\) (and a concrete path) for all \(v \in V\).

Options:
- Run Dijkstra from every source \(s\) (needs non-negative weights): \(O(nm \log n)\).
- Run Bellman-Ford-Moore from every source (handles negative weights): \(O(n^2 m)\).
- Floyd-Warshall: \(O(n^3)\). Handles negative weights.
- Johnson's algorithm: \(O(nm \log n)\). Handles negative weights.

## Floyd-Warshall's algorithm [1962]

Does **not** use Relax; based on dynamic programming.

Input: graph in adjacency-matrix form \(W\) with \(w_{ii} = 0\), \(w_{ij} = w(i,j)\) if \((i,j) \in E\), and \(w_{ij} = \infty\) otherwise.

Output (matrix form):
- \(D = (d_{ij})\), \(d_{ij} = \delta(v_i, v_j)\) = length of a shortest path from \(v_i\) to \(v_j\), \(\infty\) if none.
- \(\Pi = (\pi_{ij})\), \(\pi_{ij}\) = the last vertex before \(v_j\) on a shortest path from \(v_i\) to \(v_j\), NIL if none.

```
FLOYD-WARSHALL(W, n)
    D^(0) = W
    for k = 1 to n
        let D^(k) = (d_ij^(k)) be a new n x n matrix
        for i = 1 to n
            for j = 1 to n
                d_ij^(k) = min( d_ij^(k-1), d_ik^(k-1) + d_kj^(k-1) )
    return D^(n)
```
(Only the \(D\) matrix construction is shown; see the textbook for \(\Pi\).)

**Running time:** \(O(n^3)\). **Space:** \(O(n^2)\) — only the previous \(D^{(k)}\) matrix needs to be kept.

**Theorem:** when the algorithm stops, \(d_{ij}\) and \(\pi_{ij}\) in the last matrix are correct for all \(v_i, v_j \in V\) (if the graph has no negative cycle).

**Proof:** Invariant — \(D^{(k)}\) holds the length of the shortest path between \(v_i\) and \(v_j\) that passes only through the intermediate vertices \(v_1, v_2, \dots, v_k\) (besides the endpoints \(v_i, v_j\)). Shown by induction on \(k\).

## Johnson's algorithm [1977]

Steps:
- Run Bellman-Ford-Moore once on a slightly extended graph.
- From that, adjust edge weights so all become non-negative without essentially changing the shortest paths (see re-weighting lemma below).
- Run Dijkstra from every vertex.

**Running time:** \(O(nm \log n + nm) = O(nm \log n)\). Handles negative weights.

### Re-weighting

Assign each vertex \(v\) a number \(\phi(v)\). Define new weights:
\[ \tilde{w}(u,v) = w(u,v) + \phi(u) - \phi(v). \]

For a path \(v_1, v_2, \dots, v_k\), the sum telescopes:
\[ \sum_{i=1}^{k-1} \tilde{w}(v_i, v_{i+1}) = \sum_{i=1}^{k-1} \big( w(v_i,v_{i+1}) + \phi(v_i) - \phi(v_{i+1}) \big) = \sum_{i=1}^{k-1} w(v_i,v_{i+1}) + \big( \phi(v_1) - \phi(v_k) \big). \]

So path length under the new weights equals path length under the old, plus an additive correction \(\phi(v_1) - \phi(v_k)\) that depends only on the path's endpoints. The correction is the same for all paths from \(s = v_1\) to \(t = v_k\), so a shortest path from \(s\) to \(t\) is the same path under both \(w\) and \(\tilde{w}\).

Also: there is a negative cycle under \(w\) iff there is one under \(\tilde{w}\). For a cycle \(v_k = v_1\), so \(\phi(v_k) - \phi(v_1) = 0\) and the correction vanishes.

## A* [Hart, Nilsson, Raphael, 1968]

A* is a tuning of Dijkstra for the common case of searching for a path from \(s\) to one specific target \(t\).

New ingredient: for every vertex \(v\), make a guess \(h(v)\) of the shortest distance from \(v\) to \(t\), i.e. a guess at \(\delta(v,t)\). \(h\) is called a **heuristic**.

Intuition: if \(v.d = \delta(s,v)\) (as in Dijkstra when \(v\) is extracted), then \(v.d + h(v)\) is a guess at \(\delta(s,v) + \delta(v,t)\), the length of the shortest path from \(s\) to \(t\) through \(v\).

Idea: proceed exactly like Dijkstra (same update of \(v.d\) values), but use the priority-queue key \(v.d + h(v)\). This expands the search via vertices guessed to be on a shortest path from \(s\) to \(t\). By contrast, Dijkstra expands via vertices known to be nearest to \(s\).

### A* in practice (slide 26)

Grid-based graph: vertices are the white grid cells, edges of length one between neighbouring white cells. Heuristic \(h(v)\) = Euclidean (straight-line) distance from cell \(v\) to the target cell \(t\).
- Dijkstra (right figure): explores evenly in all directions.
- A* with this heuristic (left figure): explores more toward the target. Fewer vertices visited, so faster in practice.

### Correctness and worst-case running time

A heuristic is **consistent** if for all vertices \(v\) and all edges \((v,u)\) in \(v\)'s adjacency list:
\[ h(v) \le w(v,u) + h(u). \]
That is, the heuristic's guess for \(v\) does not contradict its guess for \(v\)'s neighbours.

With a consistent heuristic, A* is the same as Dijkstra on a graph with adjusted weights. From this you can prove correctness (A* returns the shortest path between \(s\) and \(t\)) and that A*'s worst-case running time equals Dijkstra's worst-case running time.
