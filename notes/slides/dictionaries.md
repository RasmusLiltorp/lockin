# Dictionaries

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/dictionarySlides.pdf` (41 slides, in Danish).

This deck defines the Dictionary abstract data type and covers two implementations: balanced binary search trees (red-black trees) giving O(log n) for all operations, and hashing giving O(1) for the three core operations (Search/Insert/Delete) unless you are unlucky. It walks through binary search trees (search, min/max, successor, insert, delete), proves the red-black height bound, and shows the rebalancing cases after insert and delete. The hashing part covers the universe/space problem, hash functions, collisions, chaining, open addressing, worst-case analysis, and universal hashing.

---

## Data structures (recap)

A data structure = data + the operations on it.

- Data: a key (nøgle) plus associated satellite data (the satellite data is usually left implicit in these slides).
- Operations: the properties of a data structure are exactly the operations it offers (the API for accessing the data) plus their running times. Different implementations of the same API can have different running times.

The course separates this into level 1 (catalog of data structures with wide use) and level 2 (efficient implementations of them).

Already seen: the Priority Queue, with operations Extract-Min(), Insert(key), Build(list of elements), Decrease-Key(key, reference to element).

---

## The Dictionary ADT

A Dictionary offers these operations:

- `Search(key)`: return the element with this key (or report that it is absent).
- `Insert(key)`: insert a new element with this key.
- `Delete(key)`: remove the element with this key.
- `Predecessor(key)`: find the element with the highest key < key.
- `Successor(key)`: find the element with the lowest key > key.
- `OrderedTraversal()`: print elements in sorted order.

The last three use the ordering of the keys.

- Only the first three supported → **unordered dictionary**.
- All six supported → **ordered dictionary**.

Assumption throughout these slides: **unique keys** (no duplicate elements).

Language equivalents:
- C#: interface `IDictionary`.
- Java: interface `Map`.
- Python: `dict`.

Level-2 implementations in this course:
- **Balanced binary search trees**: all operations (and more, by storing extra info in nodes) in O(log n).
- **Hashing**: the first three operations in O(1) unless you are unlucky.

In libraries: C# `SortedDictionary` (tree) and `Dictionary` (hash); Java `TreeMap` (tree) and `HashMap` (hash); Python `dict` is hashing (no balanced BST in the standard modules, but third-party ones exist).

---

## Binary search tree (BST)

A BST is:
- a binary tree,
- with nodes in **inorder**.

A binary tree with keys in every node satisfies inorder if for every node v:

    keys in v's left subtree ≤ key in v ≤ keys in v's right subtree

Example from slide 6: a tree with root 6, left child 5 (children 2 and 5), right child 7 (right child 8). Second example is a near-path-like tree: root 2, right child 5, then 7, with children 6 and 8, and 6 has left child 5.

### Node representation

Typical implementation: node objects with a reference to parent, reference to left subtree, reference to right subtree. Plus one tree object holding a reference to the root. (Programming languages call these references; the textbook calls them pointers.)

Java node class:

```java
class Node {
  int key;
  Node leftchild;
  Node rightchild;
  Node parent;
  // constructor
  // other methods
}
```

Python node class:

```python
class Node:
    def __init__(self):
        self.key = None
        self.leftchild = None
        self.rightchild = None
        self.parent = None
    # other methods
```

C# node class looks like the Java one.

### Inorder traversal

Because of the inorder definition, a BST holds its data in sorted order. More precisely, an inorder walk prints keys in sorted order.

```
INORDER-TREE-WALK(x)
  if x ≠ NIL
    INORDER-TREE-WALK(x.left)
    print key[x]
    INORDER-TREE-WALK(x.right)
```

Worked example tree (slide 9): root 15, left 6 (children 3 [with children 2,4] and 7 [with right child 13, which has left child 9]), right 18 (children 17 and 20). Inorder walk yields 2,3,4,6,7,9,13,15,17,18,20.

Running time: O(n), since O(1) work is done per node.

---

## Searching in a BST

```
TREE-SEARCH(x, k)
  if x == NIL or k == key[x]
    return x
  if k < key[x]
    return TREE-SEARCH(x.left, k)
  else return TREE-SEARCH(x.right, k)
```

Principle (gives correctness): if the searched element exists, it is in the subtree we have descended into.

### Tree-Maximum and Tree-Minimum

```
TREE-MAXIMUM(x)              TREE-MINIMUM(x)
  while x.right ≠ NIL          while x.left ≠ NIL
    x = x.right                  x = x.left
  return x                     return x
