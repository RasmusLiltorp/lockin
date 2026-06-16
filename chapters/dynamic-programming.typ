#import "../lib.typ": *

== Dynamisk programmering

Når et problem deles op i mindre udgaver af sig selv, og udgaverne overlapper, regner naiv rekursion det samme svar igen og igen — eksponentielt dyrt. Dynamisk programmering løser hvert delproblem én gang og gemmer svaret i en tabel. Du skriver den optimale værdi som en rekursion og fylder tabellen, så hver celle kun beregnes én gang.

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

#trap(title: [Rullende array])[Mindste plads er ikke altid tabellens størrelse. Afhænger en celle kun af den forrige række, nøjes et rullende array med én række, og pladsen falder fra $Theta(m n)$ til $Theta(n)$. Læser en celle alle tidligere indgange, kan intet frigives.]

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
  worked: [Celler: $i$ i $0..m$, $j$ i $0..n$ giver $Theta(m n)$. Per celle løber min'en over $k in {0,...,j-1}$, op til $j = Theta(n)$ led. Samlet
  #eq[$ Theta(m n) dot Theta(n) = Theta(m n^2) $]],
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
  worked: [Hver celle i række $i$ læser kun række $i-1$. Et rullende array på én række er nok: smid række $i-1$ væk, når række $i$ er færdig. Lavere går ikke, for en celle kræver et præfiks af alle $n$ søjler i forrige række. Mindste plads $= Theta(n)$, ikke den fulde $Theta(m n)$-tabel.],
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
  worked: [1-D-tabel $B[0..n]$, altså $Theta(n)$ celler. $B[k]$ summerer $k$ produkter, så $Theta(k)$ arbejde. Samlet
  #eq[$ sum_(k=1)^n k = (n(n+1))/2 = Theta(n^2) $]
  Pladsen er $Theta(n)$: $B(n)$ læser hver tidligere indgang, så ingen kan frigives. Et konstant vindue som i Fibonacci dur ikke her.],
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
  worked: [Gyldige tilstande er par $1 <= i <= j <= n$, en øvre trekant på $n(n+1)\/2 = Theta(n^2)$ celler. Hver celle med $i < j$ læser to værdier plus $O(1)$ aritmetik, så $Theta(1)$ arbejde. Samlet
  #eq[$ Theta(n^2) dot Theta(1) = Theta(n^2) $]
  Mindste plads er $Theta(n)$: ordn efter diagonalen $d = j - i$, hvor diagonal $d$ kun kræver diagonal $d-1$.],
)
