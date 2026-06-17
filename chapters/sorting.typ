#import "../lib.typ": *

== Sortering og udvælgelse

At sortere er at lægge $n$ tal i rækkefølge. Der findes to slags algoritmer, og forskellen afgør alt til eksamen.

De *sammenligningsbaserede* (comparison-based) (insertion, selection, merge, quick, heap, tree-sort) spørger "er $a$ mindre end $b$?". Værdiernes størrelse er ligegyldig; kun antallet tæller, så køretiden afhænger kun af $n$.

De *distributionsbaserede* (distribution-based) (counting, radix) sammenligner aldrig. De bruger værdierne som indeks i et array. Det kommer under sammenligningsgrænsen, men køretiden afhænger nu af værdiernes størrelse.

Enhver sammenligningssortering (comparison sort) bruger mindst $Omega(n log n)$ sammenligninger i værste fald:

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

Counting sort tæller hver værdis forekomster, summerer tællingerne til en prefix-sum og placerer elementerne bagfra, så ens værdier holder rækkefølge (stabilitet/stability):

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

=== Sådan udfører du hver sortering i hånden

Det følgende er den rene mekaniske opskrift på hver algoritme — hvad du fysisk gør, trin for trin, uden pseudokode. Køretiderne står i tabellen ovenfor.

#recipe(
  title: "Insertion sort",
  [Se det venstre stykke af arrayet som "allerede sorteret". I starten er det bare det første tal.],
  [Tag det næste tal og hold det i hånden.],
  [Sammenlign det med tallene til venstre, og skub dem ét felt til højre så længe de er større.],
  [Sæt tallet i hullet der opstår. Så er det sorterede stykke ét længere.],
  [Bliv ved til der ikke er flere tal tilbage.],
)

I $[3, 1, 2]$ tager du $1$, skubber $3$ til højre og får $[1, 3, 2]$. Koster $Theta(n^2)$.

#recipe(
  title: "Selection sort",
  [Kig på hele det usorterede stykke og find det mindste tal.],
  [Byt det med det første tal i det usorterede stykke.],
  [Nu ligger det tal fast. Ryk grænsen ét felt til højre.],
  [Gør det samme med resten, til kun ét tal er tilbage.],
)

I $[3, 1, 2]$ finder du $1$, bytter med $3$ og får $[1, 3, 2]$. Koster $Theta(n^2)$.

#recipe(
  title: "Merge sort",
  [Del arrayet midt over igen og igen, til hver bid kun har ét tal.],
  [Et enkelt tal er sorteret af sig selv.],
  [Flet to sorterede bidder sammen ved at kigge på det forreste tal i hver, tage det mindste og gentage.],
  [Arbejd dig opad, så bidderne bliver dobbelt så store hver gang, til hele arrayet er én sorteret bid.],
)

$[3, 1]$ og $[2, 4]$ flettes ved at sammenligne forrest hver gang til $[1, 2, 3, 4]$. Koster $Theta(n log n)$.

#recipe(
  title: "Quicksort (Lomuto, sidste element som pivot)",
  [Vælg det sidste tal i stykket som pivot.],
  [Løb stykket igennem fra venstre og saml alle tal, der er mindre end eller lig pivoten, i venstre side.],
  [Byt pivoten ind lige efter den sidste lille værdi. Så står pivoten på sin endelige plads.],
  [Gentag rekursivt på stykket til venstre for pivoten og på stykket til højre.],
  [Når alle stykker har længde ét, er arrayet sorteret.],
)

Typisk $Theta(n log n)$, men $Theta(n^2)$ når pivoten lander yderst hver gang (fx på sorteret input).

#recipe(
  title: "Heapsort",
  [Byg en max-heap (max-heap) ud af arrayet, så hver forælder er større end eller lig sine børn. Det gør du nedefra og op med sift-down.],
  [Det største tal sidder nu i toppen (rod). Byt det med det sidste tal i heapen.],
  [Skrump heapen med ét, så det store tal ligger fast bagest.],
  [Lad det nye top-tal synke ned (sift-down), til heap-egenskaben holder igen.],
  [Gentag byt, skrump og synk, til heapen er tom. Så er arrayet sorteret.],
)

