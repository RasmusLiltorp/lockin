#import "../lib.typ": *

== Sortering og udvælgelse <th-sort-lower-bound>

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

#metadata(none) <th-sort-runtimes>
#table(
  columns: (auto, auto, auto, auto, auto, 1fr),
  inset: 7pt,
  align: (left, center, center, center, center, left),
  stroke: 0.4pt + hair,
  table.header([*Algoritme*], [*Bedste fald*], [*Gns. fald*], [*Værste fald*], [*In-place*], [*Note*]),
  [Insertion sort], [$Theta(n)$], [$Theta(n^2)$], [$Theta(n^2)$], [ja], [Bedste fald på sorteret input; værst på omvendt sorteret. Stabil.],
  [Selection sort], [$Theta(n^2)$], [$Theta(n^2)$], [$Theta(n^2)$], [ja], [Altid $Theta(n^2)$, uanset input.],
  [Merge sort], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n log n)$], [nej], [Altid $Theta(n log n)$. Kræver $Theta(n)$ ekstra array. Stabil.],
  [Quicksort], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n^2)$], [ja], [Bedst ved balancerede splits; værst på sorteret input eller mange dubletter (Lomuto).],
  [Heapsort], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n log n)$], [ja], [Altid $Theta(n log n)$. Særtilfælde: $n$ ens nøgler giver $O(n)$.],
  [Counting sort], [$Theta(n + k)$], [$Theta(n + k)$], [$Theta(n + k)$], [nej], [Kræver heltal i kendt område $[0, k)$. Kun lineær når $k = O(n)$. Stabil.],
  [Radix sort], [$Theta(d(n + k))$], [$Theta(d(n + k))$], [$Theta(d(n + k))$], [nej], [$d$ cifre, $k$ er cifferområdet. Kræver fast $d$, lille $k$; lineær når $d$ konstant og $k = O(n)$. Stabil.],
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

Quicksort vælger ét tal som pivot, deler resten op i dem der er mindre og dem der er større, og sorterer hver bunke for sig. Selve delingen foregår i PARTITION, og det er her de fleste falder over notationen. Lad os tage hvert symbol, før vi ser koden.

PARTITION arbejder kun på et udsnit af arrayet, ikke nødvendigvis det hele. Udsnittet skrives $A[p..r]$, hvor $p$ er indekset på det første tal i udsnittet og $r$ indekset på det sidste. Pivoten er det sidste tal, altså $A[r]$ (CLRS vælger altid sidste element).

Undervejs har du to pegepinde. $i$ er en grænse. Alt til og med $i$ er allerede lagt over til venstre som mindre end eller lig pivoten. Den starter på $p - 1$, altså ét felt før udsnittet overhovedet begynder, for du har endnu ikke fundet nogen små tal. Læg mærke til at $i$ hverken er pivotens værdi eller dens plads. Det er bare grænsen mellem "små" og resten. $j$ er den der løber hen over tallene ét ad gangen og kigger.

Hver gang $j$ rammer et tal der er mindre end eller lig pivoten, rykker du grænsen $i$ ét frem og bytter det lille tal ind på grænsen. Større tal lader du bare ligge. Til sidst bytter du pivoten ind lige efter grænsen, og så står den på sin endelige plads med mindre-eller-lig til venstre og større til højre:

```
PARTITION(A, p, r)
  x = A[r]            // pivot: sidste element i udsnittet
  i = p - 1           // grænsen, starter lige før udsnittet
  for j = p to r - 1:
    if A[j] <= x:     // lille tal fundet
      i += 1          // ryk grænsen ét frem
      swap A[i], A[j] // byt det lille tal ind på grænsen
  swap A[i+1], A[r]   // byt pivoten ind på sin endelige plads
  return i + 1        // pivotens indeks
```

#note(title: [Værdiområde])[Værdiområdet i opgaveteksten er ofte med for at narre dig. For en sammenligningssortering er det støj: quicksort er $Theta(n^2)$ i værste fald, uanset om tallene ligger i $[0, n)$ eller $[0, n^9)$. Det betyder kun noget for counting og radix.]

#trap(title: [Counting sort])[Counting sort er ikke altid lineær. Med $k = #swap[$n^2$]$ koster den $Theta(n + n^2) = Theta(n^2)$. Den er kun $O(n)$, når $k = O(n)$. Deler du heltallet op i cifre med radix sort, holdes cifferområdet lille, og du slipper med $Theta(n)$.]

=== Sådan udfører du hver sortering i hånden

Det følgende er den rene mekaniske opskrift på hver algoritme — hvad du fysisk gør, trin for trin, uden pseudokode. Køretiderne står i tabellen ovenfor.

#metadata(none) <th-sort-insertion>
#recipe(
  title: "Insertion sort",
  [Se det venstre stykke af arrayet som "allerede sorteret". I starten er det bare det første tal.],
  [Tag det næste tal og hold det i hånden.],
  [Sammenlign det med tallene til venstre, og skub dem ét felt til højre så længe de er større.],
  [Sæt tallet i hullet der opstår. Så er det sorterede stykke ét længere.],
  [Bliv ved til der ikke er flere tal tilbage.],
)

