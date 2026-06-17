#import "../lib.typ": *

== Dynamisk programmering

Når et problem deles op i mindre udgaver af sig selv, og udgaverne overlapper, regner naiv rekursion (recursion) det samme svar igen og igen — eksponentielt dyrt. Dynamisk programmering (dynamic programming) løser hvert delproblem (subproblem) én gang og gemmer svaret i en tabel. Du skriver den optimale værdi som en rekursion og fylder tabellen, så hver celle kun beregnes én gang.

Til eksamen får du typisk en færdig rekursion og skal angive køretid eller mindste plads. Sjældnere skal du selv opstille rekursionen, fylde tabellen og rekonstruere løsningen.

=== Sådan løser du den

To tal aflæses direkte af rekursionen, uden at køre den.

Køretiden er antal celler gange arbejdet per celle:

#eq[$ T = ("antal celler") times ("arbejde per celle") $]

Mindste plads er den største mængde tidligere celler, du er nødt til at holde på samtidig:

#eq[$ S = "størrelsen af den front, du skal huske" $]

#recipe(
  title: "Læs køretid og plads af en given rekursion",
  [Find tabellens størrelse ud fra indeksenes intervaller. $i$ i $0..m$ og $j$ i $0..n$ giver $Theta(m n)$ celler. Et par $i <= j$ giver en trekant på $n(n+1)\/2 = Theta(n^2)$ celler.],
  [Find arbejdet per celle. Et #swap[$min$] eller #swap[$max$] over op til $j$ tidligere celler koster $Theta(j)$; to opslag plus aritmetik koster $Theta(1)$.],
  [Gang de to sammen.],
  [For plads: se hvilke tidligere celler en celle læser. Kun den forrige række $->$ én række er nok. Alle tidligere celler $->$ intet kan smides væk.],
)

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

#trap(title: [Rullende array])[Mindste plads er ikke altid tabellens størrelse. Afhænger en celle kun af den forrige række, nøjes et rullende array (rolling array) med én række, og pladsen falder fra $Theta(m n)$ til $Theta(n)$. Læser en celle alle tidligere indgange, kan intet frigives.]

==== Rekonstruktion

Tabellen rummer kun den optimale værdi. Vil du have løsningen, så gem det vindende valg i hver celle og gå baglæns fra målcellen til basistilfældet. Det koster $O(n)$ eller $O(m+n)$ ekstra — langt mindre end fyldningen.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [DP: aflæs køretid af given rekursion],
  source: "MCQ juni 2017, Spm. 25",
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
    Her er tallene for $b(m, n)$.

    + Celler: $i$ i $0..m$ og $j$ i $0..n$, altså $Theta(m n)$.
    + Arbejde per celle: min'en løber over $k in {0, ..., j-1}$, op til $j = Theta(n)$ led.
    + Gang sammen: $Theta(m n) dot Theta(n)$.

    #eq[$ Theta(m n) dot Theta(n) = Theta(m n^2) $]
  ],
)

#qcard(
  tag: [DP: mindste pladsforbrug for given rekursion],
  source: "MCQ juni 2017, Spm. 26",
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
    Her er fronten for $b(m, n)$.

    + Hver celle i række $i$ læser kun række $i-1$.
    + Et rullende array på én række er nok. Når række $i$ står færdig, kan række $i-1$ smides væk.
    + Lavere går ikke, for cellen kræver et præfiks af alle $n$ søjler i forrige række.

    Mindste plads bliver $Theta(n)$, mens den fulde tabel ville koste $Theta(m n)$.
  ],
)

#qcard(
  tag: [DP: mindste pladsforbrug for given rekursion],
  source: "MCQ juni 2025, Spm. 31",
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
    Her er fronten for $B(n)$.

    + Bottom-up fylder en 1-D-tabel $B[0..n]$.
    + $B(n)$ kræver $B(0)$ til $B(n-1)$ på én gang (hele foldningen), så ingen indgang kan smides væk.
    + Det giver $Theta(n)$ — ikke $Theta(1)$ (et konstant vindue som i Fibonacci dur ikke) og ikke $Theta(n^2)$ (tabellen er 1-D).

    Mindste plads bliver $Theta(n)$.
  ],
)

#qcard(
  tag: [DP: mindste pladsforbrug for given rekursion],
  source: "MCQ juni 2021, Spm. 33",
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
    Her er fronten for $W(m, n)$.

    + $W(i,j)$ læser kun $W(i-1,j)$ (ovenfor) og $W(i,j-1)$ (til venstre).
    + Ét rullende 1-D-array er nok: pladsen holder stadig $W(i-1,j)$, og den netop skrevne nabo til venstre holder $W(i,j-1)$.
    + Lad arrayet spænde den mindste dimension, så længden bliver $min(m,n)+1$.

    Mindste plads bliver $Theta(min{m,n})$. Kun skalaren $W(m,n)$ ønskes, så ingen baglæns-rekonstruktion skal gemmes.
  ],
)

