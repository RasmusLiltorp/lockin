#import "../lib.typ": *

=== Sortering (skriftlige eksamener)

Sorteringsopgaverne kommer i nogle få varianter. Nogle beder dig designe en sortering, der udnytter struktur i input — få distinkte værdier, små heltal, 0/1-nøgler. Andre vil have dig til at køre Radix-Sort eller Counting-Sort i hånden, eller aflæse køretider for Insertion-, Merge-, Quick-, Heap-, Counting- og Radix-Sort på et bestemt input. Og så er der den klassiker, hvor du tæller inversioner (inversions) med en let pyntet mergesort (merge sort).

#qcard(
  tag: [Sortér med få distinkte værdier],
  source: "DM02 januar 2005, Opg. 5 (20%)",
  prompt: [
    Sortér $n$ heltal i tid #swap[$O(n log log n)$] når der kun er #swap[$O(log n)$] distinkte værdier. Tallene kan være astronomisk store, så du må kun *sammenligne* dem ($O(1)$ pr. sammenligning) — du må ikke indeksere på værdien (Radix-/Counting-Sort på værdiintervallet er udelukket). \
    *(a)* Beskriv en algoritme og argumentér for køretiden $O(n log log n)$. \
    *(b)* Vis hvordan den sorterede følge læses ud og udskrives i tid #swap[$O(n)$].
  ],
  answer: [(a) Balanceret søgetræ (balanced search tree) med (værdi, antal)-knuder; $n dot O(log d) = O(n log log n)$ når $d = O(log n)$. (b) Inorden-gennemløb (in-order traversal), udskriv hver værdi `antal` gange: $O(d + n) = O(n)$.],
  blueprint: [
    Udnyt at der kun er få *distinkte* nøgler: gem dem i en struktur med en multiplicitetstæller.

    + Hold en balanceret søgestruktur (rød-sort træ (red-black tree), 2-3 træ (2-3 tree) — noget med $O(log "størrelse")$ pr. operation) med én knude pr. distinkt værdi, hver med et tæller-felt.
    + For hvert af de $n$ input: søg efter værdien. Findes den, tæl tælleren op; ellers indsæt en ny knude med tæller 1.
    + Lad $d$ være antal distinkte værdier. Træet har højst $d$ knuder, så hver søgning/indsættelse koster $O(log d)$. Med #swap[$d = O(log n)$] er $log d = O(log log n)$, og i alt $n dot O(log log n)$.
    + *Udlæsning.* Inorden-gennemløb besøger værdierne i voksende orden. Udskriv hver (værdi, antal) som `antal` kopier: $O(d)$ for gennemløbet plus $O(n)$ udskrivninger.
  ],
  worked: [
    Brug et balanceret søgetræ med knuder $("værdi", "antal")$.

    + *Indsætning.* `for hvert input x: søg x i træet; hvis fundet: antal += 1; ellers: indsæt (x, 1)`.
    + *Køretid.* Træet rummer aldrig mere end $d$ knuder, så søg/indsæt koster $O(log d)$. Givet $d = O(log n)$:
      #eq[$ log d = log(O(log n)) = O(log log n). $]
      Over alle $n$ elementer: $n dot O(log log n) = O(n log log n)$. Tallenes størrelse er ligegyldig — vi sammenligner kun, indekserer aldrig på værdien.
    + *(b) Udlæsning.* Inorden-gennemløb (venstre, knude, højre) besøger værdierne stigende. Ved hver knude udskrives `værdi` præcis `antal` gange. Gennemløbet rører $d$ knuder i $O(d)$, og der udskrives $sum "antal" = n$ tal. Da $d = O(log n) = O(n)$ er totalen $O(d + n) = O(n)$.
  ],
)