```

Principle: the searched element is in the subtree we have descended into.

### Tree-Successor

```
TREE-SUCCESSOR(x)
  if x.right ≠ NIL
    return TREE-MINIMUM(x.right)
  y = x.p
  while y ≠ NIL and x == y.right
    x = y
    y = y.p
  return y
```

Correctness: using inorder you can rule out most nodes from being x's successor. What remains is the minimum node in x's right subtree, and otherwise the first ancestor that has x in its left subtree.

---

## Insertion in a BST

- Search downward from the root: at each node v reached, continue down into the subtree (left/right) where the new element must go according to v's inorder requirement.
- When a leaf (NIL / empty subtree) is reached, replace it with the new node (which gets two empty subtrees).

Inorder stays satisfied: for nodes on the search path because of the search rule, and for all other nodes because they got no new descendants in their two subtrees.

---

## Deletion in a BST

Deleting node z:

- **Case 1: at least one child is NIL.** Remove z and that child; let the other child take z's place.
- **Case 2: neither child is NIL.** Then the successor node y of z is the minimum node in z's right subtree. Remove y (which is a Case 1 removal, since its left child is NIL) and put it in z's place.

Both cases leave the tree in inorder:
- Case 1: no nodes get new descendants in their subtrees.
- Case 2: y (and only y) gets new descendants in its two subtrees. But since y is z's successor, there are no keys in the tree between z's and y's keys, so the keys in y's new subtrees satisfy inorder relative to y, since they did relative to z.

Note: structurally in the tree, every deletion is a Case 1 deletion (Case 2 reduces to a Case 1 removal of the successor).

The textbook (slide 15) splits this into four pictures (a)-(d): (a) and (b) are Case 1 (one child NIL); (c) and (d) are written "(Case 2 →) Case 1", i.e. Case 2 that reduces to a Case 1 removal of the successor.

---

## Running time of BST operations

For all operations except the inorder walk: traverse a path from root to leaf. So **running time = O(height)**.

Height bound: a tree with height h cannot hold more nodes than the full tree of height h, which holds 2^(h+1) − 1 nodes (from the heaps slides).

So for a tree with n nodes and height h:

    n ≤ 2^(h+1) − 1   ⇔   log₂(n+1) − 1 ≤ h

So the best possible height is log₂ n (±1).

Question raised: can we keep the height near optimal — say O(log n) — under updates (insertions and deletions)?

---

## Balanced binary search trees

Keeping height O(log n) under updates needs **rebalancing** (restructuring the tree) after updates, since otherwise deep (path-like) trees can arise.

Maintaining O(log n) height was first achieved with **AVL trees [1961]**. Many later proposals. A proposal consists of:
- balance information in nodes,
- a structural requirement based on the balance information that guarantees O(log n) height,
- algorithms that restore the structure after an update.

This course uses **red-black trees**.

---

## Red-black trees

Balance information per node: **1 bit** (the red/black color).

Structural requirements:
1. Root and leaves are black.
2. Same number of black nodes on all root-to-leaf paths.
3. No two reds in a row on any root-to-leaf path.

Note: in red-black trees the term "leaf" refers to the NIL subtrees (which technically increases the height of a tree by one). The textbook shows the same tree in several representations (slide 19): with explicit NIL leaves, with a single shared sentinel T.nil, and without leaves drawn.

Example tree (slide 18): root 26 (black), with a subtree containing red nodes 17, 30, etc., reds like 10, 15, 35, 39, and so on, all satisfying the three requirements.

### Theorem: the requirements guarantee O(log n) height

Let the number of blacks on every root-to-leaf path be k (i.e. k−1 black internal nodes plus one black leaf).

- Then every root-to-leaf path has at least k−1 nodes (the blacks plus possibly some reds). So there are at least k−1 full layers of nodes in the tree.
- Therefore n ≥ 2⁰ + 2¹ + 2² + ... + 2^(k−2) = 2^(k−1) − 1.
- Hence log(n+1) ≥ k−1.
- Since there are no two reds in a row, the longest root-to-leaf path has at most 2(k−1) edges.
- So the height is at most 2(k−1) ≤ 2 log(n+1) = O(log n). ∎

---

## Insertion into a red-black tree

1. Insert a node into the tree.
2. Remove any imbalance (violation of the red-black structural requirements).

Recall insertion: a leaf (NIL) is replaced by a node with two leaves as children.

### What imbalance can arise?

The two new leaves must be black. We choose to color the newly inserted node **red**.

Possible violation now: **two red nodes in a row** on a root-leaf path, at exactly one spot in the tree.

Plan idea: if the problem cannot be solved immediately, push it upward in the tree until it can be (hopefully easy to finish if it reaches the root).

### Rotations

The basic restructuring is a **rotation** (α, β, γ are subtrees, possibly empty):

```
        y                         x
       / \      LEFT-ROTATE(T,x)  / \
      x   γ    <-------------->  α   y
     / \        RIGHT-ROTATE(T,y)   / \
    α   β                          β   γ
