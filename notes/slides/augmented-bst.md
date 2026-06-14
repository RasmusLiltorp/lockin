# Binary Search Trees with Extra Information in the Nodes (Augmented BSTs)

Source: `material/slides/allSlidesF26/SlidesWithNoPauses/augmentedBSTSlides.pdf`

The deck shows how to augment a balanced BST (specifically a red-black tree) by storing extra information in each node, and how that buys new operations. The running example stores subtree sizes, which gives order-statistic queries — rank of a key and key of a given rank — in O(log n). It then gives the general condition under which any such augmentation can be maintained during updates without breaking the O(log n) running time, plus the OS-RANK / OS-SELECT pseudocode and other augmentation examples (max, min, sum).

## Adding extra information to nodes

The concrete example: every node stores the size of its subtree — the number of nodes in the subtree rooted at that node.

The slide shows a red-black tree where each node is drawn with two fields: `key` on top, `size` below. Black nodes are filled, red nodes are grey (red-black coloring). The drawn tree:

- Root: key 26, size 20 (whole tree has 20 nodes).
- Left subtree root: 17 (size 12). Right subtree root: 41 (size 7).
- Under 17: left child 14 (size 7), right child 21 (size 4).
- Under 14: left 10 (size 4), right 16 (size 2).
- Under 10: left 7 (size 2), right 12 (size 1). Under 7: left child 3 (size 1).
- Under 16: left child 14 (size 1).
- Under 21 (size 4): left 19 (size 2), right 21 (size 1). Under 19: right child 20 (size 1).
- Under 41 (size 7): left 30 (size 5), right 47 (size 1).
- Under 30: left 28 (size 1), right 38 (size 3). Under 38: left 35 (size 1), right 39 (size 1).

So the tree holds 20 keys (note keys are not all distinct — 14 and 21 each appear twice).

## New functionality

With subtree sizes stored, you can do these in O(log n):

- Find the **rank** of a given key.
- Find the **key** that has a given rank.

Rank = the key's position in sorted order among the stored keys.

The slide's rank table for this tree:

| Key  | 3 | 7 | 10 | 12 | 14 | 14 | 16 | 17 | 19 | 20 | 21 | ... |
|------|---|---|----|----|----|----|----|----|----|----|----|-----|
| Rank | 1 | 2 | 3  | 4  | 5  | 6  | 7  | 8  | 9  | 10 | 11 | ... |

These are the **order-statistic** operations.

## Implementation: OS-RANK and OS-SELECT

Note from the slide: this textbook pseudocode assumes an explicit node object (with `size = 0`) is used to represent NIL (the leaves/sentinels). So `x.left.size` is always defined even when there is no real left child — it is 0.

### OS-SELECT(x, i): find the node with rank i in the subtree rooted at x

Idea: `r = x.left.size + 1` is the rank of `x` within its own subtree. If `i == r`, x is the answer. If `i < r`, the answer is in the left subtree with the same rank `i`. If `i > r`, the answer is in the right subtree, with rank reduced by `r` (we drop the left subtree and x itself).

```
OS-SELECT(x, i)
    r = x.left.size + 1
    if i == r
        return x
    elseif i < r
        return OS-SELECT(x.left, i)
    else return OS-SELECT(x.right, i - r)
```

Complexity: O(log n) on a balanced (red-black) tree — one recursive step per level, height is O(log n). Space O(log n) for recursion (or O(1) if rewritten as a loop).

### OS-RANK(T, x): find the rank of node x in the whole tree T

Idea: x's rank within its own subtree is `x.left.size + 1`. To get its rank in the whole tree, walk up to the root. Every time x's running node `y` is the right child of its parent, the parent and the parent's entire left subtree come before x in sorted order, so add `y.p.left.size + 1` to the rank.

```
OS-RANK(T, x)
    r = x.left.size + 1
    y = x
    while y != T.root
        if y == y.p.right
            r = r + y.p.left.size + 1
        y = y.p
    return r
```

Complexity: O(log n) — the while loop runs once per level from x up to the root, height O(log n). Space O(1).

Worked check against the table: take the node 14 that is the left child of 16 (the size-1 node). It is the second 14 in the table, so its rank should be 6.

- `r = x.left.size + 1 = 0 + 1 = 1`, `y = 14`.
- 14 is the left child of 16, so no add. `y = 16`.
- 16 is the right child of 14 (size 7), so add `16.p.left.size + 1 = 4 + 1 = 5` (the left child of that 14 is 10, size 4). Now `r = 6`. `y = 14` (size 7).
- That 14 is the left child of 17, no add. `y = 17`.
- 17 is the left child of 26 (the root), no add. `y = 26 = T.root`, stop.

Result `r = 6`, which matches the table.

## Maintaining the extra information under updates

Assumed property of the augmentation:

> If a node's two children's values k1 and k2 are already correct, then the node's own value k can be computed in O(1) time. A leaf's value can be computed in O(1) time.

For the size example: `k = 1 + k1 + k2` (a node's size is 1 plus the sizes of its two subtrees). A leaf computes in O(1) as well.

From this assumption, the values can be maintained during updates in a red-black tree without changing the O(log n) running time:

- **Nodes off the path** from the inserted/deleted node up to the root do not need their value changed — a bottom-up recomputation would give the same result for them, so they are untouched.
- **During rebalancing:** recompute the value for the affected nodes after every rotation and after every step upward. At the end, recompute along the path from the last rebalancing location up to the root.

### Rotation and the affected fields

The slide shows the standard rotation pair with sizes. The two nodes are 42 (x) and 93 (y), with three hanging subtrees of sizes 6, 4, 7.

- One configuration: x = 42 on top (size 19), right child y = 93 (size 12). x's left subtree has size 6; y has subtrees 4 and 7.
- Other configuration: y = 93 on top (size 19), left child x = 42 (size 11). x has subtrees 6 and 4; y's right subtree has size 7.

LEFT-ROTATE(T, x) goes from the first to the second; RIGHT-ROTATE(T, y) is the inverse. Either way the node that ends up on top gets size 19 and the one that moves down gets the smaller size. The point: a rotation only changes the subtree contents of the two rotated nodes, so only their sizes need recomputing, each in O(1).

## Other examples of augmentations

The maintenance scheme always works whenever the same property holds:

> If a node's two children's values k1 and k2 are already correct, the node's own value k can be computed in O(1). A leaf's value can be computed in O(1).

Assuming each element has, besides the search key, some associated numeric data, these all satisfy the property:

- **Maximum** of the data values in the subtree.
- **Minimum** of the data values in the subtree.
- **Sum** of the data values in the subtree.

With such information you can add more operations to the tree. Examples from the slide:

- Search for the element(s) with the maximal data value.
- Find the **average** of the data values in a node's subtree: `average = sum of data values / number of nodes` (which needs both the sum augmentation and the size augmentation).
