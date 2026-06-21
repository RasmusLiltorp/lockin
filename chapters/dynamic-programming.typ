#import "../lib.typ": *

== Dynamisk programmering

Når et problem deles op i mindre udgaver af sig selv, og udgaverne overlapper, regner naiv rekursion (recursion) det samme svar igen og igen — eksponentielt dyrt. Dynamisk programmering (dynamic programming) løser hvert delproblem (subproblem) én gang og gemmer svaret i en tabel. Du skriver den optimale værdi som en rekursion og fylder tabellen, så hver celle kun beregnes én gang.

Til eksamen får du typisk en færdig rekursion og skal angive køretid eller mindste plads. Sjældnere skal du selv opstille rekursionen, fylde tabellen og rekonstruere løsningen.

=== Sådan løser du den <th-dp-runtime>

To tal aflæses direkte af rekursionen, uden at køre den.

Køretiden er antal celler gange arbejdet per celle:

#eq[$ T = ("antal celler") times ("arbejde per celle") $]

Mindste plads er den største mængde tidligere celler, du er nødt til at holde på samtidig:

#eq[$ S = "størrelsen af den front, du skal huske" $]

#recipe(
  title: "Læs køretid og plads af en given rekursion",
  [Find tabellens størrelse ud fra indeksenes intervaller. $i$ i $0..m$ og $j$ i $0..n$ giver $Theta(m n)$ celler. Et par $i <= j$ giver en trekant på $n(n+1)\/2 = Theta(n^2)$ celler.],
  [Find arbejdet per celle. Kig på hvad én celle gør: et fast antal opslag koster $Theta(1)$, mens et #swap[$min$], $max$ eller $sum$ over et interval koster lige så meget, som intervallet er langt.],
  [Gang de to sammen.],
  [For plads: se hvilke tidligere celler en celle læser. Kun den forrige række $->$ én række er nok. Alle tidligere celler $->$ intet kan smides væk.],
)

#note(title: [Arbejde per celle på 1 sekund])[Ser du et $min$, $max$, $sum$ eller en løkke i formlen, så tæl hvor mange led den løber over. Det tal er arbejdet per celle. Ser du kun et fast antal opslag, er det $Theta(1)$.]

#table(
  columns: (auto, auto),
  inset: 7pt,
  align: (left, left),
  stroke: 0.4pt + hair,
  table.header([*Hvad står der i cellens formel?*], [*Arbejde per celle*]),
  [Fast antal opslag + regning, fx $b(i-1, j-1) + c$], [$Theta(1)$],
  [$min$ / $max$ / $sum$ / løkke over $k$ led, fx $min_(k < j)$], [$Theta(k)$ — tæl leddene, typisk $Theta(n)$],
  [To løkker oven i hinanden], [gang længderne, fx $Theta(n^2)$],
)

#metadata(none) <th-dp-build>
#recipe(
  title: "Byg en DP-løsning fra bunden",
  [Vælg delproblemets størrelse som ét eller flere heltalsindeks. Det fastlægger tabellens dimensioner.],
  [Argumentér for optimale delproblemer: skær en optimal løsning i en sidste del og resten, og vis at resten selv er optimal for et mindre delproblem.],
  [Skriv rekursionen som et #swap[$max$] eller #swap[$min$] over alle valg af den sidste del, plus et basistilfælde for størrelse 0.],
  [Fyld tabellen bottom-up, så hver celles afhængigheder allerede står klar. Eller brug memoization: rekursér top-down og cache hver celle første gang.],
  [Vil du have selve løsningen, så gem det vindende valg per celle og følg valgene baglæns.],
)

#note(title: [Memoization vs. bottom-up])[Memoization og bottom-up giver samme $Theta$ for tid og plads; memoization har blot en lidt dårligere konstant.]

#table(
  columns: (auto, auto, auto, auto),
  inset: 7pt,
  align: (left, center, center, left),
  stroke: 0.4pt + hair,
  table.header([*Problem*], [*Celler*], [*Arbejde/celle*], [*Tid*]),
  [Stangskæring $r(n)$], [$Theta(n)$], [$Theta(n)$], [$Theta(n^2)$],
  [LCS $"lcs"(i,j)$], [$Theta(m n)$], [$Theta(1)$], [$Theta(m n)$],
  [Matrixkæde $m(i,j)$], [$Theta(n^2)$], [$Theta(n)$], [$Theta(n^3)$],
)

#trap(title: [Arbejde per celle])[Tabellens størrelse er ikke køretiden — gang med arbejdet per celle. Et min over op til $j$ tidligere celler koster $Theta(j)$, ikke $Theta(1)$, og gør en $Theta(m n)$-tabel til $Theta(m n^2)$.]

