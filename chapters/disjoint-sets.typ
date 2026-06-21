#import "../lib.typ": *

== Disjunkte mængder (Union-Find)

$n$ elementer starter hver for sig. Du slår nogle sammen i grupper og vil løbende kunne spørge: "ligger de to i samme gruppe?" Det løser en disjunkt-mængde-struktur (disjoint-set structure).

Tre operationer: $"Make-Set"(x)$ laver en ny gruppe med kun $x$. $"Find-Set"(x)$ returnerer repræsentanten (representative) for $x$'s gruppe. $"Union"(x,y)$ smelter to grupper sammen.

Hver gruppe er et træ med repræsentanten som rod, så hele strukturen er en skov (forest). Til eksamen skal du kunne tegne skoven efter en række operationer og kende priserne.

Den dukker oftest op i Kruskals MST-algoritme: for hver kant spørger $"Find-Set"$, om endepunkterne allerede ligger i samme komponent.

=== Sådan løser du den <th-ds-method>

To tricks holder træerne flade. *Union by rank* hænger det lave træ under det høje. *Path compression* peger alle knuder på en $"Find-Set"$-sti direkte op på roden.

Hver rod har en rank, en øvre grænse for højden. Et frisk $"Make-Set"$ giver

#eq[$ x.p = x, quad x."rank" = 0. $]

Link-reglen sammenligner de to rødders rank:

#eq[$ "rank"(r_x) > "rank"(r_y) ==> r_y.p = r_x quad (#[rank uændret]). $]

Er rankene lige, taber det *første* argument:

#eq[$ "rank"(r_x) = "rank"(r_y) ==> r_x.p = r_y, quad r_y."rank" "+"= 1. $]

#recipe(
  title: "Tegn skoven (union by rank + path compression)",
  [*Start.* Hvert $"Make-Set"$ giver en rod med rank #swap[$0$].],
  [*Hver $"Union"(x,y)$* er $"Link"("Find-Set"(x), "Find-Set"(y))$. Find først begge rødder (her sker path compression), link så.],
  [*Link.* Højeste rank vinder og beholder sin rank. Ved uafgjort bliver *første* rod barn af *anden* rod, og andens rank vokser med 1.],
  [*Komprimér* undervejs: når $"Find-Set"$ har nået roden, peger alle knuder på stien direkte på roden. Komprimering ændrer aldrig rank.],
  [*Aflæs* de endelige forælderpegere. Roden, hvor $x.p = x$, er gruppens ID.],
)

```
Make-Set(x)              Find-Set(x)
    x.p = x                  if x != x.p
    x.rank = 0                   x.p = Find-Set(x.p)   // path compression
                             return x.p
Union(x, y)              Link(x, y)   // x, y er rødder
    Link(Find-Set(x),        if x.rank > y.rank
         Find-Set(y))            y.p = x
                             else x.p = y
                                 if x.rank == y.rank
                                     y.rank = y.rank + 1
```

#note(title: [Rank vs. højde])[Rank er en øvre grænse for højden, ikke den faktiske højde. Komprimering flader træet ud uden at sænke rank, så rank kan ende større end den højde, du tegner. Hold kun styr på rank i rødderne.]

#trap(title: [Rækkefølge ved uafgjort])[Rækkefølgen tæller ved uafgjort. $"Union"(x,y)$ med ens rank gør $"root"(x)$ til barn af $"root"(y)$, som vokser. Bytter du $x$ og $y$, vender træet om.]

#trap(title: [Sti-komprimering])[Komprimering kører kun på de $"Find-Set"$-kald, unionerne faktisk udfører. Komprimér ikke alle knuder til sidst. Et afsluttende $"Find-Set"$ på en rod ændrer intet.]

==== Priser <th-ds-costs>

Tallene gælder for $n$ $"Make-Set"$, $n-1$ $"Union"$ og $m$ $"Find-Set"$.