```

Central observation: **rotations cannot break inorder.** Only x and y could have inorder violated (every other node keeps the same elements in its subtrees before and after). But this does not happen, because the following holds both before and after a rotation:

    keys in α ≤ x ≤ keys in β ≤ y ≤ keys in γ

So we never have to worry about preserving inorder if we only restructure with rotations.

Rotation worked example (slide 24): LEFT-ROTATE at node 11/18 — node 18 (with left child 11) is rotated so 11 moves up; subtrees 9, 12, 14, 17, 19, 20, 22 redistribute but inorder is preserved.

### Plan for rebalancing after insertion

Push the red-red problem upward, using recolorings and restructurings (rotations).

Invariant maintained during the process:
- Two reds in a row on a root-leaf path at most one place in the tree.
- Apart from that, the red-black requirements hold.

Goal: in O(1) time, remove the problem or push it one step closer to the root. This gives rebalancing in O(height) = O(log n) time.

### Cases in rebalancing (after insertion)

Here z is the lowest node in the red-red problem. The uncle is the parent's sibling y.

- **Case I: red uncle of z.** Recolor (push the problem up). After recoloring, the violation may reappear higher up, so the problem moves toward the root. (One fewer black node on the path to the root in the formulation.)
- **Case II: black uncle of z.** Fix with rotation(s) and recoloring; this removes the problem (it does not propagate).

For each case: check that the invariant is maintained, and that the problem is removed or moved closer to the root. If z becomes equal to the root, it can simply be colored black (⇒ all paths get one more black).

---

## Deletion from a red-black tree

1. Delete a node from the tree.
2. Remove any imbalance (violation of the red-black requirements).

Recall deletion: structurally, exactly one node is always removed, the one whose single child is a leaf (NIL), and that leaf is removed too. (Slide 27 picture: node z with a NIL child and another child r; after deletion r takes z's place under q.)

### What imbalance can arise?

- **Removed node was red:** all red-black requirements still hold.
- **Removed node was black:** no longer the same number of blacks on all paths.

Very useful formulation (the "extra black" / doubly-black trick):

> Let the removed node's other child be **"painted" (sværtet)** and count as "one more" black than its color says when counting blacks on paths: painted black = 2 blacks, painted red = 1 black. Then the requirements hold, except for the existence of one painted node.

Plan idea: if the problem cannot be solved immediately, push the painted node upward in the tree until it can be solved (hopefully easy if it reaches the root).

### Rebalancing after deletion

Push the painted node upward, using recolorings and rotations (same rotation picture as before).

Invariant maintained:
- At most one node in the tree is painted.
- If the painting is counted, the red-black requirements hold.

Easy stopping cases:
- **Painted node is red** ⇒ remove the painting by coloring the node black.
- **Painted node is the root** ⇒ just remove the painting (⇒ all paths get one fewer black).

So it suffices to look at the case where the painted node is black.

Goal: in O(1) time, remove the problem or move it one step closer to the root. This gives rebalancing in O(height) = O(log n) time.

### Cases for a painted black node x with sibling w

1. **Red sibling.**
2. **Black sibling, and it has two black children.**
3. **Black sibling, and its nearer child is red, the farther one black.**
4. **Black sibling, and its farther child is red.**

The case diagram (slide 31) shows nodes A,B,C,D,E with subtrees α,β,γ,δ,ζ; the painted node is x. For each case: check the invariant is maintained, and check that in O(1) time the painting is removed or moved one step closer to the root.

---

## Hashing

Assumption: keys are **integers** up to a maximum bound u. (To hash other data types, elements are assigned a unique integer value — `GetHashCode()` in C#, `hashCode()` in Java, `hash()` in Python.)

So we have a universe of possible integer keys: U = {0, 1, 2, ..., u−1}.

A dictionary stores a subset K ⊆ U, e.g. K = {2, 3, 5, 8}.

Starting point (like Counting sort): use keys directly as indices into an array. This takes O(1) time for Search, Insert and Delete.

### Problem: space usage

The array size is u = |U|, while the number of stored elements n = |K| is often much smaller — wasted space.

Worked example: store 5 CPR numbers (Danish personal IDs), keys like 180781-2345, viewable as integers in U = {0, 1, ..., 10¹⁰ − 1}. Here u = 10¹⁰, n = 5. So at least 10¹⁰ bytes (> 8 GB RAM) are used to store 5 CPR numbers.

If keys are 32- or 64-bit integers, u = 2³² ≈ 10¹⁰ or u = 2⁶⁴ ≈ 10²⁰ — the same situation or much worse.

### Hash functions

Solution to the space problem: find a function h mapping keys from the large integer universe U to a smaller one:

    h : U → {0, 1, 2, ..., m−1}

m is the desired array size. Often m = O(n) is chosen, so the array uses no more space than the elements themselves.

Such a function is a **hash function**. Example:

    h(k) = k mod m

Concrete example with m = 41:

    h(12)     = 12 mod 41     = 12   (0 · 41 + 12 = 12)
    h(100)    = 100 mod 41    = 18   (2 · 41 + 18 = 100)
    h(479869) = 479869 mod 41 = 5    (11704 · 41 + 5 = 479869)

### Collisions

Hash functions fix the space problem but create another: two keys can hash to the same array index.

    h(479869) = 479869 mod 41 = 5    (11704 · 41 + 5 = 479869)
    h(46)     = 46 mod 41     = 5    (1 · 41 + 5 = 46)

This is a **collision**. When h maps U into a smaller set {0, ..., m−1}, there will always be keys k, k′ with h(k) = h(k′). Collisions cannot be avoided, so we need a way to handle them.

### Chaining

One simple solution: an array entry holds the start of a **linked list** of all inserted elements whose key hashes to that entry. This is **chaining**.

Cost: linked lists must be traversed during Search and Delete, so the time for those rises from Θ(1) to Θ(|list|). Insert is still O(1), since you can insert at the front of the list.

### Open addressing

An alternative to chaining: try to find an empty slot in the array itself.

- **Linear probing** (a.k.a. linear hashing): h(k, i) = (h₁(k) + i) mod m
- **Quadratic hashing**: h(k, i) = (h₁(k) + c₁·i + c₂·i²) mod m. *[Not in Cormen et al. 4th edition, dropped from the syllabus.]*
- **Double hashing**: h(k, i) = (h₁(k) + i·h₂(k)) mod m

Here h₁(k) and h₂(k) are two hash functions (called "auxiliary" in the book).

- Insert: try i = 0, 1, 2, ... until an empty slot is found.
- Search: try i = 0, 1, 2, ... until the element or an empty slot is found.

Remarks on open addressing:
- Implementing **Delete is more complicated**. A simple solution: leave deleted elements in place, mark them as deleted, and clean up occasionally by rebuilding the hash table (reinserting the remaining elements from scratch). For linear hashing there is a more direct method (Cormen et al. 4th ed. section 11.5.1, not syllabus).
- It is **necessary that n ≤ m** (all n elements live in the array). Preferably **n ≈ m/4** to avoid running times degenerating.
- The probed indices {h(k,0), h(k,1), ..., h(k,m−1)} should equal {0, 1, ..., m−1} for all k (so the whole array gets searched). This can be ensured, e.g., by choosing **m a prime**.

### Running time of hashing

We want a hash function h that spreads the keys of the concrete input well over {0, ..., m−1}, so there are few collisions. Good hash functions are often thought of as mapping keys to indices in a seemingly random way.

But for any given hash function you can always find at least |U|/m (i.e. u/m) keys that hash to the same array index. Often u/m > n, which makes the **worst-case time Θ(n)**.

In practice one usually just hopes this does not happen for the concrete input and the concrete choice of hash function. There are methods that guarantee it rarely happens — see universal hashing.

> In practice you can count on hashing supporting Search, Insert and Delete in **O(1)** time, unless you are very unlucky.

You can also lower the worst case to **O(log n)** by using balanced search trees instead of linked lists in chaining. Java does this when a linked list (bucket) gets large.

---

## Universal hashing (not syllabus)

Consider this family of hash functions:

    h(k) = ((a·k + b) mod p) mod m

where p is a fixed prime larger than |U|, and a, b are fixed but randomly chosen integers with 1 ≤ a ≤ p−1 and 0 ≤ b ≤ p−1.

One can prove (not syllabus) that this hash function is good in the following sense (called **universal hashing**):

> For any dataset, with a random choice of a and b we can expect so few collisions that Search, Insert and Delete take O(1) time.

Cormen et al. 4th ed. describes another family with the same property (formulas (11.2) and (11.5)) that uses fewer CPU steps and is a good choice if you implement hash tables yourself. (Or see Mikkel Thorup's notes on hashing.)

---

## Other uses of hash functions (not syllabus)

Hash functions have many uses beyond implementing unordered dictionaries:
- Fingerprints of files and documents.
- Digital signatures.
- Load balancing.
- Coordinated sampling.

Each use has its own specific requirements on the hash functions.
