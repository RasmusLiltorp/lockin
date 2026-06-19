#import "../lib.typ": *

== Appendix: Logaritmer og talrepræsentation

Et tal i base $b$ (base) er en vægtet sum af potenser af $b$. Cifret (digit) på plads $i$ (talt fra 0 yderst til højre) vejer $b^i$. Decimal er base 10, binær (binary) base 2, hexadecimal base 16.

To slags spørgsmål går igen: logaritmeregler inde i $O$- og $Theta$-påstande (hvad vokser hurtigst), og omregning af heltal mellem baser i hånden. Begge er rutine, når du kan trinnene.

=== Sådan løser du det

En logaritme (logarithm) er det omvendte af en potens. $log_2 x$ er det tal, du opløfter 2 i for at få $x$:

#eq[$ y = log_2 x quad <==> quad 2^y = x $]

Her betyder $log n$ altid $log_2 n$. De tre regneregler:

#eq[$ log(x_1 x_2) = log x_1 + log x_2 $]
#eq[$ log(x_1 \/ x_2) = log x_1 - log x_2 $]
#eq[$ log(x^r) = r log x $]

Basen er ligegyldig inde i $O$ og $Theta$. Basisskift ganger blot med en konstant:

#eq[$ log_a x = (log_b x) / (log_b a) $]

Så $log_a n = Theta(log_b n)$ uanset basen. Derfor skriver man aldrig basen i en $O$-påstand.

