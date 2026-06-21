#import "../lib.typ": *

== Korteste veje (shortest paths) <th-sp-basics>

Du har en orienteret, vægtet graf (directed, weighted graph) og en startknude $s$. Du vil finde vejen fra $s$ til hver anden knude hvor vægtene summer til mindst muligt. Den letteste vægt til $v$ kalder vi $delta(s,v)$.

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

#note(title: [Relax-egenskaber])[Uanset hvilken relax-algoritme du kører: gættet er aldrig for lavt ($delta(s,v) <= v.d$), det kan kun falde, og når $v.d$ rammer $delta(s,v)$ ændres det aldrig igen.]

Algoritmerne adskiller sig kun ved rækkefølgen kanterne slappes af i, og den afhænger af grafen. Læs derfor grafen først.

#recipe(
  title: "Vælg algoritmen",
  [*Læs vægtene.* Er de alle ens (enhedsvægte)? Alle $>= 0$? Eller er nogle negative? Skriv det ned ét sted.],
  [*Læs strukturen.* Følg pilene: kan du komme tilbage til en knude du har forladt, er der en kreds (cycle). Ellers er grafen en DAG (directed acyclic graph) (orienteret uden kredse).],
  [*Slå hver algoritme op i kortene nedenfor* og kryds den af, hvis dens krav er opfyldt for netop din graf.],
  [Til "et eller flere svar" kan flere godt være rigtige på samme graf.],
)

Her er hvad hver algoritme gør, hvad den kræver, og hvorfor kravet er der. Den lille graf til venstre viser den slags graf, kravet handler om.

#let algcard(dia, name, body) = block(breakable: false, above: 12pt, below: 12pt)[
  #grid(
    columns: (2.6cm, 1fr), column-gutter: 12pt,
    align: (center + horizon, left + horizon),
    dia, [*#name* \ #body],
  )
]

#algcard(
  gdiag({
    gnode((0,0), "a", $a$); gnode((1.5,0.5), "b", $b$); gnode((1.5,-0.5), "c", $c$)
    gedge("a","b", w: $1$); gedge("a","c", w: $1$); gedge("b","c", w: $1$)
  }),
  [BFS (Breadth-First-Search)],
  [Går grafen igennem lag for lag ud fra kilden, så knuderne nås efter hvor få kanter der er hen til dem. *Krav:* alle vægte ens — reelt en uvægtet graf. *Hvorfor:* når hver kant koster det samme, er den korteste vej bare den med færrest kanter. Så snart vægtene varierer, holder det ikke.],
)

#metadata(none) <th-sp-dijkstra>
#algcard(
  gdiag({
    gnode((0,0), "a", $a$); gnode((1.5,0.5), "b", $b$); gnode((1.5,-0.5), "c", $c$)
    gedge("a","b", w: $4$); gedge("a","c", w: $2$); gedge("b","c", w: $3$)
  }),
  [Dijkstra],
  [Tager hele tiden den nærmeste uafklarede knude og slapper dens kanter af. *Krav:* alle vægte $>= 0$. *Hvorfor:* den regner en knude for færdig i samme øjeblik den trækkes ud af køen. En negativ kant (negative edge) kunne gøre en vej billigere bagefter, og så ville svaret være forkert. Derfor er negative vægte (negative weights) udelukket.],
)

#metadata(none) <th-sp-dag>
#algcard(
  gdiag({
    gnode((0,0), "a", $a$); gnode((1.1,0.55), "b", $b$); gnode((2.2,0), "c", $c$)
    gedge("a","b", w: $3$); gedge("b","c", w: $-2$); gedge("a","c", w: $4$)
  }),
  [DAG-Shortest-Paths],
  [Sorterer knuderne topologisk (topological sort) og slapper kanterne af i den orden, én gang hver. *Krav:* grafen skal være en DAG; negative vægte er fine. *Hvorfor:* i en DAG kan du stille knuderne på en række, hvor alle pile peger fremad. Tager du dem i den orden, er en knude færdig, før du bruger den. Har grafen en kreds, findes den orden ikke.],
)

#metadata(none) <th-sp-bellman-ford>
#algcard(
  gdiag({
    gnode((0,0), "a", $a$); gnode((1.5,0.5), "b", $b$); gnode((1.5,-0.5), "c", $c$)
    gedge("a","b", w: $-2$); gedge("b","c", w: $3$); gedge("c","a", w: $4$)
  }),
  [Bellman-Ford],
  [Slapper alle kanter af $|V| - 1$ gange og kører så en runde mere for at se efter forbedringer. *Krav:* ingen negativ kreds (negative cycle); negative kanter og almindelige kredse er fine. *Hvorfor:* det robuste valg, der stiller færrest krav. Den ekstra runde fanger en negativ kreds — kan en kant stadig forbedres, findes der en. Til gengæld er den langsommere end de andre.],
)

#algcard(
  gdiag({
    gnode((0,0), "a", $a$); gnode((1.4,0.5), "b", $b$); gnode((1.4,-0.5), "c", $c$)
    gedge("a","b", w: $3$); gedge("a","c", w: $2$); gedge("b","c", w: $1$)
  }),
  [Floyd-Warshall],
  [Finder korteste vej mellem hvert par knuder på én gang — alle-par, ikke én kilde. *Krav:* ingen negativ kreds; negative kanter er fine. *Hvornår:* når du skal bruge afstandene mellem alle par, ikke kun fra én startknude.],
)

#trap(title: [Negativ kreds — så findes der ingen korteste vej])[
  #grid(
    columns: (2.6cm, 1fr), column-gutter: 12pt, align: (center + horizon, left + horizon),
    gdiag({
      gnode((0,0), "a", $a$); gnode((1.5,0.5), "b", $b$); gnode((1.5,-0.5), "c", $c$)
      gedge("a","b", w: $1$); gedge("b","c", w: $-2$); gedge("c","a", w: $-1$)
    }),
    [Rundt i kredsen $a arrow.r b arrow.r c arrow.r a$ summer vægtene til $1 - 2 - 1 = -2$. Du kan løbe rundt igen og igen og trække prisen ned hver gang, så afstanden går mod $-infinity$. Derfor forbyder selv de algoritmer, der ellers tillader negative kanter (DAG-SP, Bellman-Ford, Floyd-Warshall), en negativ kreds. Bellman-Ford er den, der opdager den for dig.],
  )
]

#trap(title: [MST er ikke korteste vej])[Kruskal og Prim bygger et minimalt udspændende træ (minimum spanning tree), ikke korteste veje. DFS alene gør det heller ikke. Klassiske distraktorer.]

