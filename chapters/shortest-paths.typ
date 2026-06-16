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

#note(title: [Relax-egenskaber])[Uanset hvilken relax-algoritme du kører: gættet er aldrig for lavt ($delta(s,v) <= v.d$), det kan kun falde, og når $v.d$ rammer $delta(s,v)$ ændres det aldrig igen.]

Algoritmerne adskiller sig kun ved rækkefølgen kanterne slappes af i, og den afhænger af grafen. Læs derfor grafen først.

#recipe(
  title: "Vælg algoritmen",
  [*Læs vægtene.* Er de alle ens (enhedsvægte)? Alle $>= 0$? Eller er nogle negative? Skriv det ned ét sted.],
  [*Læs strukturen.* Følg pilene: kan du komme tilbage til en knude du har forladt, er der en kreds. Ellers er grafen en DAG (orienteret uden kredse).],
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

#algcard(
  gdiag({
    gnode((0,0), "a", $a$); gnode((1.5,0.5), "b", $b$); gnode((1.5,-0.5), "c", $c$)
    gedge("a","b", w: $4$); gedge("a","c", w: $2$); gedge("b","c", w: $3$)
  }),
  [Dijkstra],
  [Tager hele tiden den nærmeste uafklarede knude og slapper dens kanter af. *Krav:* alle vægte $>= 0$. *Hvorfor:* den regner en knude for færdig i samme øjeblik den trækkes ud af køen. En negativ kant kunne gøre en vej billigere bagefter, og så ville svaret være forkert. Derfor er negative vægte udelukket.],
)

#algcard(
  gdiag({
    gnode((0,0), "a", $a$); gnode((1.1,0.55), "b", $b$); gnode((2.2,0), "c", $c$)
    gedge("a","b", w: $3$); gedge("b","c", w: $-2$); gedge("a","c", w: $4$)
  }),
  [DAG-Shortest-Paths],
  [Sorterer knuderne topologisk og slapper kanterne af i den orden, én gang hver. *Krav:* grafen skal være en DAG; negative vægte er fine. *Hvorfor:* i en DAG kan du stille knuderne på en række, hvor alle pile peger fremad. Tager du dem i den orden, er en knude færdig, før du bruger den. Har grafen en kreds, findes den orden ikke.],
)

#algcard(
  gdiag({
    gnode((0,0), "a", $a$); gnode((1.5,0.5), "b", $b$); gnode((1.5,-0.5), "c", $c$)
    gedge("a","b", w: $-2$); gedge("b","c", w: $3$); gedge("c","a", w: $4$)
  }),
  [Bellman-Ford],
  [Slapper alle kanter af $|V| - 1$ gange og kører så en runde mere for at se efter forbedringer. *Krav:* ingen negativ kreds; negative kanter og almindelige kredse er fine. *Hvorfor:* det robuste valg, der stiller færrest krav. Den ekstra runde fanger en negativ kreds — kan en kant stadig forbedres, findes der en. Til gengæld er den langsommere end de andre.],
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

#trap(title: [MST er ikke korteste vej])[Kruskal og Prim bygger et minimalt udspændende træ, ikke korteste veje. DFS alene gør det heller ikke. Klassiske distraktorer.]

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
  blueprint: [
    Du fører en lille tabel med $d$-værdier og krydser knuder af, efterhånden som de trækkes ud. Køen er bare "hvem har lige nu det mindste $d$".

    + Sæt $d = 0$ for startknuden #swap[$a$] og $infinity$ for resten.
    + Træk knuden med mindst $d$ ud af køen. Står to lige, tag den alfabetisk mindste.
    + Skriv den udtrukne knude på din liste. Det er den næste i udtrækningsrækkefølgen, og dens $d$ er nu endelig.
    + Slap dens udkanter af: for hver kant $(u,v)$, hvis $u.d + w(u,v) < v.d$, så sæt $v.d$ ned.
    + Gentag til køen er tom. Tæl dig frem på listen til det nummer der spørges om (her den #swap[sjette]).
  ],
  worked: [
    Start: $a.d = 0$, resten $infinity$. Så trækker vi ud én ad gangen og slapper udkanter af.

    + *1. $a$ (0)* #sym.arrow.r relax $b = 1$, $d = 3$.
    + *2. $b$ (1)* #sym.arrow.r relax $d: 3 #sym.arrow.r 2$, $c = 3$, $e = 4$.
    + *3. $d$ (2)* #sym.arrow.r relax $g = 3$. ($2 < 3$, så $d$ kommer før $c$ og $g$.)
    + *4. $c$ (3)* og *5. $g$ (3)* står uafgjort på $3$. Alfabetisk tager vi $c$ som fjerde, $g$ som femte.
    + *6. $e$ (4)* trækkes ud som den sjette.

    Hele rækkefølgen med færdige afstande: $a(0), b(1), d(2), c(3), g(3), e(4), h(5), f(6), i(6)$. Den sjette er $e$ med afstand $4$.
  ],
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
  blueprint: [
    Du behøver ikke spore relax-rækkefølgen kant for kant. Bellman-Ford garanterer at $v.d$ til sidst er vægten af den letteste vej, så du kan bare finde den letteste vej til hver knude i hånden.

    + Sæt $d = 0$ for startknuden #swap[$a$] og $infinity$ for resten.
    + Hvis du følger pseudokoden: slap alle kanter af $|V| - 1$ gange. Hver runde tager dig ét kant-hop længere ud.
    + Genvejen i hånden: for hver knude, find den billigste sti fra startknuden og læg vægtene sammen. Husk at negative kanter kan gøre en omvej billigere end den direkte kant.
    + Skriv afstandene ind i tabellen.
    + Tjek til sidst for negativ kreds: kan en kant $(u,v)$ stadig forbedres, altså $u.d + w(u,v) < v.d$, så findes der en negativ kreds, og svaret er FALSE.
  ],
  worked: [
    Init $a.d = 0$, resten $infinity$. Efter $|V| - 1 = 7$ runder med relax af alle kanter sporer vi den letteste vej til hver knude.

    - $h = 0$ via $a #sym.arrow.r f #sym.arrow.r h$, altså $10 + (-10)$. Det slår $a #sym.arrow.r e #sym.arrow.r h = 8 + (-4) = 4$.
    - $g = 12$ via $a #sym.arrow.r b #sym.arrow.r g$, altså $17 + (-5)$.
    - $c = 9$ via $g #sym.arrow.r c$, altså $12 + (-3)$.
    - $d = 1$ via $h #sym.arrow.r d$, altså $0 + 1$.
    - $e = 7$ via $d #sym.arrow.r e$, altså $1 + 6$.
    - $b = 17$ via den direkte $a #sym.arrow.r b$. Omvejen $c #sym.arrow.r b$ giver $9 + 19 = 28$ og taber.
    - $f = 10$ via den direkte $a #sym.arrow.r f$.

    Ingen negativ kreds er nåelig fra $a$, så ingen kant kan forbedres i en ekstra runde. Værdierne står fast som i tabellen.
  ],
)
