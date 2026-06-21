#import "../lib.typ": *

=== Grafgennemløb og -struktur
De skriftlige opgaver om DFS (depth-first search) og BFS (breadth-first search) beder dig stort set altid om at køre gennemløbet i hånden og aflæse noget af det. Det kan være discovery- og finish-tider, hvad kanterne klassificeres som, hvilken rækkefølge køen tømmes i, eller afstandene fra kilden. Et par opgaver går videre til stærkt sammenhængende komponenter (strongly connected components) eller til at afgøre, om en graf er todelt (bipartite). Nabolisterne (adjacency lists) gennemgås altid alfabetisk, så der ikke er tvivl om rækkefølgen.

#qcard(
  tag: [DFS: tidsstempler + kantklassifikation (Kantklassifikation)],
  source: "DM507 juni 2015, Opg. 6 (10%)",
  theory: <th-graph-edge-class>,
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
    + *Rekursionsstakken skridt for skridt.* Uret tæller op ved både opdagelse og afslutning. Hvert hjørne tager ved opdagelse den mindste hvide nabo i sin liste. Naboerne er: $i: [a,b,c,d,e,f,g,h]$, og hvert ringhjørne $v$ har $[$forgænger$,$ efterfølger$, i]$ i ringen, fx $a: [b, h, i]$, $b: [a, c, i]$, osv. Stakken vokser hele ringen rundt, før noget afsluttes:

      ```
      tid  handling                stak (bund -> top)         farver
       1   opdag i, i.d=1          [i]                        i grå
       2   i -> a (hvid), opdag    [i,a]                      a grå
       3   a -> b (hvid), opdag    [i,a,b]                    b grå
       4   b -> c (hvid), opdag    [i,a,b,c]                  c grå
       5   c -> d (hvid), opdag    [i,a,b,c,d]                d grå
       6   d -> e (hvid), opdag    [i,a,b,c,d,e]              e grå
       7   e -> f (hvid), opdag    [i,a,b,c,d,e,f]            f grå
       8   f -> g (hvid), opdag    [i,a,b,c,d,e,f,g]          g grå
       9   g -> h (hvid), opdag    [i,a,b,c,d,e,f,g,h]        h grå
      ```

    + *Nu er der ingen hvide tilbage, og stakken foldes op.* $h$ ser sine naboer $a$ (grå), $g$ (grå), $i$ (grå): alle ikke-hvide, så $h$ afsluttes. Derefter er hver pop'et knudes resterende naboer også grå/sorte:

      ```
      tid  handling                stak (bund -> top)
      10   afslut h, h.f=10        [i,a,b,c,d,e,f,g]
      11   afslut g, g.f=11        [i,a,b,c,d,e,f]
      12   afslut f, f.f=12        [i,a,b,c,d,e]
      13   afslut e, e.f=13        [i,a,b,c,d]
      14   afslut d, d.f=14        [i,a,b,c]
      15   afslut c, c.f=15        [i,a,b]
      16   afslut b, b.f=16        [i,a]
      17   afslut a, a.f=17        [i]
      18   afslut i, i.f=18        []
      ```

    + *(a)* Tidsstemplerne nester perfekt:
      #eq[$ i: 1\/18, space a: 2\/17, space b: 3\/16, space c: 4\/15, space d: 5\/14, space e: 6\/13, space f: 7\/12, space g: 8\/11, space h: 9\/10. $]

    + *(b) Tree:* $(a,i), (a,b), (b,c), (c,d), (d,e), (e,f), (f,g), (g,h)$ — de otte kanter, vi fulgte ned i en hvid nabo.
    + *Back:* hver gang en grå nabo blev mødt. $h$'s eger tilbage til $a$ (grå) er $(a,h)$, og hvert ringhjørne $b..h$ ser $i$ (grå): $(b,i), (c,i), (d,i), (e,i), (f,i), (g,i), (h,i)$.
    + *Forward* og *cross:* ingen — i en urettet graf kan kun tree- og back-kanter optræde.
  ],
)

