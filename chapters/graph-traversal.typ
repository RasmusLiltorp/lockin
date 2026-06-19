#import "../lib.typ": *

== Grafgennemløb og sammenhængskomponenter <th-graph-intro>

Et grafgennemløb (graph traversal) starter i én knude og udforsker grafen kant for kant. Hver knude farves hvid (ikke set), grå (set, ikke færdig) eller sort (færdig). Metoderne adskiller sig kun i, hvilken grå knude du arbejder videre på.

BFS (breadth-first search) bruger en kø (FIFO), breder sig ud i ringe og finder den korteste vej (shortest path) i antal kanter.

DFS (depth-first search) bruger en stak eller rekursion, dykker så dybt den kan før den vender om, og giver hver knude tidsstempler (timestamps) for opdagelse og afslutning.

Til eksamen kører du typisk BFS eller DFS i hånden på en lille orienteret graf (directed graph), klassificerer kanter, laver en topologisk sortering (topological sort) eller tæller sammenhængskomponenter (connected components). Begge kører i

#eq[$ O(n + m) $]

hvor $n$ er antal knuder og $m$ antal kanter.

=== Sådan løser du den

#metadata(none) <th-graph-dfs>
#recipe(
  title: "DFS i hånden",
  [Sortér hver naboliste (adjacency list) #swap[alfabetisk]; det gør rækkefølgen entydig.],
  [Hold én global tæller `time = 0`. Start i den givne knude #swap[$a$].],
  [Opdag en hvid knude (hvid #sym.arrow.r grå): `time += 1`, `u.d = time`. Gå ned i dens første ubrugte hvide nabo.],
  [Ingen ubrugte hvide naboer tilbage: afslut knuden (grå #sym.arrow.r sort): `time += 1`, `u.f = time`, og gå tilbage.],
  [Er der hvide knuder tilbage efter starttræet, starter det ydre loop i næste hvide knude.],
)

Hver knude får et interval $[d, f]$. To tik per knude giver sidste afslutningstid

#eq[$ 2n $]

#note(title: [Parentes-strukturen])[Intervallerne nestes som parenteser: $[u.d, u.f]$ og $[v.d, v.f]$ er enten adskilte eller det ene ligger helt inde i det andet. En knude er grå præcis i sit eget interval.]

Du står i $u$ og følger en kant til $v$. Stil ét spørgsmål: hvilken farve har $v$ lige nu? Farven siger, hvor $v$ ligger i forhold til dig. Hvid er forude, grå er bag dig på vejen ned (en forfader), sort er noget du er færdig med. Er $v$ sort, afgør starttiderne om du peger nedad eller til siden.

#metadata(none) <th-graph-edge-class>
#recipe(
  title: "Kantklassifikation (u, v), set fra u",
  [$v$ #strong[hvid] #sym.arrow.r tree-kant. Du opdager $v$ gennem kanten, så den bliver dit barn i træet. Intervallet for $v$ ligger inde i $u$'s: $u.d < v.d < v.f < u.f$.],
  [$v$ #strong[grå] #sym.arrow.r back-kant. $v$ er en forfader, der stadig ligger på stakken, så kanten peger opad mod roden. En sløjfe til knuden selv tæller med. Bare én back-kant betyder, at grafen har en kreds (cycle).],
  [$v$ #strong[sort], og $u.d < v.d$ #sym.arrow.r forward-kant. Du peger nedad til en efterkommer, du allerede har nået og afsluttet ad en kortere vej.],
  [$v$ #strong[sort], og $u.d > v.d$ #sym.arrow.r cross-kant. $v$ hører til et andet undertræ, der blev færdigt, før du nåede $u$. Kanten peger til siden.],
)

#align(center)[
  #table(
    columns: 4,
    align: (left, left, left, center),
    stroke: none,
    inset: (x: 12pt, y: 7pt),
    table.header(
      [*Type*], [*Tider for $u arrow v$*], [*$v$'s farve*], [*Retning*],
    ),
    table.hline(stroke: 0.4pt + hair),
    [tree], [$v$ inde i $u$ (opdager $v$)], [hvid], [ned],
    [back], [$u$ inde i $v$], [grå], [op],
    [forward], [$v$ inde i $u$, $v$ allerede set], [sort, $u.d < v.d$], [ned],
    [cross], [adskilte ($v.f < u.d$)], [sort, $u.d > v.d$], [til siden],
  )
]

Sagt helt enkelt, med et eksempel fra grafen ovenfor (DFS fra $i$):

- #strong[tree]: kanten du går ned ad, første gang du møder en ny knude. Ved $i arrow b$ står du i $i$, $b$ er ikke set endnu, så du hopper ned i $b$. Nu er $i$ forælder til $b$.
- #strong[back]: en kant tilbage op til en knude, du stadig er på vej ned fra. $a arrow i$ peger fra $a$ op til $i$, som $a$ hænger under.
- #strong[forward]: en genvej ned til en knude, du allerede har nået ad en længere vej. $i arrow h$ går direkte fra $i$ til $h$, men du fandt $h$ først langt nede via $g arrow h$.
- #strong[cross]: en kant over til en helt anden gren, der allerede er færdig. Ved $d arrow c$ ligger $c$ under $b$ og $d$ under $i$, og $c$ blev færdig længe før du nåede $d$.

#trap(title: [Uorienteret kanttype])[En uorienteret graf (undirected graph) har kun tree- og back-kanter. Forward- og cross-kanter kræver en orienteret graf. Nævner en MCQ "én kant af hver type", er grafen orienteret.]

#trap(title: [Back-kant og kredse])[En orienteret graf har en kreds netop hvis DFS finder en back-kant; ingen back-kanter betyder en DAG (directed acyclic graph). Forveksl ikke back-kant med cross-kant.]

#metadata(none) <th-graph-bfs>
#recipe(
  title: "BFS i hånden",
  [Sortér nabolisterne #swap[alfabetisk]. Sæt start #swap[$a$] til $d = 0$ og læg den i køen.],
  [Tag $u$ ud forrest. For hver hvid nabo $v$ i rækkefølge: $v.d = u.d + 1$, $v.pi = u$, læg $v$ bagest.],
  [Køen holder altid de grå knuder, og $d$-værdierne falder aldrig.],
  [Når køen er tom, er `v.d` afstanden fra $s$ til $v$ i kanter, eller $infinity$ hvis $v$ ikke kan nås:],
)

#eq[$ v.d = delta(s, v) $]

#note(title: [BFS niveaurækkefølge])[Alle knuder i afstand $i$ kommer ud før nogen i afstand $i + 1$. Vil du finde den første med $d = k$, fyld et niveau ad gangen: niveau 1 er de sorterede naboer til $s$, og udvid dem i rækkefølge.]

#metadata(none) <th-graph-toposort>
#metadata(none) <th-graph-components>
#metadata(none) <th-graph-scc>
#recipe(
  title: "Topologisk sortering og komponenter",
  [Topologisk sortering (kun DAG): kør DFS og list knuderne efter faldende `u.f`. Så peger hver kant fra venstre mod højre. Tjek en foreslået rækkefølge ved at se, at hver kant $u arrow v$ har $u$ før $v$.],
  [Sammenhængskomponenter (uorienteret): kør DFS eller BFS med et ydre loop. Hvert ydre kald fejer en hel komponent, så tæl kaldene.],
  [Stærkt sammenhængende komponenter (strongly connected components) (orienteret, Kosaraju): kør DFS på $G$ og gem afslutningstider. Vend alle kanter til $G^T$. Kør DFS på $G^T$ med knuderne i faldende afslutningsrækkefølge; hvert træ er én SCC.],
)

#note(title: [Hvad er en SCC])[En stærk sammenhængskomponent (SCC) er en gruppe knuder, hvor der findes en vej frem og tilbage mellem alle punkter i gruppen. To krav skal være opfyldt. For det første skal alle kunne nå alle, så starter du i et hvilket som helst punkt i gruppen, kan du følge pilene hen til ethvert andet punkt i gruppen. For det andet skal gruppen være maksimal, så du kan ikke tage et ekstra punkt udefra med, uden at reglen om at alle kan nå alle går i stykker. Et punkt du kun kan rejse til, men ikke fra, danner sin egen gruppe på ét punkt.]

#trap(title: [Et enkelt punkt er også en SCC])[Det føles som snyd, at en enlig knude tæller som en hel komponent. Men en knude kan altid nå sig selv via vejen med nul pile. Står $a$ alene, skal den kun nå sig selv for at opfylde "alle kan nå alle", og det kan den. Grunden til at $a$ havner alene er udelukkelse. Den kan ikke dele gruppe med $b$, for fra $b$ når du $a$, men aldrig tilbage til $b$. Og den kan ikke dele gruppe med $f$, for fra $a$ når du slet ikke $f$. Når $a$ ikke kan være i gruppe med nogen, og hver knude skal høre til præcis én komponent, ender den på sin egen ø. Det er derfor ${a}$, ${f}$, ${e}$ og ${i}$ hver tæller med.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [BFS: kør i hånden, find afstand/rækkefølge (BFS)],
  source: "MCQ juni 2023, spm. 14",
  theory: <th-graph-bfs>,
  prompt: [Udfør BFS($G$, $a$) med start i knude $a$ og nabolister sorteret alfabetisk. Orienterede kanter: $f arrow g$, $g arrow j$, $i arrow j$, $c arrow f$, $c arrow g$, $d arrow g$, $d arrow i$, $h arrow c$, $b arrow c$, $e arrow b$, $e arrow j$, $a arrow d$, $a arrow e$. Hvilken knude er den første, der får tildelt $d$-værdi (afstand) #swap[$4$]?],
  options: ([$c$], [$f$], [$h$], [$i$], [$j$]),
  answer: [(b) $f$.],
  blueprint: [
    Skal du finde den første knude med en bestemt afstand, kører du BFS niveau for niveau og skriver afstanden på, efterhånden som knuderne kommer ud af køen.

    + Sortér hver naboliste alfabetisk og giv startknuden #swap[$a$] afstanden $d = 0$.
    + Bred dig ud ét niveau ad gangen. Knuderne i afstand $k$ giver alle deres ubesøgte naboer afstand $k + 1$.
    + Tag knuderne alfabetisk inden for hvert niveau, så den første med afstanden #swap[$4$] bliver entydig.
    + Stop ved det niveau du leder efter, og læs den første knude af.
  ],
  worked: [
    Grafen her, start i $a$, naboer sorteret.

    + $d = 0$: $a$.
    + $d = 1$: $a$ peger på $d, e$.
    + $d = 2$: $d$ giver $g, i$, og $e$ giver $b, j$.
    + $d = 3$: $b$ giver $c$.
    + $d = 4$: $c$ giver $f$.

    Første knude i afstand 4 er $f$.

    Svar: (b) $f$.
  ],
)

#qcard(
  tag: [BFS: kør i hånden, find afstand/rækkefølge (BFS)],
  source: "MCQ juni 2019, Spm. 14",
  theory: <th-graph-bfs>,
  prompt: [Udfør BFS($G_2$, $c$) med start i knude $c$ og nabolister sorteret alfabetisk. Orienterede kanter: $a arrow b$, $a arrow f$, $b arrow f$, $b arrow g$, $c arrow b$, $c arrow d$, $c arrow g$, $c arrow h$, $d arrow h$, $d arrow i$, $e arrow d$, $e arrow i$, $f arrow g$, $h arrow i$. Hvilken knude er den #swap[første], der får tildelt $d$-værdi (afstand) #swap[$2$]?],
  options: ([$a$], [$b$], [$d$], [$e$], [$f$], [$g$], [$h$], [$i$]),
  answer: [Mulighed (e): $f$.],
  blueprint: [
    Leder du efter den første knude med en bestemt afstand, kører du BFS niveau for niveau og noterer afstanden i den rækkefølge, knuderne kommer ud af køen.

    + Sortér hver naboliste alfabetisk og giv startknuden #swap[$c$] afstanden $d = 0$.
    + Tag knuderne ud forrest i køen. Hver knude i afstand $k$ giver sine ubesøgte naboer afstand $k + 1$.
    + Hold styr på rækkefølgen: inden for samme niveau afgør køens FIFO-orden, hvem der tildeles først.
    + Læs den første knude af, der rammer afstanden #swap[$2$].
  ],
  worked: [
    Grafen her, start i $c$, naboer sorteret.

    + $d = 0$: $c$.
    + $d = 1$: $c$ peger på $b, d, g, h$ (i den orden).
    + Tag $b$ ud først; $b$'s naboer er $f, g$. $g$ har allerede $d = 1$, så $f$ får $d = 2$ først.

    Rækkefølge: $c(0), b(1), d(1), g(1), h(1), f(2), i(2)$. Første knude i afstand 2 er $f$.

    Svar: (e) $f$.
  ],
)

#qcard(
  tag: [BFS: kør i hånden, find afstand/rækkefølge (BFS)],
  source: "MCQ juni 2019, Spm. 15",
  theory: <th-graph-bfs>,
  prompt: [Fortsæt med BFS på den #swap[uorienterede] graf $G_2$ med start i knude $c$. Kanter: $a - f$, $f - g$, $f - b$, $b - g$, $c - g$, $c - b$, $c - d$, $h - i$, $h - d$, $d - i$, $e - d$, $e - i$. Hvilken knude er den #swap[sidste], der får tildelt $d$-værdi (afstand) #swap[$3$]?],
  options: ([$a$], [$b$], [$d$], [$e$], [$f$], [$g$], [$h$], [$i$]),
  answer: [Mulighed (a): $a$.],
  blueprint: [
    Her er grafen uorienteret, så hver kant kan bruges begge veje. Du samler alle knuder med den ønskede afstand og tager den sidste.

    + Byg nabolisterne, hvor hver kant tæller i begge retninger, og giv #swap[$c$] afstanden $0$.
    + Kør BFS niveau for niveau; hver ny knude $v$ får $d[v] = d[u] + 1$.
    + Saml alle knuder, der får afstanden #swap[$3$], i tildelingsrækkefølge.
    + Svaret er den #swap[sidste] af dem (den, der nås længst ude).
  ],
  worked: [
    Grafen her, uorienteret, start i $c$.

    + $d = 0$: $c$.
    + $d = 1$: naboer til $c$ er $b, d, g$.
    + $d = 2$: $b$ giver $f$; $d$ giver $e, h, i$.
    + $d = 3$: eneste tilbageværende knude er $a$, nået via $f$.

    $a$ er den eneste i afstand 3 og dermed også den sidste.

    Svar: (a) $a$.
  ],
)

#qcard(
  tag: [BFS: kør i hånden, find afstand/rækkefølge (BFS)],
  source: "MCQ juni 2019, Spm. 16",
  theory: <th-graph-bfs>,
  prompt: [Fortsæt med BFS på den orienterede graf $G_2$ med start i knude $c$. Kanter: $a arrow f$, $a arrow b$, $f arrow g$, $b arrow f$, $b arrow g$, $c arrow b$, $c arrow g$, $c arrow h$, $h arrow i$, $d arrow h$, $d arrow i$, $e arrow d$, $e arrow i$. Hvor mange knuder har $d$-værdi #swap[$infinity$], når algoritmen stopper (altså er #swap[unåelige] fra $c$)?],
  options: ([$0$], [$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [Mulighed (d): $3$.],
  blueprint: [
    Spørger opgaven om unåelige knuder, kører du BFS fra kilden og tæller, hvor mange der aldrig forlader $infinity$.

    + Skriv kanterne op med korrekt pileretning. Følg kun pile fremad.
    + Sæt alle $d$-værdier til $infinity$, undtagen kilden #swap[$c$] med $d = 0$.
    + Kør BFS; ved første opdagelse sættes $d(v) = d(u) + 1$.
    + Enhver knude, der stadig har $d = infinity$ til sidst, er unåelig. Tæl dem.
  ],
  worked: [
    Grafen her, orienteret, start i $c$.

    + Nået: $c(0)$; så $c arrow b$, $c arrow g$, $c arrow h$ giver $b, g, h$ i afstand $1$.
    + $b arrow f$ giver $f$ i afstand $2$; $h arrow i$ giver $i$ i afstand $2$.
    + Nået-mængden er ${c, b, g, h, f, i}$. Ingen af dem peger ind i $a, d, e$.

    Så $a, d, e$ beholder $d = infinity$. Antal $= 3$.

    Svar: (d) $3$.
  ],
)

#qcard(
  tag: [BFS: kør i hånden, find afstand/rækkefølge (BFS)],
  source: "MCQ juni 2021, Spm. 14",
  theory: <th-graph-bfs>,
  prompt: [Udfør BFS($G$, $a$) på den orienterede graf med start i $a$ og nabolister sorteret alfabetisk. Kanter: $a arrow g$, $g arrow j$, $g arrow c$, $c arrow a$, $c arrow h$, $h arrow g$, $h arrow j$, $h arrow.l.r d$, $h arrow.l.r e$, $d arrow j$, $d arrow.l.r i$, $i arrow j$, $b arrow c$, $b arrow h$, $e arrow b$, $e arrow d$, $e arrow.l.r f$, $f arrow b$. Hvilken liste giver #swap[rækkefølgen, knuderne lægges i køen $Q$]?],
  options: (
    [$a, g, c, h, d, i, j, e, b, f$],
    [$a, g, c, j, h, d, e, i, f, b$],
    [$a, g, j, c, h, d, e, i, f, b$],
    [$a, g, c, j, h, d, e, i, b, f$],
  ),
  answer: [Mulighed (d): $a, g, c, j, h, d, e, i, b, f$.],
  blueprint: [
    Spørgsmålet er køens indsættelsesrækkefølge. Du kører BFS og skriver hver knude på listen i det øjeblik, den lægges bagest i køen.

    + Skriv alle kanter op. En dobbeltpil ($arrow.l.r$) tæller som #swap[to] orienterede kanter.
    + Sortér hver ud-naboliste alfabetisk og læg startknuden #swap[$a$] i køen.
    + Tag en knude ud forrest, gå dens sorterede naboer igennem, og for hver ubesøgt: markér, føj til listen, læg bagest.
    + Listen, du bygger, er svaret.
  ],
  worked: [
    Grafen her, start i $a$, ud-lister sorteret.

    + Lister: $a:[g]$, $g:[c, j]$, $c:[a, h]$, $h:[d, e, g, j]$, $d:[h, i, j]$, $i:[d, j]$, $e:[b, d, f, h]$, $b:[c, h]$, $f:[b, e]$, $j:[]$.
    + $a$ lægger $g$; $g$ lægger $c, j$; $c$ ($a$ set) lægger $h$; $j$ intet; $h$ ($g, j$ set) lægger $d, e$; $d$ ($h, j$ set) lægger $i$; $e$ ($d, h$ set) lægger $b, f$; $i, b, f$ alle set.

    Rækkefølge: $a, g, c, j, h, d, e, i, b, f$.

    Svar: (d).
  ],
)

#qcard(
  tag: [BFS: kør i hånden, find afstand/rækkefølge (BFS)],
  source: "MCQ juni 2025, Spm. 15",
  theory: <th-graph-bfs>,
  prompt: [Udfør BFS($G$, $a$) på den #swap[uorienterede] graf med start i $a$ og nabolister sorteret alfabetisk. Kanter: $j - c$, $j - i$, $c - e$, $e - h$, $h - i$, $a - b$, $b - f$, $f - g$, $c - a$, $e - b$, $h - f$, $i - g$. Hvilken knude er den #swap[sidste], der får tildelt $d$-værdi (afstand) #swap[$3$]?],
  options: ([$e$], [$f$], [$g$], [$h$], [$i$], [$j$]),
  answer: [Mulighed (e): $i$.],
  blueprint: [
    Samme idé som de øvrige BFS-spørgsmål: byg nabolisterne, kør niveau for niveau, og tag den sidste knude med den ønskede afstand.

    + Byg nabolisterne (uorienteret: hver kant begge veje) og sortér dem alfabetisk. Sæt #swap[$a$] til $d = 0$.
    + Kør BFS med FIFO-kø; ved opdagelse sættes $d(v) = d(u) + 1$.
    + Saml knuderne med afstanden #swap[$3$] i tildelingsrækkefølge.
    + Svaret er den #swap[sidste] af dem.
  ],
  worked: [
    Grafen her, uorienteret, start i $a$, naboer sorteret.

    + Lister: $a:[b, c]$, $b:[a, e, f]$, $c:[a, e, j]$, $e:[b, c, h]$, $f:[b, g, h]$, $g:[f, i]$, $h:[e, f, i]$, $i:[g, h, j]$, $j:[c, i]$.
    + $a = 0$; $b = 1, c = 1$; fra $b$: $e = 2, f = 2$; fra $c$: $j = 2$; fra $e$: $h = 3$; fra $f$: $g = 3$; fra $h$: $i = 3$.

    Knuder med $d = 3$ i orden: $h, g, i$. Sidste er $i$.

    Svar: (e) $i$.
  ],
)

#qcard(
  tag: [DFS: klassificér kanter (tæl forward/back/cross) (Kantklassifikation)],
  source: "MCQ juni 2023, spm. 16",
  theory: <th-graph-edge-class>,
  prompt: [DFS-Visit($G$, $a$) på den orienterede graf med kanter $a arrow b$, $b arrow c$, $c arrow d$, $a arrow e$, $b arrow f$, $c arrow f$, $c arrow g$, $f arrow a$, $f arrow g$, $d arrow h$, $h arrow g$. Hvor mange #swap[forward-kanter] er der i dette gennemløb?],
  options: ([$0$], [$1$], [$2$], [$3$], [$4$]),
  answer: [(c) $2$.],
  blueprint: [
    Kantklassifikation hænger på tidsstemplerne, så du beregner først alle intervaller og bruger derefter farve- og tidsreglen på hver kant.

    + Kør DFS fra #swap[$a$] med alfabetiske nabolister og skriv et interval $[d, f]$ på hver knude.
    + Gå hver ekstra kant igennem. Er $v$ hvid, er det tree; grå er back; sort med $u.d < v.d$ er forward; sort med $u.d > v.d$ er cross.
    + Tæl den type opgaven spørger om, her #swap[forward].
  ],
  worked: [
    Grafen her, start i $a$.

    + Intervaller: $a[1,16]$, $b[2,13]$, $c[3,12]$, $d[4,9]$, $h[5,8]$, $g[6,7]$, $f[10,11]$, $e[14,15]$.
    + $f arrow a$: $a$ er grå, altså back.
    + $f arrow g$: $g$ er sort og $u.d = 10 > 6$, altså cross.
    + $c arrow g$: $g$ er sort og $u.d = 3 < 6$, altså forward.
    + $b arrow f$: $f$ er sort og $u.d = 2 < 10$, altså forward.

    To forward-kanter.

    Svar: (c) $2$.
  ],
)

#qcard(
  tag: [DFS: klassificér kanter (tæl forward/back/cross) (Kantklassifikation)],
  source: "MCQ juni 2015, Spm. 12",
  theory: <th-graph-edge-class>,
  prompt: [Udfør DFS på den orienterede graf med start i $i$ og nabolister sorteret alfabetisk. Kanter: $a arrow i$, $h arrow a$, $b arrow a$, $i arrow b$, $i arrow h$, $i arrow g$, $c arrow i$, $i arrow d$, $e arrow i$, $f arrow i$, $g arrow h$, $g arrow f$, $f arrow e$, $e arrow d$, $d arrow c$, $b arrow c$. Klassificér hver kant (tree, back, forward, cross). Hvilket svar indeholder #swap[præcis én kant af hver type]?],
  options: (
    [$(b,i)$, $(a,b)$, $(b,c)$, $(d,i)$],
    [$(b,i)$, $(a,i)$, $(h,i)$, $(c,d)$],
    [$(g,h)$, $(f,i)$, $(d,e)$, $(a,b)$],
    [$(a,i)$, $(h,i)$, $(d,e)$, $(e,i)$],
  ),
  answer: [Mulighed (b): $(b,i)$, $(a,i)$, $(h,i)$, $(c,d)$.],
  blueprint: [
    Skal du finde en mulighed med én kant af hver type, beregner du først intervallerne og slår derefter hver kant i muligheden op i farve- og tidsreglen.

    + Kør DFS fra #swap[$i$] med alfabetiske nabolister og skriv et interval $[d, f]$ på hver knude.
    + Klassificér: $v$ hvid er tree; $v$ grå er back; $v$ sort med $u.d < v.d$ er forward; $v$ sort med $u.d > v.d$ er cross.
    + Slå de fire kanter i hver mulighed op, og vælg den med præcis én af hver type.
  ],
  worked: [
    Grafen her, start i $i$.

    + Opdagelsesorden: $i(1), b(2), a(3), c(5), d(8), g(10), f(11), e(12), h(15)$.
    + Tree-kanter inkluderer $i arrow b$, $b arrow a$, $b arrow c$, $i arrow g$, $i arrow d$, $g arrow h$, $g arrow f$, $f arrow e$.
    + Mulighed (b): $i arrow b$ = tree, $a arrow i$ = back (peger op til forfader $i$), $i arrow h$ = forward ($h$ opdaget senere ad anden vej), $d arrow c$ = cross ($c$ færdig i andet undertræ). Præcis én af hver.
    + De øvrige: (a) er tree, tree, tree, tree; (c) er tree, back, cross, tree; (d) er back, forward, cross, back.

    Svar: (b).
  ],
)

#qcard(
  tag: [DFS: klassificér kanter (tæl forward/back/cross) (Kantklassifikation)],
  source: "MCQ juni 2017, Spm. 14",
  theory: <th-graph-edge-class>,
  prompt: [Udfør DFS på den orienterede graf $G_1$ med start i $a$ og nabolister sorteret alfabetisk. Kanter: $a arrow b$, $a arrow d$, $b arrow c$, $b arrow d$, $c arrow e$, $c arrow f$, $d arrow e$, $e arrow b$, $e arrow f$, $e arrow g$, $f arrow c$, $f arrow h$, $f arrow i$, $g arrow d$, $g arrow h$, $h arrow e$, $h arrow i$. Klassificér hver kant. Hvilket svar indeholder #swap[præcis én kant af hver type]?],
  options: (
    [$(c,e)$, $(e,g)$, $(h,e)$, $(e,b)$],
    [$(g,h)$, $(h,i)$, $(d,e)$, $(e,f)$],
    [$(b,d)$, $(d,e)$, $(g,d)$, $(g,h)$],
    [$(a,b)$, $(f,c)$, $(f,i)$, $(f,h)$],
  ),
  answer: [Mulighed (c): $(b,d)$, $(d,e)$, $(g,d)$, $(g,h)$.],
  blueprint: [
    Samme metode: byg intervallerne ud fra DFS, og slå derefter de fire kanter i hver mulighed op.

    + Kør DFS fra #swap[$a$] alfabetisk og skriv $[d, f]$ på hver knude.
    + Klassificér hver kant via farve og tider.
    + Find muligheden med én kant af hver af de fire typer.
  ],
  worked: [
    Grafen her, start i $a$.

    + Tree: $a arrow b$, $b arrow c$, $c arrow e$, $e arrow f$, $f arrow h$, $h arrow i$, $e arrow g$, $g arrow d$.
    + Back: $e arrow b$, $f arrow c$, $h arrow e$, $d arrow e$.
    + Forward: $f arrow i$, $b arrow d$, $a arrow d$.
    + Cross: $g arrow h$.
    + Mulighed (c): $(b,d)$ = forward, $(d,e)$ = back, $(g,d)$ = tree, $(g,h)$ = cross. Én af hver.

    Svar: (c).
  ],
)

#qcard(
  tag: [DFS: klassificér kanter (tæl forward/back/cross) (Kantklassifikation)],
  source: "MCQ juni 2021, Spm. 16",
  theory: <th-graph-edge-class>,
  prompt: [Udfør DFS-Visit($G$, $a$) på den orienterede graf med start i $a$ og nabolister sorteret alfabetisk. Kanter: $e arrow.l.r d$, $e arrow a$, $a arrow d$, $a arrow g$, $d arrow g$, $h arrow d$, $h arrow f$, $h arrow.l.r g$, $f arrow g$, $f arrow b$, $i arrow a$, $i arrow g$, $i arrow b$, $g arrow b$, $b arrow.l.r c$. Hvor mange #swap[cross-kanter] findes i dette gennemløb?],
  options: ([$0$], [$1$], [$2$], [$3$], [$4$], [$5$]),
  answer: [Mulighed (e): $4$.],
  blueprint: [
    Cross-tællingen kræver, at du har alle intervaller, så du beregner først DFS-skoven og bruger derefter tidsreglen.

    + Kør DFS-Visit fra #swap[$a$] alfabetisk; fortsæt det ydre loop i resterende hvide knuder alfabetisk. En dobbeltpil er to kanter.
    + Skriv $[d, f]$ på hver knude.
    + Klassificér: $v$ sort med $u.d > v.d$ er cross. Tæl dem.
  ],
  worked: [
    Grafen her, start i $a$.

    + $i$ har ingen indgående kanter, så træet fra $a$ når den aldrig; $i$ starter et nyt DFS-træ.
    + Tider: $a(1,16)$, $d(2,15)$, $e(3,4)$, $g(5,14)$, $b(6,9)$, $c(7,8)$, $h(10,13)$, $f(11,12)$, $i(17,18)$.
    + Cross-kanter er $f arrow b$, $i arrow a$, $i arrow g$, $i arrow b$: hver peger på en knude, der blev færdig før kilden blev opdaget.

    Cross-kanter $= 4$.

    Svar: (e) $4$.
  ],
)

#qcard(
  tag: [DFS: klassificér kanter (tæl forward/back/cross) (Kantklassifikation)],
  source: "MCQ juni 2025, Spm. 17",
  theory: <th-graph-edge-class>,
  prompt: [Fortsæt med DFS-Visit($G$, $a$) fra $a$, nabolister alfabetisk. Orienterede kanter: $a arrow c$, $c arrow e$, $c arrow j$, $e arrow h$, $e arrow b$, $h arrow i$, $h arrow f$, $i arrow g$, $j arrow e$, $j arrow h$, $j arrow i$, $b arrow a$, $f arrow b$, $g arrow f$. Hvor mange #swap[cross-kanter] findes i dette gennemløb?],
  options: ([$0$], [$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [Mulighed (f): $5$.],
  blueprint: [
    Samme cross-tælling: kør DFS, skriv tider på, og tæl de sorte kanter, der peger bagud i tid.

    + Kør DFS-Visit fra #swap[$a$] alfabetisk og skriv $[d, f]$ på hver knude.
    + Klassificér hver kant: hvid = tree, grå = back, sort med $u.d < v.d$ = forward, sort med $u.d > v.d$ = cross.
    + Tæl cross-kanterne.
  ],
  worked: [
    Grafen her, start i $a$.

    + $a arrow c$ (tree), $c arrow e$ (tree), $e arrow b$ (tree), $b arrow a$ back; $e arrow h$ (tree), $h arrow f$ (tree), $f arrow b$ cross; $h arrow i$ (tree), $i arrow g$ (tree), $g arrow f$ cross; $c arrow j$ (tree).
    + $j arrow e$, $j arrow h$, $j arrow i$ peger alle på færdige (sorte) knuder med $d[j] > d["mål"]$ — tre cross-kanter.
    + I alt: 8 tree, 1 back, 5 cross, 0 forward.

    Cross-kanter $= 5$.

    Svar: (f) $5$.
  ],
)

#qcard(
  tag: [Topologisk sortering: er rækkefølgen gyldig? (topologisk sortering)],
  source: "MCQ juni 2023, spm. 17",
  theory: <th-graph-toposort>,
  prompt: [Orienteret graf med kanter $a arrow b$, $a arrow d$, $b arrow c$, $b arrow d$, $b arrow e$, $c arrow f$, $e arrow f$, $g arrow c$, $g arrow f$. Hvilke lister er en topologisk sortering? (Et eller flere svar.)],
  options: (
    [$a, b, c, d, e, f, g$],
    [$a, b, e, d, c, g, f$],
    [$a, b, e, d, g, c, f$],
    [$a, b, g, c, e, d, f$],
    [$g, a, b, e, c, f, d$],
  ),
  answer: [(c), (d) og (e).],
  blueprint: [
    En liste er en topologisk sortering, hvis hver kant peger fremad i listen. Du tjekker hver kant i stedet for at gætte.

    + Skriv alle kanterne op som bindinger, så $u$ skal stå før $v$.
    + Gå hver foreslået liste igennem og find den første kant, der brydes.
    + En liste uden brudt kant er gyldig. Spørger opgaven om #swap[flere svar], saml dem alle.
  ],
  worked: [
    Grafen her.

    + Bindinger: $g$ før $c, f$; $b$ før $c, d, e$; $c, e$ før $f$; $a$ før $b, d$.
    + (a) og (b): $g$ står efter $c$, så $g arrow c$ brydes. Ugyldige.
    + (c), (d) og (e): hver kant peger fremad. Gyldige.

    Svar: (c), (d) og (e).
  ],
)

#qcard(
  tag: [Topologisk sortering: er rækkefølgen gyldig? (topologisk sortering)],
  source: "MCQ juni 2021, Spm. 17 (flere rigtige)",
  theory: <th-graph-toposort>,
  prompt: [Orienteret DAG med kanter $b arrow c$, $b arrow a$, $b arrow d$, $b arrow e$, $c arrow e$, $d arrow e$, $f arrow c$, $f arrow e$. Hvilke lister er en topologisk sortering? (Et eller flere svar.)],
  options: (
    [$a, b, c, d, e, f$],
    [$b, d, f, c, e, a$],
    [$f, e, d, c, b, a$],
    [$b, f, e, d, c, a$],
    [$f, b, c, d, a, e$],
  ),
  answer: [Mulighed (b) og (e): $b, d, f, c, e, a$ og $f, b, c, d, a, e$.],
  blueprint: [
    En liste er en topologisk sortering, hvis hver kant peger fremad i listen. Du tjekker hver kant i stedet for at gætte.

    + Skriv alle kanterne op som bindinger, så $u$ skal stå før $v$.
    + Gå hver foreslået liste igennem og find den første kant, der brydes.
    + En liste uden brudt kant er gyldig. Spørger opgaven om #swap[flere svar], saml dem alle.
  ],
  worked: [
    Grafen her.

    + Bindinger: $b$ før $a, c, d, e$; $c, d$ før $e$; $f$ før $c, e$.
    + (a): $f$ står efter $c$, så $f arrow c$ brydes. Ugyldig.
    + (b): hver kant peger fremad. Gyldig.
    + (c): $e$ står før sine forgængere. Ugyldig.
    + (d): $e$ står før $c$ og $d$, så $c arrow e$ og $d arrow e$ brydes. Ugyldig.
    + (e): hver kant peger fremad. Gyldig.

    Svar: (b) og (e).
  ],
)

#qcard(
  tag: [Topologisk sortering: er rækkefølgen gyldig? (topologisk sortering)],
  source: "MCQ juni 2025, Spm. 18 (flere rigtige)",
  theory: <th-graph-toposort>,
  prompt: [Orienteret graf med kanter $c arrow e$, $c arrow j$, $j arrow e$, $j arrow h$, $j arrow i$, $e arrow h$, $e arrow b$, $h arrow i$, $h arrow f$, $f arrow b$. Hvilke lister er en topologisk sortering? (Et eller flere svar.)],
  options: (
    [$c, j, e, h, i, f, b$],
    [$c, e, h, i, f, b, j$],
    [$b, c, e, f, h, i, j$],
    [$j, e, h, i, f, b, c$],
    [$c, j, e, h, f, i, b$],
    [$c, j, e, h, i, b, f$],
  ),
  answer: [Mulighed (a) og (e): $c, j, e, h, i, f, b$ og $c, j, e, h, f, i, b$.],
  blueprint: [
    Samme tjek: hver kant skal pege fremad i listen.

    + Skriv kanterne op som bindinger ($u$ før $v$).
    + Gå hver liste igennem og find den første brudte kant.
    + Saml alle lister uden brud — opgaven har #swap[flere rigtige].
  ],
  worked: [
    Grafen her.

    + (a) $c, j, e, h, i, f, b$: alle kanter opfyldt. Gyldig.
    + (b) slutter med $j$: bryder $j arrow e$, $j arrow h$, $j arrow i$. Ugyldig.
    + (c) starter med $b$: bryder $e arrow b$, $h arrow f$, $f arrow b$. Ugyldig.
    + (d) slutter med $c$: bryder $c arrow e$, $c arrow j$. Ugyldig.
    + (e) $c, j, e, h, f, i, b$: alle kanter opfyldt ($h arrow i$ holder, $f arrow b$ holder). Gyldig.
    + (f) $c, j, e, h, i, b, f$: $f$ står efter $b$, men $f arrow b$ kræver $f$ før $b$. Ugyldig.

    Svar: (a) og (e).
  ],
)

#qcard(
  tag: [DFS: kør i hånden, find opdagelses-/afslutningstid (DFS)],
  source: "MCQ juni 2015, spm. 10",
  theory: <th-graph-dfs>,
  prompt: [Udfør DFS med start i $i$ med nabolisterne sorteret alfabetisk. Hvilken knude får opdagelsestid (starttid) #swap[$12$]? Hjulgraf med center $i$ og ydre knuder $a$ til $h$. Eger: $i arrow a$, $i arrow b$, $c arrow i$, $i arrow d$, $e arrow i$, $f arrow i$, $i arrow g$, $i arrow h$. Ydre kanter: $h arrow a$, $b arrow a$, $b arrow c$, $d arrow c$, $e arrow d$, $f arrow e$, $g arrow f$, $g arrow h$.],
  options: (
    [Knuden $d$],
    [Knuden $e$],
    [Knuden $f$],
    [Knuden $g$],
    [Ingen knude har starttid 12],
  ),
  answer: [(b) knuden $e$.],
  blueprint: [
    Jagter du et bestemt tidsstempel, kører du DFS med én tæller og skriver opdagelses- og afslutningstid på, hver gang tælleren tikker.

    + Skriv nabolisterne op alfabetisk og start tælleren på 1 i #swap[startknuden].
    + Opdag en hvid knude: tæl op, skriv opdagelsestiden, og dyk ned i dens første hvide nabo.
    + Ingen hvide naboer tilbage: tæl op, skriv afslutningstiden, og gå tilbage.
    + Læs den knude af, der rammer tidsstemplet #swap[$12$].
  ],
  worked: [
    Hjulgrafen her, start i $i$, nabolister sorteret.

    + Lister: $i:[a, b, d, g, h]$, $b:[a, c]$, $c:[i]$, $d:[c]$, $e:[d, i]$, $f:[e, i]$, $g:[f, h]$, $h:[a]$.
    + $i$ opd 1; $a$ opd 2 afs 3; $b$ opd 4; $c$ opd 5 afs 6; $b$ afs 7.
    + $d$ opd 8 afs 9; $g$ opd 10; $f$ opd 11; $e$ opd 12 afs 13.
    + $f$ afs 14; $h$ opd 15 afs 16; $g$ afs 17; $i$ afs 18.

    Opdagelsestid 12 lander på $e$.

    Svar: (b) knuden $e$.
  ],
)

#qcard(
  tag: [DFS: kør i hånden, find opdagelses-/afslutningstid (DFS)],
  source: "MCQ juni 2015, Spm. 11",
  theory: <th-graph-dfs>,
  prompt: [Fortsæt med DFS på samme hjulgraf med start i $i$ og nabolister sorteret alfabetisk. Hvilken knude får afslutningstid (sluttid) #swap[$16$]? Eger: $i arrow a$, $i arrow c$, $i arrow d$, $i arrow g$, $h arrow i$, $b arrow i$, $f arrow i$, $e arrow i$. Ydre kanter: $g arrow h$, $h arrow a$, $b arrow a$, $b arrow c$, $d arrow c$, $e arrow d$, $f arrow e$, $g arrow f$.],
  options: (
    [Knuden $b$],
    [Knuden $d$],
    [Knuden $f$],
    [Knuden $h$],
    [Ingen knude har afslutningstid 16],
  ),
  answer: [Mulighed (e): ingen knude har afslutningstid 16.],
  blueprint: [
    Jagter du et bestemt tidsstempel, kører du DFS med én tæller. Rammer tidsstemplet en knude, der ikke er på menuen, vælger du "ingen knude".

    + Skriv nabolisterne op alfabetisk og start tælleren på 1 i #swap[startknuden].
    + Opdag en hvid knude: tæl op, skriv opdagelsestiden, dyk ned i første hvide nabo.
    + Ingen hvide naboer tilbage: tæl op, skriv afslutningstiden, gå tilbage. Fortsæt skoven over resterende knuder alfabetisk.
    + Match tidsstemplet #swap[$16$] til en knude; er den ikke blandt mulighederne, vælg "ingen knude".
  ],
  worked: [
    Hjulgrafen her, start i $i$, naboer $a, c, d, g$.

    + $i$ opd 1; $a$ opd 2 afs 3; $c$ opd 4 afs 5; $d$ opd 6 afs 7.
    + $g$ opd 8; $f$ opd 9; $e$ opd 10 afs 11; $f$ afs 12; $h$ opd 13 afs 14; $g$ afs 15; $i$ afs 16.
    + $b$ ligger i et separat træ: opd 17, afs 18.

    Afslutningstid 16 lander på $i$, som ikke er blandt $b, d, f, h$.

    Svar: (e) ingen knude har afslutningstid 16.
  ],
)

#qcard(
  tag: [DFS: kør i hånden, find opdagelses-/afslutningstid (DFS)],
  source: "MCQ juni 2017, Spm. 12",
  theory: <th-graph-dfs>,
  prompt: [Udfør DFS på den orienterede graf $G_1$ med start i $a$ og nabolister sorteret alfabetisk. Hvilken knude får opdagelsestid (starttid) #swap[$12$]? Kanter: $a arrow b$, $a arrow d$, $b arrow c$, $b arrow d$, $c arrow e$, $d arrow e$, $e arrow b$, $e arrow f$, $e arrow g$, $f arrow c$, $f arrow h$, $g arrow d$, $g arrow h$, $h arrow e$, $h arrow i$.],
  options: (
    [Knuden $d$],
    [Knuden $e$],
    [Knuden $f$],
    [Knuden $g$],
    [Ingen knude får starttid 12],
  ),
  answer: [Mulighed (a): knuden $d$.],
  blueprint: [
    Samme metode: kør DFS med én tæller og læs den knude af, der rammer det ønskede tidsstempel.

    + Byg nabolisterne og sortér dem alfabetisk. Start tælleren på 1 i #swap[startknuden].
    + Opdag en hvid knude: tæl op, skriv opdagelsestiden, dyk ned i første hvide nabo.
    + Ingen hvide naboer tilbage: tæl op, skriv afslutningstiden, gå tilbage.
    + Læs den knude af, der rammer tidsstemplet #swap[$12$].
  ],
  worked: [
    Grafen her, start i $a$, naboer sorteret.

    + Lister: $a:[b, d]$, $b:[c, d]$, $c:[e]$, $d:[e]$, $e:[b, f, g]$, $f:[c, h]$, $g:[d, h]$, $h:[e, i]$, $i:[]$.
    + $a = 1$, $b = 2$, $c = 3$, $e = 4$, $f = 5$, $h = 6$, $i = 7$.
    + $i$ afslutter; tilbage gennem $h, f$ til $e$; $e$'s næste hvide nabo er $g = 11$; $g$'s første hvide nabo er $d = 12$.

    Opdagelsestid 12 lander på $d$.

    Svar: (a) knuden $d$.
  ],
)

#qcard(
  tag: [DFS: kør i hånden, find opdagelses-/afslutningstid (DFS)],
  source: "MCQ juni 2021, Spm. 15",
  theory: <th-graph-dfs>,
  prompt: [Udfør DFS-Visit($G$, $a$) med start i $a$ og nabolister sorteret alfabetisk. Kanter: $a arrow d$, $a arrow g$, $b arrow.l.r c$, $c arrow f$, $d arrow.l.r e$, $d arrow g$, $e arrow a$, $f arrow b$, $f arrow g$, $g arrow b$, $g arrow.l.r h$, $g arrow i$, $h arrow d$, $h arrow f$, $i arrow a$, $i arrow b$. Hvilken liste giver #swap[rækkefølgen, knuderne får opdagelsestid]?],
  options: (
    [$a, g, b, c, f, h, d, e, i$],
    [$a, d, e, g, b, c, f, h, i$],
    [$a, d, e, g, b, h, i, c, f$],
    [$a, d, g, i, h, b, c, f, e$],
  ),
  answer: [Mulighed (b): $a, d, e, g, b, c, f, h, i$.],
  blueprint: [
    Spørgsmålet er opdagelsesrækkefølgen. Du kører DFS og føjer hver knude til listen i det øjeblik, den får sin opdagelsestid.

    + Skriv kanterne op. En dobbeltpil er to orienterede kanter.
    + Sortér hver ud-naboliste alfabetisk.
    + Kør rekursiv DFS-Visit fra #swap[$a$]: ved første besøg gives opdagelsestid (føj til listen) og knuden bliver grå; gå ned i ud-naboerne alfabetisk og spring de sete over.
  ],
  worked: [
    Grafen her, start i $a$, ud-lister sorteret.

    + Lister: $a:[d, g]$, $b:[c]$, $c:[b, f]$, $d:[e, g]$, $e:[a, d]$, $f:[b, g]$, $g:[b, h, i]$, $h:[d, f, g]$, $i:[a, b]$.
    + Opdag $a$; ned til $d$; opdag $d$; ned til $e$; $e$'s naboer $a, d$ set, tilbage; fra $d$ til $g$; opdag $g$; ned til $b$; opdag $b$; ned til $c$; opdag $c$; ned til $f$; opdag $f$; tilbage; fra $g$ næste er $h$; opdag $h$; fra $g$ næste er $i$; opdag $i$.

    Rækkefølge: $a, d, e, g, b, c, f, h, i$.

    Svar: (b).
  ],
)

#qcard(
  tag: [DFS: kør i hånden, find opdagelses-/afslutningstid (DFS)],
  source: "MCQ juni 2023, Spm. 15",
  theory: <th-graph-dfs>,
  prompt: [Udfør DFS-Visit($G$, $a$) fra $a$ med nabolister sorteret alfabetisk. Kanter: $a arrow b$, $b arrow c$, $c arrow d$, $a arrow e$, $f arrow a$, $b arrow f$, $c arrow f$, $c arrow g$, $d arrow h$, $f arrow e$, $f arrow g$, $g arrow d$, $h arrow g$. Hvilken knude opdages #swap[sidst] (har højeste opdagelsestid)?],
  options: ([$d$], [$e$], [$f$], [$g$], [$h$]),
  answer: [Mulighed (b): $e$.],
  blueprint: [
    Leder du efter den sidst opdagede knude, kører du DFS og finder den med den højeste opdagelsestid.

    + Byg nabolisterne og sortér dem alfabetisk.
    + Kør DFS-Visit fra #swap[$a$]; tæl op ved hvert første besøg, gå ned i den alfabetisk første hvide nabo, og gå tilbage når ingen er tilbage.
    + Den knude, der får den højeste opdagelsestid, er svaret.
  ],
  worked: [
    Grafen her, start i $a$.

    + Lister: $a:[b, e]$, $b:[c, f]$, $c:[d, f, g]$, $d:[h]$, $f:[a, e, g]$, $g:[d]$, $h:[g]$, $e:[]$.
    + Opdagelse: $a = 1$, $b = 2$, $c = 3$, $d = 4$, $h = 5$, $g = 6$ ($g arrow d$ set, tilbage til $c$), så $c arrow f = 7$, $f arrow e = 8$.
    + Rækkefølge $a, b, c, d, h, g, f, e$; højeste er $e$ (tid 8).

    Svar: (b) $e$.
  ],
)

#qcard(
  tag: [DFS: kør i hånden, find opdagelses-/afslutningstid (DFS)],
  source: "MCQ juni 2025, Spm. 16",
  theory: <th-graph-dfs>,
  prompt: [Udfør DFS-Visit($G$, $a$) fra $a$ med nabolister sorteret alfabetisk. Orienterede kanter: $a arrow c$, $c arrow e$, $c arrow j$, $e arrow b$, $e arrow h$, $h arrow f$, $h arrow i$, $i arrow g$, $j arrow c$, $j arrow e$, $j arrow h$, $j arrow i$. Hvilken knude opdages #swap[sidst] (har højeste opdagelsestid)?],
  options: ([$b$], [$c$], [$d$], [$e$], [$f$], [$g$], [$h$], [$i$], [$j$]),
  answer: [Mulighed (i): $j$.],
  blueprint: [
    Samme metode: kør DFS og find knuden med den højeste opdagelsestid.

    + Byg nabolisterne alfabetisk.
    + Kør DFS-Visit fra #swap[$a$]; gå ned i den alfabetisk første hvide nabo, tæl op ved hvert første besøg.
    + Knuden med den højeste opdagelsestid er svaret.
  ],
  worked: [
    Grafen her, start i $a$.

    + Lister: $a:[c]$, $c:[e, j]$, $e:[b, h]$, $h:[f, i]$, $i:[g]$.
    + $a(1) arrow c(2) arrow e(3) arrow b(4$, blindgyde$)$ tilbage $arrow h(5) arrow f(6$, blindgyde$)$ tilbage $arrow i(7) arrow g(8$, blindgyde$)$ tilbage til $c arrow j(9)$.
    + $j$ nås først via $c$'s anden kant, efter hele $e$/$h$/$i$-undertræet er færdigt, så den får opdagelsestid 9 — den højeste.

    Svar: (i) $j$.
  ],
)

#qcard(
  tag: [DFS: kør i hånden, find opdagelses-/afslutningstid (DFS)],
  source: "MCQ juni 2017, Spm. 13",
  theory: <th-graph-dfs>,
  prompt: [Udfør DFS på den orienterede graf $G_1$ med start i $a$ og nabolister sorteret alfabetisk. Hvilken knude får afslutningstid (sluttid) #swap[$10$]? Kanter: $a arrow b$, $a arrow d$, $b arrow c$, $b arrow d$, $c arrow e$, $c arrow f$, $d arrow e$, $e arrow b$, $e arrow f$, $e arrow g$, $f arrow c$, $f arrow h$, $f arrow i$, $g arrow d$, $g arrow h$, $h arrow e$, $h arrow i$.],
  options: (
    [Knuden $b$],
    [Knuden $d$],
    [Knuden $f$],
    [Knuden $h$],
    [Ingen knude får sluttid 10],
  ),
  answer: [Mulighed (c): knuden $f$.],
  blueprint: [
    Samme metode som de øvrige tidsstempel-spørgsmål: kør DFS med én tæller og læs den knude af, der rammer den ønskede afslutningstid.

    + Byg nabolisterne og sortér dem alfabetisk. Start tælleren på 1 i #swap[startknuden].
    + Opdag en hvid knude: tæl op, skriv opdagelsestiden, dyk ned i første hvide nabo.
    + Ingen hvide naboer tilbage: tæl op, skriv afslutningstiden, gå tilbage.
    + Læs den knude af, der rammer afslutningstiden #swap[$10$].
  ],
  worked: [
    Grafen her, start i $a$, naboer sorteret.

    + Opdagelse: $a = 1$, $b = 2$, $c = 3$, $e = 4$, $f = 5$, $h = 6$, $i = 7$.
    + $i$ er en blindgyde og afslutter som 8. Derfra lukkes undertræet nedefra, så $h$ afslutter 9 og $f$ afslutter 10.

    Afslutningstid 10 lander på $f$.

    Svar: (c) knuden $f$.
  ],
)

#qcard(
  tag: [Stærke sammenhængskomponenter: tæl dem (Kosaraju)],
  source: "MCQ juni 2017, Spm. 11",
  theory: <th-graph-scc>,
  prompt: [Hvor mange stærke sammenhængskomponenter har den orienterede graf $G_1$? Kanter: $a arrow d$, $a arrow b$, $b arrow d$, $b arrow c$, $e arrow b$, $d arrow e$, $g arrow d$, $e arrow g$, $g arrow h$, $h arrow e$, $e arrow f$, $f arrow h$, $h arrow i$, $f arrow i$, $c arrow e$, $c arrow f$.],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [Mulighed (c): $3$.],
  blueprint: [
    To knuder ligger i samme SCC, netop hvis hver kan nås fra den anden. Du finder kredsene og samler dem, der hænger sammen.

    + Skriv hver kant op med korrekt pileretning og byg nabolisterne.
    + Kør Kosaraju/Tarjan eller find kredse i hånden: knuder i samme kreds smelter sammen til én komponent.
    + Kilder (ingen indgående) og afløb (ingen udgående) uden kreds er hver sin singleton.
    + Tæl komponenterne.
  ],
  worked: [
    Grafen her.

    + $a$ har ingen indgående kant: singleton ${a}$.
    + $i$ har ingen udgående kant: singleton ${i}$.
    + De midterste 7 knuder hænger sammen via kredsene $d arrow e arrow g arrow d$, $e arrow g arrow h arrow e$, $e arrow f arrow h arrow e$ og $b arrow c arrow e arrow b$, så ${b, c, d, e, f, g, h}$ er én SCC.

    Komponenter: ${a}$, ${b, c, d, e, f, g, h}$, ${i}$ — i alt 3.

    Svar: (c) $3$.
  ],
)

#qcard(
  tag: [Stærke sammenhængskomponenter: tæl dem (Kosaraju)],
  source: "MCQ juni 2019, Spm. 12",
  theory: <th-graph-scc>,
  prompt: [Hvor mange stærke sammenhængskomponenter har den orienterede graf $G_1$? Kanter: $f arrow a$, $b arrow f$, $g arrow f$, $b arrow a$, $g arrow b$, $c arrow g$, $b arrow c$, $h arrow c$, $d arrow h$, $i arrow h$, $c arrow d$, $e arrow i$, $i arrow d$, $e arrow d$.],
  options: ([$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [Mulighed (d): $5$.],
  blueprint: [
    Samme metode: find kredsene, smelt dem, der deler en knude, sammen, og lad resten være singletons.

    + Skriv kanterne op og byg nabolisterne.
    + Find kredsene; deler to kredse en knude, smelter de sammen.
    + Knuder uden kreds (kilder, afløb) er singletons.
    + Tæl komponenterne.
  ],
  worked: [
    En stærk sammenhængskomponent er en gruppe af knuder, hvor du kan rejse fra en hvilken som helst knude i gruppen til en hvilken som helst anden i samme gruppe via pilene. Resultatet 5 betyder derfor 5 grupper, ikke 5 enkeltknuder. Tænk på dem som 5 isolerede øer.

    Den store ø er ${b, c, d, g, h}$. Inden for netop denne gruppe kan du komme fra et hvilket som helst punkt til et hvilket som helst andet. Følg fx ringen $b arrow c arrow d arrow h arrow c arrow g arrow b$.

    De fire andre er enkeltknuder, hver sin egen ø, fordi du aldrig kan rejse tilbage til dem igen:

    - ${a}$ har kun indgående pile ($f arrow a$ og $b arrow a$). Når du først er i $a$, kommer du ikke væk.
    - ${f}$ modtager pile fra $b$ og $g$, men har kun én udgående pil til $a$. Forlader du $f$, kan du ikke komme tilbage.
    - ${e}$ har kun udgående pile ($e arrow i$ og $e arrow d$). Ingen pil peger ind i $e$.
    - ${i}$ modtager $e arrow i$ og sender videre til $h$ og $d$, men ingen vej fører tilbage til $i$.

    Det er antallet af uafhængige grupper, der giver svaret, ikke at der er 5 punkter der kan nå alt. I alt 1 stor plus 4 små = 5 komponenter.

    Svar: (d) $5$.
  ],
)

#qcard(
  tag: [Stærke sammenhængskomponenter: tæl dem (Kosaraju)],
  source: "MCQ juni 2021, Spm. 18",
  theory: <th-graph-scc>,
  prompt: [Hvor mange stærke sammenhængskomponenter har den orienterede graf? Kanter: $d arrow e$, $h arrow d$, $a arrow e$, $a arrow d$, $g arrow d$, $h arrow.l.r g$, $a arrow g$, $f arrow g$, $h arrow f$, $i arrow a$, $g arrow i$, $g arrow b$, $f arrow b$, $f arrow c$, $i arrow b$, $b arrow.l.r c$.],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$], [$7$], [$8$], [$9$]),
  answer: [Mulighed (d): $4$.],
  blueprint: [
    Læs hver kant og markér enkelt- mod dobbeltpile (dobbelt = gensidigt par). En SCC er en maksimal mængde af gensidigt nåelige knuder.

    + Skriv kanterne op; en dobbeltpil binder de to knuder sammen med det samme.
    + Kør Kosaraju/Tarjan i stedet for at gætte; find kredsene og smelt dem sammen.
    + Knuder uden kreds er singletons.
    + Tæl komponenterne.
  ],
  worked: [
    Grafen her.

    + $g arrow.l.r h$ binder $g, h$. Kredsen $g arrow i arrow a arrow g$ trækker $i, a$ ind; $h arrow f arrow g arrow h$ trækker $f$ ind. Så ${a, f, g, h, i}$ er én SCC.
    + $b arrow.l.r c$ er en anden SCC ${b, c}$.
    + $d$ har indgående kanter, men kun $d arrow e$ udgående: singleton. $e$ er rent afløb: singleton.

    Komponenter: ${a, f, g, h, i}$, ${b, c}$, ${d}$, ${e}$ — i alt 4.

    Svar: (d) $4$.
  ],
)

#qcard(
  tag: [Stærke sammenhængskomponenter: tæl dem (Kosaraju)],
  source: "MCQ juni 2023, Spm. 18",
  theory: <th-graph-scc>,
  prompt: [Hvor mange stærke sammenhængskomponenter har den orienterede graf? Kanter: $B arrow A$, $A arrow E$, $E arrow B$, $B arrow C$, $C arrow D$, $C arrow F$, $D arrow F$, $G arrow E$, $E arrow H$, $H arrow G$, $H arrow I$, $H arrow C$, $F arrow I$, $I arrow J$, $J arrow F$.],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$]),
  answer: [Mulighed (d): $4$.],
  blueprint: [
    Samme metode: byg nabolisterne, kør Kosaraju eller Tarjan, og tæl komponenterne. Knuder uden returvej er singletons.

    + Skriv kanterne op og byg nabolisterne.
    + Find kredsene; deler to kredse en knude, smelter de sammen.
    + Tæl komponenterne.
  ],
  worked: [
    Grafen her.

    + Kreds $A, B, E$ ($B arrow A$, $A arrow E$, $E arrow B$). Kreds $G, H, E$ ($G arrow E$, $E arrow H$, $H arrow G$) deler $E$ og smelter ind: ${A, B, E, G, H}$.
    + Kreds $F, I, J$ ($F arrow I$, $I arrow J$, $J arrow F$): ${F, I, J}$.
    + $C$ har $H arrow C$ ind, men ingen returvej: singleton. $D$ er singleton.

    Komponenter: ${A, B, E, G, H}$, ${C}$, ${D}$, ${F, I, J}$ — i alt 4.

    Svar: (d) $4$.
  ],
)

#qcard(
  tag: [Stærke sammenhængskomponenter: par i samme komponent (Kosaraju)],
  source: "MCQ juni 2017, Spm. 10 (flere rigtige)",
  theory: <th-graph-scc>,
  prompt: [I den orienterede graf $G_1$, for hvilke par af knuder ligger #swap[begge knuder i samme stærke sammenhængskomponent]? (Et eller flere svar.) Kanter: $g arrow h$, $h arrow i$, $g arrow d$, $e arrow g$, $h arrow e$, $f arrow h$, $f arrow i$, $d arrow e$, $e arrow f$, $a arrow d$, $a arrow b$, $b arrow d$, $e arrow b$, $c arrow e$, $f arrow c$, $b arrow c$.],
  options: (
    [$a$ og $f$],
    [$b$ og $h$],
    [$c$ og $d$],
    [$b$ og $i$],
    [$a$ og $i$],
  ),
  answer: [Mulighed (b) og (c): $b$ og $h$, samt $c$ og $d$ — begge par ligger i den store SCC ${b, c, d, e, f, g, h}$; $a$ og $i$ er hver sin singleton.],
  blueprint: [
    Først finder du komponenterne, så slår du hvert par op og tjekker, om begge knuder ligger i samme.

    + Skriv kanterne op og kør en SCC-algoritme over dem.
    + For hvert kandidatpar: ligger begge knuder i samme SCC?
    + Saml alle par, der gør — opgaven har #swap[flere rigtige].
  ],
  worked: [
    Grafen her.

    + Tre SCC'er: ${a}$, ${i}$ og ${b, c, d, e, f, g, h}$. Den store kreds binder fx $d arrow e arrow b arrow d$, $e arrow g arrow d arrow e$, $e arrow f arrow h arrow e$, $f arrow c arrow e arrow f$.
    + $a$ har kun udgående kanter ($a arrow d$, $a arrow b$) uden returvej: singleton. $i$ har kun indgående: singleton.
    + Par: $a, f$ forskellige; $b, h$ samme; $c, d$ samme; $b, i$ forskellige; $a, i$ forskellige.

    Svar: (b) og (c).
  ],
)

#qcard(
  tag: [Stærke sammenhængskomponenter: par i samme komponent (Kosaraju)],
  source: "MCQ juni 2019, Spm. 13",
  theory: <th-graph-scc>,
  prompt: [I den orienterede graf $G_1$, for hvilken #swap[tilføjet kant] falder antallet af stærke sammenhængskomponenter til #swap[én]? Kanter: $g arrow f$, $f arrow a$, $b arrow f$, $g arrow b$, $c arrow g$, $b arrow a$, $b arrow c$, $c arrow d$, $i arrow h$, $h arrow c$, $d arrow h$, $i arrow d$, $e arrow i$, $e arrow d$. En kant fra $u$ til $v$ skrives $(u, v)$.],
  options: (
    [$(h, g)$],
    [$(g, h)$],
    [$(f, i)$],
    [$(i, f)$],
    [$(a, e)$],
    [$(e, a)$],
  ),
  answer: [Mulighed (e): $(a, e)$.],
  blueprint: [
    Du finder først komponenterne i grundgrafen og afgør så, hvilken kant der lukker den globale kreds.

    + Beregn SCC'erne i grundgrafen og find det universelle afløb (når intet) og den universelle kilde (nås af intet).
    + En kant fra afløbet tilbage til kilden binder hele grafen sammen til én SCC.
    + Test kandidaterne og vælg den, der giver netop 1 komponent.
  ],
  worked: [
    Grafen her.

    + Grundgrafen har SCC ${b, c, d, g, h}$ plus singletons $a, e, f, i$.
    + $a$ nås fra kernen ($f arrow a$, $b arrow a$) men når intet; $e$ når alt ($e arrow i arrow h arrow c arrow dots.h$, $e arrow d$) men nås af intet.
    + Kun $(a, e)$ føjer returkanten fra det universelle afløb $a$ til den universelle kilde $e$, så alle 9 knuder bliver gensidigt nåelige (1 SCC). De øvrige kandidater giver stadig flere komponenter.

    Svar: (e) $(a, e)$.
  ],
)
