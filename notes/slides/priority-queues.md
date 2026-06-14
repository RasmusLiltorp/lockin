# Priority Queues (Prioritetskøer)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/pqSlides.pdf`

This deck defines the priority queue as an abstract data structure, separates the interface (level 1) from the implementation (level 2), and shows how to implement a max-priority queue using the heap from Heapsort. It gives the four core/extra operations (Extract-Max, Insert, Increase-Key, Build), the algorithms for Increase-Key and Insert with a worked example, and a comparison table of running times across three implementations (heap, unsorted list, sorted list).

## Data structures: the level-1 / level-2 distinction

A data structure = **data + operations on that data**.

**Data.**
- Normally structured as an **ID plus extra data**. The ID is also called a **key**.
- We usually do not mention the extra data. So elements are referred to just by their ID, but really are `(ID, data)` or `(ID, reference to data)`.
- The ID usually comes from an **ordered universe** (it has an ordering), e.g. `int`, `float`, `String`.

**Operations.**
- The properties of a data structure are exactly the operations it offers, plus their running times.
- The two goals are **flexibility** and **efficiency**, which are usually in conflict.

Think of a data structure as an API for accessing a collection of data, on two levels:
- **Level 1**: the operations offered. In C#/Java this is an `interface`.
- **Level 2**: a concrete implementation of those operations. In Python/C#/Java this is a `class` implementing the interface.

One set of operations (level 1) can have many different implementations (level 2), often with different running times. The course is a catalog of widely-applicable data structures (level 1) together with efficient implementations (level 2).

## Priority queue: level 1 (the interface)

**Data:** an element = a key (ID) from an ordered universe, plus optional extra data.

This is the **max-version** of a priority queue. Core operations:

- **`Q.Extract-Max()`** — returns the element with the largest key in `Q` (an arbitrary such element if several are tied for largest). The element is **removed** from `Q`.
- **`Q.Insert(e: element)`** — adds element `e` to `Q`.

**Sorting via a priority queue.** With just these two operations you can sort:

```
n × Insert        // put all n elements in
n × Extract-Max   // pull them out in decreasing key order
```

### Extra operations

- **`Q.Increase-Key(r: reference to an element in Q, k: key)`** — changes the key of the element referenced by `r` to `max{k, old key}`. So the key can only go up (or stay), never down.
- **`Q.Build(L: list of elements)`** — builds a priority queue containing the elements of list `L`.

### Trivial operations (every data structure has these)

- `Q.CreateNewEmpty()`, `Q.DestructEmpty()`, `Q.IsEmpty?()`.

These are not mentioned again.

## Implementation via heaps (level 2)

One possible level-2 implementation: reuse the **heap structure from Heapsort**. Two operations come for free from what we already built:

- **Extract-Max** — this is the work done in the second phase of Heapsort: remove the root, move the last leaf up to be the new root, then call **Heapify** (sift down). Running time **O(log n)**.
- **Build** — apply Heapify repeatedly **bottom-up**. Running time **O(n)** (the standard linear-time heap construction, not n × Insert).

What is still missing and must be added:
- **Insert**
- **Increase-Key**

**Implementation detail.** In C# and Java the array version of a heap needs a known maximum queue size. Alternatively the array can be replaced by an **extendible array** — `List` in C#, `ArrayList` in Java, or lists in Python. You can also implement the heap tree with pointers/references, as is done later for search trees.

## Increase-Key

**Problem:** raise the key of one element (referenced by `r`) and restore the heap order.

**Idea:**
1. Change the element's key.
2. Restore heap order by **sifting up**: as long as the element is stronger (larger key) than its parent, swap it with the parent.

```
Increase-Key(r, k):
    if k <= key[r]: return          // max{k, old} keeps old; nothing to do
    key[r] = k
    i = position of r in the heap
    while i is not the root and key[i] > key[parent(i)]:
        swap(i, parent(i))
        i = parent(i)
```

### Worked example: Increase-Key(i, 15)

Starting heap (the highlighted node `i` holds key 4, deep on the left):

```
              16
           /      \
         14        10
        /  \      /  \
       8    7    9    3
      / \
     2   4(=i)
```

Steps shown in the slide panels (a)–(d):
- **(a)** Node `i` currently has key 4.
- **(b)** Its key is increased to 15. Now 15 > its parent 8, so heap order is broken.
- **(c)** Swap 15 with parent 8. Now 15 sits where 8 was; 15 > its new parent 14, still broken.
- **(d)** Swap 15 with parent 14. Now 15's parent is the root 16, and 15 < 16, so we stop. Heap order is restored.

Final heap:

```
              16
           /      \
         15        10
        /  \      /  \
      14    7    9    3
      / \
     2   8
```

**Running time:** the number of swaps is at most the height of the tree, so **O(log n)**.

## Insert

**Problem:** add a new element while keeping both the heap shape and the heap order.

**Idea:**
1. Insert the new element **last** (last position in the array / last leaf). This keeps the **heap shape** (complete tree) correct.
2. Restore heap order exactly like in Increase-Key: as long as the element is larger than its parent, swap with the parent (sift up).

```
Insert(e):
    place e at the last array position (new last leaf)
    i = that position
    while i is not the root and key[i] > key[parent(i)]:
        swap(i, parent(i))
        i = parent(i)
```

**Running time:** at most the height of the tree, so **O(log n)**.

Insert and the sift-up half of Increase-Key are the same loop; the only difference is where the element starts (new last leaf for Insert, an existing position for Increase-Key).

## Comparing implementations (same level 1, different level 2)

Running times for a max-priority queue under three implementations:

| Operation     | Heap       | Unsorted list | Sorted list  |
|---------------|------------|---------------|--------------|
| Extract-Max   | O(log n)   | O(n)          | O(1)         |
| Build         | O(n)       | O(1)          | O(n log n)   |
| Increase-Key  | O(log n)   | O(1)          | O(n)         |
| Insert        | O(log n)   | O(1)          | O(n)         |

Reading the table:
- **Unsorted list:** Insert/Build/Increase-Key are trivial (just append or edit in place, O(1)), but Extract-Max must scan everything, O(n).
- **Sorted list:** Extract-Max is O(1) (largest is at the end), but keeping it sorted makes Insert/Increase-Key O(n) and Build O(n log n) (sorting).
- **Heap:** a balanced middle, everything O(log n) except Build which is O(n).

## Min-priority queues

The operation set above is for **max**-priority queues. **Min**-priority queues are made the same way with the operations

```
Extract-Min, Build, Decrease-Key, Insert
```

simply by reversing all inequalities between keys in the definitions and algorithms. (Note: the dual of Increase-Key is **Decrease-Key**, since for a min-queue the useful change is lowering a key.)