#qcard(
  tag: [DFS: tidsstempler + kantklassifikation (Kantklassifikation)],
  source: "DM507 juni 2012, Opg. 4c (10%)",
  theory: <th-graph-dfs>,
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
    + *Ud-naboer, alfabetisk sorteret* (kun pilens retning følges): $a: [b,e,f]$, $b: [g]$, $c: [b,d]$, $d: [e]$, $e: [h]$, $f: [g]$, $g: [c,h]$, $h: [d,f]$. Uret tæller op ved opdagelse og afslutning; ved hver opdagelse vælges den mindste hvide ud-nabo.

      ```
      tid  handling                 stak (bund -> top)     note
       1   opdag a, a.d=1           [a]                    a's mindste hvide: b
       2   a -> b, opdag            [a,b]                  b: [g]
       3   b -> g, opdag            [a,b,g]                g: [c,h], mindste c
       4   g -> c, opdag            [a,b,g,c]              c: [b,d], b grå -> d
       5   c -> d, opdag            [a,b,g,c,d]            d: [e]
       6   d -> e, opdag            [a,b,g,c,d,e]          e: [h]
       7   e -> h, opdag            [a,b,g,c,d,e,h]        h: [d,f], d grå -> f
       8   h -> f, opdag            [a,b,g,c,d,e,h,f]      f: [g], g grå -> ingen hvid
      ```

    + *Opfoldning.* $f$ har kun $g$ (grå), så $f$ afsluttes. Hver pop'et knude finder kun grå/sorte ud-naboer:

      ```
      tid  handling                 stak (bund -> top)
       9   afslut f, f.f=9          [a,b,g,c,d,e,h]
      10   afslut h, h.f=10         [a,b,g,c,d,e]
      11   afslut e, e.f=11         [a,b,g,c,d]
      12   afslut d, d.f=12         [a,b,g,c]
      13   afslut c, c.f=13         [a,b,g]
      14   afslut g, g.f=14         [a,b]
      15   afslut b, b.f=15         [a]          a's rest e,f er sorte
      16   afslut a, a.f=16         []
      ```

      Alle otte hjørner nås fra $a$, så hovedløkken finder ingen flere uopdagede hjørner — der er kun ét DFS-træ.

    + *Tidsstempler:*
      #eq[$ a: 1\/16, space b: 2\/15, space g: 3\/14, space c: 4\/13, space d: 5\/12, space e: 6\/11, space h: 7\/10, space f: 8\/9. $]
  ],
)

