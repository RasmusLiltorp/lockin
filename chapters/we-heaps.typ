#import "../lib.typ": *

=== Binære hobe (heaps)

Skriftlige opgaver om binære hobe falder i tre slags: kør `Build-Max-Heap` på et array, afgør om et array opfylder hob-egenskaben (heap property), og kør et `Heap-Extract-Min/Max`-trace. Alle bruger 1-indeksering (1-indexing), hvor node $i$ har børn $2i$ og $2i+1$ og forælder $floor(i\/2)$.

#qcard(
  tag: [Hob: Build-Max-Heap],
  source: "jun 2016, Problem 3 (7%)",
  prompt: [
    Kør `Build-Max-Heap` på arrayet #swap[$A = [2,1,5,4,8,6,7,9,3]$] (1-indekseret, $n = 9$). Angiv arrayet bagefter.
  ],
  answer: [$A = [9,8,7,4,2,6,5,1,3]$.],
  blueprint: [
    `Build-Max-Heap` bygger en max-hob (max-heap) nedefra og op ved at `Max-Heapify` hver intern node.

    + Indeks over $floor(n\/2)$ er blade — spring dem over. Start ved $i = floor(n\/2)$ og tæl ned til $1$.
    + For hvert $i$: kald `Max-Heapify(A, i)`. Sammenlign $A[i]$ med børnene $A[2i]$ og $A[2i+1]$.
    + Er et barn større, byt med det *største* barn, og følg elementet videre ned (rekursér i den undertræ-rod) til det er $>=$ begge børn eller bliver blad.
    + Når $i = 1$ er kørt igennem, er #swap[arrayet] en gyldig max-hob.
  ],
  worked: [
    $n = 9$, så start ved $i = 4$ og tæl ned.

    + $i = 4$: $A[4] = 4$, børn $A[8] = 9, A[9] = 3$. Største barn $9$ → byt → $A[4] = 9, A[8] = 4$. Blad, stop.
    + $i = 3$: $A[3] = 5$, børn $6, 7$. Største $7$ → byt → $A[3] = 7, A[7] = 5$. Blad, stop.
    + $i = 2$: $A[2] = 1$, børn $A[4] = 9, A[5] = 8$. Største $9$ → byt → $A[2] = 9, A[4] = 1$. Rekursér ved $4$: $A[4] = 1$, barn $A[8] = 4$ → byt → $A[4] = 4, A[8] = 1$.
    + $i = 1$: $A[1] = 2$, børn $A[2] = 9, A[3] = 7$. Største $9$ → byt → $A[1] = 9, A[2] = 2$. Rekursér ved $2$: børn $A[4] = 4, A[5] = 8$ → største $8$ → byt → $A[2] = 8, A[5] = 2$. Ved $5$: blad, stop.

    Resultat: $A = [9,8,7,4,2,6,5,1,3]$.
  ],
)

#qcard(
  tag: [Hob: Build-Max-Heap],
  source: "DM507 juni 2014, Opg. 3 (6%)",
  prompt: [
    Arrayet #swap[$A = [5,4,3,2,1,10,9,8,7,6]$] (1-indekseret, $n = 10$). Angiv arrayet efter `Build-Max-Heap`.
  ],
  answer: [$A = [10,8,9,7,6,3,5,2,4,1]$.],
  blueprint: [
    Samme skabelon som ovenfor: `Max-Heapify` hver intern node fra $i = floor(n\/2)$ ned til $1$.

    + Start ved $i = floor(n\/2)$, slut ved $1$.
    + `Max-Heapify(A, i)`: byt #swap[$A[i]$] ned med det største barn så længe det er mindre end et barn.
    + Tjek til sidst at hver forælder $>=$ begge børn.
  ],
  worked: [
    $n = 10$, så de interne noder er $i = 5, 4, ..., 1$.

    + $i = 5$: $A[5] = 1$, barn $A[10] = 6$ → byt → $A[5] = 6, A[10] = 1$.
    + $i = 4$: $A[4] = 2$, børn $A[8] = 8, A[9] = 7$ → største $8$ → byt → $A[4] = 8, A[8] = 2$.
    + $i = 3$: $A[3] = 3$, børn $A[6] = 10, A[7] = 9$ → største $10$ → byt → $A[3] = 10, A[6] = 3$.
    + $i = 2$: $A[2] = 4$, børn $A[4] = 8, A[5] = 6$ → største $8$ → byt → $A[2] = 8, A[4] = 4$. Rekursér ved $4$: børn $A[8] = 2, A[9] = 7$ → største $7$ → byt → $A[4] = 7, A[9] = 4$.
    + $i = 1$: $A[1] = 5$, børn $A[2] = 8, A[3] = 10$ → største $10$ → byt → $A[1] = 10, A[3] = 5$. Rekursér ved $3$: børn $A[6] = 3, A[7] = 9$ → største $9$ → byt → $A[3] = 9, A[7] = 5$.

    Resultat: $A = [10,8,9,7,6,3,5,2,4,1]$. Tjek: rod $10 >= 8, 9$; node $8 >= 7, 6$; node $9 >= 3, 5$.
  ],
)