#qcard(
  tag: [Inversioner: tæl og vælg sortering],
  source: "DM02 januar 2006, Opg. 2 (25%)",
  prompt: [
    En inversion er et par $(x, y)$ med $x > y$ hvor $x$ står før $y$ i følgen. \
    *(a)* Hvad er det største antal inversioner i en følge af $n$ tal, og hvordan ser sådan en følge ud? \
    *(b)* Modificér mergesort så den returnerer antallet af inversioner i tid #swap[$O(n log n)$] (kun tælle, ikke liste; antag distinkte værdier). \
    *(c)* Vælg sorteringen med mindst asymptotisk værstefald i hvert tilfælde: #swap[(1) $O(n)$ inversioner; (2) $O(n log n)$ inversioner, heltal i $0..n^2-1$; (3) $O(n^2)$ inversioner].
  ],
  answer: [(a) $n(n-1)\/2$, opnået af en strengt aftagende (omvendt sorteret) følge. (b) Tæl krydsende inversioner under merge. (c) (1) Insertion-Sort $O(n)$; (2) Radix-Sort $O(n)$; (3) Merge-/Heap-Sort $O(n log n)$.],
  blueprint: [
    Inversioner deler sig i tre grupper: helt i venstre halvdel, helt i højre, og *krydsende* (venstre-element større end et højre). Tæl rekursivt i hver halvdel og krydsende under merge. Til (c): match input-strukturen til en sortering der udnytter den.

    + *Maks.* Hvert uordnet positionspar er højst én inversion, og der er $binom(n, 2)$ par. Maksimum nås når hvert par er en inversion, dvs. følgen er strengt aftagende.
    + *Tælling under merge.* Når du tager et element fra *højre* halvdel før venstre er tom, er det højre-element mindre end alle resterende venstre-elementer (venstre er sorteret) og står efter dem — hver er en inversion. Læg antallet af resterende venstre-elementer til.
    + *Valg af sortering.* Få inversioner ($I$) $->$ Insertion-Sort i $Theta(n + I)$. Lille heltalsinterval $->$ Counting-/Radix-Sort. Ellers $->$ Merge-/Heap-Sort med $O(n log n)$ i værstefald.
  ],
  worked: [
    + *(a)* Der er $binom(n, 2)$ positionspar, hvert højst én inversion, så maksimum er
      #eq[$ binom(n, 2) = (n(n-1))/2, $]
      nået når hvert par er en inversion, dvs. følgen er sorteret faldende.

    + *(b)* `SortAndCount(A)`: del i $L, R$; tæl rekursivt $c_L, c_R$; flet og tæl $c_M$; returnér $c_L + c_R + c_M$. I `MergeAndCount`, når `L[i] <= R[j]` tag `L[i]`; ellers tag `R[j]` og læg `|L| - i` til `count` (alle resterende venstre er større). Samme rekursion som mergesort, $T(n) = 2 T(n\/2) + O(n) = O(n log n)$.

    + *(c)*
      - (1) $O(n)$ inversioner: Insertion-Sort kører $Theta(n + I) = O(n + n) = O(n)$. Hvert indre skift fjerner præcis én inversion.
      - (2) $O(n log n)$ inversioner, heltal i $0..n^2-1$: inversionsgrænsen ville give Insertion-Sort $O(n log n)$ — ingen gevinst. Brug Radix-Sort med grundtal $n$: to cifre, hvert en Counting-Sort over $n$ værdier, $Theta(2(n + n)) = Theta(n)$.
      - (3) $O(n^2)$ inversioner: ingen struktur at udnytte ($n^2$ er maks). Brug en sammenligningssortering (comparison sort) med $O(n log n)$ værstefald (Merge- eller Heap-Sort).
  ],
)

#qcard(
  tag: [Radix-Sort: kør i hånden],
  source: "DM507 juni 2008, Opg. 1a (5%)",
  prompt: [
    Kør Radix-Sort med grundtal 10 på #swap[$747, 765, 544, 754, 431, 231, 222$]. Vis resultatet efter hver iteration (pass).
  ],
  answer: [Efter ener: $431, 231, 222, 544, 754, 765, 747$. Efter tier: $222, 431, 231, 544, 747, 754, 765$. Efter hundreder: $222, 231, 431, 544, 747, 754, 765$.],
  blueprint: [
    Radix-Sort er LSD: sortér efter mindst betydende ciffer først, så det næste, op til det mest betydende. Med grundtal 10 ét pass pr. decimalt ciffer.

    + Antal pass = antal cifre i det største tal.
    + Hvert pass er en *stabil* (stable) fordeling i 10 spande ($0..9$) efter det aktuelle ciffer, derefter sammensæt spand $0..9$ i orden.
    + Stabilitet (bevar tidligere-ankomne først i samme spand) er det der gør hele algoritmen korrekt.
  ],
  worked: [
    Tallene har 3 cifre, så 3 pass.

    + *Pass 1, enere* (cifre $7,5,4,4,1,1,2$):
      #eq[$ 431, 231, 222, 544, 754, 765, 747. $]
    + *Pass 2, tiere* (cifre $3,3,2,4,5,6,4$):
      #eq[$ 222, 431, 231, 544, 747, 754, 765. $]
    + *Pass 3, hundreder* (cifre $2,4,2,5,7,7,7$):
      #eq[$ 222, 231, 431, 544, 747, 754, 765. $]

    Endeligt sorteret: $222, 231, 431, 544, 747, 754, 765$.
  ],
)

