#import "../lib.typ": *

== Sortering og udvælgelse

At sortere er at lægge $n$ tal i rækkefølge. Der findes to slags algoritmer, og forskellen afgør alt til eksamen.

De *sammenligningsbaserede* (insertion, selection, merge, quick, heap, tree-sort) spørger "er $a$ mindre end $b$?". Værdiernes størrelse er ligegyldig; kun antallet tæller, så køretiden afhænger kun af $n$.

De *distributionsbaserede* (counting, radix) sammenligner aldrig. De bruger værdierne som indeks i et array. Det kommer under sammenligningsgrænsen, men køretiden afhænger nu af værdiernes størrelse.

Enhver sammenligningssortering bruger mindst $Omega(n log n)$ sammenligninger i værste fald:

#eq[$ "højde af decision tree" >= log(n!) = Omega(n log n) $]

Et decision tree har ét blad per rækkefølge, altså $n!$ blade, og et binært træ med $n!$ blade er mindst så højt. Vil du hurtigere ned, må du holde op med at sammenligne — det er netop, hvad counting og radix gør.

=== Sådan løser du den

Typisk spørgsmål: "sortér $n$ heltal i et givet interval — hvad er værste-falds-køretiden for algoritme X?"

#recipe(
  title: "Find køretiden for en sorteringsalgoritme",
  [Læs inputtet: antal elementer #swap[$n$] og værdiområde #swap[$[0, n^3)$] (for radix: antal cifre og cifferområde).],
  [Sammenligningsbaseret? Så er værdiområdet et vildspor; køretiden afhænger kun af $n$ — slå den op nedenfor.],
  [Distributionsbaseret (counting, radix)? Sæt værdiområdet ind i formlen og tag det dominerende led.],
)

#table(
  columns: (auto, auto, auto, 1fr),
  inset: 7pt,
  align: (left, center, center, left),
  stroke: 0.4pt + hair,
  table.header([*Algoritme*], [*Værste fald*], [*In-place*], [*Note*]),
  [Insertion sort], [$Theta(n^2)$], [ja], [Bedste fald $Theta(n)$ på sorteret input.],
  [Selection sort], [$Theta(n^2)$], [ja], [Altid $Theta(n^2)$, også på sorteret input.],
  [Merge sort], [$Theta(n log n)$], [nej], [Altid $Theta(n log n)$. Bruger et ekstra array.],
  [Quicksort], [$Theta(n^2)$], [ja], [Typisk $Theta(n log n)$; værst på sorteret input.],
  [Heapsort], [$Theta(n log n)$], [ja], [Build-heap $Theta(n)$, derefter $n$ heapify.],
  [Counting sort], [$Theta(n + k)$], [nej], [$k$ er værdiområdet. Stabil.],
  [Radix sort], [$Theta(d(n + k))$], [nej], [$d$ gennemløb af counting sort, $k$ er cifferområdet.],
)

Counting sort tæller hver værdis forekomster, summerer tællingerne til en prefix-sum og placerer elementerne bagfra, så ens værdier holder rækkefølge (stabilitet):

```
COUNTING-SORT(A, n, k)
  for i = 0 to k: C[i] = 0
  for j = 1 to n: C[A[j]] += 1        // C[i] = antal af værdien i
  for i = 1 to k: C[i] += C[i-1]      // C[i] = antal værdier <= i
  for j = n downto 1:                 // bagfra => stabil
    B[C[A[j]]] = A[j]
    C[A[j]] -= 1
  return B
```

Radix sort kører counting sort per ciffer, fra mindst til mest betydende. Hvert af de $d$ gennemløb koster $Theta(n + k)$ med $k$ lig cifferområdet:

#eq[$ T(n) = Theta(d(n + k)) $]

Quicksort vælger en pivot, deler arrayet i mindre og større og sorterer hver del. CLRS bruger Lomuto-partition med sidste element som pivot. Bagefter sidder pivoten på sin endelige plads med mindre-eller-lig til venstre, større til højre:

```
PARTITION(A, p, r)
  x = A[r]; i = p - 1
  for j = p to r - 1:
    if A[j] <= x: i += 1; swap A[i], A[j]
  swap A[i+1], A[r]
  return i + 1
```

