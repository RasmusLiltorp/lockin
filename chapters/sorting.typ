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

#note[Værdiområdet i opgaveteksten er ofte med for at narre dig. For en sammenligningssortering er det støj: quicksort er $Theta(n^2)$ i værste fald, uanset om tallene ligger i $[0, n)$ eller $[0, n^9)$. Det betyder kun noget for counting og radix.]

#trap[Counting sort er ikke altid lineær. Med $k = #swap[$n^2$]$ koster den $Theta(n + n^2) = Theta(n^2)$. Den er kun $O(n)$, når $k = O(n)$. Deler du heltallet op i cifre med radix sort, holdes cifferområdet lille, og du slipper med $Theta(n)$.]

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
  worked: [CountingSort koster $Theta(n + k)$. Her er $k = #swap[$n^3$]$, og $n^3$ dominerer:
  #eq[$ Theta(n + n^3) = Theta(n^3) $]],
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
  worked: [$d = 3$ gennemløb, hver en counting sort med cifferområde $k = n$, koster $Theta(n + n) = Theta(n)$. Konstanten $d = 3$ forsvinder:
  #eq[$ 3 dot Theta(n) = Theta(n) $]],
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
  worked: [QuickSort er sammenligningsbaseret, så værdiområdet er irrelevant. Værste fald er maksimalt ubalancerede partitioner ($n - 1$ og $0$):
  #eq[$ T(n) = T(n-1) + Theta(n) = Theta(n^2) $]],
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
  worked: [
  CountingSort: $k = #swap[$n^2$]$ dominerer, $Theta(n^2)$ → ja.
  RadixSort, to cifre i base $n$: to gennemløb à $Theta(n)$ → nej.
  MergeSort: altid $Theta(n log n)$ → nej.
  Rød-sort TreeSort: $n$ indsættelser à $O(log n)$ → $Theta(n log n)$ → nej.
  Ubalanceret TreeSort: sorteret input degenererer til en sti, og indsættelse $i$ koster $i$:
  #eq[$ sum_(i=1)^n i = Theta(n^2) $]
  → ja. QuickSort og InsertionSort: begge $Theta(n^2)$ → ja.],
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
  worked: [Pivot $x = A[7] = 3$, start $i = 0$.
  $j = 1$: $6 > 3$, spring over.
  $j = 2$: $2 <= 3$, $i = 1$, swap → $[2, 6, 4, 5, 1, 7, 3]$.
  $j = 3, 4$: $4, 5 > 3$, spring over.
  $j = 5$: $1 <= 3$, $i = 2$, swap $A[2], A[5]$ → $[2, 1, 4, 5, 6, 7, 3]$.
  $j = 6$: $7 > 3$, spring over.
  Til sidst swap $A[i+1] = A[3]$ med $A[7]$ → $[2, 1, 3, 5, 6, 7, 4]$.],
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
  worked: [Rå tællinger: $C = [1, 1, 3, 1, 0, 2, 1]$ (sum $9$). CLRS efterlader $C$ som prefix-summer, $C[i] "+="C[i-1]$, så $C = [1, 2, 5, 6, 6, 8, 9]$:
  #eq[$ 1 + 2 + 5 + 6 + 6 + 8 + 9 = 37 $]
  Fælden: $C$ ender kumulativt, ikke som rå tællinger.],
)
