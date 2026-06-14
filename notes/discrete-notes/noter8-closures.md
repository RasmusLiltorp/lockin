# Closures of Relations & Equivalence Relations (Lukninger og Ækvivalensrelationer)

Source: `material/discrete-maths/slides/Noter8.pdf` (Afsnit 9.4 "Lukninger" and Afsnit 9.5 "Ækvivalensrelationer").

These notes cover the three closures of a relation — reflexive ($r(R)$), symmetric ($s(R)$), transitive ($t(R)$) — plus the general definition of a closure with respect to a property $P$, why no antisymmetric closure exists, and the definitions of equivalence relations and equivalence classes. A closure adds the fewest pairs needed to give $R$ the wanted property.

---

## Afsnit 9.4: Closures (Lukninger)

All relations here are on a set $A$.

### Reflexive closure (refleksiv lukning)

For a relation $R$ on $A$, the reflexive closure is

$$r(R) = R \cup \{(a,a) \mid a \in A\}.$$

You get it by adding exactly the missing pairs so $R$ becomes reflexive — one loop $(a,a)$ for every element. The added set $\{(a,a) \mid a \in A\}$ is the diagonal $\Delta$.

**Example 1 — relation on $\{1,2,3,4\}$:**

$$R = \{(1,3),(2,2),(2,3),(3,1),(3,3)\}$$

$$r(R) = R \cup \{(1,1),(2,2),(3,3),(4,4)\}$$
$$= \{(1,1),(1,3),(2,2),(2,3),(3,1),(3,3),(4,4)\}$$

Note $(2,2)$ and $(3,3)$ were already in $R$; the new pairs are $(1,1)$ and $(4,4)$. The closure must add $(4,4)$ even though $4$ appears in no pair of $R$ — reflexivity requires a loop on every element of $A$.

**Example 2 — relation on $\mathbb{N}$:**

$$R_< = \{(a,b) \mid a < b\}$$

$$r(R_<) = R_< \cup \{(a,a) \mid a \in \mathbb{N}\} = \{(a,b) \in \mathbb{N}\times\mathbb{N} \mid a \le b\} = R_{\le}$$

The reflexive closure of "strictly less than" is "less than or equal."

### Symmetric closure (symmetrisk lukning)

For a relation $R$, the symmetric closure is

$$s(R) = R \cup \{(b,a) \mid (a,b) \in R\}.$$

Add the reverse $(b,a)$ of every pair $(a,b)$ already in $R$. The added set is the inverse relation $R^{-1}$.

**Examples:**

$$s(\{(1,3),(2,2),(2,3),(3,1)\}) = \{(1,3),(2,2),(2,3),(3,1),(3,2)\}$$

Here $(1,3)$ needs $(3,1)$ — already present. $(2,3)$ needs $(3,2)$ — added. $(3,1)$ needs $(1,3)$ — already present. $(2,2)$ is its own reverse. So only $(3,2)$ is new.

$$s(R_<) = R_< \cup R_> = R_{\ne}$$

(Union of "less than" and "greater than" is "not equal.")

$$s(R_{\le}) = R_{\le} \cup R_> = A \times A$$

(Every pair: if not $a \le b$ then $a > b$, and the reverse of $\le$ covers $\ge$, together all pairs.)

$$s(\text{"samme paritet"}) = \text{"samme paritet"}$$

"Same parity" (samme paritet) is already symmetric, so its symmetric closure is itself.

### General closure (Def. 9.4.1)

Let $R$ be a relation and $P$ a property (egenskab). The **closure of $R$ with respect to $P$** (lukningen af $R$ m.h.t. $P$), if it exists, is the set $C$ satisfying:

1. $C$ has property $P$.
2. $R \subseteq C$.
3. $C \subseteq S$ for every relation $S$ that satisfies (1) and (2).

In words: the closure of $R$ w.r.t. $P$ is the **minimal** relation that contains $R$ and has property $P$. Condition (3) is what makes it minimal — it sits inside every other relation that does the job.

### No antisymmetric closure (Antisymmetrisk lukning?)