Build-heap koster $Theta(n)$, derefter $n$ sift-downs. Samlet $Theta(n log n)$.

#recipe(
  title: "Counting sort",
  [Lav et tælle-array med en plads per mulig værdi, og tæl hvor mange gange hver værdi optræder.],
  [Læg tællingerne sammen fra venstre, så hver plads viser hvor mange tal der er mindre end eller lig den værdi (prefix-sum).],
  [Løb input-arrayet igennem bagfra og slå hvert tal op i tælle-arrayet for at finde dets plads i output. Træk én fra tællingen bagefter.],
  [At gå bagfra holder ens værdier i deres oprindelige rækkefølge (stabilt/stable).],
)

Koster $Theta(n + k)$, hvor $k$ er værdiområdet.

#recipe(
  title: "Radix sort (LSD, base 10)",
  [Start med det mindst betydende ciffer (enerne).],
  [Sortér hele arrayet på det ciffer alene med en stabil counting sort.],
  [Gå videre til næste ciffer (tierne, så hundrederne og så videre), og sortér stabilt på det.],
  [Fordi hver ciffer-sortering er stabil, bevares ordenen fra de tidligere cifre. Når du har været alle cifre igennem, er arrayet sorteret.],
)

$[21, 12, 11]$ sorteres først på enere til $[21, 11, 12]$, så på tiere til $[11, 12, 21]$. Koster $Theta(d(n + k))$.

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
  tag: [Sortering: værste-falds-køretid for CountingSort],
  source: "MCQ juni 2021, Spm. 29",
  prompt: [Vi sorterer rækken af #swap[$n$] heltal ($n$ lige): #swap[$2, 1, 2, 1, dots.h, 2, 1$]. Hvad er køretiden for CountingSort på dette input?],
  options: (
    [$Theta(1)$],
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
  ),
  answer: [Mulighed (c): $Theta(n)$.],
  blueprint: [
    CountingSort koster $Theta(n + k)$. Her er pointen, at $k$ er værdiområdet, ikke antallet af gentagelser. Er $k$ konstant, er den lineær.

    + *Find $n$.* Tæl elementerne der skal sorteres.
    + *Find $k$.* Læs hvor mange forskellige værdier der er — det er #swap[$k$], ikke hvor tit de gentages.
    + *Læg dem sammen.* Skriv $Theta(n + k)$ op.
    + *Behold det hurtigste led.* Er $k$ en konstant, falder den væk, og svaret er $Theta(n)$.
  ],
  worked: [
    Input: #swap[$2, 1, 2, 1, dots.h$], altså kun værdierne $1$ og $2$.

    + Værdierne er $1$ og $2$, så $k = 2$ — en konstant, uafhængig af $n$.
    + Sæt ind: $Theta(n + k) = Theta(n + 2) = Theta(n)$.

    Svar: $Theta(n)$.
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
  tag: [Sortering: værste-falds-køretid for QuickSort],
  source: "MCQ juni 2021, Spm. 30",
  prompt: [Vi sorterer rækken af #swap[$n$] heltal ($n$ lige): #swap[$2, 1, 2, 1, dots.h, 2, 1$]. Hvad er køretiden for QuickSort på dette input?],
  options: (
    [$Theta(1)$],
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
  ),
  answer: [Mulighed (e): $Theta(n^2)$.],
  blueprint: [
    Standard CLRS-QuickSort bruger Lomuto-partition med sidste element som pivot og $<=$-sammenligninger. Den har ingen særbehandling af ens nøgler, så mange dubletter giver maksimalt skæve partitioner.

    + *Find varianten.* Standard QuickSort sammenligner med $<=$, ingen tre-vejs-deling.
    + *Tjek for dubletter.* Har inputtet kun få forskellige værdier, lander pivoten i den ene ende hver gang.
    + *Skriv rekursionen.* Maksimalt skæve splits: $T(n) = T(n-1) + Theta(n)$.
    + *Løs den.* Summen $1 + 2 + dots.h + n$ giver $Theta(n^2)$.
  ],
  worked: [
    Input: #swap[$2, 1, 2, 1, dots.h$] — kun to forskellige nøgler.

    + Standard QuickSort har ingen særbehandling af ens elementer, så hver partition bliver maksimalt skæv.
    + Kører man Lomuto-QuickSort, er sammenligningstallet præcis $n^2\/4$ ($n=4 -> 4$, $8 -> 16$, $16 -> 64$).
    + Det giver rekursionen $T(n) = T(n-1) + Theta(n)$, der summer til $Theta(n^2)$.

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
  tag: [QuickSort: kør PARTITION i hånden],
  source: "MCQ juni 2021, Spm. 11",
  prompt: [Kør PARTITION($A$, 4, 13) på det relevante stykke af arrayet $A = #swap[$[21, 17, 28, 14, 9, 18, 6, 1, 26, 15, 30, 7, 13, 19, 2]$]$ (indeks 1..15). Hvilken mulighed viser $A$ bagefter? (Standard CLRS Lomuto-partition; pivot er $A[13] = 13$.)],
  options: (
    [$A = [21, 17, 28, 1, 6, 7, 9, 13, 14, 15, 18, 26, 30, 19, 2]$],
    [$A = [1, 2, 6, 7, 9, 13, 14, 15, 17, 18, 19, 21, 26, 28, 30]$],
    [$A = [21, 17, 28, 9, 6, 1, 7, 13, 14, 18, 26, 15, 30, 19, 2]$],
    [$A = [21, 17, 28, 9, 6, 1, 7, 13, 26, 15, 30, 14, 18, 19, 2]$],
  ),
  answer: [Mulighed (d): $A = [21, 17, 28, 9, 6, 1, 7, 13, 26, 15, 30, 14, 18, 19, 2]$.],
  blueprint: [
    Når PARTITION kun kaldes på et delstykke $p..r$, så rør den ikke resten. Kør Lomuto på indeks $p..r$ og splejs de uberørte ender på igen til sidst.

    + *Sæt pivot.* Pivoten er sidste element i stykket: #swap[$x = A[r]$]. Sæt $i = p - 1$.
    + *Løb $j$ fra $p$ til $r-1$.* Er $A[j] <= x$, tæl $i$ op og swap $A[i]$ med $A[j]$. Ellers spring over.
    + *Til sidst.* Swap $A[i+1]$ med pivoten $A[r]$.
    + *Splejs.* Kun indeks $p..r$ ændrer sig; de uberørte ender står som før.
  ],
  worked: [
    Stykket er indeks 4..13, pivot $x = A[13] = 13$. Elementerne $A[4..12] = 14, 9, 18, 6, 1, 26, 15, 30, 7$.

    + Værdier $<= 13$ i rækkefølge er $9, 6, 1, 7$, der skubbes frem i stykket.
    + Værdier $> 13$ ($14, 18, 26, 15, 30$) skubbes til højre.
    + Efter $j$-løkken og det sidste pivot-swap bliver stykket 4..13 til $9, 6, 1, 7, 13, 26, 15, 30, 14, 18$.

    Splejs med de uberørte ender: $A = 21, 17, 28, thin 9, 6, 1, 7, 13, 26, 15, 30, 14, 18, thin 19, 2$.

    Svar: $A = [21, 17, 28, 9, 6, 1, 7, 13, 26, 15, 30, 14, 18, 19, 2]$.
  ],
)

#qcard(
  tag: [QuickSort: kør PARTITION i hånden],
  source: "MCQ juni 2025, Spm. 11",
  prompt: [Kør PARTITION($A$, 1, 9) på arrayet $A = #swap[$[8, 5, 6, 1, 9, 7, 3, 2, 4]$]$ (indeks 1..9). Hvilken mulighed viser $A$ bagefter? (Standard CLRS Lomuto-partition; pivot er sidste element $A[9] = 4$.)],
  options: (
    [$A = [1, 3, 2, 4, 5, 6, 9, 7, 8]$],
    [$A = [1, 3, 2, 8, 9, 7, 5, 6, 4]$],
    [$A = [1, 3, 2, 4, 8, 5, 6, 9, 7]$],
    [$A = [1, 3, 2, 4, 9, 7, 5, 6, 8]$],
    [$A = [4, 2, 3, 1, 9, 7, 6, 5, 8]$],
    [$A = [1, 2, 3, 4, 5, 6, 7, 8, 9]$],
  ),
  answer: [Mulighed (d): $A = [1, 3, 2, 4, 9, 7, 5, 6, 8]$.],
  blueprint: [
    Lomuto-partition skubber alt der er mindre end eller lig pivoten om til venstre. Du holder styr på to indeks, $i$ og $j$, og swapper undervejs.

    + *Sæt pivot.* Pivoten er sidste element: #swap[$x = A[r]$]. Sæt $i = p - 1$.
    + *Løb $j$ fra venstre.* Er $A[j] > x$, så gør ingenting.
    + *Ved et lille element.* Er $A[j] <= x$, tæl $i$ op med $1$ og swap $A[i]$ med $A[j]$. Skriv arrayet ned hver gang.
    + *Til sidst.* Swap $A[i+1]$ med pivoten $A[r]$. Nu står pivoten på sin endelige plads.
  ],
  worked: [
    Pivot $x = A[9] = 4$, start $i = 0$. Array: #swap[$[8, 5, 6, 1, 9, 7, 3, 2, 4]$].

    - $j = 1$: $8 > 4$, spring over. $j = 2$: $5 > 4$, spring over. $j = 3$: $6 > 4$, spring over.
    - $j = 4$: $1 <= 4$, $i = 1$, swap $A[1]$ og $A[4]$ #sym.arrow.r $[1, 5, 6, 8, 9, 7, 3, 2, 4]$.
    - $j = 5$: $9 > 4$, spring over. $j = 6$: $7 > 4$, spring over.
    - $j = 7$: $3 <= 4$, $i = 2$, swap $A[2]$ og $A[7]$ #sym.arrow.r $[1, 3, 6, 8, 9, 7, 5, 2, 4]$.
    - $j = 8$: $2 <= 4$, $i = 3$, swap $A[3]$ og $A[8]$ #sym.arrow.r $[1, 3, 2, 8, 9, 7, 5, 6, 4]$.

    Til sidst swap $A[i+1] = A[4]$ med $A[9]$ #sym.arrow.r $[1, 3, 2, 4, 9, 7, 5, 6, 8]$.

    Svar: $A = [1, 3, 2, 4, 9, 7, 5, 6, 8]$.
  ],
)

#qcard(
  tag: [QuickSort: hvilken værdi var pivot?],
  source: "MCQ juni 2025, Spm. 12 (flere rigtige)",
  prompt: [Et array $A$ af længde ni indeholder ${1, dots.h, 9}$ i en eller anden rækkefølge. Efter PARTITION($A$, 1, 9) er $A = #swap[$[2, 1, 3, 4, 6, 5, 8, 7, 9]$]$ (indeks 1..9). Hvilke tal kunne have været pivoten (det sidste element til at starte med)? (Et eller flere svar.)],
  options: (
    [$1$],
    [$2$],
    [$3$],
    [$4$],
    [$5$],
    [$6$],
    [$7$],
    [$8$],
    [$9$],
  ),
  answer: [Mulighed (c), (d), (i): $3$, $4$ og $9$.],
  blueprint: [
    I Lomuto ender pivoten på sin endelige sorterede plads $q$: alt til venstre er mindre, alt til højre er større. Med værdierne $1..n$ er den plads netop indeks lig værdien.

    + *Hvor lander pivoten?* Pivoten $= A[r]$ ender på sin sorterede plads $q$, med mindre til venstre og større til højre.
    + *Plads = værdi.* For værdierne $1..n$ er pladsen til værdien $p$ netop indeks $p$, så $A[p]$ skal være $p$.
    + *Tjek hver plads.* Indeks $p$ er en gyldig pivot-landing hvis $A[p] = p$, *og* alt til venstre er $< p$, *og* alt til højre er $> p$.
    + *Saml svaret.* Alle værdier der opfylder det.
  ],
  worked: [
    Array: #swap[$[2, 1, 3, 4, 6, 5, 8, 7, 9]$]. Tjek hver $p$ med krav $A[p] = p$, venstre alle $< p$, højre alle $> p$:

    - $p = 1$: $A[1] = 2 != 1$. Nej.
    - $p = 2$: $A[2] = 1 != 2$. Nej.
    - $p = 3$: $A[3] = 3$; venstre ${2, 1}$ alle $< 3$, højre alle $> 3$. Ja.
    - $p = 4$: $A[4] = 4$; venstre ${2, 1, 3}$ alle $< 4$, højre alle $> 4$. Ja.
    - $p = 5$: $A[5] = 6 != 5$. Nej.
    - $p = 6$: $A[6] = 5 != 6$. Nej.
    - $p = 7$: $A[7] = 8 != 7$. Nej.
    - $p = 8$: $A[8] = 7 != 8$. Nej.
    - $p = 9$: $A[9] = 9$; venstre alle $< 9$, højre er tom. Ja.

    Svar: $3$, $4$ og $9$.
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

#qcard(
  tag: [CountingSort: trace tælle-arrayet C],
  source: "MCQ juni 2025, Spm. 19",
  prompt: [Et array af elleve heltal med værdier $0..5$: $A = #swap[$[2, 2, 5, 1, 3, 5, 2, 3, 2, 5, 2]$]$ (indeks 1..11). Kør COUNTING-SORT($A$, 11, 5) med et array $C$ med seks pladser (0..5). Hvad er summen af de seks heltal i $C$ ved terminering?],
  options: (
    [$0$],
    [$5$],
    [$11$],
    [$18$],
    [$23$],
    [$32$],
    [$34$],
  ),
  answer: [Mulighed (c): $11$.],
  blueprint: [
    Her spørges der om $C$ efter tælle-fasen, hvor $C[i]$ er antallet af elementer lig $i$. Hvert af de $n$ input-elementer tæller præcis én tæller op, så summen af alle tællere er bare $n$.

    + *Tæl forekomster.* $C[i]$ tæller hvor mange elementer i $A$ der er lig $i$.
    + *Én optælling per element.* Hvert af de $n$ elementer øger præcis én tæller.
    + *Summen er $n$.* Derfor er summen af alle tællere lig $n$.
    + *Aflæs $n$.* Læs antallet af elementer i opgaven.
  ],
  worked: [
    Array: #swap[$[2, 2, 5, 1, 3, 5, 2, 3, 2, 5, 2]$], værdier $0..5$.

    + Tællinger: værdi $0 -> 0$, $1 -> 1$, $2 -> 5$, $3 -> 2$, $4 -> 0$, $5 -> 3$, altså $C = [0, 1, 5, 2, 0, 3]$.
    + Hvert af de $11$ elementer øger præcis én tæller, så summen er $n = 11$.

    Svar: $11$.
  ],
)

#qcard(
  tag: [RadixSort: kør trace i hånden],
  source: "MCQ juni 2017, Spm. 9",
  prompt: [Vi vil bruge RADIX-SORT($A$, 4) til at sortere arrayet nedenfor stigende. $A$ (indeks 1..7): $#swap[$[2452, 5363, 4433, 1413, 2433, 3222, 2121]$]$. Hvad er indholdet af $A$ efter tre af de fire iterationer i RADIX-SORT($A$, 4)?],
  options: (
    [$[2452, 5363, 4433, 1413, 2433, 3222, 2121]$],
    [$[2121, 3222, 5363, 4433, 2452, 1413, 2433]$],
    [$[1413, 2121, 3222, 4433, 2433, 2452, 5363]$],
    [$[2121, 3222, 5363, 1413, 4433, 2433, 2452]$],
    [$[1413, 2121, 2433, 2452, 3222, 4433, 5363]$],
    [$[2121, 2452, 3222, 5363, 4433, 1413, 2433]$],
  ),
  answer: [Mulighed (d): $[2121, 3222, 5363, 1413, 4433, 2433, 2452]$.],
  blueprint: [
    Radix sort er en stabil counting sort per ciffer, mindst betydende først. Efter $k$ iterationer er arrayet sorteret på de $k$ laveste cifre, og ens cifre holder den tidligere rækkefølge.

    + *Find cifrene.* Tre af fire iterationer betyder de tre laveste cifre i rækkefølge: enere, så tiere, så hundreder.
    + *Sortér stabilt per ciffer.* Lav en stabil sortering på hvert ciffer efter tur, og bevar den tidligere orden ved lige cifre.
    + *Aflæs.* Skriv arrayet ned efter det tredje gennemløb.
    + *Match.* Find den i svarmenuen.
  ],
  worked: [
    Start: #swap[$[2452, 5363, 4433, 1413, 2433, 3222, 2121]$].

    + Gennemløb 1 (enere): cifre $2, 3, 3, 3, 3, 2, 1 ->$ $[2121, 2452, 3222, 5363, 4433, 1413, 2433]$.
    + Gennemløb 2 (tiere): stabil sortering giver $[1413, 2121, 3222, 4433, 2433, 2452, 5363]$.
    + Gennemløb 3 (hundreder): cifre $4, 1, 2, 4, 4, 4, 3 ->$ $[2121, 3222, 5363, 1413, 4433, 2433, 2452]$.

    Svar: $[2121, 3222, 5363, 1413, 4433, 2433, 2452]$.
  ],
)

#qcard(
  tag: [RadixSort: kør trace i hånden],
  source: "MCQ juni 2025, Spm. 20",
  prompt: [Sortér seks heltal med RADIX-SORT($A$, 6, 4). $A = #swap[$[0113, 4102, 4440, 2240, 2213, 2340]$]$ (indeks 1..6). Hvad er $A$ efter to af de fire iterationer?],
  options: (
    [$[4102, 0113, 2213, 4440, 2240, 2340]$],
    [$[4102, 0113, 2213, 2240, 2340, 4440]$],
    [$[0113, 2240, 2213, 2340, 4102, 4440]$],
    [$[0113, 2213, 2240, 2340, 4102, 4440]$],
    [$[4440, 2240, 2340, 4102, 0113, 2213]$],
  ),
  answer: [Mulighed (a): $[4102, 0113, 2213, 4440, 2240, 2340]$.],
  blueprint: [
    LSD radix sort er en stabil counting sort per ciffer, mindst betydende først. Efter $k$ iterationer er arrayet sorteret på de $k$ laveste cifre, og ens cifre bevarer den tidligere rækkefølge.

    + *Find cifrene.* To af fire iterationer betyder de to laveste cifre: enere, så tiere.
    + *Sortér stabilt per ciffer.* Grupér efter cifret og bevar den tidligere orden ved lige cifre.
    + *Aflæs.* Skriv arrayet ned efter det andet gennemløb.
  ],
  worked: [
    Start: #swap[$[0113, 4102, 4440, 2240, 2213, 2340]$].

    + Gennemløb 1 (enere, stabil): cifre $3, 2, 0, 0, 3, 0 ->$ $[4440, 2240, 2340, 4102, 0113, 2213]$.
    + Gennemløb 2 (tiere, stabil): tiere er $4, 4, 4, 0, 1, 1$. Grupér med bevaret orden: tier $0 ->$ 4102; tier $1 ->$ 0113, 2213; tier $4 ->$ 4440, 2240, 2340.

    Svar: $[4102, 0113, 2213, 4440, 2240, 2340]$.
  ],
)

#qcard(
  tag: [Sortering: køretid for InsertionSort],
  source: "MCQ juni 2021, Spm. 28",
  prompt: [Vi sorterer rækken af #swap[$n$] heltal ($n$ lige): #swap[$2, 1, 2, 1, dots.h, 2, 1$]. Hvad er køretiden for INSERTIONSORT på dette input?],
  options: (
    [$Theta(1)$],
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
  ),
  answer: [Mulighed (e): $Theta(n^2)$.],
  blueprint: [
    InsertionSorts pris på element $i$ er $1$ (sammenligningen der stopper inderløkken) plus antallet af inversioner (inversions) mellem $a[i]$ og de tidligere elementer (skiftene). Samlet $Theta(n + "inversioner")$.

    + *Tæl inversioner.* Hvor mange par står i forkert rækkefølge i forhold til hinanden?
    + *Få inversioner?* Er de $O(n)$, er svaret $Theta(n)$.
    + *Mange inversioner?* Er de $Theta(n^2)$, er svaret $Theta(n^2)$.
  ],
  worked: [
    Input: #swap[$2, 1, 2, 1, dots.h$].

    + Når det $k$.-te "$1$" indsættes, sidder de $k$ tidligere "$2$"-er allerede forrest i det sorterede præfiks. Det "$1$" skal skifte forbi dem alle.
    + Samlede skift: $1 + 2 + dots.h + n\/2 approx n^2\/8$. Et trace bekræfter: $n = 4, 8, 16$ giver $3, 10, 36$ skift.
    + Inputtet har altså $Theta(n^2)$ inversioner, og samlet tid $Theta(n^2)$.

    Svar: $Theta(n^2)$.
  ],
)

#qcard(
  tag: [Sortering: køretid for Heapsort på ens nøgler],
  source: "MCQ juni 2019, Spm. 28",
  prompt: [Hvad er værste-falds-køretiden for HEAPSORT, når den køres på #swap[$n$] ens elementer?],
  options: (
    [$O(1)$],
    [$O(log n)$],
    [$O(n)$],
    [$O(n log n)$],
    [$O(n^2)$],
  ),
  answer: [Mulighed (c): $O(n)$.],
  blueprint: [
    Heapsort er BUILD-MAX-HEAP ($O(n)$) og derefter $n-1$ EXTRACT-MAX, hver med en SIFT-DOWN. Prisen for en SIFT-DOWN er antallet af niveauer den synker; den stopper, så snart knuden er $>=$ begge børn.

    + *Find delene.* Build-fasen og udtræk-fasen kører hver en række SIFT-DOWN.
    + *Vurdér SIFT-DOWN.* Den stopper, så snart knuden ikke er strengt mindre end et barn.
    + *Tjek inputtet.* Er alle nøgler ens, er en forælder aldrig strengt mindre end et barn, så SIFT-DOWN stopper på første niveau — $O(1)$ per kald.
    + *Læg sammen.* $O(n)$ kald à $O(1)$ giver $O(n)$.
  ],
  worked: [
    Input: #swap[$n$] ens elementer.

    + Med ens elementer bliver intet swap nogensinde tvunget — en knude er aldrig strengt mindre end et barn.
    + Hver SIFT-DOWN sammenligner knuden med op til to børn og stopper på første niveau, altså $O(1)$.
    + Der er $O(n)$ sift-downs ($n\/2$ i build, $n-1$ i udtræk), hver $O(1)$.

    Svar: $O(n)$.
  ],
)