#qcard(
  tag: [Radix-Sort: kør i hånden],
  source: "DM507 juni 2014, Opg. 5 (6%)",
  prompt: [
    Givet #swap[$A = [8345, 7112, 1830, 5001, 4345, 2222, 9112, 6363]$], kør `Radix-Sort(A, 4)` (4 cifre, grundtal 10, mindst betydende først, stabil). Vis $A$ efter tre af de fire iterationer.
  ],
  answer: [Efter ener: $[1830, 5001, 7112, 2222, 9112, 6363, 8345, 4345]$. Efter tier: $[5001, 7112, 9112, 2222, 1830, 8345, 4345, 6363]$. Efter hundreder: $[5001, 7112, 9112, 2222, 8345, 4345, 6363, 1830]$.],
  blueprint: [
    Pass $d = 0$ (enere) op til $d = 3$ (tusinder). Hvert pass er en stabil Counting-Sort på det cifre, der bevarer tidligere orden ved uafgjorte.

    + Læs det aktuelle ciffer af hvert tal.
    + Fordel stabilt i spande $0..9$ og sammensæt.
    + Gentag for næste mere betydende ciffer.
  ],
  worked: [
    + *Iter 1 (enere):* $[1830, 5001, 7112, 2222, 9112, 6363, 8345, 4345]$.
    + *Iter 2 (tiere):* $[5001, 7112, 9112, 2222, 1830, 8345, 4345, 6363]$.
    + *Iter 3 (hundreder):* $[5001, 7112, 9112, 2222, 8345, 4345, 6363, 1830]$.
    + *Iter 4 (tusinder), færdig:* $[1830, 2222, 4345, 5001, 6363, 7112, 8345, 9112]$.

    Tre af de fire mellemtilstande besvarer opgaven.
  ],
)

#qcard(
  tag: [Counting-Sort: tæl-array C],
  source: "DM507 juni 2013, Opg. 5b (5%)",
  prompt: [
    Counting-Sort på værdier #swap[$0..7$]. Med CLRS-pseudokoden (s. 195): hvad er array `C` efter at den kumulative løkke er kørt? Input #swap[$A = 7, 4, 1, 2, 6, 4, 0, 4, 4, 4, 7, 2$]. Giv `C` fra venstre til højre.
  ],
  answer: [$C = 1, 2, 4, 4, 9, 9, 10, 12$ (antal elementer $<= i$).],
  blueprint: [
    CLRS sætter først `C[i]` = antal forekomster af værdien $i$, og overskriver så `C[i] = C[i] + C[i-1]`, så `C[i]` til sidst er antal elementer $<= i$.

    + Tæl forekomster af hver værdi $0..k$.
    + Tag løbende præfikssummer (prefix sums) fra venstre.
    + Den kumulative `C[i]` er antallet af elementer med nøgle $<= i$.
  ],
  worked: [
    + *Tæl pr. værdi $0..7$:* $0 -> 1,  1 -> 1,  2 -> 2,  3 -> 0,  4 -> 5,  5 -> 0,  6 -> 1,  7 -> 2$, altså
      #eq[$ C = [1, 1, 2, 0, 5, 0, 1, 2]. $]
    + *Præfikssummer:*
      #eq[$ C = [1, 2, 4, 4, 9, 9, 10, 12]. $]
    Sidste indgang $12$ = antal elementer, hvilket passer.
  ],
)