#qcard(
  tag: [DP: mindste pladsforbrug for given rekursion (trekant)],
  source: "MCQ juni 2019, Spm. 30",
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
    Her er fronten for $L(1, n)$.

    + Gyldige tilstande er par $1 <= i <= j <= n$, en øvre trekant på $n(n+1)\/2 = Theta(n^2)$ celler.
    + Ordn efter diagonalen $d = j - i$. For $d > 0$ er $L(i, i+d) = i dot L(i+1, i+d) + (i+d) dot L(i, i+d-1)$, og begge naboer ligger på diagonal $d-1$.
    + Kør $d = 0, 1, ..., n-1$ og hold kun den forrige diagonal. En diagonal rummer højst $n$ celler.

    Mindste plads bliver $Theta(n)$, mens den fulde trekant ville koste $Theta(n^2)$. $L(1,n)$ er den eneste celle på diagonal $d = n-1$.
  ],
)

#qcard(
  tag: [DP: aflæs køretid af given rekursion],
  source: "MCQ juni 2025, Spm. 30",
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
    Her er tallene for $B(n)$.

    + Tabel $B[0..n]$ har $Theta(n)$ celler.
    + $B[k]$ summerer $k$ produkter $B[i] dot B[k-i-1]$, så $Theta(k)$ arbejde.
    + Læg sammen over alle celler.

    #eq[$ sum_(k=1)^n k = (n(n+1))/2 = Theta(n^2) $]

    Pladsen er $Theta(n)$, fordi $B(n)$ læser hver tidligere indgang, så ingen kan frigives. Et konstant vindue som i Fibonacci dur ikke her.
  ],
)

#qcard(
  tag: [DP: aflæs køretid af given rekursion],
  source: "MCQ juni 2021, Spm. 32",
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
    Her er tallene for $W(m, n)$.

    + Celler: $i$ i $0..m$ og $j$ i $0..n$, altså $(m+1)(n+1) = Theta(m n)$.
    + Arbejde per celle: $max{0, w(i,j)}$ plus max af to allerede beregnede naboer. Det er $Theta(1)$.
    + Gang sammen: $Theta(m n) dot Theta(1)$.

    #eq[$ Theta(m n) dot Theta(1) = Theta(m n) $]
  ],
)

#qcard(
  tag: [DP: aflæs køretid af given rekursion (trekant)],
  source: "MCQ juni 2019, Spm. 29",
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
    Her er tallene for $L(1, n)$.

    + Gyldige tilstande er par $1 <= i <= j <= n$, en øvre trekant på $n(n+1)\/2 = Theta(n^2)$ celler.
    + Hver celle med $i < j$ læser to værdier plus $O(1)$ aritmetik, så $Theta(1)$ arbejde.
    + Gang sammen: $Theta(n^2) dot Theta(1)$.

    #eq[$ Theta(n^2) dot Theta(1) = Theta(n^2) $]

    Mindste plads er $Theta(n)$. Ordn efter diagonalen $d = j - i$, hvor diagonal $d$ kun kræver diagonal $d-1$.
  ],
)

#qcard(
  tag: [DP: find den rigtige rekursion],
  source: "MCQ juni 2017, Spm. 24 (flere rigtige)",
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
    Standardrekursionen: match $-> 1 + l(i-1,j-1)$; mismatch $-> 1 + min{l(i-1,j), l(i,j-1)}$.

    + På eksemplet $X = c c a c c$, $Y = a c a c a a$ er den sande længde $m + n - "LCS" = 5 + 6 - 3 = 8$.
    + Hver mulighed på eksemplet giver: (a)=5, (b)=4, (c)=8, (d)=11, (e)=8, (f)=6. Kun (c) og (e) rammer 8.
    + Tjekket mod orakel på mange tilfældige strengpar: kun (c) og (e) matcher overalt.
    + (e) er rigtig, fordi $l(i-1,j-1)$ er mindst af de tre led, når $x_i = y_j$, så $1 + min{...} = 1 + l(i-1,j-1)$. De øvrige fejler: (a) dropper $+1$ ved match, (b) dropper $+1$ ved mismatch, (d) lægger $+2$ til ved match, (f) tillader altid diagonalen, også når tegnene er forskellige.

    Svar: (c) og (e).
  ],
)