I $[3, 1, 2]$ tager du $1$, skubber $3$ til højre og får $[1, 3, 2]$. Bedste fald $Theta(n)$ på allerede sorteret input, gennemsnit $Theta(n^2)$, værste fald $Theta(n^2)$ på omvendt sorteret input.

#metadata(none) <th-sort-selection>
#recipe(
  title: "Selection sort",
  [Kig på hele det usorterede stykke og find det mindste tal.],
  [Byt det med det første tal i det usorterede stykke.],
  [Nu ligger det tal fast. Ryk grænsen ét felt til højre.],
  [Gør det samme med resten, til kun ét tal er tilbage.],
)

I $[3, 1, 2]$ finder du $1$, bytter med $3$ og får $[1, 3, 2]$. Bedste, gennemsnitlige og værste fald er alle $Theta(n^2)$, uanset input — den scanner altid hele det usorterede stykke.

#metadata(none) <th-sort-merge>
#recipe(
  title: "Merge sort",
  [Del arrayet midt over igen og igen, til hver bid kun har ét tal.],
  [Et enkelt tal er sorteret af sig selv.],
  [Flet to sorterede bidder sammen ved at kigge på det forreste tal i hver, tage det mindste og gentage.],
  [Arbejd dig opad, så bidderne bliver dobbelt så store hver gang, til hele arrayet er én sorteret bid.],
)

$[3, 1]$ og $[2, 4]$ flettes ved at sammenligne forrest hver gang til $[1, 2, 3, 4]$. Bedste, gennemsnitlige og værste fald er alle $Theta(n log n)$, uanset input. Kræver $Theta(n)$ ekstra array.

#metadata(none) <th-sort-quicksort>
#recipe(
  title: "Quicksort (Lomuto, sidste element som pivot)",
  [Vælg det sidste tal i stykket som pivot.],
  [Løb stykket igennem fra venstre og saml alle tal, der er mindre end eller lig pivoten, i venstre side.],
  [Byt pivoten ind lige efter den sidste lille værdi. Så står pivoten på sin endelige plads.],
  [Gentag rekursivt på stykket til venstre for pivoten og på stykket til højre.],
  [Når alle stykker har længde ét, er arrayet sorteret.],
)

Bedste fald $Theta(n log n)$ ved balancerede splits, gennemsnit $Theta(n log n)$, værste fald $Theta(n^2)$ når pivoten lander yderst hver gang (sorteret input eller mange dubletter med Lomuto).

#metadata(none) <th-sort-heapsort>
#recipe(
  title: "Heapsort",
  [Byg en max-heap (max-heap) ud af arrayet, så hver forælder er større end eller lig sine børn. Det gør du nedefra og op med sift-down.],
  [Det største tal sidder nu i toppen (rod). Byt det med det sidste tal i heapen.],
  [Skrump heapen med ét, så det store tal ligger fast bagest.],
  [Lad det nye top-tal synke ned (sift-down), til heap-egenskaben holder igen.],
  [Gentag byt, skrump og synk, til heapen er tom. Så er arrayet sorteret.],
)

Build-heap koster $Theta(n)$, derefter $n$ sift-downs. Bedste, gennemsnitlige og værste fald er alle $Theta(n log n)$. Særtilfælde: $n$ ens nøgler giver $O(n)$, fordi hver sift-down stopper på første niveau.

#metadata(none) <th-sort-counting>
#recipe(
  title: "Counting sort",
  [Lav et tælle-array med en plads per mulig værdi, og tæl hvor mange gange hver værdi optræder.],
  [Læg tællingerne sammen fra venstre, så hver plads viser hvor mange tal der er mindre end eller lig den værdi (prefix-sum).],
  [Løb input-arrayet igennem bagfra og slå hvert tal op i tælle-arrayet for at finde dets plads i output. Træk én fra tællingen bagefter.],
  [At gå bagfra holder ens værdier i deres oprindelige rækkefølge (stabilt/stable).],
)

Bedste, gennemsnitlige og værste fald er alle $Theta(n + k)$, hvor $k$ er værdiområdet. Kræver heltal i et kendt område $[0, k)$ og er kun lineær, når $k = O(n)$.

#metadata(none) <th-sort-radix>
#recipe(
  title: "Radix sort (LSD, base 10)",
  [Start med det mindst betydende ciffer (enerne).],
  [Sortér hele arrayet på det ciffer alene med en stabil counting sort.],
  [Gå videre til næste ciffer (tierne, så hundrederne og så videre), og sortér stabilt på det.],
  [Fordi hver ciffer-sortering er stabil, bevares ordenen fra de tidligere cifre. Når du har været alle cifre igennem, er arrayet sorteret.],
)