#qcard(
  tag: [Hob: genkend hob-egenskab],
  source: "DM507 juni 2012, Opg. 2a (5%)",
  prompt: [
    En binær min-hob (min-heap) i $A[1..n]$ har børn $2i, 2i+1$ til node $i$ og opfylder $A["forælder"] <= A["barn"]$ for alle noder. Afgør hvilke af følgende der er min-hobe:
    #swap[
      $A_1 = [7,4,9,2,6,8,10,1,3,5]$, \
      $A_2 = [1,2,3,4,5,6,7,8,9,10]$, \
      $A_3 = [1,2,3,4,1,2,3,4,5,6]$, \
      $A_4 = [1,1,1,1,1,1,1,1,1,1]$.
    ]
  ],
  answer: [$A_2$ og $A_4$ er min-hobe; $A_1$ og $A_3$ er ikke.],
  blueprint: [
    Tjek hob-egenskaben node for node — ét modeksempel er nok til at forkaste.

    + For hvert $i$ fra $1$ til $floor(n\/2)$: tjek $A[i] <= A[2i]$ og (hvis $2i+1 <= n$) $A[i] <= A[2i+1]$.
    + Finder du ét par forælder/barn med #swap[$A[i] > A["barn"]$], er det *ikke* en hob — stop.
    + Holder uligheden for alle interne noder, er det en min-hob.
    + Genveje: et sorteret stigende array er altid en min-hob; et array af ens værdier er altid en min-hob.
  ],
  worked: [
    + $A_1$: $A[1] = 7 > A[2] = 4$. Bryder med det samme → ikke en hob.
    + $A_2$: sorteret stigende ⇒ hver forælder $<=$ begge børn → min-hob.
    + $A_3$: $A[2] = 2 > A[5] = 1$ (og $A[3] = 3 > A[6] = 2$) → ikke en hob.
    + $A_4$: alle ens ⇒ $A[i] <= A["barn"]$ overalt → min-hob.

    Svar: $A_2$ og $A_4$.
  ],
)

#qcard(
  tag: [Hob: Heap-Extract-Min/Max],
  source: "DM507 juni 2012, Opg. 2b (5%)",
  prompt: [
    Min-hoben #swap[$A_5 = [1,2,5,3,7,9,6,8,4,10]$]. Kør én `Heap-Extract-Min`. Angiv arrayet bagefter og den udtrukne værdi.
  ],
  answer: [Udtrukket minimum $= 1$; $A_5 = [2,3,5,4,7,9,6,8,10]$ (størrelse $9$).],
  blueprint: [
    `Heap-Extract-Min` fjerner roden og genopretter hob-egenskaben med en sift-down.

    + Gem $min = A[1]$ (returværdien).
    + Flyt det sidste element $A["størrelse"]$ op i roden, og formindsk størrelsen med $1$.
    + `Min-Heapify(1)`: sammenlign noden med dens børn, byt med det *mindste* barn hvis et barn er mindre, og følg elementet ned, til det er $<=$ begge børn eller bliver blad.
    + Arrayet efter sift-down er den nye hob.
  ],
  worked: [
    + Gem $min = A[1] = 1$.
    + Flyt sidste element $A[10] = 10$ til roden, størrelse $-> 9$: $[10,2,5,3,7,9,6,8,4]$.
    + `Min-Heapify(1)`: rod $10$ vs børn $2, 5$ → mindst $2$ → byt → $[2,10,5,3,7,9,6,8,4]$.
    + $10$ ved idx $2$, børn $A[4] = 3, A[5] = 7$ → byt med $3$ → $[2,3,5,10,7,9,6,8,4]$.
    + $10$ ved idx $4$, børn $A[8] = 8, A[9] = 4$ → byt med $4$ → $[2,3,5,4,7,9,6,8,10]$.
    + $10$ ved idx $8$, ingen børn → stop.

    Svar: udtrukket $1$, hob $= [2,3,5,4,7,9,6,8,10]$.
  ],
)

