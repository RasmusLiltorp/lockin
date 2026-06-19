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

== Prioritetskøer og heaps <th-heap-property>

En prioritetskø (priority queue) trækker hele tiden den vigtigste nøgle ud — den mindste i en min-kø, den største i en max-kø. Den implementeres typisk som en binær heap (binary heap).

En binær heap er et komplet binært træ (complete binary tree) gemt i et array. "Komplet" betyder, at træet fyldes lag for lag fra venstre uden huller. Hver forælder dominerer sine børn: i en min-heap er forælderen aldrig større, i en max-heap aldrig mindre.

Træet ligger i et 1-indekseret array $A[1..n]$, og indekset alene giver børn og forælder:

#eq[$ "forælder"(i) = floor(i\/2), quad "venstre"(i) = 2i, quad "højre"(i) = 2i + 1 $]

Et array *er* et træ. Tag $A = [18,9,16,4,8,12,13,1,2]$ — sådan ser det ud med pladsnumrene over:

#block(above: 14pt, below: 8pt)[
  #harray((18, 9, 16, 4, 8, 12, 13, 1, 2))
]

Plads 1 er roden. Børnene af plads $i$ står på $2i$ og $2i+1$, forælderen på $floor(i\/2)$, så plads 1 har børn på 2 og 3, plads 2 har børn på 4 og 5, og så videre. Hver forælder er $>=$ sine børn (max-heap), så den største ($18$) ligger forrest. *Boble op* (sift up) flytter en værdi mod plads 1, *synk ned* (sift down) flytter den mod de bagerste pladser. Det er alt operationerne gør.

Til eksamen skal du afgøre om et array er en heap, og trace `Extract`, `Increase-Key` og `Insert` skridt for skridt.

=== Sådan løser du den

Hver operation har sin egen opskrift herunder. De er skrevet for en *max-heap* (største øverst). Kører du en *min-heap*, byt blot "størst/større" ud med "mindst/mindre" overalt. Husk positions-reglerne: barn af plads $i$ ligger på $2i$ og $2i+1$; forælder ligger på $floor(i\/2)$.

==== Heap-Increase-Key$(A, i, k)$ — gør en nøgle større <th-heap-increase-key>

*Hvad det gør:* sætter nøglen på plads $i$ op til en større værdi $k$, og lader den "boble opad" til sin rette plads.

#recipe(
  title: "Increase-Key — boble op",
  [Skriv den nye værdi ind: $A[i] = k$. (I en max-heap skal $k$ være $>=$ den gamle værdi.)],
  [Find forælderen på plads $floor(i\/2)$.],
  [Er din nøgle *større* end forælderen, så *byt* de to. Er den ikke, *stop*; så er du færdig.],
  [Efter byttet står din nøgle på forælderens gamle plads. Gentag fra trin 2 derfra, indtil forælderen er større, eller du rammer roden (plads 1).],
)

==== Heap-Extract-Max$(A)$ — træk den største ud <th-heap-extract>

*Hvad det gør:* roden (plads 1) er altid den største. Du fjerner den, sætter en ny værdi i roden og lader den "synke nedad", til heap-ordenen passer igen.

#recipe(
  title: "Extract-Max — synk ned",
  [Roden $A[1]$ er svaret (den største). Den fjernes.],
  [Flyt det *sidste* element op på plads 1. Heapen bliver nu én plads kortere (den sidste plads findes ikke længere).],
  [Kig på plads 1's to børn (plads $2$ og $3$). Find den *største* af de tre: forælder, venstre barn, højre barn.],
  [Er et *barn* størst, *byt* forælder med det barn. Er *forælderen* størst, *stop*.],
  [Efter byttet står din nøgle på barnets plads. Gentag fra trin 3 derfra, indtil intet barn er større, eller knuden ingen børn har. Aflæs arrayet.],
)

==== Insert$(A, k)$ — indsæt en ny nøgle <th-heap-insert>

*Hvad det gør:* lægger en ny nøgle ind og bobler den op, præcis som Increase-Key.

#recipe(
  title: "Insert — læg på og boble op",
  [Læg den nye nøgle på første ledige plads (lige efter det sidste element). Træet er stadig komplet.],
  [Boble op nøjagtigt som i Increase-Key: byt med forælderen så længe din nøgle er større, stop ellers.],
)

==== Tjek om et array er en heap <th-heap-validity>