$[21, 12, 11]$ sorteres først på enere til $[21, 11, 12]$, så på tiere til $[11, 12, 21]$. Bedste, gennemsnitlige og værste fald er alle $Theta(d(n + k))$ med $d$ cifre og cifferområde $k$. Kræver fast antal cifre $d$ og lille $k$; lineær når $d$ er konstant og $k = O(n)$.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Sortering: værste-falds-køretid for CountingSort (Counting sort)],
  source: "MCQ juni 2023, Spm. 27",
  theory: <th-sort-counting>,
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
    CountingSort koster altid $Theta(n + k)$, hvor $n$ er antallet af elementer og $k$ er størrelsen af værdiområdet (én plads i tælle-arrayet per mulig værdi). Det er en distributionssortering, så værdiområdet tæller direkte med — modsat en sammenligningssortering.

    + *Find $n$.* Der skal sorteres $n$ elementer, så $n$ er bare $n$.
    + *Find $k$.* Værdierne ligger i $[0, #swap[$n^3$])$, så der skal være én tæller per værdi fra $0$ til $n^3 - 1$. Det giver $k = n^3$ pladser i $C$.
    + *Sæt ind i formlen.* $Theta(n + k) = Theta(n + n^3)$.
    + *Sammenlign leddene.* For voksende $n$ vokser $n^3$ hurtigere end $n$: forholdet $n^3 \/ n = n^2 -> infinity$. Altså dominerer $n^3$, og $n$ falder væk.

    Det dominerende led står tilbage:

    #eq[$ Theta(n + n^3) = Theta(n^3) $]

    Svar: $Theta(n^3)$.
  ],
)

#qcard(
  tag: [Sortering: værste-falds-køretid for CountingSort (Counting sort)],
  source: "MCQ juni 2021, Spm. 29",
  theory: <th-sort-counting>,
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
    Fælden her er at blande antallet af elementer sammen med antallet af forskellige værdier. CountingSort koster $Theta(n + k)$, hvor $k$ er værdiområdets størrelse — altså hvor mange forskellige værdier der kan optræde, ikke hvor tit de gentages.

    + *Find $n$.* Rækken er #swap[$2, 1, 2, 1, dots.h$] med $n$ elementer i alt.
    + *Find $k$.* Der optræder kun to forskellige værdier, $1$ og $2$. Tælle-arrayet behøver altså kun pladser for værdierne op til $2$, så $k = 2$ — en konstant, helt uafhængig af $n$.
    + *Sæt ind i formlen.* $Theta(n + k) = Theta(n + 2)$.
    + *Behold det dominerende led.* En konstant forsvinder i $Theta$: $Theta(n + 2) = Theta(n)$.

    Bemærk, at gentagelserne (mange $1$- og $2$-er) ikke ændrer noget — de tæller bare op i de samme to tællere.

    Svar: $Theta(n)$.
  ],
)

#qcard(
  tag: [Sortering: værste-falds-køretid for RadixSort (Radix sort)],
  source: "MCQ juni 2023, Spm. 28",
  theory: <th-sort-radix>,
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
    RadixSort kører én stabil CountingSort per ciffer. Prisen er derfor $Theta(d(n + k))$, hvor $d$ er antallet af cifre og $k$ er cifferområdets størrelse (ikke hele tallets værdiområde).

    + *Tæl cifrene.* Tallene behandles som tre cifre, så $d = 3$.
    + *Find cifferområdet $k$.* Hvert enkelt ciffer ligger i $[0, #swap[$n$])$, så et ciffers CountingSort skal bruge $k = n$ tællere.
    + *Pris per gennemløb.* Ét ciffers CountingSort koster $Theta(n + k) = Theta(n + n) = Theta(2n) = Theta(n)$.
    + *Gang med antal cifre.* Tre gennemløb: $3 dot Theta(n) = Theta(3n)$.
    + *Behold det dominerende led.* Faktoren $3$ er en konstant og forsvinder i $Theta$.

    Sat ind i formlen direkte:

    #eq[$ Theta(d(n + k)) = Theta(3 (n + n)) = Theta(6 n) = Theta(n) $]

    Bemærk fælden: selvom selve tallene ligger i $[0, n^3)$, gør opdelingen i tre cifre med lille cifferområde det lineært — det er netop fordelen ved radix frem for ren CountingSort her.

    Svar: $Theta(n)$.
  ],
)

#qcard(
  tag: [Sortering: værste-falds-køretid for QuickSort (Quicksort)],
  source: "MCQ juni 2023, Spm. 29",
  theory: <th-sort-quicksort>,
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
    Første spørgsmål: er algoritmen sammenligningsbaseret? QuickSort sammenligner par af elementer, så værdiområdet $[0, #swap[$n^3$])$ er ren støj — det påvirker ikke køretiden.

    + *Find værste-falds-inputtet.* QuickSorts pris afgøres af, hvor skæve partitionerne bliver. Det værste er, at pivoten lander yderst hver gang: så ryger alle de øvrige $n-1$ elementer i den ene del, og den anden del er tom. (Det sker fx på allerede sorteret input med Lomuto.)
    + *Skriv rekursionen op.* Et PARTITION-kald på $n$ elementer koster $Theta(n)$ (det løber hele stykket igennem). Derefter er der ét rekursivt kald på $n-1$ elementer og ét på $0$:

    #eq[$ T(n) = T(n-1) + T(0) + Theta(n) = T(n-1) + Theta(n) $]

    + *Fold rekursionen ud.* Hvert niveau tager ét element mindre, og PARTITION-prisen falder tilsvarende:

    #eq[$ T(n) = Theta(n) + Theta(n-1) + Theta(n-2) + dots.h + Theta(1) = Theta(sum_(i=1)^n i) $]

    + *Læg summen sammen.* Den aritmetiske sum er

    #eq[$ sum_(i=1)^n i = (n(n+1)) / 2 = Theta(n^2) $]

    Svar: $Theta(n^2)$.
  ],
)

