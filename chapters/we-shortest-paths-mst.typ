#import "../lib.typ": *

=== Korteste veje og minimumsudspændende træer (skriftlig eksamen)

De skriftlige opgaver her falder i to slags. Den ene er korteste veje (shortest paths) fra en kilde, hvor du enten skal vælge den simplest mulige algoritme til en given graf eller køre Bellman-Ford eller Dijkstra igennem. Den anden er minimumsudspændende træer (minimum spanning trees) med Kruskal eller Prim, hvor union-find (union-find) holder styr på, hvilke knuder der allerede hænger sammen. Graferne står som kantlister (edge lists), præcis som de gives i opgaven.

#qcard(
  tag: [Korteste vej: vælg simpleste algoritme (Dijkstra)],
  source: "DM507 juni 2009, Opg. 3 (20%)",
  theory: <th-sp-dijkstra>,
  prompt: [
    For hver af tre rettede grafer $G_1, G_2, G_3$ med kilde $s$: angiv den #emph[simplest mulige] algoritme til korteste veje fra $s$ til alle knuder, begrund valget, og giv alle afstande. Knuderne i et $3 times 3$-gitter hedder $v_(r c)$, $s = v_00$.

    *$G_1$* (alle kanter vægt 1): #swap[$s arrow.r 01, 02 arrow.r 01, 10 arrow.r 00, 10 arrow.r 20, 10 arrow.r 21, 01 arrow.r 11, 01 arrow.r 12, 12 arrow.r 02, 12 arrow.r 22, 11 arrow.r 10, 11 arrow.r 12, 21 arrow.r 11, 20 arrow.r 21, 22 arrow.r 21$]. \
    *$G_2$* (negative vægte, men en DAG): #swap[$s arrow.r 01(3), 01 arrow.r 02(-5), s arrow.r 10(1), 01 arrow.r 11(-5), 01 arrow.r 12(2), 02 arrow.r 12(4), 10 arrow.r 11(1), 11 arrow.r 12(1), 10 arrow.r 20(4), 10 arrow.r 21(-2), 11 arrow.r 21(2), 12 arrow.r 22(2), 20 arrow.r 21(1), 21 arrow.r 22(3)$]. \
    *$G_3$* (ikke-negative vægte, har cykler): #swap[$s arrow.r 01(1), 01 arrow.r 02(3), s arrow.r 10(2), 01 arrow.r 11(2), 12 arrow.r 01(1), 02 arrow.r 12(4), 11 arrow.r 10(5), 11 arrow.r 12(5), 10 arrow.r 20(2), 21 arrow.r 10(1), 21 arrow.r 11(2), 12 arrow.r 22(4), 20 arrow.r 21(1), 21 arrow.r 22(2)$].
  ],
  answer: [$G_1$: BFS, afstande $0,1,3,3,2,2,4,4,3$. $G_2$: relaksér i topologisk orden, $0,3,-2,1,-2,-1,5,-1,1$. $G_3$: Dijkstra, $0,1,4,2,3,8,4,5,7$ (rækkefølge $v_00, v_01, ...$).],
  blueprint: [
    Match grafens vægte og struktur mod den letteste algoritme der stadig er korrekt.

    + Alle kanter samme vægt (eller uvægtet)? → *BFS* (breadth-first search), $O(V+E)$. Hvert lag er én afstandsenhed.
    + Negative vægte, men acyklisk (DAG, directed acyclic graph)? → relaksér (relax) kanterne i *topologisk orden* (topological order), $O(V+E)$. Ét gennemløb er nok, og negative vægte er fine. Dijkstra ville være #emph[forkert] her.
    + Ikke-negative vægte, men cykler (cycles)? → *Dijkstra*, $O((V+E) log V)$ med binær hob (binary heap).
    + Negative vægte #emph[og] cykler? → Bellman-Ford.
  ],
  worked: [
    + *$G_1$* — alle kanter har vægt 1, så afstanden er bare antal kanter: brug *BFS*. Lag for lag fra $s = v_00$, hvor hvert nyt lag er ét længere væk:

      ```
      Lag 0:  {00}                  00=0
      Lag 1:  {01}                  s->01            => 01=1
      Lag 2:  {11, 12}              01->11, 01->12   => 11=2, 12=2
      Lag 3:  {10, 02, 22}          11->10, 12->02,
                                    12->22           => 10=3, 02=3, 22=3
      Lag 4:  {20, 21}              10->20, 10->21   => 20=4, 21=4
      ```
      ($v_00$ nås igen via $10 arrow.r 00$, men ligger allerede på lag 0; $11 arrow.r 12$ rammer en allerede besøgt knude.) Afstande:
      #eq[$ v_00=0, v_01=1, v_02=3, v_10=3, v_11=2, v_12=2, v_20=4, v_21=4, v_22=3. $]

    + *$G_2$* — negative vægte, men acyklisk: relaksér i *topologisk orden* $v_00, v_01, v_02, v_10, v_11, v_12, v_20, v_21, v_22$. Ét gennemløb er nok. For hver knude tager vi minimum over alle indkommende kanter:

      ```
      00:  kilde                                          d=0
      01:  s->01 = 0+3                                    d=3
      02:  01->02 = 3+(-5)                                d=-2
      10:  s->10 = 0+1                                    d=1
      11:  min( 01->11=3-5=-2 , 10->11=1+1=2 )            d=-2
      12:  min( 01->12=3+2=5 , 02->12=-2+4=2 ,
               11->12=-2+1=-1 )                           d=-1
      20:  10->20 = 1+4                                   d=5
      21:  min( 10->21=1-2=-1 , 11->21=-2+2=0 ,
               20->21=5+1=6 )                             d=-1
      22:  min( 12->22=-1+2=1 , 21->22=-1+3=2 )           d=1
      ```
      Afstande:
      #eq[$ 0, 3, -2, 1, -2, -1, 5, -1, 1. $]

    + *$G_3$* — ikke-negative vægte med cykler, så *Dijkstra* (BFS dur ikke, vægtene er forskellige; topo-orden dur ikke, der er cykler). $d$ er afstandsfeltet, og hver Extract-Min gør en knude endelig:

      ```
      d-array (oo = uendelig); fed = netop trukket
      init:    00=0   resten oo
      ext 00:  01=1, 10=2
      ext 01:  02=4, 11=3
      ext 10:  20=4
      ext 11:  12=8         (10 via 5 ikke bedre end 2)
      ext 02:  12=8         (0+3+4 = 8, uændret)
      ext 20:  21=5
      ext 21:  22=7         (10,11 allerede endelige)
      ext 12:  22=7         (8+4=12 ikke bedre)
      ext 22:  færdig
      ```
      Trække-rækkefølge: $00,01,10,11,02,20,21,12,22$. Afstande i orden $v_00,v_01,...$:
      #eq[$ 0, 1, 4, 2, 3, 8, 4, 5, 7. $]
  ],
)

#qcard(
  tag: [Korteste vej: vælg simpleste algoritme (Dijkstra)],
  source: "DM507 juni 2011, Opg. 4 (18%)",
  theory: <th-sp-dijkstra>,
  prompt: [
    For tre rettede vægtede grafer med kilde $s$ og mål $t$: afgør for hver algoritme (BFS, DAG-Shortest-Paths, Dijkstra) om den korrekt beregner afstanden $s arrow.r t$.

    *$G_1$*: #swap[$s arrow.r a(1), a arrow.r b(1), s arrow.r b(1), b arrow.r t(1)$] — alle vægte 1, acyklisk. \
    *$G_2$*: #swap[$s arrow.r a(10), a arrow.r t(1), s arrow.r b(1), b arrow.r a(1), a arrow.r c(1), c arrow.r b(1)$] — alle vægte $>= 0$, cykel $a arrow.r c arrow.r b arrow.r a$. \
    *$G_3$*: #swap[$s arrow.r a(6), a arrow.r c(-3), s arrow.r c(10), s arrow.r b(2), b arrow.r c(2), c arrow.r t(1)$] — negativ kant $-3$, acyklisk.
  ],
  answer: [BFS: kun $G_1$. DAG-Shortest-Paths: $G_1$ og $G_3$. Dijkstra: $G_1$ og $G_2$.],
  blueprint: [
    Tjek hver algoritmes #emph[forudsætning] mod hver graf og sæt flueben hvor den holder.

    + *BFS* er korrekt netop når alle kanter har #emph[samme] vægt (den tæller kanter).
    + *DAG-Shortest-Paths* kræver at grafen er #emph[acyklisk]; negative vægte er fine.
    + *Dijkstra* kræver alle vægte $>= 0$; cykler er fine.
  ],
  worked: [
    Først aflæses hver grafs egenskaber, så holdes de op mod hver algoritmes forudsætning:

    ```
    graf  alle vægte ens?   acyklisk?   alle vægte >=0?
    G1    ja (alle = 1)     ja          ja
    G2    nej (10 og 1)     nej (a->c->b->a)   ja
    G3    nej (6,-3,...)    ja          nej (a->c = -3)
    ```

    + *BFS* kræver ens vægte (den tæller kanter): $G_1$ ja; $G_2$ nej (10 og 1); $G_3$ nej (blandede). → *kun $G_1$*.
    + *DAG-Shortest-Paths* kræver acyklisk graf (negative vægte er fine): $G_1$ ja; $G_2$ nej (cyklen $a arrow.r c arrow.r b arrow.r a$); $G_3$ ja (den negative kant $-3$ er tilladt). → *$G_1, G_3$*.
    + *Dijkstra* kræver vægte $>= 0$ (cykler er fine): $G_1$ ja; $G_2$ ja (cyklen gør ikke noget); $G_3$ nej ($a arrow.r c = -3 < 0$). → *$G_1, G_2$*.
  ],
)