#metadata(none) <th-dp-space>
#trap(title: [Rullende array])[Mindste plads er ikke altid tabellens størrelse. Afhænger en celle kun af den forrige række, nøjes et rullende array (rolling array) med én række, og pladsen falder fra $Theta(m n)$ til $Theta(n)$. Læser en celle alle tidligere indgange, kan intet frigives.]

==== Rekonstruktion

Tabellen rummer kun den optimale værdi. Vil du have løsningen, så gem det vindende valg i hver celle og gå baglæns fra målcellen til basistilfældet. Det koster $O(n)$ eller $O(m+n)$ ekstra — langt mindre end fyldningen.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [DP: aflæs køretid af given rekursion (arbejde per celle)],
  source: "MCQ juni 2017, Spm. 25",
  theory: <th-dp-runtime>,
  prompt: [For et optimeringsproblem er inputtet en omkostning $c_(i j)$ for alle $i$ og $j$. En løsning $b(i,j)$ kan beskrives ved rekursionen
  #eq[$ b(i,j) = cases(
    0 & "hvis " i=0 "eller " j=0,
    c_(i j) + min { b(i-1,k) : 0 <= k < j } & "hvis " i>0 "og " j>0
  ) $]
  Hvis $b(#swap[$m$], #swap[$n$])$ findes ved dynamisk programmering, hvilken køretid opnås da?],
  options: (
    [$Theta(1)$], [$Theta(m)$], [$Theta(n)$], [$Theta(m n)$],
    [$Theta(m^2 n)$], [$Theta(m n^2)$], [$Theta(m^2 n^2)$],
  ),
  answer: [(f) $Theta(m n^2)$.],
  blueprint: [
    Køretiden er antal celler gange arbejdet per celle. Begge tal står i rekursionen, så du behøver ikke køre den.

    + *Tæl cellerne.* Find intervallet for hvert indeks. To frie indeks #swap[$i in 0..m$] og #swap[$j in 0..n$] giver $Theta(m n)$ celler.
    + *Mål arbejdet per celle.* Tæl hvor mange tidligere celler én celle slår op i. Et #swap[$min$ over $k < j$] løber over op til $Theta(n)$ led.
    + *Gang de to tal sammen.* Køretid $= ("celler") times ("arbejde per celle")$.
  ],
  worked: [
    For at se hvad én celle koster, fyld et lille tilfælde. Tag $m = n = 3$ med omkostningerne $c_(i j)$:

    ```
    c | j=1  j=2  j=3
    --+----------------
    1 |  4    2    7
    2 |  3    5    1
    3 |  6    2    4
    ```

    Tabellen $b(i,j)$ fyldes række for række. Række $0$ og søjle $0$ er $0$ (basistilfældet). For $i,j > 0$ er $b(i,j) = c_(i j) + min{b(i-1,k) : 0 <= k < j}$ — altså mindste celle i *hele præfikset* af forrige række, ikke kun nabocellen:

    ```
    b | k=0  j=1  j=2  j=3
    --+---------------------
    0 |  0    0    0    0
    1 |  0    4    2    7
    2 |  0    3    5    1
    3 |  0    6    2    4
    ```

    To celler regnet ud med tallene:

    - $b(1,3) = c_(13) + min{b(0,0), b(0,1), b(0,2)} = 7 + min{0,0,0} = 7$.
    - $b(2,3) = c_(23) + min{b(1,0), b(1,1), b(1,2)} = 1 + min{0, 4, 2} = 1 + 0 = 1$.

    Læg mærke til at $b(2,3)$ kigger på $j = 3$ celler i forrige række. Det er arbejdet per celle:

    + Celler: $i$ i $0..m$ og $j$ i $0..n$, altså $Theta(m n)$.
    + Arbejde per celle: min'en løber over $k in {0, ..., j-1}$, op til $j = Theta(n)$ led.
    + Gang sammen: $Theta(m n) dot Theta(n)$.

    #eq[$ Theta(m n) dot Theta(n) = Theta(m n^2) $]
  ],
)