#qcard(
  tag: [Hob: Heap-Extract-Min/Max],
  source: "DM507 juni 2009, Opg. 1a (7%)",
  prompt: [
    Kør `Heap-Extract-Max` på max-hoben #swap[$A = [10,7,6,5,4,2,3,1,2,3,1,1]$] (1-indekseret, $n = 12$). Vis hvert skridt; angiv den nye hob.
  ],
  answer: [Udtrukket maksimum $= 10$; ny hob $= [7,5,6,2,4,2,3,1,1,3,1]$ (størrelse $11$).],
  blueprint: [
    `Heap-Extract-Max` er spejlbilledet af Extract-Min: fjern roden, løft sidste element op, `Max-Heapify`.

    + Gem $max = A[1]$ (returværdien).
    + Flyt det sidste element $A["størrelse"]$ op i roden, og formindsk størrelsen med $1$.
    + `Max-Heapify(1)`: byt noden ned med det *største* barn så længe et barn er større; følg elementet ned til det er $>=$ begge børn eller bliver blad.
    + Arrayet efter sift-down er den nye hob.
  ],
  worked: [
    + Gem $max = A[1] = 10$.
    + Flyt sidste element $A[12] = 1$ til roden, størrelse $-> 11$: $[1,7,6,5,4,2,3,1,2,3,1]$.
    + `Max-Heapify(1)`: rod $1$ vs børn $7$ (idx $2$), $6$ (idx $3$) → største $7$ → byt idx $1 <-> 2$.
    + $1$ ved idx $2$ vs børn $5$ (idx $4$), $4$ (idx $5$) → største $5$ → byt idx $2 <-> 4$.
    + $1$ ved idx $4$ vs børn $1$ (idx $8$), $2$ (idx $9$) → største $2$ → byt idx $4 <-> 9$.
    + idx $9$ har ingen børn → stop.

    Svar: udtrukket $10$, ny hob $= [7,5,6,2,4,2,3,1,1,3,1]$.
  ],
)

#qcard(
  tag: [Hob: Heap-Extract-Min/Max],
  source: "DM507 juni 2015, Opg. 3 (7%)",
  prompt: [
    Max-hob #swap[$A = [18,9,16,4,8,12,13,1,2]$] (1-indekseret). Kør først `Heap-Increase-Key(A, 9, 15)`, derefter `Heap-Extract-Max(A)`. Angiv arrayet efter hver operation.
  ],
  answer: [Efter Increase-Key: $A = [18,15,16,9,8,12,13,1,4]$. Efter Extract-Max (udtrukket $18$): $A = [16,15,13,9,8,12,4,1]$.],
  blueprint: [
    To operationer i rækkefølge: hæv en nøgle med sift-up, træk så maks ud med sift-down.

    + `Increase-Key(A, i, key)`: sæt $A[i] = "key"$; sift op — mens $i > 1$ og $A["forælder"(i)] < A[i]$, byt med forælderen og gå op. Her er $"forælder"(i) = floor(i\/2)$.
    + `Extract-Max`: gem $A[1]$; flyt sidste element op i roden; formindsk størrelsen; `Max-Heapify(1)` — byt roden ned med det største barn til hob-egenskaben holder.
  ],
  worked: [
    *Increase-Key(A, 9, 15).* Position $9$ holder $2$; sæt til $15$. Sift op: $"forælder"(9) = 4$ holder $4$, $15 > 4$ → byt. Ved pos $4$; $"forælder"(4) = 2$ holder $9$, $15 > 9$ → byt. Ved pos $2$; $"forælder"(2) = 1$ holder $18$, $15 < 18$ → stop. \
    Resultat: $[18,15,16,9,8,12,13,1,4]$.

    *Extract-Max* returnerer $18$. Flyt sidste element $4$ til roden → $[4,15,16,9,8,12,13,1]$, størrelse $8$. `Max-Heapify(1)`: børn $15, 16$ → største $16$ → byt → $[16,15,4,9,8,12,13,1]$. Ved pos $3$: børn $12, 13$ → største $13$ → byt → $[16,15,13,9,8,12,4,1]$. Færdig. \
    Resultat: $[16,15,13,9,8,12,4,1]$.
  ],
)

