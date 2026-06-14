# Minimum Spanning Trees (MST)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/mstSlides.pdf`

The deck builds up minimum spanning trees from the definition of a tree, proves the cut theorem that justifies a generic greedy approach, and then derives Prim-Jarník and Kruskal as two concrete instances of that greedy scheme. The proof of correctness for both runs through the same loop invariant ("what we have built so far is part of some optimal solution") plus the cut theorem. The deck closes with running-time analysis for each algorithm.

## Trees (free / unrooted trees)

A free (unrooted) tree is an undirected graph \(G = (V, E)\) that is:
- **Connected**: there is a path between every pair of vertices (the number of connected components is one).
- **Acyclic**: there is no cycle of edges.

An undirected acyclic graph is a **forest** of trees. The slide shows three pictures: a tree, a forest, and a graph with a cycle (not a tree).

### Theorem B.2 — equivalent characterizations of a tree

For an undirected graph \(G = (V, E)\) with \(n = |V|\) vertices and \(m = |E|\) edges, the following are equivalent (if one holds, all hold):

1. \(G\) is a tree (connected and acyclic).
2. \(G\) is connected, but stops being connected if any edge is removed.
3. \(G\) is connected and \(m = n - 1\).
4. \(G\) is acyclic, but stops being acyclic if any edge is added.
5. \(G\) is acyclic and \(m = n - 1\).
6. Between every pair of vertices there is exactly one path.

Proof is not part of the syllabus (see appendix B.5). Appendix B.4 and B.5 are required reading for the basic graph definitions. The load-bearing fact reused everywhere below: **every tree has exactly \(n - 1\) edges.**

## Spanning tree and MST

