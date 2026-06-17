#import "../lib.typ": *

=== Grafgennemløb og -struktur
De skriftlige opgaver om DFS (depth-first search) og BFS (breadth-first search) beder dig stort set altid om at køre gennemløbet i hånden og aflæse noget af det. Det kan være discovery- og finish-tider, hvad kanterne klassificeres som, hvilken rækkefølge køen tømmes i, eller afstandene fra kilden. Et par opgaver går videre til stærkt sammenhængende komponenter (strongly connected components) eller til at afgøre, om en graf er todelt (bipartite). Nabolisterne (adjacency lists) gennemgås altid alfabetisk, så der ikke er tvivl om rækkefølgen.

#qcard(
  tag: [DFS: tidsstempler + kantklassifikation],
  source: "DM507 juni 2015, Opg. 6 (10%)",
  prompt: [
    #swap[Hjulgraf: et centrum $i$ og en ydre ring $a-b-c-d-e-f-g-h-a$ (med uret fra toppen), hvor hvert ringhjørne også er forbundet til $i$.] Kanterne er urettede (undirected). DFS starter i $i$, og nabolister gennemgås i alfabetisk orden.
    *(a)* Angiv discovery-tid $v.d$ og finish-tid $v.f$ for alle hjørner. \
    *(b)* Klassificér hver kant som tree / back / forward / cross (endepunkter i alfabetisk orden).
  ],
  answer: [(a) $i: 1\/18$, $a: 2\/17$, $b: 3\/16$, $c: 4\/15$, $d: 5\/14$, $e: 6\/13$, $f: 7\/12$, $g: 8\/11$, $h: 9\/10$. (b) Kun tree- og back-kanter, da grafen er urettet.],
  blueprint: [
    + Lad uret starte på 0. Ved opdagelse af $v$: $mono("time")$++, sæt $v.d = mono("time")$, farv grå. Rekursér ned i hvide naboer i alfabetisk orden (det giver tree-kanterne). Ved afslutning af $v$: farv sort, $mono("time")$++, sæt $v.f = mono("time")$.
    + Klassificér kanten $(u,v)$ set fra $u$: $v$ hvid $->$ tree; $v$ grå $->$ back; $v$ sort $->$ forward hvis $u.d < v.d$, ellers cross.
    + I en *urettet* graf optræder kun tree- og back-kanter.
  ],
  worked: [
    + Fra $i$ ($d = 1$) er naboerne $a, ..., h$; første hvide er $a$, så tree-kant $i - a$. Fra $a$ er første hvide nabo $b$, og ringen vandres $a -> b -> c -> ... -> h$, hver kant en tree-kant. $h$ afsluttes først, og finish-tiderne nester:
      #eq[$ i: 1\/18, space a: 2\/17, space b: 3\/16, space c: 4\/15, space d: 5\/14, space e: 6\/13, space f: 7\/12, space g: 8\/11, space h: 9\/10. $]

    + *Tree:* $(a,i), (a,b), (b,c), (c,d), (d,e), (e,f), (f,g), (g,h)$.
    + *Back:* $(a,h)$ samt hver eger til $i$ undtagen tree-egeren $a - i$: $(b,i), (c,i), (d,i), (e,i), (f,i), (g,i), (h,i)$.
    + *Forward* og *cross:* ingen.
  ],
)

#qcard(
  tag: [DFS: tidsstempler + kantklassifikation],
  source: "DM507 juni 2012, Opg. 4c (10%)",
  prompt: [
    Rettet graf (directed graph) $G 3$ på hjørnerne $a, ..., h$ med kanterne
    #swap[$a->b, a->e, a->f, b->g, c->b, c->d, d->e, e->h, f->g, g->c, g->h, h->d, h->f$.]
    Nabolister sorteres alfabetisk; DFS starter i $a$, og hovedløkken fortsætter alfabetisk. Angiv $v.d$ og $v.f$ for alle hjørner.
  ],
  answer: [Ét DFS-træ fra $a$. $a: 1\/16$, $b: 2\/15$, $g: 3\/14$, $c: 4\/13$, $d: 5\/12$, $e: 6\/11$, $h: 7\/10$, $f: 8\/9$.],
  blueprint: [
    + $mono("time") = 0$. Ved opdagelse af $u$: $mono("time")$++, $u.d = mono("time")$, farv grå.
    + Rekursér ned i hvide naboer i listerækkefølge (alfabetisk).
    + Ved afslutning af $u$: $mono("time")$++, $u.f = mono("time")$, farv sort. Når $a$-træet er færdigt, fortsæt fra næste uopdagede hjørne alfabetisk.
  ],
  worked: [
    + Discovery-stien tager altid den mindste hvide nabo: $a -> b -> g -> c -> d -> e -> h -> f$. Alle otte hjørner nås fra $a$, så der er kun ét træ.
    + Discovery-tiderne $1..8$ langs stien; så foldes der op igen med finish-tider $9..16$:
      #eq[$ a: 1\/16, space b: 2\/15, space g: 3\/14, space c: 4\/13, space d: 5\/12, space e: 6\/11, space h: 7\/10, space f: 8\/9. $]
  ],
)

