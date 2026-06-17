#import "../lib.typ": *

== Asymptotisk analyse

Asymptotisk analyse sammenligner funktioner efter hvor hurtigt de vokser for stort $n$. Konstante faktorer og små $n$ er ligegyldige; kun forholdet mellem to funktioner, når $n -> infinity$, tæller.

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

=== Sådan løser du den

En påstand som "$f(n)$ er $O(g(n))$" spørger kun om én ting: *vokser $f$ højst lige så hurtigt som $g$?* Det eneste værktøj du behøver er vækststigen — langsomst til venstre, hurtigst til højre:

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

#trap(title: [Konstante faktorer])[Konstante faktorer og summer af samme grad ændrer ikke klassen: $n + n + n = Theta(n slash 3) = Theta(n)$. Men en $log$-faktor tæller. $(log n)^3$ er ikke $Theta(3 log n)$, fordi $(log n)^3 slash (3 log n) = (log n)^2 slash 3 -> infinity$.]

=== O(n) eller O(n²)?

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

#trap(title: [Indre tæller])[Sættes en indre tæller én gang uden for begge løkker og kun stiger, er det samlede indre arbejde $Theta(n)$ for hele kørslen, ikke per gennemløb. Det laver et tilsyneladende $Theta(n^2)$ om til $Theta(n)$.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [O-notation: er X = O(Y)?],
  source: "MCQ juni 2023, Spm. 5",
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
  tag: [Asymptotik: O / Ω / Θ / o / ω sand?],
  source: "MCQ juni 2023, Spm. 6",
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
  tag: [Køretid: tæl løkkernes gennemløb],
  source: "MCQ juni 2023, Spm. 25",
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
  tag: [Køretid: løkke-fælde (tæller nulstilles ikke)],
  source: "MCQ juni 2023, Spm. 24",
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