#qcard(
  tag: [Bellman-Ford afstande (Bellman-Ford)],
  source: "DM507 juni 2012, Opg. 4a (10%)",
  theory: <th-sp-bellman-ford>,
  prompt: [
    Kør Bellman-Ford fra $a$ på den rettede graf og giv $v.d$ for hver knude. Kanter:
    #swap[$a arrow.r e(8), a arrow.r f(10), a arrow.r b(17), e arrow.r h(-4), f arrow.r h(-10), f arrow.r g(25), g arrow.r h(-12), g arrow.r c(-3), b arrow.r g(-5), c arrow.r b(19), c arrow.r d(2), d arrow.r e(6), h arrow.r d(1)$].]
  ,
  answer: [$a{=}0, b{=}17, c{=}9, d{=}1, e{=}7, f{=}10, g{=}12, h{=}0$. Ingen negativ cykel nås fra $a$.],
  blueprint: [
    + Sæt $v.d = oo$ for alle, $s.d = 0$.
    + Relaksér #emph[hver] kant, $|V| - 1$ gange: hvis $u.d + w(u,v) < v.d$, sæt $v.d = u.d + w(u,v)$.
    + Ét ekstra gennemløb opdager en negativ cykel (negative cycle) (en kant kan stadig relakseres) — ellers er $v.d$ endelige.
  ],
  worked: [
    Init $a.d = 0$, resten $oo$, alle forgængere $pi{=}-$. Relaksér så alle 13 kanter i den givne rækkefølge $|V|-1 = 7$ gange. En kant $(u,v,w)$ relakserer, hvis $u.d + w < v.d$; så sættes $v.d$ og $pi[v]=u$. Her er hvert enkelt relaksation i gennemløb 1, hvor $d$-feltet udvikler sig undervejs ($oo$ = uendelig):

    ```
    Gennemløb 1 (d-felt opdateres straks)
                          a   b   c   d   e   f   g   h
    start                 0   oo  oo  oo  oo  oo  oo  oo
    a->e (0+8=8)          0   .   .   .   8   .   .   .   pi e=a
    a->f (0+10=10)        0   .   .   .   8  10   .   .   pi f=a
    a->b (0+17=17)        0   17  .   .   8  10   .   .   pi b=a
    e->h (8-4=4)          0   17  .   .   8  10   .   4   pi h=e
    f->h (10-10=0<4)      0   17  .   .   8  10   .   0   pi h=f
    f->g (10+25=35)       0   17  .   .   8  10  35   0   pi g=f
    g->h (35-12=23>0)     -   ingen
    g->c (35-3=32)        0   17  32  .   8  10  35   0   pi c=g
    b->g (17-5=12<35)     0   17  32  .   8  10  12   0   pi g=b
    c->b (32+19=51>17)    -   ingen
    c->d (32+2=34)        0   17  32  34  8  10  12   0   pi d=c
    d->e (34+6=40>8)      -   ingen
    h->d (0+1=1<34)       0   17  32  1   8  10  12   0   pi d=h
    ```

    Tilstanden efter hvert fuldt gennemløb:

    ```
              a    b    c    d    e    f    g    h
    init      0    oo   oo   oo   oo   oo   oo   oo
    pass 1    0    17   32   1    8    10   12   0
    pass 2    0    17   9    1    7    10   12   0
    pass 3    0    17   9    1    7    10   12   0   (ingen ændring)
    ```

    Ændringerne i gennemløb 2: $g arrow.r c$ giver $c = 12{-}3 = 9$ (slår $32$), $pi c=g$; og $d arrow.r e$ giver $e = 1{+}6 = 7$ (slår $a arrow.r e = 8$), $pi e=d$. Gennemløb 3 relakserer ingen kant.

    Forgængere ved afslutning og de realiserende veje:
    - $pi f=a$: $a arrow.r f$ ($f{=}10$).
    - $pi h=f$: $a arrow.r f arrow.r h$ ($h{=}0$).
    - $pi b=a$: $a arrow.r b$ ($b{=}17$).
    - $pi g=b$: $a arrow.r b arrow.r g$ ($g{=}12$).
    - $pi c=g$: $a arrow.r b arrow.r g arrow.r c$ ($c{=}9$).
    - $pi d=h$: $a arrow.r f arrow.r h arrow.r d$ ($d{=}1$).
    - $pi e=d$: $a arrow.r f arrow.r h arrow.r d arrow.r e$ ($e{=}7$).

    Et ekstra (8.) gennemløb relakserer ingen kant, så ingen negativ cykel er nåelig fra $a$, og afstandene er endelige:
    #eq[$ a{=}0, quad b{=}17, quad c{=}9, quad d{=}1, quad e{=}7, quad f{=}10, quad g{=}12, quad h{=}0. $]
  ],
)

#qcard(
  tag: [Dijkstra: Extract-Min-orden + afstande (Dijkstra)],
  source: "DM507 juni 2013, Opg. 4b (10%)",
  theory: <th-sp-dijkstra>,
  prompt: [
    Kør Dijkstra fra $a$ på den rettede graf $G_2$. Giv Extract-Min-rækkefølgen og endelige $v.d$. Kanter (ring + eger):
    #swap[$h arrow.r a(8), b arrow.r a(4), h arrow.r g(9), b arrow.r c(2), g arrow.r f(10), c arrow.r d(11), f arrow.r e(15), e arrow.r d(21)$; $a arrow.r i(7), i arrow.r h(17), i arrow.r b(6), g arrow.r i(13), c arrow.r i(22), f arrow.r i(5), e arrow.r i(14), i arrow.r d(18)$].]
  ,
  answer: [Extract-Min: $a, i, b, c, h, d, g, f, e$. Afstande $a{=}0, i{=}7, b{=}13, c{=}15, h{=}24, d{=}25, g{=}33, f{=}43, e{=}58$.],
  blueprint: [
    + $d[a] = 0$, resten $oo$.
    + Extract-Min: træk den ufærdige knude $u$ med mindst $d$, gør den endelig.
    + Relaksér hver ud-kant $(u,v,w)$: hvis $d[u] + w < d[v]$, sæt $d[v] = d[u] + w$.
    + Extract-Min-rækkefølgen $=$ rækkefølgen knuderne gøres endelige.
  ],
  worked: [
    Init $d[a]{=}0$, resten $oo$, alle $pi{=}-$. Køen indeholder alle 9 knuder. Hver linje viser den netop trukne knude (fed), $d$-feltet og forgænger-feltet $pi$ bagefter, samt prioritetskøens indhold (de endnu ufærdige knuder med endelig nøgle):

    ```
    d/pi efter hver Extract-Min  (oo = uendelig, [..] = kø-nøgler)

    trukket   a  i  b  c  h  d  g  f  e    PQ (key)
    init      0  oo oo oo oo oo oo oo oo   {alle oo}
    EXT a=0   0  7  oo oo oo oo oo oo oo   [i:7]
              pi: i<-a
    EXT i=7   0 [7] 13 oo 24 25 oo oo oo   [b:13, h:24, d:25]
              pi: b<-i, h<-i, d<-i
    EXT b=13  0 [7][13]15 24 25 oo oo oo   [c:15, h:24, d:25]
              pi: c<-b  (b->a=17>0, ingen)
    EXT c=15  0 [7][13][15]24 25 oo oo oo  [h:24, d:25]
              (c->d=26>25, ingen; c->i lukket)
    EXT h=24  0 ...        [24]25 33 oo oo [d:25, g:33]
              pi: g<-h  (h->a lukket)
    EXT d=25  0 ...            [25]33 oo oo[g:33]
              (d har ingen ud-kanter)
    EXT g=33  0 ...                [33]43 oo[f:43]
              pi: f<-g  (g->i lukket)
    EXT f=43  0 ...                    [43]58[e:58]
              pi: e<-f  (f->i lukket)
    EXT e=58  0 ...                        [58] {}
              (e->d, e->i begge lukket)
    ```

    Bemærk at $c arrow.r d = 15{+}11 = 26$ ikke slår det tidligere $d{=}25$ (sat fra $i arrow.r d$), så $d$ beholder forgænger $i$. Extract-Min-rækkefølgen er rækkefølgen knuderne lukkes:
    #eq[$ a, i, b, c, h, d, g, f, e. $]
    Endelige $v.d$:
    #eq[$ a{=}0, quad i{=}7, quad b{=}13, quad c{=}15, quad h{=}24, quad d{=}25, quad g{=}33, quad f{=}43, quad e{=}58. $]
  ],
)

