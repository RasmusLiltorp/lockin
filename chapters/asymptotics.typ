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
    Jeg tager forholdet $f slash g$ for hver linje og ser hvor det ender.

    - *(a)* $n slash sqrt(n) = sqrt(n) -> infinity$. Falsk.
    - *(b)* $2n slash (n log n) = 2 slash log n -> 0$. Sand.
    - *(c)* $n log n slash n^(1.5) = log n slash sqrt(n) -> 0$, fordi roden slår $log$. Sand.
    - *(d)* $(log n)^2 slash sqrt(n) -> 0$, samme grund. Sand.
    - *(e)* $3^n$ delt med en $log$-potens $-> infinity$. Falsk.
    - *(f)* $log n slash n -> 0$. Sand.
    - *(g)* $n^(1 slash 7)$ delt med $17 log n -> infinity$, for en rod slår $log$. Falsk.

    Et forhold der går mod $0$ tæller stadig som $O$. Tilbage står (b), (c), (d) og (f).
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
    Jeg tager forholdet $f slash g$ for hver linje.

    - *(a)* $2^n slash n^3 -> infinity$, for eksponentiel slår potens. Falsk.
    - *(b)* $n^2 slash 3^n -> 0$, potens under eksponentiel. Sand.
    - *(c)* $(n(log n)^2) slash (n^3 log n) = log n slash n^2 -> 0$. Sand.
    - *(d)* $(n^2 log n) slash (n(log n)^3) = n slash (log n)^2 -> infinity$. Falsk.
    - *(e)* $n^3 slash n^2 = n -> infinity$, større eksponent. Falsk.
    - *(f)* $3^n slash 2^n = (3 slash 2)^n -> infinity$, større grundtal. Falsk.
    - *(g)* $n^(1 slash 3) slash n^(1 slash 2) = n^(-1 slash 6) -> 0$, mindre eksponent. Sand.

    Sande: (b), (c), (g).
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
    + *(a, b)* $n^2 slash n^3 = 1 slash n -> 0$, så både $O$ og $o$ holder. Sande.
    + *(c)* $3n^2 + 2n^3$ styres af $n^3$; $n^2 slash (2n^3) -> 0$, ikke afgrænset nedad, så $Theta$ fejler. Falsk.
    + *(d)* $2^n slash n^4 -> infinity$, eksponentiel slår potens. Falsk.
    + *(e)* $n^2 slash 4^n -> 0$, så $O$ holder. Sand.
    + *(f)* forholdet $= (log n)^8 slash n -> 0$. Sand.
    + *(g)* $4^n slash 2^n = 2^n -> infinity$, strengt hurtigere, så $omega$. Sand.
    + *(h)* $(1 slash 2)^n slash (1 slash 4)^n = 2^n -> infinity$, ikke afgrænset. Falsk.
    + *(i)* $1 slash log n -> 0$, afgrænset, så $O(1)$. Sand.
    + *(j)* $abs(sin n) <= 1 <= log n$ for store $n$. Sand.

    Sande: (a), (b), (e), (f), (g), (i), (j).
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
    - *(a)* $n^3 slash n^2 = n -> infinity$. Falsk.
    - *(b)* $log n slash sqrt(n) -> 0$, rod slår $log$. Sand.
    - *(c)* $1 slash n^(1 slash 3) -> 0$, konstant under voksende. Sand.
    - *(d)* $n^(1.5) slash (n log n) = sqrt(n) slash log n -> infinity$. Falsk.
    - *(e)* $1.5^n slash n^(15) -> infinity$, eksponentiel slår potens. Falsk.
    - *(f)* højresidens hurtigste led er $n(log n)^3$; $(n log n) slash (n(log n)^3) = 1 slash (log n)^2 -> 0$. Sand.

    Sande: (b), (c), (f).
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
    - *(a)* $n slash log n -> infinity$. Falsk.
    - *(b)* $(log n)^3 slash n^2 -> 0$, polylog under potens. Sand.
    - *(c)* svarer til $log n = O(sqrt(n))$; $log n slash sqrt(n) -> 0$. Sand.
    - *(d)* eksponentiel slår enhver potens. Falsk.
    - *(e)* faktoren $3$ forsvinder. Sand.
    - *(f)* eksponentiel slår polylog. Falsk.
    - *(g)* $log(n!) = Theta(n log n)$, som ligger under $n^2$. Sand.

    Sande: (b), (c), (e), (g).
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
    - *(a)* $n^4 slash n^3 = n -> infinity$. Falsk.
    - *(b)* begge lineære, forholdet $= 12$. Sand.
    - *(c)* $sqrt(n) slash log n -> infinity$. Falsk.
    - *(d)* hurtigste led $n^3$ mod $O(n)$, forholdet $-> infinity$. Falsk.
    - *(e)* $g slash f = n slash (log n)^3 -> infinity$, så $f slash g -> 0$. Sand.
    - *(f)* eksponentiel slår enhver potens. Sand.
    - *(g)* skiller sig kun ad med konstanten $log 3 slash log 4$. Sand.

    Sande: (b), (e), (f), (g).
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
    Jeg regner $L$ for hver linje og holder det op mod symbolet der står.

    - *(a)* $n slash (log n)^2 -> infinity$, og linjen siger $Omega$. Passer. Sand.
    - *(b)* $4^n slash 2^n = 2^n -> infinity$, strengt hurtigere, så $omega$. Sand.
    - *(c)* $3n slash (n slash 3) = 9$, en konstant, så $Theta$. Sand.
    - *(d)* $(log n)^3 slash (3 log n) = (log n)^2 slash 3 -> infinity$. Linjen siger $Theta$, men $L$ er ikke konstant. Falsk.
    - *(e)* $(n^2 slash log n) slash (n^2 log n) = 1 slash (log n)^2 -> 0$, så $o$. Sand.
    - *(f)* summen styres af $n^2$, og $n^2 slash n^(1.75) -> infinity$. $Theta$ fejler. Falsk.
    - *(g)* $2^n slash n^n = (2 slash n)^n -> 0$, så $o$. Sand.

    Sande: (a), (b), (c), (e) og (g).
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
    - *(a)* hurtigste led er $2n^2$, så summen er $Theta(n^2)$. Sand.
    - *(b)* $n$ vokser præcis som $n$, så $Omega(n)$. Sand.
    - *(c)* $2^n$ er eksponentiel og slår $n^3$, så det er $omega(n^3)$, ikke $o$. Falsk.
    - *(d)* $(log n)^3$ er polylog; $n slash log n$ vokser polynomielt, så venstre er $o$ af den, ikke $omega$. Falsk.
    - *(e)* $1 slash 3 < 1 slash 2$, og $n^(1 slash 3) slash n^(1 slash 2) = n^(-1 slash 6) -> 0$, så $o$. Sand.
    - *(f)* venstre styres af $n^5$, højre af $n^4$. Forskellig orden, ikke $Theta$. Falsk.

    Sande: (a), (b), (e).
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
    - *(a)* $log n slash n^2 -> 0$, så $log n$ er $o(n^2)$, ikke $omega$. Falsk.
    - *(b)* styres af $n^3$, forholdet $-> 1$. Sand.
    - *(c)* $6 slash 7$ er en konstant $!= 0$, så $o$ fejler (det er $Theta(7)$). Falsk.
    - *(d)* $(3 slash 2)^n -> infinity$, så $Omega$. Sand.
    - *(e)* $(n slash (log n)^2) slash (log n)^3 = n slash (log n)^5 -> infinity$, ikke $o$. Falsk.
    - *(f)* $n^n slash 2^n -> infinity$, så $Omega$. Sand.
    - *(g)* $n^(1.1) slash (n log n) = n^(0.1) slash log n -> infinity$, så $omega$. Sand.

    Sande: (b), (d), (f), (g).
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
    - *(a)* $2^n slash n^4 -> infinity$, så $Omega(n^4)$. Sand.
    - *(b)* $n^3 slash (n^6 slash 2) = 2 slash n^3 -> 0$, så $o$. Sand.
    - *(c)* forholdet $= 1$, ikke $infinity$; det er $Theta(n^2)$, ikke $omega$. Falsk.
    - *(d)* forholdet $= n slash log n -> infinity$, ikke konstant. Falsk.
    - *(e)* $log n$ vokser uden grænse, så afgrænset nedad: $Omega(1)$. Sand.
    - *(f)* $2 slash 1 = 2 !-> 0$; det er $Theta(1)$. Falsk.
    - *(g)* $(n - 100) slash (n + 100) -> 1$. Sand.

    Sande: (a), (b), (e), (g).
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
    + *Ydre løkke.* $i$ ganges med $2$ hver gang: $i = 1, 2, 4, dots$ indtil $i > n$. Det er $Theta(log n)$ gennemløb.
    + *Indre løkke.* $j$ sættes til $n$ og tælles ned til $2$. Det er $n - 1$ skridt, og det sker forfra hvert ydre gennemløb uanset hvad $i$ er. Altså $Theta(n)$ per gang.
    + *Gang sammen.* $Theta(log n) dot Theta(n) = Theta(n log n)$.

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
    + *Indre løkke.* $j$ går fra $n$ ned til $i$, altså $n - i$ skridt for hvert fast $i$.
    + *Ydre løkke.* $i$ løber fra $n$ ned til $2$.
    + *Summér.* $sum_(i=2)^n (n - i) = (n-2)(n-1) slash 2 approx n^2 slash 2$.

    En trekant af arbejde er stadig $Theta(n^2)$. Svaret er (d).
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
    + *Ydre løkke.* $i = 1, 2, 4, dots, n$, altså $Theta(log n)$ gennemløb.
    + *Indre arbejde.* På hvert gennemløb koster den indre løkke $i$ skridt.
    + *Summér.* $1 + 2 + 4 + dots + n = 2n - 1 = Theta(n)$.

    Det sidste led $n$ dominerer hele summen. Svaret er (b).
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
    + *Ydre løkke.* $i = 1, dots, n$, altså $Theta(n)$ gennemløb.
    + *Indre arbejde.* $j$ fordobles op til $i$, altså $floor(log_2 i) + 1$ skridt.
    + *Summér.* $sum_(i=1)^n (log_2 i + 1) = log_2(n!) + n = Theta(n log n)$.

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
    + *Ydre arbejde.* $i$- og $j$-løkkerne kører $n^2$ gange, og `if i == j` testes $n^2$ gange.
    + *Inderste løkke.* `i == j` holder kun på diagonalen, altså $n$ gange. Hver gang koster $k$-løkken $n$, så $n dot n = n^2$ skridt i alt.
    + *Læg sammen.* $n^2 + n^2 = Theta(n^2)$.

    Vagten skærer den inderste løkke ned til $n$ fyringer, så det bliver kvadratisk, ikke kubisk. Svaret er (d).
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
    + *Ydre løkke.* $i$ halveres hver gang, altså $Theta(log n)$ gennemløb.
    + *Indre arbejde.* $j$ går fra $i$ op til $n$, altså $n - i$ skridt.
    + *Summér.* $sum (n - i)$ for $i = n, n slash 2, dots approx n log n - 2n = Theta(n log n)$.

    Svaret er (c).
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
    + *Startafstand.* $i = 1$, $j = n$, så afstanden $j - i = n - 1$.
    + *Krympning.* Hvert gennemløb plusser $i$ og minusser $j$, så afstanden falder med $2$.
    + *Antal gennemløb.* $approx (n-1) slash 2 = Theta(n)$, hver med konstant arbejde.

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
    + *Ydre løkke.* $i$ går fra $n$ ned til $2$, altså $Theta(n)$ gennemløb.
    + *Indre arbejde.* $j$ fordobles op til $i$, altså $ceil(log_2 i) = Theta(log i)$ skridt.
    + *Summér.* $sum_(i=2)^n log_2 i = log_2(n!) = Theta(n log n)$.

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
    + *Ydre løkke.* $i = 1, 2, 4, dots$, altså $ceil(log_2 n)$ gennemløb.
    + *Indre arbejde.* $j = i$ halveres ned til $1$, altså $log_2 i$ skridt. Ved gennemløb $k$ er $i = 2^k$, så det er $k$ skridt.
    + *Summér.* $sum_(k=0)^(log_2 n) k = (log_2 n)(log_2 n + 1) slash 2 = Theta((log n)^2)$.

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
    + *Løkken.* `for i = 1 to n` kører $n$ gange.
    + *Arbejde.* Hver gang en konstant-tids tildeling, $O(1)$.
    + *Gang sammen.* $n dot O(1) = Theta(n)$.

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
    + *Ydre løkke.* $i = 1$ til $n^2$, altså $n^2$ gennemløb.
    + *Indre løkke.* $j = 1$ til $n$, altså $n$ gennemløb.
    + *Gang sammen.* $n^2 dot n = n^3 = Theta(n^3)$.

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
    + *Variable efter $k$ gennemløb.* $i = 2^k$ og $j = n - k$.
    + *Stop.* Løkken kører mens $2^k <= n - k$. Da $i$ vokser eksponentielt og $j$ kun falder lineært, styres stoppet af $2^k > n$.
    + *Løs.* $k > log_2 n$, altså $Theta(log n)$ gennemløb.

    Svaret er (a).
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
    + *Ydre løkke.* $i = n, n slash 2, dots, 1$.
    + *Indre arbejde.* `for j = i to 2i` kører $i + 1$ gange, altså $approx i$.
    + *Summér.* $n + n slash 2 + n slash 4 + dots = n dot 1 slash (1 - 1 slash 2) = 2n = Theta(n)$.

    Svaret er (c).
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
    + *Tælleren.* $i = i + i$ fordobler $i$: $1, 2, 4, 8, dots, 2^k$.
    + *Stop.* Løkken stopper når $2^k > n$, altså $k > log_2 n$.
    + *Gennemløb.* $approx floor(log_2 n) + 1 = Theta(log n)$.

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
    + *Variable efter $k$ gennemløb.* $i = 4^k$ og $j = n dot 2^k$.
    + *Stop.* Løkken kører mens $4^k <= n dot 2^k$, altså $2^k <= n$.
    + *Løs.* $k <= log_2 n$, altså $Theta(log n)$ gennemløb.

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
    + *Tælleren.* $s$ starter på $0$ og plusses med $3$ hver gang.
    + *Stop.* Løkken stopper når $s >= n$, altså efter $ceil(n slash 3)$ gennemløb.
    + *Klasse.* $n slash 3 + O(1) = Theta(n)$.

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
    + *Ydre løkke.* Kører $n slash 2$ gange.
    + *Indre løkke.* `for j = i to i + n/2` kører $n slash 2 + 1$ gange — længden er konstant i $i$.
    + *Gang sammen.* $(n slash 2)(n slash 2 + 1) = n^2 slash 4 + n slash 2 = Theta(n^2)$.

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
    + *Ydre løkke.* $i = 1, 3, 5, dots$ med skridt $2$ indtil $i > n$, altså $approx n slash 2 = Theta(n)$ gennemløb.
    + *Indre løkke.* $j = 1, 2, 4, dots$ op til $n$, altså $floor(log_2 n) + 1 = Theta(log n)$ skridt, forfra hvert gennemløb.
    + *Gang sammen.* $(n slash 2)(log_2 n) = Theta(n log n)$.

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
    + *Variable efter $k$ gennemløb.* $i = 2^k$ og $j = n slash 2^k$.
    + *Stop.* Løkken kører mens $2^k <= n slash 2^k$, altså $2^(2k) <= n$.
    + *Løs.* $2k <= log_2 n$, så $k <= (1 slash 2) log_2 n = Theta(log n)$.

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
    + *Hvor sættes $j$?* $j = 1$ står uden for begge løkker og nulstilles aldrig. Det er fælden.
    + *Ydre løkke.* $i$ plusses med $5$ hver gang, så den kører cirka $n slash 5$ gange, altså $Theta(n)$.
    + *Indre arbejde i alt.* Den indre løkke skubber kun $j$ opad. Hen over hele kørslen klatrer $j$ fra $1$ til cirka $n$, så det er $Theta(n)$ skridt samlet, ikke per gennemløb.
    + *Læg sammen.* $Theta(n) + Theta(n) = Theta(n)$.

    Svaret er (c). Læser du det som $Theta(n^2)$, er du gået i fælden.
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
    + *Hvor sættes $j$?* $j = 1$ står uden for begge løkker og nulstilles aldrig. Det er fælden.
    + *Ydre løkke.* $i$ ganges med $2$: $1, 2, 4, dots$ indtil $i > n$, altså $Theta(log n)$ gennemløb.
    + *Indre arbejde i alt.* Den indre løkke skubber kun $j$ opad mod det aktuelle $i$. Hen over hele kørslen klatrer $j$ fra $1$ op til den sidste $i$-værdi, som er den mindste toer-potens over $n$, altså $Theta(n)$. Det er $Theta(n)$ skridt samlet, ikke per gennemløb.
    + *Læg sammen.* $Theta(log n) + Theta(n) = Theta(n)$.

    Svaret er (b). Læser du det indre arbejde som $Theta(n)$ per gennemløb, går du i fælden.
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
    + *Hvor sættes $j$?* $j = n$ står uden for begge løkker og nulstilles aldrig. Det er fælden.
    + *Ydre løkke.* $i$ minusses med $1$ fra $n$ ned til $2$, altså $Theta(n)$ gennemløb.
    + *Indre arbejde i alt.* Start er $i = j = n$, så $j > i$ er falsk i begyndelsen. Efterhånden som $i$ falder, kan $j$ tælle ned, men $j$ skubbes kun nedad og kan i alt rejse fra $n$ til $2$. Det er $Theta(n)$ skridt samlet, ikke per gennemløb.
    + *Læg sammen.* $Theta(n) + Theta(n) = Theta(n)$.

    Svaret er (b). Læser du det som $Theta(n^2)$, er du gået i fælden.
  ],
)