#table(
  columns: (1.7fr, auto, auto, 1.2fr),
  inset: 7pt,
  align: (left, center, center, left),
  stroke: 0.4pt + hair,
  table.header([*Implementation*], [*Find*], [*Union*], [*I alt*]),
  [Lænket liste, naiv], [$O(1)$], [$O(n)$], [$O(m + n^2)$],
  [Lænket liste, vægtet union], [$O(1)$], [$O(n)$], [$O(m + n log n)$],
  [Skov, ingen balancering], [$O(n)$], [$O(1)$], [$O(m dot n)$],
  [Skov, rank + komprimering], [$alpha(n)$], [$alpha(n)$], [$O(m dot alpha(n) + n)$],
)

#note(title: [Vægtet union og inverse Ackermann])[Vægtet union (weighted union) på lænkede lister (linked lists) giver $O(n log n)$: en knudes header omskrives kun, når dens liste er den korteste, så gruppen fordobles hver gang, altså højst $log n$ omskrivninger pr. knude. For skoven er $alpha(n)$ den inverse Ackermann-funktion (inverse Ackermann function), under 5 for ethvert tænkeligt $n$. Beviset (CLRS 19.4) er ikke pensum.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Union-Find: tegn skoven efter operationerne (union by rank + path compression)],
  source: "MCQ juni 2025, Spm. 25",
  theory: <th-ds-method>,
  prompt: [Disjunkt-mængde-skov med union by rank og path compression (Cormen 4. udg.). Fra tom: Make-Set på $a, b, c, d, e, f$, derefter
    #swap[$"Union"(f,e)$, $"Union"(b,f)$, $"Union"(d,a)$, $"Union"(f,d)$, $"Union"(b,c)$, $"Find-Set"(a)$].
    Hvilken figur viser strukturen bagefter?],
  options: (
    [Rod $a$ med børnene $b, c, d, e$ direkte under $a$; $f$ peger på $e$ ($f arrow.r e arrow.r a$).],
    [Rod $a$ med $b, c, d, e, f$ alle direkte under $a$ (flad stjerne).],
    [Rod $a$ med børnene $c, d, e$; under $e$ ligger $b$ og $f$ ($b, f arrow.r e arrow.r a$).],
    [Rod $c$ øverst; $a arrow.r c$; $b, d, e arrow.r a$; $f arrow.r e$.],
  ),
  answer: [Mulighed (a).],
  blueprint: [
    Kør sekvensen én operation ad gangen og hold styr på to ting: hver knudes forælder og hver rods rank.

    + *Start.* Hvert $"Make-Set"$ giver en rod med $x.p = x$ og #swap[$"rank" = 0$].
    + *Hver $"Union"(x,y)$.* Find først begge rødder. $"Find-Set"$ følger forældrepegerne op til roden og komprimerer stien undervejs. Link så efter rank: den høje rod vinder og beholder sin rank; ved uafgjort bliver #swap[første] rod barn af #swap[anden], hvis rank vokser med 1.
    + *Aflæs skoven.* Roden er den knude med $x.p = x$. Resten af pegerne giver figuren.
  ],
  worked: [
    Jeg fører to tabeller med: forælderen `p[x]` for hver knude og `rank` for de knuder, der er rod. Et felt med `*` markerer, at knuden er rod ($p[x] = x$). Start, lige efter de seks $"Make-Set"$:

    ```
    knude:   a   b   c   d   e   f
    p[x]:    a*  b*  c*  d*  e*  f*
    rank:    0   0   0   0   0   0
    ```

    Hver $"Union"$ kalder først $"Find-Set"$ på begge argumenter (her sker path compression), derefter $"Link"$ på de to rødder.

    *Trin 1 — $"Union"(f,e)$.* $"find"(f) = f$, $"find"(e) = e$. Begge rank $0$ (uafgjort). Cormen-reglen: første rod bliver barn af anden, og anden vokser. Så $f.p = e$, $"rank"(e) = 1$.

    ```
    knude:   a   b   c   d   e   f
    p[x]:    a*  b*  c*  d*  e*  e
    rank:    0   0   0   0   1   -
    ```

    *Trin 2 — $"Union"(b,f)$.* $"find"(b) = b$. $"find"(f)$: $f arrow.r e$, rod $e$. Rødder $b$ (rank $0$) og $e$ (rank $1$). $"rank"(e) > "rank"(b)$, så $b.p = e$; rank uændret.

    ```
    knude:   a   b   c   d   e   f
    p[x]:    a*  e   c*  d*  e*  e
    rank:    0   -   0   0   1   -
    ```

    *Trin 3 — $"Union"(d,a)$.* $"find"(d) = d$, $"find"(a) = a$, begge rank $0$ (uafgjort). $d.p = a$, $"rank"(a) = 1$.

    ```
    knude:   a   b   c   d   e   f
    p[x]:    a*  e   c*  a   e*  e
    rank:    1   -   0   -   1   -
    ```

    *Trin 4 — $"Union"(f,d)$.* $"find"(f)$: $f arrow.r e$, rod $e$ (rank $1$). $"find"(d)$: $d arrow.r a$, rod $a$ (rank $1$). Uafgjort, så første rod $e$ bliver barn af anden rod $a$: $e.p = a$, $"rank"(a) = 2$.

    ```
    knude:   a   b   c   d   e   f
    p[x]:    a*  e   c*  a   a   e
    rank:    2   -   0   -   -   -
    ```

    *Trin 5 — $"Union"(b,c)$.* $"find"(b)$: stien er $b arrow.r e arrow.r a$, rod $a$. Path compression peger $b$ direkte på $a$: $b.p = a$. $"find"(c) = c$. Rødder $a$ (rank $2$) og $c$ (rank $0$): $"rank"(a) > "rank"(c)$, så $c.p = a$.

    ```
    knude:   a   b   c   d   e   f
    p[x]:    a*  a   a   a   a   e
    rank:    2   -   -   -   -   -
    ```

    *Trin 6 — $"Find-Set"(a)$.* $a$ er allerede rod, så intet ændrer sig (intet at komprimere).

    Endelige forældre: $b, c, d, e arrow.r a$ og $f arrow.r e$. Læg mærke til, at $f$ aldrig blev rørt af et $"find"$, så den hænger stadig under $e$ ($f arrow.r e arrow.r a$). Det er mulighed (a).
  ],
)

