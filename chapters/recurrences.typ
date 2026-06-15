#import "../lib.typ": *

== Rekursionsligninger og Master Theorem

En Divide-and-Conquer-algoritme deler problemet op, løser delene rekursivt og samler resultatet. Køretiden $T(n)$ står derfor udtrykt ved sig selv på mindre input. Gør algoritmen $a$ kald, hvert på et stykke af størrelse $n/b$, og bruger $f(n)$ på at dele op og samle, så er

#eq[$ T(n) = a thin T(n/b) + f(n). $]

Master Theorem giver en lukket $Theta$-grænse for $T(n)$.

=== Sådan løser du den

Sammenlign arbejdet i rekursionen, målt af $n^alpha$ med

#eq[$ alpha = log_b a, $]

mod arbejdet uden for, $f(n)$. Den, der vokser hurtigst, bestemmer svaret.

#note[Skelseksponenten $alpha = log_b a$ er det samme som $p$ i eksamenens svar: skriver opgaven $Theta(n^p)$, så er $p = alpha = log_b a$. Du regner altså $p$ ved at tage $log$ af $a$ med grundtal $b$ — fx $T(n) = 5 T(n/2) + n^2$ giver $p = log_2 5$. Pas på rækkefølgen: det er $log_b a$, ikke $log_a b$.]

#note[*$p$ optræder kun når svaret er $n^alpha$ (tilfælde 1).* Vinder $f(n)$ (tilfælde 3), er svaret $f(n)$ selv — fx $Theta(n^(1/2))$ — uden noget $p$. Tommelfinger: ser du "$p = log_b a$", er det tilfælde 1; ser du en ren funktion som $n^(1/2)$ eller $n^2$, er det tilfælde 3.]

#recipe(
  title: "Master Theorem (Cormen et al., 4. udg.)",
  [Aflæs #swap[$a$], #swap[$b$] og #swap[$f(n)$] fra ligningen. Kun de tre skifter fra år til år.],
  [Regn skelseksponenten $alpha = log_b a$ ud, og skriv skelfunktionen $n^alpha$.],
  [Hold $f(n)$ op mod $n^alpha$ og find tilfældet.],
  [Skriv den $Theta$-grænse, tilfældet giver.],
)

De tre udfald handler kun om: er $n^alpha$ eller $f(n)$ størst?

#block(above: 14pt, below: 14pt)[
  #align(center)[
    #table(
      columns: 4,
      align: (left, left, center, left),
      stroke: none,
      inset: (x: 12pt, y: 7pt),
      table.header(
        [*Hvem er størst?*], [*Eksempel ($n^alpha = n$)*], [*Tilfælde*], [*Svar* $T(n)$],
      ),
      table.hline(stroke: 0.4pt + hair),
      [$n^alpha$ størst], [$f(n) = sqrt(n)$], [1], [$Theta(n^alpha)$],
      [lige store], [$f(n) = n$], [2], [$Theta(n^alpha log n)$],
      [$f(n)$ størst — _en hel potens_], [$f(n) = n^2$], [3], [$Theta(f(n))$],
      [$f(n)$ større, men _kun et $log$_], [$f(n) = n log n$], [—], [kan ikke løses],
    )
  ]
]

For at se *hvem der er størst*, placér både $n^alpha$ og $f(n)$ på vækststigen — længst til højre vinder:

#eq[$ 1 quad < quad log n quad < quad sqrt(n) quad < quad n quad < quad n log n quad < quad n^2 quad < quad n^2 log n quad < quad n^3 quad < quad 2^n $]

#note[Et $n^c$ med større potens slår altid et med mindre ($n^2 > n^(1.5) > n$), uanset $log$-faktorer: ethvert $n^c$ slår $log n$, og enhver eksponentiel ($2^n$) slår alle $n^c$. Til Master Theorem: er $n^alpha$ længere til højre end $f(n)$, er det tilfælde 1; står de på samme plads, tilfælde 2; er $f(n)$ en *hel potens* længere til højre, tilfælde 3. Bemærk $n^alpha$ kan have skæv potens, fx $n^(log_2 5) approx n^(2.32)$, som ligger mellem $n^2$ og $n^3$.]