#qcard(
  tag: [Hob: Insert (sift-up)],
  source: "DM02 jan 2006, Opg. 1b (6%)",
  prompt: [
    Min-hob (mindst i roden) gemt som array efter niveauer: #swap[$A = [1,3,5,4,10,13,7,6,17]$]. Indsæt prioritet #swap[$2$]. Angiv hoben bagefter.
  ],
  answer: [$A = [1,2,5,4,3,13,7,6,17,10]$. Her sidder $2$ som venstre barn til roden, $3$ rykker ned som venstre barn til $2$, og $10$ bliver venstre barn til $3$.],
  blueprint: [
    `Insert` i en binær min-hob: hæng den nye nøgle på som nyt blad, og sift op, til hob-egenskaben holder.

    + Læg den nye nøgle i næste ledige plads — sidst i arrayet, indeks $n+1$.
    + Lad $i$ være dens 1-indekserede position. Mens $i > 1$ og $A["forælder"(i)] > A[i]$: byt med forælderen og sæt $i = "forælder"(i)$. Her er $"forælder"(i) = floor(i\/2)$.
    + Stop ved roden, eller når forælderen ikke længere er større.
  ],
  worked: [
    Arrayet har $9$ elementer; det nye $2$ ryger på plads $10$.

    + $i = 10$: $"forælder"(10) = 5$, $A[5] = 10 > 2$ → byt → $A[5] = 2, A[10] = 10$.
    + $i = 5$: $"forælder"(5) = 2$, $A[2] = 3 > 2$ → byt → $A[2] = 2, A[5] = 3$.
    + $i = 2$: $"forælder"(2) = 1$, $A[1] = 1 < 2$ → stop.

    Resultat: $A = [1,2,5,4,3,13,7,6,17,10]$.
  ],
)

#qcard(
  tag: [Hob: Insert (sift-up)],
  source: "DM507 jan 2008, Opg. 1b (7%)",
  prompt: [
    Indsæt nøglen #swap[$9$] i max-hoben #swap[$A = [10,8,6,3,7,4,5,1,2]$]. Vis arrayet før hver iteration af `Max-Heap-Insert`s while-løkke (sift-up). Angiv den endelige hob.
  ],
  answer: [$A = [10,9,6,3,8,4,5,1,2,7]$.],
  blueprint: [
    `Max-Heap-Insert`: hæng nøglen på som nyt blad, og sift op, mens forælderen er mindre.

    + Læg den nye nøgle sidst i arrayet (et nyt blad), indeks $i = n+1$.
    + Mens $i > 1$ og $A["forælder"(i)] < A[i]$: byt med forælderen og sæt $i = "forælder"(i)$. Her er $"forælder"(i) = floor(i\/2)$.
    + Stop ved roden, eller når forælderen ikke længere er mindre.
  ],
  worked: [
    Hæng $9$ på plads $10$: $[10,8,6,3,7,4,5,1,2,9]$.

    + Før iteration 1 ($i = 10$): $[10,8,6,3,7,4,5,1,2,9]$. $"forælder"(10) = 5$, $A[5] = 7 < 9$ → byt.
    + Før iteration 2 ($i = 5$): $[10,8,6,3,9,4,5,1,2,7]$. $"forælder"(5) = 2$, $A[2] = 8 < 9$ → byt.
    + Før iteration 3 ($i = 2$): $[10,9,6,3,8,4,5,1,2,7]$. $"forælder"(2) = 1$, $A[1] = 10 > 9$ → stop.

    Endelig hob: $A = [10,9,6,3,8,4,5,1,2,7]$.
  ],
)

#qcard(
  tag: [Hob: Insert (sift-up)],
  source: "DM507 juni 2013, Opg. 3a (4%)",
  prompt: [
    Indsæt først #swap[$1$], derefter #swap[$2$], i min-hoben #swap[$A = [2,4,5,8,7,6,6,9]$] (1-indekseret). Angiv hoben efter den anden indsættelse (venstre mod højre).
  ],
  answer: [$A = [1,2,5,4,2,6,6,9,8,7]$.],
  blueprint: [
    `Insert` i en binær min-hob: hæng nøglen på som nyt blad, og sift op, mens den er mindre end forælderen. 1-indekseret er $"forælder"(i) = floor(i\/2)$.

    + Læg nøglen på indeks $n+1$.
    + Mens $i > 1$ og $A["forælder"(i)] > A[i]$: byt med forælderen og gå op.
    + Stop ved roden, eller når forælderen ikke længere er større. Kør samme procedure for hver indsættelse.
  ],
  worked: [
    Start: $[2,4,5,8,7,6,6,9]$ ($n = 8$).

    *Indsæt $1$* på plads $9$. $"forælder"(9) = 4$, $A[4] = 8 > 1$ → byt. $"forælder"(4) = 2$, $A[2] = 4 > 1$ → byt. $"forælder"(2) = 1$, $A[1] = 2 > 1$ → byt → rod. \
    Efter indsæt $1$: $[1,2,5,4,7,6,6,9,8]$ ($n = 9$).

    *Indsæt $2$* på plads $10$. $"forælder"(10) = 5$, $A[5] = 7 > 2$ → byt. $"forælder"(5) = 2$, $A[2] = 2$, $2 < 2$ er falsk → stop. \
    Efter indsæt $2$: $[1,2,5,4,2,6,6,9,8,7]$.
  ],
)