#qcard(
  tag: [Sorteringskøretider på et givet input],
  source: "DM507 juni 2008, Opg. 1b (10%)",
  prompt: [
    Angiv bedstefald (best case), værstefald (worst case) og "sorteret input" for #swap[Insertion-Sort, Merge-Sort, Quicksort]. Begrund.
  ],
  answer: [Insertion: $Theta(n) \/ Theta(n^2) \/ Theta(n)$. Merge: $Theta(n log n)$ i alle tre. Quicksort (fast pivot = sidste element): $Theta(n log n) \/ Theta(n^2) \/ Theta(n^2)$.],
  blueprint: [
    Husk hver algoritmes omkostning som funktion af input-ordenen.

    + *Insertion-Sort:* bedst på allerede sorteret (én sammenligning pr. element, $Theta(n)$); værst omvendt sorteret ($sum i = Theta(n^2)$). Sorteret input er netop bedstefaldet.
    + *Merge-Sort:* deler altid midt over og fletter lineært, $T(n) = 2 T(n\/2) + Theta(n) = Theta(n log n)$ uanset input.
    + *Quicksort (fast pivot):* bedst ved balancerede partitioner, $Theta(n log n)$; værst ved maksimalt ubalancerede ($n-1$ mod $0$), $Theta(n^2)$. Med fast pivot er *allerede sorteret input værstefaldet*.
  ],
  worked: [
    #table(
      columns: 4,
      stroke: 0.4pt + hair,
      [], [*Bedst*], [*Værst*], [*Sorteret*],
      [Insertion-Sort], [$Theta(n)$], [$Theta(n^2)$], [$Theta(n)$],
      [Merge-Sort], [$Theta(n log n)$], [$Theta(n log n)$], [$Theta(n log n)$],
      [Quicksort], [$Theta(n log n)$], [$Theta(n^2)$], [$Theta(n^2)$],
    )

    Quicksort med fast sidste-element-pivot peeler ét element af pr. partition på sorteret input, $T(n) = T(n-1) + Theta(n) = Theta(n^2)$. Randomiseret pivot ville give forventet $Theta(n log n)$ på sorteret input — angiv hvilken variant du antager.
  ],
)

#qcard(
  tag: [Sorteringskøretider på et givet input],
  source: "DM507 juni 2011, Opg. 3 (24%)",
  prompt: [
    $n$ nøgler, heltal i intervallet #swap[$0..n^5$]. To input: #swap[(1) alle distinkte, omvendt sorteret; (2) alle nøgler ens]. Angiv køretiden for hvert tilfælde for #swap[Insertion-Sort, Quicksort (fast sidste-element-pivot), Heapsort, Radix-Sort].
  ],
  answer: [Insertion: (1) $Theta(n^2)$, (2) $Theta(n)$. Quicksort: (1) $Theta(n^2)$, (2) $Theta(n^2)$. Heapsort: $Theta(n log n)$ begge. Radix-Sort: $Theta(n)$ begge.],
  blueprint: [
    + *Insertion-Sort:* omvendt sorteret er værstefald (hvert element skifter hele vejen); alle ens giver med testen `A[i] > nøgle` ingen flytninger, $Theta(n)$.
    + *Quicksort:* omvendt sorteret $->$ pivot er minimum hver gang $->$ split $0$ mod $n-1$; alle ens $->$ standard-PARTITION lægger alt på én side. Begge $Theta(n^2)$.
    + *Heapsort:* $Theta(n log n)$ på ethvert input (BUILD i $O(n)$, $n$ extract-max à $O(log n)$).
    + *Radix-Sort:* skriv nøgler i grundtal $n$. Interval $0..n^5$ giver #swap[$d = 5$] cifre, hvert pass en Counting-Sort i $O(n + n) = O(n)$, total $Theta(5n) = Theta(n)$ — uafhængigt af input-orden.
  ],
  worked: [
    #table(
      columns: 3,
      stroke: 0.4pt + hair,
      [], [*Omvendt sorteret*], [*Alle ens*],
      [Insertion-Sort], [$Theta(n^2)$], [$Theta(n)$],
      [Quicksort], [$Theta(n^2)$], [$Theta(n^2)$],
      [Heapsort], [$Theta(n log n)$], [$Theta(n log n)$],
      [Radix-Sort], [$Theta(n)$], [$Theta(n)$],
    )

    Radix: $n^5$ i grundtal $n$ er "$100000$", så nøgler $< n^5$ fylder $5$ base-$n$-cifre. Generelt: nøgler i $0..n^k$ giver grundtal $n$, $d = k+1$ cifre, $Theta((k+1) n) = Theta(n)$ for konstant $k$.
  ],
)

