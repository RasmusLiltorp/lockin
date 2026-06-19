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
    + *$G_1$* — BFS fra $s$. Alle kanter koster 1, så afstand $=$ antal kanter. Afstande:
      #eq[$ v_00=0, v_01=1, v_02=3, v_10=3, v_11=2, v_12=2, v_20=4, v_21=4, v_22=3. $]

    + *$G_2$* — DAG med negative vægte. Topo-orden $v_00, v_01, v_02, v_10, v_11, v_12, v_20, v_21, v_22$; ét gennemløb relakserer alt korrekt. Fx $v_02 = 3 + (-5) = -2$, $v_11 = min(3-5, 1+1) = -2$, $v_21 = min(1-2, -2+2) = -1$. Afstande:
      #eq[$ 0, 3, -2, 1, -2, -1, 5, -1, 1. $]

    + *$G_3$* — ikke-negativ med cykler, så Dijkstra. BFS dur ikke (vægtene er forskellige), topo-orden dur ikke (cykler). Afstande:
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
    + *BFS* (alle vægte ens): $G_1$ ja (alt vægt 1); $G_2$ nej (10 og 1); $G_3$ nej (blandede). → *kun $G_1$*.
    + *DAG-Shortest-Paths* (acyklisk): $G_1$ ja; $G_2$ nej (cykel $a arrow.r c arrow.r b arrow.r a$); $G_3$ ja (negativ kant er tilladt). → *$G_1, G_3$*.
    + *Dijkstra* (vægte $>= 0$): $G_1$ ja; $G_2$ ja (cykel er ok); $G_3$ nej ($a arrow.r c = -3 < 0$). → *$G_1, G_2$*.
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
    Efter $|V|-1$ gennemløb stabiliserer afstandene sig:
    #eq[$ a{=}0, quad b{=}17, quad c{=}9, quad d{=}1, quad e{=}7, quad f{=}10, quad g{=}12, quad h{=}0. $]
    Vejene der realiserer dem: $a arrow.r f arrow.r h$ giver $h{=}0$; $a arrow.r b arrow.r g$ giver $g{=}12$; $g arrow.r c$ giver $c{=}9$; $h arrow.r d$ giver $d{=}1$; $d arrow.r e$ giver $e{=}7$. Ingen negativ cykel er nåelig fra $a$, så værdierne er endelige.
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
    + $a(0)$: $i = 7$.
    + $i(7)$: $h{=}24$, $b{=}13$, $d{=}25$.
    + $b(13)$: $c = 13{+}2 = 15$.
    + $c(15)$: $c arrow.r d = 26 > 25$, ingen ændring.
    + $h(24)$: $g = 24{+}9 = 33$.
    + $d(25)$: ingen ud-kanter.
    + $g(33)$: $f = 33{+}10 = 43$.
    + $f(43)$: $e = 43{+}15 = 58$.
    + $e(58)$: alt allerede færdigt.

    Endelige $v.d$: $a{=}0, i{=}7, b{=}13, c{=}15, h{=}24, d{=}25, g{=}33, f{=}43, e{=}58$.
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
    Extract-Min-rækkefølge med endelig afstand:
    #eq[$ a(0), b(6), e(14), c(15), d(17), g(22), i(26), f(29), j(38), h(39). $]
    Centrale relaksationer: $b$ via $a arrow.r b = 6$; $e$ via $b arrow.r e = 14$; $c$ via $b arrow.r c = 15$; $d$ via $c arrow.r d = 17$; $g$ via $d arrow.r g = 22$; $i$ via $g arrow.r i = 26$; $f$ via $i arrow.r f = 29$ (slår $c arrow.r f = 31$ og $e arrow.r f = 35$); $j$ via $i arrow.r j = 38$; $h$ via $j arrow.r h = 39$ (slår $f arrow.r h = 44$).
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
    Afstand og forgænger (træ-forælder):
    #eq[$
      &A{:}1{<-}s, quad B{:}12{<-}s, quad G{:}17{<-}B, quad I{:}21{<-}G, quad H{:}25{<-}G, \
      &C{:}34{<-}G, quad F{:}36{<-}I, quad D{:}41{<-}C, quad R{:}42{<-}C, quad E{:}44{<-}D, quad Q{:}44{<-}R, quad P{:}52{<-}R.
    $]
    Træ-kanter (rod $s$): $s{-}A, s{-}B, B{-}G, G{-}I, G{-}H, G{-}C, I{-}F, C{-}D, C{-}R, D{-}E, R{-}Q, R{-}P$. Fx slår $s arrow.r B arrow.r G arrow.r C = 34$ den direkte $s arrow.r B arrow.r C = 42$. Dijkstra er korrekt fordi alle vægte er $>= 0$: en settlet knudes $d$ er endelig.
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
    Settle-orden $A, B, D, G, E, F, C, H, I$. Afstand og forælder:
    #eq[$
      &B{:}2{<-}A, quad D{:}6{<-}A, quad E{:}7{<-}B, quad G{:}7{<-}D, quad F{:}8{<-}E, \
      &C{:}9{<-}B, quad H{:}10{<-}D, quad I{:}12{<-}F.
    $]
    $E$ nås billigst via $B$ ($2{+}5{=}7$), ikke via $D$ ($6{+}5{=}11$); $F$ via $E$ ($7{+}1{=}8$); $C$ via $B$ ($2{+}7{=}9$), ikke via $F$ ($8{+}5{=}13$).
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
    Sorteret: $(g,h){-}12, (f,h){-}10, (b,g){-}5, (e,h){-}4, (g,c){-}3, (h,d)1, (c,d)2, (d,e)6, (a,e)8, ...$

    + $(g,h){-}12$ — tilføj.
    + $(f,h){-}10$ — tilføj.
    + $(b,g){-}5$ — tilføj.
    + $(e,h){-}4$ — tilføj.
    + $(g,c){-}3$ — tilføj.
    + $(h,d)1$ — tilføj. Derefter $(c,d)2$ og $(d,e)6$ springes over (kreds).
    + $(a,e)8$ — tilføj. Nu 7 kanter, stop.

    Totalvægt $= -12-10-5-4-3+1+8 = -25$.
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
    Scan i vægtorden (tilføj hvis komponenterne er forskellige):
    #eq[$
      &(j,h)1 ✓, quad (c,d)2 ✓, quad (i,f)3 ✓, quad (i,g)4 ✓, quad (g,d)5 ✓, \
      &(a,b)6 ✓, quad (g,c)7 mono("(spring)"), quad (e,b)8 ✓, quad (b,c)9 ✓, quad (j,i)12 ✓.
    $]
    9 kanter nået, stop. Totalvægt $= 1{+}2{+}3{+}4{+}5{+}6{+}8{+}9{+}12 = 50$.
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
    Kruskal-orden ($n-1 = 12$ kanter):
    #eq[$
      &s{-}A(1), Q{-}R(2), D{-}E(3), G{-}I(4), B{-}G(5), H{-}I(6), C{-}D(7), R{-}C(8), \
      &P{-}Q(9), D{-}F(11), s{-}B(12), F{-}I(15).
    $]
    Sprunget over som kredse: $G{-}H(8), P{-}R(10), A{-}B(13), E{-}F(14), R{-}D(15), C{-}G(17), B{-}C(30)$. Totalvægt $= 83$.

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
    + $a(0)$: $b{=}4, h{=}8, i{=}7$.
    + $b(4)$, kant $(a,b)$: $c{=}2, i{=}6$ ($6 < 7$).
    + $c(2)$, kant $(b,c)$: $d{=}11$.
    + $i(6)$, kant $(b,i)$: $f{=}5, e{=}14, g{=}13$.
    + $f(5)$, kant $(i,f)$: $g{=}10$ ($10 < 13$).
    + $h(8)$, kant $(a,h)$: $g{=}9$ ($9 < 10$).
    + $g(9)$, kant $(h,g)$.
    + $d(11)$, kant $(c,d)$.
    + $e(14)$, kant $(i,e)$.

    MST-kanter: $(a,b),(b,c),(b,i),(i,f),(a,h),(h,g),(c,d),(i,e)$. Totalvægt $= 4{+}2{+}6{+}5{+}8{+}9{+}11{+}14 = 59$.
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
    Greedy fra $A$ — letteste kant ud af træet hver gang:
    #eq[$ A{-}B(2), B{-}E(5), E{-}F(1), E{-}H(3), H{-}I(2), H{-}D(4), D{-}G(1), F{-}C(5). $]
    Totalvægt $= 2{+}5{+}1{+}3{+}2{+}4{+}1{+}5 = 23$ (samme total som Kruskal giver).
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

    + *(c) Dijkstra.* Extract-Min-orden med endelige afstande: $s{=}0$ (relaksér $T R{=}17, M L{=}15, C{=}35$) $arrow.r M L{=}10$ ($s arrow.r M L = 10$ slår $15$) $arrow.r T R{=}17$ ($M R{=}21, C{=}26$) $arrow.r M R{=}21$ ($B R{=}23, C{=}24$) $arrow.r B R{=}23$ ($C{=}24$) $arrow.r C{=}24$. $B L$ har ingen indkant fra det nåelige sæt, så $B L = oo$. Tjek $C$: bedste indgang er $B R arrow.r C$ med $23{+}1 = 24$.
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
    + $a(0)$: $b{<-}17, e{<-}11, d{<-}8$.
    + $d(8)$, kant $(a,d)$: $c{<-}25$ ($e{:}18$ ikke $< 11$).
    + $e(11)$, kant $(a,e)$: $b{<-}5, c{<-}3$.
    + $c(3)$, kant $(e,c)$: ($b{:}14$ ikke $< 5$).
    + $b(5)$, kant $(e,b)$.

    Extract-Min-orden $a, d, e, c, b$. MST-kanter $(a,d){=}8, (a,e){=}11, (e,c){=}3, (e,b){=}5$, totalvægt $= 27$.
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