#qcard(
  tag: [Sortering: værste-falds-køretid for QuickSort (Quicksort)],
  source: "MCQ juni 2021, Spm. 30",
  theory: <th-sort-quicksort>,
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
    Standard CLRS-QuickSort bruger Lomuto-partition med sidste element som pivot og sammenligner med $<=$. Den har ingen tre-vejs-deling, så ens nøgler gør ingen forskel — alle elementer $<= $ pivoten ryger til venstre, også dem der er lig pivoten. Med kun to forskellige værdier giver det maksimalt skæve splits.

    Lad os se det konkret på det lille input $[2, 1, 2, 1]$ ($n = 4$). Pivoten er altid sidste element:

    ```
    [2, 1, 2, 1]   pivot = A[4] = 1
      j=1: 2 > 1  spring over
      j=2: 1 <=1  swap ind   -> [1, 2, 2, 1]
      j=3: 2 > 1  spring over
      swap pivot ind          -> [1, 1, 2, 2]   pivot lander paa idx 2
    ```

    Pivoten $1$ ender på indeks $2$. Venstre del er $[1]$ (ét element), højre del er $[2, 2]$ (to elementer) — altså et split på $1$ og $2$ ud af $3$ resterende. Det er det skæve mønster, der gentager sig hele vejen ned.

    + *Skriv rekursionen op.* Fordi hvert PARTITION-kald kun skærer en konstant brøkdel fra og efterlader $Theta(n)$ i den ene del, koster det rekursivt:

    #eq[$ T(n) = T(n-1) + Theta(n) $]

    + *Løs den.* Foldet ud bliver det en aritmetisk sum:

    #eq[$ T(n) = Theta(n) + Theta(n-1) + dots.h + Theta(1) = Theta(sum_(i=1)^n i) = Theta(n^2) $]

    + *Tjek med sammenligningstallet.* Et fuldt Lomuto-trace giver $n^2 \/ 4$ sammenligninger: $n = 4 -> 4$, $n = 8 -> 16$, $n = 16 -> 64$. Det vokser kvadratisk, præcis som $Theta(n^2)$ forudsiger.

    Svar: $Theta(n^2)$.
  ],
)

#qcard(
  tag: [Sortering: hvilke er Θ(n²) i værste fald? (comparison sort)],
  source: "MCQ juni 2019, Spm. 27",
  theory: <th-sort-runtimes>,
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
    Værdiområdet er $[0, #swap[$n^2$])$, så $k = n^2$. Det betyder kun noget for de to distributionssorteringer; for de sammenligningsbaserede er værdiområdet støj, og kun det velkendte værste fald i $n$ tæller. Jeg går listen igennem én linje ad gangen.

    - *CountingSort* — distributionssortering, $Theta(n + k)$. Med $k = n^2$ er $Theta(n + n^2) = Theta(n^2)$, fordi $n^2$ dominerer $n$ ($n^2 \/ n = n -> infinity$). *Ja.*
    - *RadixSort, to cifre i base $n$* — to stabile counting sorts à $Theta(n + k)$ med cifferområde $k = n$, altså $Theta(n + n) = Theta(n)$ per gennemløb. To gennemløb: $2 dot Theta(n) = Theta(n)$. *Nej.*
    - *MergeSort* — deler altid midt over og fletter i $Theta(n)$ per niveau over $log n$ niveauer: $Theta(n log n)$ uanset input. *Nej.*
    - *TreeSort med rød-sort træ* — træet er balanceret, så hver af de $n$ indsættelser koster $O(log n)$. Inorder-gennemløbet er $Theta(n)$. Samlet $Theta(n log n)$. *Nej.*
    - *TreeSort med ubalanceret søgetræ* — på allerede sorteret input degenererer træet til en kæde (hver ny nøgle hænges yderst til højre). Indsættelse nummer $i$ vandrer forbi de $i - 1$ tidligere knuder, så prisen er $sum_(i=1)^n (i - 1) = (n(n-1)) / 2 = Theta(n^2)$. *Ja.*
    - *QuickSort* — Lomuto med sidste element som pivot rammer maksimalt skæve splits på sorteret input: $T(n) = T(n-1) + Theta(n) = Theta(sum_(i=1)^n i) = Theta(n^2)$. *Ja.*
    - *InsertionSort* — på omvendt sorteret input skal hvert element skubbes forbi alle de tidligere: $sum_(i=1)^n (i-1) = Theta(n^2)$. *Ja.*

    De fire med $Theta(n^2)$ i værste fald er altså CountingSort, ubalanceret TreeSort, QuickSort og InsertionSort.

    Svar: CountingSort, ubalanceret TreeSort, QuickSort og InsertionSort.
  ],
)

