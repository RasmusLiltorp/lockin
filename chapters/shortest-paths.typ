#import "../lib.typ": *

== Korteste veje

Du har en orienteret, vægtet graf og en startknude $s$. Du vil finde vejen fra $s$ til hver anden knude hvor vægtene summer til mindst muligt. Den letteste vægt til $v$ kalder vi $delta(s,v)$.

#eq[$ delta(s,v) = "vægten af den letteste vej fra" s "til" v $]

Alle algoritmerne bygger på samme skridt: *relax*. Du gætter en afstand til hver knude og forbedrer gættet når du finder en kortere vej. Til eksamen skal du vælge den rigtige algoritme til en graf, køre en i hånden, eller sammenligne køretider for alle-par-afstande.

=== Sådan løser du den

To operationer bærer det hele. Sæt alle gæt til uendeligt og startknudens til nul. Slap så kanter af, én ad gangen.

#recipe(
  title: "Relax — det fælles skridt",
  [Initialisér: $v.d = infinity$ og $v.pi = "NIL"$ for alle knuder, derefter $s.d = 0$. Her er $v.d$ dit bedste afstandsgæt og $v.pi$ forgængeren på vejen.],
  [Relax kanten $(u,v)$: er vejen gennem $u$ kortere end gættet, så opdatér.],
  [Altså hvis:],
)

#eq[$ v.d > u.d + w(u,v) $]

så sætter du

#eq[$ v.d <- u.d + w(u,v), quad v.pi <- u $]

#note[Uanset hvilken relax-algoritme du kører: gættet er aldrig for lavt ($delta(s,v) <= v.d$), det kan kun falde, og når $v.d$ rammer $delta(s,v)$ ændres det aldrig igen.]

Algoritmerne adskiller sig kun ved rækkefølgen kanterne slappes af i, og den afhænger af grafen. Læs derfor grafen først.

#recipe(
  title: "Vælg algoritmen",
  [Vægtene: alle ens (enhedsvægte)? Alle ikke-negative? Eller nogle negative?],
  [Strukturen: er grafen en DAG (orienteret uden kredse), eller har den kredse?],
  [Match mod forudsætningerne:
    - *BFS* virker kun hvis alle vægte er ens.
    - *Dijkstra* kræver at alle vægte er $>= 0$.
    - *DAG-Shortest-Paths* kræver at grafen er en DAG. Vægtene må gerne være negative.
    - *Bellman-Ford* virker på enhver én-kilde-graf uden negativ kreds; negative vægte er fine.
    - *Floyd-Warshall* er til alle-par, tåler negative vægte, men ingen negativ kreds.],
  [Vælg hver algoritme hvis forudsætning er opfyldt. Til "et eller flere svar" kan flere være rigtige.],
)

#trap[Kruskal og Prim bygger et minimalt udspændende træ, ikke korteste veje. DFS alene gør det heller ikke. Klassiske distraktorer.]

#trap[En DAG med negative vægte: Dijkstra ude, Bellman-Ford og DAG-Shortest-Paths ok. Ikke-negative vægte med kredse: Dijkstra, Bellman-Ford og (ved enhedsvægte) BFS ok, men ikke DAG-Shortest-Paths.]

Dijkstra og Bellman-Ford skal du oftest køre i hånden. Dijkstra tager altid den nærmeste uafklarede knude først.

```
DIJKSTRA(G, w, s)              // alle vægte >= 0
  INIT-SINGLE-SOURCE(G, s); S = {}; Q = G.V
  while Q != {}
    u = EXTRACT-MIN(Q); S = S u {u}
    for each v in G.Adj[u]: RELAX(u, v, w)

BELLMAN-FORD(G, w, s)          // negative vægte ok, opdager neg. kreds
  INIT-SINGLE-SOURCE(G, s)
  for i = 1 to |V|-1:  for each edge (u,v): RELAX(u, v, w)
  for each edge (u,v):  if v.d > u.d + w(u,v):  return FALSE
  return TRUE
```

#recipe(
  title: "Kør Dijkstra i hånden",
  [Start med $s.d = 0$, resten $infinity$.],
  [Træk gentagne gange knuden med mindst $d$ ud af køen; ved uafgjort den alfabetisk mindste.],
  [Slap dens udkanter af og notér udtrækningsrækkefølgen. De færdige afstande kommer i stigende orden.],
)

Bellman-Ford slapper alle kanter af $|V| - 1$ gange og tjekker så en sidste gang om en kant stadig kan forbedres. Kan den det, findes en negativ kreds.

#note[Dijkstra med binært heap: $O((n + m) log n)$. Bellman-Ford: $O(n m)$.]

Til alle-par kører du enten en én-kilde-algoritme fra hver knude eller Floyd-Warshall direkte. Vinderen afhænger af grafens tæthed.

#eq[$ "Floyd-Warshall:" quad O(n^3) $]