#recipe(
  title: "Er det en gyldig heap?",
  [Tjek for huller: står der en værdi efter en tom plads, er arrayet ikke en gyldig heap.],
  [Løb de interne knuder (internal nodes) igennem, $i = 1 .. floor(n\/2)$, for kun de har børn.],
  [Tjek begge børn for hver knude. Min-heap kræver $A[i] <= A[2i]$ og $A[i] <= A[2i+1]$; max-heap kræver $A[i] >=$ begge børn. Ens nøgler er tilladt.],
  [Én overtrådt ulighed er nok til at forkaste arrayet.],
)

#trap(title: [Boble op vs. synk ned])[Den klassiske trace-fejl er at bytte retning om. Increase-Key og Insert *bobler op* (mod forælderen, $floor(i\/2)$). Extract *synker ned* (mod børnene, $2i$ og $2i+1$). Roden er min i en min-heap og max i en max-heap, aldrig begge.]

#metadata(none) <th-heap-build>
#note(title: [Build-Heap-køretid])[Build-Heap er $O(n)$, ikke $O(n log n)$. Den kalder synk-ned nedefra og op over arrayets nederste halvdel. At indsætte $n$ nøgler én ad gangen ville koste $O(n log n)$.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Heap: er arrayet en (min-)heap? (min-heap)],
  source: "DM507 juni 2012, Opg. 2a (5%)",
  theory: <th-heap-validity>,
  prompt: [Hvilke af følgende arrays af størrelse $#swap[$10$]$ er min-heaps? \
    A1 $= [7,4,9,2,6,8,10,1,3,5]$ \
    A2 $= [1,2,3,4,5,6,7,8,9,10]$ \
    A3 $= [1,2,3,4,1,2,3,4,5,6]$ \
    A4 $= [1,1,1,1,1,1,1,1,1,1]$],
  answer: [A2 og A4.],
  blueprint: [
    Her tjekker du hver forælder mod sine børn. Knækker bare én ulighed, er det ikke en min-heap.

    + *Find de interne knuder.* Kun $i = 1 .. floor(n\/2)$ har børn, så kun dem skal tjekkes. For #swap[$n=10$] er det $i = 1..5$.
    + *Slå børnene op.* Barn af $i$ ligger på $2i$ og $2i+1$.
    + *Tjek uligheden.* Min-heap kræver $#swap[$A[i] <= A[2i]$]$ og $A[i] <= A[2i+1]$. Ens nøgler er tilladt.
    + *Stop ved første brud.* Holder alle uligheder, er det en min-heap. Ellers ikke.
  ],
  worked: [
    Tjek $A[i] <= A[2i]$ og $A[i] <= A[2i+1]$ for $i = 1..5$.

    - A1 $= [7,4,9,2,6,8,10,1,3,5]$: $A[1]=7 > A[2]=4$. Brud med det samme, ikke en heap.
    - A2 $= [1,2,3,4,5,6,7,8,9,10]$: sorteret stigende, så hver forælder er $<=$ begge børn. Min-heap.
    - A3 $= [1,2,3,4,1,2,3,4,5,6]$: $A[2]=2 > A[5]=1$. Brud, ikke en heap.
    - A4 $= [1,1,1,1,1,1,1,1,1,1]$: alle nøgler ens, så alle uligheder holder. Min-heap.

    Svar: A2 og A4.
  ],
)

