# Connected Components in Graphs

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/connectedComponentsSlides.pdf`

This deck defines connected components (CCs) for undirected graphs and strongly connected components (SCCs) for directed graphs, both built on equivalence relations over the vertex set. It shows how to find CCs with a single DFS/BFS using an outer loop in O(n + m), and presents the Kosaraju/Sharir two-pass DFS algorithm for SCCs, also in O(n + m). The bulk of the deck is the correctness proof of the SCC algorithm, including two lemmas and an induction over the second-pass DFS trees.

## Equivalence relations (recap)

A relation R on a set S is a subset of S × S. When (x, y) ∈ R we say x stands in relation to y, written x ∼ y; the relation itself is written "∼".

A relation is an **equivalence relation** if for all x, y, z ∈ S:

- x ∼ x (reflexive)
- x ∼ y ⇒ y ∼ x (symmetric)
- x ∼ y ∧ y ∼ z ⇒ x ∼ z (transitive)

An equivalence relation splits S into disjoint subsets. Each subset holds elements related to each other but not to elements outside it. Such a splitting is also called a **partition**.

## Equivalence relation on the vertices of an undirected graph

For an undirected graph and v, u ∈ V:

> v ∼ u ⇔ there is an (undirected) path between u and v

This is easily seen to be an equivalence relation, so it partitions the vertex set V. The slide shows a graph on vertices {1,2,3,4,5,6} with a partition of size three. Edges: 1–2, 1–5, 2–5, 3–6. So the three components are {1,2,5} (the triangle), {3,6}, and the isolated vertex {4}.

The blocks of the partition are the graph's **connected components (CCs)**.

### Finding the connected components

Use DFS or BFS with a **global outer loop**. Each call from the outer loop discovers exactly the vertices of one connected component.

Justification: from earlier theorems on `GenericGraphTraversal2/3(s)`, a single call discovers exactly the vertices reachable from s along a path of white vertices at the time of the call. Since at the start of an outer-loop call everything in the unvisited component is white, one call sweeps up exactly one component.

```
CC(G):
    for each vertex s in V:
        if s is white (unvisited):
            run DFS-Visit(s) / BFS(s)   # discovers exactly one CC
            label all discovered vertices with the current component id
```

**Time:** O(n + m) — the outer loop touches each vertex once, and the traversals together touch each vertex and edge once.

### Applications of finding CCs

- Is an electrical network connected, so current can reach everywhere?
- Find regions in images of a given color (the "magic wand" tool in Photoshop), image analysis.
- Social network analysis.

## Equivalence relation on the vertices of a directed graph

For a directed graph and v, u ∈ V:

> v ∼ u ⇔ there is a (directed) path from u to v AND there is a (directed) path from v to u

This is easily seen to be an equivalence relation, so it partitions V. The slide shows a directed graph whose partition has size four (vertices labeled a..h grouped into four blocks).

The blocks are the graph's **strongly connected components (SCCs)**.

### Applications of finding SCCs

- For a road network the number of SCCs should be one, otherwise "black holes" appear where vehicles get trapped.
- The ergodic theorem for Markov chains (a graph model for many stochastic processes, including Google's PageRank) has two conditions, one of which is that the number of SCCs in the graph is one.
- The problem 2-CNF-SAT can be solved in linear time via SCC algorithms. Many problems — e.g. in VLSI (computer chip) design, data clustering, and scheduling — can be modeled as instances of 2-CNF-SAT.

## SCC algorithm (Sharir 1981, Kosaraju)

**Problem:** partition the vertices of a directed graph G into its SCCs.

**Idea:** run DFS twice. The first pass records finishing times. The second pass runs DFS on the transpose G^T, processing vertices in order of decreasing finishing time. Each tree of the second-pass DFS forest is exactly one SCC.

```
SCC(G):
    call DFS(G) to compute finishing times u.f for all u
    compute G^T
    call DFS(G^T), but in the main loop consider vertices
        in order of decreasing u.f (as computed in the first DFS)
    output the vertices in each tree of the depth-first forest
        formed in the second DFS as a separate SCC