#qcard(
  tag: [Dijkstra: Extract-Min-orden + afstande (Dijkstra)],
  source: "jun 2016, Problem 6c (7%)",
  theory: <th-sp-dijkstra>,
  prompt: [
    Kør Dijkstra fra $a$ på den rettede vægtede graf $G_2$ (triangulært gitter; følg kun pile i deres retning). Giv Extract-Min-rækkefølge og endelige $v.d$. Kanter:
    #swap[$a arrow.r b(6), b arrow.r c(9), c arrow.r d(2); e arrow.r f(21), f arrow.r g(19), h arrow.r i(17); j arrow.r h(1), h arrow.r e(14), e arrow.r a(13); i arrow.r j(12), g arrow.r i(4), d arrow.r g(5); b arrow.r e(8), f arrow.r h(15); i arrow.r f(3), g arrow.r c(7); c arrow.r f(16), f arrow.r b(11)$].]
  ,
  answer: [Extract-Min: $a, b, e, c, d, g, i, f, j, h$. Afstande $a{=}0, b{=}6, c{=}15, d{=}17, e{=}14, f{=}29, g{=}22, h{=}39, i{=}26, j{=}38$.],
  blueprint: [
    + $d[a] = 0$, resten $oo$.
    + Extract-Min den ufærdige knude med mindst $d$, gør den endelig.
    + Relaksér kun #emph[ud]-kanter $(u,v)$: hvis $d[u] + w(u,v) < d[v]$, opdatér $d[v]$. Grafen er rettet.
  ],
  worked: [
    Init $d[a]{=}0$, resten $oo$, $pi{=}-$. Hver Extract-Min lukker en knude (fed), relakserer dens ud-kanter og opdaterer $d$ og $pi$. Kolonnerne er $d$-værdierne; under hver linje står de forgængere der blev sat, og prioritetskøens åbne nøgler:

    ```
    trukket    a  b  c  d  e  f  g  h  i  j
    init       0  oo oo oo oo oo oo oo oo oo   PQ {oo}
    EXT a=0    0   6 oo oo oo oo oo oo oo oo   b<-a        [b:6]
    EXT b=6    0  [6] 15 oo 14 oo oo oo oo oo  c<-b,e<-b   [e:14,c:15]
    EXT e=14   0  .  15 oo[14]35 oo oo oo oo   f<-e        [c:15,f:35]
                                               (e->a=27>0 lukket)
    EXT c=15   0  . [15]17 . 31 oo oo oo oo    d<-c, f<-c (31<35) [d:17,f:31]
    EXT d=17   0  .  . [17]. 31 22 oo oo oo    g<-d        [g:22,f:31]
    EXT g=22   0  .  .  .  . 31[22]oo 26 oo    i<-g        [i:26,f:31]
                                               (g->c=29>15 lukket)
    EXT i=26   0  .  .  .  . 29 . oo[26]38     f<-i(29<31),j<-i [f:29,j:38]
    EXT f=29   0  .  .  .  .[29]. 44 .  38     h<-f        [j:38,h:44]
                                               (f->g,f->b lukket)
    EXT j=38   0  .  .  .  .  . . 39 . [38]    h<-j(39<44) [h:39]
    EXT h=39   0  .  .  .  .  . .[39]. .       {}  (h->i,h->e lukket)
    ```

    De afgørende relaksationer hvor en kortere vej slår en tidligere: $f$ falder fra $35$ ($e arrow.r f$) til $31$ ($c arrow.r f$) til $29$ ($i arrow.r f$); $h$ falder fra $44$ ($f arrow.r h$) til $39$ ($j arrow.r h$). Extract-Min-rækkefølge:
    #eq[$ a(0), b(6), e(14), c(15), d(17), g(22), i(26), f(29), j(38), h(39). $]
    Endelige $v.d$:
    #eq[$ a{=}0, b{=}6, c{=}15, d{=}17, e{=}14, f{=}29, g{=}22, h{=}39, i{=}26, j{=}38. $]
  ],
)

#qcard(
  tag: [Dijkstra: korteste-vej-træ fra kilden (korteste-vej-træ)],
  source: "DM507 jan 2008, Opg. 2c (8%)",
  theory: <th-sp-dijkstra>,
  prompt: [
    Kør Dijkstra fra $s$ og angiv korteste-vej-træet (shortest-path tree) (forgænger-kanterne) samt afstanden fra $s$ til hver knude. Uorienterede vægtede kanter:
    #swap[$s{-}A{=}1, s{-}B{=}12, A{-}B{=}13, B{-}C{=}30, B{-}G{=}5, P{-}Q{=}9, P{-}R{=}10, Q{-}R{=}2, R{-}C{=}8, R{-}D{=}15, C{-}D{=}7, C{-}G{=}17, D{-}E{=}3, D{-}F{=}11, E{-}F{=}14, G{-}H{=}8, G{-}I{=}4, H{-}I{=}6, F{-}I{=}15$].]
  ,
  answer: [Afstande $A{=}1, B{=}12, G{=}17, I{=}21, H{=}25, C{=}34, F{=}36, D{=}41, R{=}42, Q{=}44, E{=}44, P{=}52$. Træ via forgængere nedenfor.],
  blueprint: [
    + $d[s] = 0$, resten $oo$.
    + Træk den usettlede knude med mindst $d$, settl den, relaksér dens kanter: hvis $d[u] + w < d[v]$, sæt $d[v] = d[u] + w$ og $mono("prev")[v] = u$.
    + Korteste-vej-træet er kanterne $(mono("prev")[v], v)$.
  ],
  worked: [
    Init $d[s]{=}0$, resten $oo$. Hver Extract-Min settler den ufærdige knude med mindst $d$ (fed) og relakserer dens kanter; en forbedring sætter både $d[v]$ og forgængeren $pi[v]$. Tabellen viser $d$ efter hvert settle, og linjen under hver settle angiver de forgængere der blev sat:

    ```
    settle    s  A  B  C  D  E  F  G  H  I  P  Q  R
    init      0  oo oo oo oo oo oo oo oo oo oo oo oo
    s=0       0   1 12 .  .  .  .  .  .  .  .  .  .   A<-s, B<-s
    A=1       0 [1]12 .  .  .  .  .  .  .  .  .  .   (A-B=14>12 ingen)
    B=12      0  . [12]42 .  .  .  17 .  .  .  .  .   C<-B, G<-B
    G=17      0  .  . 34 .  .  . [17]25 21 .  .  .   C<-G(34<42),H<-G,I<-G
    I=21      0  .  . 34 .  . 36  . 25[21].  .  .   F<-I  (I-H=27>25)
    H=25      0  .  . 34 .  . 36  .[25]. .  .  .   (H-I lukket)
    C=34      0  .  .[34]41 . 36  . .  . . . 42   D<-C, R<-C
    F=36      0  .  . . 41 50[36]. .  . . . 42   E<-F  (F-D=47>41)
    D=41      0  .  . . [41]44 . . .  . . . 42   E<-D(44<50)  (D-R=56>42)
    R=42      0  .  . . . 44 . . .  . 52 44[42]  Q<-R, P<-R
    E=44/Q=44 0  .  . . . [44]. . . . 52[44].   (uafgjort; ingen forbedring)
    P=52      0  .  . . . . . . .  .[52]. .   slut
    ```

    Endelig afstand og forgænger (træ-forælder):
    #eq[$
      &A{:}1{<-}s, quad B{:}12{<-}s, quad G{:}17{<-}B, quad I{:}21{<-}G, quad H{:}25{<-}G, \
      &C{:}34{<-}G, quad F{:}36{<-}I, quad D{:}41{<-}C, quad R{:}42{<-}C, quad E{:}44{<-}D, quad Q{:}44{<-}R, quad P{:}52{<-}R.
    $]
    Træ-kanter (rod $s$): $s{-}A, s{-}B, B{-}G, G{-}I, G{-}H, G{-}C, I{-}F, C{-}D, C{-}R, D{-}E, R{-}Q, R{-}P$. Fx slår $s arrow.r B arrow.r G arrow.r C = 34$ den direkte $s arrow.r B arrow.r C = 42$, og $D arrow.r E = 44$ slår $F arrow.r E = 50$. Dijkstra er korrekt fordi alle vægte er $>= 0$: en settlet knudes $d$ er endelig.
  ],
)

#qcard(
  tag: [Dijkstra: korteste-vej-træ fra kilden (korteste-vej-træ)],
  source: "DM02 jan 2006, Opg. 3d (8%)",
  theory: <th-sp-dijkstra>,
  prompt: [
    Kør Dijkstra fra $A$ og angiv korteste-vej-træet samt afstanden fra $A$ til hver knude. Uorienterede vægtede kanter:
    #swap[$A{-}B{=}2, B{-}C{=}7, A{-}D{=}6, B{-}D{=}6, B{-}E{=}5, C{-}F{=}5, D{-}E{=}5, E{-}F{=}1, D{-}G{=}1, D{-}H{=}4, E{-}H{=}3, F{-}I{=}4, H{-}I{=}2$].]
  ,
  answer: [Settle-orden $A, B, D, G, E, F, C, H, I$. Afstande $A{=}0, B{=}2, D{=}6, E{=}7, G{=}7, F{=}8, C{=}9, H{=}10, I{=}12$.],
  blueprint: [
    + $d[A] = 0$, resten $oo$.
    + Træk den usettlede knude med mindst $d$, settl den, relaksér kanterne og sæt forælder $u$ ved forbedring.
    + Forældrene udgør korteste-vej-træet.
  ],
  worked: [
    Init $d[A]{=}0$, resten $oo$. Hvert settle (fed) relakserer kanterne; en forbedring sætter $d[v]$ og forælder $pi[v]$. $d$ efter hvert settle, med de satte forældre under linjen:

    ```
    settle   A  B  C  D  E  F  G  H  I
    init     0  oo oo oo oo oo oo oo oo
    A=0      0   2 oo  6 oo oo oo oo oo   B<-A, D<-A
    B=2      0 [2] 9  6  7 oo oo oo oo   C<-B,E<-B (B-D=8>6 ingen)
    D=6      0  . 9 [6] 7 oo  7 10 oo   G<-D,H<-D (D-E=11>7 ingen)
    G=7      0  . 9  . 7 oo [7]10 oo   (kun D-G)
    E=7      0  . 9  .[7] 8  . 10 oo   F<-E  (E-H=10 ikke <10)
    F=8      0  . 9  .  .[8] . 10 12   I<-F  (F-C=13>9 ingen)
    C=9      0  .[9] .  . . . 10 12   (C-F lukket)
    H=10     0  . .  .  . . .[10]12   (H-I=12 ikke <12)
    I=12     0  . .  .  . . . . [12]   slut
    ```

    Settle-orden $A, B, D, G, E, F, C, H, I$ (uafgjort $G{=}E{=}7$ brydes til $G$ først). Afstand og forælder:
    #eq[$
      &B{:}2{<-}A, quad D{:}6{<-}A, quad E{:}7{<-}B, quad G{:}7{<-}D, quad F{:}8{<-}E, \
      &C{:}9{<-}B, quad H{:}10{<-}D, quad I{:}12{<-}F.
    $]
    $E$ nås billigst via $B$ ($2{+}5{=}7$), ikke via $D$ ($6{+}5{=}11$); $F$ via $E$ ($7{+}1{=}8$); $C$ via $B$ ($2{+}7{=}9$), ikke via $F$ ($8{+}5{=}13$); $I$ via $F$ ($8{+}4{=}12$), hvor $H arrow.r I = 12$ ikke er strengt mindre.
  ],
)