#qcard(
  tag: [BFS + DFS på rettet graf (DFS)],
  source: "jun 2016, Problem 6 (a,b)",
  theory: <th-graph-dfs>,
  prompt: [
    Rettet graf $G 1$ med ud-nabolister (alfabetisk sorteret, kun disse kanter må følges):
    #swap[$a: \[b\], space b: \[c\,e\], space c: \[d\,f\], space d: \[ \], space e: \[a\,f\], space f: \[b\,g\,h\], space g: \[c\,i\], space h: \[e\,i\], space i: \[f\,j\], space j: \[h\]$.]
    *(a)* Kør BFS fra $a$: angiv dequeue-rækkefølge og endelig $v.d$ (afstand fra $a$). \
    *(b)* Kør DFS fra $a$: angiv discovery-tid $v.d$ og finish-tid $v.f$.
  ],
  answer: [(a) Dequeue: $a, b, c, e, d, f, g, h, i, j$; afstande $a 0, b 1, c 2, e 2, d 3, f 3, g 4, h 4, i 5, j 6$. (b) $a: 1\/20, b: 2\/19, c: 3\/18, d: 4\/5, f: 6\/17, g: 7\/16, i: 8\/15, j: 9\/14, h: 10\/13, e: 11\/12$.],
  blueprint: [
    + *BFS.* Enqueue start med $d = 0$. Dequeue gentaget $u$, og for hver ubesøgt ud-nabo $v$ (alfabetisk): $v.d = u.d + 1$, marker besøgt, enqueue. Dequeue-rækkefølgen er besøgsrækkefølgen.
    + *DFS.* Globalt ur fra 0. Ved første besøg: $v.d = $ ++ur; rekursér ned i ubesøgte ud-naboer alfabetisk; ved retur: $v.f = $ ++ur. Følg kun kanter i pilens retning.
  ],
  worked: [
    + *(a) BFS fra $a$.* FIFO-kø; $d[a] = 0$. Hver dequeue gennemgår ud-naboerne alfabetisk og enqueuer de uset:

      ```
      deq  u  d[u]  nye naboer (d=d[u]+1)        kø efter (front -> bag)
       1   a   0    b(1)                          [b]
       2   b   1    c(2), e(2)                     [c,e]
       3   c   2    d(3), f(3)                     [e,d,f]
       4   e   2    a set, f set                   [d,f]
       5   d   3    (ingen ud-kanter)              [f]
       6   f   3    b set, g(4), h(4)              [g,h]
       7   g   4    c set, i(5)                     [h,i]
       8   h   4    e set, i set                    [i]
       9   i   5    f set, j(6)                     [j]
      10   j   6    h set                           []
      ```

      Dequeue-rækkefølge $a, b, c, e, d, f, g, h, i, j$; afstande $a 0, b 1, c 2, e 2, d 3, f 3, g 4, h 4, i 5, j 6$.

    + *(b) DFS fra $a$.* Uret tæller op ved opdagelse og afslutning; mindste hvide ud-nabo vælges. Bemærk at $d$ ingen ud-kanter har, så $d$ afsluttes straks ved tid 5 — DFS-træet fortsætter derefter fra $c$'s næste nabo $f$:

      ```
      tid  handling                 stak (bund -> top)
       1   opdag a, a.d=1           [a]            a:[b]
       2   a -> b, opdag            [a,b]          b:[c,e]
       3   b -> c, opdag            [a,b,c]        c:[d,f]
       4   c -> d, opdag            [a,b,c,d]      d:[] ingen hvid
       5   afslut d, d.f=5          [a,b,c]        c's næste: f
       6   c -> f, opdag            [a,b,c,f]      f:[b,g,h], b grå -> g
       7   f -> g, opdag            [a,b,c,f,g]    g:[c,i], c grå -> i
       8   g -> i, opdag            [a,b,c,f,g,i]  i:[f,j], f grå -> j
       9   i -> j, opdag            [a,b,c,f,g,i,j] j:[h]
      10   j -> h, opdag            [a,b,c,f,g,i,j,h] h:[e,i], i grå -> e
      11   h -> e, opdag            [...,h,e]      e:[a,f], begge grå
      12   afslut e, e.f=12         [a,b,c,f,g,i,j,h]
      13   afslut h, h.f=13         [a,b,c,f,g,i,j]
      14   afslut j, j.f=14         [a,b,c,f,g,i]
      15   afslut i, i.f=15         [a,b,c,f,g]
      16   afslut g, g.f=16         [a,b,c,f]
      17   afslut f, f.f=17         [a,b,c]
      18   afslut c, c.f=18         [a,b]          b's rest e er sort
      19   afslut b, b.f=19         [a]
      20   afslut a, a.f=20         []
      ```

      Tidsstempler:
      #eq[$ a: 1\/20, space b: 2\/19, space c: 3\/18, space d: 4\/5, space f: 6\/17, space g: 7\/16, space i: 8\/15, space j: 9\/14, space h: 10\/13, space e: 11\/12. $]
  ],
)

#qcard(
  tag: [BFS på rettet graf (BFS)],
  source: "DM507 juni 2013, Opg. 4a (10%)",
  theory: <th-graph-bfs>,
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
    + *BFS fra $a$.* FIFO-kø; $d[a] = 0$. Ud-naboer: $a: [i]$, $b: [a,c]$, $c: [d,i]$, $d: []$, $e: [d,i]$, $f: [e,i]$, $g: [f,i]$, $h: [a,g]$, $i: [b,d,h]$. Hver dequeue gennemgår sin liste alfabetisk og enqueuer de uset:

      ```
      deq  u  d[u]  nye naboer (d=d[u]+1)        kø efter (front -> bag)
       1   a   0    i(1)                          [i]
       2   i   1    b(2), d(2), h(2)              [b,d,h]
       3   b   2    a set, c(3)                    [d,h,c]
       4   d   2    (ingen ud-kanter)             [h,c]
       5   h   2    a set, g(3)                    [c,g]
       6   c   3    d set, i set                   [g]
       7   g   3    f(4), i set                    [f]
       8   f   4    e(5), i set                    [e]
       9   e   5    d set, i set                   []
      ```

    + Dequeue-rækkefølge $a, i, b, d, h, c, g, f, e$; afstande
      #eq[$ a 0, space i 1, space b 2, space d 2, space h 2, space c 3, space g 3, space f 4, space e 5. $]
  ],
)

