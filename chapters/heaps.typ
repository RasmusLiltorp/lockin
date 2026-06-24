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

==== Heap-Extract-Min$(A)$ — træk den mindste ud <th-heap-extract-min>

*Hvad det gør:* i en min-heap er roden (plads 1) altid den mindste. Du fjerner den, sætter en ny værdi i roden og lader den "synke nedad", til heap-ordenen passer igen. Det er Extract-Max spejlvendt. Hvor Extract-Max bytter mod det største barn, bytter Extract-Min mod det mindste.

#recipe(
  title: "Extract-Min — synk ned",
  [Roden $A[1]$ er svaret (den mindste). Den fjernes.],
  [Flyt det *sidste* element op på plads 1. Heapen bliver nu én plads kortere (den sidste plads findes ikke længere).],
  [Kig på plads 1's to børn (plads $2$ og $3$). Find den *mindste* af de tre: forælder, venstre barn, højre barn.],
  [Er et *barn* mindst, *byt* forælder med det barn. Er *forælderen* mindst, *stop*.],
  [Efter byttet står din nøgle på barnets plads. Gentag fra trin 3 derfra, indtil intet barn er mindre, eller knuden ingen børn har. Aflæs arrayet.],
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
    For $n = 10$ er de interne knuder $i = 1..5$. For hver tjekkes $A[i] <= A[2i]$ (venstre barn) og $A[i] <= A[2i+1]$ (højre barn). Første brud forkaster arrayet.

    ```
    A1 = [7,4,9,2,6,8,10,1,3,5]
      i=1: A[1]=7 vs A[2]=4 -> 7 <= 4 ? NEJ            BRUD -> ikke min-heap

    A2 = [1,2,3,4,5,6,7,8,9,10]
      i=1: 1 <= A[2]=2 og 1 <= A[3]=3      ok
      i=2: 2 <= A[4]=4 og 2 <= A[5]=5      ok
      i=3: 3 <= A[6]=6 og 3 <= A[7]=7      ok
      i=4: 4 <= A[8]=8 og 4 <= A[9]=9      ok
      i=5: 5 <= A[10]=10                   ok    -> min-heap

    A3 = [1,2,3,4,1,2,3,4,5,6]
      i=1: 1 <= A[2]=2 og 1 <= A[3]=3      ok
      i=2: A[2]=2 vs A[5]=1 -> 2 <= 1 ? NEJ          BRUD -> ikke min-heap

    A4 = [1,1,1,1,1,1,1,1,1,1]
      alle nøgler ens: hver A[i] <= begge børn (1 <= 1)  -> min-heap
    ```

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
    For $n = 8$ er de interne knuder $i = 1..4$. Børn af $i$ står på $2i$ og $2i+1$ (knude $4$ har kun ét barn, på plads $8$). Tjek $A[i] <= A[2i]$ og $A[i] <= A[2i+1]$.

    ```
    A0 = [0,1,0,1,1,0,1,1]
      i=1: 0 <= A[2]=1, 0 <= A[3]=0   ok
      i=2: 1 <= A[4]=1, 1 <= A[5]=1   ok
      i=3: 0 <= A[6]=0, 0 <= A[7]=1   ok
      i=4: 1 <= A[8]=1                ok   -> min-heap

    A1 = [0,0,0,1,1,1,0,1]
      i=1: 0 <= 0, 0 <= 0   ok
      i=2: 0 <= A[4]=1, 0 <= A[5]=1   ok
      i=3: 0 <= A[6]=1, 0 <= A[7]=0   ok
      i=4: 1 <= A[8]=1                ok   -> min-heap

    A2 = [0,0,1,0,0,1,1,0]
      i=1: 0 <= 0, 0 <= 1   ok
      i=2: 0 <= A[4]=0, 0 <= A[5]=0   ok
      i=3: 1 <= A[6]=1, 1 <= A[7]=1   ok
      i=4: 0 <= A[8]=0                ok   -> min-heap

    A3 = [0,1,0,1,0,1,0,1]
      i=1: 0 <= 1, 0 <= 0   ok
      i=2: A[2]=1 vs A[5]=0 -> 1 <= 0 ? NEJ   BRUD -> ikke min-heap

    A4 = [0,0,0,0,1,1,1,1]
      i=1: 0 <= 0, 0 <= 0   ok
      i=2: 0 <= A[4]=0, 0 <= A[5]=1   ok
      i=3: 0 <= A[6]=1, 0 <= A[7]=1   ok
      i=4: 0 <= A[8]=1                ok   -> min-heap

    A5 = [1,1,1,1,0,0,0,0]
      i=1: 1 <= 1, 1 <= 1   ok
      i=2: A[2]=1 vs A[5]=0 -> 1 <= 0 ? NEJ   BRUD -> ikke min-heap

    A6 = [0,0,0,0,0,0,0,0]
      alle nøgler ens (0 <= 0)   -> min-heap
    ```

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
    To ting forkaster et array: et hul (en tom plads med en værdi efter sig) og et brud på max-uligheden $A[i] >= A[2i], A[2i+1]$. De fulde arrays har $n = 6$, så de interne knuder er $i = 1..3$ (knude $3$ har kun barnet på plads $6$).

    ```
    A0 = [4,3,3,2,1, _ ,1]   plads 6 tom, plads 7 = 1
      hul: værdi efter tom plads -> UGYLDIGT array

    A1 = [4,3,4,2,1,4]
      i=1: A[1]=4 >= A[2]=3 og 4 >= A[3]=4   ok
      i=2: A[2]=3 >= A[4]=2 og 3 >= A[5]=1   ok
      i=3: A[3]=4 >= A[6]=4                  ok   -> max-heap

    A2 = [3,4,4,2,1, _ ,4]   plads 6 tom, plads 7 = 4
      hul -> UGYLDIGT array (og roden 3 < barnet 4)

    A3 = [4,4,4,4,4,4]
      alle nøgler ens (4 >= 4)   -> max-heap

    A4 = [1,2,3,4,5,6]
      i=1: A[1]=1 >= A[2]=2 ? NEJ            BRUD -> ikke max-heap

    A5 = [-1,-2,-3,-4,-5,-6]
      i=1: -1 >= A[2]=-2 og -1 >= A[3]=-3    ok
      i=2: -2 >= A[4]=-4 og -2 >= A[5]=-5    ok
      i=3: -3 >= A[6]=-6                     ok   -> max-heap
    ```

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
    Max-heap kræver $A[i] >= A[2i]$ og $A[i] >= A[2i+1]$ for alle interne knuder. Fælden er en knude *under* roden, der er mindre end sit barn — så tjek hver intern knude, ikke kun plads 1.

    ```
    A0 = [2,1]                  n=2, intern: i=1
      i=1: A[1]=2 >= A[2]=1     ok   -> max-heap

    A1 = [2,1,2,1]              n=4, interne: i=1,2
      i=1: 2 >= A[2]=1 og 2 >= A[3]=2   ok
      i=2: A[2]=1 >= A[4]=1             ok   -> max-heap

    A2 = [2,1,2,1,2,1]          n=6, interne: i=1,2,3
      i=1: 2 >= 1, 2 >= 2       ok
      i=2: A[2]=1 vs A[5]=2 -> 1 >= 2 ? NEJ   BRUD -> ikke max-heap

    A3 = [2,1,2,1,2,1,2,1]      n=8, interne: i=1..4
      i=1: 2 >= 1, 2 >= 2       ok
      i=2: A[2]=1 vs A[5]=2 -> 1 >= 2 ? NEJ   BRUD -> ikke max-heap

    A4 = [-2,-2,-2,-2,-2,-2]    alle nøgler ens (-2 >= -2)   -> max-heap

    A5 = [1,2,4,8,16,32,64]
      i=1: A[1]=1 vs A[2]=2 -> 1 >= 2 ? NEJ   BRUD -> ikke max-heap

    A6 = [1,-1,-1,-2,-2,-2]     n=6, interne: i=1,2,3
      i=1: 1 >= A[2]=-1 og 1 >= A[3]=-1     ok
      i=2: -1 >= A[4]=-2 og -1 >= A[5]=-2   ok
      i=3: -1 >= A[6]=-2                    ok   -> max-heap
    ```

    Svar: A0, A1, A4 og A6.
  ],
)