#qcard(
  tag: [Kruskal: byg MST (Kruskal)],
  source: "DM507 juni 2012, Opg. 4b (10%)",
  theory: <th-mst-kruskal>,
  prompt: [
    Kør Kruskal på den uorienterede graf $G_2$ og giv MST-kanterne i den rækkefølge de tilføjes, samt totalvægten. Kanter:
    #swap[$a{-}e(8), a{-}f(10), a{-}b(17), e{-}h(-4), f{-}h(-10), g{-}f(25), g{-}h(-12), g{-}c(-3), d{-}e(6), h{-}d(1), c{-}d(2), c{-}b(19), b{-}g(-5)$].]
  ,
  answer: [MST (i orden): $(g,h), (f,h), (b,g), (e,h), (g,c), (h,d), (a,e)$. Totalvægt $-25$.],
  blueprint: [
    + Sortér kanterne stigende efter vægt.
    + Scan: tilføj en kant hvis dens endepunkter er i #emph[forskellige] komponenter (union-find); spring over hvis den danner en kreds (cycle).
    + Stop ved $|V| - 1$ kanter.
  ],
  worked: [
    Sorteret stigende: $(g,h){-}12, (f,h){-}10, (b,g){-}5, (e,h){-}4, (g,c){-}3, (h,d)1, (c,d)2, (d,e)6, (a,e)8, (a,f)10, (a,b)17, (c,b)19, (g,f)25$.

    Scan i orden. Tilføj kun hvis endepunkterne ligger i forskellige union-find-komponenter; ellers kreds. 8 knuder, så stop ved 7 kanter. Komponent-mængderne efter hvert skridt (singletons udeladt):

    ```
    kant       vægt  find(u)?find(v)?  handling   komponenter
    init                               -          alle singletons
    (g,h)      -12   g != h            TILFØJ      {g,h}
    (f,h)      -10   f != {g,h}        TILFØJ      {f,g,h}
    (b,g)       -5   b != {f,g,h}      TILFØJ      {b,f,g,h}
    (e,h)       -4   e != {b,f,g,h}    TILFØJ      {b,e,f,g,h}
    (g,c)       -3   {..} != c         TILFØJ      {b,c,e,f,g,h}
    (h,d)        1   {..} != d         TILFØJ      {b,c,d,e,f,g,h}
    (c,d)        2   samme komponent   KREDS       (uændret)
    (d,e)        6   samme komponent   KREDS       (uændret)
    (a,e)        8   a != {b..h}       TILFØJ      {a,b,c,d,e,f,g,h}  (7 kanter)
    ```

    7 kanter nået, stop. MST (i tilføjelsesorden): $(g,h), (f,h), (b,g), (e,h), (g,c), (h,d), (a,e)$. Totalvægt:
    #eq[$ -12 - 10 - 5 - 4 - 3 + 1 + 8 = -25. $]
  ],
)

#qcard(
  tag: [Kruskal: byg MST (Kruskal)],
  source: "jun 2016, Problem 6d (5%)",
  theory: <th-mst-kruskal>,
  prompt: [
    Kør Kruskal på den uorienterede graf $G_3$ og giv MST-kanterne. Kanter:
    #swap[$j{-}h(1), j{-}i(12), h{-}i(17), h{-}e(14), h{-}f(15), i{-}f(3), i{-}g(4), e{-}f(21), f{-}g(19), e{-}a(13), e{-}b(8), f{-}b(11), f{-}c(16), g{-}c(7), g{-}d(5), a{-}b(6), b{-}c(9), c{-}d(2)$].]
  ,
  answer: [MST: $(h,j),(c,d),(f,i),(g,i),(d,g),(a,b),(b,e),(b,c),(i,j)$. Totalvægt $50$, 9 kanter over 10 knuder.],
  blueprint: [
    + Sortér kanterne stigende.
    + Tilføj en kant hvis endepunkterne er i forskellige komponenter, ellers spring over.
    + Stop ved $|V| - 1 = 9$ kanter.
  ],
  worked: [
    Sorteret stigende: $(j,h)1, (c,d)2, (i,f)3, (i,g)4, (g,d)5, (a,b)6, (g,c)7, (e,b)8, (b,c)9, (f,b)11, (j,i)12, ...$ 10 knuder, så stop ved 9 kanter. Scan i orden, tilføj hvis endepunkterne er i forskellige komponenter:

    ```
    kant     vægt  find-tjek            handling  komponenter (singletons udeladt)
    (j,h)     1    j != h               TILFØJ    {h,j}
    (c,d)     2    c != d               TILFØJ    {c,d}
    (i,f)     3    i != f               TILFØJ    {f,i}
    (i,g)     4    {f,i} != g           TILFØJ    {f,g,i}
    (g,d)     5    {f,g,i} != {c,d}     TILFØJ    {c,d,f,g,i}
    (a,b)     6    a != b               TILFØJ    {a,b}
    (g,c)     7    g,c samme komponent  KREDS     (uændret)
    (e,b)     8    e != {a,b}           TILFØJ    {a,b,e}
    (b,c)     9    {a,b,e} != {c,d,..}  TILFØJ    {a,b,c,d,e,f,g,i}
    (f,b)    11    samme komponent      KREDS     (uændret)
    (j,i)    12    {h,j} != {a,b,..}    TILFØJ    {a,b,c,d,e,f,g,h,i,j}  (9 kanter)
    ```

    9 kanter nået, alle 10 knuder hænger sammen, stop. MST (i tilføjelsesorden): $(h,j),(c,d),(f,i),(g,i),(d,g),(a,b),(b,e),(b,c),(i,j)$. Totalvægt:
    #eq[$ 1{+}2{+}3{+}4{+}5{+}6{+}8{+}9{+}12 = 50. $]
  ],
)

#qcard(
  tag: [Kruskal: byg MST + argumentér (snit-egenskaben)],
  source: "DM507 jan 2008, Opg. 2b (8%)",
  theory: <th-mst-cut>,
  prompt: [
    Tegn et MST for grafen og argumentér for at det er minimalt (og entydigt). Uorienterede kanter:
    #swap[$s{-}A{=}1, s{-}B{=}12, A{-}B{=}13, B{-}C{=}30, B{-}G{=}5, P{-}Q{=}9, P{-}R{=}10, Q{-}R{=}2, R{-}C{=}8, R{-}D{=}15, C{-}D{=}7, C{-}G{=}17, D{-}E{=}3, D{-}F{=}11, E{-}F{=}14, G{-}H{=}8, G{-}I{=}4, H{-}I{=}6, F{-}I{=}15$].]
  ,
  answer: [MST: $s{-}A, Q{-}R, D{-}E, G{-}I, B{-}G, H{-}I, C{-}D, R{-}C, P{-}Q, D{-}F, s{-}B, F{-}I$. Totalvægt $83$, entydigt.],
  blueprint: [
    + Sortér kanterne stigende, tilføj hvis en kant forbinder to forskellige komponenter (ingen kreds), stop ved $n-1$ kanter.
    + Argumentér: hver tilføjet kant er den letteste kant der krydser snittet (cut) mellem dens to komponenter, så snit-egenskaben (cut property) gør den sikker.
    + Entydighed: tjek at gentagne vægte hver især tvinges (den anden af et par danner en kreds).
  ],
  worked: [
    Sorteret stigende (13 knuder, stop ved 12 kanter): $s{-}A(1), Q{-}R(2), D{-}E(3), G{-}I(4), B{-}G(5), H{-}I(6), C{-}D(7), R{-}C(8), G{-}H(8), P{-}Q(9), P{-}R(10), D{-}F(11), s{-}B(12), A{-}B(13), E{-}F(14), R{-}D(15), F{-}I(15), C{-}G(17), B{-}C(30)$.

    Scan i orden; tilføj hvis komponenterne er forskellige. Komponenter undervejs (singletons udeladt):

    ```
    kant     vægt  handling  komponenter (ikke-trivielle)
    s-A       1    TILFØJ    {s,A}
    Q-R       2    TILFØJ    {Q,R}
    D-E       3    TILFØJ    {D,E}
    G-I       4    TILFØJ    {G,I}
    B-G       5    TILFØJ    {B,G,I}
    H-I       6    TILFØJ    {B,G,H,I}
    C-D       7    TILFØJ    {C,D,E}
    R-C       8    TILFØJ    {C,D,E,Q,R}
    G-H       8    KREDS     (begge i {B,G,H,I})
    P-Q       9    TILFØJ    {C,D,E,P,Q,R}
    P-R      10    KREDS     (begge i {C,D,E,P,Q,R})
    D-F      11    TILFØJ    {C,D,E,F,P,Q,R}
    s-B      12    TILFØJ    {s,A,B,G,H,I}
    A-B      13    KREDS     (begge i {s,A,B,G,H,I})
    E-F      14    KREDS     (begge i {C,D,E,F,..})
    R-D      15    KREDS     (begge i {C,D,E,F,..})
    F-I      15    TILFØJ    alle 13 knuder  (12 kanter)
    ```

    Kruskal-orden ($n-1 = 12$ kanter):
    #eq[$
      &s{-}A(1), Q{-}R(2), D{-}E(3), G{-}I(4), B{-}G(5), H{-}I(6), C{-}D(7), R{-}C(8), \
      &P{-}Q(9), D{-}F(11), s{-}B(12), F{-}I(15).
    $]
    Sprunget over som kredse: $G{-}H(8), P{-}R(10), A{-}B(13), E{-}F(14), R{-}D(15), C{-}G(17), B{-}C(30)$. Totalvægt $= 1{+}2{+}3{+}4{+}5{+}6{+}7{+}8{+}9{+}11{+}12{+}15 = 83$.

    Entydighed: vægte gentages kun ved 8 ($R{-}C, G{-}H$) og 15 ($R{-}D, F{-}I$). I hvert par bruger Kruskal den ene, og den anden danner en kreds. Ingen kant af vægt $< 15$ broer de to halvdele, så $F{-}I = 15$ er tvunget. Hver valgt kant er minimumskanten over snittet for den hidtil byggede komponent, så ved snit-egenskaben er træet et MST.
  ],
)