#qcard(
  tag: [Stærkt sammenhængende komponenter (SCC) (Kosaraju)],
  source: "DM02 januar 2005, Opg. 3 (25%)",
  theory: <th-graph-scc>,
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
    + *Ud-nabolister på $G$* (alfabetisk): $A: [E]$, $B: [C,E]$, $C: [D,G,L]$, $D: []$, $E: [A,I]$, $F: [B,E,J]$, $G: [F,K]$, $H: [C,D,G]$, $I: [J]$, $J: [N]$, $K: [J]$, $L: [H]$, $M: [I,J]$, $N: [K,M]$.

    + *Første DFS på $G$,* ét ur der tæller op ved push (pre) og pop (post). Hovedløkken starter i $A$ og fortsætter alfabetisk på resterende uopdagede hjørner. Stakken vist bund $->$ top:

      ```
      tid  handling           stak                       note
       1   push A  A.pre=1     [A]                        A:[E]
       2   push E  E.pre=2     [A,E]                      E:[A,I], A grå -> I
       3   push I  I.pre=3     [A,E,I]                    I:[J]
       4   push J  J.pre=4     [A,E,I,J]                  J:[N]
       5   push N  N.pre=5     [A,E,I,J,N]                N:[K,M] -> K
       6   push K  K.pre=6     [A,E,I,J,N,K]              K:[J], J grå
       7   pop  K  K.post=7    [A,E,I,J,N]                N's næste: M
       8   push M  M.pre=8     [A,E,I,J,N,M]              M:[I,J] begge grå
       9   pop  M  M.post=9    [A,E,I,J,N]
      10   pop  N  N.post=10   [A,E,I,J]
      11   pop  J  J.post=11   [A,E,I]
      12   pop  I  I.post=12   [A,E]
      13   pop  E  E.post=13   [A]                        E's rest A er grå
      14   pop  A  A.post=14   []                         A-træet færdigt
      15   push B  B.pre=15    [B]                        ny rod B:[C,E]
      16   push C  C.pre=16    [B,C]                      C:[D,G,L] -> D
      17   push D  D.pre=17    [B,C,D]                    D:[] ingen
      18   pop  D  D.post=18   [B,C]                      C's næste: G
      19   push G  G.pre=19    [B,C,G]                    G:[F,K] -> F
      20   push F  F.pre=20    [B,C,G,F]                  F:[B,E,J] alle ikke-hvide
      21   pop  F  F.post=21   [B,C,G]
      22   pop  G  G.post=22   [B,C]                      G's rest K er sort
      23   push L  L.pre=23    [B,C,L]                    C's næste: L; L:[H]
      24   push H  H.pre=24    [B,C,L,H]                  H:[C,D,G] alle ikke-hvide
      25   pop  H  H.post=25   [B,C,L]
      26   pop  L  L.post=26   [B,C]
      27   pop  C  C.post=27   [B]
      28   pop  B  B.post=28   []                         B's rest E er sort
      ```

      Pre/post:
      #eq[$ A: 1\/14, space E: 2\/13, space I: 3\/12, space J: 4\/11, space N: 5\/10, space K: 6\/7, space M: 8\/9, $]
      #eq[$ B: 15\/28, space C: 16\/27, space D: 17\/18, space G: 19\/22, space F: 20\/21, space L: 23\/26, space H: 24\/25. $]

    + *Aftagende finish (post):* $B(28), C(27), L(26), H(25), G(22), F(21), D(18), A(14), E(13), I(12), J(11), N(10), M(9), K(7)$.

    + *Transponaten $G^T$* (alle kanter vendt), in-naboer som nye ud-lister: $A: [E]$, $B: [F]$, $C: [B,H]$, $D: [C,H]$, $E: [A,B,F]$, $F: [G]$, $G: [C,H]$, $H: [L]$, $I: [E,M]$, $J: [F,I,K,M]$, $K: [G,N]$, $L: [C]$, $M: [N]$, $N: [J]$.

    + *Andet DFS på $G^T$,* rødder valgt i aftagende første-DFS-finish. Hvert træ er én SCC:

      ```
      rod  forløb (kun hvide følges)              SCC
      B    B -> F -> G -> C -> H -> L (L->C grå)  {B,C,F,G,H,L}
      D    D: C,H allerede besøgt                 {D}
      A    A -> E (E->A grå; B,F besøgt)          {A,E}
      I    I -> M -> N -> J -> K (K->N grå)       {I,J,K,M,N}
      ```

      Resten af rækkefølgen ($C, L, H, G, F, E, J, N, M, K$) er allerede opdaget, når deres tur kommer, så de starter ingen nye træer. Fire SCC'er: ${B,C,F,G,H,L}$, ${D}$, ${A,E}$, ${I,J,K,M,N}$.

    + *(b) $G'$:* fire hjørner $B C F G H L, D, A E, I J K M N$. Kryds-kanter (kanter i $G$ mellem to forskellige SCC'er): $C->D$ giver $B C F G H L -> D$; $B->E$ og $F->E$ giver $B C F G H L -> A E$; $G->K$ giver $B C F G H L -> I J K M N$; $E->I$ giver $A E -> I J K M N$.

    + *(c)* Orden $B C F G H L, D, A E, I J K M N$. Alle fire kanter peger fremad i listen, så det er en gyldig topologisk sortering. ($D$ og $A E$ er usammenlignelige, så $B C F G H L, A E, D, I J K M N$ virker også.)
  ],
)