#qcard(
  tag: [DP: mindste pladsforbrug for given rekursion (rullende array)],
  source: "MCQ juni 2017, Spm. 26",
  theory: <th-dp-space>,
  prompt: [Samme problem og samme rekursion for $b(i,j)$. Hvis $b(#swap[$m$], #swap[$n$])$ findes ved dynamisk programmering, hvad er det mindste pladsforbrug, der kan opnås?],
  options: (
    [$Theta(1)$], [$Theta(m)$], [$Theta(n)$], [$Theta(m n)$],
    [$Theta(m^2 n)$], [$Theta(m n^2)$], [$Theta(m^2 n^2)$],
  ),
  answer: [(c) $Theta(#swap[$n$])$.],
  blueprint: [
    Mindste plads er den mindste front af tidligere celler, du skal holde på samtidig.

    + *Se hvad en celle læser.* Find hvilke tidligere celler der står i rekursionens højreside.
    + *Find fronten.* Læser en celle kun #swap[forrige række], er én række nok, og resten kan smides væk.
    + *Tjek den nedre grænse.* Kræver cellen et helt præfiks af rækken, kan du ikke gå under #swap[rækkens bredde].
  ],
  worked: [
    Brug samme lille tilfælde, $m = n = 3$. Pointen er hvor lidt du behøver at holde på ad gangen. Hver celle $b(i,j) = c_(i j) + min{b(i-1,k) : 0 <= k < j}$ læser kun række $i-1$, aldrig længere tilbage.

    Kør med ét rullende array `prev`, der hele tiden er den senest færdige række:

    ```
    Start (række 0):  prev = [ 0, 0, 0, 0 ]   (k=0..3)

    Beregn række 1:   b(1,1)=4+min{0}        =4
                      b(1,2)=2+min{0,4}      =2
                      b(1,3)=7+min{0,4,2}    =7
    prev <- række 1:  prev = [ 0, 4, 2, 7 ]   række 0 smides væk

    Beregn række 2:   b(2,1)=3+min{0}        =3
                      b(2,2)=5+min{0,4}      =5
                      b(2,3)=1+min{0,4,2}    =1
    prev <- række 2:  prev = [ 0, 3, 5, 1 ]   række 1 smides væk

    Beregn række 3:   b(3,1)=6+min{0}        =6
                      b(3,2)=2+min{0,3}      =2
                      b(3,3)=4+min{0,3,5}    =4
    prev <- række 3:  prev = [ 0, 6, 2, 4 ]
    ```

    Hele tiden ligger kun ét array på $n+1$ tal i hukommelsen.

    + Hver celle i række $i$ læser kun række $i-1$.
    + Et rullende array på én række er nok. Når række $i$ står færdig, kan række $i-1$ smides væk.
    + Lavere går ikke, for hver celle kræver et helt præfiks af forrige række — fx $b(3,3)$ ovenfor bruger alle af $0, 3, 5$.

    Mindste plads bliver $Theta(n)$, mens den fulde tabel ville koste $Theta(m n)$.
  ],
)

#qcard(
  tag: [DP: mindste pladsforbrug for given rekursion (rullende array)],
  source: "MCQ juni 2025, Spm. 31",
  theory: <th-dp-space>,
  prompt: [Samme problem og samme rekursion for $B(n)$, antallet af binære træer med $n$ knuder, ved
  #eq[$ B(0) = 1, quad B(n) = sum_(i=0)^(n-1) B(i) dot B(n-i-1) "for " n > 0 $]
  Beregnet ved dynamisk programmering, hvad er det mindste pladsforbrug, der kan opnås?],
  options: (
    [$Theta(1)$], [$Theta(log n)$], [$Theta(n)$], [$Theta(n log n)$],
    [$Theta(n^2)$], [$Theta(n^3)$],
  ),
  answer: [(c) $Theta(n)$.],
  blueprint: [
    Mindste plads er de celler, du er nødt til at holde på samtidig. Læser hver ny celle alle de tidligere, kan ingen smides væk.

    + *Find delproblemerne.* Én værdi per indeks, $B(0)..B(n)$.
    + *Se afhængighederne.* Summerer $B(n)$ over alle #swap[$i = 0..n-1$], læser den hver tidligere indgang.
    + *Find fronten.* Kan ingen indgang frigives, skal hele tabellen på $n+1$ celler stå — altså $Theta(n)$.
  ],
  worked: [
    Fyld tabellen for $n = 5$, så det bliver klart hvad hver ny celle læser. Bottom-up med $B(0) = 1$ og $B(n) = sum_(i=0)^(n-1) B(i) dot B(n-i-1)$:

    ```
    B[0] = 1
    B[1] = B0*B0                      = 1*1                       = 1
    B[2] = B0*B1 + B1*B0              = 1*1 + 1*1                 = 2
    B[3] = B0*B2 + B1*B1 + B2*B0      = 1*2 + 1*1 + 2*1           = 5
    B[4] = B0*B3 + B1*B2 + B2*B1 + B3*B0
                                      = 1*5 + 1*2 + 2*1 + 5*1     = 14
    B[5] = B0*B4 + B1*B3 + B2*B2 + B3*B1 + B4*B0
                                      = 1*14 + 1*5 + 2*2 + 5*1 + 14*1 = 42

    tabel: [ 1, 1, 2, 5, 14, 42 ]      (indeks 0..5)
    ```

    Se på $B[5]$: foldningen parrer $B[0]$ med $B[4]$, $B[1]$ med $B[3]$, og så videre — den rører *hver* tidligere indgang. Derfor kan ingen smides væk undervejs.

    + Bottom-up fylder en 1-D-tabel $B[0..n]$.
    + $B(n)$ kræver $B(0)$ til $B(n-1)$ på én gang (hele foldningen), så ingen indgang kan smides væk.
    + Det giver $Theta(n)$ — ikke $Theta(1)$ (et konstant vindue som i Fibonacci dur ikke, for foldningen rører hele tabellen) og ikke $Theta(n^2)$ (tabellen er 1-D).

    Mindste plads bliver $Theta(n)$.
  ],
)

#qcard(
  tag: [DP: mindste pladsforbrug for given rekursion (rullende array)],
  source: "MCQ juni 2021, Spm. 33",
  theory: <th-dp-space>,
  prompt: [Samme problem og rekursion som før: med
  #eq[$ W(i,j) = cases(
    0 & "hvis " i = 0 "eller " j = 0,
    max{0, w(i,j)} + max{W(i-1,j), W(i,j-1)} & "ellers"
  ) $]
  Hvis $W(#swap[$m$], #swap[$n$])$ findes ved DP, hvad er det mindste pladsforbrug?],
  options: (
    [$Theta(n)$], [$Theta(m)$], [$Theta(min{m,n})$], [$Theta(max{m,n})$],
    [$Theta(m n)$], [$Theta(m n^2)$], [$Theta(m^2 n)$],
  ),
  answer: [(c) $Theta(min{m,n})$.],
  blueprint: [
    Mindste plads er den mindste front, du skal holde på. Læser cellen kun den forrige række og naboen til venstre, er ét rullende array nok.

    + *Se hvad en celle læser.* Find hvilke tidligere celler der står i højresiden.
    + *Vælg det rullende array.* Læser cellen kun #swap[ovenfor og til venstre], nøjes du med ét 1-D-array.
    + *Vælg den korte side.* Lad arrayet spænde den mindste dimension, så længden bliver $min(m,n)+1$.
  ],
  worked: [
    Fyld et lille tilfælde, $m = n = 3$, med disse $w(i,j)$ (nogle negative):

    ```
    w | j=1  j=2  j=3
    --+----------------
    1 |  3   -2    4
    2 | -1    5   -3
    3 |  2    1   -4
    ```

    Hver celle er $W(i,j) = max{0, w(i,j)} + max{W(i-1,j), W(i,j-1)}$. Fyld række for række:

    ```
    W | j=0  j=1  j=2  j=3
    --+---------------------
    0 |  0    0    0    0
    1 |  0    3    3    7
    2 |  0    3    8    8
    3 |  0    5    9    9
    ```

    To celler regnet med tallene:

    - $W(2,2) = max{0, 5} + max{W(1,2), W(2,1)} = 5 + max{3, 3} = 8$.
    - $W(1,3) = max{0, 4} + max{W(0,3), W(1,2)} = 4 + max{0, 3} = 7$.

    Hver celle ser kun på to naboer, ovenfor og til venstre, og det er dét, der afgør pladsen.

    + $W(i,j)$ læser kun $W(i-1,j)$ (ovenfor) og $W(i,j-1)$ (til venstre).
    + Ét rullende 1-D-array er nok: pladsen holder stadig $W(i-1,j)$, og den netop skrevne nabo til venstre holder $W(i,j-1)$.
    + Lad arrayet spænde den mindste dimension, så længden bliver $min(m,n)+1$.

    Mindste plads bliver $Theta(min{m,n})$. Kun skalaren $W(m,n)$ ønskes, så ingen baglæns-rekonstruktion skal gemmes.
  ],
)

#qcard(
  tag: [DP: mindste pladsforbrug for given rekursion (trekant)],
  source: "MCQ juni 2019, Spm. 30",
  theory: <th-dp-space>,
  prompt: [Samme problem og samme rekursion for $L(i,j)$:
  #eq[$ L(i,j) = cases(
    c_i & "hvis " i = j,
    i dot L(i+1,j) + j dot L(i,j-1) & "hvis " i < j
  ) $]
  Hvis $L(1, #swap[$n$])$ findes ved dynamisk programmering, hvad er det mindste pladsforbrug, der kan opnås?],
  options: (
    [$Theta(1)$], [$Theta(n^(1\/2))$], [$Theta(n)$], [$Theta(n^(3\/2))$],
    [$Theta(n^2)$], [$Theta(n^3)$],
  ),
  answer: [(c) $Theta(n)$.],
  blueprint: [
    Et bånd $i <= j$ fylder en trekant på $Theta(n^2)$ celler, men pladsen afhænger af afhængighederne, ikke af tabellens størrelse. Find en rækkefølge, hvor hver celles afhængigheder ligger i én færdig front.

    + *Find afhængighederne.* Læs hvilke celler højresiden slår op i: $L(i,j)$ afhænger af $L(i+1,j)$ og $L(i,j-1)$.
    + *Ordn efter diagonalen.* Sæt #swap[$d = j - i$]; celle $L(i, i+d)$ afhænger kun af celler på diagonal $d-1$.
    + *Mål fronten.* Mindste plads er den største front, du skal holde på. En diagonal rummer op til $n$ celler.
  ],
  worked: [
    Fyld den øvre trekant for $n = 4$ med $c = (c_1, c_2, c_3, c_4) = (2, 3, 1, 2)$. Diagonalen $i = j$ er basistilfældet $L(i,i) = c_i$; for $i < j$ er $L(i,j) = i dot L(i+1,j) + j dot L(i,j-1)$.

    Udfyld diagonal for diagonal, $d = j - i = 0, 1, 2, 3$:

    ```
    L | j=1  j=2  j=3  j=4
    --+---------------------
    1 |  2    7   32  192     <- mål L(1,4) i hjørnet
    2 |  .    3   11   64
    3 |  .    .    1   10
    4 |  .    .    .    2
    (d=0 diagonal: 2,3,1,2   d=1: 7,11,10   d=2: 32,64   d=3: 192)
    ```

    To celler regnet med tallene:

    - $L(2,3) = 2 dot L(3,3) + 3 dot L(2,2) = 2 dot 1 + 3 dot 3 = 2 + 9 = 11$.
    - $L(1,2) = 1 dot L(2,2) + 2 dot L(1,1) = 1 dot 3 + 2 dot 2 = 3 + 4 = 7$.

    Begge naboer ($L(i+1,j)$ nedenunder og $L(i,j-1)$ til venstre) ligger på den forrige diagonal $d-1$. Så du behøver kun at holde én diagonal ad gangen.

    + Gyldige tilstande er par $1 <= i <= j <= n$, en øvre trekant på $n(n+1)\/2 = Theta(n^2)$ celler.
    + Ordn efter diagonalen $d = j - i$. For $d > 0$ er $L(i, i+d) = i dot L(i+1, i+d) + (i+d) dot L(i, i+d-1)$, og begge naboer ligger på diagonal $d-1$.
    + Kør $d = 0, 1, ..., n-1$ og hold kun den forrige diagonal. En diagonal rummer højst $n$ celler.

    Mindste plads bliver $Theta(n)$, mens den fulde trekant ville koste $Theta(n^2)$. $L(1,n)$ er den eneste celle på diagonal $d = n-1$.
  ],
)

