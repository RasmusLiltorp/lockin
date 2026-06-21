#import "../lib.typ": *

== Asymptotisk analyse

Asymptotisk analyse (asymptotic analysis) sammenligner funktioner efter hvor hurtigt de vokser for stort $n$. Konstante faktorer og små $n$ er ligegyldige; kun forholdet mellem to funktioner, når $n -> infinity$, tæller.

Eksamen spørger på to måder: om en påstand som "$f(n)$ er $O(g(n))$" er sand, eller om $Theta$-køretiden for en løkke. Begge løses med samme greb: kig på forholdet $f(n) slash g(n)$.

De fem symboler er bare fem måder at sige "hvor hurtigt vokser $f$ i forhold til $g$". Med køretid i baghovedet:

#block(above: 14pt, below: 14pt)[
  #align(center)[
    #table(
      columns: 3,
      align: (center, left, left),
      stroke: none,
      inset: (x: 14pt, y: 7pt),
      table.header(
        [*Symbol*], [*Hverdagsord*], [*Hvad det siger om køretiden*],
      ),
      table.hline(stroke: 0.4pt + hair),
      [$O(g)$], ["højst" — loft], [Bliver aldrig værre end $g$ (på nær konstanter). Værste-fald-grænse.],
      [$Omega(g)$], ["mindst" — gulv], [Er mindst lige så slem som $g$. En nedre grænse.],
      [$Theta(g)$], ["præcis"], [Både loft og gulv er $g$ — vokser nøjagtig lige så hurtigt som $g$.],
      [$o(g)$], ["skarpt under"], [Strengt langsommere end $g$; et loft den aldrig når.],
      [$omega(g)$], ["skarpt over"], [Strengt hurtigere end $g$; et gulv den aldrig når.],
    )
  ]
]

#note(title: [Streng vs. ikke-streng])[$O$ og $Omega$ tillader lighed (loft/gulv må røres), $o$ og $omega$ gør ikke (strengt under/over). $Theta$ er $O$ og $Omega$ på én gang. Derfor: hver gang $Theta$ holder, holder $O$ og $Omega$ også — men ikke omvendt.]

=== Sådan løser du den <th-asym-ladder>

En påstand som "$f(n)$ er $O(g(n))$" spørger kun om én ting: *vokser $f$ højst lige så hurtigt som $g$?* Det eneste værktøj du behøver er vækststigen (growth hierarchy) — langsomst til venstre, hurtigst til højre:

#eq[$ 1 < log n < sqrt(n) < n < n log n < n^2 < n^3 < 2^n < n^n. $]

To huskeregler dækker næsten alt: en *eksponentiel* ($2^n$, $3^n$) slår altid en *potens* ($n^2$, $n^3$, …), og en *$log$-faktor* rykker dig kun en lillebitte smule på stigen.

#note(title: [Konstanter])[Det yderste $1$ på stigen er *alle konstanter*: $2$, $3$, $100$ vokser ikke med $n$, så de sidder alle på samme plads. Derfor er enhver konstant $O$ (endda $Theta$) af enhver anden — fx er $3 = O(2)$ sand, og $O(2)$ betyder bare $O(1)$.]

#recipe(
  title: "Afgør en påstand f er O / Ω / Θ af g",
  [Find $f$ (venstre) og $g$ (inde i parentesen).],
  [Placér begge på vækststigen — hvem står længst til højre (vokser hurtigst)?],
  [Slå relationen op: står $f$ til *venstre for* $g$, er $f = O(g)$ og $o(g)$; *samme plads*, $Theta(g)$; *højre for*, $Omega(g)$ og $omega(g)$.],
)

For et hurtigt blik: er $f$ under eller lig med $g$ på stigen, holder "$f = O(g)$"; er $f$ over $g$, gør den ikke.

#metadata(none) <th-asym-limit>
*Den præcise metode (hvis stigen ikke rækker):* del de to funktioner og se hvad forholdet går mod langt ude. Lad

#eq[$ L = lim_(n -> infinity) f(n) / g(n). $]

Grænseværdien $L$ giver relationen (en sum beholder kun sit hurtigste led, så forenkl først).

Fra grænseværdi til relation:

#eq[$
L -> c > 0 quad &=> quad f = Theta(g) \
L -> 0 quad &=> quad f = o(g) " (og dermed " O(g) ") " \
L -> infinity quad &=> quad f = omega(g) " (og dermed " Omega(g) ")"
$]

Tænk på symbolerne som tal-sammenligninger: $O$ er $<=$, $Omega$ er $>=$, $Theta$ er $=$, $o$ er $<$, $omega$ er $>$. $Theta$ kræver et positivt endeligt $L$. $O$ holder så længe forholdet ikke vokser uden grænse, så det dækker også $L -> 0$.

Hele opslaget på én tabel — regn $L = lim f(n) slash g(n)$ og slå op:

#block(above: 14pt, below: 14pt)[
  #align(center)[
    #table(
      columns: 4,
      align: (center, center, center, left),
      stroke: none,
      inset: (x: 14pt, y: 7pt),
      table.header(
        [*Påstand*], [*Betyder*], [*Sand når $L$ er*], [*Eksempel (sand)*],
      ),
      table.hline(stroke: 0.4pt + hair),
      [$f = O(g)$], [$f <= g$], [$0$ eller en konstant], [$n = O(n^2)$],
      [$f = o(g)$], [$f < g$], [$0$], [$n = o(n^2)$],
      [$f = Theta(g)$], [$f = g$], [en konstant $> 0$], [$3n = Theta(n)$],
      [$f = Omega(g)$], [$f >= g$], [en konstant eller $infinity$], [$n^2 = Omega(n)$],
      [$f = omega(g)$], [$f > g$], [$infinity$], [$n^2 = omega(n)$],
    )
  ]
]

Kort sagt: er $f$ *under* $g$ på vækststigen, så er $f = O(g)$ (og $o(g)$). *Over*: $Omega(g)$ (og $omega(g)$). *Samme plads*: $Theta(g)$ — og så gælder både $O$ og $Omega$ samtidig.

#note(title: [Polynomium vs. eksponentiel])[To kendsgerninger afgør næsten alt. Ethvert polynomium slår enhver eksponentialfunktion: $n^a slash b^n -> 0$ for $a > 0$ og $b > 1$. Og enhver rod slår enhver polylog: $(log n)^a slash n^d -> 0$ for $a, d > 0$.]

*Et gennemregnet eksempel.* Vil vi afgøre om $(log n)^4 = O(n slash (log n)^4)$, kan vækststigen ikke bruges direkte, fordi $g$ selv er en brøk. Så regn forholdet $f slash g$ og se om det går mod $0$.

*Trin 1 — opstil forholdet (venstre delt med højre):*
#eq[$ ((log n)^4) / (n slash (log n)^4) $]

*Trin 2 — at dele med en brøk er det samme som at gange med den omvendte:*
#eq[$ (log n)^4 dot (log n)^4 / n $]

*Trin 3 — gang de to log-led sammen:*
#eq[$ ((log n)^4 dot (log n)^4) / n = (log n)^(4 + 4) / n = (log n)^8 / n $]

*Trin 4 — tag grænsen for $n -> infinity$:*
#eq[$ lim_(n -> infinity) (log n)^8 / n = 0 $]

Grænsen er $0$, fordi enhver positiv rod af $n$ slår enhver potens af $log n$, altså $(log n)^a = o(n^b)$. Forholdet går mod $0$, så $(log n)^4 = o(n slash (log n)^4)$ og dermed også $O(n slash (log n)^4)$. Påstanden er sand.

#trap(title: [Konstante faktorer])[Konstante faktorer og summer af samme grad ændrer ikke klassen: $n + n + n = Theta(n slash 3) = Theta(n)$. Men en $log$-faktor tæller. $(log n)^3$ er ikke $Theta(3 log n)$, fordi $(log n)^3 slash (3 log n) = (log n)^2 slash 3 -> infinity$.]

=== O(n) eller O(n²)? <th-asym-loops>

Forskellen mellem $Theta(n)$ og $Theta(n^2)$ handler kun om én ting: hvor mange gange den inderste linje kører i alt. Køretiden _er_ det tal. Så lad være med at gætte eksponenten; tæl skridtene.

En enkelt løkke fra $1$ til $n$ rammer den inderste linje $n$ gange. Det er $Theta(n)$:

```
for i = 1 til n:
  tæl = tæl + 1
```

Lægger du en løkke inden i en løkke, og begge løber til $n$, kører den inderste linje $n$ gange for hvert af de $n$ ydre gennemløb. $n$ gange $n$ er $n^2$, så det er $Theta(n^2)$:

```
for i = 1 til n:
  for j = 1 til n:
    tæl = tæl + 1
```

Sæt tal på. Med $n = 4$ kører den enkelte løkke 4 gange, mens den indlejrede kører $4 dot 4 = 16$. Fordobler du til $n = 8$, går den enkelte op på 8, altså dobbelt så meget, men den indlejrede springer til 64, fire gange så meget. Det er sådan $n^2$ opfører sig. Fordobler du dit input, firdobler du arbejdet, fordi hvert ekstra ydre skridt slæber en hel indre løkke med sig.

Vanen, der gør det nemt, er at starte ved den inderste linje og tælle udad. Ét lag løkke om den giver én faktor $n$. To lag giver to faktorer, altså $n^2$. Når du tæller den vej, falder eksponenten på plads helt af sig selv.

Men en enkelt løkke kører ikke nødvendigvis $n$ gange. Hvor mange gange den kører afhænger helt af, hvordan tælleren ændrer sig undervejs. Det er her de andre klasser som $log n$ og $sqrt(n)$ kommer fra:

#block(above: 14pt, below: 14pt)[
  #align(center)[
    #table(
      columns: 3,
      align: (left, left, center),
      stroke: none,
      inset: (x: 14pt, y: 7pt),
      table.header(
        [*Tælleren ændres*], [*Eksempel*], [*Gennemløb*],
      ),
      table.hline(stroke: 0.4pt + hair),
      [Plus en konstant], [`i = i + 3`], [$Theta(n)$],
      [Gange med en konstant], [`i = 2 * i`], [$Theta(log n)$],
      [Stopper ved $sqrt(n)$], [`while i*i <= n`], [$Theta(sqrt(n))$],
    )
  ]
]

En multiplikativ tæller når $n$ langt hurtigere end en additiv, fordi den fordobler sig hver gang. Derfor klarer den sig på $log n$ skridt: hvor mange gange skal du gange $1$ med $2$ for at nå $n$? Cirka $log_2 n$ gange.

Stabler du løkker oven på hinanden, ganger du tallene sammen. Det er sådan resten af klasserne opstår, $n log n$ for eksempel:

#block(above: 14pt, below: 14pt)[
  #align(center)[
    #table(
      columns: 3,
      align: (left, left, center),
      stroke: none,
      inset: (x: 14pt, y: 7pt),
      table.header(
        [*Ydre løkke*], [*Indre løkke*], [*Samlet*],
      ),
      table.hline(stroke: 0.4pt + hair),
      [$Theta(n)$ gennemløb], [$Theta(n)$ arbejde], [$Theta(n^2)$],
      [$Theta(log n)$ gennemløb], [$Theta(n)$ arbejde], [$Theta(n log n)$],
      [$Theta(n)$ gennemløb], [$Theta(log n)$ arbejde], [$Theta(n log n)$],
      [$Theta(n)$ gennemløb], [indre løber op til $i$], [$Theta(n^2)$],
    )
  ]
]

