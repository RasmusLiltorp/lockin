#import "../lib.typ": *

== Prioritetskøer og heaps

En prioritetskø trækker hele tiden den vigtigste nøgle ud — den mindste i en min-kø, den største i en max-kø. Den implementeres typisk som en binær heap.

En binær heap er et komplet binært træ gemt i et array. "Komplet" betyder, at træet fyldes lag for lag fra venstre uden huller. Hver forælder dominerer sine børn: i en min-heap er forælderen aldrig større, i en max-heap aldrig mindre.

Træet ligger i et 1-indekseret array $A[1..n]$, og indekset alene giver børn og forælder:

#eq[$ "forælder"(i) = floor(i\/2), quad "venstre"(i) = 2i, quad "højre"(i) = 2i + 1 $]

Til eksamen skal du afgøre om et array er en heap, og trace `Extract`, `Increase-Key` og `Insert` skridt for skridt.

=== Sådan løser du den

#recipe(
  title: "Tjek om et array er en heap",
  [Tjek for huller: står der en værdi efter en tom plads, er arrayet ikke en gyldig heap.],
  [Løb de interne knuder igennem, $i = 1 .. floor(n\/2)$ — kun de har børn.],
  [Tjek begge børn for hver knude. Min-heap kræver],
  [#eq[$ A[i] <= A[2i] quad "og" quad A[i] <= A[2i+1], $] max-heap kræver $A[i] >=$ begge børn. Ens nøgler er tilladt.],
  [Én overtrådt ulighed er nok til at forkaste arrayet.],
)

#recipe(
  title: "Extract-Min / Extract-Max",
  [Gem roden $A[1]$ — det er værdien, du returnerer.],
  [Flyt sidste element $A[n]$ op i roden, og skrump heapen med én plads.],
  [Sift roden ned: i en min-heap byt med det #swap[mindste] barn hvis barnet er mindre; i en max-heap byt med det #swap[største] barn hvis det er større.],
  [Gentag fra den nye plads, til intet barn bryder ordenen eller knuden ingen børn har. Aflæs arrayet.],
)

#recipe(
  title: "Insert / Increase-Key (sift op)",
  [Insert: læg den nye nøgle på sidste plads — det holder træet komplet.],
  [Increase-Key$(A, i, k)$: sæt $A[i] = k$, i en max-heap kun hvis $k$ er større end den gamle værdi.],
  [Sift op: byt med forælderen så længe knuden slår den. For en max-heap er betingelsen],
  [#eq[$ A[i] > A[floor(i\/2)]. $] Stop ved roden eller når forælderen igen dominerer.],
)

#note[Build-Heap er $O(n)$, ikke $O(n log n)$. Den kalder sift-ned nedefra og op over arrayets nederste halvdel. At indsætte $n$ nøgler én ad gangen ville koste $O(n log n)$.]

#trap[Sift ned bruger børnene ($2i$ og $2i+1$), sift op bruger forælderen ($floor(i\/2)$). Extract sifter ned; Insert og Increase-Key sifter op. At bytte de to retninger om er den klassiske trace-fejl. Roden er min i en min-heap og max i en max-heap, aldrig begge.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
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
  source: "MCQ juni 2023, Spm. 7",
  prompt: [Udfør Extract-Min på min-heapen $A = #swap[$[3,5,6,10,11,8,7,18,16,15]$]$ (1-indekseret, positioner $1..10$). Hvilken position i $A$ ender $#swap[$15$]$ på bagefter?],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$8$], [$9$]),
  answer: [(d) position 4.],
  worked: [Fjern roden $3$, flyt sidste element $15$ op, størrelse $9$: $[15,5,6,10,11,8,7,18,16]$. Sift ned fra idx 1: børn $5,6$, byt med $5$ — $15$ til idx 2. Idx 2: børn $10,11$, byt med $10$ — $15$ til idx 4. Børn ved idx 8 ($18$) og 9 ($16$) er begge $> 15$, stop. Slut $[5,10,6,15,11,8,7,18,16]$: $15$ står på position 4.],
)

#qcard(
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
  source: "MCQ juni 2019, Spm. 28",
  prompt: [Hvad er worst-case køretiden for Heapsort, når den køres på $#swap[$n$]$ identiske elementer?],
  options: ([$O(1)$], [$O(log n)$], [$O(n)$], [$O(n log n)$], [$O(n^2)$]),
  answer: [(c) $O(n)$.],
  worked: [Heapsort er Build-Max-Heap ($O(n)$) og derefter $n-1$ Extract-Max med sift-ned. Når alle nøgler er ens, er en forælder aldrig strengt mindre end et barn, så hvert sift-ned stopper efter et par sammenligninger — $O(1)$ per kald. Build: $~n\/2$ kald, Extract: $n-1$ kald, hver $O(1)$. I alt $O(n)$.],
)