#qcard(
  tag: [DP: aflæs køretid af given rekursion (arbejde per celle)],
  source: "MCQ juni 2025, Spm. 30",
  theory: <th-dp-runtime>,
  prompt: [Find $B(n)$, antallet af binære træer med $n$ knuder (fx $B(3) = 5$), ved rekursionen
  #eq[$ B(0) = 1, quad B(n) = sum_(i=0)^(n-1) B(i) dot B(n-i-1) "for " n > 0 $]
  Beregnet ved dynamisk programmering på denne rekursion, hvilken køretid opnås?],
  options: (
    [$Theta(1)$], [$Theta(log n)$], [$Theta(n)$], [$Theta(n log n)$],
    [$Theta(n^2)$], [$Theta(n^3)$],
  ),
  answer: [(e) $Theta(n^2)$.],
  blueprint: [
    En 1-D-rekursion med en sum i hver celle. Tæl cellerne, mål summens længde, og gang.

    + *Tæl cellerne.* En tabel $B[0..n]$ har $Theta(n)$ celler.
    + *Mål summen.* Celle $B[k]$ summerer #swap[$k$ produkter], altså $Theta(k)$ arbejde.
    + *Læg arbejdet sammen.* En stigende sum giver $sum_(k=1)^n k = n(n+1)\/2 = Theta(n^2)$.
  ],
  worked: [
    Fyld tabellen for $n = 5$ og tæl led i hver sum. $B[k] = sum_(i=0)^(k-1) B[i] dot B[k-i-1]$ er en foldning, så $B[k]$ koster netop $k$ produkter:

    ```
    B[0] = 1                                              (0 produkter)
    B[1] = B0*B0                          = 1             (1 produkt)
    B[2] = B0*B1 + B1*B0                  = 1+1 = 2        (2 produkter)
    B[3] = B0*B2 + B1*B1 + B2*B0          = 2+1+2 = 5      (3 produkter)
    B[4] = B0*B3 + B1*B2 + B2*B1 + B3*B0  = 5+2+2+5 = 14   (4 produkter)
    B[5] = B0*B4 + B1*B3 + B2*B2 + B3*B1 + B4*B0
                                          = 14+5+4+5+14 = 42 (5 produkter)

    tabel: [ 1, 1, 2, 5, 14, 42 ]
    ```

    Antallet af produkter vokser $0, 1, 2, 3, 4, 5$ — én mere for hver celle. Det samlede arbejde er summen af disse:

    + Tabel $B[0..n]$ har $Theta(n)$ celler.
    + $B[k]$ summerer $k$ produkter $B[i] dot B[k-i-1]$, så $Theta(k)$ arbejde.
    + Læg sammen over alle celler.

    #eq[$ sum_(k=1)^n k = (n(n+1))/2 = Theta(n^2) $]

    Pladsen er $Theta(n)$, fordi $B(n)$ læser hver tidligere indgang, så ingen kan frigives. Et konstant vindue som i Fibonacci dur ikke her.
  ],
)