#qcard(
  tag: [Heap: er arrayet en (min-)heap? (min-heap)],
  source: "MCQ juni 2017, Spm. 6 (flere rigtige)",
  theory: <th-heap-validity>,
  prompt: [Hvilke af følgende arrays af størrelse $#swap[$8$]$ er min-heaps? \
    A0 $= [0,1,0,1,1,0,1,1]$ \
    A1 $= [0,0,0,1,1,1,0,1]$ \
    A2 $= [0,0,1,0,0,1,1,0]$ \
    A3 $= [0,1,0,1,0,1,0,1]$ \
    A4 $= [0,0,0,0,1,1,1,1]$ \
    A5 $= [1,1,1,1,0,0,0,0]$ \
    A6 $= [0,0,0,0,0,0,0,0]$],
  answer: [Mulighed A0, A1, A2, A4 og A6: alle med ens eller stigende nøgler nedad. A3 og A5 har en forælder større end et barn.],
  blueprint: [
    Samme tjek som før: hold hver forælder op mod sine børn, og knæk én ulighed, så ryger arrayet.

    + *Find de interne knuder.* Kun $i = 1 .. floor(n\/2)$ har børn. For #swap[$n=8$] er det $i = 1..4$.
    + *Slå børnene op.* Barn af $i$ ligger på $2i$ og $2i+1$.
    + *Tjek uligheden.* Min-heap kræver $#swap[$A[i] <= A[2i]$]$ og $A[i] <= A[2i+1]$. Ens nøgler er fine.
    + *Stop ved første brud.* Holder alt, er det en min-heap.
  ],
  worked: [
    Tjek $A[i] <= A[2i]$ og $A[i] <= A[2i+1]$ for $i = 1..4$.

    - A0 $= [0,1,0,1,1,0,1,1]$: $0 <= 1,0$; $1 <= 1,1$; $0 <= 0,1$; $1 <= 1$. Min-heap.
    - A1 $= [0,0,0,1,1,1,0,1]$: alle forældre $<=$ deres børn. Min-heap.
    - A2 $= [0,0,1,0,0,1,1,0]$: alle uligheder holder. Min-heap.
    - A3 $= [0,1,0,1,0,1,0,1]$: $A[2]=1 > A[5]=0$. Brud, ikke en heap.
    - A4 $= [0,0,0,0,1,1,1,1]$: alle forældre $<=$ deres børn. Min-heap.
    - A5 $= [1,1,1,1,0,0,0,0]$: $A[2]=1 > A[5]=0$. Brud, ikke en heap.
    - A6 $= [0,0,0,0,0,0,0,0]$: alle nøgler ens. Min-heap.

    Svar: A0, A1, A2, A4 og A6.
  ],
)

#qcard(
  tag: [Heap: er arrayet en (min-)heap? (min-heap)],
  source: "MCQ juni 2019, Spm. 7 (flere rigtige)",
  theory: <th-heap-validity>,
  prompt: [Hvilke af følgende arrays er max-heaps? (1-indekseret; en tom plads efterfulgt af en værdi er et hul og dur ikke som heap-array.) \
    A0 $= [4,3,3,2,1,#h(0.7em),1]$ (plads 6 tom, plads 7 $= 1$) \
    A1 $= [4,3,4,2,1,4]$ \
    A2 $= [3,4,4,2,1,#h(0.7em),4]$ (plads 6 tom, plads 7 $= 4$) \
    A3 $= [4,4,4,4,4,4]$ \
    A4 $= [1,2,3,4,5,6]$ \
    A5 $= [-1,-2,-3,-4,-5,-6]$],
  answer: [Mulighed A1, A3 og A5: ingen huller, og hver forælder $>=$ begge børn.],
  blueprint: [
    Her er der to ting at fange: huller i arrayet og brud på max-uligheden.

    + *Tjek for hul.* Står der en værdi efter en tom plads, er det ikke et gyldigt heap-array. Forkast med det samme.
    + *Find de interne knuder,* $i = 1 .. floor(n\/2)$.
    + *Tjek uligheden.* Max-heap kræver $#swap[$A[i] >= A[2i]$]$ og $A[i] >= A[2i+1]$. Ens nøgler er fine, og negative tal tæller helt normalt.
    + *Stop ved første brud.*
  ],
  worked: [
    - A0: hul på plads 6 med værdi på plads 7. Ugyldigt array.
    - A1 $= [4,3,4,2,1,4]$: $4 >= 3,4$; $3 >= 2,1$; $4 >= 4$. Max-heap.
    - A2: hul på plads 6 med værdi på plads 7 (og roden $3 <$ barnet $4$). Ugyldigt.
    - A3 $= [4,4,4,4,4,4]$: alle nøgler ens. Max-heap.
    - A4 $= [1,2,3,4,5,6]$: roden $1 < 2$. Ikke en heap.
    - A5 $= [-1,-2,-3,-4,-5,-6]$: $-1 >= -2,-3$; $-2 >= -4,-5$; $-3 >= -6$. Max-heap.

    Svar: A1, A3 og A5.
  ],
)

#qcard(
  tag: [Heap: er arrayet en (min-)heap? (min-heap)],
  source: "MCQ juni 2021, Spm. 7 (flere rigtige)",
  theory: <th-heap-validity>,
  prompt: [Hvilke af følgende arrays $A$ er max-heaps? \
    A0 $= [2,1]$ \
    A1 $= [2,1,2,1]$ \
    A2 $= [2,1,2,1,2,1]$ \
    A3 $= [2,1,2,1,2,1,2,1]$ \
    A4 $= [-2,-2,-2,-2,-2,-2]$ \
    A5 $= [1,2,4,8,16,32,64]$ \
    A6 $= [1,-1,-1,-2,-2,-2]$],
  answer: [Mulighed A0, A1, A4 og A6: hver forælder $>=$ begge børn.],
  blueprint: [
    Den klassiske fælde her er en knude længere nede med et større barn — tjek alle interne knuder, ikke kun roden.

    + *Find de interne knuder,* $i = 1 .. floor(n\/2)$.
    + *Tjek uligheden.* Max-heap kræver $#swap[$A[i] >= A[2i]$]$ og $A[i] >= A[2i+1]$.
    + *Pas på dybe brud.* En knude på plads 2 eller 3 kan sagtens være mindre end sit barn, selvom roden ser fin ud.
    + *Stop ved første brud.*
  ],
  worked: [
    - A0 $= [2,1]$: $2 >= 1$. Max-heap.
    - A1 $= [2,1,2,1]$: $2 >= 1,2$; $1 >= 1$. Max-heap.
    - A2 $= [2,1,2,1,2,1]$: $A[2]=1 < A[5]=2$. Brud, ikke en heap.
    - A3 $= [2,1,2,1,2,1,2,1]$: $A[2]=1 < A[5]=2$. Brud, ikke en heap.
    - A4 $= [-2,-2,-2,-2,-2,-2]$: alle nøgler ens. Max-heap.
    - A5 $= [1,2,4,8,16,32,64]$: roden $1 < 2$. Ikke en heap.
    - A6 $= [1,-1,-1,-2,-2,-2]$: $1 >= -1,-1$; $-1 >= -2,-2$; $-1 >= -2$. Max-heap.

    Svar: A0, A1, A4 og A6.
  ],
)