A **spanning tree** of an undirected connected graph \(G = (V, E)\) is a subgraph \(T = (V, E')\) with \(E' \subseteq E\) that is a tree. The vertex set \(V\) is the same — from here on \(T\) is treated as just the edge set \(E'\). By Theorem B.2 every spanning tree has \(n - 1\) edges.

A **minimum spanning tree (MST)** of a weighted, undirected, connected graph \(G\) is a spanning tree with the smallest possible sum of edge weights (no spanning tree has a smaller sum).

**Motivation**: connect points in a supply network (electricity, oil, ...) as cheaply as possible. An edge in \(G\) is a possible connection; its weight is the cost of building that connection. This was the motivation for the first algorithm for the problem (Borůvka, 1926, Austria-Hungary, now the Czech Republic).

## Generic greedy algorithm for MST

The base idea is greedy: build the MST by choosing edges one at a time using a suitable rule.

Correctness goes through the usual greedy loop invariant: "what we have built so far is part of an optimal solution." Letting \(A \subseteq E\) be the set of edges chosen so far, the invariant is:

> **There exists an MST that contains \(A\).**

**Terminology**: an edge is **safe** for \(A\) if it can be added without breaking the invariant. At least one safe edge must exist whenever the invariant holds and \(|A| < n - 1\).

### Why the invariant gives correctness

- **Initialization**: every connected graph has at least one spanning tree (by Theorem B.2 point 2 — keep removing edges until the condition is reached), hence an MST. That MST contains the empty edge set \(\emptyset\), so the invariant holds at the start with \(A = \emptyset\).
- **Maintenance**: maintaining the invariant is exactly the statement that the chosen edge is safe.
- **Termination**: every (M)ST contains exactly \(n - 1\) edges. \(A\) grows by one edge per iteration, so the algorithm terminates, and at termination \(A\) is an MST. (\(A\) is contained in some MST and has the same number of edges as it, so \(A\) equals that MST.)

The open question the rest of the deck answers: how do we find a safe edge in a single step?

## Cuts

A **cut** is a subset \(S\) of the vertices, \(S \subseteq V\). It can be seen as a two-way split of the vertices into \(S\) and \(V - S\).

An **edge across the cut** is an edge in \(S \times (V - S)\) — one endpoint in \(S\), the other in \(V - S\).

## Cut theorem

**Theorem.** If
- there exists an MST that contains \(A\),
- \(S\) is a cut that \(A\) has no edges across, and
- \(e\) is a lightest edge among the edges across the cut,

then \(e\) is safe for \(A\) (there exists an MST that contains \(A \cup \{e\}\)).

### Proof

- There is an MST \(T\) that contains \(A\). We construct an MST \(T'\) that contains \(A \cup \{e\}\).
- Let \(e = (u, v)\) be a lightest edge across the cut \(S\).
- Since \(T\) is connected, there is a path in \(T\) between \(u\) and \(v\). On that path there is at least one edge \((x, y)\) across the cut \(S\).
- Let \(T'\) be \(T\) with \((x, y)\) replaced by \(e = (u, v)\).

Like \(T\), \(T'\) is still connected: in any path, \((x, y)\) can be replaced by the rest of the path from \(u\) to \(v\) together with edge \((u, v)\). \(T'\) has \(n\) vertices and \(n - 1\) edges, so by Theorem B.2 it is a tree. Its weight can only be lighter than \(T\) (because \(e\) is a lightest edge across the cut, so \(w(e) \le w(x,y)\)). Therefore \(T'\) is also an MST.

\(T'\) contains \(A \cup \{e\}\): the removed edge \((x, y)\) is not in \(A\), since \(A\) has no edges across the cut. So removing it did not touch \(A\), and we added \(e\).

The accompanying figure marks \(T\) as the shown edges, \(A\) as the bold edges, and the cut by vertex coloring.

## Using the cut theorem in MST algorithms

Invariant: there exists an MST containing the chosen edges \(A\). Look at the graph \(G' = (V, A)\) of chosen edges and its connected components.

- A new edge \((u, v)\) with **both endpoints in the same component** of \(G'\) would introduce a cycle and break the invariant. Such edges are never safe.
- A new edge \((u, v)\) with **endpoints in different components** \(C_1\) and \(C_2\) of \(G'\) is safe if it is a lightest edge leaving \(C_1\): apply the cut theorem with the cut \(S = C_1\). (\(A\) has no edge across this cut, since all of \(A\)'s edges stay inside components.)

Adding an edge whose endpoints lie in different components \(C_1\) and \(C_2\) merges \(C_1\) and \(C_2\) into one component of \(G'\).

## Prim-Jarník algorithm (Prim 1957, Jarník 1930)

**Problem**: find an MST of a weighted, connected, undirected graph.

**Idea**: pick an arbitrary start vertex \(r\). Repeatedly grow \(r\)'s connected component \(C\) in \(G' = (V, A)\) by adding the lightest edge that leaves \(C\) (the cut theorem applied to the cut \(S = C\) gives safety).

**Data**: each vertex \(v \in V - C\) stores information about its cheapest edge across the cut \(C\) in fields `v.key` and `v.π`. The set of chosen edges is \(A = \{(v, v.\pi) \mid v \in C - \{r\}\}\). The vertices in \(V - C\) are kept in a min-priority queue \(Q\) keyed by `v.key`.

```
PRIM(G, w, r)
    Q = ∅
    for each u in G.V
        u.key = ∞
        u.π = NIL
        INSERT(Q, u)
    DECREASE-KEY(Q, r, 0)          // r.key = 0
    while Q ≠ ∅
        u = EXTRACT-MIN(Q)
        for each v in G.Adj[u]
            if v ∈ Q and w(u, v) < v.key
                v.π = u
                DECREASE-KEY(Q, v, w(u, v))
```

`EXTRACT-MIN` pulls in the vertex closest to the current component; the inner loop updates each neighbor's best crossing edge. A vertex's `π` field, once it leaves \(Q\), names the tree edge that connected it.

**Correctness**: a concrete variant of the generic greedy algorithm; each `EXTRACT-MIN` adds a lightest edge across the cut \(C\), which is safe by the cut theorem.

**Running time**: \(n\) `INSERT`, \(n\) `EXTRACT-MIN`, and \(m\) `DECREASE-KEY` on a priority queue of size \(O(n)\). With a binary heap this is \(O(m \log n)\) in total, using \(m \ge n - 1\) because \(G\) is connected (so \(\log m = \Theta(\log n)\)).

The worked example (CLRS graph) shows the component around \(r\) growing one bold edge at a time across successive panels until it spans all vertices.

## Kruskal algorithm (1956)

**Problem**: find an MST of a weighted, connected, undirected graph.

**Idea**: try to add edges to \(A\) in global lightest-first order. From the cut-theorem recap:

1. An edge \((u, v)\) can never be added to \(A\) if \(u\) and \(v\) lie in the same component of \(G' = (V, A)\) (it would form a cycle).
2. If an edge between two different components is added to \(A\), those two components merge into one.

So sort all edges by weight and scan them lightest-first; add an edge whenever its two endpoints are in different components.

### Disjoint-set maintenance

The connected components of \(G' = (V, A)\) are maintained with a **disjoint-set** data structure on \(V\), using `MAKE-SET(x)`, `UNION(x, y)`, `FIND-SET(x)`.

```
KRUSKAL(G, w)
    A = ∅
    for each vertex v in G.V
        MAKE-SET(v)
    sort the edges of G.E into nondecreasing order by weight w
    for each (u, v) taken from the sorted list
        if FIND-SET(u) ≠ FIND-SET(v)
            A = A ∪ {(u, v)}
            UNION(u, v)
    return A
```

Two facts that follow from the component recap:
1. The disjoint-set structure maintains the connected components of \(G' = (V, A)\).
2. An edge examined by the IF-statement has both endpoints in the same component after the examination, whatever the test's outcome (if the test passed, the `UNION` merges them; if it failed, they were already together). Since components in \(G'\) only get merged as the algorithm runs, that edge stays intra-component for the rest of the run.

### Correctness

- When the algorithm adds an edge \((u, v)\) to \(A\), \(u\) and \(v\) lie in different components \(C_1\) and \(C_2\) of \(G'\) (from fact 1 plus the IF-test).
- Consider the cut given by \(u\)'s component \(C_1\). All lighter edges have already been examined and therefore have both endpoints in the same component of \(G'\) (fact 2). So \((u, v)\) is a lightest edge across this cut, and the cut theorem justifies adding it to \(A\).
- When the algorithm stops, all edges have been examined. By fact 2 every edge of the input graph \(G\) has both endpoints in the same component of \(G'\). Such edges cannot be added to \(A\) without making a cycle.
- So \(A\) is itself the MST (from the invariant) that contains \(A\), since no edge can be added. The algorithm is correct.

Exactly \(n - 1\) `UNION` operations are performed, since each adds one edge to \(A\) and an MST has \(n - 1\) edges.

### Running time

Work breakdown:
- Sort \(m\) edges.
- \(n\) `MAKE-SET`, \(n - 1\) `UNION`, \(m\) `FIND-SET`.

There is a disjoint-set data structure where \(n\) `MAKE-SET`, \(n - 1\) `UNION`, and \(m\) `FIND-SET` together take \(O(m + n \log n)\) time. Sorting \(m\) edges dominates, so the total running time of Kruskal is

\[ O(m \log m) \]

using \(m \ge n - 1\) because the input graph is connected. (Note \(\log m = \Theta(\log n)\), so this is also \(O(m \log n)\), and the sort cost \(O(m \log m)\) swamps the disjoint-set cost \(O(m + n \log n)\).)

The worked example (CLRS graph, edge weights from 1 to 14, vertices \(a\)–\(i\)) walks panels (a) through (n): each panel highlights the next edge taken from the sorted list with an arrow; light edges joining two different components become bold (added), and an edge whose endpoints are already in one component is skipped.