#qcard(
  tag: [DP: aflæs køretid af given rekursion (arbejde per celle)],
  source: "MCQ juni 2021, Spm. 32",
  theory: <th-dp-runtime>,
  prompt: [Et problem med ikke-krydsende parring løses med DP. Mængderne $U = {u_1, ..., u_m}$ og $V = {v_1, ..., v_n}$ ligger på to parallelle linjer; par $(u_i, v_j)$ forbindes med linjer, der ikke må overlappe, hver med værdi $w(i,j)$ (kan være negativ), og den samlede værdi skal maksimeres. Med
  #eq[$ W(i,j) = cases(
    0 & "hvis " i = 0 "eller " j = 0,
    max{0, w(i,j)} + max{W(i-1,j), W(i,j-1)} & "ellers"
  ) $]
  Hvilken køretid giver denne DP for $W(#swap[$m$], #swap[$n$])$?],
  options: (
    [$Theta(n)$], [$Theta(m)$], [$Theta(min{m,n})$], [$Theta(max{m,n})$],
    [$Theta(m n)$], [$Theta(m n^2)$], [$Theta(m^2 n)$],
  ),
  answer: [(e) $Theta(m n)$.],
  blueprint: [
    Køretiden er antal celler gange arbejdet per celle. Tæl cellerne ud fra indeksenes intervaller og mål arbejdet i én celle.

    + *Tæl cellerne.* To frie indeks #swap[$i in 0..m$] og #swap[$j in 0..n$] giver $Theta(m n)$ celler.
    + *Mål arbejdet per celle.* Læser cellen #swap[et fast antal naboer] plus $O(1)$ aritmetik, er det $Theta(1)$.
    + *Gang de to tal sammen.* Køretid $= ("celler") times ("arbejde per celle")$.
  ],
  worked: [
    Fyld et lille tilfælde, $m = n = 3$, med disse $w(i,j)$:

    ```
    w | j=1  j=2  j=3
    --+----------------
    1 |  3   -2    4
    2 | -1    5   -3
    3 |  2    1   -4
    ```

    $W(i,j) = max{0, w(i,j)} + max{W(i-1,j), W(i,j-1)}$, fyldt række for række:

    ```
    W | j=0  j=1  j=2  j=3
    --+---------------------
    0 |  0    0    0    0
    1 |  0    3    3    7
    2 |  0    3    8    8
    3 |  0    5    9    9
    ```

    To celler regnet med tallene:

    - $W(2,2) = max{0, 5} + max{W(1,2), W(2,1)} = 5 + max{3, 3} = 8$.
    - $W(3,3) = max{0, -4} + max{W(2,3), W(3,2)} = 0 + max{8, 9} = 9$.

    Hver celle gør et fast stykke arbejde: ét $max$ med nul, og ét $max$ over to færdige naboer. Ingen løkke, ingen sum.

    + Celler: $i$ i $0..m$ og $j$ i $0..n$, altså $(m+1)(n+1) = Theta(m n)$.
    + Arbejde per celle: $max{0, w(i,j)}$ plus max af to allerede beregnede naboer. Det er $Theta(1)$.
    + Gang sammen: $Theta(m n) dot Theta(1)$.

    #eq[$ Theta(m n) dot Theta(1) = Theta(m n) $]
  ],
)