#qcard(
  tag: [Heap: trace Extract-Min skridt for skridt (synk ned)],
  source: "MCQ juni 2023, Spm. 7",
  theory: <th-heap-extract>,
  prompt: [Udfør Extract-Min på min-heapen $A = #swap[$[3,5,6,10,11,8,7,18,16,15]$]$ (1-indekseret, positioner $1..10$). Hvilken position i $A$ ender $#swap[$15$]$ på bagefter?],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$8$], [$9$]),
  answer: [(d) position 4.],
  blueprint: [
    Extract-Min trækker roden ud og reparerer heapen ved at synke det sidste element ned på plads.

    + *Tag roden ud.* $A[1]$ er svaret (det mindste).
    + *Flyt sidste element op i roden.* Heapen bliver én plads kortere.
    + *Synk ned.* Sammenlign #swap[knuden] med begge børn på $2i$ og $2i+1$. Er et barn mindre, byt med det *mindste* barn.
    + *Gentag,* til ingen børn er mindre, eller knuden ingen børn har. Aflæs arrayet.
  ],
  worked: [
    Her er heapen: #swap[$[3,5,6,10,11,8,7,18,16,15]$].

    + Tag roden $3$ ud, flyt sidste element $15$ op. Størrelse $9$: $[15,5,6,10,11,8,7,18,16]$.
    + Idx 1: børn er $5$ og $6$. Mindst er $5$, og $5 < 15$, så byt. $15$ rykker til idx 2: $[5,15,6,10,11,8,7,18,16]$.
    + Idx 2: børn er $10$ og $11$. Mindst er $10$, og $10 < 15$, så byt. $15$ rykker til idx 4: $[5,10,6,15,11,8,7,18,16]$.
    + Idx 4: børn er $18$ (idx 8) og $16$ (idx 9). Begge $> 15$, så stop.

    Slutarray: $[5,10,6,15,11,8,7,18,16]$. $15$ står på position 4.
  ],
)