#qcard(
  tag: [QuickSort: kør PARTITION i hånden (Lomuto)],
  source: "MCQ juni 2019, Spm. 11",
  theory: <th-sort-quicksort>,
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
    Pivoten er sidste element, $x = A[7] = 3$. Grænsen starter på $i = p - 1 = 0$, altså lige før udsnittet, og $j$ løber fra $1$ til $6$. Reglen: rammer $j$ et tal $<= 3$, så ryk $i$ ét frem og swap $A[i]$ med $A[j]$; ellers lad det ligge.

    Hele arrayet vises på hver linje, så swappene er nemme at følge:

    ```
    Start: [ 6, 2, 4, 5, 1, 7, 3 ]   pivot x = A[7] = 3, i = 0

    j=1:   [ 6, 2, 4, 5, 1, 7, 3 ]    6 > 3:  gør intet
    j=2:   [ 2, 6, 4, 5, 1, 7, 3 ]    2 <= 3: i=1, swap idx 1 & 2
    j=3:   [ 2, 6, 4, 5, 1, 7, 3 ]    4 > 3:  gør intet
    j=4:   [ 2, 6, 4, 5, 1, 7, 3 ]    5 > 3:  gør intet
    j=5:   [ 2, 1, 4, 5, 6, 7, 3 ]    1 <= 3: i=2, swap idx 2 & 5
    j=6:   [ 2, 1, 4, 5, 6, 7, 3 ]    7 > 3:  gør intet
    ```

    Efter løkken er $i = 2$, så alle tal $<= 3$ ($2$ og $1$) ligger forrest på indeks $1..2$. Sidste skridt swapper pivoten $A[7]$ med det første store tal, $A[i+1] = A[3] = 4$, så pivoten lander på sin endelige plads:

    ```
    Slut:  [ 2, 1, 3, 5, 6, 7, 4 ]   swap pivot idx 7 & idx 3
    ```

    Pivoten $3$ står nu på indeks $3$ med mindre tal til venstre og større til højre.

    Svar: $A = [2, 1, 3, 5, 6, 7, 4]$.
  ],
)

#qcard(
  tag: [QuickSort: kør PARTITION i hånden (Lomuto)],
  source: "MCQ juni 2021, Spm. 11",
  theory: <th-sort-quicksort>,
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
    Stykket er indeks 4..13, så pivoten er $x = A[13] = 13$. Grænsen $i$ starter på $3$, lige uden for stykket, og $j$ løber fra $4$ til $12$. Reglen: rammer $j$ et tal $<= 13$, så ryk $i$ ét frem og swap $A[i]$ med $A[j]$; ellers lad det ligge.

    Herunder vises kun delstykket (indeks 4..13), så de enkelte swaps er nemme at følge:

    ```
    Start: [ 14,  9, 18,  6,  1, 26, 15, 30,  7, 13 ]

    j=4:   [ 14,  9, 18,  6,  1, 26, 15, 30,  7, 13 ]   14 > 13: gør intet
    j=5:   [  9, 14, 18,  6,  1, 26, 15, 30,  7, 13 ]    9 <= 13: swap idx 4 & 5
    j=6:   [  9, 14, 18,  6,  1, 26, 15, 30,  7, 13 ]   18 > 13: gør intet
    j=7:   [  9,  6, 18, 14,  1, 26, 15, 30,  7, 13 ]    6 <= 13: swap idx 5 & 7
    j=8:   [  9,  6,  1, 14, 18, 26, 15, 30,  7, 13 ]    1 <= 13: swap idx 6 & 8
    j=9:   [  9,  6,  1, 14, 18, 26, 15, 30,  7, 13 ]   26 > 13: gør intet
    j=10:  [  9,  6,  1, 14, 18, 26, 15, 30,  7, 13 ]   15 > 13: gør intet
    j=11:  [  9,  6,  1, 14, 18, 26, 15, 30,  7, 13 ]   30 > 13: gør intet
    j=12:  [  9,  6,  1,  7, 18, 26, 15, 30, 14, 13 ]    7 <= 13: swap idx 7 & 12
    ```

    Efter løkken står alle tal $<= 13$ forrest i stykket (indeks 4..7), og $i$ er endt på $7$. Sidste skridt swapper pivoten $A[13]$ med det første store tal, $A[i+1] = A[8]$, så den lander mellem de små og de store:

    ```
    Slut:  [  9,  6,  1,  7, 13, 26, 15, 30, 14, 18 ]   swap pivot idx 13 & idx 8
    ```

    Splejs så de uberørte ender på igen ($21, 17, 28$ foran, $19, 2$ bagved):

    #eq[$ A = 21, 17, 28, thin 9, 6, 1, 7, 13, 26, 15, 30, 14, 18, thin 19, 2 $]

    Svar: $A = [21, 17, 28, 9, 6, 1, 7, 13, 26, 15, 30, 14, 18, 19, 2]$.
  ],
)