#qcard(
  tag: [Kruskal-skridt + union-find-skov (union-find)],
  source: "DM02 jan 2006, Opg. 3a (8%)",
  theory: <th-mst-kruskal>,
  prompt: [
    Grafen har kanter #swap[$A{-}B{=}2, B{-}C{=}7, A{-}D{=}6, B{-}D{=}6, B{-}E{=}5, C{-}F{=}5, D{-}E{=}5, E{-}F{=}1, D{-}G{=}1, D{-}H{=}4, E{-}H{=}3, F{-}I{=}4, H{-}I{=}2$]. De første 5 Kruskal-kanter er $E{-}F(1), D{-}G(1), A{-}B(2), H{-}I(2), E{-}H(3)$, så mængderne er $\{E,F,H,I\}, \{D,G\}, \{A,B\}, \{C\}$. \
    *(a)* Hvilken kant tilføjer Kruskal som nr. 6? \
    *(b)* Tegn disjoint-set-skoven (disjoint-set forest) efter den 6. kant med union-by-rank (union by rank) + sti-komprimering (path compression).
  ],
  answer: [Næste kant $D{-}H(4)$. Efter union'en: rod $E$ (rank 2) med $F, I, H, D$ ($G$ under $D$); $H$ og $I$ peger nu direkte på $E$.],
  blueprint: [
    + Sortér de resterende kanter, scan i orden.
    + Næste valgte kant $=$ den letteste hvis endepunkter har #emph[forskellige] rødder ($mono("find")$ er forskellig).
    + Union: sammenlign rank, hæng den lavere rod under den højere; ved lige rank vælg én og hæv dens rank med 1. $mono("find")$ sti-komprimerer alle knuder på vejen til roden.
  ],
  worked: [
    Resterende kanter efter de 5: $D{-}H(4), F{-}I(4), B{-}E(5), C{-}F(5), D{-}E(5), A{-}D(6), B{-}D(6), B{-}C(7)$.

    + Scan: $D{-}H(4)$ — $D in \{D,G\}$, $H in \{E,F,H,I\}$, forskellige mængder. *Valgt.*
    + Startskov: $E$ (rank 2) med børn $F$ og $I$, og $H$ under $I$ (altså $H arrow.r I arrow.r E$); $D$ (rank 1) med barn $G$; $A$ (rank 1) med barn $B$; $C$ alene.
    + $mono("Union")(mono("Find")(D), mono("Find")(H))$: $mono("find")(D)=D$ (rank 1). $mono("find")(H)$ går $H arrow.r I arrow.r E$, så $mono("find")(H)=E$ (rank 2) — og sti-komprimering flader $H$ og $I$ til at pege direkte på $E$.
    + Union-by-rank: $D$ (rank 1) hænges under $E$ (rank 2). Rank uændret.

    Resultat: mængde $\{E,F,I,H,D,G\}$ med rod $E$ (rank 2), børn $F, I, H, D$, og $G$ under $D$. Desuden $\{A,B\}$ (rod $A$, rank 1) og $\{C\}$. Pointen: $mono("find")(H)$ komprimerer, så den gamle $H arrow.r I$-kant forsvinder.
  ],
)

#qcard(
  tag: [Prim: byg MST (Prim)],
  source: "DM507 juni 2013, Opg. 4c (10%)",
  theory: <th-mst-prim>,
  prompt: [
    Kør Prim fra $a$ på den uorienterede graf $G_3$. Giv Extract-Min-rækkefølge og MST-kanterne. Kanter:
    #swap[$a{-}b(4), a{-}h(8), a{-}i(7), b{-}c(2), b{-}i(6), h{-}g(9), h{-}i(17), g{-}i(13), g{-}f(10), i{-}c(22), i{-}f(5), i{-}e(14), i{-}d(18), c{-}d(11), f{-}e(15), e{-}d(21)$].]
  ,
  answer: [Extract-Min: $a, b, c, i, f, h, g, d, e$. MST: $(a,b),(b,c),(b,i),(i,f),(a,h),(h,g),(c,d),(i,e)$, totalvægt $59$.],
  blueprint: [
    + $mono("key")[a] = 0$, resten $oo$.
    + Extract-Min knude $u$ med mindst $mono("key")$; tilføj kanten $(pi[u], u)$ til MST når $u != a$.
    + For hver nabo $v$ stadig i køen med $w(u,v) < mono("key")[v]$: sæt $mono("key")[v] = w(u,v)$, $pi[v] = u$.
  ],
  worked: [
    Init $mono("key")[a]{=}0$, resten $oo$, $pi{=}-$. Hver Extract-Min trækker knuden $u$ med mindst nøgle (fed), tilføjer kanten $(pi[u], u)$ til MST (for $u != a$) og opdaterer naboer $v$ stadig i køen med $w(u,v) < mono("key")[v]$. Nøgle-felter og prioritetskøen efter hvert Extract-Min:

    ```
    trukket   a  b  c  d  e  f  g  h  i    PQ (key for åbne knuder)
    init      0  oo oo oo oo oo oo oo oo   {alle oo}
    EXT a=0   .  4 oo oo oo oo oo  8  7    [b:4,i:7,h:8]   pi: b,i,h <- a
    EXT b=4   .  .  2 oo oo oo oo  8  6    [c:2,i:6,h:8]   pi c<-b, i<-b(6<7)
    EXT c=2   .  .  . 11 oo oo oo  8  6    [i:6,h:8,d:11]  pi d<-c (i:22 ingen)
    EXT i=6   .  .  . 11 14  5 13  8  .    [f:5,h:8,d:11,e:14,g:13] pi f,e,g,(d:18 ingen)<-i
    EXT f=5   .  .  . 11 14  . 10  8  .    [h:8,g:10,d:11,e:14]  pi g<-f (10<13)
    EXT h=8   .  .  . 11 14  .  9  .  .    [g:9,d:11,e:14]  pi g<-h (9<10)
    EXT g=9   .  .  . 11 14  .  .  .  .    [d:11,e:14]  (f,i lukket)
    EXT d=11  .  .  .  . 14  .  .  .  .    [e:14]  (c,i lukket; d-e:21 ingen)
    EXT e=14  .  .  .  .  .  .  .  .  .    {}  alle med
    ```

    Extract-Min-rækkefølge: $a, b, c, i, f, h, g, d, e$. Tilføjede MST-kanter $(pi[u], u)$ i den orden:
    #eq[$ (a,b), (b,c), (b,i), (i,f), (a,h), (h,g), (c,d), (i,e). $]
    De afgørende opdateringer: $i$ falder fra $7$ ($a arrow.r i$) til $6$ ($b arrow.r i$); $g$ falder fra $13$ ($i arrow.r g$) til $10$ ($f arrow.r g$) til $9$ ($h arrow.r g$). Totalvægt:
    #eq[$ 4{+}2{+}6{+}5{+}8{+}9{+}11{+}14 = 59. $]
  ],
)

#qcard(
  tag: [Prim: byg MST (Prim)],
  source: "DM02 jan 2006, Opg. 3b (6%)",
  theory: <th-mst-prim>,
  prompt: [
    Kør Prim fra $A$ og angiv MST-kanterne i den rækkefølge Prim vælger dem. Kanter:
    #swap[$A{-}B{=}2, B{-}C{=}7, A{-}D{=}6, B{-}D{=}6, B{-}E{=}5, C{-}F{=}5, D{-}E{=}5, E{-}F{=}1, D{-}G{=}1, D{-}H{=}4, E{-}H{=}3, F{-}I{=}4, H{-}I{=}2$].]
  ,
  answer: [Orden: $A{-}B, B{-}E, E{-}F, E{-}H, H{-}I, H{-}D, D{-}G, F{-}C$. Totalvægt $23$.],
  blueprint: [
    + Hold mængden af træ-knuder; start med $A$.
    + Vælg gentagne gange minimumskanten med præcis ét endepunkt i træet; tilføj det nye endepunkt.
    + Stop når alle knuder er med.
  ],
  worked: [
    Init $mono("key")[A]{=}0$, resten $oo$, $pi{=}-$. Hver Extract-Min trækker knuden med mindst nøgle (fed), tilføjer $(pi[u], u)$ og opdaterer naboer stadig i køen. Nøgle-felter og kø efter hvert Extract-Min:

    ```
    trukket   A  B  C  D  E  F  G  H  I   PQ (åbne nøgler)
    init      0  oo oo oo oo oo oo oo oo  {alle oo}
    EXT A=0   .  2 oo  6 oo oo oo oo oo   [B:2,D:6]   pi B,D <- A
    EXT B=2   .  . 7  6  5 oo oo oo oo    [E:5,D:6,C:7] pi C,E<-B (D:6 ikke<6)
    EXT E=5   .  . 7  5  .  1 oo  3 oo    [F:1,H:3,D:5,C:7] pi D<-E(5<6),F,H<-E
    EXT F=1   .  . 5  5  .  . oo  3  4    [H:3,I:4,D:5,C:5] pi C<-F(5<7),I<-F
    EXT H=3   .  . 5  4  .  . oo  .  2    [I:2,D:4,C:5] pi D<-H(4<5),I<-H(2<4)
    EXT I=2   .  . 5  4  .  . oo  .  .    [D:4,C:5]  (F lukket)
    EXT D=4   .  . 5  .  .  .  1  .  .    [G:1,C:5] pi G<-D (B,E lukket)
    EXT G=1   .  . 5  .  .  .  .  .  .    [C:5]
    EXT C=5   .  .  .  .  .  .  .  .  .    {}  alle med
    ```

    Extract-Min-orden $A, B, E, F, H, I, D, G, C$. Den nøgle der vinder for hver knude giver træ-kanterne i valgrækkefølge:
    #eq[$ A{-}B(2), B{-}E(5), E{-}F(1), E{-}H(3), H{-}I(2), H{-}D(4), D{-}G(1), F{-}C(5). $]
    Bemærk hvordan $D$ falder $6 arrow.r 5 arrow.r 4$ ($A arrow.r E arrow.r H$) og $I$ falder $4 arrow.r 2$ ($F arrow.r H$). Totalvægt $= 2{+}5{+}1{+}3{+}2{+}4{+}1{+}5 = 23$ (samme total som Kruskal giver).
  ],
)