#qcard(
  tag: [Heap: trace Increase-Key + Extract-Max (Increase-Key)],
  source: "MCQ juni 2015, Spm. 6",
  theory: <th-heap-increase-key>,
  prompt: [Udfør først Heap-Increase-Key$(A, #swap[$9$], #swap[$15$])$ og derefter Heap-Extract-Max$(A)$ på max-heapen $A$ herunder. $A$ (positioner $1..9$) $= #swap[$[18,9,16,4,8,12,13,1,2]$]$. Hvilket af svarene viser heapen efter de to operationer?],
  options: (
    [$A = [16,15,13,9,8,4,12,1]$],
    [$A = [16,15,13,9,8,12,4,1]$],
    [$A = [16,15,13,4,8,12,2,1]$],
    [$A = [16,15,13,4,8,12,1,2]$],
  ),
  answer: [(b) $[16,15,13,9,8,12,4,1]$.],
  blueprint: [
    Den nye nøgle bobler op mod roden, og bagefter trækker Extract-Max roden ud og synker en ny værdi på plads.

    + *Increase-Key.* Skriv #swap[den nye værdi $k$] ind på plads $i$. Boble op: byt med forælderen på $floor(i\/2)$ så længe din nøgle er *større*, stop ellers.
    + *Extract-Max.* Roden $A[1]$ er max og fjernes. Flyt sidste element op i roden.
    + *Synk ned.* Byt med det *største* barn så længe et barn er større. Aflæs arrayet.
  ],
  worked: [
    Start: #swap[$[18,9,16,4,8,12,13,1,2]$].

    *Increase-Key$(A, 9, 15)$* — sæt pos 9 til $15$ og boble op:
    + Forælder på pos 4 er $4 < 15$, byt. $15$ til pos 4.
    + Forælder på pos 2 er $9 < 15$, byt. $15$ til pos 2.
    + Forælder på pos 1 er $18 > 15$, stop. Nu: $[18,15,16,9,8,12,13,1,4]$.

    *Extract-Max$(A)$* — tag $18$ ud, flyt sidste $4$ op, størrelse $8$, synk ned:
    + Idx 1: børn $15$ og $16$. Størst er $16 > 4$, byt. $4$ til idx 3.
    + Idx 3: børn $12$ og $13$. Størst er $13 > 4$, byt. $4$ til idx 7.
    + Idx 7: barn $1 < 4$, stop.

    Slutarray: $[16,15,13,9,8,12,4,1]$.
  ],
)

#qcard(
  tag: [Heap: trace Extract-Max skridt for skridt (Extract-Max)],
  source: "MCQ juni 2019, Spm. 8",
  theory: <th-heap-extract>,
  prompt: [Udfør Heap-Extract-Max$(A)$ på max-heapen $A = #swap[$[5,4,3,3,4,2,3,2,1]$]$ (positioner $1..9$). Hvordan ser $A$ ud bagefter?],
  options: (
    [$A = [4,4,3,3,3,2,2,1,#h(0.7em)]$],
    [$A = [#h(0.7em),4,3,3,4,2,3,2,1]$],
    [$A = [4,3,3,4,2,3,2,1,#h(0.7em)]$],
    [$A = [4,4,3,3,1,2,3,2,#h(0.7em)]$],
    [$A = [4,4,3,3,2,3,2,1,#h(0.7em)]$],
  ),
  answer: [Mulighed (d): $[4,4,3,3,1,2,3,2,#h(0.7em)]$.],
  blueprint: [
    Extract-Max trækker roden ud og synker det sidste element ned, til max-ordenen passer igen.

    + *Tag roden ud.* $A[1]$ er svaret (den største).
    + *Flyt sidste element op i roden.* Heapen bliver én plads kortere.
    + *Synk ned.* Sammenlign #swap[knuden] med begge børn på $2i$ og $2i+1$. Er et barn større, byt med det *største* barn.
    + *Gentag,* til intet barn er større, eller knuden ingen børn har. Aflæs arrayet.
  ],
  worked: [
    Her er heapen: #swap[$[5,4,3,3,4,2,3,2,1]$].

    + Tag roden $5$ ud, flyt sidste element $1$ op. Størrelse $8$: $[1,4,3,3,4,2,3,2]$.
    + Idx 1: børn $4$ (idx 2) og $3$ (idx 3). Størst er $4$, og $4 > 1$, så byt. $1$ rykker til idx 2: $[4,1,3,3,4,2,3,2]$.
    + Idx 2: børn $3$ (idx 4) og $4$ (idx 5). Størst er $4$, og $4 > 1$, så byt. $1$ rykker til idx 5: $[4,4,3,3,1,2,3,2]$.
    + Idx 5: børnene ville stå på idx 10 og 11, uden for heapen (størrelse 8). Stop.

    Slutarray: $[4,4,3,3,1,2,3,2]$, plads 9 tom.
  ],
)

#qcard(
  tag: [Heap: trace Extract-Max skridt for skridt (Extract-Max)],
  source: "MCQ juni 2017, Spm. 7",
  theory: <th-heap-extract>,
  prompt: [Udfør to gange Heap-Extract-Max$(A)$ på max-heapen $A = #swap[$[1,1,0,1,0,0,0,1]$]$ (positioner $1..8$). Hvordan ser $A$ ud bagefter?],
  options: (
    [$A = [0,1,0,1,0,0,#h(0.7em),#h(0.7em)]$],
    [$A = [1,0,1,0,0,0,#h(0.7em),#h(0.7em)]$],
    [$A = [1,1,0,0,0,0,#h(0.7em),#h(0.7em)]$],
    [$A = [1,0,0,1,0,0,#h(0.7em),#h(0.7em)]$],
    [$A = [1,1,0,1,0,0,0,#h(0.7em)]$],
  ),
  answer: [Mulighed (c): $[1,1,0,0,0,0,#h(0.7em),#h(0.7em)]$.],
  blueprint: [
    To Extract-Max i træk. Kør den ene helt færdig, og brug resultatet som start på den næste.

    + *Første Extract-Max.* Roden ud, sidste element op i roden, synk ned med det største barn, til ordenen passer.
    + *Anden Extract-Max.* Gentag på den nu én kortere heap.
    + *Synk ned.* Byt altid med det *største* barn så længe et barn er større. Aflæs arrayet.
  ],
  worked: [
    Start: #swap[$[1,1,0,1,0,0,0,1]$], størrelse $8$.

    *Første Extract-Max:* tag $1$ ud, flyt sidste $1$ op, størrelse $7$: $[1,1,0,1,0,0,0]$. Børn af roden er $1$ og $0$, begge $<= 1$, intet byt. Tilstand $[1,1,0,1,0,0,0]$.

    *Anden Extract-Max:* tag $1$ ud, flyt sidste $0$ op, størrelse $6$: $[0,1,0,1,0,0]$.
    + Idx 1: børn $1$ (idx 2) og $0$ (idx 3). Størst er $1 > 0$, byt: $[1,0,0,1,0,0]$.
    + Idx 2: børn $1$ (idx 4) og $0$ (idx 5). Størst er $1 > 0$, byt: $[1,1,0,0,0,0]$.
    + Idx 4: ingen børn inden for størrelse 6. Stop.

    Slutarray: $[1,1,0,0,0,0]$, pladserne 7 og 8 tomme.
  ],
)

#qcard(
  tag: [Heap: trace Insert-sekvens (Insert)],
  source: "MCQ juni 2021, Spm. 8",
  theory: <th-heap-insert>,
  prompt: [Indsæt med Max-Heap-Insert tallene #swap[$6, 12, 13, 4, 8, 14, 5$] i den rækkefølge i en tom binær max-heap $A$. Hvordan ser $A$ ud bagefter?],
  options: (
    [$A = [14,12,13,4,8,6,5]$],
    [$A = [6,12,13,4,8,14,5]$],
    [$A = [14,8,13,4,6,12,5]$],
    [$A = [14,13,12,8,6,5,4]$],
    [$A = [13,12,14,4,8,6,5]$],
  ),
  answer: [Mulighed (c): $[14,8,13,4,6,12,5]$.],
  blueprint: [
    Hver indsættelse lægger nøglen på første ledige plads og bobler den op. Det er indsættelsesrækkefølgen, ikke en sortering, så resultatet er sjældent fuldt sorteret.

    + *Læg på.* Sæt den nye nøgle på næste ledige plads (lige efter det sidste element).
    + *Boble op.* Byt med forælderen på $floor(i\/2)$ så længe din nøgle er *større*. Stop ved roden eller når forælderen er $>=$.
    + *Gentag* for hvert tal i rækkefølgen, og aflæs arrayet til sidst.
  ],
  worked: [
    Indsæt #swap[$6, 12, 13, 4, 8, 14, 5$] et ad gangen, max-heap:

    + $6$: $[6]$.
    + $12$ på plads 2, $12 > 6$ byt: $[12,6]$.
    + $13$ på plads 3, $13 > 12$ byt: $[13,6,12]$.
    + $4$ på plads 4, forælder $6 > 4$ stop: $[13,6,12,4]$.
    + $8$ på plads 5, forælder $6 < 8$ byt til plads 2, forælder $13 > 8$ stop: $[13,8,12,4,6]$.
    + $14$ på plads 6, forælder $12 < 14$ byt til plads 3, forælder $13 < 14$ byt til plads 1: $[14,8,13,4,6,12]$.
    + $5$ på plads 7, forælder $13 > 5$ stop: $[14,8,13,4,6,12,5]$.

    Slutarray: $[14,8,13,4,6,12,5]$.
  ],
)

#qcard(
  tag: [Heap: trace Build-Heap (Build-Heap)],
  source: "MCQ juni 2025, Spm. 7",
  theory: <th-heap-build>,
  prompt: [Kør Build-Min-Heap$(A, #swap[$8$])$ på arrayet $A = #swap[$[5,4,2,3,7,6,1,0]$]$ (positioner $1..8$). På hvilken position i $A$ ender nøglen $#swap[$5$]$?],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$], [$7$], [$8$]),
  answer: [Mulighed (h): position 8.],
  blueprint: [
    Build-Min-Heap synker hver intern knude på plads, nedefra og op. Følg din nøgle gennem byttene.

    + *Find startpunktet.* Kør Min-Heapify på knuderne fra $i = floor(n\/2)$ ned til $1$.
    + *Min-Heapify$(i)$.* Find den mindste af knuden og dens to børn ($2i$, $2i+1$). Er et barn mindre, byt og fortsæt rekursivt ned i det barn.
    + *Aflæs.* Når alle knuder er kørt, læs slutarrayet og find nøglen.
  ],
  worked: [
    Start: #swap[$[5,4,2,3,7,6,1,0]$], $n=8$. Heapify knuderne $4,3,2,1$.

    + $i=4$ (værdi 3): barn på plads 8 er $0$, byt: $[5,4,2,0,7,6,1,3]$.
    + $i=3$ (værdi 2): børn $6$ og $1$, mindst er $1$, byt: $[5,4,1,0,7,6,2,3]$.
    + $i=2$ (værdi 4): børn $0$ og $7$, mindst er $0$, byt: $[5,0,1,4,7,6,2,3]$; rekursér på plads 4 (værdi 4): barn på plads 8 er $3$, byt: $[5,0,1,3,7,6,2,4]$.
    + $i=1$ (værdi 5): børn $0$ og $1$, mindst er $0$, byt: $[0,5,1,3,7,6,2,4]$; rekursér på plads 2 (værdi 5): børn $3$ og $7$, mindst er $3$, byt: $[0,3,1,5,7,6,2,4]$; rekursér på plads 4 (værdi 5): barn på plads 8 er $4$, byt: $[0,3,1,4,7,6,2,5]$.

    Slutarray: $[0,3,1,4,7,6,2,5]$. Nøglen $5$ står på position 8.
  ],
)

#qcard(
  tag: [Heap: mulige pladser for en nøgle (min-heap)],
  source: "MCQ juni 2023, Spm. 8 (flere rigtige)",
  theory: <th-heap-property>,
  prompt: [En min-heap $A$ (array af størrelse $#swap[$5$]$, positioner $1..5$) indeholder nøglerne $#swap[${1,2,3,4,5}$]$. Angiv alle positioner i $A$, hvor nøglen $#swap[$4$]$ kan stå.],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$]),
  answer: [Mulighed (c), (d), (e): positionerne 3, 4 og 5. Position 1 må være minimum, og position 2 kan ikke holde $4$.],
  blueprint: [
    Du leder efter, hvor en nøgle *kan* stå i en min-heap. Reglen er, at hver knude skal være $<=$ alle sine efterkommere (descendants). Tæl efterkommere mod hvor mange større nøgler der findes.

    + *Tegn formen.* Med $n$ pladser: forælder af $i$ er $floor(i\/2)$; find hver positions efterkommere.
    + *Ranger nøglen.* Hvor mange af de andre nøgler er større end #swap[målnøglen]?
    + *Tjek hver position.* Position 1 (roden) skal være den mindste. En position med $k$ efterkommere kræver $k$ nøgler større end målnøglen.
    + *Saml de gyldige positioner.* Tjek evt. ved at prøve en konkret heap for hver.
  ],
  worked: [
    Form for 5 elementer: plads 1 er rod; plads 2 har børn ${4,5}$; plads 3 har ingen børn; plads 4 og 5 er blade. Nøglen $4$ er næststørst (kun $5$ er større).

    - Plads 1: roden skal være minimum ($1$), så $4$ er udelukket.
    - Plads 2: to efterkommere (plads 4 og 5) skal begge være $> 4$, men kun $5$ er det. Umuligt.
    - Plads 3: ingen efterkommere, fx $[1,2,4,3,5]$. Gyldig.
    - Plads 4: blad, fx $[1,2,3,4,5]$. Gyldig.
    - Plads 5: blad, fx $[1,3,2,5,4]$. Gyldig.

    Svar: positionerne 3, 4 og 5.
  ],
)

#qcard(
  tag: [Heap: mulige pladser for en nøgle (min-heap)],
  source: "MCQ juni 2025, Spm. 8 (flere rigtige)",
  theory: <th-heap-property>,
  prompt: [En min-heap $A$ (array af størrelse $#swap[$6$]$, positioner $1..6$) indeholder nøglerne $#swap[${5,6,7,8,9,10}$]$. Angiv alle positioner i $A$, hvor nøglen $#swap[$9$]$ kan stå.],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [Mulighed (c), (d), (e), (f): positionerne 3, 4, 5 og 6. Position 1 må være minimum, og position 2 har to efterkommere, der begge skulle være $> 9$.],
  blueprint: [
    Samme idé: en knude skal være $<=$ alle sine efterkommere. Tæl efterkommere mod antallet af større nøgler.

    + *Tegn formen.* Find hver positions efterkommere ud fra $2i$, $2i+1$.
    + *Ranger nøglen.* Tæl hvor mange nøgler der er større end #swap[målnøglen].
    + *Tjek hver position.* En position med $k$ efterkommere kræver $k$ større nøgler til rådighed. Roden skal være minimum.
    + *Saml de gyldige positioner.*
  ],
  worked: [
    Form for 6 elementer: plads 1 er rod; plads 2 har børn ${4,5}$; plads 3 har barn ${6}$; plads 4, 5, 6 er blade. Nøglen $9$ er næststørst (kun $10$ er større).

    - Plads 1: roden skal være minimum ($5$), så $9$ er udelukket.
    - Plads 2: to efterkommere (plads 4 og 5) skal begge være $> 9$, men kun $10$ er det. Umuligt.
    - Plads 3: én efterkommer (plads 6); læg $10$ der. Gyldig.
    - Plads 4, 5, 6: blade under en forælder $< 9$. Gyldige.

    Svar: positionerne 3, 4, 5 og 6.
  ],
)

#qcard(
  tag: [Heapsort: køretid på ens elementer (Build-Heap)],
  source: "MCQ juni 2019, Spm. 28",
  theory: <th-heap-build>,
  prompt: [Hvad er worst-case køretiden for Heapsort, når den køres på $#swap[$n$]$ identiske elementer?],
  options: ([$O(1)$], [$O(log n)$], [$O(n)$], [$O(n log n)$], [$O(n^2)$]),
  answer: [(c) $O(n)$.],
  blueprint: [
    Tæl arbejdet i de to faser, og se hvad inputtet gør ved sift-ned.

    + *Skriv faserne op.* Heapsort er Build-Max-Heap efterfulgt af $#swap[$n-1$]$ gange Extract-Max, hver med et sift-ned.
    + *Find prisen på ét sift-ned for dette input.* Når #swap[alle nøgler er ens], er ingen forælder strengt mindre end et barn, så hvert sift-ned stopper efter et par sammenligninger: $O(1)$.
    + *Gang sammen.* Antal kald gange pris per kald.
  ],
  worked: [
    Input: #swap[$n$ identiske elementer].

    + Build-Max-Heap kører $~n\/2$ sift-ned. Med ens nøgler stopper hvert kald straks, så fasen er $O(n)$.
    + Extract-Max kører $n-1$ gange. Hver gang stopper sift-ned efter en sammenligning eller to, altså $O(1)$ per kald. Fasen er $O(n)$.

    Begge faser er $O(n)$, så i alt $O(n)$.
  ],
)