An antisymmetric closure does not exist (unless the relation is already antisymmetric). You cannot make a non-antisymmetric relation antisymmetric by *adding* pairs — antisymmetry forbids having both $(a,b)$ and $(b,a)$ with $a \ne b$, and closures only add, never remove. So if $R$ has such a pair, no superset can be antisymmetric.

### Transitive closure (transitiv lukning)

**Motivating example:**

$$R = \{(1,2),(2,3),(3,4)\}$$

$$t(R) = \{(1,2),(2,3),(3,4)\} \cup \{(1,3),(2,4)\} \cup \{(1,4)\}$$
$$= \{(1,2),(1,3),(1,4),(2,3),(2,4),(3,4)\}$$

Build it in rounds: first the original edges, then 2-step connections $\{(1,3),(2,4)\}$, then the 3-step connection $\{(1,4)\}$. In the directed graph this is the chain $1 \to 2 \to 3 \to 4$ plus every shortcut edge connecting any two nodes reachable along the chain.

**Definition — transitive closure of $R$:**

$$t(R) = \{(a,b) \mid \exists\, x_1, x_2, \dots, x_n : x_1 = a \ \wedge\ x_n = b \ \wedge\ (x_1,x_2),(x_2,x_3),\dots,(x_{n-1},x_n) \in R\}.$$

In words: $(a,b) \in t(R)$ exactly when there is a **path** (sti) from $a$ to $b$ in the graph of $R$. Equivalently — if there is a path from $a$ to $b$ in the graph of $R$, then there is a (single) **edge** (kant) from $a$ to $b$ in the graph of $t(R)$.

**Graph example:** the slide draws a graph $R$ on $\{1,2,3,4\}$ and its $t(R)$ next to it. In $t(R)$ you add a direct edge for every path: if $a$ reaches $b$, draw $a \to b$. The drawn $t(R)$ has self-loops on some nodes — a self-loop $(a,a)$ shows up exactly when $a$ lies on a directed cycle (a path from $a$ back to $a$), since then $a$ reaches itself.

---

## Afsnit 9.5: Equivalence Relations (Ækvivalensrelationer)

### Def. 9.5.1 — equivalence relation (ækvivalensrelation)

A relation that is **reflexive, symmetric, and transitive** (refleksiv, symmetrisk og transitiv) is called an equivalence relation.

**Examples that are equivalence relations (✓):** $=$ (equality), "samme paritet" (same parity).

**Examples that are NOT (✗):** $\le$, $\mid$ (divides), $\ne$.

(Why they fail: $\le$ is not symmetric; $\mid$ is not symmetric; $\ne$ is not reflexive and not transitive.)

### Def. 9.5.2 — equivalent elements (ækvivalente)

If $R$ is an equivalence relation and $(a,b) \in R$, then $a$ and $b$ are called **equivalent** (ækvivalente).

For an equivalence relation $R$ the following are interchangeable:

$$(a,b) \in R \iff (b,a) \in R \ (\text{since } R \text{ is symmetric}) \iff a \text{ and } b \text{ are equivalent}.$$

### Def. 9.5.3 — equivalence class (ækvivalensklasse)

If $R$ is an equivalence relation on $A$ and $a \in A$, then the equivalence class of $a$ is

$$[a]_R = \{b \mid (a,b) \in R\} = \{b \mid (b,a) \in R\} \ (\text{since } R \text{ symmetric}) = \{b \mid a \text{ and } b \text{ are equivalent}\}.$$

**Example — same parity on $\mathbb{N}$:**

$$R = \{(a,b) \in \mathbb{N}\times\mathbb{N} \mid a \text{ and } b \text{ have the same parity (samme paritet)}\}$$

$$[0]_R = \{0,2,4,6,\dots\} \quad (\text{the even numbers})$$
$$[1]_R = \{1,3,5,7,\dots\} \quad (\text{the odd numbers})$$
$$[2]_R = \{0,2,4,6,\dots\} = [0]_R$$
$$[3]_R = [1]_R$$

There are only two distinct classes: $[0] = [2] = [4] = \dots$ (evens) and $[1] = [3] = [5] = \dots$ (odds). The slide draws this as a circle split in two halves — one side holding $\{0,2,4,\dots\}$, the other $\{1,3,5,\dots\}$ — showing every element lands in exactly one of the two classes.