#trap(title: [Forudsætninger pr. graf])[En DAG med negative vægte: Dijkstra ude, Bellman-Ford og DAG-Shortest-Paths ok. Ikke-negative vægte med kredse: Dijkstra, Bellman-Ford og (ved enhedsvægte) BFS ok, men ikke DAG-Shortest-Paths.]

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

#metadata(none) <th-sp-runtimes>
#note(title: [Køretider — alle korteste-vej-algoritmer])[
  $n$ er antal knuder, $m$ antal kanter.

  #table(
    columns: 4,
    align: (left, left, left, left),
    stroke: none,
    inset: (x: 11pt, y: 6pt),
    table.header(
      [*Algoritme*], [*Køretid*], [*Vægte*], [*Krav*],
    ),
    table.hline(stroke: 0.4pt + hair),
    [BFS], [$O(n + m)$], [ens], [—],
    [DAG-Shortest-Paths], [$O(n + m)$], [alle, også negative], [DAG (ingen kreds)],
    [Dijkstra (binært heap)], [$O((n + m) log n)$], [$>= 0$], [ingen negative kanter],
    [Bellman-Ford], [$O(n m)$], [alle, også negative], [ingen negativ kreds],
    [Floyd-Warshall (alle-par)], [$O(n^3)$], [alle, også negative], [ingen negativ kreds],
  )

  BFS og DAG-SP er hurtigst ($O(n + m)$), men har de strammeste krav. Bellman-Ford er langsomst men mest fleksibel.
]

Til alle-par kører du enten en én-kilde-algoritme fra hver knude eller Floyd-Warshall direkte. Vinderen afhænger af grafens tæthed.

#eq[$ "Floyd-Warshall:" quad O(n^3) $]

Tæt graf (dense graph) ($m = Theta(n^2)$): $n$ kørsler af Dijkstra giver $O(n^3 log n)$, så Floyd-Warshall vinder. Tynd graf (sparse graph) ($m = Theta(n)$): $n$ kørsler af Bellman-Ford giver $Theta(n^3)$, det samme som Floyd-Warshall.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Korteste veje: vælg algoritme til grafen (Bellman-Ford)],
  source: "MCQ juni 2015, Spm. 13",
  theory: <th-sp-basics>,
  prompt: [Which of the following algorithms can be used to find shortest paths on this graph? (Et eller flere svar.) $G_1$ er orienteret med knuder $a,b,c,d,e$ og *alle vægte* #swap[$1$], og grafen *har kredse*: $b arrow.r a$, $a arrow.r d$, $a arrow.r e$, $b arrow.r e$, $e arrow.r d$, $c arrow.r b$, $c arrow.r e$, $c arrow.r d$.],
  options: (
    [Dijkstra],
    [Bellman-Ford],
    [DAG-Shortest-Paths],
    [Breadth-First-Search (BFS)],
    [Depth-First-Search (DFS)],
  ),
  answer: [(a), (b) og (d): Dijkstra, Bellman-Ford og BFS.],
  blueprint: [
    Det er en ren tjekliste-opgave. Du regner ikke noget — du læser grafen og krydser af.

    + *Læs vægtene.* Er de alle ens? Alle $>= 0$? Eller er nogle negative? Skriv det ned ét sted.
    + *Læs strukturen.* Følg pilene: kan du vende tilbage til en knude du har forladt, er der en kreds. Ellers er det en DAG.
    + *Kryds hver algoritme af mod sin forudsætning:*
      - BFS: kun hvis alle vægte er ens.
      - Dijkstra: kun hvis alle vægte $>= 0$.
      - DAG-Shortest-Paths: kun hvis grafen er en DAG.
      - Bellman-Ford: virker altid, så længe der ikke er en negativ kreds.
    + *DFS er aldrig svaret* her, og det samme gælder MST (Prim, Kruskal). De finder ikke korteste veje.
    + Marker hver algoritme hvor forudsætningen holder. Flere kan være rigtige.
  ],
  worked: [
    Denne graf: alle vægte er #swap[$1$], så de er ens og ikke-negative. Og der er mindst én kreds.

    - *Dijkstra* — vægte $>= 0$? Ja. #sym.arrow.r virker.
    - *Bellman-Ford* — negativ kreds? Nej. #sym.arrow.r virker.
    - *BFS* — alle vægte ens? Ja. #sym.arrow.r virker.
    - *DAG-Shortest-Paths* — er grafen en DAG? Nej, den har en kreds. #sym.arrow.r fejler.
    - *DFS* — en korteste-vej-algoritme? Nej. #sym.arrow.r fejler.

    Tilbage står Dijkstra, Bellman-Ford og BFS.
  ],
)

#qcard(
  tag: [Korteste veje: vælg algoritme (DAG-Shortest-Paths)],
  source: "MCQ juni 2015, Spm. 14",
  theory: <th-sp-basics>,
  prompt: [Which of the following algorithms can be used to find shortest paths on this graph? (Et eller flere svar.) $G_2$ er orienteret med knuder $a,b,c,d,e$, *nogle vægte* #swap[$-1$], og grafen er en *DAG* (topologisk orden $c,b,a,e,d$): $b arrow.r a (1)$, $a arrow.r d (-1)$, $a arrow.r e (1)$, $b arrow.r e (-1)$, $e arrow.r d (1)$, $c arrow.r b (1)$, $c arrow.r e (-1)$, $c arrow.r d (1)$.],
  options: (
    [Dijkstra],
    [Bellman-Ford],
    [DAG-Shortest-Paths],
    [Breadth-First-Search (BFS)],
    [Depth-First-Search (DFS)],
  ),
  answer: [(b) og (c): Bellman-Ford og DAG-Shortest-Paths.],
  blueprint: [
    Samme tjekliste som før, men her er det de negative vægte og DAG-strukturen der afgør det.

    + *Vægte:* er nogle negative? Så ryger Dijkstra og BFS med det samme.
    + *Struktur:* prøv at stille knuderne på en række så alle pile går fremad (en topologisk orden). Lykkes det, er grafen en DAG og har ingen kreds.
    + *Kryds af:*
      - Dijkstra: nej, hvis bare én vægt er negativ.
      - BFS: nej, hvis vægtene ikke er ens.
      - DAG-Shortest-Paths: ja, hvis grafen er en DAG (negative vægte er fine her).
      - Bellman-Ford: ja, så længe ingen negativ kreds — og en DAG har slet ingen kreds.
    + DFS er aldrig svaret.
  ],
  worked: [
    Vægtene: nogle er #swap[$-1$], altså negative. Strukturen: den topologiske orden $c, b, a, e, d$ findes (alle pile går fremad), så grafen er en DAG.

    - *Dijkstra* — kræver alle vægte $>= 0$. Her er nogle negative. #sym.arrow.r ude.
    - *BFS* — kræver ens vægte. Her er både $1$ og $-1$. #sym.arrow.r ude.
    - *DAG-Shortest-Paths* — kræver en DAG. Ja. #sym.arrow.r virker.
    - *Bellman-Ford* — kun ingen negativ kreds; en DAG har ingen. #sym.arrow.r virker.
    - *DFS* — finder ikke korteste veje. #sym.arrow.r ude.

    Svar: Bellman-Ford og DAG-Shortest-Paths.
  ],
)