#qcard(
  tag: [DP: aflæs køretid af given rekursion (trekant)],
  source: "MCQ juni 2019, Spm. 29",
  theory: <th-dp-runtime>,
  prompt: [For et optimeringsproblem er inputtet værdier $c_k$ for $k = 1, 2, ..., n$. En løsning $L(i,j)$ kan beskrives ved rekursionen
  #eq[$ L(i,j) = cases(
    c_i & "hvis " i = j,
    i dot L(i+1,j) + j dot L(i,j-1) & "hvis " i < j
  ) $]
  Hvis $L(1, #swap[$n$])$ findes ved dynamisk programmering, hvilken køretid opnås?],
  options: (
    [$Theta(1)$], [$Theta(n^(1\/2))$], [$Theta(n)$], [$Theta(n^(3\/2))$],
    [$Theta(n^2)$], [$Theta(n^3)$],
  ),
  answer: [(e) $Theta(n^2)$.],
  blueprint: [
    Et bånd $i <= j$ på indeksene fylder en trekant, ikke et helt kvadrat. Tæl trekantens celler.

    + *Tæl trekanten.* Par med #swap[$i <= j$] fylder en øvre trekant på $n(n+1)\/2 = Theta(n^2)$ celler.
    + *Mål arbejdet.* Læser cellen et fast antal naboer plus $O(1)$ aritmetik, er det $Theta(1)$ per celle.
    + *Gang de to tal sammen.* Køretid $= ("trekantens celler") times ("arbejde per celle")$.
  ],
  worked: [
    Fyld den øvre trekant for $n = 4$ med $c = (2, 3, 1, 2)$. Basistilfælde $L(i,i) = c_i$; ellers $L(i,j) = i dot L(i+1,j) + j dot L(i,j-1)$.

    ```
    L | j=1  j=2  j=3  j=4
    --+---------------------
    1 |  2    7   32  192     <- mål L(1,4)
    2 |  .    3   11   64
    3 |  .    .    1   10
    4 |  .    .    .    2
    ```

    To celler regnet med tallene:

    - $L(3,4) = 3 dot L(4,4) + 4 dot L(3,3) = 3 dot 2 + 4 dot 1 = 6 + 4 = 10$.
    - $L(1,3) = 1 dot L(2,3) + 3 dot L(1,2) = 1 dot 11 + 3 dot 7 = 11 + 21 = 32$.

    Hver celle med $i < j$ ganger to færdige naboer med konstanter og lægger sammen — fast arbejde. Antallet af celler er trekantens størrelse.

    + Gyldige tilstande er par $1 <= i <= j <= n$, en øvre trekant på $n(n+1)\/2 = Theta(n^2)$ celler.
    + Hver celle med $i < j$ læser to værdier plus $O(1)$ aritmetik, så $Theta(1)$ arbejde.
    + Gang sammen: $Theta(n^2) dot Theta(1)$.

    #eq[$ Theta(n^2) dot Theta(1) = Theta(n^2) $]

    Mindste plads er $Theta(n)$. Ordn efter diagonalen $d = j - i$, hvor diagonal $d$ kun kræver diagonal $d-1$.
  ],
)

