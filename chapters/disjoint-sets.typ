#import "../lib.typ": *

== Disjunkte mængder (Union-Find)

$n$ elementer starter hver for sig. Du slår nogle sammen i grupper og vil løbende kunne spørge: "ligger de to i samme gruppe?" Det løser en disjunkt-mængde-struktur.

Tre operationer: $"Make-Set"(x)$ laver en ny gruppe med kun $x$. $"Find-Set"(x)$ returnerer repræsentanten for $x$'s gruppe. $"Union"(x,y)$ smelter to grupper sammen.

Hver gruppe er et træ med repræsentanten som rod, så hele strukturen er en skov. Til eksamen skal du kunne tegne skoven efter en række operationer og kende priserne.

Den dukker oftest op i Kruskals MST-algoritme: for hver kant spørger $"Find-Set"$, om endepunkterne allerede ligger i samme komponent.

=== Sådan løser du den

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

#note[Rank er en øvre grænse for højden, ikke den faktiske højde. Komprimering flader træet ud uden at sænke rank, så rank kan ende større end den højde, du tegner. Hold kun styr på rank i rødderne.]

#trap[Rækkefølgen tæller ved uafgjort. $"Union"(x,y)$ med ens rank gør $"root"(x)$ til barn af $"root"(y)$, som vokser. Bytter du $x$ og $y$, vender træet om.]

#trap[Komprimering kører kun på de $"Find-Set"$-kald, unionerne faktisk udfører. Komprimér ikke alle knuder til sidst. Et afsluttende $"Find-Set"$ på en rod ændrer intet.]

==== Priser

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

#note[Vægtet union på lænkede lister giver $O(n log n)$: en knudes header omskrives kun, når dens liste er den korteste, så gruppen fordobles hver gang, altså højst $log n$ omskrivninger pr. knude. For skoven er $alpha(n)$ den inverse Ackermann-funktion, under 5 for ethvert tænkeligt $n$. Beviset (CLRS 19.4) er ikke pensum.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  source: "MCQ juni 2025, Spm. 25",
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
  worked: [
    - $"Union"(f,e)$: uafgjort $arrow.r$ $f.p = e$, $"rank"(e) = 1$.
    - $"Union"(b,f)$: $"find"(f) = e$; $"rank"(e) > "rank"(b)$ $arrow.r$ $b.p = e$.
    - $"Union"(d,a)$: uafgjort $arrow.r$ $d.p = a$, $"rank"(a) = 1$.
    - $"Union"(f,d)$: $"find"(f) = e$, $"find"(d) = a$, begge rank 1, uafgjort $arrow.r$ $e.p = a$, $"rank"(a) = 2$.
    - $"Union"(b,c)$: $"find"(b)$ går $b arrow.r e arrow.r a$ og komprimerer $b$ til $a$; $"find"(c) = c$; $"rank"(a) > "rank"(c)$ $arrow.r$ $c.p = a$.
    - $"Find-Set"(a)$: $a$ er rod, intet sker.

    Endelige forældre: $b, c, d, e arrow.r a$ og $f arrow.r e$.
  ],
)

#qcard(
  source: "DM507 juni 2008, Opgave 3b/3c",
  prompt: [Kør instruktionerne
    #swap[$"Union"(b,a)$, $"Union"(b,c)$, $"Union"(e,d)$, $"Union"(e,c)$, $"Union"(g,f)$, $"Union"(e,g)$]
    med union by rank. Ved uafgjort hænges $"root"(x)$ under $"root"(y)$, og $"root"(y)$'s rank forhøjes. Tegn skoven (b) uden path compression og (c) med.],
  answer: [Rod $a$ (rank 2) med børnene $b, c, d, f$; $e$ under $d$; $g$ under $f$. Med komprimering flytter $e$ direkte ind under $a$.],
  worked: [
    *(b) uden komprimering:*
    - $"Union"(b,a)$: uafgjort $arrow.r$ $b.p = a$, $"rank"(a) = 1$.
    - $"Union"(b,c)$: $"root"(b) = a$ (rank 1) $>$ $c$ (rank 0) $arrow.r$ $c.p = a$.
    - $"Union"(e,d)$: uafgjort $arrow.r$ $e.p = d$, $"rank"(d) = 1$.
    - $"Union"(e,c)$: $"root"(e) = d$ (rank 1), $"root"(c) = a$ (rank 1), uafgjort $arrow.r$ $d.p = a$, $"rank"(a) = 2$.
    - $"Union"(g,f)$: uafgjort $arrow.r$ $g.p = f$, $"rank"(f) = 1$.
    - $"Union"(e,g)$: $"root"(e) = a$ (rank 2) $>$ $"root"(g) = f$ (rank 1) $arrow.r$ $f.p = a$.

    Resultat: $a$ (rank 2) med børnene $b, c, d, f$; $e$ under $d$; $g$ under $f$.

    *(c) med komprimering:* eneste $"find"$ på en sti af længde 2 er trin 6, hvor $"find"(e)$ går $e arrow.r d arrow.r a$ og komprimerer $e$ til at pege på $a$. Samme træ som (b), men $e$ er nu direkte barn af $a$. Rank uændret.
  ],
)

#qcard(
  source: "DM02 jan 2006, Opg 3a",
  prompt: [De første #swap[5] Kruskal-kanter er valgt, så grupperne er ${E,F,H,I}$, ${D,G}$, ${A,B}$, ${C}$. Hvilken kant tilføjer Kruskal som den #swap[6.], og hvordan ser disjunkt-mængde-skoven ud bagefter, med union by rank + path compression?],
  answer: [Næste kant er #swap[$D"-"H$] (vægt #swap[4]). $D$ hænges under $E$.],
  worked: [
    Scan resterende kanter i stigende vægt. Den letteste med endepunkter i forskellige grupper er $D"-"H$: $D in {D,G}$ og $H in {E,F,H,I}$.

    $"Union"(D, H)$ kalder $"Find-Set"$ på begge:
    - $"find"(D) = D$ (rank 1).
    - $"find"(H)$ går $H arrow.r I arrow.r E$, så $"find"(H) = E$ (rank 2). Komprimering peger nu $H$ og $I$ direkte på $E$.

    Rank 1 $<$ rank 2, så $D$ (med barnet $G$) hænges under $E$, der forbliver rank 2.

    Fælden: $"find"(H)$ komprimerer, så kanten $H arrow.r I$ forsvinder og $H, I$ peger direkte på $E$.
  ],
)

#note[Kruskal er stedet, union-find oftest dukker op. Opskrift: sortér kanterne efter stigende vægt; for hver kant, foren endepunkterne hvis deres $"Find-Set"$ er forskellige, ellers spring over. Stop ved $|V| - 1$ kanter. Antal komponenter undervejs er $|V|$ minus accepterede kanter.]