#qcard(
  tag: [QuickSort: kør PARTITION i hånden (Lomuto)],
  source: "MCQ juni 2025, Spm. 11",
  theory: <th-sort-quicksort>,
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
  tag: [QuickSort: hvilken værdi var pivot? (Lomuto)],
  source: "MCQ juni 2025, Spm. 12 (flere rigtige)",
  theory: <th-sort-quicksort>,
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
    Lomuto efterlader pivoten på sin endelige sorterede plads $q$: alt på indeks $1..q-1$ er $<$ pivoten, og alt på $q+1..9$ er $>$ pivoten. Da arrayet indeholder netop ${1, dots.h, 9}$, er den sorterede plads for værdien $v$ præcis indeks $v$. En værdi $v$ kan altså kun have været pivot, hvis den nu står på indeks $v$ med alt mindre til venstre og alt større til højre. Det er kun en nødvendig betingelse, men det er det opgaven beder os tjekke.

    Array med indeks under hvert tal:

    ```
    idx:  1  2  3  4  5  6  7  8  9
    A  :  2  1  3  4  6  5  8  7  9
    ```

    Tjek hver $p$ med kravet $A[p] = p$, venstre alle $< p$, højre alle $> p$:

    - $p = 1$: $A[1] = 2 != 1$. Nej.
    - $p = 2$: $A[2] = 1 != 2$. Nej.
    - $p = 3$: $A[3] = 3$; venstre ${2, 1}$ alle $< 3$, højre ${4, 6, 5, 8, 7, 9}$ alle $> 3$. Ja.
    - $p = 4$: $A[4] = 4$; venstre ${2, 1, 3}$ alle $< 4$, højre ${6, 5, 8, 7, 9}$ alle $> 4$. Ja.
    - $p = 5$: $A[5] = 6 != 5$. Nej.
    - $p = 6$: $A[6] = 5 != 6$. Nej.
    - $p = 7$: $A[7] = 8 != 7$. Nej.
    - $p = 8$: $A[8] = 7 != 8$. Nej.
    - $p = 9$: $A[9] = 9$; venstre ${2, 1, 3, 4, 6, 5, 8, 7}$ alle $< 9$, højre er tom. Ja.

    Læg mærke til at parrene $(6, 5)$ og $(8, 7)$ står "byttet om": de kan ikke selv have været pivot, for ingen af dem står på sin sorterede plads. Kun $3$, $4$ og $9$ opfylder alle tre krav.

    Svar: $3$, $4$ og $9$.
  ],
)

#qcard(
  tag: [CountingSort: trace tælle-arrayet C (Counting sort)],
  source: "MCQ juni 2023, Spm. 11",
  theory: <th-sort-counting>,
  prompt: [Et array af ni heltal med værdier $0..6$: $A = #swap[$[2, 0, 6, 2, 3, 5, 5, 1, 2]$]$ (indeks 1..9). Kør COUNTING-SORT($A$, 9, 6) med et array $C$ med syv pladser (0..6). Hvad er summen af de syv heltal i $C$ ved terminering?],
  options: (
    [$0$],
    [$6$],
    [$9$],
    [$22$],
    [$28$],
    [$37$],
  ),
  answer: [(e) $28$.],
  blueprint: [
    Dobbeltfælden: $C$ ender hverken med de rå tællinger eller med prefix-summerne. CLRS' sidste løkke (placeringen) tæller $C$ ned igen, så ved terminering er $C[i]$ antallet af værdier mindre end $i$.

    + *Tæl forekomster.* $C[i]$ = antal elementer lig $i$.
    + *Lav prefix-summer.* $C[i] "+=" C[i-1]$ fra venstre giver antal $<= i$.
    + *Placeringen tæller ned.* Hvert element trækker $1$ fra sin $C$-plads, så plads $i$ mister $"tæl"[i]$. Tilbage står $C[i] = $ antal $< i$ — det er $C$ ved terminering.
    + *Regn så det opgaven spørger om* (her summen) på dette $C$.
  ],
  worked: [
    Array: #swap[$[2, 0, 6, 2, 3, 5, 5, 1, 2]$], værdier $0..6$. COUNTING-SORT stopper ikke ved prefix-summerne: placeringsløkken til sidst ($C[A[j]] "-=" 1$ for hvert element) tæller hver plads ned igen. Det er det nedtalte $C$, vi skal summere.

    + *Tæl forekomster.* Løb $A$ igennem og tæl hver værdi (indeks $0..6$ i $C$):

      ```
      værdi:  0   1   2   3   4   5   6
      tæl:    1   1   3   1   0   2   1
      ```

      Tjek: $1 + 1 + 3 + 1 + 0 + 2 + 1 = 9 = n$.

    + *Lav prefix-summer.* $C[i] "+=" C[i-1]$ fra venstre, så $C[i]$ er antal værdier $<= i$:

      ```
      C[0]=1   C[1]=2   C[2]=5   C[3]=6   C[4]=6   C[5]=8   C[6]=9
      ```

    + *Placeringsløkken tæller ned.* For hvert af de $9$ elementer: $B[C[A[j]]] = A[j]$, dernæst $C[A[j]] "-=" 1$. Plads $i$ tælles ned $"tæl"[i]$ gange, så slut-værdien er $"prefix"[i] - "tæl"[i]$, dvs. antal værdier $< i$:

      ```
      C_slut[i] = prefix[i] - tæl[i]:
      C[0] = 1 - 1 = 0
      C[1] = 2 - 1 = 1
      C[2] = 5 - 3 = 2
      C[3] = 6 - 1 = 5
      C[4] = 6 - 0 = 6
      C[5] = 8 - 2 = 6
      C[6] = 9 - 1 = 8
      ```

      Altså $C = [0, 1, 2, 5, 6, 6, 8]$ ved terminering.

    + *Summér.* $0 + 1 + 2 + 5 + 6 + 6 + 8 = 28$. Genvej: sum af prefix minus sum af tæl, $37 - 9 = 28$.

    Svar: $28$.
  ],
)