#metadata(none) <th-app-log>
#recipe(
  title: [Afgør om $f$ er $O(g)$],
  [Lær vækstrækken (growth hierarchy) udenad; hver står stærkere end den foregående:
   #eq[$ 1 < log n < (log n)^k < n^epsilon < n < n log n < n^2 < n^3 < c^n < n^n $]
   En polylog $(log n)^k$ taber til enhver positiv potens $n^epsilon$. Konstante faktorer tæller ikke.],
  [I tvivl? Regn grænseværdien (limit)
   #eq[$ L = lim_(n -> oo) f(n) / g(n) $]],
  [Aflæs svaret af $L$:
   #eq[$ O: L < oo quad quad Theta: 0 < L < oo quad quad o: L = 0 quad quad omega: L = oo $]],
  [Husk Stirling; den dukker op hvert år:
   #eq[$ log(n!) = Theta(n log n) $]],
)

#metadata(none) <th-app-base>
#recipe(
  title: [Omregn et positivt heltal til base $b$],
  [Sæt $X = N$. Dividér $X$ med #swap[$b$] og notér *resten* (remainder); det er det næste ciffer, mindst betydende først.],
  [Sæt $X$ til *kvotienten* (quotient) og gentag, så længe $X > 0$.],
  [Resterne læst *nedefra og op* er cifrene i base #swap[$b$].],
  [Den anden vej, base $b$ til decimal, er den vægtede sum
   #eq[$ N = sum_i d_i dot b^i $]],
)

Hvert ciffer koster $O(1)$, og du deler $N$ ned til 0, så omregningen tager $Theta(log_b N)$.

#note(title: [Hex som firkløvere])[*Hex er grupperet binær.* Del bittene i firkløvere fra højre og erstat hver gruppe med ét hex-ciffer: $0$–$9$, så $A = 10$ op til $F = 15$. F.eks. $0110 thin 1010_2 = 6 A_16$.]

#note(title: [Toer-komplement])[*Toer-komplement* (two's complement)*.* Øverste bit tæller negativt, $-(2^(k-1))$ i stedet for $+2^(k-1)$. Med 4 bit: $1101_2 = -8 + 4 + 0 + 1 = -3$. Et 1-tal forrest betyder altid et negativt tal.]

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  inset: 6pt,
  align: center + horizon,
  stroke: 0.4pt + hair,
  table.header([*bit*], [*uden fortegn*], [*toer-kompl.*], [*bit*], [*uden fortegn*], [*toer-kompl.*]),
  [0000], [0], [0], [1000], [8], [-8],
  [0001], [1], [1], [1001], [9], [-7],
  [0110], [6], [6], [1110], [14], [-2],
  [0111], [7], [7], [1111], [15], [-1],
)

#trap(title: [Fortegnsskift])[Fortegnsskift i toer-komplement er ikke "vend alle bit". Kopiér bittene fra højre til og med første 1-tal, og vend resten. $0110$ ($=6$) bliver $1010$ ($=-6$). (Samme som at vende alle bit og lægge 1 til.)]

#trap(title: [Vendte retninger])[Vendte retninger er den klassiske fælde. $n$ er *ikke* $O(log n)$, og $log n$ er *ikke* $omega(n^2)$. $log$ vokser langsommere end enhver positiv potens af $n$.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [O-notation: er X = O(Y)? (growth hierarchy)],
  source: "MCQ juni 2021, Spm. 5",
  theory: <th-app-log>,
  prompt: [Hvilke udsagn er sande? $log n$ er base to. (Et eller flere svar.)],
  options: (
    [$n$ er $O(log n)$],
    [$(log n)^3$ er $O(n^2)$],
    [$n log n$ er $O(n^(1.5))$],
    [$2^n$ er $O(sqrt(n))$],
    [$3n^2$ er $O(n^2)$],
    [$7^n$ er $O((log n)^7)$],
    [$log(n!)$ er $O(n^2)$],
  ),
  answer: [(b), (c), (e) og (g) er sande.],
  blueprint: [
    Et $O$-udsagn "$f$ er $O(g)$" spørger om $f$ vokser højst lige så hurtigt som $g$.

    + *Find $f$ og $g$.* Skriv #swap[de to funktioner] op, en på hver side.
    + *Slå dem op i vækstrækken.* $1 < log n < (log n)^k < n^epsilon < n < n log n < n^2 < c^n < n^n$. Konstante faktorer tæller ikke med.
    + *Sammenlign placeringen.* Ligger #swap[$f$] til venstre for eller samme sted som #swap[$g$], er udsagnet sandt.
    + *Tvivlstilfælde.* Regn $L = lim_(n -> oo) f\/g$. Er $L < oo$, holder $O$.
  ],
  worked: [
    Jeg tager dem en ad gangen og holder $f\/g$ op mod rækken.

    - (a) $n$ mod $log n$: $n$ står til højre, så $n$ er ikke $O(log n)$. Falsk.
    - (b) $(log n)^3$ mod $n^2$: enhver polylog taber til et polynomium. Sand.
    - (c) $n log n$ mod $n^(1.5)$: del med $n$, så er det $log n$ mod $sqrt(n)$, og $log$ taber. Sand.
    - (d) $2^n$ mod $sqrt(n)$: eksponentiel slår enhver potens. Falsk.
    - (e) $3n^2$ mod $n^2$: konstanten 3 forsvinder i $O$. Sand.
    - (f) $7^n$ mod $(log n)^7$: eksponentiel mod polylog, helt galt. Falsk.
    - (g) $log(n!)$ mod $n^2$: Stirling giver $log(n!) = Theta(n log n)$, som ligger under $n^2$. Sand.

    Svar: (b), (c), (e) og (g).
  ],
)

#qcard(
  tag: [Asymptotik: O / Ω / Θ / o / ω sand? (growth hierarchy)],
  source: "MCQ juni 2021, Spm. 6",
  theory: <th-app-log>,
  prompt: [Hvilke udsagn er sande? $log n$ er base to. (Et eller flere svar.)],
  options: (
    [$log n$ er $omega(n^2)$],
    [$n^2 + n^3$ er $Theta(n^3)$],
    [$6$ er $o(7)$],
    [$3^n$ er $Omega(2^n)$],
    [$n \/ (log n)^2$ er $o((log n)^3)$],
    [$n^n$ er $Omega(2^n)$],
    [$n^(1.1)$ er $omega(n log n)$],
  ),
  answer: [(b), (d), (f) og (g) er sande.],
  blueprint: [
    Her er fem forskellige symboler i spil. Grænseværdien $L = lim_(n->oo) f\/g$ afgør dem alle.

    + *Opstil brøken.* Skriv $f\/g$ med #swap[de to funktioner].
    + *Tag grænsen* $L = lim_(n->oo) f\/g$. Forkort først, så meget du kan.
    + *Aflæs symbolet ud fra $L$:*
      #eq[$ O: L < oo quad Theta: 0 < L < oo quad o: L = 0 quad omega: L = oo quad Omega: L > 0 $]
    + *Match mod udsagnet.* Passer dit $L$ med #swap[det påståede symbol], er udsagnet sandt.
  ],
  worked: [
    Jeg regner $L = lim f\/g$ for hver linje.

    - (a) $log n \/ n^2 -> 0$, så $log n$ er $o(n^2)$, ikke $omega(n^2)$. Falsk.
    - (b) $n^3$ dominerer $n^2 + n^3$, så $L = 1$ og det er $Theta(n^3)$. Sand.
    - (c) $6\/7$ er en konstant forskellig fra 0, så $6$ er $Theta(7)$, ikke $o(7)$. Falsk.
    - (d) $3^n\/2^n = (3\/2)^n -> oo$, så $3^n$ er $Omega(2^n)$. Sand.
    - (e) $n\/(log n)^2$ delt med $(log n)^3$ giver $n\/(log n)^5 -> oo$, ikke $o$. Falsk.
    - (f) $n^n\/2^n -> oo$, så $n^n$ er $Omega(2^n)$. Sand.
    - (g) $n^(1.1)\/(n log n) = n^(0.1)\/log n -> oo$, så $omega(n log n)$. Sand.

    Svar: (b), (d), (f) og (g).
  ],
)

#qcard(
  tag: [Talrepræsentation: omregn til binær (base)],
  source: "DM573, talReprSlides (omregningsøvelse)",
  theory: <th-app-base>,
  prompt: [Omregn $N = #swap[$25$]$ til binær.],
  answer: [$25 = 11001_2$.],
  blueprint: [
    Gentagen division med basen. Resterne er cifrene, mindst betydende først.

    + *Start.* Sæt $X = #swap[$N$]$, det tal du vil omregne.
    + *Dividér med basen.* Del $X$ med #swap[2] og skriv resten ned. Den er det næste ciffer.
    + *Gentag.* Sæt $X$ til kvotienten og kør igen, til $X = 0$.
    + *Læs op.* Cifrene nedefra og op er svaret. Tjek med den vægtede sum $sum_i d_i dot b^i$.
  ],
  worked: [
    Jeg dividerer 25 med 2 igen og igen og noterer resten hver gang.

    #table(
      columns: 3, inset: 5pt, align: center,
      stroke: 0.4pt + hair,
      table.header([division], [kvotient], [rest]),
      [$25 : 2$], [12], [1],
      [$12 : 2$], [6], [0],
      [$6 : 2$], [3], [0],
      [$3 : 2$], [1], [1],
      [$1 : 2$], [0], [1],
    )

    Resterne nedefra og op: $11001_2$. Tjek baglæns: $16 + 8 + 0 + 0 + 1 = 25$.

    Svar: $25 = 11001_2$.
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (running time)],
  source: "DM507 juni 2010, Opg. 3d",
  theory: <th-app-base>,
  prompt: [Algoritmen finder de binære cifre $b_i$ for et positivt heltal $n$ (her $n = #swap[$55$]$). Identiteten $x = y dot (x "div" y) + (x "mod" y)$ gælder for alle heltal. Hvad er køretiden?
    ```
    BinaryDigits(n)
      i = 0
      d = n
      while d > 0
         b_i = d mod 2
         d   = d div 2
         i   = i + 1
      k = i - 1
    ```],
  answer: [$Theta(log n)$.],
  blueprint: [
    Køretid (running time) for en løkke er antal gennemløb gange arbejdet per gennemløb.

    + *Find tælleren.* Hvilken variabel styrer #swap[løkken], og hvad starter den ved?
    + *Se hvordan den ændrer sig.* Trækkes der fra (lineært), eller deles der med en faktor (logaritmisk)? Halvering hver gang giver $log_2$.
    + *Tæl gennemløbene.* Deles der med #swap[2] ned til 0, er det $floor(log_2 n) + 1$ gange.
    + *Gang med arbejdet per gennemløb.* Er kroppen $O(1)$, er svaret antal gennemløb.
  ],
  worked: [
    Jeg følger $d$ gennem løkken.

    + $d$ starter ved $n$ og deles med 2 (heltalsdivision) hver gang, til den rammer 0.
    + Antal halveringer ned til 0 er
      #eq[$ floor(log_2 n) + 1 = Theta(log n) $]
    + Kroppen laver $O(1)$ per gennemløb: én mod, én div og en optælling.

    For $n = 55$ kører løkken $floor(log_2 55) + 1 = 6$ gange. I alt $Theta(log n)$.

    Svar: $Theta(log n)$.
  ],
)