#trap[Tilfælde 3 kræver, at $f(n)$ er en *hel potens* større end $n^alpha$ (et helt trin på stigen, fx $n^2$ mod $n$). Er $f(n)$ kun en $log$-faktor større — som $f(n) = n log n$ når $n^alpha = n$ — så er den for stor til tilfælde 2 og for lille til tilfælde 3. Den falder i hullet, og Master Theorem kan *ikke* løse den.]

*Tilfælde 1 — $n^alpha$ er størst.* Rekursionen vinder, og svaret er $n^alpha$.

#eq[$ "Tilfælde 1:" quad f(n) = O(n^(alpha - epsilon)) quad ==> quad T(n) = Theta(n^alpha). $]

*Tilfælde 2 — de er lige store.* Uafgjort, så du lægger et $log n$ oveni.

#eq[$ "Tilfælde 2:" quad f(n) = Theta(n^alpha) quad ==> quad T(n) = Theta(n^alpha log n). $]

*Tilfælde 3 — $f(n)$ er størst.* Toparbejdet vinder, og svaret er $f(n)$.

#eq[$ "Tilfælde 3:" quad f(n) = Omega(n^(alpha + epsilon)) quad ==> quad T(n) = Theta(f(n)). $]

I tilfælde 3 skal du tjekke regularitetsbetingelsen: at et $c < 1$ opfylder $a thin f(n/b) <= c thin f(n)$ for store $n$. For polynomielle $f$ holder den altid.

#note[MCQ'en har samme faste svarmenu hvert år: $Theta(1)$, $Theta(log n)$, $Theta(n^(log_4 3))$, $Theta(n)$, $Theta(n log n)$, $Theta(n^(log_3 4))$, $Theta(n^2)$, $Theta(n^2 log n)$, $Theta(n^3)$ og "kan ikke løses med Master Theorem". Løs ligningen, og find svaret i menuen.]

Tre situationer giver svaret *"kan ikke løses med Master Theorem"*:

#block(above: 14pt, below: 14pt)[
  #align(center)[
    #table(
      columns: 3,
      align: (left, left, left),
      stroke: none,
      inset: (x: 12pt, y: 8pt),
      table.header(
        [*Fælde*], [*Eksempel*], [*Hvorfor*],
      ),
      table.hline(stroke: 0.4pt + hair),
      [Hullet ($log$-faktor)], [$2 T(n/2) + n log n$], [$f(n)$ kun et $log$ større end $n^alpha$ — for stor til tilfælde 2, for lille til tilfælde 3],
      [Ulige stykker], [$T(n/3) + T(2n/3) + n$], [kaldene har ikke samme størrelse $n/b$],
      [Subtraktion], [$2 T(n-2) + n$], [problemet divideres ikke ($T(n-c)$, ikke $T(n/b)$) — der findes intet $b$],
    )
  ]
]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Master Theorem: løs rekursionsligning],
  source: "MCQ juni 2025, Spm. 1 (samme type 2015–2023)",
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$2$] dot T(n\/#swap[$4$]) + #swap[$n^2$]$],
  options: (
    [$T(n) = Theta(1)$],
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(log_4 3))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(log_3 4))$],
    [$T(n) = Theta(n^2)$],
    [$T(n) = Theta(n^2 log n)$],
    [$T(n) = Theta(n^3)$],
    [Rekursionsligningen kan ikke løses med Master Theorem fra Cormen et al., 4. udgave.],
  ),
  answer: [Mulighed (g): $T(n) = Theta(n^2)$ — tilfælde 3.],
  worked: [$a = #swap[$2$]$, $b = #swap[$4$]$, $f(n) = #swap[$n^2$]$. Skelseksponenten er
  #eq[$ alpha = log_4 2 = 0.5, quad n^alpha = n^(0.5). $]
  $f(n) = n^2$ er polynomielt større end $n^(0.5)$ (med $epsilon = 1.5$): tilfælde 3. Regularitet: $a thin f(n/b) = 2(n/4)^2 = 1/8 n^2 <= c thin n^2$ med $c = 1/8 < 1$. Den holder, så $T(n) = Theta(n^2)$.],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning],
  source: "MCQ juni 2025, Spm. 2",
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$4$] dot T(n\/#swap[$2$]) + #swap[$n^2$]$],
  options: (
    [$T(n) = Theta(1)$],
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(log_4 3))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(log_3 4))$],
    [$T(n) = Theta(n^2)$],
    [$T(n) = Theta(n^2 log n)$],
    [$T(n) = Theta(n^3)$],
    [Rekursionsligningen kan ikke løses med Master Theorem fra Cormen et al., 4. udgave.],
  ),
  answer: [Mulighed (h): $T(n) = Theta(n^2 log n)$ — tilfælde 2.],
  worked: [$a = #swap[$4$]$, $b = #swap[$2$]$, $f(n) = #swap[$n^2$]$. Skelseksponenten er
  #eq[$ alpha = log_2 4 = 2, quad n^alpha = n^2. $]
  $f(n) = n^2$ er lige så stor som $n^alpha$, altså uafgjort med $k = 0$: tilfælde 2, $T(n) = Theta(n^2 log n)$.],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning],
  source: "MCQ juni 2025, Spm. 3",
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$4$] dot T(n\/#swap[$3$]) + #swap[$n$]$],
  options: (
    [$T(n) = Theta(1)$],
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(log_4 3))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(log_3 4))$],
    [$T(n) = Theta(n^2)$],
    [$T(n) = Theta(n^2 log n)$],
    [$T(n) = Theta(n^3)$],
    [Rekursionsligningen kan ikke løses med Master Theorem fra Cormen et al., 4. udgave.],
  ),
  answer: [Mulighed (f): $T(n) = Theta(n^(log_3 4))$ — tilfælde 1.],
  worked: [$a = #swap[$4$]$, $b = #swap[$3$]$, $f(n) = #swap[$n$]$. Skelseksponenten er
  #eq[$ alpha = log_3 4 approx 1.26. $]
  Her vokser $n^alpha$ hurtigere end $f(n) = n$. $f$ er polynomielt mindre: tilfælde 1, $T(n) = Theta(n^(log_3 4))$.],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning],
  source: "MCQ juni 2025, Spm. 4",
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = T(n\/#swap[$4$]) + #swap[$1$]$],
  options: (
    [$T(n) = Theta(1)$],
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(log_4 3))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(log_3 4))$],
    [$T(n) = Theta(n^2)$],
    [$T(n) = Theta(n^2 log n)$],
    [$T(n) = Theta(n^3)$],
    [Rekursionsligningen kan ikke løses med Master Theorem fra Cormen et al., 4. udgave.],
  ),
  answer: [Mulighed (b): $T(n) = Theta(log n)$ — tilfælde 2.],
  worked: [Her er $a = 1$, $b = #swap[$4$]$, $f(n) = #swap[$1$]$. Skelseksponenten er
  #eq[$ alpha = log_4 1 = 0, quad n^alpha = n^0 = 1. $]
  $f(n) = 1$ er lige så stor som $n^0$: tilfælde 2, $T(n) = Theta(log n)$.],
)

#qcard(
  tag: [Master Theorem: kan den løses?],
  source: "MCQ juni 2025, Spm. 2 (samme menu)",
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$5$] dot T(n\/#swap[$5$]) + #swap[$n log n$]$],
  options: (
    [$T(n) = Theta(n^p)$ med $p = log_5 5$],
    [$T(n) = Theta(n^p log n)$ med $p = log_5 5$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (c): rekursionsligningen *kan ikke løses* med Master Theorem.],
  worked: [$a = #swap[$5$]$, $b = #swap[$5$]$, $f(n) = #swap[$n log n$]$. Skelseksponenten er
  #eq[$ alpha = log_5 5 = 1, quad n^alpha = n. $]
  Sammenlign $f(n) = n log n$ mod $n$: den er *større* end $n$ (ikke tilfælde 1 eller 2), men kun en $log$-faktor større — ikke en hel potens, så $f(n)$ er ikke $Omega(n^(1 + epsilon))$ (ikke tilfælde 3). Den falder i hullet mellem tilfælde 2 og 3, og kan derfor ikke løses.],
)

#note[Samme skabelon, fire udfald. Regn $alpha = log_b a$, og lad $f(n)$ dyste mod $n^alpha$: vinder $n^alpha$, tilfælde 1; uafgjort, et ekstra $log n$ (tilfælde 2); vinder $f$, tilfælde 3.]