#qcard(
  tag: [DP: find den rigtige rekursion (optimale delproblemer)],
  source: "MCQ juni 2017, Spm. 24 (flere rigtige)",
  theory: <th-dp-build>,
  prompt: [For to følger $X = x_1, ..., x_m$ og $Y = y_1, ..., y_n$ søges en følge $S$, der har både $X$ og $Y$ som delsekvenser (subsequences). En sådan $S$ kaldes en supersekvens (supersequence) af $X$ og $Y$. En supersekvens findes altid (fx $S = X Y$), så en korteste supersekvens findes også. Lad $l(i,j)$ være længden af en korteste supersekvens af præfikserne #swap[$X_i = x_1, ..., x_i$] og #swap[$Y_j = y_1, ..., y_j$], for $0 <= i <= m$ og $0 <= j <= n$. Basistilfælde: $l(0,j) = j$ og $l(i,0) = i$. Hvilke af følgende er korrekte rekursioner for $i > 0, j > 0$?],
  options: (
    [$l(i,j) = 1 + min{l(i-1,j), l(i,j-1)}$ hvis $x_i != y_j$; $l(i-1,j-1)$ hvis $x_i = y_j$],
    [$l(i,j) = min{l(i-1,j), l(i,j-1)}$ hvis $x_i != y_j$; $1 + l(i-1,j-1)$ hvis $x_i = y_j$],
    [$l(i,j) = 1 + min{l(i-1,j), l(i,j-1)}$ hvis $x_i != y_j$; $1 + l(i-1,j-1)$ hvis $x_i = y_j$],
    [$l(i,j) = 1 + min{l(i-1,j), l(i,j-1)}$ hvis $x_i != y_j$; $2 + l(i-1,j-1)$ hvis $x_i = y_j$],
    [$l(i,j) = 1 + min{l(i-1,j), l(i,j-1)}$ hvis $x_i != y_j$; $1 + min{l(i-1,j), l(i,j-1), l(i-1,j-1)}$ hvis $x_i = y_j$],
    [$l(i,j) = 1 + min{l(i-1,j), l(i,j-1), l(i-1,j-1)}$ (én linje, uden betingelse)],
  ),
  answer: [Mulighed (c) og (e): begge giver den rigtige supersekvenslængde. (e) koger ned til (c), fordi $l(i-1,j-1)$ er det mindste af de tre led, når $x_i = y_j$.],
  blueprint: [
    Genkend mønstret bag opgaven, skriv standardrekursionen op, og test hver mulighed mod den.

    + *Genkend problemet.* Det er korteste fælles supersekvens (SCS), med basistilfælde #swap[$l(0,j) = j$] og #swap[$l(i,0) = i$].
    + *Skriv standardrekursionen.* Matcher de sidste tegn ($x_i = y_j$), deler de én plads: $l(i,j) = 1 + l(i-1,j-1)$. Ellers tilføjer du det sidste tegn fra $X$ eller $Y$: $l(i,j) = 1 + min{l(i-1,j), l(i,j-1)}$.
    + *Brug evt. identiteten.* $l(i,j) = i + j - "LCS"(X_i, Y_j)$ kan tjekke et svar.
    + *Test hver mulighed.* Kør hver kandidat på eksemplet og på mange små tilfældige par; behold dem, der rammer rigtigt på alle.
  ],
  worked: [
    Standardrekursionen, som er mulighed (c): match ($x_i = y_j$) $-> 1 + l(i-1,j-1)$; mismatch $-> 1 + min{l(i-1,j), l(i,j-1)}$.

    Fyld tabellen med eksemplet $X = c c a c c$ ($m = 5$) og $Y = a c a c a a$ ($n = 6$). Basistilfælde: $l(0,j) = j$ (top-række) og $l(i,0) = i$ (venstre søjle). Rækker er indekseret med $x_i$, søjler med $y_j$:

    ```
    l   |  -  a  c  a  c  a  a     <- Y
    ----+-----------------------
     -  |  0  1  2  3  4  5  6
     c  |  1  2  2  3  4  5  6
     c  |  2  3  3  4  4  5  6
     a  |  3  3  4  4  5  5  6
     c  |  4  4  4  5  5  6  7
     c  |  5  5  5  6  6  7  8     <- l(5,6) = 8
    ```

    To celler regnet med tegnene:

    - $l(1,2)$: $x_1 = c$, $y_2 = c$, match, så $1 + l(0,1) = 1 + 1 = 2$.
    - $l(3,2)$: $x_3 = a$, $y_2 = c$, mismatch, så $1 + min{l(2,2), l(3,1)} = 1 + min{3, 3} = 4$.

    Nederste højre hjørne er $l(5,6) = 8$. Den sande længde kan tjekkes uafhængigt: en korteste fælles supersekvens har længde $m + n - "LCS"(X,Y) = 5 + 6 - 3 = 8$. De passer.

    Nu testes hver mulighed ved at fylde samme tabel med dens egen regel og aflæse hjørnet:

    + Hjørneværdierne bliver: (a)=5, (b)=4, (c)=8, (d)=11, (e)=8, (f)=6. Kun (c) og (e) rammer den sande $8$.
    + Tjekket mod et orakel på mange tilfældige strengpar: kun (c) og (e) matcher overalt.
    + (e) er rigtig, fordi $l(i-1,j-1)$ er mindst af de tre led, når $x_i = y_j$, så $1 + min{l(i-1,j), l(i,j-1), l(i-1,j-1)} = 1 + l(i-1,j-1)$ — netop (c). De øvrige fejler: (a) dropper $+1$ ved match, (b) dropper $+1$ ved mismatch, (d) lægger $+2$ til ved match, (f) tillader altid diagonalen, også når tegnene er forskellige.

    Svar: (c) og (e).
  ],
)