#qcard(
  tag: [CountingSort: trace tælle-arrayet C (Counting sort)],
  source: "MCQ juni 2025, Spm. 19",
  theory: <th-sort-counting>,
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
  answer: [(e) $23$.],
  blueprint: [
    Samme fælde som i nabokortet: COUNTING-SORT er ikke færdig efter tælle-fasen. Prefix-summerne og dernæst placeringsløkkens nedtælling kører bagefter, så ved terminering er $C[i]$ antallet af værdier mindre end $i$.

    + *Tæl forekomster.* $C[i]$ = antal elementer lig $i$ (summen her er $n$).
    + *Lav prefix-summer.* $C[i] "+=" C[i-1]$ giver antal $<= i$.
    + *Placeringen tæller ned.* Plads $i$ mister $"tæl"[i]$, så $C[i] = $ antal $< i$.
    + *Summér* det nedtalte $C$.
  ],
  worked: [
    Array: #swap[$[2, 2, 5, 1, 3, 5, 2, 3, 2, 5, 2]$], værdier $0..5$. "Ved terminering" betyder efter hele COUNTING-SORT — også prefix-summer og placeringsløkkens nedtælling, ikke kun tælle-fasen.

    + *Tæl forekomster.* Gå rækken igennem og før streg ved hver værdi:

      - værdi $0$: optræder $0$ gange.
      - værdi $1$: optræder $1$ gang (position $4$).
      - værdi $2$: optræder $5$ gange (positionerne $1, 2, 7, 9, 11$).
      - værdi $3$: optræder $2$ gange (positionerne $5, 8$).
      - værdi $4$: optræder $0$ gange.
      - værdi $5$: optræder $3$ gange (positionerne $3, 6, 10$).

      ```
      værdi:  0   1   2   3   4   5
      tæl:    0   1   5   2   0   3
      ```

      Tjek: $0 + 1 + 5 + 2 + 0 + 3 = 11 = n$.

    + *Lav prefix-summer.* $C[i] "+=" C[i-1]$ giver antal værdier $<= i$:

      ```
      C[0]=0   C[1]=1   C[2]=6   C[3]=8   C[4]=8   C[5]=11
      ```

    + *Placeringsløkken tæller ned.* Plads $i$ tælles ned $"tæl"[i]$ gange, så slut-værdien er $"prefix"[i] - "tæl"[i]$, dvs. antal værdier $< i$:

      ```
      C_slut[i] = prefix[i] - tæl[i]:
      C[0] =  0 - 0 = 0
      C[1] =  1 - 1 = 0
      C[2] =  6 - 5 = 1
      C[3] =  8 - 2 = 6
      C[4] =  8 - 0 = 8
      C[5] = 11 - 3 = 8
      ```

      Altså $C = [0, 0, 1, 6, 8, 8]$ ved terminering.

    + *Summér.* $0 + 0 + 1 + 6 + 8 + 8 = 23$. Genvej: sum af prefix minus sum af tæl, $34 - 11 = 23$.

    Svar: $23$.
  ],
)

#qcard(
  tag: [RadixSort: kør trace i hånden (Radix sort)],
  source: "MCQ juni 2017, Spm. 9",
  theory: <th-sort-radix>,
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
    LSD radix sort kører en stabil counting sort per ciffer, fra enere og opefter. Efter $k$ gennemløb er arrayet sorteret på de $k$ laveste cifre, og elementer med samme ciffer beholder den indbyrdes orden fra det forrige gennemløb. Tre af fire iterationer betyder enere, tiere og hundreder.

    Start: #swap[$[2452, 5363, 4433, 1413, 2433, 3222, 2121]$].

    + *Gennemløb 1 — enere.* Enercifrene er $2, 3, 3, 3, 3, 2, 1$. Grupér stabilt efter ener (bevar rækkefølgen inden for hver gruppe):

      ```
      ener 1:  2121
      ener 2:  2452, 3222
      ener 3:  5363, 4433, 1413, 2433
      ```

      Sat efter hinanden: $[2121, 2452, 3222, 5363, 4433, 1413, 2433]$.

    + *Gennemløb 2 — tiere.* Tiercifrene af det nye array ($2121, 2452, 3222, 5363, 4433, 1413, 2433$) er $2, 5, 2, 6, 3, 1, 3$. Grupér stabilt efter tier:

      ```
      tier 1:  1413
      tier 2:  2121, 3222
      tier 3:  4433, 2433
      tier 5:  2452
      tier 6:  5363
      ```

      Sat efter hinanden: $[1413, 2121, 3222, 4433, 2433, 2452, 5363]$.

    + *Gennemløb 3 — hundreder.* Hundredecifrene af det array ($1413, 2121, 3222, 4433, 2433, 2452, 5363$) er $4, 1, 2, 4, 4, 4, 3$. Grupér stabilt efter hundrede:

      ```
      hund. 1:  2121
      hund. 2:  3222
      hund. 3:  5363
      hund. 4:  1413, 4433, 2433, 2452
      ```

      Sat efter hinanden: $[2121, 3222, 5363, 1413, 4433, 2433, 2452]$.

    Svar: $[2121, 3222, 5363, 1413, 4433, 2433, 2452]$.
  ],
)