#qcard(
  tag: [Heap: trace Extract-Min skridt for skridt (synk ned)],
  source: "MCQ juni 2023, Spm. 7",
  theory: <th-heap-extract-min>,
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
    Min-heap, så roden $A[1] = 3$ er det mindste og bliver trukket ud. Det sidste element $A[10] = 15$ flyttes op i roden, heapen krymper til størrelse $9$, og $15$ synker ned: sammenlign med begge børn ($2i$ og $2i+1$), og byt med det *mindste* barn så længe et barn er mindre.

    Hvert skridt herunder viser hele arrayet (indeks $1..9$ efter krympningen) med $15$ markeret undervejs:

    ```
    Start:        [  3,  5,  6, 10, 11,  8,  7, 18, 16, 15 ]   (størrelse 10)
    Tag rod 3 ud, flyt sidste 15 op i plads 1, størrelse -> 9:
    Efter:        [ 15,  5,  6, 10, 11,  8,  7, 18, 16 ]

    i=1: børn A[2]=5, A[3]=6.  mindst=5 < 15: byt plads 1 & 2
                  [  5, 15,  6, 10, 11,  8,  7, 18, 16 ]   15 -> plads 2
    i=2: børn A[4]=10, A[5]=11. mindst=10 < 15: byt plads 2 & 4
                  [  5, 10,  6, 15, 11,  8,  7, 18, 16 ]   15 -> plads 4
    i=4: børn A[8]=18, A[9]=16. begge > 15: stop
    ```

    Slut: $A = [5,10,6,15,11,8,7,18,16]$. Nøglen $15$ står på position 4.
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
    Max-heap. Først Increase-Key$(A, 9, 15)$: skriv $15$ ind på plads 9 (gammel værdi $2$, og $15 >= 2$, så det er lovligt) og boble op mod roden — byt med forælderen på $floor(i\/2)$ så længe din nøgle er *større*.

    ```
    Start:        [ 18,  9, 16,  4,  8, 12, 13,  1,  2 ]
    Sæt A[9]=15:  [ 18,  9, 16,  4,  8, 12, 13,  1, 15 ]   15 på plads 9

    forælder(9)=4: A[4]=4 < 15: byt plads 9 & 4
                  [ 18,  9, 16, 15,  8, 12, 13,  1,  4 ]   15 -> plads 4
    forælder(4)=2: A[2]=9 < 15: byt plads 4 & 2
                  [ 18, 15, 16,  9,  8, 12, 13,  1,  4 ]   15 -> plads 2
    forælder(2)=1: A[1]=18 > 15: stop
    ```

    Heapen er nu $[18,15,16,9,8,12,13,1,4]$. Så Extract-Max: roden $18$ ud, det sidste element $A[9] = 4$ op i plads 1, størrelse $8$, og $4$ synker ned mod det *største* barn.

    ```
    Tag rod 18 ud, flyt sidste 4 op, størrelse -> 8:
    Efter:        [  4, 15, 16,  9,  8, 12, 13,  1 ]

    i=1: børn A[2]=15, A[3]=16. størst=16 > 4: byt plads 1 & 3
                  [ 16, 15,  4,  9,  8, 12, 13,  1 ]   4 -> plads 3
    i=3: børn A[6]=12, A[7]=13. størst=13 > 4: byt plads 3 & 7
                  [ 16, 15, 13,  9,  8, 12,  4,  1 ]   4 -> plads 7
    i=7: børn ville stå på plads 14,15, uden for størrelse 8: stop
    ```

    Slut: $A = [16,15,13,9,8,12,4,1]$, svar (b).
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
    Max-heap. Roden $A[1] = 5$ er den største og trækkes ud; det sidste element $A[9] = 1$ flyttes op i plads 1, heapen krymper til størrelse $8$, og $1$ synker ned mod det *største* barn.

    ```
    Start:        [  5,  4,  3,  3,  4,  2,  3,  2,  1 ]   (størrelse 9)
    Tag rod 5 ud, flyt sidste 1 op i plads 1, størrelse -> 8:
    Efter:        [  1,  4,  3,  3,  4,  2,  3,  2 ]

    i=1: børn A[2]=4, A[3]=3.  størst=4 > 1: byt plads 1 & 2
                  [  4,  1,  3,  3,  4,  2,  3,  2 ]   1 -> plads 2
    i=2: børn A[4]=3, A[5]=4.  størst=4 > 1: byt plads 2 & 5
                  [  4,  4,  3,  3,  1,  2,  3,  2 ]   1 -> plads 5
    i=5: børn ville stå på plads 10,11, uden for størrelse 8: stop
    ```

    Slut: $A = [4,4,3,3,1,2,3,2]$, plads 9 tom. Svar (d).
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
    Max-heap, to Extract-Max i træk. Hver gang: roden ud, sidste element op i plads 1, synk ned mod det *største* barn (ved lige store børn er der intet krav om at bytte, kun hvis et barn er *strengt* større).

    *Første Extract-Max* — roden $A[1] = 1$ ud, sidste element $A[8] = 1$ op, størrelse $7$:

    ```
    Start:        [  1,  1,  0,  1,  0,  0,  0,  1 ]   (størrelse 8)
    Tag rod 1 ud, flyt sidste 1 op, størrelse -> 7:
    Efter:        [  1,  1,  0,  1,  0,  0,  0 ]

    i=1: børn A[2]=1, A[3]=0. størst=1, ikke > 1: stop (intet byt)
    ```

    Tilstand efter første: $[1,1,0,1,0,0,0]$, størrelse $7$.

    *Anden Extract-Max* — roden $A[1] = 1$ ud, sidste element $A[7] = 0$ op, størrelse $6$:

    ```
    Tag rod 1 ud, flyt sidste 0 op, størrelse -> 6:
    Efter:        [  0,  1,  0,  1,  0,  0 ]

    i=1: børn A[2]=1, A[3]=0. størst=1 > 0: byt plads 1 & 2
                  [  1,  0,  0,  1,  0,  0 ]   0 -> plads 2
    i=2: børn A[4]=1, A[5]=0. størst=1 > 0: byt plads 2 & 4
                  [  1,  1,  0,  0,  0,  0 ]   0 -> plads 4
    i=4: børn ville stå på plads 8,9, uden for størrelse 6: stop
    ```

    Slut: $A = [1,1,0,0,0,0]$, pladserne 7 og 8 tomme. Svar (c).
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
    Max-heap. Hvert tal lægges på første ledige plads og bobler op: byt med forælderen på $floor(i\/2)$ så længe det indsatte tal er *større*. Arrayet vokser ét felt ad gangen.

    ```
    indsæt 6:  på plads 1                              [ 6 ]
    indsæt 12: på plads 2; forælder(2)=1 A[1]=6 < 12: byt
               [ 12,  6 ]
    indsæt 13: på plads 3; forælder(3)=1 A[1]=12 < 13: byt
               [ 13,  6, 12 ]
    indsæt 4:  på plads 4; forælder(4)=2 A[2]=6 > 4: stop
               [ 13,  6, 12,  4 ]
    indsæt 8:  på plads 5; forælder(5)=2 A[2]=6 < 8: byt -> plads 2
               [ 13,  8, 12,  4,  6 ]
               forælder(2)=1 A[1]=13 > 8: stop
    indsæt 14: på plads 6; forælder(6)=3 A[3]=12 < 14: byt -> plads 3
               [ 13,  8, 14,  4,  6, 12 ]
               forælder(3)=1 A[1]=13 < 14: byt -> plads 1
               [ 14,  8, 13,  4,  6, 12 ]
    indsæt 5:  på plads 7; forælder(7)=3 A[3]=13 > 5: stop
               [ 14,  8, 13,  4,  6, 12,  5 ]
    ```

    Slut: $A = [14,8,13,4,6,12,5]$, svar (c). Bemærk, at resultatet ikke er sorteret — det afhænger af indsættelsesrækkefølgen.
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
    Build-Min-Heap kører Min-Heapify på de interne knuder fra $i = floor(n\/2) = 4$ ned til $1$. Min-Heapify$(i)$: find den mindste af knuden og dens børn ($2i$, $2i+1$); er et barn mindre, byt med det *mindste* barn og fortsæt rekursivt ned i den plads, nøglen landede på.

    ```
    Start:                [  5,  4,  2,  3,  7,  6,  1,  0 ]   n=8, heapify i=4,3,2,1

    i=4 (A[4]=3): barn A[8]=0. mindst=0 < 3: byt plads 4 & 8
                          [  5,  4,  2,  0,  7,  6,  1,  3 ]
                  plads 8 er blad: stop
    i=3 (A[3]=2): børn A[6]=6, A[7]=1. mindst=1 < 2: byt plads 3 & 7
                          [  5,  4,  1,  0,  7,  6,  2,  3 ]
                  plads 7 er blad: stop
    i=2 (A[2]=4): børn A[4]=0, A[5]=7. mindst=0 < 4: byt plads 2 & 4
                          [  5,  0,  1,  4,  7,  6,  2,  3 ]
                  rekursér plads 4 (A[4]=4): barn A[8]=3. mindst=3 < 4: byt plads 4 & 8
                          [  5,  0,  1,  3,  7,  6,  2,  4 ]
                  plads 8 er blad: stop
    i=1 (A[1]=5): børn A[2]=0, A[3]=1. mindst=0 < 5: byt plads 1 & 2
                          [  0,  5,  1,  3,  7,  6,  2,  4 ]
                  rekursér plads 2 (A[2]=5): børn A[4]=3, A[5]=7. mindst=3 < 5: byt plads 2 & 4
                          [  0,  3,  1,  5,  7,  6,  2,  4 ]
                  rekursér plads 4 (A[4]=5): barn A[8]=4. mindst=4 < 5: byt plads 4 & 8
                          [  0,  3,  1,  4,  7,  6,  2,  5 ]
                  plads 8 er blad: stop
    ```

    Slut: $A = [0,3,1,4,7,6,2,5]$. Nøglen $5$ er endt på position 8, svar (h).
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
    En knude i en min-heap skal være $<=$ alle sine efterkommere. Så en position med $k$ efterkommere kan kun holde en nøgle, hvis der findes mindst $k$ nøgler større end den. Nøglen $4$ har præcis én større nøgle ($5$), så $4$ kan kun stå et sted med $<= 1$ efterkommer.

    Træformen for $5$ elementer og hver positions antal efterkommere:

    ```
                1            plads 1: efterkommere = {2,3,4,5}  -> 4 stk
              /   \
            2       3        plads 2: efterkommere = {4,5}      -> 2 stk
           / \              plads 3: efterkommere = {}          -> 0 stk
          4   5              plads 4: blad                       -> 0 stk
                             plads 5: blad                       -> 0 stk
    ```

    Nøgler større end $4$: kun $5$, altså $1$ stk til rådighed.

    - Plads 1: roden skal være minimum ($1$), og $4 != 1$. Udelukket.
    - Plads 2: kræver $2$ større nøgler (til plads 4 og 5), men kun $1$ findes. Umuligt.
    - Plads 3: $0$ efterkommere, kravet $0 <= 1$ holder. Konkret: $[1,2,4,3,5]$. Gyldig.
    - Plads 4: blad, $0$ efterkommere. Konkret: $[1,2,3,4,5]$. Gyldig.
    - Plads 5: blad, $0$ efterkommere. Konkret: $[1,3,2,5,4]$. Gyldig.

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
    Samme regel: en position med $k$ efterkommere kræver $k$ nøgler større end målnøglen. Nøglen $9$ er næststørst, så kun $10$ er større — altså $1$ større nøgle til rådighed.

    Træformen for $6$ elementer og hver positions antal efterkommere:

    ```
                1                  plads 1: efterkommere = {2,3,4,5,6} -> 5 stk
              /   \
            2       3              plads 2: efterkommere = {4,5}        -> 2 stk
           / \     /              plads 3: efterkommer  = {6}          -> 1 stk
          4   5   6                plads 4: blad                         -> 0 stk
                                   plads 5: blad                         -> 0 stk
                                   plads 6: blad                         -> 0 stk
    ```

    Nøgler større end $9$: kun $10$, altså $1$ stk til rådighed.

    - Plads 1: roden skal være minimum ($5$), og $9 != 5$. Udelukket.
    - Plads 2: kræver $2$ større nøgler (plads 4 og 5), men kun $1$ findes. Umuligt.
    - Plads 3: $1$ efterkommer (plads 6); læg $10$ der, kravet $1 <= 1$ holder. Konkret: $[5,6,9,7,8,10]$. Gyldig.
    - Plads 4, 5, 6: blade, $0$ efterkommere, under en forælder $< 9$. Gyldige.

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
    Input: $n$ identiske elementer. Heapsort har to faser, og pointen er, at hvert sift-ned bliver billigt, når alle nøgler er ens.

    Et sift-ned sammenligner en forælder med sine børn og bytter kun, hvis et barn er *strengt* større. Med ens nøgler er forælder $=$ barn, så uligheden "barn $>$ forælder" er aldrig sand: sift-ned stopper efter $1$ niveau, altså $O(1)$ pr. kald — uanset $n$.

    + *Fase 1 — Build-Max-Heap:* kalder sift-ned på $floor(n\/2)$ knuder. Hver koster $O(1)$, så fasen koster
      #eq[$ floor(n\/2) dot O(1) = O(n). $]
    + *Fase 2 — $n-1$ gange Extract-Max:* hvert kald flytter sidste element op i roden og kører ét sift-ned. Med ens nøgler koster hvert sift-ned $O(1)$, så fasen koster
      #eq[$ (n-1) dot O(1) = O(n). $]

    Samlet: $O(n) + O(n) = O(n)$. (Til sammenligning er worst-case for vilkårligt input $O(n log n)$, fordi hvert sift-ned dér kan løbe op til $log n$ niveauer.) Svar (c).
  ],
)
