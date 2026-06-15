#import "../lib.typ": *

== Appendix: Logaritmer og talrepræsentation

Et tal i base $b$ er en vægtet sum af potenser af $b$. Cifret på plads $i$ (talt fra 0 yderst til højre) vejer $b^i$. Decimal er base 10, binær base 2, hexadecimal base 16.

To slags spørgsmål går igen: logaritmeregler inde i $O$- og $Theta$-påstande (hvad vokser hurtigst), og omregning af heltal mellem baser i hånden. Begge er rutine, når du kan trinnene.

=== Sådan løser du det

En logaritme er det omvendte af en potens. $log_2 x$ er det tal, du opløfter 2 i for at få $x$:

#eq[$ y = log_2 x quad <==> quad 2^y = x $]

Her betyder $log n$ altid $log_2 n$. De tre regneregler:

#eq[$ log(x_1 x_2) = log x_1 + log x_2 $]
#eq[$ log(x_1 \/ x_2) = log x_1 - log x_2 $]
#eq[$ log(x^r) = r log x $]

Basen er ligegyldig inde i $O$ og $Theta$. Basisskift ganger blot med en konstant:

#eq[$ log_a x = (log_b x) / (log_b a) $]

Så $log_a n = Theta(log_b n)$ uanset basen. Derfor skriver man aldrig basen i en $O$-påstand.

#recipe(
  title: [Afgør om $f$ er $O(g)$],
  [Lær vækstrækken udenad; hver står stærkere end den foregående:
   #eq[$ 1 < log n < (log n)^k < n^epsilon < n < n log n < n^2 < n^3 < c^n < n^n $]
   En polylog $(log n)^k$ taber til enhver positiv potens $n^epsilon$. Konstante faktorer tæller ikke.],
  [I tvivl? Regn grænseværdien
   #eq[$ L = lim_(n -> oo) f(n) / g(n) $]],
  [Aflæs svaret af $L$:
   #eq[$ O: L < oo quad quad Theta: 0 < L < oo quad quad o: L = 0 quad quad omega: L = oo $]],
  [Husk Stirling; den dukker op hvert år:
   #eq[$ log(n!) = Theta(n log n) $]],
)

#recipe(
  title: [Omregn et positivt heltal til base $b$],
  [Sæt $X = N$. Dividér $X$ med #swap[$b$] og notér *resten*; det er det næste ciffer, mindst betydende først.],
  [Sæt $X$ til *kvotienten* og gentag, så længe $X > 0$.],
  [Resterne læst *nedefra og op* er cifrene i base #swap[$b$].],
  [Den anden vej, base $b$ til decimal, er den vægtede sum
   #eq[$ N = sum_i d_i dot b^i $]],
)

Hvert ciffer koster $O(1)$, og du deler $N$ ned til 0, så omregningen tager $Theta(log_b N)$.

#note[*Hex er grupperet binær.* Del bittene i firkløvere fra højre og erstat hver gruppe med ét hex-ciffer: $0$–$9$, så $A = 10$ op til $F = 15$. F.eks. $0110 thin 1010_2 = 6 A_16$.]

#note[*Toer-komplement.* Øverste bit tæller negativt, $-(2^(k-1))$ i stedet for $+2^(k-1)$. Med 4 bit: $1101_2 = -8 + 4 + 0 + 1 = -3$. Et 1-tal forrest betyder altid et negativt tal.]

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

#trap[Fortegnsskift i toer-komplement er ikke "vend alle bit". Kopiér bittene fra højre til og med første 1-tal, og vend resten. $0110$ ($=6$) bliver $1010$ ($=-6$). (Samme som at vende alle bit og lægge 1 til.)]

#trap[Vendte retninger er den klassiske fælde. $n$ er *ikke* $O(log n)$, og $log n$ er *ikke* $omega(n^2)$. $log$ vokser langsommere end enhver positiv potens af $n$.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [O-notation: er X = O(Y)?],
  source: "MCQ juni 2021, Spm. 5",
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
  worked: [Hold $f\/g$ op mod vækstrækken. (a) falsk, $n$ slår $log n$. (b) sand, polylog taber til ethvert polynomium. (c) sand, samme som $log n = O(sqrt(n))$. (d) falsk, eksponentiel slår enhver potens. (e) sand, konstanten 3 forsvinder i $O$. (f) falsk, eksponentiel slår polylog. (g) sand, $log(n!) = Theta(n log n)$, som ligger under $n^2$.],
)

#qcard(
  tag: [Asymptotik: O / Ω / Θ / o / ω sand?],
  source: "MCQ juni 2021, Spm. 6",
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
  worked: [Regn $L = lim f\/g$. (a) falsk, $L = 0$, så $o(n^2)$, ikke $omega$. (b) sand, $n^3$ dominerer, $L = 1$. (c) falsk, $6\/7$ er konstant og $!= 0$, så $Theta(7)$, ikke $o$. (d) sand, $(3\/2)^n -> oo$. (e) falsk, $n\/(log n)^5 -> oo$. (f) sand, $n^n\/2^n -> oo$. (g) sand, $n^(0.1)\/log n -> oo$.],
)

#qcard(
  tag: [Talrepræsentation: omregn til binær],
  source: "DM573, talReprSlides (omregningsøvelse)",
  prompt: [Omregn $N = #swap[$25$]$ til binær.],
  answer: [$25 = 11001_2$.],
  worked: [Gentagen division med 2, rester læst nedefra og op:
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
    Læst opad: $11001_2$. Tjek: $16 + 8 + 1 = 25$.],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb],
  source: "DM507 juni 2010, Opg. 3d",
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
  worked: [$d$ starter ved $n$ og halveres (heltalsdivision) hver iteration, til den når 0. Antal iterationer er
    #eq[$ floor(log_2 n) + 1 = Theta(log n) $]
    Hver iteration laver $O(1)$ arbejde: én mod, én div, én addition. I alt $Theta(log n)$.],
)
