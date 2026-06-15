#import "../lib.typ": *

== Asymptotisk analyse

Asymptotisk analyse sammenligner funktioner efter hvor hurtigt de vokser for stort $n$. Konstante faktorer og små $n$ er ligegyldige; kun forholdet mellem to funktioner, når $n -> infinity$, tæller.

Eksamen spørger på to måder: om en påstand som "$f(n)$ er $O(g(n))$" er sand, eller om $Theta$-køretiden for en løkke. Begge løses med samme greb: kig på forholdet $f(n) slash g(n)$.

=== Sådan løser du den

En påstand som "$f(n)$ er $O(g(n))$" spørger kun om én ting: *vokser $f$ højst lige så hurtigt som $g$?* Det eneste værktøj du behøver er vækststigen — langsomst til venstre, hurtigst til højre:

#eq[$ 1 < log n < sqrt(n) < n < n log n < n^2 < n^3 < 2^n < n^n. $]

To huskeregler dækker næsten alt: en *eksponentiel* ($2^n$, $3^n$) slår altid en *potens* ($n^2$, $n^3$, …), og en *$log$-faktor* rykker dig kun en lillebitte smule på stigen.

#note[Det yderste $1$ på stigen er *alle konstanter*: $2$, $3$, $100$ vokser ikke med $n$, så de sidder alle på samme plads. Derfor er enhver konstant $O$ (endda $Theta$) af enhver anden — fx er $3 = O(2)$ sand, og $O(2)$ betyder bare $O(1)$.]

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

#note[To kendsgerninger afgør næsten alt. Ethvert polynomium slår enhver eksponentialfunktion: $n^a slash b^n -> 0$ for $a > 0$ og $b > 1$. Og enhver rod slår enhver polylog: $(log n)^a slash n^d -> 0$ for $a, d > 0$.]

#trap[Konstante faktorer og summer af samme grad ændrer ikke klassen: $n + n + n = Theta(n slash 3) = Theta(n)$. Men en $log$-faktor tæller. $(log n)^3$ er ikke $Theta(3 log n)$, fordi $(log n)^3 slash (3 log n) = (log n)^2 slash 3 -> infinity$.]

For løkker tæller du to ting hver for sig: hvor mange gange den ydre løkke kører, og arbejdet indeni per gennemløb.

#recipe(
  title: "Find Θ-køretiden for en løkke",
  [Tæl ydre gennemløb. Additivt skridt ($i = i + #swap[$c$]$) giver $Theta(n)$; multiplikativt ($i = #swap[$2$] dot i$) giver $Theta(log n)$.],
  [Find det indre arbejde per ydre gennemløb. Tjek om en tæller nulstilles hvert gennemløb eller bliver ved med at stige.],
  [Gang ydre antal med indre omkostning, smid konstanter væk, skriv $Theta$.],
)

#trap[Sættes en indre tæller én gang uden for begge løkker og kun stiger, er det samlede indre arbejde $Theta(n)$ for hele kørslen, ikke per gennemløb. Det laver et tilsyneladende $Theta(n^2)$ om til $Theta(n)$.]

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
  worked: [Tag hvert forhold mod uendelig. (a) $n slash sqrt(n) = sqrt(n) -> infinity$, falsk. (b) $2n slash (n log n) = 2 slash log n -> 0$, sand. (c) $n log n slash n^(1.5) = log n slash sqrt(n) -> 0$, sand. (d) $(log n)^2 slash sqrt(n) -> 0$ (rod slår polylog), sand. (e) $3^n$ mod en polylog $-> infinity$, falsk. (f) $log n slash n -> 0$, sand. (g) $n^(1 slash 7)$ mod $17 log n -> infinity$, falsk. Et forhold mod $0$ tæller stadig som $O$.],
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
  worked: [(a) $n slash (log n)^2 -> infinity$, så $Omega$ holder. (b) $4^n slash 2^n = 2^n -> infinity$, strengt hurtigere, $omega$ holder. (c) $3n slash (n slash 3) = 9$, positiv konstant, $Theta$ holder. (d) $(log n)^3 slash (3 log n) = (log n)^2 slash 3 -> infinity$, ikke konstant, $Theta$ fejler. (e) $1 slash (log n)^2 -> 0$, $o$ holder. (f) summen opfører sig som $n^2$, og $n^2 slash n^(1.75) -> infinity$, $Theta$ fejler. (g) $(2 slash n)^n -> 0$, $o$ holder.],
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
  worked: [Ydre løkke: $i = 1, 2, 4, dots$ indtil $i > n$, altså $Theta(log n)$ gennemløb. Indre løkke: $j$ tæller fra $n$ ned til $2$, det er $n - 1$ skridt hvert gennemløb uafhængigt af $i$, altså $Theta(n)$. I alt $Theta(log n) dot Theta(n) = Theta(n log n)$.],
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
  worked: [$j$ sættes til $1$ én gang uden for begge løkker og nulstilles aldrig. Den ydre løkke kører cirka $n slash #swap[$5$]$ gange. Den indre løkke skubber kun $j$ opad, så hen over hele kørslen klatrer $j$ fra $1$ op til cirka $n$ — det er $Theta(n)$ indre skridt i alt, ikke per gennemløb. I alt $Theta(n slash 5) + Theta(n) = Theta(n)$. At læse det som $Theta(n^2)$ er fejlen spørgsmålet jagter.],
)
