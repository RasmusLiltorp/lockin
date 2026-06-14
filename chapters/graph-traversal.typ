#import "../lib.typ": *

== Grafgennemløb og sammenhængskomponenter

Et grafgennemløb starter i én knude og udforsker grafen kant for kant. Hver knude farves hvid (ikke set), grå (set, ikke færdig) eller sort (færdig). Metoderne adskiller sig kun i, hvilken grå knude du arbejder videre på.

BFS bruger en kø (FIFO), breder sig ud i ringe og finder den korteste vej i antal kanter.

DFS bruger en stak eller rekursion, dykker så dybt den kan før den vender om, og giver hver knude tidsstempler for opdagelse og afslutning.

Til eksamen kører du typisk BFS eller DFS i hånden på en lille orienteret graf, klassificerer kanter, laver en topologisk sortering eller tæller sammenhængskomponenter. Begge kører i

#eq[$ O(n + m) $]

hvor $n$ er antal knuder og $m$ antal kanter.

=== Sådan løser du den

#recipe(
  title: "DFS i hånden",
  [Sortér hver naboliste #swap[alfabetisk]; det gør rækkefølgen entydig.],
  [Hold én global tæller `time = 0`. Start i den givne knude #swap[$a$].],
  [Opdag en hvid knude (hvid #sym.arrow.r grå): `time += 1`, `u.d = time`. Gå ned i dens første ubrugte hvide nabo.],
  [Ingen ubrugte hvide naboer tilbage: afslut knuden (grå #sym.arrow.r sort): `time += 1`, `u.f = time`, og gå tilbage.],
  [Er der hvide knuder tilbage efter starttræet, starter det ydre loop i næste hvide knude.],
)

Hver knude får et interval $[d, f]$. To tik per knude giver sidste afslutningstid

#eq[$ 2n $]

#note[Intervallerne nestes som parenteser: $[u.d, u.f]$ og $[v.d, v.f]$ er enten adskilte eller det ene ligger helt inde i det andet. En knude er grå præcis i sit eget interval.]

#recipe(
  title: "Kantklassifikation (u, v), set fra u",
  [$v$ hvid #sym.arrow.r tree-kant. Her er $u.d < v.d < v.f < u.f$.],
  [$v$ grå #sym.arrow.r back-kant: $v$ er en forfader, der stadig ligger på stakken. En sløjfe til knuden selv tæller med.],
  [$v$ sort og $u.d < v.d$ #sym.arrow.r forward-kant: $v$ er en allerede afsluttet efterkommer.],
  [$v$ sort og $u.d > v.d$ #sym.arrow.r cross-kant: $v$ ligger i et undertræ, der blev afsluttet før.],
)

#trap[En uorienteret graf har kun tree- og back-kanter. Forward- og cross-kanter kræver en orienteret graf. Nævner en MCQ "én kant af hver type", er grafen orienteret.]

#trap[En orienteret graf har en kreds netop hvis DFS finder en back-kant; ingen back-kanter betyder en DAG. Forveksl ikke back-kant med cross-kant.]

#recipe(
  title: "BFS i hånden",
  [Sortér nabolisterne #swap[alfabetisk]. Sæt start #swap[$a$] til $d = 0$ og læg den i køen.],
  [Tag $u$ ud forrest. For hver hvid nabo $v$ i rækkefølge: $v.d = u.d + 1$, $v.pi = u$, læg $v$ bagest.],
  [Køen holder altid de grå knuder, og $d$-værdierne falder aldrig.],
  [Når køen er tom, er `v.d` afstanden fra $s$ til $v$ i kanter, eller $infinity$ hvis $v$ ikke kan nås:],
)

#eq[$ v.d = delta(s, v) $]

#note[Alle knuder i afstand $i$ kommer ud før nogen i afstand $i + 1$. Vil du finde den første med $d = k$, fyld et niveau ad gangen: niveau 1 er de sorterede naboer til $s$, og udvid dem i rækkefølge.]

#recipe(
  title: "Topologisk sortering og komponenter",
  [Topologisk sortering (kun DAG): kør DFS og list knuderne efter faldende `u.f`. Så peger hver kant fra venstre mod højre. Tjek en foreslået rækkefølge ved at se, at hver kant $u arrow v$ har $u$ før $v$.],
  [Sammenhængskomponenter (uorienteret): kør DFS eller BFS med et ydre loop. Hvert ydre kald fejer en hel komponent, så tæl kaldene.],
  [Stærkt sammenhængende komponenter (orienteret, Kosaraju): kør DFS på $G$ og gem afslutningstider. Vend alle kanter til $G^T$. Kør DFS på $G^T$ med knuderne i faldende afslutningsrækkefølge; hvert træ er én SCC.],
)

=== Tilbagevendende eksamensspørgsmål

#qcard(
  source: "MCQ juni 2023, spm. 14",
  prompt: [Udfør BFS($G$, $a$) med start i knude $a$ og nabolister sorteret alfabetisk. Orienterede kanter: $f arrow g$, $g arrow j$, $i arrow j$, $c arrow f$, $c arrow g$, $d arrow g$, $d arrow i$, $h arrow c$, $b arrow c$, $e arrow b$, $e arrow j$, $a arrow d$, $a arrow e$. Hvilken knude er den første, der får tildelt $d$-værdi (afstand) #swap[$4$]?],
  options: ([$c$], [$f$], [$h$], [$i$], [$j$]),
  answer: [(b) $f$.],
  worked: [Niveau for niveau fra $a$: $d = 1$: $d, e$. $d = 2$: $g, i$ (fra $d$), $b, j$ (fra $e$). $d = 3$: $c$ (fra $b$). $d = 4$: $f$ (fra $c$). Først til afstand 4 er $f$.],
)

#qcard(
  source: "MCQ juni 2023, spm. 16",
  prompt: [DFS-Visit($G$, $a$) på den orienterede graf med kanter $a arrow b$, $b arrow c$, $c arrow d$, $a arrow e$, $b arrow f$, $c arrow f$, $c arrow g$, $f arrow a$, $f arrow g$, $d arrow h$, $h arrow g$. Hvor mange #swap[forward-kanter] er der i dette gennemløb?],
  options: ([$0$], [$1$], [$2$], [$3$], [$4$]),
  answer: [(c) $2$.],
  worked: [Tider: $a(1\/16)$, $b(2\/13)$, $c(3\/12)$, $d(4\/9)$, $h(5\/8)$, $g(6\/7)$, $f(10\/11)$, $e(14\/15)$. Back-kant: $f arrow a$ ($a$ grå). Cross-kant: $f arrow g$ ($g$ sort, $d[f] = 10 > d[g] = 6$). Forward-kanter: $c arrow g$ ($d[c] = 3 < d[g] = 6$) og $b arrow f$ ($d[b] = 2 < d[f] = 10$). I alt 2.],
)

#qcard(
  source: "MCQ juni 2023, spm. 17",
  prompt: [Orienteret graf med kanter $a arrow b$, $a arrow d$, $b arrow c$, $b arrow d$, $b arrow e$, $c arrow f$, $e arrow f$, $g arrow c$, $g arrow f$. Hvilke lister er en topologisk sortering? (Et eller flere svar.)],
  options: (
    [$a, b, c, d, e, f, g$],
    [$a, b, e, d, c, g, f$],
    [$a, b, e, d, g, c, f$],
    [$a, b, g, c, e, d, f$],
    [$g, a, b, e, c, f, d$],
  ),
  answer: [(c), (d) og (e).],
  worked: [Hver kant $u arrow v$ skal have $u$ før $v$. Bindinger: $g$ før $c, f$; $b$ før $c, d, e$; $c, e$ før $f$. (a) og (b) sætter $g$ efter $c$ og bryder $g arrow c$. (c), (d), (e) overholder alle kanter.],
)

#qcard(
  source: "MCQ juni 2015, spm. 10",
  prompt: [Udfør DFS med start i $i$ med nabolisterne sorteret alfabetisk. Hvilken knude får opdagelsestid (starttid) #swap[$12$]? Hjulgraf med center $i$ og ydre knuder $a$ til $h$. Eger: $i arrow a$, $i arrow b$, $c arrow i$, $i arrow d$, $e arrow i$, $f arrow i$, $i arrow g$, $i arrow h$. Ydre kanter: $h arrow a$, $b arrow a$, $b arrow c$, $d arrow c$, $e arrow d$, $f arrow e$, $g arrow f$, $g arrow h$.],
  options: (
    [Knuden $d$],
    [Knuden $e$],
    [Knuden $f$],
    [Knuden $g$],
    [Ingen knude har starttid 12],
  ),
  answer: [(b) knuden $e$.],
  worked: [Naboliste (sorteret): $i:[a, b, d, g, h]$, $b:[a, c]$, $c:[i]$, $d:[c]$, $e:[d, i]$, $f:[e, i]$, $g:[f, h]$, $h:[a]$. DFS fra $i$: $i$ opd 1; $a$ opd 2 afs 3; $b$ opd 4; $c$ opd 5 afs 6; $b$ afs 7; $d$ opd 8 afs 9; $g$ opd 10; $f$ opd 11; $e$ opd 12 afs 13; $f$ afs 14; $h$ opd 15 afs 16; $g$ afs 17; $i$ afs 18. Opdagelsestid 12 er $e$.],
)