#qcard(
  tag: [BFS + DFS på rettet graf],
  source: "jun 2016, Problem 6 (a,b)",
  prompt: [
    Rettet graf $G 1$ med ud-nabolister (alfabetisk sorteret, kun disse kanter må følges):
    #swap[$a: \[b\], space b: \[c\,e\], space c: \[d\,f\], space d: \[ \], space e: \[a\,f\], space f: \[b\,g\,h\], space g: \[c\,i\], space h: \[e\,i\], space i: \[f\,j\], space j: \[h\]$.]
    *(a)* Kør BFS fra $a$: angiv dequeue-rækkefølge og endelig $v.d$ (afstand fra $a$). \
    *(b)* Kør DFS fra $a$: angiv discovery-tid $v.d$ og finish-tid $v.f$.
  ],
  answer: [(a) Dequeue: $a, b, c, e, d, f, g, h, i, j$; afstande $a 0, b 1, c 2, e 2, d 3, f 3, g 4, h 4, i 5, j 6$. (b) $a: 1\/20, b: 2\/19, c: 3\/18, d: 4\/17, g: 5\/16, i: 6\/15, f: 7\/12, h: 8\/11, e: 9\/10, j: 13\/14$.],
  blueprint: [
    + *BFS.* Enqueue start med $d = 0$. Dequeue gentaget $u$, og for hver ubesøgt ud-nabo $v$ (alfabetisk): $v.d = u.d + 1$, marker besøgt, enqueue. Dequeue-rækkefølgen er besøgsrækkefølgen.
    + *DFS.* Globalt ur fra 0. Ved første besøg: $v.d = $ ++ur; rekursér ned i ubesøgte ud-naboer alfabetisk; ved retur: $v.f = $ ++ur. Følg kun kanter i pilens retning.
  ],
  worked: [
    + *(a) BFS.* $a(0)$ giver $b(1)$. $b$ giver $c, e (2)$. $c$ giver $d, f (3)$. $e$: alt besøgt. $d$ giver $g(4)$. $f$ giver $h(4)$ ($b, g$ set). $g$ giver $i(5)$. $h$: set. $i$ giver $j(6)$. Dequeue-rækkefølge $a, b, c, e, d, f, g, h, i, j$.
    + *(b) DFS.* Stien tager mindste ubesøgte ud-nabo: $a -> b -> c -> d -> g -> i -> f -> h -> e$; $e$ afsluttes ved 10. Tilbage til $h$ (afslut 11), $f$ (afslut 12), så fra $i$ opdages $j$ ved 13 ($j -> h$ set, afslut 14), og der foldes op: $i 15, g 16, d 17, c 18, b 19, a 20$.
  ],
)