Den sidste række er værd at lægge mærke til. En indre løkke, der kun løber op til den ydre tæller $i$, laver $1 + 2 + dots + n$ skridt i alt. Den sum er $n(n+1) slash 2$, som stadig er $Theta(n^2)$, ikke $Theta(n)$. En trekant af arbejde fylder altså lige så meget som hele firkanten, asymptotisk set.

For løkker tæller du altså to ting hver for sig: hvor mange gange den ydre løkke kører, og arbejdet indeni per gennemløb.

#recipe(
  title: "Find Θ-køretiden for en løkke",
  [Tæl ydre gennemløb. Additivt skridt ($i = i + #swap[$c$]$) giver $Theta(n)$; multiplikativt ($i = #swap[$2$] dot i$) giver $Theta(log n)$.],
  [Find det indre arbejde per ydre gennemløb. Tjek om en tæller nulstilles hvert gennemløb eller bliver ved med at stige.],
  [Gang ydre antal med indre omkostning, smid konstanter væk, skriv $Theta$.],
)

#metadata(none) <th-asym-loop-trap>
#trap(title: [Indre tæller])[Sættes en indre tæller én gang uden for begge løkker og kun stiger, er det samlede indre arbejde $Theta(n)$ for hele kørslen, ikke per gennemløb. Det laver et tilsyneladende $Theta(n^2)$ om til $Theta(n)$.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [O-notation: er X = O(Y)? (vækststigen)],
  source: "MCQ juni 2023, Spm. 5",
  theory: <th-asym-ladder>,
  prompt: [Hvilke af følgende er sande? (Et eller flere svar.)],
  options: (
    [$#swap[$n$]$ er $O(#swap[$sqrt(n)$])$],
    [$#swap[$n + n$]$ er $O(#swap[$n log n$])$],
    [$#swap[$n log n$]$ er $O(#swap[$n^(3 slash 2)$])$],
    [$#swap[$(log n)^2$]$ er $O(#swap[$n^(1 slash 2)$])$],
    [$#swap[$3^n$]$ er $O(#swap[$(log n)^3$])$],
    [$#swap[$2^n log n$]$ er $O(#swap[$2^n n$])$],
    [$#swap[$n^(1 slash 7)$]$ er $O(#swap[$log(n^(17))$])$],
  ),
  answer: [(b), (c), (d) og (f) er sande.],
  blueprint: [
    Hver linje spørger om det samme: vokser venstresiden højst lige så hurtigt som højresiden? Du tjekker én linje ad gangen, og du kan som regel nøjes med vækststigen.

    + Forenkl begge sider. En sum beholder kun sit hurtigste led, så $#swap[$n + n$]$ bliver til $#swap[$n$]$.
    + Find $f$ og $g$ på stigen $1 < log n < sqrt(n) < n < n log n < n^2 < 2^n < n^n$.
    + Står $f$ til venstre for eller på samme plads som $g$, holder $O$. Står $f$ til højre, holder den ikke.
    + Er du i tvivl, så regn forholdet: $#swap[$f(n) slash g(n)$]$. Går det mod $0$ eller en konstant, er det $O$. Går det mod $infinity$, er det ikke.
    + To genveje: en eksponentiel slår enhver potens, og en rod slår enhver $log$-potens.
  ],
  worked: [
    $f = O(g)$ holder netop når $f slash g$ ikke vokser uden grænse, altså når grænsen er $0$ eller en konstant. Jeg regner forholdet ud for hver linje.

    - *(a)* $f = n$, $g = sqrt(n)$. Forholdet:
      #eq[$ n / sqrt(n) = n^1 / n^(1 slash 2) = n^(1 - 1 slash 2) = n^(1 slash 2) = sqrt(n) -> infinity. $]
      Tælleren vokser hurtigere end nævneren, så grænsen er $infinity$. *Falsk.*
    - *(b)* $f = n + n = 2n$, $g = n log n$. Forholdet:
      #eq[$ (2n) / (n log n) = 2 / log n -> 0, $]
      fordi $log n -> infinity$. Grænsen er $0$. *Sand.*
    - *(c)* $f = n log n$, $g = n^(3 slash 2)$. Del $n$ væk:
      #eq[$ (n log n) / n^(3 slash 2) = (log n) / n^(3 slash 2 - 1) = (log n) / n^(1 slash 2) = (log n) / sqrt(n) -> 0, $]
      for enhver positiv rod af $n$ slår enhver potens af $log n$. *Sand.*
    - *(d)* $f = (log n)^2$, $g = n^(1 slash 2) = sqrt(n)$. Forholdet $(log n)^2 slash sqrt(n) -> 0$ af samme grund: en polylog under en rod. *Sand.*
    - *(e)* $f = 3^n$, $g = (log n)^3$. En eksponentialfunktion slår enhver potens af $log n$, så
      #eq[$ 3^n / (log n)^3 -> infinity. $]
      *Falsk.*
    - *(f)* $f = 2^n log n$, $g = 2^n n$. Den fælles faktor $2^n$ forkortes:
      #eq[$ (2^n log n) / (2^n n) = (log n) / n -> 0. $]
      *Sand.*
    - *(g)* $f = n^(1 slash 7)$, $g = log(n^(17)) = 17 log n$. Forholdet:
      #eq[$ n^(1 slash 7) / (17 log n) -> infinity, $]
      for selv en lille rod $n^(1 slash 7)$ slår $log n$. *Falsk.*

    Et forhold der går mod $0$ tæller stadig som $O$ (det er endda $o$). Tilbage står *(b), (c), (d)* og *(f)*.
  ],
)

#qcard(
  tag: [O-notation: er X = O(Y)? (vækststigen)],
  source: "MCQ juni 2015, Spm. 5 (flere rigtige)",
  theory: <th-asym-ladder>,
  prompt: [Hvilke af følgende er sande? (Et eller flere svar.)],
  options: (
    [$#swap[$2^n$]$ er $O(#swap[$n^3$])$],
    [$#swap[$n^2$]$ er $O(#swap[$3^n$])$],
    [$#swap[$n(log n)^2$]$ er $O(#swap[$n^3 log n$])$],
    [$#swap[$n^2 log n$]$ er $O(#swap[$n(log n)^3$])$],
    [$#swap[$n^3$]$ er $O(#swap[$n^2$])$],
    [$#swap[$3^n$]$ er $O(#swap[$2^n$])$],
    [$#swap[$n^(1 slash 3)$]$ er $O(#swap[$n^(1 slash 2)$])$],
  ),
  answer: [Mulighed (b), (c) og (g) er sande.],
  blueprint: [
    Hver linje spørger om det samme: vokser venstresiden højst lige så hurtigt som højresiden? Tag én linje ad gangen, og brug stigen først.

    + Forenkl begge sider, så kun det hurtigste led står tilbage.
    + Placér $f$ og $g$ på stigen $1 < log n < sqrt(n) < n < n log n < n^2 < n^3 < 2^n$.
    + Står $f$ til venstre for eller på samme plads som $g$, holder $O$. Står $f$ til højre, holder den ikke.
    + To genveje: en eksponentiel slår enhver potens, og blandt potenser vinder den med størst eksponent. Mellem to eksponentialer $a^n$ og $b^n$ er det grundtallet der tæller.
    + Er du i tvivl, regn forholdet #swap[$f(n) slash g(n)$] og se om det går mod $0$, en konstant eller $infinity$.
  ],
  worked: [
    Forholdet $f slash g$ skal være afgrænset (gå mod $0$ eller en konstant) for at $O$ holder. Jeg regner det ud linje for linje.

    - *(a)* $f = 2^n$, $g = n^3$. En eksponentialfunktion slår enhver potens:
      #eq[$ 2^n / n^3 -> infinity. $]
      *Falsk.*
    - *(b)* $f = n^2$, $g = 3^n$. Samme regel den anden vej, potens under eksponentiel:
      #eq[$ n^2 / 3^n -> 0. $]
      *Sand.*
    - *(c)* $f = n(log n)^2$, $g = n^3 log n$. Forkort $n$ og én $log n$:
      #eq[$ (n(log n)^2) / (n^3 log n) = (log n)^(2-1) / n^(3-1) = (log n) / n^2 -> 0. $]
      *Sand.*
    - *(d)* $f = n^2 log n$, $g = n(log n)^3$. Forkort $n$ og én $log n$:
      #eq[$ (n^2 log n) / (n(log n)^3) = n^(2-1) / (log n)^(3-1) = n / (log n)^2 -> infinity, $]
      for en potens af $n$ slår enhver potens af $log n$. *Falsk.*
    - *(e)* $f = n^3$, $g = n^2$. Større eksponent i tælleren:
      #eq[$ n^3 / n^2 = n -> infinity. $]
      *Falsk.*
    - *(f)* $f = 3^n$, $g = 2^n$. Saml potensen:
      #eq[$ 3^n / 2^n = (3 / 2)^n -> infinity, $]
      fordi grundtallet $3 slash 2 > 1$. *Falsk.*
    - *(g)* $f = n^(1 slash 3)$, $g = n^(1 slash 2)$. Træk eksponenterne fra:
      #eq[$ n^(1 slash 3) / n^(1 slash 2) = n^(1 slash 3 - 1 slash 2) = n^(-1 slash 6) -> 0, $]
      negativ eksponent betyder aftagende. *Sand.*

    Sande: *(b), (c), (g)*.
  ],
)

#qcard(
  tag: [O-notation: er X = O(Y)? (vækststigen)],
  source: "MCQ juni 2017, Spm. 5 (flere rigtige)",
  theory: <th-asym-ladder>,
  prompt: [Hvilke af følgende er sande? (Et eller flere svar.)],
  options: (
    [$#swap[$n^2$]$ er $O(#swap[$n^3$])$],
    [$#swap[$n^2$]$ er $o(#swap[$n^3$])$],
    [$#swap[$n^2$]$ er $Theta(#swap[$3n^2 + 2n^3$])$],
    [$#swap[$2^n$]$ er $O(#swap[$n^4$])$],
    [$#swap[$n^2$]$ er $O(#swap[$4^n$])$],
    [$#swap[$(log n)^4$]$ er $O(#swap[$n slash (log n)^4$])$],
    [$#swap[$4^n$]$ er $omega(#swap[$2^n$])$],
    [$#swap[$(1 slash 2)^n$]$ er $O(#swap[$(1 slash 4)^n$])$],
    [$#swap[$1 slash log n$]$ er $O(#swap[$1$])$],
    [$#swap[$sin n$]$ er $O(#swap[$log n$])$],
  ),
  answer: [Mulighed (a), (b), (e), (f), (g), (i) og (j) er sande.],
  blueprint: [
    Her er flere symboler i spil end bare $O$. Oversæt forholdet til det symbol linjen påstår.

    + Forenkl, og regn $L = lim f(n) slash g(n)$.
    + $O$ holder når $L$ er endeligt (også $0$). $o$ kræver $L = 0$. $Theta$ kræver en konstant $> 0$. $omega$ kræver $L = infinity$.
    + Brug stigen: konstant $< 1 slash log n < (log n)^k < $ potens $< $ eksponentiel.
    + Mellem to eksponentialer $a^n$ og $b^n$ vinder det største grundtal.
    + En begrænset funktion som $sin n$ er $O$ af alt, der ikke selv går mod $0$.
  ],
  worked: [
    Hver linje påstår et bestemt symbol. Jeg regner $L = lim f slash g$ og tjekker om symbolet passer: $O$ kræver $L$ endeligt (også $0$), $o$ kræver $L = 0$, $Theta$ en konstant $> 0$, $omega$ kræver $L = infinity$.

    - *(a, b)* $f = n^2$, $g = n^3$:
      #eq[$ n^2 / n^3 = 1 / n -> 0. $]
      $L = 0$ giver både $O$ (linje a) og $o$ (linje b). Begge *sande.*
    - *(c)* $f = n^2$, $g = 3n^2 + 2n^3$. Det hurtigste led i $g$ er $2n^3$, så
      #eq[$ n^2 / (3n^2 + 2n^3) approx n^2 / (2n^3) = 1 / (2n) -> 0. $]
      $Theta$ kræver en konstant $> 0$, men $L = 0$. *Falsk.*
    - *(d)* $f = 2^n$, $g = n^4$. Eksponentiel slår potens: $2^n slash n^4 -> infinity$. Linjen siger $O$, men $L = infinity$. *Falsk.*
    - *(e)* $f = n^2$, $g = 4^n$. Potens under eksponentiel: $n^2 slash 4^n -> 0$, så $L$ endeligt og $O$ holder. *Sand.*
    - *(f)* $f = (log n)^4$, $g = n slash (log n)^4$. At dele med en brøk er at gange med den omvendte:
      #eq[$ (log n)^4 / (n slash (log n)^4) = (log n)^4 dot (log n)^4 / n = (log n)^8 / n -> 0, $]
      for en rod af $n$ slår enhver potens af $log n$. $O$ holder. *Sand.*
    - *(g)* $f = 4^n$, $g = 2^n$:
      #eq[$ 4^n / 2^n = (4 / 2)^n = 2^n -> infinity. $]
      $L = infinity$ er præcis hvad $omega$ kræver. *Sand.*
    - *(h)* $f = (1 slash 2)^n$, $g = (1 slash 4)^n$:
      #eq[$ (1 slash 2)^n / (1 slash 4)^n = ((1 slash 2) / (1 slash 4))^n = 2^n -> infinity. $]
      $O$ kræver $L$ endeligt, men $L = infinity$. *Falsk.*
    - *(i)* $f = 1 slash log n$, $g = 1$:
      #eq[$ (1 slash log n) / 1 = 1 / log n -> 0. $]
      Endeligt, så $O(1)$ holder. *Sand.*
    - *(j)* $f = sin n$, $g = log n$. Da $abs(sin n) <= 1$ for alle $n$ og $log n -> infinity$, er
      #eq[$ abs(sin n) / log n <= 1 / log n -> 0. $]
      En afgrænset funktion er $O$ af alt der ikke selv går mod $0$. *Sand.*

    Sande: *(a), (b), (e), (f), (g), (i), (j)*.
  ],
)

#qcard(
  tag: [O-notation: er X = O(Y)? (vækststigen)],
  source: "MCQ juni 2019, Spm. 5 (flere rigtige)",
  theory: <th-asym-ladder>,
  prompt: [Hvilke af følgende er sande? (Et eller flere svar.)],
  options: (
    [$#swap[$n^3$]$ er $O(#swap[$n^2$])$],
    [$#swap[$log n$]$ er $O(#swap[$n^(1 slash 2)$])$],
    [$#swap[$1$]$ er $O(#swap[$n^(1 slash 3)$])$],
    [$#swap[$n^(3 slash 2)$]$ er $O(#swap[$n log n$])$],
    [$#swap[$1.5^n$]$ er $O(#swap[$n^(15)$])$],
    [$#swap[$n log n$]$ er $O(#swap[$n(log n)^3 + n^(1 slash 3)$])$],
  ),
  answer: [Mulighed (b), (c) og (f) er sande.],
  blueprint: [
    Samme spørgsmål hver linje: vokser venstresiden højst lige så hurtigt som højresiden?

    + Forenkl begge sider; i en sum tæller kun det hurtigste led.
    + Placér $f$ og $g$ på stigen og sammenlign.
    + $f$ er $O(g)$ netop når $g$ vokser mindst lige så hurtigt som $f$.
    + En eksponentiel er aldrig $O$ af en potens.
    + Brug $log(n!) = Theta(n log n)$ (Stirling), hvis $log(n!)$ dukker op.
  ],
  worked: [
    $f = O(g)$ holder netop når $f slash g$ er afgrænset. Jeg regner forholdet for hver linje.

    - *(a)* $f = n^3$, $g = n^2$:
      #eq[$ n^3 / n^2 = n -> infinity. $]
      *Falsk.*
    - *(b)* $f = log n$, $g = n^(1 slash 2) = sqrt(n)$:
      #eq[$ (log n) / sqrt(n) -> 0, $]
      for en rod slår $log$. *Sand.*
    - *(c)* $f = 1$, $g = n^(1 slash 3)$:
      #eq[$ 1 / n^(1 slash 3) -> 0, $]
      en konstant delt med noget voksende. *Sand.*
    - *(d)* $f = n^(3 slash 2)$, $g = n log n$. Forkort $n$:
      #eq[$ n^(3 slash 2) / (n log n) = n^(3 slash 2 - 1) / log n = n^(1 slash 2) / log n = sqrt(n) / log n -> infinity, $]
      for en rod slår $log$. *Falsk.*
    - *(e)* $f = 1.5^n$, $g = n^(15)$. Eksponentiel slår potens:
      #eq[$ 1.5^n / n^(15) -> infinity. $]
      *Falsk.*
    - *(f)* $f = n log n$, $g = n(log n)^3 + n^(1 slash 3)$. Det hurtigste led i $g$ er $n(log n)^3$ (det slår $n^(1 slash 3)$). Forkort $n$ og én $log n$:
      #eq[$ (n log n) / (n(log n)^3) = (log n)^(1-3) = 1 / (log n)^2 -> 0. $]
      *Sand.*

    Sande: *(b), (c), (f)*.
  ],
)

#qcard(
  tag: [O-notation: er X = O(Y)? (vækststigen)],
  source: "MCQ juni 2021, Spm. 5 (flere rigtige)",
  theory: <th-asym-ladder>,
  prompt: [Hvilke af følgende er sande? ($log n$ er grundtal to.) (Et eller flere svar.)],
  options: (
    [$#swap[$n$]$ er $O(#swap[$log n$])$],
    [$#swap[$(log n)^3$]$ er $O(#swap[$n^2$])$],
    [$#swap[$n log n$]$ er $O(#swap[$n^(1.5)$])$],
    [$#swap[$2^n$]$ er $O(#swap[$sqrt(n)$])$],
    [$#swap[$3n^2$]$ er $O(#swap[$n^2$])$],
    [$#swap[$7^n$]$ er $O(#swap[$(log n)^7$])$],
    [$#swap[$log(n!)$]$ er $O(#swap[$n^2$])$],
  ),
  answer: [Mulighed (b), (c), (e) og (g) er sande.],
  blueprint: [
    $f$ er $O(g)$ netop når $f slash g$ holder sig afgrænset. Stigen klarer det meste.

    + Placér $f$ og $g$ på stigen: konstant $< log n < (log n)^k < n^epsilon < n^c < c^n$.
    + En $(log n)^k$ slås af enhver positiv potens af $n$.
    + Konstante faktorer forsvinder i $O$.
    + Brug $log(n!) = Theta(n log n)$ (Stirling).
  ],
  worked: [
    $f = O(g)$ holder netop når $f slash g$ holder sig afgrænset. Jeg regner forholdet linje for linje.

    - *(a)* $f = n$, $g = log n$:
      #eq[$ n / log n -> infinity, $]
      for $n$ vokser meget hurtigere end $log n$. *Falsk.*
    - *(b)* $f = (log n)^3$, $g = n^2$:
      #eq[$ (log n)^3 / n^2 -> 0, $]
      en polylog under en potens. *Sand.*
    - *(c)* $f = n log n$, $g = n^(1.5)$. Forkort $n$:
      #eq[$ (n log n) / n^(1.5) = (log n) / n^(0.5) = (log n) / sqrt(n) -> 0, $]
      rod slår $log$. *Sand.*
    - *(d)* $f = 2^n$, $g = sqrt(n)$. Eksponentiel slår enhver potens: $2^n slash sqrt(n) -> infinity$. *Falsk.*
    - *(e)* $f = 3n^2$, $g = n^2$:
      #eq[$ (3n^2) / n^2 = 3, $]
      en konstant, så $O$ holder (konstante faktorer er ligegyldige). *Sand.*
    - *(f)* $f = 7^n$, $g = (log n)^7$. En eksponentialfunktion slår enhver potens af $log n$:
      #eq[$ 7^n / (log n)^7 -> infinity. $]
      *Falsk.*
    - *(g)* $f = log(n!)$, $g = n^2$. Ved Stirling er $log(n!) = Theta(n log n)$, så
      #eq[$ (log(n!)) / n^2 approx (n log n) / n^2 = (log n) / n -> 0. $]
      *Sand.*

    Sande: *(b), (c), (e), (g)*.
  ],
)

#qcard(
  tag: [O-notation: er X = O(Y)? (vækststigen)],
  source: "MCQ juni 2025, Spm. 5 (flere rigtige)",
  theory: <th-asym-ladder>,
  prompt: [Hvilke af følgende er sande? Afgør for hvert par om $f(n) = O(g(n))$. (Et eller flere svar.)],
  options: (
    [$#swap[$3n^4$]$ er $O(#swap[$4n^3$])$],
    [$#swap[$4n$]$ er $O(#swap[$n slash 3$])$],
    [$#swap[$sqrt(n)$]$ er $O(#swap[$log n$])$],
    [$#swap[$n^2 slash 2 + n^3 slash 3$]$ er $O(#swap[$2n$])$],
    [$#swap[$n log n$]$ er $O(#swap[$n^2 slash (log n)^2$])$],
    [$#swap[$n^(10)$]$ er $O(#swap[$10^n$])$],
    [$#swap[$log_4 n$]$ er $O(#swap[$log_3 n$])$],
  ),
  answer: [Mulighed (b), (e), (f) og (g) er sande.],
  blueprint: [
    $f$ er $O(g)$ netop når $f slash g$ er endeligt langt ude.

    + Konstante faktorer er ligegyldige: $O(c g) = O(g)$.
    + Brug rangordnen $log n << sqrt(n) << n << n log n << n^2 << n^3 << dots.h << c^n$.
    + En højere potens er aldrig $O$ af en lavere.
    + Alle logaritmer er ens på nær en konstant, så $log_a n = O(log_b n)$ uanset grundtal.
    + Enhver potens er $O$ af enhver eksponentiel $c^n$ med $c > 1$.
  ],
  worked: [
    $f = O(g)$ holder netop når $f slash g$ er endeligt langt ude. Jeg regner forholdet for hver linje.

    - *(a)* $f = 3n^4$, $g = 4n^3$. Konstanterne er ligegyldige, så se på $n^4 slash n^3$:
      #eq[$ (3n^4) / (4n^3) = 3/4 dot n -> infinity. $]
      *Falsk.*
    - *(b)* $f = 4n$, $g = n slash 3$. Begge er lineære, så forholdet er en ren konstant:
      #eq[$ (4n) / (n slash 3) = 4n dot 3/n = 12. $]
      Endeligt, så $O$ holder. *Sand.*
    - *(c)* $f = sqrt(n)$, $g = log n$. En rod slår $log$:
      #eq[$ sqrt(n) / log n -> infinity. $]
      *Falsk.*
    - *(d)* $f = n^2 slash 2 + n^3 slash 3$, $g = 2n$. Det hurtigste led i $f$ er $n^3 slash 3$, så
      #eq[$ (n^3 slash 3) / (2n) = n^2 / 6 -> infinity. $]
      *Falsk.*
    - *(e)* $f = n log n$, $g = n^2 slash (log n)^2$. Det er nemmest at se på $g slash f$:
      #eq[$ g / f = (n^2 slash (log n)^2) / (n log n) = n^2 / (log n)^2 dot 1 / (n log n) = n / (log n)^3 -> infinity, $]
      altså $f slash g -> 0$. $O$ holder. *Sand.*
    - *(f)* $f = n^(10)$, $g = 10^n$. En eksponentialfunktion slår enhver potens:
      #eq[$ n^(10) / 10^n -> 0. $]
      *Sand.*
    - *(g)* $f = log_4 n$, $g = log_3 n$. Skift grundtal: $log_4 n = (log_3 n) slash (log_3 4)$, så
      #eq[$ (log_4 n) / (log_3 n) = 1 / (log_3 4), $]
      en ren konstant. Alle logaritmer er ens på nær en konstant. *Sand.*

    Sande: *(b), (e), (f), (g)*.
  ],
)

#qcard(
  tag: [Asymptotik: O / Ω / Θ / o / ω sand? (grænseværdi)],
  source: "MCQ juni 2023, Spm. 6",
  theory: <th-asym-limit>,
  prompt: [Hvilke af følgende er sande? (Et eller flere svar.)],
  options: (
    [$#swap[$n$]$ er $Omega(#swap[$(log n)^2$])$],
    [$#swap[$4^n$]$ er $omega(#swap[$2^n$])$],
    [$#swap[$n + n + n$]$ er $Theta(#swap[$n slash 3$])$],
    [$#swap[$(log n)^3$]$ er $Theta(#swap[$3 log n$])$],
    [$#swap[$n^2 slash log n$]$ er $o(#swap[$n^2 log n$])$],
    [$#swap[$n^(1.5) + n^(2.0)$]$ er $Theta(#swap[$n^(1.75)$])$],
    [$#swap[$2^n$]$ er $o(#swap[$n^n$])$],
  ),
  answer: [(a), (b), (c), (e) og (g) er sande.],
  blueprint: [
    Her blandes alle fem symboler, så du kan ikke bare bruge stigen. Regn forholdet og oversæt grænseværdien til det symbol linjen påstår.

    + Forenkl begge sider, så kun det hurtigste led står tilbage.
    + Regn $L = lim_(n -> infinity) #swap[$f(n) slash g(n)$]$.
    + Oversæt $L$: en konstant $> 0$ giver $Theta$. $L = 0$ giver $o$ og $O$. $L = infinity$ giver $omega$ og $Omega$.
    + Tjek om symbolet i linjen passer til det $L$ du fik. $Theta$ er strengest og kræver en konstant — hverken $0$ eller $infinity$.
  ],
  worked: [
    Jeg regner $L = lim f slash g$ for hver linje og holder det op mod symbolet der står. Husk: $Omega$ kræver $L > 0$ (også $infinity$), $omega$ kræver $L = infinity$, $Theta$ en konstant $> 0$, $o$ kræver $L = 0$.

    - *(a)* $f = n$, $g = (log n)^2$:
      #eq[$ n / (log n)^2 -> infinity, $]
      for en potens af $n$ slår enhver polylog. Linjen siger $Omega$, og $L = infinity > 0$. Passer. *Sand.*
    - *(b)* $f = 4^n$, $g = 2^n$:
      #eq[$ 4^n / 2^n = (4 / 2)^n = 2^n -> infinity. $]
      Strengt hurtigere, så $omega$. *Sand.*
    - *(c)* $f = n + n + n = 3n$, $g = n slash 3$:
      #eq[$ (3n) / (n slash 3) = 3n dot 3/n = 9. $]
      En konstant $> 0$, så $Theta$. *Sand.*
    - *(d)* $f = (log n)^3$, $g = 3 log n$. Forkort én $log n$:
      #eq[$ (log n)^3 / (3 log n) = (log n)^(3-1) / 3 = (log n)^2 / 3 -> infinity. $]
      Linjen siger $Theta$, men $L$ er ikke en konstant. *Falsk.*
    - *(e)* $f = n^2 slash log n$, $g = n^2 log n$:
      #eq[$ (n^2 slash log n) / (n^2 log n) = n^2 / (n^2 (log n)^2) = 1 / (log n)^2 -> 0. $]
      $L = 0$, så $o$. *Sand.*
    - *(f)* $f = n^(1.5) + n^(2.0)$, $g = n^(1.75)$. Det hurtigste led i $f$ er $n^2$, så
      #eq[$ n^2 / n^(1.75) = n^(2 - 1.75) = n^(0.25) -> infinity. $]
      Linjen siger $Theta$, men $L = infinity$. *Falsk.*
    - *(g)* $f = 2^n$, $g = n^n$:
      #eq[$ 2^n / n^n = (2 / n)^n -> 0, $]
      for $2 slash n < 1$ fra $n = 3$ og opefter. $L = 0$, så $o$. *Sand.*

    Sande: *(a), (b), (c), (e)* og *(g)*.
  ],
)

#qcard(
  tag: [Asymptotik: O / Ω / Θ / o / ω sand? (grænseværdi)],
  source: "MCQ juni 2019, Spm. 6 (flere rigtige)",
  theory: <th-asym-limit>,
  prompt: [Hvilke af følgende er sande? (Et eller flere svar.)],
  options: (
    [$#swap[$n^(1 slash 2) + 2n^2 + (log n)^2$]$ er $Theta(#swap[$n^2$])$],
    [$#swap[$n$]$ er $Omega(#swap[$n$])$],
    [$#swap[$2^n$]$ er $o(#swap[$n^3$])$],
    [$#swap[$(log n)^3$]$ er $omega(#swap[$n slash log n$])$],
    [$#swap[$n^(1 slash 3)$]$ er $o(#swap[$n^(1 slash 2)$])$],
    [$#swap[$2n^3 + 4n^5$]$ er $Theta(#swap[$5n^4 + 3n^2$])$],
  ),
  answer: [Mulighed (a), (b) og (e) er sande.],
  blueprint: [
    Find det hurtigste led på hver side, og oversæt forholdet til symbolet linjen påstår.

    + Forenkl, så kun det dominerende led står tilbage.
    + $Theta$: samme vækstorden på begge sider. $Omega$: venstre vokser mindst lige så hurtigt.
    + $o$: venstre strengt langsommere ($L = 0$). $omega$: venstre strengt hurtigere ($L = infinity$).
    + Rangorden: polylog $<$ potens $<$ eksponentiel.
  ],
  worked: [
    Jeg finder det hurtigste led på hver side, regner $L = lim f slash g$ og tjekker symbolet.

    - *(a)* $f = n^(1 slash 2) + 2n^2 + (log n)^2$, $g = n^2$. Det hurtigste led i $f$ er $2n^2$ (det slår både $sqrt(n)$ og $(log n)^2$), så
      #eq[$ (2n^2) / n^2 = 2, $]
      en konstant $> 0$, altså $Theta(n^2)$. *Sand.*
    - *(b)* $f = n$, $g = n$:
      #eq[$ n / n = 1. $]
      $L = 1 > 0$, så $Omega(n)$ holder ($Theta$ ville også). *Sand.*
    - *(c)* $f = 2^n$, $g = n^3$. Eksponentiel slår potens:
      #eq[$ 2^n / n^3 -> infinity. $]
      Det er $omega(n^3)$, men linjen påstår $o$ (som kræver $L = 0$). *Falsk.*
    - *(d)* $f = (log n)^3$, $g = n slash log n$. Saml til ét forhold:
      #eq[$ (log n)^3 / (n slash log n) = (log n)^3 dot (log n) / n = (log n)^4 / n -> 0. $]
      $L = 0$, så venstre er $o$ af højre, ikke $omega$. *Falsk.*
    - *(e)* $f = n^(1 slash 3)$, $g = n^(1 slash 2)$:
      #eq[$ n^(1 slash 3) / n^(1 slash 2) = n^(1 slash 3 - 1 slash 2) = n^(-1 slash 6) -> 0. $]
      $L = 0$, så $o$. *Sand.*
    - *(f)* $f = 2n^3 + 4n^5$, $g = 5n^4 + 3n^2$. Hurtigste led: $4n^5$ mod $5n^4$, så
      #eq[$ (4n^5) / (5n^4) = 4/5 dot n -> infinity. $]
      Forskellig orden, så ikke $Theta$. *Falsk.*

    Sande: *(a), (b), (e)*.
  ],
)

#qcard(
  tag: [Asymptotik: O / Ω / Θ / o / ω sand? (grænseværdi)],
  source: "MCQ juni 2021, Spm. 6 (flere rigtige)",
  theory: <th-asym-limit>,
  prompt: [Hvilke af følgende er sande? ($log n$ er grundtal to.) (Et eller flere svar.)],
  options: (
    [$#swap[$log n$]$ er $omega(#swap[$n^2$])$],
    [$#swap[$n^2 + n^3$]$ er $Theta(#swap[$n^3$])$],
    [$#swap[$6$]$ er $o(#swap[$7$])$],
    [$#swap[$3^n$]$ er $Omega(#swap[$2^n$])$],
    [$#swap[$n slash (log n)^2$]$ er $o(#swap[$(log n)^3$])$],
    [$#swap[$n^n$]$ er $Omega(#swap[$2^n$])$],
    [$#swap[$n^(1.1)$]$ er $omega(#swap[$n log n$])$],
  ),
  answer: [Mulighed (b), (d), (f) og (g) er sande.],
  blueprint: [
    Regn $L = lim f(n) slash g(n)$ og slå symbolet op.

    + $o$ sand når $L = 0$; $omega$ når $L = infinity$; $Theta$ når $0 < L < infinity$; $Omega$ når $L > 0$ (også $infinity$); $O$ når $L < infinity$.
    + Rangorden: konstanter $<$ logaritmer $<$ potenser $<$ eksponentialer $< n^n$.
  ],
  worked: [
    Jeg regner $L = lim f slash g$ for hver linje og slår symbolet op: $o$ kræver $L = 0$, $omega$ kræver $L = infinity$, $Theta$ en konstant $> 0$, $Omega$ kræver $L > 0$.

    - *(a)* $f = log n$, $g = n^2$:
      #eq[$ (log n) / n^2 -> 0. $]
      Det er $o(n^2)$, men linjen påstår $omega$ (kræver $L = infinity$). *Falsk.*
    - *(b)* $f = n^2 + n^3$, $g = n^3$. Hurtigste led $n^3$:
      #eq[$ (n^2 + n^3) / n^3 = 1/n + 1 -> 1. $]
      En konstant $> 0$, så $Theta(n^3)$. *Sand.*
    - *(c)* $f = 6$, $g = 7$, begge konstanter:
      #eq[$ 6 / 7 approx 0.857. $]
      $L != 0$, så $o$ fejler — det er $Theta(7) = Theta(1)$. *Falsk.*
    - *(d)* $f = 3^n$, $g = 2^n$:
      #eq[$ 3^n / 2^n = (3 / 2)^n -> infinity. $]
      $L = infinity > 0$, så $Omega$ holder. *Sand.*
    - *(e)* $f = n slash (log n)^2$, $g = (log n)^3$:
      #eq[$ (n slash (log n)^2) / (log n)^3 = n / ((log n)^2 (log n)^3) = n / (log n)^5 -> infinity, $]
      for en potens af $n$ slår enhver polylog. $o$ kræver $L = 0$, så *falsk.*
    - *(f)* $f = n^n$, $g = 2^n$:
      #eq[$ n^n / 2^n = (n / 2)^n -> infinity. $]
      $L = infinity > 0$, så $Omega$. *Sand.*
    - *(g)* $f = n^(1.1)$, $g = n log n$. Forkort $n$:
      #eq[$ n^(1.1) / (n log n) = n^(0.1) / log n -> infinity, $]
      for enhver positiv potens $n^(0.1)$ slår $log n$. $L = infinity$, så $omega$. *Sand.*

    Sande: *(b), (d), (f), (g)*.
  ],
)

#qcard(
  tag: [Asymptotik: O / Ω / Θ / o / ω sand? (grænseværdi)],
  source: "MCQ juni 2025, Spm. 6 (flere rigtige)",
  theory: <th-asym-limit>,
  prompt: [Hvilke af følgende er sande? (Et eller flere svar.)],
  options: (
    [$#swap[$2^n$]$ er $Omega(#swap[$n^4$])$],
    [$#swap[$n^3$]$ er $o(#swap[$n^6 slash 2$])$],
    [$#swap[$n^2$]$ er $omega(#swap[$n^2$])$],
    [$#swap[$n^3 slash (log n)^3$]$ er $Theta(#swap[$n^2 slash (log n)^2$])$],
    [$#swap[$log n$]$ er $Omega(#swap[$1$])$],
    [$#swap[$2$]$ er $o(#swap[$1$])$],
    [$#swap[$n - 100$]$ er $Theta(#swap[$n + 100$])$],
  ),
  answer: [Mulighed (a), (b), (e) og (g) er sande.],
  blueprint: [
    Regn $L = lim f(n) slash g(n)$ for hver linje og slå symbolet op.

    + $O$ / $Omega$: afgrænset opad / nedad af en konstant gange $g$.
    + $o$: $L = 0$ (strengt mindre). $omega$: $L = infinity$ (strengt større). $Theta$: $L$ en positiv konstant.
    + $Omega(1)$ betyder "vokser mindst som en konstant" — enhver funktion, der ikke går mod $0$, kvalificerer.
  ],
  worked: [
    Jeg regner $L = lim f slash g$ for hver linje og slår symbolet op: $Omega$ kræver $L > 0$, $o$ kræver $L = 0$, $omega$ kræver $L = infinity$, $Theta$ en konstant $> 0$.

    - *(a)* $f = 2^n$, $g = n^4$. Eksponentiel slår potens:
      #eq[$ 2^n / n^4 -> infinity. $]
      $L = infinity > 0$, så $Omega(n^4)$. *Sand.*
    - *(b)* $f = n^3$, $g = n^6 slash 2$:
      #eq[$ n^3 / (n^6 slash 2) = (2 n^3) / n^6 = 2 / n^3 -> 0. $]
      $L = 0$, så $o$. *Sand.*
    - *(c)* $f = n^2$, $g = n^2$:
      #eq[$ n^2 / n^2 = 1. $]
      $L = 1$, ikke $infinity$; det er $Theta(n^2)$, ikke $omega$. *Falsk.*
    - *(d)* $f = n^3 slash (log n)^3$, $g = n^2 slash (log n)^2$:
      #eq[$ (n^3 slash (log n)^3) / (n^2 slash (log n)^2) = n^3 / (log n)^3 dot (log n)^2 / n^2 = n / log n -> infinity. $]
      Ikke en konstant, så $Theta$ fejler. *Falsk.*
    - *(e)* $f = log n$, $g = 1$:
      #eq[$ (log n) / 1 = log n -> infinity. $]
      Vokser uden grænse, altså afgrænset nedad af en konstant: $Omega(1)$. *Sand.*
    - *(f)* $f = 2$, $g = 1$, begge konstanter:
      #eq[$ 2 / 1 = 2 != 0. $]
      $o$ kræver $L = 0$; det er $Theta(1)$. *Falsk.*
    - *(g)* $f = n - 100$, $g = n + 100$:
      #eq[$ (n - 100) / (n + 100) = (1 - 100 slash n) / (1 + 100 slash n) -> 1. $]
      En konstant $> 0$, så $Theta$. *Sand.*

    Sande: *(a), (b), (e), (g)*.
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2023, Spm. 25",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME3(n): i = 1; while i <= n: { j = n; while j > 1: j = j - 1; i = `#swap[$2$]`*i }`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [(d) $Theta(n log n)$.],
  blueprint: [
    To indlejrede løkker. Du tæller den ydre og den indre hver for sig og ganger til sidst.

    + Se på hvordan tælleren i den ydre løkke ændrer sig. Plusses der med en konstant ($i = i + #swap[$c$]$), kører den $Theta(n)$ gange. Ganges der ($i = #swap[$2$] dot i$), kører den $Theta(log n)$ gange.
    + Tæl den indre løkkes arbejde for ét ydre gennemløb. Tjek om grænsen afhænger af $n$ eller af den ydre tæller.
    + Gang de to tal sammen og smid konstanter væk.
  ],
  worked: [
    + *Ydre løkke.* $i$ starter på $1$ og ganges med $2$ hvert gennemløb, så den tager værdierne $1, 2, 4, 8, dots$. Efter $k$ gennemløb er $i = 2^k$, og løkken kører mens $i <= n$:
      #eq[$ 2^k <= n quad <=> quad k <= log_2 n. $]
      Altså $floor(log_2 n) + 1 = Theta(log n)$ gennemløb.
    + *Indre løkke.* For hvert ydre gennemløb sættes $j = n$ og tælles ned til $2$ (`while j > 1`), altså $n - 1$ skridt. Vigtigt: $j$ sættes til $n$ forfra hver gang, uafhængigt af $i$, så det er $Theta(n)$ arbejde *per* ydre gennemløb.
    + *Lille talværdi.* Med $n = 8$ kører den ydre løkke for $i = 1, 2, 4, 8$ (fire gange), og hver gang laver den indre løkke $7$ skridt: i alt $4 dot 7 = 28 approx 8 log_2 8 = 8 dot 3 = 24$. Størrelsesordenen passer.
    + *Gang sammen.* Da det indre arbejde er konstant per gennemløb, ganger vi simpelthen:
      #eq[$ underbrace(Theta(log n), "ydre") dot underbrace(Theta(n), "indre") = Theta(n log n). $]

    Svaret er (d).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2015, Spm. 21",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME1(n): i = n; while i > 1: { j = n; while j > `#swap[$i$]`: j = j - 1; i = i - 1 }`],
  options: (
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (d): $Theta(n^2)$.],
  blueprint: [
    Når den indre grænse afhænger af den ydre tæller, summerer du i stedet for bare at gange.

    + Find hvor mange skridt den indre løkke tager for en fast ydre tæller. Her er det $n - i$.
    + Læg sammen over den ydre tæller i stedet for at gange med et fast tal.
    + Summen $sum (n - i)$ giver en trekant, og en trekant er $Theta(n^2)$ — halvdelen af firkanten, men samme klasse.
  ],
  worked: [
    + *Indre løkke.* For et fast ydre $i$ sættes $j = n$ og tælles ned mens $j > i$, altså til $j = i$. Det er $n - i$ skridt.
    + *Ydre løkke.* $i$ løber fra $n$ ned til $2$ (`while i > 1`), ét skridt ad gangen.
    + *Indre arbejde varierer med $i$*, så vi kan ikke bare gange — vi summerer $n - i$ over alle ydre værdier:
      #eq[$ sum_(i=2)^n (n - i) = (n-2) + (n-3) + dots + 1 + 0. $]
      Det er summen $0 + 1 + dots + (n-2) = (n-2)(n-1) slash 2$:
      #eq[$ sum_(i=2)^n (n - i) = ((n-2)(n-1)) / 2 approx n^2 / 2. $]
    + *Konkret med $n = 5$:* $i = 5, 4, 3, 2$ giver indre arbejde $0, 1, 2, 3$, i alt $6 = (3 dot 4) slash 2$. Stemmer med formlen.

    En trekant af arbejde er halvdelen af firkanten, men stadig $Theta(n^2)$. Svaret er (d).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2015, Spm. 23",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME3(n): i = 1; while i <= n: { j = 1; while j <= `#swap[$i$]`: j = j + 1; i = `#swap[$2$]`*i }`],
  options: (
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (b): $Theta(n)$.],
  blueprint: [
    Den ydre tæller fordobles, men den indre arbejder op til $i$. En geometrisk sum styres af sit største led.

    + Den ydre løkke fordobler $i$, så den kører $Theta(log n)$ gange med værdierne $1, 2, 4, dots, n$.
    + Den indre løkke koster $i$ skridt for hvert ydre gennemløb.
    + Summér $i$ over de ydre værdier: $1 + 2 + 4 + dots + n$. Den geometriske sum er $approx 2n$, domineret af det sidste led.
  ],
  worked: [
    + *Ydre løkke.* $i$ fordobles fra $1$, så $i = 1, 2, 4, dots, n$. Efter $k$ gennemløb er $i = 2^k$, og løkken kører mens $i <= n$, altså $Theta(log n)$ gennemløb.
    + *Indre arbejde.* For et fast $i$ tæller den indre løkke $j = 1, 2, dots, i$ ét ad gangen (`j = j + 1`), altså $i$ skridt.
    + *Indre arbejde varierer*, så vi summerer $i$ over de ydre værdier. Det er en geometrisk række:
      #eq[$ 1 + 2 + 4 + dots + n = sum_(k=0)^(log_2 n) 2^k = 2^(log_2 n + 1) - 1 = 2n - 1. $]
    + *Konkret med $n = 8$:* indre arbejde er $1 + 2 + 4 + 8 = 15 = 2 dot 8 - 1$. Stemmer.

    Det sidste led $n$ alene dominerer hele summen, så $2n - 1 = Theta(n)$. Svaret er (b).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2015, Spm. 24",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME4(n): i = 1; while i <= n: { j = 1; while j <= i: j = `#swap[$2$]`*j; i = i + `#swap[$1$]` }`],
  options: (
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (c): $Theta(n log n)$.],
  blueprint: [
    Ydre løkke lineær, indre løkke multiplikativ op til $i$. Summen af logaritmer er $Theta(n log n)$.

    + Den ydre løkke plusser med $1$, så den kører $Theta(n)$ gange.
    + Den indre løkke fordobler $j$ op til $i$, så den koster $log i$ skridt.
    + Summér: $sum_(i=1)^n log i = log(n!) = Theta(n log n)$ ved Stirling.
  ],
  worked: [
    + *Ydre løkke.* $i$ plusses med $1$ fra $1$ til $n$ (`i = i + 1`), altså $n$ gennemløb, $Theta(n)$.
    + *Indre arbejde.* For et fast $i$ fordobles $j$ fra $1$ mens $j <= i$, altså $j = 1, 2, 4, dots$. Antallet af skridt for at nå $i$ er $floor(log_2 i) + 1 = Theta(log i)$.
    + *Summér over $i$:*
      #eq[$ sum_(i=1)^n (floor(log_2 i) + 1) = (sum_(i=1)^n log_2 i) + n = log_2(1 dot 2 dots.h n) + n = log_2(n!) + n. $]
    + *Stirling.* $log_2(n!) = Theta(n log n)$, og $n$ er af lavere orden, så summen er $Theta(n log n)$.
    + *Konkret med $n = 4$:* indre skridt for $i = 1, 2, 3, 4$ er $1, 2, 2, 3$, i alt $8$. Til sammenligning er $n log_2 n = 4 dot 2 = 8$. Samme størrelsesorden.

    Svaret er (c).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2017, Spm. 20",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITHM1(n): s = 0; for i = 1 to n: for j = 1 to n: if i == j: for k = 1 to n: s = s + 1`],
  options: (
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (d): $Theta(n^2)$.],
  blueprint: [
    En vagt foran den inderste løkke kan skære en hel faktor $n$ væk. Tæl hvor mange gange løkken faktisk fyrer.

    + De to ydre løkker kører $n dot n = n^2$ gange uanset hvad, så `if`-testen udføres $n^2$ gange.
    + Den inderste løkke fyrer kun når betingelsen holder. Tæl hvor ofte det sker.
    + Gang antallet af fyringer med arbejdet per fyring og læg til de $n^2$ fra testene.
  ],
  worked: [
    + *Ydre arbejde.* `for i = 1 to n` og `for j = 1 to n` kører $n dot n = n^2$ gange tilsammen, og `if i == j` evalueres $n^2$ gange. Det alene er $Theta(n^2)$.
    + *Hvornår fyrer den inderste løkke?* Betingelsen `i == j` er kun sand på diagonalen, altså for parrene $(1,1), (2,2), dots, (n,n)$. Det er $n$ gange ud af de $n^2$.
    + *Inderste løkke.* Hver gang `i == j` holder, kører `for k = 1 to n` præcis $n$ gange. Samlet inderste arbejde:
      #eq[$ underbrace(n, "antal diagonalpunkter") dot underbrace(n, "k-løkkens skridt") = n^2. $]
    + *Læg sammen.* $n^2$ (tests) $+ n^2$ (inderste løkke) $= Theta(n^2)$.
    + *Hvorfor ikke $n^3$?* Uden vagten ville den inderste løkke køre for alle $n^2$ par og give $n^2 dot n = n^3$. Vagten skærer den ned til kun de $n$ diagonalpunkter, så en hel faktor $n$ forsvinder.

    Svaret er (d).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2017, Spm. 22",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME3(n): i = n; while i > 1: { j = i; while j < n: j = j + 1; i = i/`#swap[$2$]` }`],
  options: (
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (c): $Theta(n log n)$.],
  blueprint: [
    Ydre løkke halverer, indre løkke arbejder $n - i$ skridt. Summen over de halverede $i$-værdier domineres af $n log n$.

    + Den ydre løkke halverer $i$, så den kører $Theta(log n)$ gange.
    + Den indre løkke koster $n - i$ skridt for det aktuelle $i$.
    + Summér $(n - i)$ over $i = n, n slash 2, n slash 4, dots$. Det giver $approx n log n - 2n$, og $n log n$ dominerer.
  ],
  worked: [
    + *Ydre løkke.* $i$ starter på $n$ og halveres hvert gennemløb (`i = i/2`), så $i = n, n slash 2, n slash 4, dots, 1$. Det er $Theta(log n)$ gennemløb.
    + *Indre arbejde.* For et fast $i$ går $j$ fra $i$ op til $n$ (`while j < n`), altså $n - i$ skridt.
    + *Summér over de halverede $i$-værdier.* Skriv $i = n slash 2^t$ for $t = 0, 1, dots, log_2 n$:
      #eq[$ sum_(t=0)^(log_2 n) (n - n/2^t) = n(log_2 n + 1) - n sum_(t=0)^(log_2 n) 1/2^t. $]
      Den geometriske sum $sum 1 slash 2^t < 2$, så det andet led er højst $2n$:
      #eq[$ approx n log_2 n - 2n = Theta(n log n). $]
    + *Konkret med $n = 8$:* $i = 8, 4, 2, 1$ giver indre arbejde $n - i = 0, 4, 6, 7$, i alt $17$. Til sammenligning er $n log_2 n = 8 dot 3 = 24$. Samme størrelsesorden.

    Det dominerende led er $n log n$. Svaret er (c).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2019, Spm. 24",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME1(n): i = 1; j = n; while i < j: { i = i + `#swap[$1$]`; j = j - `#swap[$1$]` }`],
  options: (
    [$Theta(log n)$],
    [$Theta((log n)^2)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n(log n)^2)$],
    [$Theta(n^2)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (c): $Theta(n)$.],
  blueprint: [
    To tællere bevæger sig mod hinanden. Find hvor hurtigt afstanden lukkes, og hvor mange gennemløb det giver.

    + Find startafstanden mellem de to tællere.
    + Se hvor meget afstanden krymper per gennemløb.
    + Antal gennemløb $= $ startafstand delt med krympning. Gang med konstant arbejde per gennemløb.
  ],
  worked: [
    + *Startafstand.* $i = 1$ og $j = n$, så afstanden mellem dem er $j - i = n - 1$.
    + *Krympning per gennemløb.* Hvert gennemløb gør $i = i + 1$ og $j = j - 1$, så $i$ rykker $1$ op og $j$ rykker $1$ ned. Afstanden $j - i$ falder dermed med $2$ hvert gennemløb.
    + *Antal gennemløb.* Løkken stopper når $i >= j$, altså når afstanden er brugt op:
      #eq[$ "antal gennemløb" approx (n - 1) / 2 = Theta(n). $]
    + *Konkret med $n = 7$:* $(i, j)$ går $(1,7) -> (2,6) -> (3,5) -> (4,4)$, og ved $i = j = 4$ stopper `while i < j`. Det er $3 approx (7-1) slash 2$ gennemløb.
    + *Arbejde.* Hvert gennemløb er konstant-tid ($O(1)$), så $Theta(n) dot O(1) = Theta(n)$.

    Svaret er (c).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2019, Spm. 25",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME3(n): i = n; while i > 1: { j = 1; while j < i: j = `#swap[$2$]`*j; i = i - `#swap[$1$]` }`],
  options: (
    [$Theta(log n)$],
    [$Theta((log n)^2)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n(log n)^2)$],
    [$Theta(n^2)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (d): $Theta(n log n)$.],
  blueprint: [
    Ydre løkke lineær, indre løkke multiplikativ op til $i$. Summen af logaritmer er $Theta(n log n)$.

    + Den ydre løkke minusser med $1$, så den kører $Theta(n)$ gange.
    + Den indre løkke fordobler $j$ op til $i$, altså $Theta(log i)$ skridt.
    + Summér: $sum log i = log(n!) = Theta(n log n)$ ved Stirling.
  ],
  worked: [
    + *Ydre løkke.* $i$ minusses med $1$ fra $n$ ned til $2$ (`while i > 1`), altså $n - 1 = Theta(n)$ gennemløb.
    + *Indre arbejde.* For et fast $i$ fordobles $j$ fra $1$ mens $j < i$, altså $j = 1, 2, 4, dots$. Antallet af skridt for at passere $i$ er $ceil(log_2 i) = Theta(log i)$.
    + *Summér over $i$.* Da arbejdet varierer med $i$, lægger vi sammen:
      #eq[$ sum_(i=2)^n log_2 i = log_2(2 dot 3 dots.h n) = log_2(n!). $]
    + *Stirling.* $log_2(n!) = Theta(n log n)$.
    + *Konkret med $n = 8$:* indre skridt for $i = 8, 7, dots, 2$ er $log_2$-værdierne $3, 3, 3, 3, 2, 2, 1$, i alt $17 approx n log_2 n = 24$. Samme størrelsesorden.

    Svaret er (d).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2019, Spm. 26",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME4(n): i = 1; while i < n: { j = i; while j > 1: j = j/`#swap[$2$]`; i = `#swap[$2$]`*i }`],
  options: (
    [$Theta(log n)$],
    [$Theta((log n)^2)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n(log n)^2)$],
    [$Theta(n^2)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (b): $Theta((log n)^2)$.],
  blueprint: [
    Begge løkker er multiplikative. Den ydre fordobler, den indre halverer op til $i$. Summen af logaritmer over en logaritmisk ydre løkke giver $(log n)^2$.

    + Den ydre løkke fordobler $i$, så den kører $approx log_2 n$ gange.
    + Den indre løkke halverer $j$ fra $i$ ned til $1$, altså $log_2 i$ skridt.
    + Ved det $k$'te ydre gennemløb er $i = 2^k$, så indre arbejde $approx k$. Summér: $sum_(k=0)^(log n) k = Theta((log n)^2)$.
  ],
  worked: [
    + *Ydre løkke.* $i$ fordobles fra $1$ (`i = 2*i`), så $i = 1, 2, 4, dots$ mens $i < n$. Det er $ceil(log_2 n)$ gennemløb. Ved det $k$'te gennemløb (talt fra $k = 0$) er $i = 2^k$.
    + *Indre arbejde.* For et fast $i$ halveres $j = i$ ned til $1$ (`while j > 1`), altså $log_2 i$ skridt. Med $i = 2^k$ er det netop $k$ skridt.
    + *Summér over gennemløbene.* Det indre arbejde vokser med $k$, så vi lægger sammen:
      #eq[$ sum_(k=0)^(log_2 n) k = (log_2 n (log_2 n + 1)) / 2 = Theta((log n)^2). $]
    + *Konkret med $n = 16$:* ydre $i = 1, 2, 4, 8$ ($k = 0, 1, 2, 3$) giver indre skridt $0, 1, 2, 3$, i alt $6 approx (log_2 16)^2 = 16$ i størrelsesorden (en trekant af logaritmer).

    Svaret er (b).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2021, Spm. 24",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITHM1(n): s = 0; for i = 1 to n: s = i + s`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (c): $Theta(n)$.],
  blueprint: [
    Én løkke med konstant arbejde i kroppen. Tæl gennemløbene og gang med $O(1)$.

    + Find hvor mange gange løkken kører som funktion af $n$.
    + Gang med arbejdet per gennemløb. Et additivt skridt op til $n$ giver $Theta(n)$.
  ],
  worked: [
    + *Løkken.* `for i = 1 to n` kører præcis $n$ gange — én løkke, fast grænse $n$.
    + *Arbejde i kroppen.* `s = i + s` er én addition og én tildeling, altså konstant tid $O(1)$ uanset $n$. (Lad dig ikke narre af at $i$ vokser; det ændrer ikke arbejdet per gennemløb.)
    + *Gang sammen.*
      #eq[$ n dot O(1) = Theta(n). $]

    Svaret er (c).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2021, Spm. 25",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME2(n): s = 1; for i = 1 to `#swap[$n n$]`: for j = 1 to `#swap[$n$]`: s = s + 1`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (f): $Theta(n^3)$.],
  blueprint: [
    To indlejrede løkker med faste grænser. Gang de to gennemløbstal og kroppens omkostning sammen.

    + Tæl den ydre løkkes gennemløb fra dens grænse.
    + Tæl den indre løkkes gennemløb.
    + Gang sammen og gang med $O(1)$-kroppen.
  ],
  worked: [
    + *Ydre løkke.* `for i = 1 to n*n` kører $n^2$ gange (grænsen er $n dot n = n^2$).
    + *Indre løkke.* `for j = 1 to n` kører $n$ gange, og den nulstilles forfra for hvert ydre gennemløb — længden afhænger ikke af $i$.
    + *Krop.* `s = s + 1` er $O(1)$.
    + *Gang sammen.* Begge grænser er faste, så vi ganger:
      #eq[$ underbrace(n^2, "ydre") dot underbrace(n, "indre") dot underbrace(O(1), "krop") = n^3 = Theta(n^3). $]

    Svaret er (f).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2021, Spm. 26",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITHM3(n): i = 1; j = n; while i <= j: { j = j - `#swap[$1$]`; i = `#swap[$2$]`*i }`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (a): $Theta(log n)$.],
  blueprint: [
    Én tæller fordobler, en anden minusser. Skriv begge som funktion af gennemløbstallet $k$ og find hvornår løkken stopper.

    + Efter $k$ gennemløb: den fordoblende er $2^k$, den minussende er start $- k$.
    + Sæt stopbetingelsen op og løs for $k$.
    + Den eksponentielle vækst dominerer, så $k approx log_2 n$.
  ],
  worked: [
    + *Variable efter $k$ gennemløb.* $i$ starter på $1$ og fordobles: $i = 2^k$. $j$ starter på $n$ og minusses med $1$: $j = n - k$.
    + *Stopbetingelse.* Løkken kører mens $i <= j$, altså mens $2^k <= n - k$.
    + *Hvem styrer stoppet?* $i = 2^k$ vokser eksponentielt, mens $j = n - k$ kun falder langsomt lineært. Allerede længe før $j$ når i nærheden af $i$, har $2^k$ passeret $n$. Så stoppet styres af
      #eq[$ 2^k > n quad <=> quad k > log_2 n. $]
    + *Konkret med $n = 16$:* $(i, j)$ går $(1,16), (2,15), (4,14), (8,13), (16,12)$. Ved $i = 16 > j = 12$ stopper løkken efter $4 approx log_2 16$ gennemløb.

    Altså $Theta(log n)$ gennemløb, hver $O(1)$. Svaret er (a).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2021, Spm. 27",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME4(n): i = n; s = 0; while i >= 1: { for j = i to `#swap[$2i$]`: s = s + 1; i = floor(i/`#swap[$2$]`) }`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (c): $Theta(n)$.],
  blueprint: [
    Ydre løkke halverer, indre arbejde er proportionalt med $i$. En geometrisk sum styres af sit største led.

    + Den ydre løkke halverer $i$, så $i$ tager værdierne $n, n slash 2, n slash 4, dots, 1$.
    + Den indre `for`-løkke koster $approx i$ skridt for det aktuelle $i$.
    + Summér: $n + n slash 2 + n slash 4 + dots = 2n$, domineret af det første led.
  ],
  worked: [
    + *Ydre løkke.* $i$ starter på $n$ og halveres hvert gennemløb (`i = floor(i/2)`), så $i = n, n slash 2, n slash 4, dots, 1$. Det er $Theta(log n)$ gennemløb.
    + *Indre arbejde.* `for j = i to 2i` kører fra $j = i$ til $j = 2i$, altså $2i - i + 1 = i + 1 approx i$ gange. Arbejdet er proportionalt med det aktuelle $i$.
    + *Summér over de halverede $i$-værdier.* Det er en aftagende geometrisk række:
      #eq[$ n + n/2 + n/4 + dots = n sum_(t=0)^infinity (1/2)^t = n dot 1 / (1 - 1 slash 2) = 2n. $]
    + *Konkret med $n = 8$:* $i = 8, 4, 2, 1$ giver indre arbejde $approx 8, 4, 2, 1 = 15 approx 2 dot 8$. Det første led $n$ dominerer hele summen.

    Geometrisk sum domineret af det største led, så $2n = Theta(n)$. Svaret er (c).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2023, Spm. 23",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITHM1(n): i = 1; while i <= n: i = i + i`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (a): $Theta(log n)$.],
  blueprint: [
    Én løkke. Aflæs hvordan tælleren ændrer sig, og hvor mange gennemløb det giver.

    + `i = i + i` fordobler $i$, så det er en multiplikativ tæller.
    + En multiplikativ tæller når $n$ på $Theta(log n)$ skridt.
    + Hvert gennemløb er $O(1)$, så køretiden er antallet af gennemløb.
  ],
  worked: [
    + *Tælleren.* `i = i + i` lægger $i$ til sig selv, hvilket er det samme som at fordoble: $i = 1, 2, 4, 8, dots$. Efter $k$ gennemløb er $i = 2^k$. (Selvom det ser additivt ud, er det multiplikativt.)
    + *Stopbetingelse.* Løkken kører mens $i <= n$, altså:
      #eq[$ 2^k <= n quad <=> quad k <= log_2 n. $]
    + *Gennemløb.* $floor(log_2 n) + 1 = Theta(log n)$, hver med konstant arbejde.
    + *Konkret med $n = 16$:* $i = 1, 2, 4, 8, 16$, og ved $i = 16 <= 16$ kører den, derefter $i = 32 > 16$ og stop. Det er $5 approx log_2 16 + 1$ gennemløb.

    Svaret er (a).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2023, Spm. 26",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME4(n): i = 1; j = n; while i <= j: { i = `#swap[$4$]`*i; j = `#swap[$2$]`*j }`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (a): $Theta(log n)$.],
  blueprint: [
    To tællere vokser begge geometrisk, men med forskellig fart. Skriv begge som funktion af $k$ og løs stopbetingelsen.

    + Efter $k$ gennemløb: en tæller er $4^k dot$ start, den anden $2^k dot$ start.
    + Sæt stopbetingelsen op og forkort de fælles potenser.
    + Løs for $k$. Det er $O(1)$ per gennemløb, så $k$ er køretiden.
  ],
  worked: [
    + *Variable efter $k$ gennemløb.* $i$ starter på $1$ og ganges med $4$: $i = 4^k$. $j$ starter på $n$ og ganges med $2$: $j = n dot 2^k$.
    + *Stopbetingelse.* Løkken kører mens $i <= j$:
      #eq[$ 4^k <= n dot 2^k. $]
    + *Forkort de fælles potenser.* Skriv $4^k = (2^2)^k = 2^(2k)$ og del med $2^k$:
      #eq[$ 2^(2k) <= n dot 2^k quad <=> quad 2^(2k - k) <= n quad <=> quad 2^k <= n. $]
    + *Løs.* $2^k <= n <=> k <= log_2 n$, altså $Theta(log n)$ gennemløb.
    + *Konkret med $n = 16$:* parrene $(i, j)$ er $(1, 16), (4, 32), (16, 64), (64, 128), (256, 256)$. Løkken kører så længe $i <= j$ og stopper, når $i$ overhaler — omkring $k = log_2 16 = 4$ skridt.

    Svaret er (a).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2025, Spm. 26",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME1(n): s = 0; while s < n: s = s + `#swap[$3$]],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (c): $Theta(n)$.],
  blueprint: [
    Én løkke. Løs stopbetingelsen for antallet af gennemløb.

    + Find tællerens opdatering. Et additivt skridt giver lineært, et multiplikativt giver logaritmisk.
    + Løs hvornår tælleren rammer $n$.
    + Smid konstanter væk.
  ],
  worked: [
    + *Tælleren.* $s$ starter på $0$ og plusses med $3$ hvert gennemløb (`s = s + 3`), så efter $k$ gennemløb er $s = 3k$. Det er en additiv tæller.
    + *Stopbetingelse.* Løkken kører mens $s < n$:
      #eq[$ 3k < n quad <=> quad k < n/3. $]
      Altså $ceil(n slash 3)$ gennemløb.
    + *Konkret med $n = 10$:* $s = 0, 3, 6, 9$ kører (alle $< 10$), så stopper ved $s = 12$. Det er $4 = ceil(10 slash 3)$ gennemløb.
    + *Klasse.* Konstanten $1 slash 3$ er ligegyldig: $n slash 3 = Theta(n)$.

    Svaret er (c).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2025, Spm. 27",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME2(n): s = 0; i = 0; while i < n/2: { for j = i to i + `#swap[$n\/2$]`: s = s + 1; i = i + `#swap[$1$]` }`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (e): $Theta(n^2)$.],
  blueprint: [
    To indlejrede løkker, men tjek om den indre længde afhænger af den ydre tæller eller ej.

    + Tæl den ydre løkkes gennemløb.
    + Tæl den indre løkkes gennemløb og bemærk om antallet er konstant eller varierer med $i$.
    + Gang sammen (eller summér hvis det varierer) og smid konstanter væk.
  ],
  worked: [
    + *Ydre løkke.* `while i < n/2` med `i = i + 1`, så $i = 0, 1, dots$ op til $n slash 2$. Det er $n slash 2$ gennemløb.
    + *Indre løkke.* `for j = i to i + n/2` kører fra $j = i$ til $j = i + n slash 2$, altså $n slash 2 + 1$ gange. Selvom start- og slutpunkt flytter sig med $i$, er *længden* altid $n slash 2$ — konstant i $i$. Det er fælden at undgå: den indre længde afhænger ikke af den ydre tæller.
    + *Gang sammen* (fast indre længde):
      #eq[$ (n/2)(n/2 + 1) = n^2/4 + n/2 = Theta(n^2). $]
    + *Konkret med $n = 8$:* ydre kører $4$ gange, hver med indre længde $5$, i alt $20 approx n^2 slash 4 = 16$. Kvadratisk.

    Svaret er (e).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2025, Spm. 28",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME3(n): i = 1; while i <= n: { j = 1; while j <= n: j = `#swap[$2$]`*j; i = i + `#swap[$2$]` }`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (d): $Theta(n log n)$.],
  blueprint: [
    Ydre løkke additiv, indre løkke multiplikativ op til $n$. Indre arbejde er det samme hvert gennemløb, så du ganger.

    + Den ydre løkke plusser, så den kører $Theta(n)$ gange.
    + Den indre løkke fordobler $j$ op til $n$, altså $Theta(log n)$ skridt — og den kører forfra hvert ydre gennemløb.
    + Gang de to tal sammen.
  ],
  worked: [
    + *Ydre løkke.* `i = i + 2` fra $i = 1$, så $i = 1, 3, 5, dots$ indtil $i > n$. Det er $approx n slash 2 = Theta(n)$ gennemløb.
    + *Indre løkke.* `j = 2*j` fra $j = 1$, så $j = 1, 2, 4, dots$ mens $j <= n$. Det er $floor(log_2 n) + 1 = Theta(log n)$ skridt. Afgørende: den indre grænse er $n$ (ikke $i$), så arbejdet er det samme hvert ydre gennemløb, og løkken starter forfra hver gang.
    + *Gang sammen* (fast indre arbejde per gennemløb):
      #eq[$ underbrace((n/2), "ydre") dot underbrace(log_2 n, "indre") = Theta(n log n). $]
    + *Konkret med $n = 8$:* ydre $i = 1, 3, 5, 7$ ($4$ gange), hver med indre $4$ skridt ($j = 1,2,4,8$), i alt $16 approx (n slash 2) log_2 n = 4 dot 3 = 12$.

    Svaret er (d).
  ],
)

#qcard(
  tag: [Køretid: tæl løkkernes gennemløb (multiplikativ)],
  source: "MCQ juni 2025, Spm. 29",
  theory: <th-asym-loops>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME4(n): i = 1; j = n; while i <= j: { i = `#swap[$2$]`*i; j = j/`#swap[$2$]` }`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [Mulighed (a): $Theta(log n)$.],
  blueprint: [
    En tæller fordobler, en anden halverer. De mødes på halvt så mange skridt, men det er stadig logaritmisk.

    + Efter $k$ gennemløb: den fordoblende er $2^k$, den halverende er $n slash 2^k$.
    + Sæt stopbetingelsen op: de mødes når $2^k = n slash 2^k$.
    + Løs for $k$. Det giver $k = (1 slash 2) log_2 n = Theta(log n)$.
  ],
  worked: [
    + *Variable efter $k$ gennemløb.* $i$ starter på $1$ og fordobles: $i = 2^k$. $j$ starter på $n$ og halveres: $j = n slash 2^k$.
    + *Stopbetingelse.* Løkken kører mens $i <= j$:
      #eq[$ 2^k <= n / 2^k. $]
    + *Saml potenserne.* Gang begge sider med $2^k$:
      #eq[$ 2^k dot 2^k <= n quad <=> quad 2^(2k) <= n. $]
    + *Løs.* Tag $log_2$ på begge sider: $2k <= log_2 n$, altså
      #eq[$ k <= 1/2 log_2 n = Theta(log n). $]
    + *Konkret med $n = 16$:* $(i, j) = (1, 16), (2, 8), (4, 4)$. Ved $i = j = 4$ mødes de efter $2 = (1 slash 2) log_2 16$ gennemløb. Halvt så mange skridt som ren fordobling, men stadig logaritmisk.

    Svaret er (a).
  ],
)

#qcard(
  tag: [Køretid: løkke-fælde, tæller nulstilles ikke (nulstilles)],
  source: "MCQ juni 2023, Spm. 24",
  theory: <th-asym-loop-trap>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME2(n): i = 1; j = 1; while i <= n: { i = i + `#swap[$5$]`; while j < i: j = j + 1 }`],
  options: (
    [$Theta(log n)$],
    [$Theta(sqrt(n))$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
  ),
  answer: [(c) $Theta(n)$. Det er fælde-tilfældet.],
  blueprint: [
    Det ligner to indlejrede løkker, men tjek hvor den indre tæller sættes, før du ganger.

    + Find ud af hvor den indre tæller initialiseres. Sker det inde i den ydre løkke, nulstilles den hvert gennemløb, og så ganger du som normalt.
    + Sættes den derimod én gang *uden for* begge løkker og kun stiger, så summér i stedet for at gange. Tælleren klatrer fra start til slut over hele kørslen, så det indre arbejde er $#swap[$Theta(n)$]$ i alt, ikke per gennemløb.
    + Læg ydre og indre arbejde sammen.
  ],
  worked: [
    + *Hvor sættes $j$?* `j = 1` står *uden for* begge løkker. Den indre `while j < i` skubber kun $j$ opad og nulstilles aldrig mellem ydre gennemløb. Det er fælden.
    + *Ydre løkke.* `i = i + 5` fra $i = 1$, så $i = 1, 6, 11, dots$ indtil $i > n$. Det er cirka $n slash 5 = Theta(n)$ gennemløb.
    + *Indre arbejde — summeret over hele kørslen, ikke per gennemløb.* Da $j$ aldrig nulstilles, fortsætter den bare hvor den slap. Hen over alle ydre gennemløb klatrer $j$ monotont fra $1$ op til den sidste $i$-værdi, cirka $n$. Det er $Theta(n)$ indre skridt i alt for hele kørslen.
    + *Lille trace ($n = 11$).* Følg $j$'s rejse på tværs af de ydre gennemløb:
      ```
      i=1:  j starter på 1, while 1<1 falsk -> 0 indre skridt, j=1
      i=6:  while j<6: j klatrer 1->6  -> 5 indre skridt, j=6
      i=11: while j<11: j klatrer 6->11 -> 5 indre skridt, j=11
      i=16: 16>11, ydre løkke stopper
      ```
      Indre skridt i alt: $0 + 5 + 5 = 10 approx n$. Ikke $n$ per gennemløb.
    + *Læg sammen.* Ydre $Theta(n)$ + indre $Theta(n)$ i alt $= Theta(n)$.

    Svaret er (c). Læser du det indre arbejde som $Theta(n)$ *per* gennemløb og ganger til $Theta(n^2)$, er du gået i fælden.
  ],
)

#qcard(
  tag: [Køretid: løkke-fælde, tæller nulstilles ikke (nulstilles)],
  source: "MCQ juni 2015, Spm. 22",
  theory: <th-asym-loop-trap>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME2(n): i = 1; j = 1; while i <= n: { while j <= i: j = j + `#swap[$1$]`; i = `#swap[$2$]`*i }`],
  options: (
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (b): $Theta(n)$. Det er fælde-tilfældet.],
  blueprint: [
    Den ydre løkke fordobler, så det ligner $Theta(log n)$ gange noget. Men tjek hvor den indre tæller sættes, før du ganger.

    + Find ud af hvor den indre tæller sættes. Står den uden for begge løkker og nulstilles aldrig, klatrer den kun opad over hele kørslen.
    + Så summér i stedet for at gange: det samlede indre arbejde er bundet af den højeste værdi $j$ når, ikke af arbejdet per ydre gennemløb.
    + Læg ydre og indre arbejde sammen.
  ],
  worked: [
    + *Hvor sættes $j$?* `j = 1` står *uden for* begge løkker. Den indre `while j <= i` skubber kun $j$ opad og nulstilles aldrig. Det er fælden.
    + *Ydre løkke.* `i = 2*i` fra $i = 1$, så $i = 1, 2, 4, dots$ indtil $i > n$, altså $Theta(log n)$ gennemløb.
    + *Indre arbejde — summeret over hele kørslen.* Da $j$ aldrig nulstilles, fortsætter den fra forrige værdi mod det aktuelle $i$. Samlet klatrer $j$ fra $1$ op til den sidste $i$-værdi, som er den mindste toer-potens $> n$, altså $approx 2n = Theta(n)$ skridt i alt.
    + *Lille trace ($n = 8$).* Følg $j$ på tværs af de ydre gennemløb:
      ```
      i=1: while j<=1: j 1->2   -> 1 indre skridt, j=2
      i=2: while j<=2: j 2->3   -> 1 indre skridt, j=3
      i=4: while j<=4: j 3->5   -> 2 indre skridt, j=5
      i=8: while j<=8: j 5->9   -> 4 indre skridt, j=9
      i=16: 16>8, stop
      ```
      Indre skridt i alt: $1 + 1 + 2 + 4 = 8 approx n$. Det er én lang optælling spredt ud over gennemløbene.
    + *Læg sammen.* Ydre $Theta(log n)$ + indre $Theta(n)$ i alt $= Theta(n)$.

    Svaret er (b). Fælden er at tro $j$ nulstilles hvert ydre gennemløb og dermed give hvert gennemløb sit fulde indre arbejde. Så ville man få $sum log i = Theta(n log n)$ eller værre — men $j$ nulstilles aldrig, så hele den indre optælling koster kun $Theta(n)$ tilsammen.
  ],
)

#qcard(
  tag: [Køretid: løkke-fælde, tæller nulstilles ikke (nulstilles)],
  source: "MCQ juni 2017, Spm. 21",
  theory: <th-asym-loop-trap>,
  prompt: [Hvad er den asymptotiske køretid i $Theta$-notation? \
    `ALGORITME2(n): i = n; j = n; while i > 1: { while j > i: j = j - `#swap[$1$]`; i = i - `#swap[$1$]` }`],
  options: (
    [$Theta(log n)$],
    [$Theta(n)$],
    [$Theta(n log n)$],
    [$Theta(n^2)$],
    [$Theta(n^3)$],
    [$Theta(2^n)$],
  ),
  answer: [Mulighed (b): $Theta(n)$. Det er fælde-tilfældet.],
  blueprint: [
    To løkker der begge løber lineært ligner $Theta(n^2)$. Men tjek hvor den indre tæller sættes, før du ganger.

    + Find ud af hvor den indre tæller sættes. Står den uden for begge løkker og nulstilles aldrig, bevæger den sig kun i én retning over hele kørslen.
    + Så summér i stedet for at gange: det samlede indre arbejde er bundet af, hvor langt $j$ overhovedet kan rejse.
    + Læg ydre og indre arbejde sammen.
  ],
  worked: [
    + *Hvor sættes $j$?* `j = n` står *uden for* begge løkker. Den indre `while j > i` skubber kun $j$ nedad og nulstilles aldrig. Det er fælden.
    + *Ydre løkke.* `i = i - 1` fra $i = n$ ned til $2$ (`while i > 1`), altså $Theta(n)$ gennemløb.
    + *Indre arbejde — summeret over hele kørslen.* Start er $i = j = n$, så `j > i` er falsk i første gennemløb (nul indre skridt). Når $i$ falder, kan $j$ følge efter nedad, men $j$ kan i alt kun rejse fra $n$ ned til $2$ over hele kørslen. Det er $Theta(n)$ indre skridt i alt.
    + *Lille trace ($n = 5$).* Følg $j$ på tværs af de ydre gennemløb:
      ```
      i=5: while j>5: 5>5 falsk -> 0 skridt, j=5
      i=4: while j>4: j 5->4   -> 1 skridt, j=4
      i=3: while j>3: j 4->3   -> 1 skridt, j=3
      i=2: while j>2: j 3->2   -> 1 skridt, j=2
      i=1: ydre stop
      ```
      Indre skridt i alt: $0 + 1 + 1 + 1 = 3 approx n$. $j$ tæller aldrig op igen.
    + *Læg sammen.* Ydre $Theta(n)$ + indre $Theta(n)$ i alt $= Theta(n)$.

    Svaret er (b). De to lineære løkker ligner $Theta(n^2)$, men fordi $j$ aldrig nulstilles, deler alle de ydre gennemløb én og samme nedtælling. Læser du det som $Theta(n^2)$, er du gået i fælden.
  ],
)