Tæt graf ($m = Theta(n^2)$): $n$ kørsler af Dijkstra giver $O(n^3 log n)$, så Floyd-Warshall vinder. Tynd graf ($m = Theta(n)$): $n$ kørsler af Bellman-Ford giver $Theta(n^3)$, det samme som Floyd-Warshall.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Korteste veje: vælg algoritme til grafen],
  source: "MCQ juni 2015, Spm. 13",
  prompt: [Which of the following algorithms can be used to find shortest paths on this graph? (Et eller flere svar.) $G_1$ er orienteret med knuder $a,b,c,d,e$ og *alle vægte* #swap[$1$], og grafen *har kredse*: $b arrow.r a$, $a arrow.r d$, $a arrow.r e$, $b arrow.r e$, $e arrow.r d$, $c arrow.r b$, $c arrow.r e$, $c arrow.r d$.],
  options: (
    [Dijkstra],
    [Bellman-Ford],
    [DAG-Shortest-Paths],
    [Breadth-First-Search (BFS)],
    [Depth-First-Search (DFS)],
  ),
  answer: [(a), (b) og (d): Dijkstra, Bellman-Ford og BFS.],
  worked: [Vægtene er alle 1, altså ikke-negative og ens. Dijkstra kræver kun ikke-negative vægte: ok. Bellman-Ford kræver kun ingen negativ kreds: ok. BFS virker fordi vægtene er ens. Grafen har kredse, så DAG-Shortest-Paths fejler. DFS er ikke en korteste-vej-algoritme.],
)

#qcard(
  tag: [Korteste veje: vælg algoritme (DAG, negative vægte)],
  source: "MCQ juni 2015, Spm. 14",
  prompt: [Which of the following algorithms can be used to find shortest paths on this graph? (Et eller flere svar.) $G_2$ er orienteret med knuder $a,b,c,d,e$, *nogle vægte* #swap[$-1$], og grafen er en *DAG* (topologisk orden $c,b,a,e,d$): $b arrow.r a (1)$, $a arrow.r d (-1)$, $a arrow.r e (1)$, $b arrow.r e (-1)$, $e arrow.r d (1)$, $c arrow.r b (1)$, $c arrow.r e (-1)$, $c arrow.r d (1)$.],
  options: (
    [Dijkstra],
    [Bellman-Ford],
    [DAG-Shortest-Paths],
    [Breadth-First-Search (BFS)],
    [Depth-First-Search (DFS)],
  ),
  answer: [(b) og (c): Bellman-Ford og DAG-Shortest-Paths.],
  worked: [Negative vægte, så Dijkstra er ude. Den topologiske orden $c,b,a,e,d$ har ingen bagudkant: grafen er en DAG, og DAG-Shortest-Paths virker. Bellman-Ford tåler negative vægte uden negativ kreds: ok. BFS kræver ens vægte; DFS finder ikke korteste veje.],
)

#qcard(
  tag: [Dijkstra: udtrækningsrækkefølge i hånden],
  source: "MCQ juni 2017, Spm. 15",
  prompt: [Run Dijkstra's algorithm on graph $G_2$ below, starting at node #swap[$a$]. The first node extracted from the priority queue (via EXTRACT-MIN) during the run is node $a$. Which node is the #swap[sixth] one extracted? (Ved uafgjort: alfabetisk mindste navn.) Kanter: $a arrow.r b (1)$, $a arrow.r d (3)$, $d arrow.r g (1)$, $d arrow.r e (3)$, $g arrow.r h (3)$, $g arrow.r e (1)$, $h arrow.r i (1)$, $b arrow.r d (1)$, $b arrow.r e (3)$, $b arrow.r c (2)$, $e arrow.r h (1)$, $e arrow.r f (2)$, $c arrow.r e (1)$, $c arrow.r f (3)$, $f arrow.r h (2)$, $f arrow.r i (3)$.],
  options: (
    [Node $d$],
    [Node $e$],
    [Node $f$],
    [Node $g$],
    [Node $h$],
  ),
  answer: [(b): node $e$.],
  worked: [Udtrækningsrækkefølgen med færdige afstande: $a(0), b(1), d(2), c(3), g(3), e(4), h(5), f(6), i(6)$. $a$: relax $b=1, d=3$. $b$: relax $d arrow.r 2$, $c arrow.r 3$, $e arrow.r 4$. $d$ ($2 < 3$): relax $g arrow.r 3$. Nu er $c=3$ og $g=3$ uafgjort, så alfabetisk $c$ fjerde, $g$ femte. Sjette er $e = 4$.],
)

#qcard(
  tag: [Bellman-Ford: find alle afstande i hånden],
  source: "DM507 juni 2012, Opg. 4a",
  prompt: [Kør Bellman-Ford fra #swap[$a$] på den orienterede graf $G_1$ og angiv den endelige $v.d$ for alle knuder. Kanter: $a arrow.r e (8)$, $a arrow.r f (10)$, $a arrow.r b (17)$, $e arrow.r h (-4)$, $f arrow.r h (-10)$, $f arrow.r g (25)$, $g arrow.r h (-12)$, $g arrow.r c (-3)$, $b arrow.r g (-5)$, $c arrow.r b (19)$, $c arrow.r d (2)$, $d arrow.r e (6)$, $h arrow.r d (1)$.],
  answer: [
    #table(
      columns: 9, inset: 5pt, align: center, stroke: 0.4pt + hair,
      [$v$],[$a$],[$b$],[$c$],[$d$],[$e$],[$f$],[$g$],[$h$],
      [$v.d$],[0],[17],[9],[1],[7],[10],[12],[0],
    )
  ],
  worked: [Init $a.d = 0$, resten $infinity$, relax alle kanter $|V| - 1 = 7$ gange. Vejene der realiserer afstandene: $a arrow.r f arrow.r h$ giver $h = 0$; $a arrow.r b arrow.r g$ giver $g = 12$; $g arrow.r c$ giver $c = 9$; $h arrow.r d$ giver $d = 1$; $d arrow.r e$ giver $e = 7$. Ingen negativ kreds er nåelig fra $a$, så værdierne er endelige.],
)