#note(title: [Værdiområde])[Værdiområdet i opgaveteksten er ofte med for at narre dig. For en sammenligningssortering er det støj: quicksort er $Theta(n^2)$ i værste fald, uanset om tallene ligger i $[0, n)$ eller $[0, n^9)$. Det betyder kun noget for counting og radix.]

#trap(title: [Counting sort])[Counting sort er ikke altid lineær. Med $k = #swap[$n^2$]$ koster den $Theta(n + n^2) = Theta(n^2)$. Den er kun $O(n)$, når $k = O(n)$. Deler du heltallet op i cifre med radix sort, holdes cifferområdet lille, og du slipper med $Theta(n)$.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Sortering: værste-falds-køretid for CountingSort],
  source: "MCQ juni 2023, Spm. 27",
  prompt: [Vi betragter sortering af #swap[$n$] heltal med værdier i intervallet #swap[$[0, n^3)$]. Hvad er værste-falds-køretiden for CountingSort på dette input?],
  options: (
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [(d) $Theta(n^3)$.],
  blueprint: [
    CountingSort koster altid $Theta(n + k)$, uanset hvad tallene er. Du skal bare finde de to størrelser og se hvilken der vinder.

    + *Find $n$.* Tæl elementerne der skal sorteres: #swap[$n$].
    + *Find $k$.* Læs værdiområdet og sæt $k$ til den øvre grænse: #swap[$k = n^3$].
    + *Læg dem sammen.* Skriv $Theta(n + k)$ op med dine egne tal.
    + *Behold det hurtigste led.* Det led der vokser hurtigst, slår det andet ihjel. Det er svaret.
  ],
  worked: [
    Inputtet er $n$ elementer i $[0, #swap[$n^3$])$, så $k = n^3$.

    + Sæt ind i formlen: $Theta(n + k) = Theta(n + n^3)$.
    + $n^3$ vokser hurtigere end $n$, så $n$ falder væk.

    Svar: $Theta(n^3)$.
  ],
)

#qcard(
  tag: [Sortering: værste-falds-køretid for RadixSort],
  source: "MCQ juni 2023, Spm. 28",
  prompt: [Vi betragter sortering af #swap[$n$] heltal med værdier i intervallet #swap[$[0, n^3)$]. Hvad er værste-falds-køretiden for RadixSort, når heltallene behandles som tre cifre med værdier i intervallet $[0, n)$?],
  options: (
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [(a) $Theta(n)$.],
  blueprint: [
    RadixSort er counting sort kørt én gang per ciffer. Du tæller cifrene og ganger med prisen for ét gennemløb.

    + *Tæl cifrene.* Hvor mange cifre deler du tallene op i: #swap[$d$].
    + *Find cifferområdet $k$.* Hvor store kan de enkelte cifre være: #swap[$k = n$].
    + *Pris per gennemløb.* Hvert ciffer er en counting sort, altså $Theta(n + k)$.
    + *Gang med $d$.* Samlet $Theta(d(n + k))$. Er $d$ en konstant, falder den væk i $Theta$.
  ],
  worked: [
    Her er $d = 3$ cifre, hvert i $[0, #swap[$n$])$, så $k = n$.

    + Ét gennemløb koster $Theta(n + n) = Theta(n)$.
    + Tre gennemløb giver $3 dot Theta(n)$.
    + $3$ er en konstant og forsvinder i $Theta$.

    Svar: $Theta(n)$.
  ],
)

#qcard(
  tag: [Sortering: værste-falds-køretid for QuickSort],
  source: "MCQ juni 2023, Spm. 29",
  prompt: [Vi betragter sortering af #swap[$n$] heltal med værdier i intervallet #swap[$[0, n^3)$]. Hvad er værste-falds-køretiden for QuickSort på dette input?],
  options: (
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [(c) $Theta(n^2)$.],
  blueprint: [
    Spørg først om algoritmen er sammenligningsbaseret. Er den det, er værdiområdet i opgaven ren støj, og du ser kun på $n$.

    + *Sammenligningsbaseret?* QuickSort, merge, heap og insertion sammenligner alle. Er svaret ja, så ignorer værdiområdet #swap[$[0, n^3)$].
    + *Find værste fald.* For QuickSort er det maksimalt skæve partitioner: den ene del har $n-1$ elementer, den anden er tom.
    + *Skriv rekursionen.* $T(n) = T(n-1) + Theta(n)$.
    + *Løs den.* Summen $1 + 2 + ... + n$ giver svaret.
  ],
  worked: [
    QuickSort sammenligner, så $[0, #swap[$n^3$])$ er ligegyldigt.

    + Værste fald: pivoten ender yderst hver gang, så partitionerne bliver $n-1$ og $0$.
    + Det giver rekursionen $T(n) = T(n-1) + Theta(n)$.
    + Den summer til $sum_(i=1)^n i = Theta(n^2)$.

    Svar: $Theta(n^2)$.
  ],
)

#qcard(
  tag: [Sortering: hvilke er Θ(n²) i værste fald?],
  source: "MCQ juni 2019, Spm. 27",
  prompt: [Vi betragter sortering af #swap[$n$] heltal med værdier i intervallet #swap[$[0, n^2)$]. Ved TreeSort menes algoritmen, der indsætter tallene ét ad gangen i et søgetræ og derefter laver et inorder-gennemløb. Hvilke af algoritmerne nedenfor har værste-falds-køretid $Theta(n^2)$? (Et eller flere svar.)],
  options: (
    [CountingSort],
    [RadixSort, hvor heltallene behandles som to cifre med værdier i intervallet $[0, n)$],
    [MergeSort],
    [TreeSort, hvor søgetræet er et rød-sort træ],
    [TreeSort, hvor søgetræet er et ubalanceret søgetræ],
    [QuickSort],
    [InsertionSort],
  ),
  answer: [(a) CountingSort, (e) ubalanceret TreeSort, (f) QuickSort og (g) InsertionSort.],
  blueprint: [
    Listen blander sammenligningssorteringer og distributionssorteringer. Gå hver linje igennem og slå dens værste fald op.

    + *Del op.* Marker hver algoritme som sammenligningsbaseret eller distributionsbaseret.
    + *Distributionssorteringerne.* Counting sort bliver $Theta(n^2)$, hvis #swap[$k = n^2$] eller større. Radix med få cifre i base $n$ er lineær.
    + *De garanterede.* Merge sort og balancerede træer (rød-sort) er altid $Theta(n log n)$, aldrig $n^2$.
    + *De ustabile.* QuickSort, insertion og et ubalanceret søgetræ rammer $Theta(n^2)$ på det rigtige input, typisk det sorterede.
    + *Saml svaret.* Alle med $Theta(n^2)$ i værste fald.
  ],
  worked: [
    Her er $k = #swap[$n^2$]$. Jeg går listen igennem.

    - CountingSort: $k = n^2$ dominerer, så $Theta(n^2)$. Ja.
    - RadixSort, to cifre i base $n$: to gennemløb à $Theta(n)$. Nej.
    - MergeSort: altid $Theta(n log n)$. Nej.
    - Rød-sort TreeSort: $n$ indsættelser à $O(log n)$, altså $Theta(n log n)$. Nej.
    - Ubalanceret TreeSort: sorteret input degenererer til en sti, og indsættelse $i$ koster $i$. Summen $sum_(i=1)^n i = Theta(n^2)$. Ja.
    - QuickSort: $Theta(n^2)$. Ja.
    - InsertionSort: $Theta(n^2)$. Ja.

    Svar: CountingSort, ubalanceret TreeSort, QuickSort og InsertionSort.
  ],
)

#qcard(
  tag: [QuickSort: kør PARTITION i hånden],
  source: "MCQ juni 2019, Spm. 11",
  prompt: [Kør PARTITION($A$, 1, 7) på arrayet $A = #swap[$[6, 2, 4, 5, 1, 7, 3]$]$ (indeks 1..7). Hvilken mulighed viser $A$ bagefter? (Standard CLRS Lomuto-partition; pivot er sidste element $A[7] = 3$.)],
  options: (
    [$A = [2, 1, 3, 5, 6, 7, 4]$],
    [$A = [2, 1, 3, 6, 4, 5, 7]$],
    [$A = [1, 2, 3, 4, 5, 6, 7]$],
    [$A = [3, 2, 1, 4, 5, 6, 7]$],
    [$A = [1, 2, 3, 7, 6, 5, 4]$],
    [$A = [2, 1, 4, 5, 6, 7, 3]$],
  ),
  answer: [(a) $A = [2, 1, 3, 5, 6, 7, 4]$.],
  blueprint: [
    Lomuto-partition skubber alt der er mindre end eller lig pivoten om til venstre. Du holder styr på to indeks, $i$ og $j$, og swapper undervejs.

    + *Sæt pivot.* Pivoten er sidste element: #swap[$x = A[r]$]. Sæt $i = p - 1$.
    + *Løb $j$ fra venstre.* Er $A[j] > x$, så gør ingenting.
    + *Ved et lille element.* Er $A[j] <= x$, tæl $i$ op med $1$ og swap $A[i]$ med $A[j]$. Skriv arrayet ned hver gang.
    + *Til sidst.* Swap $A[i+1]$ med pivoten $A[r]$. Nu står pivoten på sin endelige plads.
  ],
  worked: [
    Pivot $x = A[7] = 3$, start $i = 0$. Array: #swap[$[6, 2, 4, 5, 1, 7, 3]$].

    - $j = 1$: $6 > 3$, spring over.
    - $j = 2$: $2 <= 3$, $i = 1$, swap $A[1]$ og $A[2]$ #sym.arrow.r $[2, 6, 4, 5, 1, 7, 3]$.
    - $j = 3$: $4 > 3$, spring over.
    - $j = 4$: $5 > 3$, spring over.
    - $j = 5$: $1 <= 3$, $i = 2$, swap $A[2]$ og $A[5]$ #sym.arrow.r $[2, 1, 4, 5, 6, 7, 3]$.
    - $j = 6$: $7 > 3$, spring over.

    Til sidst swap $A[i+1] = A[3]$ med $A[7]$ #sym.arrow.r $[2, 1, 3, 5, 6, 7, 4]$.

    Svar: $A = [2, 1, 3, 5, 6, 7, 4]$.
  ],
)

#qcard(
  tag: [CountingSort: trace tælle-arrayet C],
  source: "MCQ juni 2023, Spm. 11",
  prompt: [Et array af ni heltal med værdier $0..6$: $A = #swap[$[2, 0, 6, 2, 3, 5, 5, 1, 2]$]$ (indeks 1..9). Kør COUNTING-SORT($A$, 9, 6) med et array $C$ med syv pladser (0..6). Hvad er summen af de syv heltal i $C$ ved terminering?],
  options: (
    [$0$],
    [$6$],
    [$9$],
    [$22$],
    [$28$],
    [$37$],
  ),
  answer: [(f) $37$.],
  blueprint: [
    Fælden er at $C$ ikke ender med de rå tællinger. CLRS overskriver $C$ med prefix-summer, og det er dem du skal regne på.

    + *Tæl forekomster.* Løb arrayet igennem og tæl hver værdi. Det giver det rå $C$.
    + *Lav prefix-summer.* Sæt $C[i] "+=" C[i-1]$ fra venstre. Nu er $C[i]$ antallet af værdier $<= i$.
    + *Læs svaret af det rigtige $C$.* Det opgaven spørger om (her summen) regnes på det kumulative $C$, ikke det rå.
  ],
  worked: [
    Array: #swap[$[2, 0, 6, 2, 3, 5, 5, 1, 2]$], værdier $0..6$.

    + Rå tællinger: $C = [1, 1, 3, 1, 0, 2, 1]$, sum $9$.
    + Prefix-summer, $C[i] "+=" C[i-1]$: $C = [1, 2, 5, 6, 6, 8, 9]$.
    + Summen er $1 + 2 + 5 + 6 + 6 + 8 + 9 = 37$.

    Svar: $37$.
  ],
)
