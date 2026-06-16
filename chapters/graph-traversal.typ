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

#note(title: [Parentes-strukturen])[Intervallerne nestes som parenteser: $[u.d, u.f]$ og $[v.d, v.f]$ er enten adskilte eller det ene ligger helt inde i det andet. En knude er grå præcis i sit eget interval.]

Du står i $u$ og følger en kant til $v$. Stil ét spørgsmål: hvilken farve har $v$ lige nu? Farven siger, hvor $v$ ligger i forhold til dig. Hvid er forude, grå er bag dig på vejen ned (en forfader), sort er noget du er færdig med. Er $v$ sort, afgør starttiderne om du peger nedad eller til siden.

#recipe(
  title: "Kantklassifikation (u, v), set fra u",
  [$v$ #strong[hvid] #sym.arrow.r tree-kant. Du opdager $v$ gennem kanten, så den bliver dit barn i træet. Intervallet for $v$ ligger inde i $u$'s: $u.d < v.d < v.f < u.f$.],
  [$v$ #strong[grå] #sym.arrow.r back-kant. $v$ er en forfader, der stadig ligger på stakken, så kanten peger opad mod roden. En sløjfe til knuden selv tæller med. Bare én back-kant betyder, at grafen har en kreds.],
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

#trap(title: [Uorienteret kanttype])[En uorienteret graf har kun tree- og back-kanter. Forward- og cross-kanter kræver en orienteret graf. Nævner en MCQ "én kant af hver type", er grafen orienteret.]

#trap(title: [Back-kant og kredse])[En orienteret graf har en kreds netop hvis DFS finder en back-kant; ingen back-kanter betyder en DAG. Forveksl ikke back-kant med cross-kant.]

#recipe(
  title: "BFS i hånden",
  [Sortér nabolisterne #swap[alfabetisk]. Sæt start #swap[$a$] til $d = 0$ og læg den i køen.],
  [Tag $u$ ud forrest. For hver hvid nabo $v$ i rækkefølge: $v.d = u.d + 1$, $v.pi = u$, læg $v$ bagest.],
  [Køen holder altid de grå knuder, og $d$-værdierne falder aldrig.],
  [Når køen er tom, er `v.d` afstanden fra $s$ til $v$ i kanter, eller $infinity$ hvis $v$ ikke kan nås:],
)

#eq[$ v.d = delta(s, v) $]

#note(title: [BFS niveaurækkefølge])[Alle knuder i afstand $i$ kommer ud før nogen i afstand $i + 1$. Vil du finde den første med $d = k$, fyld et niveau ad gangen: niveau 1 er de sorterede naboer til $s$, og udvid dem i rækkefølge.]

#recipe(
  title: "Topologisk sortering og komponenter",
  [Topologisk sortering (kun DAG): kør DFS og list knuderne efter faldende `u.f`. Så peger hver kant fra venstre mod højre. Tjek en foreslået rækkefølge ved at se, at hver kant $u arrow v$ har $u$ før $v$.],
  [Sammenhængskomponenter (uorienteret): kør DFS eller BFS med et ydre loop. Hvert ydre kald fejer en hel komponent, så tæl kaldene.],
  [Stærkt sammenhængende komponenter (orienteret, Kosaraju): kør DFS på $G$ og gem afslutningstider. Vend alle kanter til $G^T$. Kør DFS på $G^T$ med knuderne i faldende afslutningsrækkefølge; hvert træ er én SCC.],
)

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [BFS: kør i hånden, find afstand/rækkefølge],
  source: "MCQ juni 2023, spm. 14",
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
  tag: [DFS: klassificér kanter (tæl forward/back/cross)],
  source: "MCQ juni 2023, spm. 16",
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
  tag: [Topologisk sortering: er rækkefølgen gyldig?],
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
  tag: [DFS: kør i hånden, find opdagelses-/afslutningstid],
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
