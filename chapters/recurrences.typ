#import "../lib.typ": *

== Rekursionsligninger og Master Theorem

En Divide-and-Conquer-algoritme deler problemet op, løser delene rekursivt og samler resultatet. Køretiden $T(n)$ står derfor udtrykt ved sig selv på mindre input. Gør algoritmen $a$ kald, hvert på et stykke af størrelse $n/b$, og bruger $f(n)$ på at dele op og samle, så er

#eq[$ T(n) = a thin T(n/b) + f(n). $]

Master Theorem giver en lukket $Theta$-grænse for $T(n)$.

=== Sådan løser du den

Sammenlign arbejdet i rekursionen, målt af $n^alpha$ med

#eq[$ alpha = log_b a, $]

mod arbejdet uden for, $f(n)$. Den, der vokser hurtigst, bestemmer svaret.

#recipe(
  title: "Master Theorem (Cormen et al., 4. udg.)",
  [Aflæs #swap[$a$], #swap[$b$] og #swap[$f(n)$] fra ligningen. Kun de tre skifter fra år til år.],
  [Regn skelseksponenten $alpha = log_b a$ ud, og skriv skelfunktionen $n^alpha$.],
  [Hold $f(n)$ op mod $n^alpha$ og find tilfældet.],
  [Skriv den $Theta$-grænse, tilfældet giver.],
)

De tre udfald:

#eq[$ "Tilfælde 1:" quad f(n) = O(n^(alpha - epsilon)) quad ==> quad T(n) = Theta(n^alpha). $]

$f$ polynomielt mindre: rekursionen vinder, du får $n^alpha$.

#eq[$ "Tilfælde 2:" quad f(n) = Theta(n^alpha (log n)^k) quad ==> quad T(n) = Theta(n^alpha (log n)^(k+1)). $]

$f$ lige så stor som $n^alpha$ (uafgjort): et $log n$ oveni. Som regel er $k = 0$.

#eq[$ "Tilfælde 3:" quad f(n) = Omega(n^(alpha + epsilon)) quad ==> quad T(n) = Theta(f(n)). $]

$f$ polynomielt større: toparbejdet vinder, du får $f$.

I tilfælde 3 skal du tjekke regularitetsbetingelsen: at et $c < 1$ opfylder $a thin f(n/b) <= c thin f(n)$ for store $n$. For polynomielle $f$ holder den altid.

#note[MCQ'en har samme faste svarmenu hvert år: $Theta(1)$, $Theta(log n)$, $Theta(n^(log_4 3))$, $Theta(n)$, $Theta(n log n)$, $Theta(n^(log_3 4))$, $Theta(n^2)$, $Theta(n^2 log n)$, $Theta(n^3)$ og "kan ikke løses med Master Theorem". Løs ligningen, og find svaret i menuen.]

#trap[Master Theorem kræver, at alle kald har samme størrelse $n/b$. En ligning som $T(n) = T(n/3) + T(2n/3) + n$ har to størrelser, så sætningen gælder ikke — derfor findes svaret "kan ikke løses". Brug et rekursionstræ.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
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
  $f(n) = 1$ er lige så stor som $n^0$: tilfælde 2 med $k = 0$, $T(n) = Theta(log n)$.],
)

#note[Samme skabelon, fire udfald. Regn $alpha = log_b a$, og lad $f(n)$ dyste mod $n^alpha$: vinder $n^alpha$, tilfælde 1; uafgjort, et ekstra $log n$ (tilfælde 2); vinder $f$, tilfælde 3.]