#qcard(
  tag: [Union-Find: tegn skoven (med/uden path compression)],
  source: "DM507 juni 2008, Opgave 3b/3c",
  theory: <th-ds-method>,
  prompt: [Kør instruktionerne
    #swap[$"Union"(b,a)$, $"Union"(b,c)$, $"Union"(e,d)$, $"Union"(e,c)$, $"Union"(g,f)$, $"Union"(e,g)$]
    med union by rank. Ved uafgjort hænges $"root"(x)$ under $"root"(y)$, og $"root"(y)$'s rank forhøjes. Tegn skoven (b) uden path compression og (c) med.],
  answer: [Rod $a$ (rank 2) med børnene $b, c, d, f$; $e$ under $d$; $g$ under $f$. Med komprimering flytter $e$ direkte ind under $a$.],
  blueprint: [
    Når opgaven beder om skoven både med og uden komprimering, kør den fulde sekvens for rank, og hold så øje med, hvilke $"Find-Set"$-kald der faktisk går gennem mere end ét led.

    + *Uden komprimering.* Kør hver #swap[$"Union"$]. Find begge rødder og link den lave rank under den høje. Ved uafgjort hænges $"root"(x)$ under $"root"(y)$, og $"root"(y)$'s rank vokser med 1. Pegerne ændrer sig kun ved selve linket.
    + *Med komprimering.* Samme sekvens, men hver gang et $"Find-Set"$ går over en sti på to led eller mere, peger knuderne på stien bagefter direkte på roden. Rank rører du ikke.
    + *Sammenlign.* Find de $"Find-Set"$-kald med lange stier. Kun de knuder flytter; resten af træet står som i den ukomprimerede version.
  ],
  worked: [
    *(b) uden komprimering.* Jeg fører forælder `p[x]` og `rank` (kun for rødder, markeret `*`). Uafgjort: $"root"(x)$ under $"root"(y)$, og $"root"(y)$'s rank $+1$. Start efter $"Make-Set"$ på $a..g$:

    ```
    knude:   a   b   c   d   e   f   g
    p[x]:    a*  b*  c*  d*  e*  f*  g*
    rank:    0   0   0   0   0   0   0
    ```

    *Trin 1 — $"Union"(b,a)$.* Rødder $b(0), a(0)$, uafgjort: $b.p = a$, $"rank"(a) = 1$.

    ```
    p[x]:    a*  a   c*  d*  e*  f*  g*
    rank:    1   -   0   0   0   0   0
    ```

    *Trin 2 — $"Union"(b,c)$.* $"find"(b)$: $b arrow.r a$, rod $a(1)$. $"find"(c) = c(0)$. $"rank"(a) > "rank"(c)$: $c.p = a$.

    ```
    p[x]:    a*  a   a   d*  e*  f*  g*
    rank:    1   -   -   0   0   0   0
    ```

    *Trin 3 — $"Union"(e,d)$.* Rødder $e(0), d(0)$, uafgjort: $e.p = d$, $"rank"(d) = 1$.

    ```
    p[x]:    a*  a   a   d*  d   f*  g*
    rank:    1   -   -   1   -   0   0
    ```

    *Trin 4 — $"Union"(e,c)$.* $"find"(e)$: $e arrow.r d$, rod $d(1)$. $"find"(c)$: $c arrow.r a$, rod $a(1)$. Uafgjort: $"root"(e) = d$ under $"root"(c) = a$, så $d.p = a$, $"rank"(a) = 2$.

    ```
    p[x]:    a*  a   a   a   d   f*  g*
    rank:    2   -   -   -   -   0   0
    ```

    *Trin 5 — $"Union"(g,f)$.* Rødder $g(0), f(0)$, uafgjort: $g.p = f$, $"rank"(f) = 1$.

    ```
    p[x]:    a*  a   a   a   d   f*  f
    rank:    2   -   -   -   -   1   -
    ```

    *Trin 6 — $"Union"(e,g)$.* $"find"(e)$: $e arrow.r d arrow.r a$, rod $a(2)$. $"find"(g)$: $g arrow.r f$, rod $f(1)$. $"rank"(a) > "rank"(f)$: $f.p = a$. Uden komprimering rører jeg ikke $e$, så $e$ hænger stadig under $d$.

    ```
    p[x]:    a*  a   a   a   d   a   f
    rank:    2   -   -   -   -   -   -
    ```

    Resultat (b): $a$ (rank $2$) med børnene $b, c, d, f$; $e$ under $d$; $g$ under $f$.

    *(c) med komprimering.* Samme sekvens og samme rank. Det eneste $"find"$, der løber over mere end ét led, er $"find"(e)$ i trin 6: stien $e arrow.r d arrow.r a$ peger nu både $e$ og $d$ direkte på roden $a$ ($d$ pegede i forvejen på $a$, så kun $e$ flytter):

    ```
    knude:   a   b   c   d   e   f   g
    p[x]:    a*  a   a   a   a   a   f
    rank:    2   -   -   -   -   -   -
    ```

    Samme træ som i (b), men nu hænger $e$ direkte under $a$. Rank er uændret.
  ],
)

