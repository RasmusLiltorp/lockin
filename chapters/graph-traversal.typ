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

#note(title: [Cross-kant: tænk fætter])[
  Cross-kant er den, der driller flest. Forfader og efterkommer ligger på din egen linje gennem træet, lige op eller lige ned. En cross-kant rammer derimod en knude, der hverken er over eller under dig, altså en fætter ude i en sidegren, som var pakket helt sammen, før du overhovedet nåede frem. Pilen findes i grafen, men DFS brugte den aldrig til at opdage noget, fordi målet allerede var sort.

  Tag det mindste eksempel: $1 arrow 2$, $1 arrow 3$, $2 arrow 4$, $3 arrow 4$. DFS fra $1$ går $1 arrow 2 arrow 4$, lukker $4$, bakker op og tager $1 arrow 3$. Så kigger den på $3 arrow 4$, men $4$ er for længst færdig nede i $2$'s gren. $3$ og $4$ er fætre, og $3 arrow 4$ hopper på tværs. Det er en cross-kant. Bemærk, at der kun skal være én pil. $4$ behøver ikke pege tilbage på $3$.
]

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
    Sortér ud-nabolisterne alfabetisk: $a:[d, e]$, $b:[c]$, $c:[f]$, $d:[g, i]$, $e:[b, j]$, $f:[g]$, $g:[j]$, $h:[c]$, $i:[j]$, $j:[]$. Start: $a.d = 0$, læg $a$ i køen. Reglen: tag forreste $u$ ud, og for hver hvid nabo $v$ sæt $v.d = u.d + 1$ og læg bagest. Køen $Q$ vises efter hvert udtag, opdagede $d$-værdier til højre.

    ```
    Q=[a]                a.d=0  (start)

    pop a: naboer d,e begge hvide
    Q=[d,e]              d.d=1, e.d=1
    pop d: naboer g,i begge hvide
    Q=[e,g,i]            g.d=2, i.d=2
    pop e: naboer b,j begge hvide
    Q=[g,i,b,j]          b.d=2, j.d=2
    pop g: nabo j allerede set -> intet
    Q=[i,b,j]
    pop i: nabo j allerede set -> intet
    Q=[b,j]
    pop b: nabo c hvid
    Q=[j,c]              c.d=3
    pop j: ingen naboer
    Q=[c]
    pop c: nabo f hvid
    Q=[f]                f.d=4
    pop f: nabo g allerede set
    Q=[]                 (færdig)
    ```

    $d$-værdierne tildelt i orden: $a(0)$, $d(1)$, $e(1)$, $g(2)$, $i(2)$, $b(2)$, $j(2)$, $c(3)$, $f(4)$. Den eneste knude med $d = 4$ er $f$, så den er også den første.

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
    Sortér ud-nabolisterne: $a:[b, f]$, $b:[f, g]$, $c:[b, d, g, h]$, $d:[h, i]$, $e:[d, i]$, $f:[g]$, $g:[]$, $h:[i]$. Start: $c.d = 0$, læg $c$ i køen. Køen vises efter hvert udtag.

    ```
    Q=[c]                c.d=0  (start)

    pop c: naboer b,d,g,h alle hvide
    Q=[b,d,g,h]          b.d=1, d.d=1, g.d=1, h.d=1
    pop b: nabo f hvid; g allerede set
    Q=[d,g,h,f]          f.d=2
    pop d: h allerede set; nabo i hvid
    Q=[g,h,f,i]          i.d=2
    pop g: ingen naboer
    Q=[h,f,i]
    pop h: nabo i allerede set
    Q=[f,i]
    pop f: nabo g allerede set
    Q=[i]
    pop i: ingen naboer
    Q=[]                 (færdig)
    ```

    Tildelingsorden: $c(0)$, $b(1)$, $d(1)$, $g(1)$, $h(1)$, $f(2)$, $i(2)$. Inden for niveau $2$ kommer $f$ ud før $i$, fordi $b$ (som opdager $f$) stod før $d$ (som opdager $i$) i køen. Første med $d = 2$ er $f$.

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
    Uorienteret: hver kant tæller begge veje. Nabolister sorteret: $a:[f]$, $b:[c, f, g]$, $c:[b, d, g]$, $d:[c, e, h, i]$, $e:[d, i]$, $f:[a, b, g]$, $g:[b, c, f]$, $h:[d, i]$, $i:[d, e, h]$. Start: $c.d = 0$, køen $= [c]$.

    ```
    Q=[c]                c.d=0  (start)

    pop c: naboer b,d,g hvide
    Q=[b,d,g]            b.d=1, d.d=1, g.d=1
    pop b: c,g set; nabo f hvid
    Q=[d,g,f]            f.d=2
    pop d: c set; naboer e,h,i hvide
    Q=[g,f,e,h,i]        e.d=2, h.d=2, i.d=2
    pop g: b,c,f alle set
    Q=[f,e,h,i]
    pop f: b,g set; nabo a hvid
    Q=[e,h,i,a]          a.d=3
    pop e: d,i set
    pop h: d,i set
    pop i: d,e,h set
    pop a: f set
    Q=[]                 (færdig)
    ```

    Knuder med $d = 3$ i tildelingsorden: kun $a$. Den er dermed både den eneste og den sidste i afstand $3$.

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
    Kun udgående pile bruges. Ud-nabolister: $a:[b, f]$, $b:[f, g]$, $c:[b, g, h]$, $d:[h, i]$, $e:[d, i]$, $f:[g]$, $h:[i]$. Alle $d$-værdier starter på $infinity$, undtagen $c.d = 0$.

    ```
    Q=[c]                c.d=0  (start)

    pop c: naboer b,g,h hvide
    Q=[b,g,h]            b.d=1, g.d=1, h.d=1
    pop b: f hvid; g set
    Q=[g,h,f]            f.d=2
    pop g: ingen naboer
    Q=[h,f]
    pop h: nabo i hvid
    Q=[f,i]              i.d=2
    pop f: g set
    Q=[i]
    pop i: ingen naboer
    Q=[]                 (færdig)
    ```

    Nået: ${c, b, g, h, f, i}$. Tilbage med $d = infinity$: $a$, $d$, $e$. Ingen kant fra den nåede mængde peger ind i dem ($a$, $d$, $e$ har kun udgående eller indbyrdes kanter), så de forbliver unåelige. Antal $= 3$.

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
    En dobbeltpil tæller som to orienterede kanter. Ud-nabolister sorteret: $a:[g]$, $b:[c, h]$, $c:[a, h]$, $d:[h, i, j]$, $e:[b, d, f, h]$, $f:[b, e]$, $g:[c, j]$, $h:[d, e, g, j]$, $i:[d, j]$, $j:[]$. Listen bygges, hver gang en knude lægges bagest i køen.

    ```
    Q=[a]                lagt: a

    pop a: g hvid
    Q=[g]                lagt: g
    pop g: c,j hvide
    Q=[c,j]              lagt: c, j
    pop c: a set; h hvid
    Q=[j,h]              lagt: h
    pop j: ingen naboer
    Q=[h]
    pop h: d,e hvide; g,j set
    Q=[d,e]              lagt: d, e
    pop d: h set; i hvid; j set
    Q=[e,i]              lagt: i
    pop e: b hvid; d,h set; f hvid
    Q=[i,b,f]            lagt: b, f
    pop i: d,j set
    pop b: c,h set
    pop f: b,e set
    Q=[]                 (færdig)
    ```

    Indsættelsesrækkefølge: $a, g, c, j, h, d, e, i, b, f$.

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
    Uorienteret, hver kant begge veje, lister sorteret: $a:[b, c]$, $b:[a, e, f]$, $c:[a, e, j]$, $e:[b, c, h]$, $f:[b, g, h]$, $g:[f, i]$, $h:[e, f, i]$, $i:[g, h, j]$, $j:[c, i]$. Start: $a.d = 0$.

    ```
    Q=[a]                a.d=0  (start)

    pop a: b,c hvide
    Q=[b,c]              b.d=1, c.d=1
    pop b: a set; e,f hvide
    Q=[c,e,f]            e.d=2, f.d=2
    pop c: a,e set; j hvid
    Q=[e,f,j]            j.d=2
    pop e: b,c set; h hvid
    Q=[f,j,h]            h.d=3
    pop f: b,h set; g hvid
    Q=[j,h,g]            g.d=3
    pop j: c set; i hvid
    Q=[h,g,i]            i.d=3
    pop h: e,f,i set
    pop g: f,i set
    pop i: g,h,j set
    Q=[]                 (færdig)
    ```

    Knuder med $d = 3$ i tildelingsorden: $h$, $g$, $i$. Den sidste er $i$.

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
    Ud-nabolister sorteret: $a:[b, e]$, $b:[c, f]$, $c:[d, f, g]$, $d:[h]$, $f:[a, g]$, $g:[]$, $h:[g]$. Kør DFS med tæller `time`; `(d` = opdag, `f)` = afslut.

    ```
    time=1   d a      stak [a]
    time=2   d b      stak [a,b]      (a->b tree)
    time=3   d c      stak [a,b,c]    (b->c tree)
    time=4   d d      stak [..,c,d]   (c->d tree)
    time=5   d h      stak [..,d,h]   (d->h tree)
    time=6   d g      stak [..,h,g]   (h->g tree)
    time=7   f g      g ingen naboer
    time=8   f h
    time=9   f d
             tilbage i c: c->f
    time=10  d f      stak [a,b,c,f]  (c->f tree)
             f->a: a grå          -> BACK
             f->g: g sort, 10>6   -> CROSS
    time=11  f f
             c->g: g sort, 3<6    -> FORWARD
    time=12  f c
             b->f: f sort, 2<10   -> FORWARD
    time=13  f b
             a->e
    time=14  d e      stak [a,e]      (a->e tree)
    time=15  f e
    time=16  f a
    ```

    Intervaller: $a[1,16]$, $b[2,13]$, $c[3,12]$, $d[4,9]$, $h[5,8]$, $g[6,7]$, $f[10,11]$, $e[14,15]$. Forward-kanter (sort mål, $u.d < v.d$): $c arrow g$ og $b arrow f$. I alt $2$.

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
    Ud-nabolister sorteret: $a:[i]$, $b:[a, c]$, $c:[i]$, $d:[c]$, $e:[d, i]$, $f:[e, i]$, $g:[f, h]$, $h:[a]$, $i:[b, d, g, h]$. DFS fra $i$:

    ```
    time=1   d i      (start)
    time=2   d b      i->b tree
    time=3   d a      b->a tree
             a->i: i grå           -> BACK
    time=4   f a
             b->c
    time=5   d c      b->c tree
             c->i: i grå           -> BACK
    time=6   f c
    time=7   f b
             i->d
    time=8   d d      i->d tree
             d->c: c sort, 8>5     -> CROSS
    time=9   f d
             i->g
    time=10  d g      i->g tree
    time=11  d f      g->f tree
    time=12  d e      f->e tree
             e->d: d sort, 12>8    -> CROSS
             e->i: i grå           -> BACK
    time=13  f e
             f->i: i grå           -> BACK
    time=14  f f
             g->h
    time=15  d h      g->h tree
             h->a: a sort, 15>3    -> CROSS
    time=16  f h
    time=17  f g
             i->h: h sort, 1<15    -> FORWARD
    time=18  f i
    ```

    Intervaller: $i[1,18]$, $b[2,7]$, $a[3,4]$, $c[5,6]$, $d[8,9]$, $g[10,17]$, $f[11,14]$, $e[12,13]$, $h[15,16]$. Slå mulighed (b) op: $(b,i)$ er kanten $i arrow b$ = tree; $(a,i)$ er $a arrow i$ = back; $(h,i)$ er $i arrow h$ = forward; $(c,d)$ er $d arrow c$ = cross. Præcis én af hver. De øvrige: (a) er fire tree; (c) er tree, back, cross, tree; (d) er back, forward, cross, back.

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
    Ud-nabolister sorteret: $a:[b, d]$, $b:[c, d]$, $c:[e, f]$, $d:[e]$, $e:[b, f, g]$, $f:[c, h, i]$, $g:[d, h]$, $h:[e, i]$, $i:[]$. DFS fra $a$:

    ```
    time=1   d a      (start)
    time=2   d b      a->b tree
    time=3   d c      b->c tree
    time=4   d e      c->e tree
             e->b: b grå           -> BACK
    time=5   d f      e->f tree
             f->c: c grå           -> BACK
    time=6   d h      f->h tree
             h->e: e grå           -> BACK
    time=7   d i      h->i tree
    time=8   f i
    time=9   f h
             f->i: i sort, 5<7     -> FORWARD
    time=10  f f
             e->g
    time=11  d g      e->g tree
    time=12  d d      g->d tree
             d->e: e grå           -> BACK
    time=13  f d
             g->h: h sort, 11>6    -> CROSS
    time=14  f g
    time=15  f e
    time=16  f c
             b->d: d sort, 2<12    -> FORWARD
    time=17  f b
             a->d: d sort, 1<12    -> FORWARD
    time=18  f a
    ```

    Intervaller: $a[1,18]$, $b[2,17]$, $c[3,16]$, $e[4,15]$, $f[5,10]$, $h[6,9]$, $i[7,8]$, $g[11,14]$, $d[12,13]$. Mulighed (c): $(b,d)$ = $b arrow d$ forward; $(d,e)$ = $d arrow e$ back; $(g,d)$ = $g arrow d$ tree; $(g,h)$ = $g arrow h$ cross. Én af hver type.

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
    Hver dobbeltpil er to kanter. Ud-nabolister sorteret: $a:[d, g]$, $b:[c]$, $c:[b]$, $d:[e, g]$, $e:[a, d]$, $f:[b, g]$, $g:[b, h]$, $h:[d, f, g]$, $i:[a, b, g]$. DFS-Visit fra $a$, derefter ydre loop i resterende hvide alfabetisk.

    ```
    time=1   d a      (start)
    time=2   d d      a->d tree
    time=3   d e      d->e tree
             e->a: a grå           -> BACK
             e->d: d grå           -> BACK
    time=4   f e
             d->g
    time=5   d g      d->g tree
    time=6   d b      g->b tree
    time=7   d c      b->c tree
             c->b: b grå           -> BACK
    time=8   f c
    time=9   f b
             g->h
    time=10  d h      g->h tree
             h->d: d grå           -> BACK
    time=11  d f      h->f tree
             f->b: b sort, 11>6    -> CROSS
             f->g: g grå           -> BACK
    time=12  f f
             h->g: g grå           -> BACK
    time=13  f h
    time=14  f g
    time=15  f d
             a->g: g sort, 1<5     -> FORWARD
    time=16  f a
             ydre loop: i er hvid
    time=17  d i      (ny rod)
             i->a: a sort, 17>1    -> CROSS
             i->b: b sort, 17>6    -> CROSS
             i->g: g sort, 17>5    -> CROSS
    time=18  f i
    ```

    $i$ har ingen indgående kant, så den nås aldrig fra $a$ og starter sit eget træ. Tider: $a[1,16]$, $d[2,15]$, $e[3,4]$, $g[5,14]$, $b[6,9]$, $c[7,8]$, $h[10,13]$, $f[11,12]$, $i[17,18]$. Cross-kanter (sort mål, $u.d > v.d$): $f arrow b$, $i arrow a$, $i arrow b$, $i arrow g$. I alt $4$.

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
    Ud-nabolister sorteret: $a:[c]$, $b:[a]$, $c:[e, j]$, $e:[b, h]$, $f:[b]$, $g:[f]$, $h:[f, i]$, $i:[g]$, $j:[e, h, i]$. DFS-Visit fra $a$:

    ```
    time=1   d a      (start)
    time=2   d c      a->c tree
    time=3   d e      c->e tree
    time=4   d b      e->b tree
             b->a: a grå           -> BACK
    time=5   f b
             e->h
    time=6   d h      e->h tree
    time=7   d f      h->f tree
             f->b: b sort, 7>4     -> CROSS
    time=8   f f
             h->i
    time=9   d i      h->i tree
    time=10  d g      i->g tree
             g->f: f sort, 10>7    -> CROSS
    time=11  f g
    time=12  f i
    time=13  f h
    time=14  f e
             c->j
    time=15  d j      c->j tree
             j->e: e sort, 15>3    -> CROSS
             j->h: h sort, 15>6    -> CROSS
             j->i: i sort, 15>9    -> CROSS
    time=16  f j
    time=17  f c
    time=18  f a
    ```

    Tider: $a[1,18]$, $c[2,17]$, $e[3,14]$, $b[4,5]$, $h[6,13]$, $f[7,8]$, $i[9,12]$, $g[10,11]$, $j[15,16]$. Optælling: 8 tree, 1 back ($b arrow a$), 0 forward, 5 cross ($f arrow b$, $g arrow f$, $j arrow e$, $j arrow h$, $j arrow i$).

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
    Bindinger (hver kant $u arrow v$ kræver $u$ før $v$): $a$ før $b, d$; $b$ før $c, d, e$; $c$ før $f$; $e$ før $f$; $g$ før $c, f$. Gå hver liste igennem og find første brudte kant.

    ```
    (a) a,b,c,d,e,f,g   g står sidst (pos7), men g før c (pos3) -> BRUDT (g->c). Ugyldig
    (b) a,b,e,d,c,g,f   g pos6 efter c pos5 -> BRUDT (g->c). Ugyldig
    (c) a,b,e,d,g,c,f   a<b,a<d,b<c,b<d,b<e,c<f,e<f,g<c,g<f alle OK. Gyldig
    (d) a,b,g,c,e,d,f   a<b,a<d,b<c,b<d,b<e,c<f,e<f,g<c,g<f alle OK. Gyldig
    (e) g,a,b,e,c,f,d   g<c,g<f,a<b,a<d,b<c,b<d,b<e,c<f,e<f alle OK. Gyldig
    ```

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
    Bindinger: $b$ før $a, c, d, e$; $c$ før $e$; $d$ før $e$; $f$ før $c, e$. Tjek hver liste.

    ```
    (a) a,b,c,d,e,f   f sidst (pos6), men f før c (pos3) -> BRUDT (f->c). Ugyldig
    (b) b,d,f,c,e,a   b<c,b<a,b<d,b<e,c<e,d<e,f<c,f<e alle OK. Gyldig
    (c) f,e,d,c,b,a   b pos5 efter c pos4 -> BRUDT (b->c). Ugyldig
    (d) b,f,e,d,c,a   c pos5 efter e pos3 -> BRUDT (c->e). Ugyldig
    (e) f,b,c,d,a,e   f<c,f<e,b<c,b<a,b<d,b<e,c<e,d<e alle OK. Gyldig
    ```

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
    Bindinger: $c$ før $e, j$; $j$ før $e, h, i$; $e$ før $b, h$; $h$ før $f, i$; $f$ før $b$. Tjek hver liste.

    ```
    (a) c,j,e,h,i,f,b   c<e,c<j,j<e,j<h,j<i,e<h,e<b,h<i,h<f,f<b alle OK. Gyldig
    (b) c,e,h,i,f,b,j   j sidst (pos7), men j før e (pos2) -> BRUDT (j->e). Ugyldig
    (c) b,c,e,f,h,i,j   b først (pos1), men e før b -> BRUDT (e->b). Ugyldig
    (d) j,e,h,i,f,b,c   c sidst (pos7), men c før e (pos2) -> BRUDT (c->e). Ugyldig
    (e) c,j,e,h,f,i,b   c<e,c<j,j<e,j<h,j<i,e<h,e<b,h<i,h<f,f<b alle OK. Gyldig
    (f) c,j,e,h,i,b,f   f pos7 efter b pos6 -> BRUDT (f->b). Ugyldig
    ```

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
    Ud-nabolister sorteret: $i:[a, b, d, g, h]$, $a:[]$, $b:[a, c]$, $c:[i]$, $d:[c]$, $e:[d, i]$, $f:[e, i]$, $g:[f, h]$, $h:[a]$. DFS fra $i$; `(d` opdag, `f)` afslut.

    ```
    time=1   d i      (start)
    time=2   d a      i->a tree;  a ingen naboer
    time=3   f a
             i->b
    time=4   d b      i->b tree
             b->a: a sort
    time=5   d c      b->c tree
             c->i: i grå (back)
    time=6   f c
    time=7   f b
             i->d
    time=8   d d      i->d tree
             d->c: c sort
    time=9   f d
             i->g
    time=10  d g      i->g tree
    time=11  d f      g->f tree
    time=12  d e      f->e tree   <-- opdagelsestid 12
             e->d: d sort;  e->i: i grå (back)
    time=13  f e
             f->i: i grå (back)
    time=14  f f
             g->h
    time=15  d h      g->h tree
             h->a: a sort
    time=16  f h
    time=17  f g
             i->h: h sort
    time=18  f i
    ```

    Opdagelsestid $12$ lander på $e$.

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
    Ud-nabolister sorteret: $i:[a, c, d, g]$, $a:[]$, $b:[a, c, i]$, $c:[]$, $d:[c]$, $e:[d, i]$, $f:[e, i]$, $g:[f, h]$, $h:[a, i]$. DFS fra $i$, ydre loop bagefter.

    ```
    time=1   d i      (start)
    time=2   d a      i->a tree;  a ingen naboer
    time=3   f a
    time=4   d c      i->c tree;  c ingen naboer
    time=5   f c
    time=6   d d      i->d tree;  d->c sort
    time=7   f d
             i->g
    time=8   d g      i->g tree
    time=9   d f      g->f tree
    time=10  d e      f->e tree;  e->d sort; e->i grå (back)
    time=11  f e
             f->i: i grå (back)
    time=12  f f
             g->h
    time=13  d h      g->h tree;  h->a sort; h->i grå (back)
    time=14  f h
    time=15  f g
    time=16  f i      <-- afslutningstid 16
             ydre loop: b er hvid
    time=17  d b      (ny rod); b->a sort, b->c sort, b->i sort
    time=18  f b
    ```

    Afslutningstid $16$ lander på $i$ selv, som ikke er blandt mulighederne $b, d, f, h$.

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
    Ud-nabolister sorteret: $a:[b, d]$, $b:[c, d]$, $c:[e]$, $d:[e]$, $e:[b, f, g]$, $f:[c, h]$, $g:[d, h]$, $h:[e, i]$, $i:[]$. DFS fra $a$:

    ```
    time=1   d a      (start)
    time=2   d b      a->b tree
    time=3   d c      b->c tree
    time=4   d e      c->e tree
             e->b: b grå (back)
    time=5   d f      e->f tree
             f->c: c grå (back)
    time=6   d h      f->h tree
             h->e: e grå (back)
    time=7   d i      h->i tree
    time=8   f i
    time=9   f h
    time=10  f f
             e->g
    time=11  d g      e->g tree
    time=12  d d      g->d tree   <-- opdagelsestid 12
             d->e: e grå (back)
    time=13  f d
             g->h: h sort
    time=14  f g
    time=15  f e
    time=16  f c
             b->d: d sort
    time=17  f b
             a->d: d sort
    time=18  f a
    ```

    Opdagelsestid $12$ lander på $d$.

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
    En dobbeltpil er to kanter. Ud-nabolister sorteret: $a:[d, g]$, $b:[c]$, $c:[b, f]$, $d:[e, g]$, $e:[a, d]$, $f:[b, g]$, $g:[b, h, i]$, $h:[d, f, g]$, $i:[a, b]$. DFS-Visit fra $a$; knuden føjes til listen ved opdagelse.

    ```
    time=1   d a      liste: a       stak [a]
    time=2   d d      liste: d       a->d, stak [a,d]
    time=3   d e      liste: e       d->e, stak [a,d,e]
             e->a set; e->d set -> tilbage
    time=4   f e
             d->g
    time=5   d g      liste: g       d->g, stak [a,d,g]
    time=6   d b      liste: b       g->b, stak [a,d,g,b]
    time=7   d c      liste: c       b->c, stak [..,b,c]
             c->b set
    time=8   d f      liste: f       c->f, stak [..,c,f]
             f->b set; f->g set -> tilbage
    time=9   f f
    time=10  f c
    time=11  f b
             g->h
    time=12  d h      liste: h       g->h
             h->d,f,g alle set -> tilbage
    time=13  f h
             g->i
    time=14  d i      liste: i       g->i
    ...
    ```

    Opdagelsesrækkefølge: $a, d, e, g, b, c, f, h, i$.

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
    Ud-nabolister sorteret: $a:[b, e]$, $b:[c, f]$, $c:[d, f, g]$, $d:[h]$, $e:[]$, $f:[a, e, g]$, $g:[d]$, $h:[g]$. DFS-Visit fra $a$:

    ```
    time=1   d a      (start)
    time=2   d b      a->b tree
    time=3   d c      b->c tree
    time=4   d d      c->d tree
    time=5   d h      d->h tree
    time=6   d g      h->g tree
             g->d: d grå (back)
    time=7   f g
    time=8   f h
    time=9   f d
             c->f
    time=10  d f      c->f tree
             f->a: a grå (back)
    time=11  d e      f->e tree   <-- højeste opdagelsestid
    time=12  f e
             f->g: g sort
    time=13  f f
             c->g: g sort
    time=14  f c
             b->f: f sort
    time=15  f b
             a->e: e sort
    time=16  f a
    ```

    Opdagelsesrækkefølge: $a(1)$, $b(2)$, $c(3)$, $d(4)$, $h(5)$, $g(6)$, $f(10)$, $e(11)$. Den sidst opdagede er $e$ med opdagelsestid $11$. ($e$ nås først via $f$, efter hele $d$/$h$/$g$-undertræet er lukket.)

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
    Ud-nabolister sorteret: $a:[c]$, $b:[]$, $c:[e, j]$, $e:[b, h]$, $f:[]$, $g:[]$, $h:[f, i]$, $i:[g]$, $j:[c, e, h, i]$. DFS-Visit fra $a$:

    ```
    time=1   d a      (start)
    time=2   d c      a->c tree
    time=3   d e      c->e tree
    time=4   d b      e->b tree;  b blindgyde
    time=5   f b
             e->h
    time=6   d h      e->h tree
    time=7   d f      h->f tree;  f blindgyde
    time=8   f f
             h->i
    time=9   d i      h->i tree
    time=10  d g      i->g tree;  g blindgyde
    time=11  f g
    time=12  f i
    time=13  f h
    time=14  f e
             c->j
    time=15  d j      c->j tree   <-- højeste opdagelsestid
             j->c,e,h,i alle sorte
    time=16  f j
    ```

    $j$ nås først via $c$'s anden kant, efter hele $e$/$h$/$i$-undertræet er lukket, så den får opdagelsestid $15$ — den højeste.

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
    Samme graf $G_1$ som før. Ud-nabolister sorteret: $a:[b, d]$, $b:[c, d]$, $c:[e]$, $d:[e]$, $e:[b, f, g]$, $f:[c, h]$, $g:[d, h]$, $h:[e, i]$, $i:[]$. DFS fra $a$:

    ```
    time=1   d a      (start)
    time=2   d b      a->b tree
    time=3   d c      b->c tree
    time=4   d e      c->e tree;  e->b grå (back)
    time=5   d f      e->f tree;  f->c grå (back)
    time=6   d h      f->h tree;  h->e grå (back)
    time=7   d i      h->i tree;  i blindgyde
    time=8   f i
    time=9   f h
    time=10  f f      <-- afslutningstid 10
    ...
    ```

    $i$ er en blindgyde og afslutter som $8$. Undertræet lukkes nedefra: $h$ afslutter $9$, derefter $f$ afslutter $10$ (dens eneste hvide nabo $h$ er nu sort).

    Afslutningstid $10$ lander på $f$.

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
    To knuder er i samme SCC, netop hvis der findes en vej begge veje mellem dem. Find kredsene og smelt dem, der deler en knude.

    ```
    Kilde/afløb:
      a: kun udgående (a->d, a->b), intet peger ind  -> singleton {a}
      i: kun indgående (h->i, f->i), intet udgående   -> singleton {i}

    Kredse blandt de øvrige:
      d -> e -> g -> d      binder {d, e, g}
      e -> g -> h -> e      trækker h ind   -> {d, e, g, h}
      e -> f -> h -> e      trækker f ind   -> {d, e, f, g, h}
      b -> c -> e -> b      trækker b, c ind-> {b, c, d, e, f, g, h}
    ```

    Alle kredse deler mindst én knude og smelter til én SCC ${b, c, d, e, f, g, h}$. Komponenter i alt: ${a}$, ${b, c, d, e, f, g, h}$, ${i}$ — $3$.

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

    ```
    Kredse, der smelter sammen:
      c -> d -> h -> c     binder {c, d, h}
      b -> c -> g -> b     trækker b, g ind  -> {b, c, d, g, h}

    Resten (ingen returvej -> hver sin singleton):
      a: ind f->a, b->a;  ud kun a-ingen        -> {a}
      f: ind b->f, g->f;  ud kun f->a (a lukket) -> {f}
      e: ud e->i, e->d;   intet peger ind i e     -> {e}
      i: ind e->i;        ud i->h, i->d, ingen retur -> {i}
    ```

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
    En dobbeltpil binder de to knuder sammen med det samme. Find kredsene og smelt dem.

    ```
    g <-> h              binder {g, h}
    g -> i -> a -> g     trækker i, a ind  -> {a, g, h, i}
    h -> f -> g -> h     trækker f ind     -> {a, f, g, h, i}

    b <-> c              egen SCC          -> {b, c}

    Singletons (ingen returvej):
      d: ind h->d, a->d, g->d; ud kun d->e -> {d}
      e: rent afløb, ingen udgående         -> {e}
    ```

    Komponenter: ${a, f, g, h, i}$, ${b, c}$, ${d}$, ${e}$ — i alt $4$.

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
    Find kredsene og smelt dem, der deler en knude.

    ```
    B -> A -> E -> B     binder {A, B, E}
    G -> E -> H -> G     deler E, smelter ind -> {A, B, E, G, H}

    F -> I -> J -> F     egen kreds           -> {F, I, J}

    Singletons (ingen returvej):
      C: ind B->C, H->C; ud C->D, C->F -> {C}
      D: ind C->D;       ud D->F       -> {D}
    ```

    Komponenter: ${A, B, E, G, H}$, ${C}$, ${D}$, ${F, I, J}$ — i alt $4$.

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
    Find først SCC'erne, slå derefter hvert par op.

    ```
    Kredse:
      d -> e -> b -> d     binder {b, d, e}
      e -> g -> d -> e     trækker g ind     -> {b, d, e, g}
      e -> f -> h -> e     trækker f, h ind  -> {b, d, e, f, g, h}
      f -> c -> e -> f     trækker c ind     -> {b, c, d, e, f, g, h}

    Singletons:
      a: kun udgående (a->d, a->b), ingen retur -> {a}
      i: kun indgående (g->h->i, f->i)          -> {i}

    Tre SCC'er: {a}, {i}, {b,c,d,e,f,g,h}
    ```

    Slå parrene op:

    ```
    (a) a og f   {a} vs stor SCC   -> forskellige
    (b) b og h   begge i stor SCC  -> SAMME
    (c) c og d   begge i stor SCC  -> SAMME
    (d) b og i   stor SCC vs {i}   -> forskellige
    (e) a og i   {a} vs {i}        -> forskellige
    ```

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
    Find først SCC'erne i grundgrafen.

    ```
    Kredse:
      b -> c -> g -> b     binder {b, c, g}
      c -> d -> h -> c     trækker d, h ind -> {b, c, d, g, h}

    Singletons:
      a: ind f->a, b->a;  ingen udgående  -> universelt AFLØB (når intet)
      f: ind g->f, b->f;  ud f->a          -> {f}
      i: ind e->i;        ud i->h, i->d    -> {i}
      e: ud e->i, e->d;   intet peger ind  -> universel KILDE (nås af intet)
    ```

    Grundgrafen har SCC ${b, c, d, g, h}$ plus singletons $a, e, f, i$ — i alt 5. For at presse alt ned til 1 SCC skal hver knude kunne nå hver anden. Fra alle knuder kan man allerede nå afløbet $a$, og fra kilden $e$ kan man nå alle. Mangler kun returkanten fra $a$ tilbage til $e$:

    ```
    Tilføj (a,e): a (afløb) -> e (kilde)
      vilkårlig u --...--> a --(ny)--> e --...--> vilkårlig v
      => alle 9 knuder gensidigt nåelige -> 1 SCC
    ```

    De øvrige kandidater binder ikke afløb til kilde og efterlader stadig flere komponenter.

    Svar: (e) $(a, e)$.
  ],
)