#qcard(
  tag: [RadixSort: kør trace i hånden (Radix sort)],
  source: "MCQ juni 2025, Spm. 20",
  theory: <th-sort-radix>,
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
    LSD radix sort kører en stabil counting sort per ciffer, fra enere og opefter. To af fire iterationer betyder de to laveste cifre: enere, så tiere.

    Start: #swap[$[0113, 4102, 4440, 2240, 2213, 2340]$].

    + *Gennemløb 1 — enere.* Enercifrene er $3, 2, 0, 0, 3, 0$. Grupér stabilt efter ener (bevar rækkefølgen inden for hver gruppe):

      ```
      ener 0:  4440, 2240, 2340
      ener 2:  4102
      ener 3:  0113, 2213
      ```

      Sat efter hinanden: $[4440, 2240, 2340, 4102, 0113, 2213]$.

    + *Gennemløb 2 — tiere.* Tiercifrene af det nye array ($4440, 2240, 2340, 4102, 0113, 2213$) er $4, 4, 4, 0, 1, 1$. Grupér stabilt efter tier:

      ```
      tier 0:  4102
      tier 1:  0113, 2213
      tier 4:  4440, 2240, 2340
      ```

      Sat efter hinanden: $[4102, 0113, 2213, 4440, 2240, 2340]$.

    Bemærk, at $4440, 2240, 2340$ stadig står i den rækkefølge, de fik i gennemløb 1 — det er stabiliteten, der bærer den orden videre.

    Svar: $[4102, 0113, 2213, 4440, 2240, 2340]$.
  ],
)

#qcard(
  tag: [Sortering: køretid for InsertionSort (Insertion sort)],
  source: "MCQ juni 2021, Spm. 28",
  theory: <th-sort-insertion>,
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
    InsertionSort tager ét element ad gangen og skubber det til venstre forbi alle større elementer i det allerede sorterede præfiks. Prisen på element $i$ er derfor antallet af elementer foran det, der er større end det — antallet af inversioner det indgår i. Samlet tid er $Theta(n + "antal inversioner")$.

    Input: #swap[$2, 1, 2, 1, dots.h$]. Lad os først følge det lille tilfælde $[2, 1, 2, 1]$ ($n = 4$). Det venstre stykke er det sorterede præfiks, og tallet i hånden står i parentes:

    ```
    Start:      [ 2 | 1, 2, 1 ]
    indsæt (1): 1 < 2, skub 2 til højre   -> [ 1, 2 | 2, 1 ]   1 skift
    indsæt (2): 2 >= 2, bliver hvor det er -> [ 1, 2, 2 | 1 ]   0 skift
    indsæt (1): 1 < 2,2 skub begge frem    -> [ 1, 1, 2, 2 ]    2 skift
    ```

    Det giver $1 + 0 + 2 = 3$ skift for $n = 4$.

    + *Hvor mange skift i alt?* Når det $k$.-te "$1$" skal ind, ligger der allerede $k$ stykker "$2$" forrest i præfikset (alle de $2$-er, der kom før), og det "$1$" må skubbe forbi dem alle — $k$ skift. De "$2$"-er, der indsættes, koster $0$, for de er $>=$ alt foran sig.
    + *Summér.* Der er $n\/2$ stykker "$1$", det $k$.-te koster $k$ skift:

      #eq[$ sum_(k=1)^(n\/2) k = ((n\/2)(n\/2 + 1)) / 2 approx n^2 / 8 $]

      Et trace bekræfter væksten: $n = 4, 8, 16$ giver $3, 10, 36$ skift — kvadratisk.
    + *Konkludér.* Inputtet har $Theta(n^2)$ inversioner, så samlet tid er $Theta(n^2)$.

    Svar: $Theta(n^2)$.
  ],
)

#qcard(
  tag: [Sortering: køretid for Heapsort på ens nøgler (Heapsort)],
  source: "MCQ juni 2019, Spm. 28",
  theory: <th-sort-heapsort>,
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
    HEAPSORT er to faser: BUILD-MAX-HEAP, der kalder SIFT-DOWN på de $floor(n\/2)$ indre knuder nedefra og op, og derefter $n - 1$ runder af EXTRACT-MAX, der hver bytter roden ned bagest og kalder én SIFT-DOWN på den nye rod. Prisen for HEAPSORT er summen af alle disse SIFT-DOWN-kald, og en SIFT-DOWN koster så mange niveauer, som knuden faktisk synker.

    Input: #swap[$n$] ens elementer, fx alle lig $v$.

    + *Hvornår synker en knude?* SIFT-DOWN bytter kun, hvis knuden er strengt mindre end et af sine børn. Den finder det største barn og stopper, så snart knuden er $>=$ begge børn.
    + *Med ens nøgler.* Forælder og børn er alle $v$, så $v >= v$ er altid sandt. Ingen knude er nogensinde strengt mindre end et barn, så hvert SIFT-DOWN-kald laver sine op til to sammenligninger på første niveau og stopper med det samme — $O(1)$ per kald. (Arrayet er i forvejen en gyldig max-heap og ændrer sig aldrig.)
    + *Tæl kaldene.* Build-fasen laver $floor(n\/2)$ kald, udtræk-fasen $n - 1$ kald, altså $O(n)$ kald i alt — hver $O(1)$:

      #eq[$ (floor(n\/2) + (n-1)) dot O(1) = O(n) $]

    Det er særtilfældet: normalt koster en SIFT-DOWN op til $O(log n)$, men her stopper alle på første niveau.

    Svar: $O(n)$.
  ],
)