#qcard(
  tag: [Union-Find i Kruskal: næste kant + skoven (Kruskal)],
  source: "DM02 jan 2006, Opg 3a",
  theory: <th-ds-kruskal>,
  prompt: [De første #swap[5] Kruskal-kanter er valgt, så grupperne er ${E,F,H,I}$, ${D,G}$, ${A,B}$, ${C}$. Hvilken kant tilføjer Kruskal som den #swap[6.], og hvordan ser disjunkt-mængde-skoven ud bagefter, med union by rank + path compression?],
  answer: [Næste kant er #swap[$D"-"H$] (vægt #swap[4]). $D$ hænges under $E$.],
  blueprint: [
    Her smelter to spørgsmål sammen: hvilken kant tager Kruskal, og hvordan ser union-find-skoven ud bagefter.

    + *Find kanten.* Gå de resterende kanter igennem i stigende vægt. Den første, hvor #swap[endepunkterne] ligger i hver sin gruppe, er den næste Kruskal vælger.
    + *Kald $"Find-Set"$ på begge endepunkter.* Følg forældrepegerne op til hver rod. Går et kald over flere led, komprimerer du stien, så knuderne peger direkte på roden.
    + *Link efter rank.* Den lave rod hænges under den høje, som beholder sin rank. Tegn så den nye skov.
  ],
  worked: [
    *Find kanten.* Gå de resterende kanter igennem i stigende vægt. Den letteste, hvor endepunkterne ligger i hver sin gruppe, er $D"-"H$ (vægt $4$): $D in {D,G}$ og $H in {E,F,H,I}$, altså to forskellige komponenter, så Kruskal accepterer den.

    *Skoven før kanten.* Med union by rank har de fire grupper denne form (rod markeret `*`). Den store gruppe ${E,F,H,I}$ er to led dyb under $E$, og ${D,G}$ har $G$ under $D$:

    ```
    knude:   E   F   H   I   D   G   A   B   C
    p[x]:    E*  E   I   E   D*  D   A*  A   C*
    rank:    2   -   -   -   1   -   1   -   0
    ```

    Træerne tegnet ud:

    ```
        E(2)        D(1)     A(1)    C(0)
       /  \          |        |
      F    I         G        B
           |
           H
    ```

    *$"Union"(D,H)$ kalder $"Find-Set"$ på begge endepunkter.*

    - $"find"(D)$: $D$ er rod, så $"find"(D) = D$ (rank $1$). Intet at komprimere.
    - $"find"(H)$: stien er $H arrow.r I arrow.r E$, så $"find"(H) = E$ (rank $2$). Path compression peger nu både $H$ og $I$ direkte på $E$.

    Efter de to $"find"$ (kanten endnu ikke linket):

    ```
    knude:   E   F   H   I   D   G   A   B   C
    p[x]:    E*  E   E   E   D*  D   A*  A   C*
    rank:    2   -   -   -   1   -   1   -   0
    ```

    *Link efter rank.* Rødderne er $D$ (rank $1$) og $E$ (rank $2$). $"rank"(E) > "rank"(D)$, så den lave rod $D$ (med barnet $G$) hænges under $E$, der beholder rank $2$:

    ```
    knude:   E   F   H   I   D   G   A   B   C
    p[x]:    E*  E   E   E   E   D   A*  A   C*
    rank:    2   -   -   -   -   -   1   -   0
    ```

    Skoven bagefter:

    ```
            E(2)
        /  / | \  \
       F  H  I  D  ...
                |
                G
    ```

    Næste kant er altså $D"-"H$ (vægt $4$), og $D$ hænges under $E$.
  ],
)

#metadata(none) <th-ds-kruskal>
#note(title: [Kruskal])[Kruskal er stedet, union-find oftest dukker op. Opskrift: sortér kanterne efter stigende vægt; for hver kant, foren endepunkterne hvis deres $"Find-Set"$ er forskellige, ellers spring over. Stop ved $|V| - 1$ kanter. Antal komponenter undervejs er $|V|$ minus accepterede kanter.]