#qcard(
  tag: [BFS på rettet graf],
  source: "DM507 juni 2013, Opg. 4a (10%)",
  prompt: [
    Rettet, uvægtet graf $G 1$ på hjørnerne $a, ..., h$ og centrum $i$. Ud-nabolister (alfabetisk sorteret):
    #swap[$a: \[i\], space b: \[a\,c\], space c: \[d\,i\], space d: \[ \], space e: \[d\,i\], space f: \[e\,i\], space g: \[f\,i\], space h: \[a\,g\], space i: \[b\,d\,h\]$.]
    Kør BFS fra $a$: angiv hjørnerne i dequeue-rækkefølge og den endelige $v.d$ (afstand fra $a$) for hvert hjørne.
  ],
  answer: [Dequeue: $a, i, b, d, h, c, g, f, e$. Afstande: $a 0, i 1, b 2, d 2, h 2, c 3, g 3, f 4, e 5$.],
  blueprint: [
    + Køen starter med kilden ($d = 0$). Dequeue gentaget $u$, og gennemgå $mono("Adj")[u]$ i sorteret orden.
    + Hver uset nabo får $d = d[u] + 1$, enqueues og markeres.
    + Dequeue-rækkefølgen er BFS-besøgsrækkefølgen.
  ],
  worked: [
    + $a(0)$: enqueue $i(1)$.
    + $i$: $b, d, h$ alle nye $-> (2)$.
    + $b$: $a$ set, $c$ ny $-> (3)$. $d$: ingen ud-kanter. $h$: $a$ set, $g$ ny $-> (3)$.
    + $c$: $d, i$ set. $g$: $f$ ny $-> (4)$. $f$: $e$ ny $-> (5)$. $e$: $d, i$ set.

    Dequeue-rækkefølge $a, i, b, d, h, c, g, f, e$; afstande som i svaret.
  ],
)

#qcard(
  tag: [Stærkt sammenhængende komponenter (SCC)],
  source: "DM02 januar 2005, Opg. 3 (25%)",
  prompt: [
    Rettet graf $G = (V, E)$ med $V = {A, ..., N}$ (14 hjørner) og kanterne
    #swap[$A->E, E->A, B->C, B->E, C->D, C->G, C->L, E->I, F->E, F->B, F->J, G->F, G->K, H->C, H->D, H->G, I->J, J->N, K->J, L->H, M->I, M->J, N->K, N->M$.]
    Ties brydes alfabetisk.
    *(a)* Find SCC'erne. Angiv pre/post-numre fra den *første* DFS; tegn skoven fra den *anden* DFS. \
    *(b)* Tegn komponentgrafen (component graph) $G'$. \
    *(c)* Angiv en topologisk sortering (topological sort) af $G'$ og forklar hvorfor.
  ],
  answer: [(a) Fire SCC'er: ${B,C,F,G,H,L}$, ${D}$, ${A,E}$, ${I,J,K,M,N}$. (b) $G'$ har kanterne $B C F G H L -> D$, $-> A E$, $-> I J K M N$ samt $A E -> I J K M N$. (c) Topologisk: $B C F G H L, D, A E, I J K M N$.],
  blueprint: [
    Kosaraju / to-pas-DFS for stærkt sammenhængende komponenter (vilkårlig digraf).

    + Kør DFS på $G$ med alfabetiske ties. Notér discovery (pre, $d$) og finish (post, $f$) med ét ur, der tæller op ved både push og pop.
    + List hjørnerne i *aftagende finish-tid*.
    + Kør DFS på transponaten (transpose) $G^T$ (alle kanter vendt) startende fra det uopdagede hjørne med højest finish. Hvert træ i denne anden skov er én SCC.
    + *Komponentgraf $G'$:* ét hjørne pr. SCC; kant $C_i -> C_j$ hvis nogen kant i $G$ går fra $C_i$ til $C_j$ ($i != j$).
    + *Topologisk orden:* list SCC'erne i aftagende første-DFS-finish (= den rækkefølge andet pas opdagede dem). Det er altid topologisk, fordi en kondensation (condensation) er acyklisk (acyclic).
  ],
  worked: [
    + *Første DFS på $G$* (ét ur, pre/post). $A$-træet: $A->E->I->J->N->K$ ($K->J$ set), $N->M$. Så ny rod $B$: $B->C->D$, $C->G->F$, $C->L->H$. Pre/post bl.a.:
      #eq[$ A: 1\/14, space E: 2\/13, space I: 3\/12, space J: 4\/11, space N: 5\/10, space K: 6\/7, space M: 8\/9, $]
      #eq[$ B: 15\/28, space C: 16\/27, space D: 17\/18, space G: 19\/22, space F: 20\/21, space L: 23\/26, space H: 24\/25. $]

    + *Aftagende finish:* $B(28), C(27), L(26), H(25), G(22), F(21), D(18), A(14), E(13), I(12), J(11), N(10), M(9), K(7)$.

    + *Andet DFS på $G^T$,* rødder i den orden:
      - $B$: når ${B, C, F, G, H, L}$.
      - $D$: alene.
      - $A$: når ${A, E}$ (kun $A->E$ og $E->A$ rører $A$; $F->E$, så $E$ kan ikke nå tilbage).
      - $I$: når ${I, J, K, M, N}$.

    + *(b) $G'$:* fire hjørner $B C F G H L, D, A E, I J K M N$. Kryds-kanter: $C->D$ giver $-> D$; $B->E, F->E$ giver $-> A E$; $G->K$ giver $-> I J K M N$; $E->I$ giver $A E -> I J K M N$.

    + *(c)* Orden $B C F G H L, D, A E, I J K M N$. Alle fire kanter peger fremad i listen, så det er en gyldig topologisk sortering. ($D$ og $A E$ er usammenlignelige, så $B C F G H L, A E, D, I J K M N$ virker også.)
  ],
)