#qcard(
  tag: [Union-find: træk en sekvens af unioner (union-by-rank)],
  source: "DM507 juni 2008, Opg. 3 (a, b, c) (18%)",
  theory: <th-mst-kruskal>,
  prompt: [
    Udfør unionerne #swap[$1.mono("Union")(b,a) thin 2.mono("Union")(b,c) thin 3.mono("Union")(e,d) thin 4.mono("Union")(e,c) thin 5.mono("Union")(g,f) thin 6.mono("Union")(e,g)$]. Ved uafgjort hænges mængden med $x$ under/efter mængden med $y$. \
    *(a)* Vægtet union (union by size) med hægtede lister. \
    *(b)* Union-by-rank, uden sti-komprimering. \
    *(c)* Union-by-rank med sti-komprimering.
  ],
  answer: [(a) Én liste $a arrow.r b arrow.r c arrow.r d arrow.r e arrow.r f arrow.r g$, repr. $a$. (b) Rod $a$ (rank 2): børn $b,c,d,f$; $e$ under $d$, $g$ under $f$. (c) Som (b), men $e$ rykkes op som direkte barn af $a$.],
  blueprint: [
    + *Vægtet union (liste):* hver mængde er en liste med hoved (repr.) og hale; vægt $=$ længde. $mono("Union")(x,y)$: hæng den #emph[korteste] liste efter den længste; ved uafgjort hæng listen med $x$ efter listen med $y$.
    + *Union-by-rank:* hver mængde er et træ, roden gemmer rank. Hæng lavere-rank-rod under højere; ved lige rank, hæng $x$'s rod under $y$'s og hæv $y$'s rank med 1.
    + *Sti-komprimering:* hvert $mono("find")$ får alle knuder på stien til at pege direkte på roden. Rank ændres ikke.
  ],
  worked: [
    *(a) Vægtet union (lister, hoved$arrow.r$hale):*
    + $mono("Union")(b,a)$: $[a],[b]$ uafgjort $arrow.r.long$ $a arrow.r b$ (1).
    + $mono("Union")(b,c)$: $[a,b](2)$ vs $[c](1)$ $arrow.r.long$ $b arrow.r c$ (2).
    + $mono("Union")(e,d)$: uafgjort $arrow.r.long$ $d arrow.r e$ (3).
    + $mono("Union")(e,c)$: $[d,e](2)$ vs $[a,b,c](3)$ $arrow.r.long$ $c arrow.r d$ (4).
    + $mono("Union")(g,f)$: uafgjort $arrow.r.long$ $f arrow.r g$ (5).
    + $mono("Union")(e,g)$: $[a..e](5)$ vs $[f,g](2)$ $arrow.r.long$ $e arrow.r f$ (6).

    Slutliste: $a arrow.r b arrow.r c arrow.r d arrow.r e arrow.r f arrow.r g$, repr. $a$.

    *(b) Union-by-rank:* $b$ under $a$ (rank$(a){=}1$); $c$ under $a$; $e$ under $d$ (rank$(d){=}1$); $mono("root")(e){=}d$ og $mono("root")(c){=}a$, begge rank 1, så $d$ under $a$ (rank$(a){=}2$); $g$ under $f$ (rank$(f){=}1$); til sidst $mono("root")(g){=}f$ (rank 1) under $a$ (rank 2). Resultat: rod $a$ (rank 2), direkte børn $b, c, d, f$; $e$ under $d$; $g$ under $f$.

    *(c) Med sti-komprimering:* eneste $mono("find")$ med længde-2-sti er skridt 6: $mono("find")(e)$ går $e arrow.r d arrow.r a$ og komprimerer $e$ til at pege direkte på $a$. Resultat som (b), men $e$ er nu et direkte barn af $a$. Rank uændret ($a{=}2, d{=}1, f{=}1$).
  ],
)

#qcard(
  tag: [Union-find: hvilke grafer giver skovens form (union-by-rank)],
  source: "DM507 juni 2008, Opg. 3d (7%)",
  theory: <th-mst-kruskal>,
  prompt: [
    Et union-by-rank-skovtræ (Figur 3) har rod $a$ med direkte børn $b, c, d, e$, og $f$ er barn af $e$. Fire vægtede grafer køres gennem Kruskal — hvilke kan producere dette træ? Begrund. \
    *(a)* sti #swap[$a{-}2{-}b{-}4{-}c{-}6{-}d{-}8{-}e{-}10{-}f$]. \
    *(b)* sti #swap[$a{-}2{-}b{-}4{-}c{-}6{-}d{-}10{-}e{-}8{-}f$]. \
    *(c)* sekskant #swap[$a{-}1{-}b{-}2{-}c{-}9{-}d{-}10{-}e{-}4{-}f{-}7{-}a$]. \
    *(d)* sekskant + 3 diagonaler, #swap[alle vægte 1].
  ],
  answer: [(b), (c) og (d) kan; (a) kan ikke.],
  blueprint: [
    + Kruskal kører kanter i stigende vægtorden og $mono("Union")$'er endepunkterne af hver ikke-kreds-kant.
    + Målets rod har rank 2 (barnet $e$ har selv barnet $f$). En kandidat skal altså kunne bygge en rank-2-rod med ét rank-1-barn.
    + Et rent "smelt singletons ind i én rod i vægtorden" giver en flad stjerne (dybde 1, rank 1) — kan ikke passe. Du har brug for et rank-1-deltræ (to knuder samlet) der senere hænger under den voksende rod.
    + Ved lige vægte må uafgjort brydes i vilkårlig orden, så tjek om #emph[en] orden kan reproducere træet.
  ],
  worked: [
    - *(a) NEJ.* Kanter i orden $2,4,6,8,10$: $a{-}b$ (rank$arrow.r 1$), derefter $b{-}c, c{-}d, d{-}e, e{-}f$ smelter hver en singleton ind i den ene rank-1-rod. Resultat er en dybde-1-stjerne — ingen knude har et barnebarn. Figur 3 har $f$ to niveauer under roden.
    - *(b) JA.* Sorteret $a{-}b(2), b{-}c(4), c{-}d(6), e{-}f(8), d{-}e(10)$. De tre første bygger en rank-2-rod over $\{a,b,c,d\}$; $e{-}f(8)$ samler $e,f$ til et rank-1-par, som så hænger under roden via $d{-}e(10)$. Form $=$ rank-2-rod med ét rank-1-barn med et blad.
    - *(c) JA.* Sorteret $a{-}b(1), b{-}c(2), e{-}f(4), a{-}f(7), c{-}d(9)$ ($d{-}e(10)$ er en kreds). $e{-}f(4)$ danner et rank-1-par, der hænger under roden via $a{-}f(7)$. Samme form.
    - *(d) JA.* Alle ni kanter har vægt 1, så uafgjort kan brydes vilkårligt. En orden (fx $a{-}b, b{-}c, c{-}d, e{-}f, d{-}e, f{-}a, ...$) bygger præcis Figur 3. Da mindst én orden reproducerer den, kan (d).
  ],
)

#qcard(
  tag: [MST-bevis: tungeste kant i en kreds (udspændende træ)],
  source: "DM507 jan 2008, Opg. 2a (9%)",
  theory: <th-mst-cut>,
  prompt: [
    $G$ er vægtet, $e$ en kant. Antag der findes en kreds $C$ med $e in C$ og #swap[$w(e) > w(e')$ for hver anden kant $e'$ i $C$]. Bevis at $e$ ikke kan ligge i noget MST.
  ],
  answer: [Antag modsætningsvis $e in T$ for et MST $T$; udskift med en lettere kreds-kant over snittet og få et lettere udspændende træ — modstrid.],
  blueprint: [
    + Antag modsætningsvis at et MST $T$ indeholder $e$.
    + Fjern $e$ fra $T$: $T$ deles i to komponenter $S$ og $V - S$.
    + Find en billigere kant af kredsen der krydser samme snit.
    + Skift den ind og få et udspændende træ med mindre vægt — modstrid.
  ],
  worked: [
    Antag et MST $T$ indeholder $e = (u, v)$. Slet $e$ fra $T$: træet deles i to dele med knudemængder $S$ (med $u$) og $V - S$ (med $v$). Gå rundt i kredsen $C$ fra $u$ til $v$ ad den vej der ikke bruger $e$. Vejen starter i $S$ og ender i $V - S$, så et sted krydser den snittet, dvs. $C$ har en kant $e' != e$ med ét endepunkt i $S$ og ét i $V - S$. Da $e$ er strengt tungest i $C$ er $w(e') < w(e)$.

    Sæt $T' = T - e + e'$. Begge endepunkter af $e'$ ligger på hver sin side, så $T'$ er igen et udspændende træ, og
    #eq[$ w(T') = w(T) - w(e) + w(e') < w(T). $]
    Det modsiger at $T$ er minimalt. Altså ligger $e$ i intet MST. $qed$
  ],
)

#qcard(
  tag: [MST-design: rummer et MST en given kantmængde? (udspændende træ)],
  source: "DM02 jan 2006, Opg. 3c (8%)",
  theory: <th-mst-cut>,
  prompt: [
    Graf $G$ med kanter $\{e_1, ..., e_k\}$. Afgør om #emph[et] MST af $G$ indeholder alle $k$ kanter. Angiv køretiden.
  ],
  answer: [Ja hvis kanterne er kredsfri og den tvungne grådige fuldendelse har vægt $W = W^*$ (det globale MST). Køretid $O(E log V)$.],
  blueprint: [
    + De $k$ kanter må ikke danne en kreds. Tjek med union-find i $O(k thin alpha)$; danner de en kreds, er svaret nej.
    + Tving kanterne ind (union'ér deres endepunkter, samlet vægt $W_0$) og fuldend grådigt med Kruskal på de #emph[resterende] kanter: $W = W_0 + ("Kruskal-fuldendelse")$.
    + Sammenlign $W$ med vægten $W^*$ af et rigtigt MST af $G$. Er $W = W^*$, findes et MST der rummer alle $k$ kanter; ellers ikke.
  ],
  worked: [
    At tvinge kanterne ind og fuldende grådigt (greedily) giver det letteste udspændende træ (spanning tree) blandt dem der indeholder $\{e_1, ..., e_k\}$ (ombytningsargument, exchange argument). Det træ er et MST af $G$ netop når dets vægt er lig det globale minimum $W^*$.

    Køretid: to Kruskal-kørsler dominerer — sortering $O(E log E)$ plus union-find næsten-lineært, altså
    #eq[$ O(E log E) = O(E log V). $]
  ],
)

