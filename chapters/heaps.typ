#import "../lib.typ": *

// Array drawn the way the exam shows it: a position row above a boxed value row.
#let harray(values, label: $A$) = {
  let idx = range(1, values.len() + 1).map(i => align(center, text(size: 8pt, fill: soft)[#i]))
  let vals = values.map(v => align(center + horizon, text(size: 9pt)[#v]))
  align(center, table(
    columns: (auto,) + (24pt,) * values.len(),
    align: horizon,
    stroke: none,
    inset: (x: 2pt, y: 5pt),
    [], ..idx,
    table.cell(stroke: none)[#label:], ..vals.map(v => table.cell(stroke: 0.6pt + ink, v)),
  ))
}

== Prioritetskøer og heaps

En prioritetskø trækker hele tiden den vigtigste nøgle ud — den mindste i en min-kø, den største i en max-kø. Den implementeres typisk som en binær heap.

En binær heap er et komplet binært træ gemt i et array. "Komplet" betyder, at træet fyldes lag for lag fra venstre uden huller. Hver forælder dominerer sine børn: i en min-heap er forælderen aldrig større, i en max-heap aldrig mindre.

Træet ligger i et 1-indekseret array $A[1..n]$, og indekset alene giver børn og forælder:

#eq[$ "forælder"(i) = floor(i\/2), quad "venstre"(i) = 2i, quad "højre"(i) = 2i + 1 $]

Et array *er* et træ. Tag $A = [18,9,16,4,8,12,13,1,2]$ — sådan ser det ud med pladsnumrene over:

#block(above: 14pt, below: 8pt)[
  #harray((18, 9, 16, 4, 8, 12, 13, 1, 2))
]

Plads 1 er roden. Børnene af plads $i$ står på $2i$ og $2i+1$, forælderen på $floor(i\/2)$, så plads 1 har børn på 2 og 3, plads 2 har børn på 4 og 5, og så videre. Hver forælder er $>=$ sine børn (max-heap), så den største ($18$) ligger forrest. *Boble op* flytter en værdi mod plads 1, *synk ned* flytter den mod de bagerste pladser. Det er alt operationerne gør.

Til eksamen skal du afgøre om et array er en heap, og trace `Extract`, `Increase-Key` og `Insert` skridt for skridt.

=== Sådan løser du den

Hver operation har sin egen opskrift herunder. De er skrevet for en *max-heap* (største øverst). Kører du en *min-heap*, byt blot "størst/større" ud med "mindst/mindre" overalt. Husk positions-reglerne: barn af plads $i$ ligger på $2i$ og $2i+1$; forælder ligger på $floor(i\/2)$.

==== Heap-Increase-Key$(A, i, k)$ — gør en nøgle større

*Hvad det gør:* sætter nøglen på plads $i$ op til en større værdi $k$, og lader den "boble opad" til sin rette plads.

#recipe(
  title: "Increase-Key — boble op",
  [Skriv den nye værdi ind: $A[i] = k$. (I en max-heap skal $k$ være $>=$ den gamle værdi.)],
  [Find forælderen på plads $floor(i\/2)$.],
  [Er din nøgle *større* end forælderen, så *byt* de to. Er den ikke, *stop*; så er du færdig.],
  [Efter byttet står din nøgle på forælderens gamle plads. Gentag fra trin 2 derfra, indtil forælderen er større, eller du rammer roden (plads 1).],
)

==== Heap-Extract-Max$(A)$ — træk den største ud

*Hvad det gør:* roden (plads 1) er altid den største. Du fjerner den, sætter en ny værdi i roden og lader den "synke nedad", til heap-ordenen passer igen.

#recipe(
  title: "Extract-Max — synk ned",
  [Roden $A[1]$ er svaret (den største). Den fjernes.],
  [Flyt det *sidste* element op på plads 1. Heapen bliver nu én plads kortere (den sidste plads findes ikke længere).],
  [Kig på plads 1's to børn (plads $2$ og $3$). Find den *største* af de tre: forælder, venstre barn, højre barn.],
  [Er et *barn* størst, *byt* forælder med det barn. Er *forælderen* størst, *stop*.],
  [Efter byttet står din nøgle på barnets plads. Gentag fra trin 3 derfra, indtil intet barn er større, eller knuden ingen børn har. Aflæs arrayet.],
)

==== Insert$(A, k)$ — indsæt en ny nøgle

*Hvad det gør:* lægger en ny nøgle ind og bobler den op, præcis som Increase-Key.

#recipe(
  title: "Insert — læg på og boble op",
  [Læg den nye nøgle på første ledige plads (lige efter det sidste element). Træet er stadig komplet.],
  [Boble op nøjagtigt som i Increase-Key: byt med forælderen så længe din nøgle er større, stop ellers.],
)

==== Tjek om et array er en heap

#recipe(
  title: "Er det en gyldig heap?",
  [Tjek for huller: står der en værdi efter en tom plads, er arrayet ikke en gyldig heap.],
  [Løb de interne knuder igennem, $i = 1 .. floor(n\/2)$, for kun de har børn.],
  [Tjek begge børn for hver knude. Min-heap kræver $A[i] <= A[2i]$ og $A[i] <= A[2i+1]$; max-heap kræver $A[i] >=$ begge børn. Ens nøgler er tilladt.],
  [Én overtrådt ulighed er nok til at forkaste arrayet.],
)

#trap(title: [Boble op vs. synk ned])[Den klassiske trace-fejl er at bytte retning om. Increase-Key og Insert *bobler op* (mod forælderen, $floor(i\/2)$). Extract *synker ned* (mod børnene, $2i$ og $2i+1$). Roden er min i en min-heap og max i en max-heap, aldrig begge.]

#note(title: [Build-Heap-køretid])[Build-Heap er $O(n)$, ikke $O(n log n)$. Den kalder synk-ned nedefra og op over arrayets nederste halvdel. At indsætte $n$ nøgler én ad gangen ville koste $O(n log n)$.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Heap: er arrayet en (min-)heap?],
  source: "DM507 juni 2012, Opg. 2a (5%)",
  prompt: [Hvilke af følgende arrays af størrelse $#swap[$10$]$ er min-heaps? \
    A1 $= [7,4,9,2,6,8,10,1,3,5]$ \
    A2 $= [1,2,3,4,5,6,7,8,9,10]$ \
    A3 $= [1,2,3,4,1,2,3,4,5,6]$ \
    A4 $= [1,1,1,1,1,1,1,1,1,1]$],
  answer: [A2 og A4.],
  worked: [Tjek $A[i] <= A[2i]$ og $A[i] <= A[2i+1]$ for $i = 1..5$. A1: $A[1]=7 > A[2]=4$, falder. A2: sorteret stigende, forælder $<=$ børn — min-heap. A3: $A[2]=2 > A[5]=1$, falder. A4: alle ens — min-heap.],
)

#qcard(
  tag: [Heap: trace Extract-Min skridt for skridt],
  source: "MCQ juni 2023, Spm. 7",
  prompt: [Udfør Extract-Min på min-heapen $A = #swap[$[3,5,6,10,11,8,7,18,16,15]$]$ (1-indekseret, positioner $1..10$). Hvilken position i $A$ ender $#swap[$15$]$ på bagefter?],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$8$], [$9$]),
  answer: [(d) position 4.],
  worked: [Fjern roden $3$, flyt sidste element $15$ op, størrelse $9$: $[15,5,6,10,11,8,7,18,16]$. Sift ned fra idx 1: børn $5,6$, byt med $5$ — $15$ til idx 2. Idx 2: børn $10,11$, byt med $10$ — $15$ til idx 4. Børn ved idx 8 ($18$) og 9 ($16$) er begge $> 15$, stop. Slut $[5,10,6,15,11,8,7,18,16]$: $15$ står på position 4.],
)

#qcard(
  tag: [Heap: trace Increase-Key + Extract-Max],
  source: "MCQ juni 2015, Spm. 6",
  prompt: [Udfør først Heap-Increase-Key$(A, #swap[$9$], #swap[$15$])$ og derefter Heap-Extract-Max$(A)$ på max-heapen $A$ herunder. $A$ (positioner $1..9$) $= #swap[$[18,9,16,4,8,12,13,1,2]$]$. Hvilket af svarene viser heapen efter de to operationer?],
  options: (
    [$A = [16,15,13,9,8,4,12,1]$],
    [$A = [16,15,13,9,8,12,4,1]$],
    [$A = [16,15,13,4,8,12,2,1]$],
    [$A = [16,15,13,4,8,12,1,2]$],
  ),
  answer: [(b) $[16,15,13,9,8,12,4,1]$.],
  worked: [Increase-Key pos 9 til $15$: forælder pos 4 $=4<15$ byt, pos 2 $=9<15$ byt, pos 1 $=18>15$ stop — $[18,15,16,9,8,12,13,1,4]$. Extract-Max: max $=18$, flyt sidste $4$ op, størrelse $8$, sift ned: mod $15,16$ byt med $16$, mod $12,13$ byt med $13$, mod barn $1$ stop. Slut $[16,15,13,9,8,12,4,1]$.],
)

#qcard(
  tag: [Heapsort: køretid på ens elementer],
  source: "MCQ juni 2019, Spm. 28",
  prompt: [Hvad er worst-case køretiden for Heapsort, når den køres på $#swap[$n$]$ identiske elementer?],
  options: ([$O(1)$], [$O(log n)$], [$O(n)$], [$O(n log n)$], [$O(n^2)$]),
  answer: [(c) $O(n)$.],
  worked: [Heapsort er Build-Max-Heap ($O(n)$) og derefter $n-1$ Extract-Max med sift-ned. Når alle nøgler er ens, er en forælder aldrig strengt mindre end et barn, så hvert sift-ned stopper efter et par sammenligninger — $O(1)$ per kald. Build: $~n\/2$ kald, Extract: $n-1$ kald, hver $O(1)$. I alt $O(n)$.],
)