#qcard(
  tag: [Todelt graf (bipartit): genkend + BFS-test],
  source: "DM507 januar 2007, Opg. 4 (20%)",
  prompt: [
    En todelt (bipartit) graf er én, hvis hjørner kan deles i to disjunkte mængder $X, Y$, så hver kant har ét endepunkt i $X$ og ét i $Y$.
    *(a)* Hvilke af disse er bipartitte (giv en 2-deling)? #swap[(i) en 5-kreds (pentagon); (ii) en 4-kreds (firkant); (iii) fem hjørner $T, L, R, B L, B R$ med kanterne $T - B R, L - R, R - B L, B L - B R, B R - L$.] \
    *(b)* Modificér BFS, så den afgør bipartithed i samme asymptotiske tid. \
    *(c)* Bevis: en graf er bipartit $<==>$ den har ingen ulige kreds (odd cycle).
  ],
  answer: [(a) (i) ikke bipartit (ulige kreds, længde 5); (ii) bipartit, $X, Y$ = de to diagonalpar; (iii) bipartit, fx $X = {T, L, B L}$, $Y = {R, B R}$. (b) BFS med farve = niveau-paritet, $O(V + E)$. (c) Se bevis.],
  blueprint: [
    + *Genkend:* en graf er bipartit hvis og kun hvis den ingen ulige kreds har. Prøv en 2-farvning (2-coloring): farv et starthjørne $X$, naboerne $Y$, deres naboer $X$ osv. Får to nabohjørner samme farve, har du en ulige kreds $->$ ikke bipartit.
    + *BFS-test:* kør BFS og giv hvert hjørne en farve = dets BFS-afstand mod 2. For hver kant $(u,v)$: hvis $v$ er ufarvet, $mono("color")[v] = 1 - mono("color")[u]$; ellers hvis $mono("color")[v] = mono("color")[u]$, returnér FALSE. Kør over alle hjørner for at dække usammenhængende grafer.
    + *Køretid:* hvert hjørne enqueues én gang, hver kant ses $O(1)$ gange $-> O(V + E)$, som almindelig BFS.
  ],
  worked: [
    + *(a)(i)* Pentagon $C_5$: ulige kreds af længde 5, så ikke bipartit (2-farvning fejler).
    + *(a)(ii)* Firkant $C_4$: lige kreds, bipartit. $X = $ de to modstående hjørner, $Y = $ de to andre.
    + *(a)(iii)* $T$ rører kun $B R$ (grad 1), og $L, R, B L, B R$ danner 4-kredsen $L - R - B L - B R - L$. En lige kreds plus et pendant-hjørne giver ingen ulige kreds, så grafen 2-farves: $X = {T, L, B L}$, $Y = {R, B R}$.

    + *(c)($=>$)* Bipartit $=>$ ingen ulige kreds. Langs enhver kreds krydser hver kant mellem $X$ og $Y$, så siden veksler $X, Y, X, Y, ...$. For at vende tilbage til startsiden efter $k$ skridt må $k$ være lige. Altså er enhver kreds lige.

    + *(c)($<==$)* Ingen ulige kreds $=>$ bipartit. Arbejd pr. sammenhængskomponent. Kør BFS fra $s$, farv efter afstands-paritet. Hvis en kant $(u,v)$ forbandt to lige-paritets-hjørner, ville træstierne $w -> u$ og $w -> v$ fra deres laveste fælles forfader $w$ have samme paritet, så $(u,v)$ lukkede en ulige kreds — modstrid. Paritetsfarvningen er derfor en gyldig 2-deling.
  ],
)