#qcard(
  tag: [Fælles graf: BFS, Dijkstra og MST (Kruskal)],
  source: "DM507 juni 2010, Opg. 2 (25%)",
  theory: <th-mst-kruskal>,
  prompt: [
    Fire grafer deler samme knude-layout: $s$ til venstre; øverste række $T L, T R$; midterste $M L, C, M R$; nederste $B L, B R$. Løs sub-opgaverne på de grafer der angives. \
    *(a)* BFS-afstande $v.d$ fra $s$ på den rettede $G_1$. Kanter: #swap[$s arrow.r T L, s arrow.r M L; T L arrow.r T R, T L arrow.r M L, T L arrow.r C; T R arrow.r C, T R arrow.r M R; M L arrow.r C; M R arrow.r C, M R arrow.r B R; B L arrow.r s, B L arrow.r M L, B L arrow.r C; B R arrow.r B L, B R arrow.r C$]. \
    *(c)* Dijkstra-afstande $v.d$ fra $s$ på den rettede $G_3$. Kanter: #swap[$s arrow.r T L(5), s arrow.r M L(10); T L arrow.r T R(12), T L arrow.r M L(10), T L arrow.r C(30); T R arrow.r C(9), T R arrow.r M R(4); M L arrow.r C(20); M R arrow.r C(3), M R arrow.r B R(2); B L arrow.r s(6), B L arrow.r M L(8), B L arrow.r C(3), B L arrow.r B R(7); B R arrow.r C(1)$]. \
    *(d)* Et MST af den uorienterede $G_4$ (samme vægte som $G_3$, uden retninger) plus dens vægt. Ekstra kant: #swap[$s{-}B L(6)$].
  ],
  answer: [(a) $s{=}0, T L{=}1, M L{=}1, T R{=}2, C{=}2, M R{=}3, B R{=}4, B L{=}5$. (c) $s{=}0, T L{=}5, M L{=}10, T R{=}17, M R{=}21, B R{=}23, C{=}24, B L{=}oo$. (d) MST $\{B R{-}C(1), M R{-}B R(2), B L{-}C(3), T R{-}M R(4), s{-}T L(5), s{-}B L(6), B L{-}M L(8)\}$, vægt $29$.],
  blueprint: [
    Hver sub-opgave er den letteste korrekte algoritme for sin graf.

    + Uvægtet, korteste vej i kanter? → *BFS* fra $s$, $v.d =$ lagnummer.
    + Ikke-negative vægte, cykler mulige? → *Dijkstra*. Knuder uden indkant fra det nåelige sæt får $oo$.
    + MST på den uorienterede version? → *Kruskal*: sortér, tilføj hvis komponenterne er forskellige, stop ved $|V|-1$ kanter.
  ],
  worked: [
    + *(a) BFS.* Lag fra $s$: lag 0 $\{s\}$; lag 1 $\{T L, M L\}$; lag 2 $\{T R, C\}$; lag 3 $\{M R\}$; lag 4 $\{B R\}$; lag 5 $\{B L\}$. $B L$ nås kun via den lange vej $s arrow.r T L arrow.r T R arrow.r M R arrow.r B R arrow.r B L$, for de eneste kanter ind i $B L$ kommer fra $B R$.
      #eq[$ s{=}0, T L{=}1, M L{=}1, T R{=}2, C{=}2, M R{=}3, B R{=}4, B L{=}5. $]

    + *(c) Dijkstra.* Init $d[s]{=}0$, resten $oo$. Hver Extract-Min (fed) relakserer ud-kanterne; $d$-felt efter hvert settle (forkortelser: TL, TR, ML, MR, C, BR, BL):

      ```
      settle    s  TL ML TR MR C  BR BL
      init      0  oo oo oo oo oo oo oo
      s=0       0   5 10 oo oo oo oo oo   (s->TL=5, s->ML=10)
      TL=5      0  [5]10 17 oo 35 oo oo   TR=17, C=35 (ML:15>10 ingen)
      ML=10     0  . [10]17 oo 30 oo oo   C=30 (ML->C=10+20)
      TR=17     0  .  . [17]21 26 oo oo   MR=21, C=26 (slår 30)
      MR=21     0  .  .  . [21]24 23 oo   C=24 (slår 26), BR=23
      BR=23     0  .  .  .  . 24[23]oo   (BR->C=24 ikke<24)
      C=24      0  .  .  .  .[24]. oo    (C har ingen ud-kant)
      BL: oo    -  -  -  -  - -  -  oo    ingen indkant fra nåeligt sæt
      ```
      $B L$ har ingen indkant fra det nåelige sæt, så $B L = oo$. $C$'s bedste indgang er $B R arrow.r C$ med $23{+}1 = 24$.
      #eq[$ s{=}0, T L{=}5, M L{=}10, T R{=}17, M R{=}21, B R{=}23, C{=}24, B L{=}oo. $]

    + *(d) Kruskal.* Scan i vægtorden: tilføj $B R{-}C(1)$, $M R{-}B R(2)$, $B L{-}C(3)$; spring $M R{-}C(3)$ over (kreds); tilføj $T R{-}M R(4)$, $s{-}T L(5)$, $s{-}B L(6)$; spring $B L{-}B R(7)$ over; tilføj $M L{-}B L(8)$. Nu hænger alle 8 knuder sammen med 7 kanter.
      #eq[$ "vægt" = 1{+}2{+}3{+}4{+}5{+}6{+}8 = 29. $]
      Treren-uafgjorten gør ingen skade: $M R{-}C(3)$ er altid overflødig givet $B R{-}C$ og $M R{-}B R$, så MST'et er entydigt.
  ],
)

#qcard(
  tag: [Kruskal-skridt + union-find-skov (union-find)],
  source: "DM507 juni 2014, Opg. 7 (17%)",
  theory: <th-mst-kruskal>,
  prompt: [
    Kør Kruskal på den uorienterede graf $G$. Kanter: #swap[$a{-}c(5), a{-}e(18), a{-}f(3), c{-}f(16), b{-}c(2), b{-}f(11), e{-}f(21), d{-}e(8), d{-}f(12), b{-}d(13), b{-}g(19), d{-}g(15)$]. Spørgsmål (a), (b), (d) angår tilstanden efter 7 undersøgte kanter (7 gennemløb af den indre løkke). Ved uafgjort rank bliver den alfabetisk mindste knude ny rod. \
    *(a)* Hvilke kanter er valgt (i $A$) efter 7 undersøgte? \
    *(b)* Sammenhængskomponenterne (connected components) i $G' = (V, A)$. \
    *(c)* Vægten af et MST af hele $G$. \
    *(d)* Disjoint-set-skoven efter 7 undersøgte kanter med union-by-rank + sti-komprimering.
  ],
  answer: [(a) $(a,c), (a,f), (b,c), (d,e), (d,f)$ (vægte $5,3,2,8,12$). (b) $\{a,b,c,d,e,f\}$ og $\{g\}$. (c) $45$. (d) Træ 1: rod $a$ (rank 2), forældre $c arrow.r b, b arrow.r a, f arrow.r a, d arrow.r a, e arrow.r d$. Træ 2: $\{g\}$, rank 0.],
  blueprint: [
    + Sortér kanterne stigende og scan dem i orden.
    + Tilføj en kant til $A$ hvis $mono("find")$ giver forskellige rødder; ellers spring over (kreds).
    + Union-by-rank: hæng den lavere rod under den højere; ved lige rank bliver den valgte rod (her alfabetisk mindst) ny rod og hæver sin rank med 1.
    + Komponenterne i $(V, A)$ aflæses fra rødderne; MST-vægten fås ved at fortsætte Kruskal til alle knuder hænger sammen.
  ],
  worked: [
    Sorteret: $(2,b,c), (3,a,f), (5,a,c), (8,d,e), (11,b,f), (12,d,f), (13,b,d), (15,d,g), (16,c,f), (18,a,e), (19,b,g), (21,e,f)$.

    De første 7 undersøgte kanter:
    + $(b,c)2$ → tilføj. Uafgjort rank → rod $b$ (rank 1), $c arrow.r b$.
    + $(a,f)3$ → tilføj. Uafgjort → rod $a$ (rank 1), $f arrow.r a$.
    + $(a,c)5$ → tilføj. $mono("find")(a){=}a$, $mono("find")(c){=}b$, begge rank 1 → mindst $a$ rod (rank 2), $b arrow.r a$.
    + $(d,e)8$ → tilføj. Uafgjort → rod $d$ (rank 1), $e arrow.r d$.
    + $(b,f)11$ → begge $mono("find") arrow.r a$, kreds, spring over.
    + $(d,f)12$ → tilføj. $mono("find")(d){=}d$ (rank 1), $mono("find")(f){=}a$ (rank 2) → $a$ vinder, $d arrow.r a$.
    + $(b,d)13$ → begge $mono("find") arrow.r a$, kreds, spring over.

    *(a)* Valgt: $(a,c), (a,f), (b,c), (d,e), (d,f)$. *(b)* $\{a,b,c,d,e,f\}$ og $\{g\}$. \
    *(c)* Fortsæt: næste ikke-kreds-kant er $(d,g)15$, som binder $g$ på. MST-kanter $b{-}c(2), a{-}f(3), a{-}c(5), d{-}e(8), d{-}f(12), d{-}g(15)$, vægt $= 45$. \
    *(d)* Slutskov: forældre $c arrow.r b, b arrow.r a, f arrow.r a, d arrow.r a, e arrow.r d$, rod $a$ (rank 2); og $\{g\}$ alene (rank 0). Sti-komprimering ændrede intet her, for hvert $mono("find")$ landede allerede på en knude der peger direkte på sin rod.
  ],
)