#qcard(
  tag: [Sorteringskøretider på et givet input],
  source: "DM507 juni 2013, Opg. 5a (5%)",
  prompt: [
    $n$ heltal i intervallet #swap[$0..n^4$]. Angiv værstefald for: i) Counting-Sort, ii) Radix-Sort (heltal som #swap[4 cifre, hvert i $0..n$]), iii) Quicksort, iv) Merge-Sort, v) Insertion-Sort.
  ],
  answer: [i) $Theta(n^4)$, ii) $Theta(n)$, iii) $Theta(n^2)$, iv) $Theta(n log n)$, v) $Theta(n^2)$.],
  blueprint: [
    Indsæt antal $n$ og interval $k$ i de kendte omkostninger.

    + *Counting-Sort:* $Theta(n + k)$ med $k$ = værdiintervallet.
    + *Radix-Sort:* $Theta(d (n + k'))$ med $d$ cifre af grundtal $k'$.
    + *Sammenligningssorteringer* påvirkes ikke af værdiintervallet: Quicksort værst $Theta(n^2)$, Merge-Sort $Theta(n log n)$, Insertion-Sort værst $Theta(n^2)$.
  ],
  worked: [
    - i) Counting-Sort: $Theta(n + n^4) = Theta(n^4)$.
    - ii) Radix-Sort, $d = 4$, hvert ciffer i $0..n$ så pass koster $Theta(n + n) = Theta(n)$: total $Theta(4n) = Theta(n)$.
    - iii) Quicksort: $Theta(n^2)$.
    - iv) Merge-Sort: $Theta(n log n)$.
    - v) Insertion-Sort: $Theta(n^2)$.
  ],
)

#qcard(
  tag: [Sorteringskøretider på et givet input],
  source: "DM507 juni 2014, Opg. 8 (10%)",
  prompt: [
    Sortér $n$ elementer hvis nøgler kun er #swap[$0$ eller $1$]. For Counting-Sort, Insertion-Sort, Merge-Sort, Quicksort: angiv værstefald og bedstefald fra A) $O(n)$, B) $O(n log n)$, C) $O(n^2)$.
  ],
  answer: [Counting: A/A. Insertion: C/A. Merge: B/B. Quicksort: C/B.],
  blueprint: [
    Ræsonnér pr. algoritme på dette 2-værdis input.

    + *Counting-Sort:* interval $k = 2$ konstant $->$ $Theta(n)$ altid.
    + *Insertion-Sort:* bedst når allerede sorteret ($0...0 thin 1...1$), $O(n)$; værst ved mange inversioner (fx alle $1$ før alle $0$), $Theta(n^2)$.
    + *Merge-Sort:* $Theta(n log n)$ uanset input.
    + *Quicksort:* med kun to nøgleværdier og fast sidste-element-pivot kan partitioneringen blive maksimalt ubalanceret (størrelse $0$ mod $n-1$) $->$ $Theta(n^2)$; et balanceret split giver $O(n log n)$ bedstefald.
  ],
  worked: [
    #table(
      columns: 3,
      stroke: 0.4pt + hair,
      [], [*Værst*], [*Bedst*],
      [Counting-Sort], [A $O(n)$], [A $O(n)$],
      [Insertion-Sort], [C $O(n^2)$], [A $O(n)$],
      [Merge-Sort], [B $O(n log n)$], [B $O(n log n)$],
      [Quicksort], [C $O(n^2)$], [B $O(n log n)$],
    )

    Counting-Sort er det rette værktøj her, $O(n)$. Quicksorts værstefald skyldes at ens nøgler giver et degenereret split med Lomuto/sidste-element-pivot.
  ],
)
