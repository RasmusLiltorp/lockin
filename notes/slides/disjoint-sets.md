# Disjoint Sets

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/disjointSetsSlides.pdf`

The deck introduces the disjoint-sets (union-find) abstract data type: maintain a partition of a universe under merging, and answer which block an element belongs to. It walks through three implementations in order of speed: linked lists (naive and weighted), and forests of trees (plain, then with union by rank + path compression). Each implementation gets its operation costs and an aggregate cost for a sequence of operations.

## Partition (the underlying concept)

A partition (Danish: *disjunkt opdeling*) of a set \(S\) is a collection of non-empty subsets \(A_i\), \(i = 1, \dots, k\), that are pairwise disjoint and together cover \(S\):

- \(A_i \neq \emptyset\) for all \(i\)
- \(A_i \cap A_j = \emptyset\) for \(i \neq j\)
- \(A_1 \cup A_2 \cup \cdots \cup A_k = S\)

Example from the slide: \(\{a,b,e\}, \{f\}, \{c,d,g,h\}\) is a partition of \(\{a,b,c,d,e,f,g,h\}\).

## The Disjoint Sets data structure

A partition used as a data structure. Three operations turned out to be the ones that matter across many applications (some appear later in the course):

- **Find-Set(x)**: return (an ID for) the set containing \(x\).
- **Union(x, y)**: merge the set \(\{a,b,c,\dots,x\}\) and the set \(\{h,i,j,\dots,y\}\) into one set \(\{a,b,c,\dots,x,h,i,j,\dots,y\}\).
- **Make-Set(x)**: create \(\{x\}\) as a new set (\(x\) must not already be an element of any other set).

Key note on the ID: there is no requirement on what the ID of a set is. It just has to be the same for every \(x\) in the same set. That is enough to check whether two elements \(x\) and \(y\) lie in the same set — compare their Find-Set results.

Throughout, **\(n\)** = number of elements = number of Make-Set calls, and **\(m\)** = number of Find-Set calls.

## Implementation 1: linked lists

Each set is a linked list of its elements. The ID of the set is the first element in the list. Each node has a header-pointer back to the list header; the header stores `head` and `tail`.

Operations:

- **Find-Set(x)**: follow the header-pointer, return the first element of the list.
- **Make-Set(x)**: create a new list.
- **Union(x, y)**: splice the two lists together, keep one header, and update all the header-pointers in the *other* list.

The slide's figure shows two lists \(s_1 = (f, g, d)\) and \(s_2 = (c, h, e, b)\) in part (a), then in part (b) the result of the union as one list \(s_1 = (f, g, d, c, h, e, b)\), where every node in what was \(s_2\) now points back to \(s_1\)'s header.

### Costs (naive list version)

- Find-Set(x): \(O(1)\) — one header-pointer hop.
- Make-Set(x): \(O(1)\).
- Union(x, y): \(O(n)\) — you may have to rewrite up to \(n\) header-pointers.

**Naive analysis:** \(n\) Make-Set, up to \(n-1\) Union, and \(m\) Find-Set cost \(O(m + n^2)\).

The \(n^2\) comes from a bad sequence: repeatedly union a single-element list into the growing big list, rewriting the big list's pointers each time. \(1 + 2 + \cdots + (n-1) = O(n^2)\) pointer updates.

## Implementation 2: linked lists, weighted union

Same structure, but Union is smarter. The fix: on Union, keep the header of the **longest** list and rewrite the header-pointers of the **shortest** list.

- Find-Set(x): \(O(1)\).
- Make-Set(x): \(O(1)\).
- Union(x, y): still \(O(n)\) in the worst case for a single call.

### Why this is faster overall

A single node can only change its header-pointer \(\log n\) times. Each time a node's pointer is rewritten, it is because its list was the shorter one, so the merged set is at least twice the size of the set the node was in. Starting from size 1, after \(k\) doublings the set has size at least \(2^k\), and a set can hold at most \(n\) elements:

\[
1 \cdot 2^k \le n \iff k \le \log n
\]

So each node is touched at most \(\log n\) times across all unions.

**Better analysis:** \(n\) Make-Set, up to \(n-1\) Union, and \(m\) Find-Set cost \(O(m + n \log n)\).

## Implementation 3: forest of trees

Each set is a tree; elements sit in nodes; the **root** is the ID of the set. Each node points to its parent; the root points to itself (the slide draws a self-loop on the root).

- **Find-Set(x)**: walk to the root.
- **Make-Set(x)**: create a new (single-node) tree.
- **Union(x, y)**: make the root of one tree a child of the other tree's root.

The slide's figure: part (a) shows two trees, one rooted at \(c\) (with children \(h\) and \(e\); \(h\) has child \(b\)) and one rooted at \(f\) (chain \(f \leftarrow d \leftarrow g\)). Part (b) shows the union, where \(c\)'s tree becomes a child of \(f\): \(f\) now has children \(c\) and \(d\); \(c\) has children \(h\) and \(e\); \(h\) has child \(b\); \(d\) has child \(g\).

Without any balancing rule, trees can degenerate into long chains, so Find-Set can be slow (\(O(n)\) per call in the worst case). The next version fixes this.

## Implementation 4: forest, union by rank + path compression

Two improvements applied together.

### Union by rank

Add an integer **rank** to every root. Set to 0 for new trees (in Make-Set). Rank decides the parent–child choice in Union:

- The root with the larger rank gets the other root as its child.
- On a tie (equal ranks), make \(x\) a child of \(y\) and increment \(y\)'s rank by 1.

Rank is an upper bound on the height of the subtree at that node; keeping the shorter tree under the taller one keeps trees shallow.

### Path compression

During Find-Set(x), after finding the root, make every node passed on the way a direct child of the root.

The slide's example is Find-Set(a) on a degenerate chain. Part (a) before: \(f \leftarrow e \leftarrow d \leftarrow c \leftarrow b \leftarrow a\) (each node a chain toward root \(f\), with subtrees hanging off, drawn as triangles). Part (b) after: \(a, b, c, d, e\) all hang directly off the root \(f\) as direct children. The path got flattened in one shot.

### Complexity

Union by rank and path compression together give time **very close to \(O(m + n)\)**. More precisely:

\[
O(m \cdot \alpha(n) + n)
\]

where \(\alpha(n)\) is a very slowly growing function (the inverse Ackermann function). For all practical \(n\), \(\alpha(n)\) is a small constant.

The slide flags that \(\alpha(n)\) and the proof of this running time are in CLRS section 19.4, which is **not part of the syllabus** (covered in a later CS course).

### Pseudocode

The slide stresses the code is surprisingly simple.

```
Make-Set(x)
    x.p = x
    x.rank = 0

Union(x, y)
    Link(Find-Set(x), Find-Set(y))

Find-Set(x)
    if x != x.p
        x.p = Find-Set(x.p)      // path compression
    return x.p

Link(x, y)
    if x.rank > y.rank
        y.p = x
    else x.p = y
        // If equal ranks, choose y as parent and increment its rank.
        if x.rank == y.rank
            y.rank = y.rank + 1
```

Notes on the code:
- `x.p` is the parent pointer; a root satisfies `x.p == x`.
- Find-Set is recursive: it both finds the root and rewrites `x.p` to point straight at the root on the way back up — that is the path compression.
- Link assumes `x` and `y` are already roots (Union calls it with two Find-Set results). When `x.rank == y.rank`, the `else` branch sets `x.p = y` and then bumps `y.rank`.