#qcard(
  tag: [Korteste-vej-algoritme på struktureret graf (topologisk orden)],
  source: "DM507 juni 2014, Opg. 10 (15%)",
  theory: <th-sp-dag>,
  prompt: [
    En #emph[kvadrat-graf] er en rettet graf med $k$ rækker à $k$ knuder, $v_(i j)$ for $i$ række $1..k$, $j$ søjle $1..k$. Kanter: $(v_(i j), v_(i+1,j))$ (op en række), $(v_(i j), v_(i,j+1))$ (højre) og $(v_(i j), v_(i,j-1))$ (venstre), når begge ender findes. Alle vægte $>= 0$. \
    *(a)* Udtryk $n$ og $m$ som funktioner af $k$. \
    *(b)* Dijkstras køretid fra $v_(1 1)$ med binær hob. \
    *(c)* Giv en $O(m)$-algoritme til korteste veje fra $v_(1 1)$ til alle knuder, og argumentér.
  ],
  answer: [(a) $n = k^2$, $m = 3k(k-1) = 3k^2 - 3k$. (b) $O(k^2 log k)$. (c) Behandl rækkerne nedefra og op; i hver række to vandrette fej (venstre-mod-højre, så højre-mod-venstre) og skub så op. $O(m)$.],
  blueprint: [
    + Tæl knuder og kanter: lodrette op-kanter $k(k-1)$, vandrette $2k(k-1)$, i alt $m = 3k(k-1)$.
    + Sæt Dijkstras $O((n+m) log n)$ ind med $n = k^2$, $m = Theta(k^2)$, $log n = Theta(log k)$.
    + Udnyt strukturen: ingen kant går #emph[ned] en række, så rækkerne nedefra og op er en topologisk orden. Hver række er en sti-graf; med ikke-negative vægte fanger to monotone fej (venstre, så højre) alle optimale veje i rækken.
  ],
  worked: [
    *(a)* Knuder $n = k^2$. Lodrette "op"-kanter $k(k-1)$; vandrette per række $(k-1)$ højre $+ (k-1)$ venstre $= 2(k-1)$, over $k$ rækker $= 2k(k-1)$. I alt $m = 3k(k-1)$. (Tjek: $k{=}5 arrow.r n{=}25, m{=}60$.)

    *(b)* Dijkstra med binær hob er $O((n+m) log n)$. Her $n{=}k^2$, $m{=}Theta(k^2)$, $log n = log k^2 = 2 log k$, altså $O(k^2 log k)$.

    *(c)* Nøgleobservation: hver kant bliver i samme række eller går én række op, aldrig ned. Så rækkerne $i = 1, 2, ..., k$ er en gyldig topologisk orden — når række $i$ er færdig, kan ingen senere relaksation komme tilbage til den. Algoritme:
    #eq[$
      &mono("dist")[v_(1 1)] = 0, " resten " +oo. \
      &"for " i = 1 "til" k: \
      &quad "for " j = 2 "til" k: " relaksér " (v_(i,j-1), v_(i j)) \
      &quad "for " j = k-1 "ned til" 1: " relaksér " (v_(i,j+1), v_(i j)) \
      &quad "hvis " i < k: " for " j = 1 "til" k: " relaksér " (v_(i j), v_(i+1,j)).
    $]
    To vandrette fej rækker: en venstre-mod-højre fej propagerer alle "kommer fra venstre"-bidrag, en højre-mod-venstre fej alle "kommer fra højre"-bidrag. Da alle vægte er $>= 0$, vender en optimal vej i rækken aldrig vandret retning, så de to fej fanger alt. Korrekthed ved induktion på rækker: før række $i$ er hver indgangsafstand allerede korrekt (de eneste kanter ind i række $i$ kommer fra række $i-1$, behandlet i trin 2 af iteration $i-1$). Køretid: $O(k)$ arbejde per række, $k$ rækker, så $O(k^2) = O(m)$.
  ],
)

#qcard(
  tag: [Prim: byg MST (Prim)],
  source: "DM507 juni 2015, Opg. 5 (7%)",
  theory: <th-mst-prim>,
  prompt: [
    Kør Prim fra $a$ på den uorienterede vægtede graf. Giv Extract-Min-rækkefølge og MST-kanterne. Kanter:
    #swap[$a{-}b(17), a{-}e(11), a{-}d(8), b{-}e(5), e{-}d(18), b{-}c(14), e{-}c(3), c{-}d(25)$].]
  ,
  answer: [Extract-Min: $a, d, e, c, b$. MST: $(a,d){=}8, (a,e){=}11, (e,c){=}3, (e,b){=}5$. Totalvægt $27$.],
  blueprint: [
    + $mono("key")[a] = 0$, resten $oo$, $pi = mono("NIL")$.
    + Extract-Min knude $u$ med mindst $mono("key")$; udskriv den og tilføj kanten $(u, pi[u])$ når $pi[u] != mono("NIL")$.
    + For hver nabo $v$ stadig i køen med $w(u,v) < mono("key")[v]$: sæt $mono("key")[v] = w(u,v)$, $pi[v] = u$.
  ],
  worked: [
    Init $mono("key")[a]{=}0$, resten $oo$, $pi{=}-$. Hver Extract-Min trækker mindste nøgle (fed), tilføjer $(pi[u], u)$ og opdaterer naboer i køen. Nøgle-felter og kø:

    ```
    trukket   a  b  c  d  e   PQ (åbne nøgler)
    init      0  oo oo oo oo  {alle oo}
    EXT a=0   .  17 oo  8 11  [d:8,e:11,b:17]  pi b,d,e <- a
    EXT d=8   .  17 25  . 11  [e:11,b:17,c:25] pi c<-d (e:18 ikke<11)
    EXT e=11  .   5  3  .  .   [c:3,b:5]  pi b<-e(5<17), c<-e(3<25)
    EXT c=3   .   5  .  .  .   [b:5]  (b:14 ikke<5; d lukket)
    EXT b=5   .   .  .  .  .   {}  alle med
    ```

    Extract-Min-orden $a, d, e, c, b$. For hver knude giver den vindende nøgle træ-kanten: $b$ og $c$ falder begge fra deres $d$-baserede nøgler ($17, 25$) ned til $e$-baserede ($5, 3$). MST-kanter:
    #eq[$ (a,d){=}8, quad (a,e){=}11, quad (e,c){=}3, quad (e,b){=}5. $]
    Totalvægt $= 8{+}11{+}3{+}5 = 27$.
  ],
)

#qcard(
  tag: [Korteste vej: vælg simpleste algoritme (Dijkstra)],
  source: "DM507 juni 2015, Opg. 7 (10%)",
  theory: <th-sp-dijkstra>,
  prompt: [
    *(a)* Tre grafer deler topologi (kilde-agtig $c$, dræn-agtig $d$): kanter $b arrow.r a, a arrow.r e, a arrow.r d, b arrow.r e, c arrow.r b, c arrow.r e, e arrow.r d$, plus én kant nederst til højre der varierer. Markér hvilke af Dijkstra (D), Bellman-Ford (BF), DAG-Shortest-Paths (DAG), BFS, DFS (depth-first search) der korrekt beregner korteste veje. \
    #swap[$G_1$]: alle vægte 1. \
    #swap[$G_2$]: $b arrow.r a(1), a arrow.r e(1), a arrow.r d(-1), b arrow.r e(-1), c arrow.r b(1), c arrow.r e(-1), e arrow.r d(1), c arrow.r d(1)$ — DAG med negative kanter, ingen negativ cykel. \
    #swap[$G_3$]: som $G_2$, men nederste kant er $d arrow.r c(1)$ — skaber cyklen $a arrow.r d arrow.r c arrow.r b arrow.r a$ (vægt $+2$); negative kanter, men alle cykler positive. \
    *(b)* Grafer med $n$ knuder, $m = n log n$ kanter. Giv køretiderne for Dijkstra (binær hob), Bellman-Ford og DAG-Shortest-Paths som funktion af $n$.
  ],
  answer: [(a) $G_1$: D, BF, DAG, BFS. $G_2$: BF, DAG. $G_3$: kun BF. DFS aldrig. (b) Dijkstra $O(n (log n)^2)$, Bellman-Ford $O(n^2 log n)$, DAG $O(n log n)$.],
  blueprint: [
    + Tjek hver algoritmes forudsætning mod grafen: D kræver vægte $>= 0$; BF kræver blot ingen negativ cykel; DAG kræver acyklisk; BFS kræver ens vægte; DFS beregner aldrig korteste veje.
    + Sæt $m = n log n$ ind i hver kendt grænse og forenkl: Dijkstra $O((n+m) log n)$, Bellman-Ford $O(n m)$, DAG $O(n + m)$.
  ],
  worked: [
    *(a)*
    - $G_1$: ikke-negativ $+$ acyklisk $+$ ens vægte → D, BF, DAG, BFS.
    - $G_2$: negative kanter (ude: D, BFS), men DAG uden negativ cykel → BF, DAG.
    - $G_3$: negativ kant (ude: D, BFS) og en rettet cykel (ude: DAG), ingen negativ cykel → kun BF.

    DFS markeres aldrig — den beregner ikke korteste veje.

    *(b)* Indsæt $m = n log n$:
    #eq[$
      &"Dijkstra:" quad O((n+m) log n) = O((n + n log n) log n) = O(n (log n)^2). \
      &"Bellman-Ford:" quad O(n m) = O(n dot n log n) = O(n^2 log n). \
      &"DAG-Shortest-Paths:" quad O(n + m) = O(n log n).
    $]
  ],
)