#qcard(
  tag: [Todelt graf (bipartit): genkend + BFS-test],
  source: "DM507 januar 2007, Opg. 4 (20%)",
  theory: <th-graph-bfs>,
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
    + *(a)(i)* Pentagon $C_5$ med hjørner $1-2-3-4-5-1$. BFS-2-farvning fra $1$ (farve = afstand mod 2):

      ```
      hjørne  afstand  farve   konflikt?
        1        0      X
        2        1      Y      kant (1,2): X-Y ok
        5        1      Y      kant (1,5): X-Y ok
        3        2      X      kant (2,3): Y-X ok
        4        2      X      kant (5,4): Y-X ok
                               kant (3,4): X-X  <- KONFLIKT
      ```

      Den lukkende kant $(3,4)$ forbinder to $X$-hjørner, så farvningen fejler: $C_5$ har en ulige kreds (længde 5) og er *ikke* bipartit.

    + *(a)(ii)* Firkant $C_4$ med hjørner $1-2-3-4-1$. BFS-2-farvning fra $1$:

      ```
      hjørne  afstand  farve   konflikt?
        1        0      X
        2        1      Y      kant (1,2): X-Y ok
        4        1      Y      kant (1,4): X-Y ok
        3        2      X      kant (2,3): Y-X ok
                               kant (4,3): Y-X ok
      ```

      Ingen konflikt: $C_4$ er bipartit med $X = {1, 3}$ (modstående hjørner), $Y = {2, 4}$.

    + *(a)(iii)* Naboer: $T: [B R]$, $L: [R, B R]$, $R: [L, B L]$, $B L: [R, B R]$, $B R: [T, B L, L]$. BFS-2-farvning fra $T$:

      ```
      hjørne  afstand  farve   kanttjek
        T       0       X
        BR      1       Y      (T,BR): X-Y ok
        BL      2       X      (BR,BL): Y-X ok
        L       2       X      (BR,L): Y-X ok
        R       3       Y      (BL,R): X-Y ok; (L,R): X-Y ok; (R,BL): Y-X ok
      ```

      Ingen kant forbinder to ens farver, så grafen er bipartit. $T$ rører kun $B R$ (grad 1), og $L, R, B L, B R$ danner 4-kredsen $L - R - B L - B R - L$ — en lige kreds plus et pendant-hjørne, altså ingen ulige kreds. 2-deling: $X = {T, L, B L}$, $Y = {R, B R}$.

    + *(c)($=>$)* Bipartit $=>$ ingen ulige kreds. Langs enhver kreds krydser hver kant mellem $X$ og $Y$, så siden veksler $X, Y, X, Y, ...$. For at vende tilbage til startsiden efter $k$ skridt må $k$ være lige. Altså er enhver kreds lige.

    + *(c)($<==$)* Ingen ulige kreds $=>$ bipartit. Arbejd pr. sammenhængskomponent. Kør BFS fra $s$, farv efter afstands-paritet. Hvis en kant $(u,v)$ forbandt to lige-paritets-hjørner, ville træstierne $w -> u$ og $w -> v$ fra deres laveste fælles forfader $w$ have samme paritet, så $(u,v)$ lukkede en ulige kreds — modstrid. Paritetsfarvningen er derfor en gyldig 2-deling.
  ],
)