#qcard(
  tag: [Korteste veje: vælg algoritme (DAG-Shortest-Paths)],
  source: "MCQ juni 2015, Spm. 15",
  theory: <th-sp-basics>,
  prompt: [Which of the following algorithms can be used to find shortest paths on this graph? $G_3$ er orienteret med knuder $a,b,c,d,e$ og *nogle vægte* #swap[$-1$], og grafen *har kredse* (er ikke en DAG): $b arrow.r a (1)$, $a arrow.r d (-1)$, $a arrow.r e (1)$, $b arrow.r e (-1)$, $e arrow.r d (1)$, $c arrow.r b (1)$, $c arrow.r e (-1)$, $c arrow.r d (1)$.],
  options: (
    [Dijkstra],
    [Bellman-Ford],
    [DAG-Shortest-Paths],
    [Breadth-First-Search (BFS)],
    [Depth-First-Search (DFS)],
  ),
  answer: [Mulighed (b): Bellman-Ford.],
  blueprint: [
    Med både negative vægte og en kreds bliver listen skåret helt ind til benet, og kun én algoritme står tilbage.

    + *Læs vægtene.* Er nogen negative? Så er Dijkstra og BFS ude med det samme.
    + *Læs strukturen.* Kan du gå rundt og tilbage til en knude du har forladt, er der en kreds, og så virker DAG-Shortest-Paths ikke.
    + *Kryds af:*
      - Dijkstra: nej, hvis bare én vægt er negativ.
      - BFS: nej, hvis vægtene ikke er ens.
      - DAG-Shortest-Paths: nej, hvis grafen har en kreds.
      - Bellman-Ford: ja, så længe ingen negativ kreds.
    + DFS er aldrig svaret.
  ],
  worked: [
    Vægtene: nogle er #swap[$-1$], altså negative. Strukturen: der er en kreds, så grafen er ikke en DAG.

    - *Dijkstra* — kræver alle vægte $>= 0$. Nogle er negative. #sym.arrow.r ude.
    - *BFS* — kræver ens vægte. Her er både $1$ og $-1$. #sym.arrow.r ude.
    - *DAG-Shortest-Paths* — kræver en DAG. Grafen har en kreds. #sym.arrow.r ude.
    - *Bellman-Ford* — kun ingen negativ kreds. #sym.arrow.r virker.
    - *DFS* — finder ikke korteste veje. #sym.arrow.r ude.

    Tilbage står kun Bellman-Ford.
  ],
)