```

Here G^T is G with every edge reversed.

**Time:** O(n + m). Two DFS passes are each O(n + m), and building G^T is O(n + m). Sorting by u.f is not a comparison sort — the first DFS can push vertices onto a list at finishing time, giving the decreasing-finish order directly.

## Correctness of the SCC algorithm

**Theorem:** The SCC algorithm above is correct, i.e. the trees returned from the second DFS call represent exactly G's SCCs.

First observation:

> There is a path u ⇝ v in G ⇔ there is a path v ⇝ u in G^T

From this:

> u and v in the same SCC in G ⇔ u and v in the same SCC in G^T

So **G and G^T have the same SCCs.**

### f(C) and the two lemmas

For a vertex set C ⊆ V define f(C) = max over v ∈ C of v.f, where v.f is the finishing time from the **first** DFS in the SCC algorithm.

**Lemma 1:** If C, C′ are two distinct SCCs in G, and (x, y) is an edge in G with x ∈ C and y ∈ C′, then f(C) > f(C′).

**Lemma 2:** Since G^T is G with all edges reversed and the SCCs are the same in G^T and G, Lemma 1 reformulated for G^T reads: if C, C′ are two distinct SCCs in G^T and (x, y) is an edge in G^T with x ∈ C and y ∈ C′, then f(C) < f(C′).

(Lemma 2 is just Lemma 1 applied with edge directions flipped — an edge from C to C′ in G^T is an edge from C′ to C in G, so the inequality flips.)

### Proof of Lemma 1

Let u be the first vertex in C ∪ C′ to be discovered.

**Case 1: u ∈ C.** Then there is a path from u to every w ∈ C ∪ C′ (within C since u, w are in the same SCC; into C′ via the edge (x, y) since x ∈ C). By the white-path lemma all of C ∪ C′ becomes a descendant of u, so f(C) = u.f and in particular f(C) > f(C′). The claim follows.

**Case 2: u ∈ C′.** There is a path from u to every w ∈ C′, so by the white-path lemma f(C′) = u.f.

Now suppose some vertex v ∈ C had v.d < u.f. Since u.d < v.d (u was discovered first in C ∪ C′), the parenthesis structure of the d- and f-times forces u.d < v.d < v.f < u.f. So v and u are on the stack at the same time, with v above (pushed later). It is a DFS invariant that the graph contains a path between the stack vertices (from earlier-pushed to later-pushed), so there would be a path from u ∈ C′ to v ∈ C. Together with the edge (x, y) (which goes from C to C′) this would put all of C ∪ C′ into one SCC, contradicting that C and C′ are distinct SCCs.

Therefore v.d > u.f for all v ∈ C, hence f(C) > u.f = f(C′). □

### Main correctness proof (induction on k)

Claim to prove for all k:

> The vertices of the first k trees generated during the second DFS each form one SCC in G^T.

Since the SCCs of G and G^T are the same, and every vertex lies in some tree, this proves correctness.

Proof by induction on k.

**Induction step:** assume true for k, show for k + 1.

The (k+1)-th tree is generated by the (k+1)-th call to DFS-Visit in the for-loop of the outer DFS loop. Let u be the vertex called on. Lining the vertices up in for-loop order (by decreasing v.f value), the situation at the time of this call looks like this:

```
                          u
                          ↓
   V:    ●●●●●●●●●●●○○○○●●○○●●●○○      (black = already discovered, white = not yet)
   v.f:  (decreasing left to right)
   for-loop sweeps left → right
```

Black vertices are those discovered so far in this second DFS; white are undiscovered.

Let C be the SCC containing u, and let T be the tree generated by the call on u.

- By the induction hypothesis the black vertices are exactly k of the graph's SCCs. So every other SCC lies among the white vertices, and C is one of these (since u is white).
- At the start of the call there is a white path from u to every w ∈ C, so C ⊆ T by the earlier theorem on `GenericGraphTraversal2(s)`.
- Let C′ be an arbitrary white SCC different from C. By the for-loop order, u.f = f(C) > f(C′).
- If there were an edge in G^T from C to C′, Lemma 2 would give f(C) < f(C′), a contradiction. So no edge in G^T goes from C to C′.
- Since DFS-Visit does not visit the black vertices, it cannot leave C. Hence T ⊆ C.

Combining C ⊆ T and T ⊆ C gives T = C, proving the claim for k + 1.

**Base case (k = 1):** the same argument, only simpler — there are no black vertices and u is the first vertex in the order. □