#qcard(
  tag: [Korteste veje: vælg algoritme (DAG-Shortest-Paths)],
  source: "MCQ juni 2019, Spm. 19 (flere rigtige)",
  theory: <th-sp-basics>,
  prompt: [Which of the following algorithms can be used to find shortest paths on this graph? (Et eller flere svar.) $G_4$ er orienteret med *alle vægte positive* (#swap[$1$] og #swap[$2$]), og kanterne danner *en DAG* (ingen kreds).],
  options: (
    [Dijkstra],
    [Bellman-Ford],
    [DAG-Shortest-Paths],
    [Prim],
    [Breadth-First-Search (BFS)],
    [Depth-First-Search (DFS)],
  ),
  answer: [Mulighed (a), (b) og (c): Dijkstra, Bellman-Ford og DAG-Shortest-Paths.],
  blueprint: [
    En DAG med ikke-negative vægte er det milde tilfælde, hvor alle tre én-kilde-algoritmer passer på den.

    + *Læs vægtene.* Alle $>= 0$? Så er Dijkstra med.
    + *Læs strukturen.* Ingen kreds (en DAG)? Så er DAG-Shortest-Paths med.
    + *Kryds af:*
      - Dijkstra: ja, vægtene er ikke-negative.
      - Bellman-Ford: ja, ingen negativ kreds.
      - DAG-Shortest-Paths: ja, grafen er en DAG.
      - BFS: nej, vægtene er ikke ens ($1$ og $2$).
      - Prim: nej, det er MST, ikke korteste veje.
    + DFS er aldrig svaret.
  ],
  worked: [
    Vægtene er #swap[$1$] og #swap[$2$], altså positive og ikke ens. Strukturen er en DAG uden kreds.

    - *Dijkstra* — vægte $>= 0$? Ja. #sym.arrow.r virker.
    - *Bellman-Ford* — negativ kreds? Nej. #sym.arrow.r virker.
    - *DAG-Shortest-Paths* — en DAG? Ja. #sym.arrow.r virker.
    - *BFS* — ens vægte? Nej, $1$ og $2$. #sym.arrow.r ude.
    - *Prim* — korteste vej? Nej, det er MST. #sym.arrow.r ude.
    - *DFS* — korteste vej? Nej. #sym.arrow.r ude.

    Svar: Dijkstra, Bellman-Ford og DAG-Shortest-Paths.
  ],
)

#qcard(
  tag: [Korteste veje: vælg algoritme (DAG-Shortest-Paths)],
  source: "MCQ juni 2023, Spm. 19 (flere rigtige)",
  theory: <th-sp-basics>,
  prompt: [Which algorithms can find shortest paths on the graph below? (Et eller flere svar.) Knuder $a..g$ med *nogle vægte* #swap[$-1$], grafen er *en DAG* og *uden negativ kreds*: $a arrow.r g (1)$, $a arrow.r c (1)$, $a arrow.r b (1)$, $g arrow.r e (1)$, $g arrow.r c (1)$, $c arrow.r e (1)$, $b arrow.r c (1)$, $b arrow.r d (1)$, $f arrow.r e (-1)$, $f arrow.r c (-1)$, $d arrow.r c (-1)$, $f arrow.r d (-1)$.],
  options: (
    [Dijkstra],
    [Bellman-Ford],
    [DAG-Shortest-Paths],
    [Kruskal],
    [Breadth-First-Search (BFS)],
    [Depth-First-Search (DFS)],
    [Floyd-Warshall],
  ),
  answer: [Mulighed (b), (c) og (g): Bellman-Ford, DAG-Shortest-Paths og Floyd-Warshall.],
  blueprint: [
    Når listen rummer Floyd-Warshall, så husk at den også tæller med — den tillader negative kanter ligesom Bellman-Ford, så længe der ikke er en negativ kreds.

    + *Læs vægtene.* Er nogen negative? Så ryger Dijkstra og BFS.
    + *Læs strukturen.* En DAG uden negativ kreds.
    + *Kryds af:*
      - Dijkstra: nej, der er negative vægte.
      - BFS: nej, vægtene er ikke ens.
      - DAG-Shortest-Paths: ja, grafen er en DAG.
      - Bellman-Ford: ja, ingen negativ kreds.
      - Floyd-Warshall: ja, negative kanter er fine uden negativ kreds.
      - Kruskal: nej, det er MST.
    + DFS er aldrig svaret.
  ],
  worked: [
    Vægtene: nogle er #swap[$-1$], altså negative. Strukturen er en DAG uden negativ kreds.

    - *Dijkstra* — vægte $>= 0$? Nej. #sym.arrow.r ude.
    - *BFS* — ens vægte? Nej. #sym.arrow.r ude.
    - *DAG-Shortest-Paths* — en DAG? Ja. #sym.arrow.r virker.
    - *Bellman-Ford* — negativ kreds? Nej. #sym.arrow.r virker.
    - *Floyd-Warshall* — negativ kreds? Nej, negative kanter er fine. #sym.arrow.r virker.
    - *Kruskal* — korteste vej? Nej, MST. #sym.arrow.r ude.
    - *DFS* — korteste vej? Nej. #sym.arrow.r ude.

    Svar: Bellman-Ford, DAG-Shortest-Paths og Floyd-Warshall.
  ],
)

#qcard(
  tag: [Dijkstra: udtrækningsrækkefølge i hånden (Dijkstra)],
  source: "MCQ juni 2017, Spm. 15",
  theory: <th-sp-dijkstra>,
  prompt: [Run Dijkstra's algorithm on graph $G_2$ below, starting at node #swap[$a$]. The first node extracted from the priority queue (via EXTRACT-MIN) during the run is node $a$. Which node is the #swap[sixth] one extracted? (Ved uafgjort: alfabetisk mindste navn.) Kanter: $a arrow.r b (1)$, $a arrow.r d (3)$, $d arrow.r g (1)$, $d arrow.r e (3)$, $g arrow.r h (3)$, $g arrow.r e (1)$, $h arrow.r i (1)$, $b arrow.r d (1)$, $b arrow.r e (3)$, $b arrow.r c (2)$, $e arrow.r h (1)$, $e arrow.r f (2)$, $c arrow.r e (1)$, $c arrow.r f (3)$, $f arrow.r h (2)$, $f arrow.r i (3)$.],
  options: (
    [Node $d$],
    [Node $e$],
    [Node $f$],
    [Node $g$],
    [Node $h$],
  ),
  answer: [(b): node $e$.],
  blueprint: [
    Du fører en lille tabel med $d$-værdier og krydser knuder af, efterhånden som de trækkes ud. Køen er bare "hvem har lige nu det mindste $d$".

    + Sæt $d = 0$ for startknuden #swap[$a$] og $infinity$ for resten.
    + Træk knuden med mindst $d$ ud af køen. Står to lige, tag den alfabetisk mindste.
    + Skriv den udtrukne knude på din liste. Det er den næste i udtrækningsrækkefølgen, og dens $d$ er nu endelig.
    + Slap dens udkanter af: for hver kant $(u,v)$, hvis $u.d + w(u,v) < v.d$, så sæt $v.d$ ned.
    + Gentag til køen er tom. Tæl dig frem på listen til det nummer der spørges om (her den #swap[sjette]).
  ],
  worked: [
    Init: $a.d = 0$, resten $infinity$; alle $pi = "NIL"$. Køen $Q$ holder alle ni knuder. Hver runde trækker EXTRACT-MIN den uafklarede knude med mindst $d$ ud (ved uafgjort den alfabetisk mindste), og dens udkanter slappes af. Et felt skrives kun, når relax er skarp ($u.d + w < v.d$).

    Hele kørslen, med $d$- og $pi$-arrayet og køens indhold efter hvert udtræk:

    ```
    array-indeks:     a    b    c    d    e    f    g    h    i
    init  d  =        0    .    .    .    .    .    .    .    .      (. = uendelig)
          pi =        -    -    -    -    -    -    -    -    -

    EXTRACT a (d=0)   relax a->b: 0+1=1 < .  -> b.d=1, b.pi=a
                      relax a->d: 0+3=3 < .  -> d.d=3, d.pi=a
      d  =            0    1    .    3    .    .    .    .    .
      pi =            -    a    -    a    -    -    -    -    -
      Q  = { b:1, d:3, c:., e:., f:., g:., h:., i:. }

    EXTRACT b (d=1)   relax b->c: 1+2=3 < .  -> c.d=3, c.pi=b
                      relax b->d: 1+1=2 < 3  -> d.d=2, d.pi=b
                      relax b->e: 1+3=4 < .  -> e.d=4, e.pi=b
      d  =            0    1    3    2    4    .    .    .    .
      pi =            -    a    b    b    b    -    -    -    -
      Q  = { d:2, c:3, e:4, f:., g:., h:., i:. }

    EXTRACT d (d=2)   relax d->e: 2+3=5 !< 4 -> intet
                      relax d->g: 2+1=3 < .  -> g.d=3, g.pi=d
      d  =            0    1    3    2    4    .    3    .    .
      pi =            -    a    b    b    b    -    d    -    -
      Q  = { c:3, g:3, e:4, f:., h:., i:. }    (c og g uafgjort paa 3)

    EXTRACT c (d=3)   c foer g (alfabetisk).
                      relax c->e: 3+1=4 !< 4 -> intet
                      relax c->f: 3+3=6 < .  -> f.d=6, f.pi=c
      d  =            0    1    3    2    4    6    3    .    .
      pi =            -    a    b    b    b    c    d    -    -
      Q  = { g:3, e:4, f:6, h:., i:. }

    EXTRACT g (d=3)   relax g->e: 3+1=4 !< 4 -> intet
                      relax g->h: 3+3=6 < .  -> h.d=6, h.pi=g
      d  =            0    1    3    2    4    6    3    6    .
      pi =            -    a    b    b    b    c    d    g    -
      Q  = { e:4, f:6, h:6, i:. }

    EXTRACT e (d=4)   <-- sjette udtraek
      d  =            0    1    3    2    4    6    3    6    .
    ```

    Udtrækningsrækkefølgen bliver altså $a(0), b(1), d(2), c(3), g(3), e(4), dots$ Den #swap[sjette] knude ud af køen er $e$ med afstand $4$.

    Svar: node $e$.
  ],
)

#qcard(
  tag: [Dijkstra: udtrækningsrækkefølge i hånden (Dijkstra)],
  source: "MCQ juni 2021, Spm. 19",
  theory: <th-sp-dijkstra>,
  prompt: [Kør Dijkstra fra knude #swap[$a$]. Hvilken liste giver rækkefølgen, knuderne trækkes ud af prioritetskøen (priority queue) i? Orienterede kanter: $a arrow.r g (7)$, $a arrow.r c (2)$, $a arrow.r b (4)$, $g arrow.r e (6)$, $g arrow.r c (4)$, $c arrow.r e (8)$, $c arrow.r f (6)$, $c arrow.r b (1)$, $c arrow.r d (1)$, $f arrow.r e (1)$, $b arrow.r d (2)$, $d arrow.r f (4)$.],
  options: (
    [$a, b, c, d, g, f, e$],
    [$a, b, c, d, f, e, g$],
    [$a, b, g, c, d, e, f$],
    [$a, b, c, f, e, d, g$],
  ),
  answer: [Mulighed (b): $a, b, c, d, f, e, g$. (Se note i gennemregningen: kanterne som skrevet giver $a, c, b, d, f, g, e$ — antagelig en afskriftsfejl i kantvægtene.)],
  blueprint: [
    Du fører en lille tabel med $d$-værdier og krydser knuder af, efterhånden som de trækkes ud. Køen er bare "hvem har lige nu mindst $d$".

    + Sæt $d = 0$ for startknuden #swap[$a$] og $infinity$ for resten.
    + Træk knuden med mindst $d$ ud. Står flere lige, tag den alfabetisk mindste.
    + Skriv den udtrukne knude på listen; dens $d$ er nu endelig.
    + Slap dens udkanter af: for hver kant $(u,v)$, hvis $u.d + w(u,v) < v.d$, så sæt $v.d$ ned.
    + Gentag til køen er tom, og match rækkefølgen mod listerne.
  ],
  worked: [
    Init: $a.d = 0$, resten $infinity$, alle $pi = "NIL"$. Vi kører Dijkstra på kanterne præcis som de står i opgaven. Hver linje viser $d$- og $pi$-arrayet plus køen efter et udtræk; et felt skrives kun ved skarp relax.

    ```
    indeks:          a    b    c    d    e    f    g
    init  d =        0    .    .    .    .    .    .
          pi=        -    -    -    -    -    -    -

    EXTRACT a (0)    a->b 0+4=4, a->c 0+2=2, a->g 0+7=7
      d =            0    4    2    .    .    .    7
      pi=            -    a    a    -    -    -    a
      Q = {c:2, b:4, g:7}

    EXTRACT c (2)    c->b 2+1=3 < 4, c->d 2+1=3, c->e 2+8=10, c->f 2+6=8
      d =            0    3    2    3    10   8    7
      pi=            -    c    a    c    c    c    a
      Q = {b:3, d:3, g:7, f:8, e:10}   (b og d uafgjort paa 3)

    EXTRACT b (3)    b foer d (alfabetisk). b->d 3+2=5 !< 3 -> intet
      Q = {d:3, g:7, f:8, e:10}

    EXTRACT d (3)    d->f 3+4=7 < 8
      d =            0    3    2    3    10   7    7
      pi=            -    c    a    c    c    d    a
      Q = {f:7, g:7, e:10}   (f og g uafgjort paa 7)

    EXTRACT f (7)    f foer g (alfabetisk). f->e 7+1=8 < 10
      d =            0    3    2    3    8    7    7
      pi=            -    c    a    c    f    d    a
      Q = {g:7, e:8}

    EXTRACT g (7)    g->e 7+6=13 !< 8, g->c 7+4=11 !< 2 -> intet
      Q = {e:8}

    EXTRACT e (8)    koeen tom
    ```

    Med kanterne som skrevet bliver udtrækningsrækkefølgen $a, c, b, d, f, g, e$. Det matcher ingen af de fem lister — alle starter $a, b, dots$, hvilket kun kan ske, hvis $a arrow.r b$ var billigere end $a arrow.r c$. Det facit-rigtige svar er liste (b), $a, b, c, d, f, e, g$; afvigelsen skyldes en afskriftsfejl i kantvægtene i denne gengivelse af opgaven, ikke i metoden.

    Svar: liste (b), $a, b, c, d, f, e, g$.
  ],
)

#qcard(
  tag: [Dijkstra: længden af korteste vej (Dijkstra)],
  source: "MCQ juni 2017, Spm. 16",
  theory: <th-sp-dijkstra>,
  prompt: [Kør Dijkstra på $G_2$ med start i knude #swap[$a$]. Hvad er længden af en korteste vej fra #swap[$a$] til #swap[$i$]? Kanter: $a arrow.r d (3)$, $a arrow.r b (1)$, $b arrow.r d (1)$, $b arrow.r e (3)$, $b arrow.r c (2)$, $c arrow.r e (1)$, $c arrow.r f (3)$, $d arrow.r e (3)$, $d arrow.r g (1)$, $e arrow.r g (1)$, $e arrow.r h (1)$, $e arrow.r f (2)$, $f arrow.r h (1)$, $f arrow.r i (3)$, $g arrow.r h (3)$, $h arrow.r i (1)$.],
  options: (
    [$6$],
    [$7$],
    [$8$],
    [$9$],
    [$10$],
  ),
  answer: [Mulighed (a): $6$.],
  blueprint: [
    Samme håndkørsel som udtrækningsopgaven, men her aflæser du bare den endelige $d$ til målknuden.

    + Sæt $d = 0$ for startknuden #swap[$a$] og $infinity$ for resten.
    + Træk gentagne gange knuden med mindst $d$ ud og slap dens udkanter af.
    + Når køen er tom, er $v.d$ den korteste afstand. Aflæs #swap[$i.d$].
  ],
  worked: [
    Init: $a.d = 0$, resten $infinity$, alle $pi = "NIL"$. Vi kører Dijkstra helt til bunds og aflæser $i.d$. Hver linje viser $d$- og $pi$-arrayet samt køen efter et udtræk; et felt skrives kun ved skarp relax.

    ```
    indeks:          a    b    c    d    e    f    g    h    i
    init  d =        0    .    .    .    .    .    .    .    .
          pi=        -    -    -    -    -    -    -    -    -

    EXTRACT a (0)    a->b 0+1=1, a->d 0+3=3
      d =            0    1    .    3    .    .    .    .    .
      pi=            -    a    -    a    -    -    -    -    -
      Q = {b:1, d:3}

    EXTRACT b (1)    b->d 1+1=2 < 3, b->e 1+3=4, b->c 1+2=3
      d =            0    1    3    2    4    .    .    .    .
      pi=            -    a    b    b    b    -    -    -    -
      Q = {d:2, c:3, e:4}

    EXTRACT d (2)    d->e 2+3=5 !< 4, d->g 2+1=3
      d =            0    1    3    2    4    .    3    .    .
      pi=            -    a    b    b    b    -    d    -    -
      Q = {c:3, g:3, e:4}

    EXTRACT c (3)    c->e 3+1=4 !< 4, c->f 3+3=6
      d =            0    1    3    2    4    6    3    .    .
      pi=            -    a    b    b    b    c    d    -    -
      Q = {g:3, e:4, f:6}

    EXTRACT g (3)    g->e 3+1=4 !< 4, g->h 3+3=6
      d =            0    1    3    2    4    6    3    6    .
      pi=            -    a    b    b    b    c    d    g    -
      Q = {e:4, f:6, h:6}

    EXTRACT e (4)    e->g 4+1=5 !< 3, e->h 4+1=5 < 6, e->f 4+2=6 !< 6
      d =            0    1    3    2    4    6    3    5    .
      pi=            -    a    b    b    b    c    d    e    -
      Q = {h:5, f:6}

    EXTRACT h (5)    h->i 5+1=6
      d =            0    1    3    2    4    6    3    5    6
      pi=            -    a    b    b    b    c    d    e    h
      Q = {f:6, i:6}

    EXTRACT f (6)    f->h 6+2=8 !< 5, f->i 6+3=9 !< 6 -> intet
    EXTRACT i (6)    maalet naaet, koeen tom
    ```

    Korteste vej til $i$ aflæses i $pi$-arrayet baglæns: $i <- h <- e <- b <- a$, altså $a arrow.r b arrow.r e arrow.r h arrow.r i$ med vægt $1 + 3 + 1 + 1 = 6$. Det matcher $i.d = 6$.

    Svar: $6$.
  ],
)

#qcard(
  tag: [Dijkstra: antal relax der ændrer v.d (relax)],
  source: "MCQ juni 2021, Spm. 20",
  theory: <th-sp-dijkstra>,
  prompt: [Fortsæt Dijkstra fra knude #swap[$a$]. RELAX kører på hver kant præcis én gang (#swap[$12$] gange i alt). I hvor mange af dem ændres $v.d$? Kanter: $g arrow.r e (6)$, $a arrow.r g (7)$, $a arrow.r c (2)$, $g arrow.r c (4)$, $c arrow.r e (8)$, $e arrow.r f (1)$, $c arrow.r f (6)$, $a arrow.r b (4)$, $b arrow.r c (1)$, $c arrow.r d (1)$, $d arrow.r f (4)$, $b arrow.r d (2)$.],
  options: (
    [$7$],
    [$8$],
    [$9$],
    [$10$],
    [$11$],
    [$12$],
  ),
  answer: [Mulighed (a): $7$.],
  blueprint: [
    Tæl de relax-kald, hvor gættet faktisk falder. Hver knude (på nær startknuden) nås en første gang og giver én ændring; oveni kommer eventuelle senere forbedringer.

    + Kør Dijkstra: hver udtrukken knude slapper sine udkanter af én gang.
    + Tæl en ændring, hver gang $u.d + w(u,v) < v.d$ er skarp, så $v.d$ sættes ned.
    + Første gang en knude nås tæller med — det er $n - 1$ ændringer i bunden. Læg senere skarpe forbedringer til.
  ],
  worked: [
    Init: $a.d = 0$, resten $infinity$, alle $pi = "NIL"$. Hver udtrukken knude slapper sine udkanter af én gang — i alt #swap[$12$] relax-kald, da grafen har 12 kanter. Vi tæller hvert kald, hvor $u.d + w < v.d$ er skarp og $v.d$ derfor sættes ned.

    ```
    indeks:          a    b    c    d    e    f    g       relax-kald (* = aendrer v.d)
    init  d =        0    .    .    .    .    .    .
          pi=        -    -    -    -    -    -    -

    EXTRACT a (0)    a->b 0+4=4 < .  *  b.d=4 b.pi=a
                     a->c 0+2=2 < .  *  c.d=2 c.pi=a
                     a->g 0+7=7 < .  *  g.d=7 g.pi=a
      d =            0    4    2    .    .    .    7

    EXTRACT c (2)    c->d 2+1=3 < .  *  d.d=3 d.pi=c
                     c->e 2+8=10 < . *  e.d=10 e.pi=c
                     c->f 2+6=8 < .  *  f.d=8 f.pi=c
      d =            0    4    2    3    10   8    7

    EXTRACT d (3)    d->f 3+4=7 < 8  *  f.d=7 f.pi=d
      d =            0    4    2    3    10   7    7

    EXTRACT b (4)    b->c 4+1=5 !< 2     intet
                     b->d 4+2=6 !< 3     intet
      d =            0    4    2    3    10   7    7

    EXTRACT f (7)    f->e ... (kant e->f, ej udkant fra f i denne graf)
                     [f har ingen forbedrende udkant]    intet
      d =            0    4    2    3    10   7    7

    EXTRACT g (7)    g->e 7+6=13 !< 10   intet
                     g->c 7+4=11 !< 2    intet
      d =            0    4    2    3    10   7    7

    EXTRACT e (10)   e->f 10+1=11 !< 7   intet
      d =            0    4    2    3    10   7    7
    ```

    Kald med en stjerne, altså hvor $v.d$ faktisk falder: $a arrow.r b$, $a arrow.r c$, $a arrow.r g$, $c arrow.r d$, $c arrow.r e$, $c arrow.r f$ og $d arrow.r f$ — i alt $7$. De øvrige fem kald ($b arrow.r c$, $b arrow.r d$, $g arrow.r e$, $g arrow.r c$, $e arrow.r f$) forbedrer intet, fordi målknuden allerede har en lavere $d$.

    Svar: $7$.
  ],
)

#qcard(
  tag: [Bellman-Ford: find alle afstande i hånden (Bellman-Ford)],
  source: "DM507 juni 2012, Opg. 4a",
  theory: <th-sp-bellman-ford>,
  prompt: [Kør Bellman-Ford fra #swap[$a$] på den orienterede graf $G_1$ og angiv den endelige $v.d$ for alle knuder. Kanter: $a arrow.r e (8)$, $a arrow.r f (10)$, $a arrow.r b (17)$, $e arrow.r h (-4)$, $f arrow.r h (-10)$, $f arrow.r g (25)$, $g arrow.r h (-12)$, $g arrow.r c (-3)$, $b arrow.r g (-5)$, $c arrow.r b (19)$, $c arrow.r d (2)$, $d arrow.r e (6)$, $h arrow.r d (1)$.],
  answer: [
    #table(
      columns: 9, inset: 5pt, align: center, stroke: 0.4pt + hair,
      [$v$],[$a$],[$b$],[$c$],[$d$],[$e$],[$f$],[$g$],[$h$],
      [$v.d$],[0],[17],[9],[1],[7],[10],[12],[0],
    )
  ],
  blueprint: [
    Du behøver ikke spore relax-rækkefølgen kant for kant. Bellman-Ford garanterer at $v.d$ til sidst er vægten af den letteste vej, så du kan bare finde den letteste vej til hver knude i hånden.

    + Sæt $d = 0$ for startknuden #swap[$a$] og $infinity$ for resten.
    + Hvis du følger pseudokoden: slap alle kanter af $|V| - 1$ gange. Hver runde tager dig ét kant-hop længere ud.
    + Genvejen i hånden: for hver knude, find den billigste sti fra startknuden og læg vægtene sammen. Husk at negative kanter kan gøre en omvej billigere end den direkte kant.
    + Skriv afstandene ind i tabellen.
    + Tjek til sidst for negativ kreds: kan en kant $(u,v)$ stadig forbedres, altså $u.d + w(u,v) < v.d$, så findes der en negativ kreds, og svaret er FALSE.
  ],
  worked: [
    Init: $a.d = 0$, resten $infinity$, alle $pi = "NIL"$. Bellman-Ford slapper *alle* kanter af i hver af de $|V| - 1 = 7$ runder. Vi tager kanterne i den rækkefølge, de står i opgaven: $a e, a f, a b, e h, f h, f g, g h, g c, b g, c b, c d, d e, h d$. Et felt skrives kun ved skarp relax. Her er $d$-arrayet (og de ændrede $pi$) efter hver runde:

    ```
    indeks:          a    b    c    d    e    f    g    h        (. = uendelig)
    init  d =        0    .    .    .    .    .    .    .
          pi=        -    -    -    -    -    -    -    -

    Runde 1: slap a e,a f,a b,e h,f h,f g,g h,g c,b g,c b,c d,d e,h d
      a->e 0+8=8     a->f 0+10=10   a->b 0+17=17
      e->h 8-4=4     f->h 10-10=0 (<4)   f->g 10+25=35
      g->h 35-12=23 (!<0)   g->c 35-3=32   b->g 17-5=12 (<35)
      c->b 32+19=51 (!<17)  c->d 32+2=34   d->e ... (d=34) 34+6=40 (!<8)
      h->d 0+1=1 (<34)
      d =            0    17   32   1    8    10   12   0
      pi=            -    a    g    h    e    a    b    f

    Runde 2: samme kantrunde igen
      g->c 12-3=9 (<32)     c->b 9+19=28 (!<17)   c->d 9+2=11 (!<1)
      d->e 1+6=7 (<8)       (h->d 0+1=1, uaendret)
      d =            0    17   9    1    7    10   12   0
      pi=            -    a    g    h    d    a    b    f

    Runde 3: ingen kant er skarp laengere -> ingen aendring
      d =            0    17   9    1    7    10   12   0
    ```

    Runde 4–7 ændrer heller intet (fixpunkt nået). De endelige veje, aflæst i $pi$ baglæns:

    - $h = 0$ via $a arrow.r f arrow.r h$: $10 + (-10) = 0$. (Slår $a arrow.r e arrow.r h = 8 + (-4) = 4$.)
    - $g = 12$ via $a arrow.r b arrow.r g$: $17 + (-5) = 12$.
    - $c = 9$ via $a arrow.r b arrow.r g arrow.r c$: $12 + (-3) = 9$.
    - $d = 1$ via $a arrow.r f arrow.r h arrow.r d$: $0 + 1 = 1$.
    - $e = 7$ via $dots arrow.r d arrow.r e$: $1 + 6 = 7$.
    - $b = 17$ via den direkte $a arrow.r b$. Omvejen $c arrow.r b$ giver $9 + 19 = 28$ og taber.
    - $f = 10$ via den direkte $a arrow.r f$.

    Negativ-kreds-tjek: en ekstra runde gør ingen kant skarp, så ingen negativ kreds er nåelig fra $a$. Værdierne står fast som i tabellen.
  ],
)

#qcard(
  tag: [Korteste veje: køretid ved given m (Dijkstra)],
  source: "MCQ juni 2015, Spm. 16",
  theory: <th-sp-runtimes>,
  prompt: [På grafer med $n$ knuder og $m = #swap[$n log n$]$ kanter, hvad er den asymptotiske køretid som funktion af $n$ for #swap[Dijkstra] (med prioritetskøen som et binært heap (binary heap))?],
  options: (
    [$O(n)$],
    [$O(n log n)$],
    [$O(n (log n)^2)$],
    [$O(n^2)$],
    [$O(n^2 log n)$],
    [$O(n^2 (log n)^2)$],
  ),
  answer: [Mulighed (c): $O(n (log n)^2)$.],
  blueprint: [
    Det er ren formel-genkald plus indsættelse. Slå algoritmens køretid op, sæt det givne $m$ ind, og forenkl.

    + *Slå køretiden op.* For #swap[Dijkstra med binært heap] er den $O((n + m) log n)$.
    + *Indsæt $m$.* Sæt #swap[$m = n log n$] ind.
    + *Forenkl.* Behold kun det dominerende led, og match med menuen.
  ],
  worked: [
    Dijkstra med binært heap: $O((n + m) log n)$. Indsæt $m = #swap[$n log n$]$:

    #eq[$ O((n + n log n) log n) = O(n log n dot log n) = O(n (log n)^2). $]

    Svar: $O(n (log n)^2)$.
  ],
)

#qcard(
  tag: [Korteste veje: køretid ved given m (Dijkstra)],
  source: "MCQ juni 2015, Spm. 17",
  theory: <th-sp-runtimes>,
  prompt: [På grafer med $n$ knuder og $m = #swap[$n log n$]$ kanter, hvad er den asymptotiske køretid som funktion af $n$ for #swap[Bellman-Ford]?],
  options: (
    [$O(n)$],
    [$O(n log n)$],
    [$O(n (log n)^2)$],
    [$O(n^2)$],
    [$O(n^2 log n)$],
    [$O(n^2 (log n)^2)$],
  ),
  answer: [Mulighed (e): $O(n^2 log n)$.],
  blueprint: [
    Samme opskrift: slå køretiden op, sæt $m$ ind, forenkl.

    + *Slå køretiden op.* #swap[Bellman-Ford] kører i $O(n m)$.
    + *Indsæt $m$.* Sæt #swap[$m = n log n$] ind.
    + *Forenkl* og match med menuen.
  ],
  worked: [
    Bellman-Ford: $O(n m)$. Indsæt $m = #swap[$n log n$]$:

    #eq[$ O(n dot n log n) = O(n^2 log n). $]

    Svar: $O(n^2 log n)$.
  ],
)

#qcard(
  tag: [Korteste veje: køretid ved given m (Dijkstra)],
  source: "MCQ juni 2015, Spm. 18",
  theory: <th-sp-runtimes>,
  prompt: [På grafer med $n$ knuder og $m = #swap[$n log n$]$ kanter, hvad er den asymptotiske køretid som funktion af $n$ for #swap[DAG-Shortest-Paths]?],
  options: (
    [$O(n)$],
    [$O(n log n)$],
    [$O(n (log n)^2)$],
    [$O(n^2)$],
    [$O(n^2 log n)$],
    [$O(n^2 (log n)^2)$],
  ),
  answer: [Mulighed (b): $O(n log n)$.],
  blueprint: [
    Samme opskrift igen.

    + *Slå køretiden op.* #swap[DAG-Shortest-Paths] er topologisk sortering plus ét relax-gennemløb over alle kanter, i alt $Theta(n + m)$.
    + *Indsæt $m$.* Sæt #swap[$m = n log n$] ind.
    + *Forenkl* og match med menuen.
  ],
  worked: [
    DAG-Shortest-Paths: $Theta(n + m)$. Indsæt $m = #swap[$n log n$]$:

    #eq[$ Theta(n + n log n) = Theta(n log n). $]

    Leddet $n log n$ dominerer $n$.

    Svar: $O(n log n)$.
  ],
)

#qcard(
  tag: [Alle-par: hurtigste metode (Floyd-Warshall)],
  source: "MCQ juni 2017, Spm. 17",
  theory: <th-sp-runtimes>,
  prompt: [På grafer med $n$ knuder og $m = #swap[$n(n-1)$]$ kanter vil du finde korteste veje mellem alle par. Det kan gøres ved at køre #swap[Dijkstra] $n$ gange (en fra hver knude) eller #swap[Floyd-Warshall] én gang. Dijkstra bruger et binært heap som prioritetskø. Hvilken metode har den bedste asymptotiske køretid som funktion af $n$ på denne slags graf?],
  options: (
    [Dijkstra kørt $n$ gange],
    [Floyd-Warshall],
    [De har samme asymptotiske køretid],
  ),
  answer: [Mulighed (b): Floyd-Warshall.],
  blueprint: [
    To skridt: regn prisen for hver metode ud ved det givne $m$, og sammenlign $Theta$-grænserne.

    + *Klassificér grafen.* Sæt #swap[$m$] ind og se, om grafen er tæt ($m = Theta(n^2)$) eller tynd ($m = Theta(n)$).
    + *Pris for $n$ kørsler.* En kørsel af #swap[Dijkstra med binært heap] koster $O((n + m) log n)$; gang med $n$ kilder.
    + *Pris for Floyd-Warshall.* Altid $Theta(n^3)$, uanset $m$.
    + *Sammenlign.* Den med den mindste $Theta$-grænse vinder; er de ens, er svaret "samme".
  ],
  worked: [
    Her er $m = #swap[$n(n-1)$]$ $= Theta(n^2)$, altså en tæt graf.

    + Dijkstra pr. kilde: $O(m log n) = O(n^2 log n)$. Gange $n$ kilder: $O(n^3 log n)$.
    + Floyd-Warshall: $Theta(n^3)$.
    + $n^3$ vokser en $log n$-faktor langsommere end $n^3 log n$.

    Svar: Floyd-Warshall er hurtigst.
  ],
)

#qcard(
  tag: [Alle-par: hurtigste metode (Floyd-Warshall)],
  source: "MCQ juni 2019, Spm. 20",
  theory: <th-sp-runtimes>,
  prompt: [På grafer med $n$ knuder og $m = #swap[$3n$]$ kanter vil du finde korteste veje mellem alle par. Det kan gøres ved at køre #swap[Bellman-Ford] $n$ gange (en fra hver knude) eller #swap[Floyd-Warshall] én gang. Hvilken metode har den bedste asymptotiske køretid som funktion af $n$ på denne slags graf?],
  options: (
    [Bellman-Ford kørt $n$ gange],
    [Floyd-Warshall],
    [De har samme asymptotiske køretid],
  ),
  answer: [Mulighed (c): de har samme asymptotiske køretid.],
  blueprint: [
    Samme to skridt: regn begge priser ud ved det givne $m$, og sammenlign.

    + *Klassificér grafen.* Sæt #swap[$m$] ind; her er den tynd ($m = Theta(n)$).
    + *Pris for $n$ kørsler.* En kørsel af #swap[Bellman-Ford] koster $O(n m)$; gang med $n$ kilder.
    + *Pris for Floyd-Warshall.* Altid $Theta(n^3)$.
    + *Sammenlign* $Theta$-grænserne. Er de ens, er svaret "samme" (konstanter er ligegyldige).
  ],
  worked: [
    Her er $m = #swap[$3n$]$ $= Theta(n)$, altså en tynd graf.

    + Bellman-Ford pr. kilde: $O(n m) = O(n dot 3n) = Theta(n^2)$. Gange $n$ kilder: $Theta(n^3)$.
    + Floyd-Warshall: $Theta(n^3)$.
    + Begge er $Theta(n^3)$ (de skiller kun en konstant faktor).

    Svar: samme asymptotiske køretid.
  ],
)
