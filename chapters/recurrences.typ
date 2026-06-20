#import "../lib.typ": *

== Rekursionsligninger og Master Theorem <th-recurrences>

En Divide-and-Conquer-algoritme deler problemet op, løser delene rekursivt (recursively) og samler resultatet. Køretiden $T(n)$ står derfor udtrykt ved sig selv på mindre input. Gør algoritmen $a$ kald, hvert på et stykke af størrelse $n/b$, og bruger $f(n)$ på at dele op og samle, så er

#eq[$ T(n) = a thin T(n/b) + f(n). $]

Master Theorem giver en lukket $Theta$-grænse for $T(n)$.

=== Sådan løser du den <th-rec-method>

Sammenlign arbejdet i rekursionen, målt af $n^alpha$ med

#eq[$ alpha = log_b a, $]

mod arbejdet uden for, $f(n)$. Den, der vokser hurtigst, bestemmer svaret.

#note(title: [Skelseksponenten])[Skelseksponenten $alpha = log_b a$ er det samme som $p$ i eksamenens svar: skriver opgaven $Theta(n^p)$, så er $p = alpha = log_b a$. Du regner altså $p$ ved at tage $log$ af $a$ med grundtal $b$ — fx $T(n) = 5 T(n/2) + n^2$ giver $p = log_2 5$. Pas på rækkefølgen: det er $log_b a$, ikke $log_a b$.]

#note(title: [Regn $log_b a$ i hovedet])[Spørg dig selv: hvilken potens skal $b$ opløftes i for at give $a$? Det tal er $log_b a$. Er $a$ en potens af $b$, går det glat op: $log_2 8 = 3$ fordi $2^3 = 8$, og $log_4 2 = 0.5$ fordi $4^(0.5) = 2$. To faste holdepunkter er $log_b b = 1$ og $log_b 1 = 0$. Går det ikke op, så klem værdien inde mellem to nabopotenser: $log_2 5$ ligger mellem $log_2 4 = 2$ og $log_2 8 = 3$, altså lidt over $2$ (præcist $approx 2.32$). Til Master Theorem behøver du sjældent mere end den indklemning, for du skal bare vide, om $n^alpha$ lander til venstre eller højre for $f(n)$ på stigen.]

#note(title: [Hvornår $p$ optræder])[*$p$ optræder kun når svaret er $n^alpha$ (tilfælde 1).* Vinder $f(n)$ (tilfælde 3), er svaret $f(n)$ selv — fx $Theta(n^(1/2))$ — uden noget $p$. Tommelfinger: ser du "$p = log_b a$", er det tilfælde 1; ser du en ren funktion som $n^(1/2)$ eller $n^2$, er det tilfælde 3.]

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
      [lige store med en $log$-faktor ($k = 1$)], [$f(n) = n log n$], [2], [$Theta(n^alpha log^2 n)$],
    )
  ]
]

For at se *hvem der er størst*, placér både $n^alpha$ og $f(n)$ på vækststigen — længst til højre vinder:

#eq[$ 1 quad < quad log n quad < quad sqrt(n) quad < quad n quad < quad n log n quad < quad n^2 quad < quad n^2 log n quad < quad n^3 quad < quad 2^n $]

#note(title: [Potenser på stigen])[Et $n^c$ med større potens slår altid et med mindre ($n^2 > n^(1.5) > n$), uanset $log$-faktorer: ethvert $n^c$ slår $log n$, og enhver eksponentiel ($2^n$) slår alle $n^c$. Til Master Theorem: er $n^alpha$ længere til højre end $f(n)$, er det tilfælde 1; står de på samme plads, tilfælde 2; er $f(n)$ en *hel potens* længere til højre, tilfælde 3. Bemærk $n^alpha$ kan have skæv potens, fx $n^(log_2 5) approx n^(2.32)$, som ligger mellem $n^2$ og $n^3$.]

#metadata(none) <th-rec-hole>
#trap(title: [En $log$-faktor er tilfælde 2 — ikke et hul])[I 3. udgave faldt $f(n) = n log n$ (med $n^alpha = n$) i et hul mellem tilfælde 2 og 3 og kunne ikke løses. *Det hul er lukket i 4. udgave.* En $log$-faktor oven på $n^alpha$ er tilfælde 2 med $k = 1$, og svaret er $Theta(n log^2 n)$. Gamle eksamenssæt og løsningsforslag svarer "kan ikke løses" her — det er den gamle sætning, og det er forkert i år. Tilfælde 3 kræver stadig, at $f(n)$ er en *hel potens* større end $n^alpha$ (fx $n^2$ mod $n$); en ren $log$-faktor er ikke nok til tilfælde 3.]

*Tilfælde 1 — $n^alpha$ er størst.* Rekursionen vinder, og svaret er $n^alpha$.

#eq[$ "Tilfælde 1:" quad f(n) = O(n^(alpha - epsilon)) quad ==> quad T(n) = Theta(n^alpha). $]

*Tilfælde 2 — de er lige store.* Står $f(n)$ på samme trin som $n^alpha$, lægger du et $log$ oveni. 4. udgave skriver det med en parameter $k >= 0$, så det også dækker, når $f(n)$ allerede bærer en $log$-faktor:

#eq[$ "Tilfælde 2:" quad f(n) = Theta(n^alpha log^k n), thick k >= 0 quad ==> quad T(n) = Theta(n^alpha log^(k+1) n). $]

Det velkendte tilfælde er $k = 0$: $f(n) = Theta(n^alpha)$ giver $Theta(n^alpha log n)$. Men $k = 1$ tæller med — fx $f(n) = n log n$ med $n^alpha = n$ giver $Theta(n log^2 n)$. Hver ekstra $log$ i $f$ giver én ekstra $log$ i svaret.

*Tilfælde 3 — $f(n)$ er størst.* Toparbejdet vinder, og svaret er $f(n)$.

#eq[$ "Tilfælde 3:" quad f(n) = Omega(n^(alpha + epsilon)) quad ==> quad T(n) = Theta(f(n)). $]

I tilfælde 3 skal du tjekke regularitetsbetingelsen (regularity condition): at et $c < 1$ opfylder $a thin f(n/b) <= c thin f(n)$ for store $n$. For polynomielle $f$ holder den altid.

#note(title: [Fast svarmenu])[De gamle sæt har samme faste svarmenu: $Theta(1)$, $Theta(log n)$, $Theta(n^(log_4 3))$, $Theta(n)$, $Theta(n log n)$, $Theta(n^(log_3 4))$, $Theta(n^2)$, $Theta(n^2 log n)$, $Theta(n^3)$ og "kan ikke løses med Master Theorem". Med 4. udgaves tilfælde 2 kan en $log^2$-grænse som $Theta(n log^2 n)$ nu også være det rigtige svar, så regn med, at menuen i år kan rumme den slags. Løs ligningen, og find svaret i menuen.]

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
      [Negativ $log$-faktor], [$2 T(n/2) + n\/log n$], [$f(n) = n^alpha \/ log n$ ligger et $log$ *under* $n^alpha$ — det svarer til $k = -1$, og tilfælde 2 kræver $k >= 0$],
      [Ulige stykker], [$T(n/3) + T(2n/3) + n$], [kaldene har ikke samme størrelse $n/b$],
      [Subtraktion], [$2 T(n-2) + n$], [problemet divideres ikke ($T(n-c)$, ikke $T(n/b)$) — der findes intet $b$],
    )
  ]
]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2025, Spm. 1 (samme type 2015–2023)",
  theory: <th-rec-method>,
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
  blueprint: [
    Tre tal styrer hele opgaven, $a$, $b$ og $f(n)$. Resten kører ens hver gang.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$] i ligningen.
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Sæt $n^alpha$ og $f(n)$ på vækststigen og se hvem der står længst til højre.
    + *Vælg tilfælde.* Vinder $n^alpha$, er det tilfælde 1. Står de lige, tilfælde 2. Vinder $f(n)$ med en hel potens, tilfælde 3.
    + *Skriv svaret.* Læs $Theta$-grænsen af tabellen og find den i svarmenuen.
  ],
  worked: [
    Tallene her er $a = #swap[$2$]$, $b = #swap[$4$]$ og $f(n) = #swap[$n^2$]$.

    + Skelseksponenten: $alpha = log_4 2 = 0.5$, så $n^alpha = n^(0.5)$.
    + Sammenlign $n^(0.5)$ mod $n^2$. $f(n)$ er klart størst.
    + Forskellen er halvanden potens, altså mindst en hel. Det er tilfælde 3.
    + Tjek regularitet: $a thin f(n/b) = 2(n/4)^2 = 1/8 n^2 <= c thin n^2$ med $c = 1/8 < 1$. Den holder.

    Svar: $T(n) = Theta(n^2)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2025, Spm. 2",
  theory: <th-rec-method>,
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
  blueprint: [
    Samme tre tal som altid, $a$, $b$ og $f(n)$. Stå særligt klar på tilfælde 2, hvor $f(n)$ og $n^alpha$ ender lige store.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Står $f(n)$ og $n^alpha$ samme sted på stigen, er det uafgjort.
    + *Læg log på.* Uafgjort er tilfælde 2, og du ganger et $log n$ på $n^alpha$.
  ],
  worked: [
    Tallene her er $a = #swap[$4$]$, $b = #swap[$2$]$ og $f(n) = #swap[$n^2$]$.

    + Skelseksponenten: $alpha = log_2 4 = 2$, så $n^alpha = n^2$.
    + Sammenlign $n^2$ mod $n^2$. De står samme sted på stigen.
    + Lige store er tilfælde 2, og så koster det et ekstra $log n$.

    Svar: $T(n) = Theta(n^2 log n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2025, Spm. 3",
  theory: <th-rec-method>,
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
  blueprint: [
    De samme tre tal, men her er pointen, at $n^alpha$ kan have en skæv potens og stadig vinde.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$. Den behøver ikke være et helt tal.
    + *Sammenlign.* Ligger $n^alpha$ længere til højre på stigen end $f(n)$, vinder rekursionen.
    + *Skriv svaret.* Vinder $n^alpha$ med en hel potens, er det tilfælde 1, og svaret er $Theta(n^alpha)$.
  ],
  worked: [
    Tallene her er $a = #swap[$4$]$, $b = #swap[$3$]$ og $f(n) = #swap[$n$]$.

    + Skelseksponenten: $alpha = log_3 4 approx 1.26$.
    + Sammenlign $n^(1.26)$ mod $n$. $n^alpha$ ligger længere til højre.
    + $n^alpha$ vinder, og $f$ er en hel potens mindre. Tilfælde 1.

    Svar: $T(n) = Theta(n^(log_3 4))$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2025, Spm. 4",
  theory: <th-rec-method>,
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
  blueprint: [
    Pas på de små tal. Når $a = 1$ bliver $alpha = 0$, og $n^alpha$ falder helt ned til en konstant.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$]. Med ét kald er $a = 1$.
    + *Skelseksponent.* Regn $alpha = log_b a$. Er $a = 1$, er $alpha = 0$ og $n^alpha = 1$.
    + *Sammenlign.* Er $f(n)$ også konstant, står de lige.
    + *Læg log på.* Lige store er tilfælde 2. Med $n^alpha = 1$ bliver $Theta(n^alpha log n)$ til et rent $Theta(log n)$.
  ],
  worked: [
    Tallene her er $a = 1$, $b = #swap[$4$]$ og $f(n) = #swap[$1$]$.

    + Skelseksponenten: $alpha = log_4 1 = 0$, så $n^alpha = n^0 = 1$.
    + Sammenlign $f(n) = 1$ mod $n^0 = 1$. De er ens.
    + Lige store er tilfælde 2. Med $n^alpha = 1$ bliver det et rent $log n$.

    Svar: $T(n) = Theta(log n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2015, Spm. 1",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$5$] dot T(n\/#swap[$2$]) + #swap[$n^2$]$],
  options: (
    [$T(n) = Theta(n^p)$ med $p = log_2 5$],
    [$T(n) = Theta(n^p)$ med $p = log_5 2$],
    [$T(n) = Theta(n^p log n)$ med $p = log_2 5$],
    [$T(n) = Theta(n^p log n)$ med $p = log_5 2$],
    [$T(n) = Theta(n^2)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (a): $T(n) = Theta(n^p)$ med $p = log_2 5$ — tilfælde 1.],
  blueprint: [
    De samme tre tal, men her er fælden, at skelseksponenten ender skæv og stadig slår $f(n)$.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$. Den behøver ikke være et helt tal.
    + *Sammenlign.* Ligger $n^alpha$ længere til højre på stigen end $f(n)$, vinder rekursionen.
    + *Skriv svaret.* Vinder $n^alpha$ med en hel potens, er det tilfælde 1, og svaret er $Theta(n^alpha)$. Pas på rækkefølgen: det er $log_2 5$, ikke $log_5 2$.
  ],
  worked: [
    Tallene her er $a = #swap[$5$]$, $b = #swap[$2$]$ og $f(n) = #swap[$n^2$]$.

    + Skelseksponenten: $alpha = log_2 5 approx 2.32$, så $n^alpha approx n^(2.32)$.
    + Sammenlign $n^(2.32)$ mod $n^2$. $n^alpha$ ligger længere til højre.
    + $n^alpha$ vinder med en hel potens. Tilfælde 1.

    Svar: $T(n) = Theta(n^(log_2 5))$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2015, Spm. 3",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$2$] dot T(n\/#swap[$5$]) + #swap[$n^(1\/2)$]$],
  options: (
    [$T(n) = Theta(n^p)$ med $p = log_2 5$],
    [$T(n) = Theta(n^p)$ med $p = log_5 2$],
    [$T(n) = Theta(n^p log n)$ med $p = log_2 5$],
    [$T(n) = Theta(n^p log n)$ med $p = log_5 2$],
    [$T(n) = Theta(n^(1\/2))$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (e): $T(n) = Theta(n^(1\/2))$ — tilfælde 3.],
  blueprint: [
    De samme tre tal. Her er pointen, at $f(n)$ vinder, selv om begge potenser er små brøker.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Skriv $f(n) = n^c$, og hold $c$ op mod $alpha$.
    + *Vælg tilfælde.* Er $c > alpha$, vinder $f(n)$ — tilfælde 3, og svaret er $Theta(f(n))$.
  ],
  worked: [
    Tallene her er $a = #swap[$2$]$, $b = #swap[$5$]$ og $f(n) = #swap[$n^(1\/2)$]$, så $c = 0.5$.

    + Skelseksponenten: $alpha = log_5 2 approx 0.43$.
    + Sammenlign $c = 0.5$ mod $alpha approx 0.43$. $f(n)$ er størst.
    + $f$ vinder, så det er tilfælde 3. Regularitet: $a thin f(n/b) = 2(n/5)^(1/2) approx 0.89 n^(1/2) <= c thin f(n)$ med $c < 1$. Den holder.

    Svar: $T(n) = Theta(n^(1\/2))$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2017, Spm. 1",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = T(n\/#swap[$4$]) + #swap[$n$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1\/4))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^4)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (c): $T(n) = Theta(n)$ — tilfælde 3.],
  blueprint: [
    Pas på de små tal. Med ét kald er $a = 1$, så $alpha = 0$ og $n^alpha$ falder ned til en konstant.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$]. Med ét kald er $a = 1$.
    + *Skelseksponent.* Regn $alpha = log_b a$. Er $a = 1$, er $alpha = 0$ og $n^alpha = 1$.
    + *Sammenlign.* Er $f(n)$ en hel potens større end konstanten, vinder $f(n)$.
    + *Skriv svaret.* Tilfælde 3 giver $Theta(f(n))$.
  ],
  worked: [
    Tallene her er $a = 1$, $b = #swap[$4$]$ og $f(n) = #swap[$n$]$.

    + Skelseksponenten: $alpha = log_4 1 = 0$, så $n^alpha = 1$.
    + Sammenlign $f(n) = n$ mod $1$. $f$ er en hel potens større.
    + Tilfælde 3. Regularitet: $a thin f(n/b) = n/4 <= c thin n$ med $c = 1/4 < 1$. Den holder.

    Svar: $T(n) = Theta(n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2017, Spm. 2",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$3$] dot T(n\/#swap[$4$]) + #swap[$n$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(3\/4))$],
    [$T(n) = Theta(n^alpha)$ med $alpha = log_4 3$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(4\/3))$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (d): $T(n) = Theta(n)$ — tilfælde 3.],
  blueprint: [
    De samme tre tal. Her ligger $n^alpha$ lige under $n$, så $f(n) = n$ vinder.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Hold $f(n)$ op mod $n^alpha$ på vækststigen.
    + *Skriv svaret.* Vinder $f(n)$ med en hel potens, er det tilfælde 3, og svaret er $Theta(f(n))$.
  ],
  worked: [
    Tallene her er $a = #swap[$3$]$, $b = #swap[$4$]$ og $f(n) = #swap[$n$]$.

    + Skelseksponenten: $alpha = log_4 3 approx 0.79$, så $n^alpha approx n^(0.79)$.
    + Sammenlign $n$ mod $n^(0.79)$. $f$ er størst.
    + $f$ vinder med en hel potens. Tilfælde 3. Regularitet: $a thin f(n/b) = 3(n/4) = 0.75 n <= c thin n$ med $c = 0.75 < 1$. Den holder.

    Svar: $T(n) = Theta(n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2017, Spm. 3",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$3$] dot T(n\/#swap[$4$]) + #swap[$n^(3\/4)$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(3\/4))$],
    [$T(n) = Theta(n^alpha)$ med $alpha = log_4 3$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(4\/3))$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (c): $T(n) = Theta(n^alpha)$ med $alpha = log_4 3$ — tilfælde 1.],
  blueprint: [
    De samme tre tal. Fælden her: $f(n) = n^(3\/4)$ ligger lige under $n^alpha$, så rekursionen vinder snævert.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Skriv $f(n) = n^c$ og hold $c$ op mod $alpha$ — også når de ligger tæt.
    + *Skriv svaret.* Er $c < alpha$, vinder $n^alpha$. Tilfælde 1 giver $Theta(n^alpha)$.
  ],
  worked: [
    Tallene her er $a = #swap[$3$]$, $b = #swap[$4$]$ og $f(n) = #swap[$n^(3\/4)$]$, så $c = 0.75$.

    + Skelseksponenten: $alpha = log_4 3 approx 0.79$.
    + Sammenlign $c = 0.75$ mod $alpha approx 0.79$. $n^alpha$ er størst, om end snævert.
    + $n^alpha$ vinder, så $f(n) = O(n^(alpha - epsilon))$. Tilfælde 1.

    Svar: $T(n) = Theta(n^(log_4 3))$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2019, Spm. 1",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = T(#swap[$3$]n\/#swap[$4$]) + #swap[$n$]$],
  options: (
    [$T(n) = Theta(1)$],
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1\/4))$],
    [$T(n) = Theta(n^(1\/3))$],
    [$T(n) = Theta(n^(3\/4))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(log_3 4))$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (f): $T(n) = Theta(n)$ — tilfælde 3.],
  blueprint: [
    Pas på, når $n/b$ er skrevet som $3n\/4$. Så er $b = 4\/3$, og ét kald giver stadig $a = 1$.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$]. Står der $3n\/4$, er $b = 4\/3$.
    + *Skelseksponent.* Regn $alpha = log_b a$. Er $a = 1$, er $alpha = 0$ og $n^alpha = 1$.
    + *Sammenlign.* Er $f(n)$ en hel potens større end konstanten, vinder $f(n)$.
    + *Skriv svaret.* Tilfælde 3 giver $Theta(f(n))$.
  ],
  worked: [
    Tallene her er $a = 1$, $b = #swap[$4\/3$]$ og $f(n) = #swap[$n$]$.

    + Skelseksponenten: $alpha = log_(4/3) 1 = 0$, så $n^alpha = 1$.
    + Sammenlign $f(n) = n$ mod $1$. $f$ er en hel potens større.
    + Tilfælde 3. Regularitet: $a thin f(n/b) = 3n/4 = (3/4) f(n)$ med $c = 3/4 < 1$. Den holder.

    Svar: $T(n) = Theta(n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2019, Spm. 2",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$3$] dot T(n\/#swap[$3$]) + #swap[$n$]$],
  options: (
    [$T(n) = Theta(1)$],
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1\/3))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^3)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (e): $T(n) = Theta(n log n)$ — tilfælde 2.],
  blueprint: [
    De samme tre tal. Stå klar på tilfælde 2, hvor $f(n)$ og $n^alpha$ ender lige store.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Står $f(n)$ og $n^alpha$ samme sted på stigen, er det uafgjort.
    + *Læg log på.* Uafgjort er tilfælde 2, og du ganger et $log n$ på $n^alpha$.
  ],
  worked: [
    Tallene her er $a = #swap[$3$]$, $b = #swap[$3$]$ og $f(n) = #swap[$n$]$.

    + Skelseksponenten: $alpha = log_3 3 = 1$, så $n^alpha = n$.
    + Sammenlign $n$ mod $n$. De står samme sted.
    + Lige store er tilfælde 2, og så koster det et ekstra $log n$.

    Svar: $T(n) = Theta(n log n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2021, Spm. 1",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$3$] dot T(n\/#swap[$2$]) + #swap[$n^2$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(sqrt(n))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^2)$],
    [$T(n) = Theta(n^2 log n)$],
    [$T(n) = Theta(n^3)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (e): $T(n) = Theta(n^2)$ — tilfælde 3.],
  blueprint: [
    De samme tre tal. Her er skelseksponenten skæv ($log_2 3 approx 1.58$), og $f(n) = n^2$ slår den.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Hold $f(n)$ op mod $n^alpha$ på vækststigen.
    + *Skriv svaret.* Vinder $f(n)$ med en hel potens, er det tilfælde 3, og svaret er $Theta(f(n))$.
  ],
  worked: [
    Tallene her er $a = #swap[$3$]$, $b = #swap[$2$]$ og $f(n) = #swap[$n^2$]$.

    + Skelseksponenten: $alpha = log_2 3 approx 1.58$, så $n^alpha approx n^(1.58)$.
    + Sammenlign $n^2$ mod $n^(1.58)$. $f$ er størst, med ca. en halv potens i overskud.
    + $f$ vinder med en hel potens. Tilfælde 3. Regularitet: $a thin f(n/b) = 3(n/2)^2 = 3/4 n^2 <= c thin n^2$ med $c = 3/4 < 1$. Den holder.

    Svar: $T(n) = Theta(n^2)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2021, Spm. 2",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$9$] dot T(n\/#swap[$3$]) + #swap[$n^(1\/2)$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(sqrt(n))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^2)$],
    [$T(n) = Theta(n^2 log n)$],
    [$T(n) = Theta(n^3)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (e): $T(n) = Theta(n^2)$ — tilfælde 1.],
  blueprint: [
    De samme tre tal. Her vinder $n^alpha$ stort, fordi $f(n) = sqrt(n)$ er meget lille.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Ligger $n^alpha$ langt til højre for $f(n)$, vinder rekursionen.
    + *Skriv svaret.* Tilfælde 1 giver $Theta(n^alpha)$.
  ],
  worked: [
    Tallene her er $a = #swap[$9$]$, $b = #swap[$3$]$ og $f(n) = #swap[$n^(1\/2)$]$.

    + Skelseksponenten: $alpha = log_3 9 = 2$, så $n^alpha = n^2$.
    + Sammenlign $n^(0.5)$ mod $n^2$. $n^alpha$ vinder klart.
    + $n^alpha$ er en hel potens større. Tilfælde 1.

    Svar: $T(n) = Theta(n^2)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2021, Spm. 3",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$4$] dot T(n\/#swap[$2$]) + #swap[$n^2$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(sqrt(n))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^2)$],
    [$T(n) = Theta(n^2 log n)$],
    [$T(n) = Theta(n^3)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (f): $T(n) = Theta(n^2 log n)$ — tilfælde 2.],
  blueprint: [
    De samme tre tal. Stå klar på tilfælde 2, hvor $f(n)$ og $n^alpha$ ender lige store.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Står $f(n)$ og $n^alpha$ samme sted på stigen, er det uafgjort.
    + *Læg log på.* Uafgjort er tilfælde 2, og du ganger et $log n$ på $n^alpha$.
  ],
  worked: [
    Tallene her er $a = #swap[$4$]$, $b = #swap[$2$]$ og $f(n) = #swap[$n^2$]$.

    + Skelseksponenten: $alpha = log_2 4 = 2$, så $n^alpha = n^2$.
    + Sammenlign $n^2$ mod $n^2$. De står samme sted.
    + Lige store er tilfælde 2, og så koster det et ekstra $log n$.

    Svar: $T(n) = Theta(n^2 log n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2021, Spm. 4",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$2$] dot T(n\/#swap[$3$]) + #swap[$n log n$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(sqrt(n))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^2)$],
    [$T(n) = Theta(n^2 log n)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (d): $T(n) = Theta(n log n)$ — tilfælde 3.],
  blueprint: [
    $f(n) = n log n$ har en $log$-faktor, men afgørelsen er ren tilfælde 3: $n^alpha$ ligger en hel potens under $n$, så $f(n)$ vinder.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Ligger $f(n)$ en hel potens over $n^alpha$ (selv med en $log$-faktor), vinder $f(n)$.
    + *Skriv svaret.* Tilfælde 3 giver $Theta(f(n))$, her $Theta(n log n)$.
  ],
  worked: [
    Tallene her er $a = #swap[$2$]$, $b = #swap[$3$]$ og $f(n) = #swap[$n log n$]$.

    + Skelseksponenten: $alpha = log_3 2 approx 0.63$, så $n^alpha approx n^(0.63)$.
    + Sammenlign $n log n$ mod $n^(0.63)$. $f$ er størst, med ca. en tredjedels potens i overskud — altså en hel potens, ikke kun et $log$.
    + $f$ er $Omega(n^(alpha + epsilon))$. Tilfælde 3. Regularitet: $a thin f(n/b) = 2(n/3) log(n/3) <= c thin n log n$ med $c = 2/3 < 1$ for store $n$. Den holder.

    Svar: $T(n) = Theta(n log n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2023, Spm. 1",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$2$] dot T(n\/#swap[$2$]) + #swap[$n^(1\/2)$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1\/2))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(3\/2))$],
    [$T(n) = Theta(n^2)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (c): $T(n) = Theta(n)$ — tilfælde 1.],
  blueprint: [
    De samme tre tal. Her vinder $n^alpha = n$, fordi $f(n) = sqrt(n)$ er en hel potens mindre.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Ligger $n^alpha$ en hel potens over $f(n)$, vinder rekursionen.
    + *Skriv svaret.* Tilfælde 1 giver $Theta(n^alpha)$.
  ],
  worked: [
    Tallene her er $a = #swap[$2$]$, $b = #swap[$2$]$ og $f(n) = #swap[$n^(1\/2)$]$.

    + Skelseksponenten: $alpha = log_2 2 = 1$, så $n^alpha = n$.
    + Sammenlign $n^(0.5)$ mod $n$. $n^alpha$ er en halv potens større.
    + $n^alpha$ vinder, $f(n) = O(n^(alpha - epsilon))$. Tilfælde 1.

    Svar: $T(n) = Theta(n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2023, Spm. 2",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = T(n\/#swap[$2$]) + #swap[$n^(1\/2)$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1\/2))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(3\/2))$],
    [$T(n) = Theta(n^2)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (b): $T(n) = Theta(n^(1\/2))$ — tilfælde 3.],
  blueprint: [
    Pas på de små tal. Ét kald giver $a = 1$, så $alpha = 0$ og $n^alpha = 1$, og selv $sqrt(n)$ slår en konstant.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$]. Med ét kald er $a = 1$.
    + *Skelseksponent.* Regn $alpha = log_b a$. Er $a = 1$, er $alpha = 0$ og $n^alpha = 1$.
    + *Sammenlign.* Er $f(n)$ en hel potens større end konstanten, vinder $f(n)$.
    + *Skriv svaret.* Tilfælde 3 giver $Theta(f(n))$.
  ],
  worked: [
    Tallene her er $a = 1$, $b = #swap[$2$]$ og $f(n) = #swap[$n^(1\/2)$]$.

    + Skelseksponenten: $alpha = log_2 1 = 0$, så $n^alpha = 1$.
    + Sammenlign $n^(0.5)$ mod $1$. $f$ er en hel potens større.
    + Tilfælde 3. Regularitet: $a thin f(n/b) = sqrt(n/2) = sqrt(n)/sqrt(2) <= c thin sqrt(n)$ med $c = 1/sqrt(2) < 1$. Den holder.

    Svar: $T(n) = Theta(n^(1\/2))$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2023, Spm. 3",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$2$] dot T(n\/#swap[$2$]) + #swap[$1\/2$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1\/2))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(3\/2))$],
    [$T(n) = Theta(n^2)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (c): $T(n) = Theta(n)$ — tilfælde 1.],
  blueprint: [
    Pas på et konstant $f(n)$. En ren konstant er $Theta(1)$ og taber til ethvert $n^alpha$ med $alpha > 0$.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$]. Et tal uden $n$ er $f(n) = Theta(1)$.
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Er $alpha > 0$, ligger $n^alpha$ over konstanten, så rekursionen vinder.
    + *Skriv svaret.* Tilfælde 1 giver $Theta(n^alpha)$.
  ],
  worked: [
    Tallene her er $a = #swap[$2$]$, $b = #swap[$2$]$ og $f(n) = #swap[$1\/2$]$, altså $Theta(1)$.

    + Skelseksponenten: $alpha = log_2 2 = 1$, så $n^alpha = n$.
    + Sammenlign $Theta(1)$ mod $n$. $n^alpha$ er en hel potens større.
    + $f(n) = O(n^(alpha - epsilon))$. Tilfælde 1.

    Svar: $T(n) = Theta(n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2023, Spm. 4",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = T(n\/#swap[$2$]) + #swap[$1\/2$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1\/2))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(3\/2))$],
    [$T(n) = Theta(n^2)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (a): $T(n) = Theta(log n)$ — tilfælde 2.],
  blueprint: [
    Pas på de små tal. Når både $a = 1$ og $f(n)$ er konstant, står $n^alpha = 1$ og $f(n)$ lige, og tilfælde 2 koger ned til et rent $log n$.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$]. Med ét kald er $a = 1$.
    + *Skelseksponent.* Regn $alpha = log_b a$. Er $a = 1$, er $alpha = 0$ og $n^alpha = 1$.
    + *Sammenlign.* Er $f(n)$ også konstant, står de lige.
    + *Læg log på.* Lige store er tilfælde 2. Med $n^alpha = 1$ bliver $Theta(n^alpha log n)$ til et rent $Theta(log n)$.
  ],
  worked: [
    Tallene her er $a = 1$, $b = #swap[$2$]$ og $f(n) = #swap[$1\/2$]$, altså $Theta(1)$.

    + Skelseksponenten: $alpha = log_2 1 = 0$, så $n^alpha = 1$.
    + Sammenlign $f(n) = Theta(1)$ mod $1$. De er ens.
    + Lige store er tilfælde 2. Med $n^alpha = 1$ bliver det et rent $log n$.

    Svar: $T(n) = Theta(log n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "MCQ juni 2019, Spm. 4",
  theory: <th-rec-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$4$] dot T(n\/#swap[$3$]) + #swap[$n log n$]$],
  options: (
    [$T(n) = Theta(1)$],
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1\/4))$],
    [$T(n) = Theta(n^(1\/3))$],
    [$T(n) = Theta(n^(3\/4))$],
    [$T(n) = Theta(n^(log_4 3))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(log_3 4))$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (i): $T(n) = Theta(n^(log_3 4))$ — tilfælde 1.],
  blueprint: [
    De samme tre tal. $f(n) = n log n$ har en $log$-faktor, men $n^alpha$ ligger en hel potens over, så rekursionen vinder i tilfælde 1.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Hold $f(n)$ op mod $n^alpha$ på vækststigen. En $log$-faktor er ikke en hel potens.
    + *Skriv svaret.* Vinder $n^alpha$ med en hel potens, er det tilfælde 1, og svaret er $Theta(n^alpha)$.
  ],
  worked: [
    Tallene her er $a = #swap[$4$]$, $b = #swap[$3$]$ og $f(n) = #swap[$n log n$]$.

    + Skelseksponenten: $alpha = log_3 4 approx 1.26$, så $n^alpha approx n^(1.26)$.
    + Sammenlign $n log n$ mod $n^(1.26)$. $n^alpha$ ligger en hel potens over, og en $log$-faktor flytter ikke $f(n)$ op forbi den.
    + $f(n) = O(n^(alpha - epsilon))$. Tilfælde 1.

    Svar: $T(n) = Theta(n^(log_3 4))$.
  ],
)

#qcard(
  tag: [Master Theorem: log-faktor er tilfælde 2],
  source: "MCQ juni 2025, Spm. 2 (samme menu)",
  theory: <th-rec-hole>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$5$] dot T(n\/#swap[$5$]) + #swap[$n log n$]$],
  options: (
    [$T(n) = Theta(n^p)$ med $p = log_5 5$],
    [$T(n) = Theta(n^p log^2 n)$ med $p = log_5 5$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (b): $T(n) = Theta(n log^2 n)$ — tilfælde 2 med $k = 1$.],
  blueprint: [
    Klassikeren, der i 3. udgave faldt i hullet. Med 4. udgaves $k$-led er $f(n) = n log n$ tilfælde 2.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Er $f(n) = Theta(n^alpha log^k n)$ med $k >= 0$, er det tilfælde 2.
    + *Skriv svaret.* Tilfælde 2 giver $Theta(n^alpha log^(k+1) n)$.
  ],
  worked: [
    Tallene her er $a = #swap[$5$]$, $b = #swap[$5$]$ og $f(n) = #swap[$n log n$]$.

    + Skelseksponenten: $alpha = log_5 5 = 1$, så $n^alpha = n$.
    + $f(n) = n log n = Theta(n^1 log^1 n)$, altså tilfælde 2 med $k = 1$.
    + Svaret er $Theta(n^alpha log^(k+1) n) = Theta(n log^2 n)$.

    Svar: $T(n) = Theta(n log^2 n)$. (I 3. udgave faldt denne i hullet og blev svaret "kan ikke løses".)
  ],
)

#qcard(
  tag: [Master Theorem: kan den løses? (subtraktiv form)],
  source: "MCQ juni 2015, Spm. 4",
  theory: <th-rec-hole>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$2$] dot T(n - #swap[$2$]) + #swap[$n$]$],
  options: (
    [$T(n) = Theta(n^p)$ med $p = log_2 2$],
    [$T(n) = Theta(n^p log n)$ med $p = log_2 2$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (c): rekursionsligningen *kan ikke løses* med Master Theorem.],
  blueprint: [
    Tjek formen, før du regner. Master Theorem kræver $T(n) = a thin T(n/b) + f(n)$, hvor inputtet *divideres* med et $b > 1$.

    + *Tjek formen.* Står der $T(n - c)$ i stedet for $T(n/b)$, trækker rekursionen en konstant fra — der findes intet $b$.
    + *Konkludér.* Subtraktionsrekursioner falder uden for Master Theorem.
    + *Bekræft.* Sådanne rekursioner vokser typisk eksponentielt ($Theta(a^(n/c))$), så ingen $Theta(n^p)$ passer alligevel.
    + *Vælg svaret.* Vælg "kan ikke løses".
  ],
  worked: [
    Tallene her er $a = #swap[$2$]$, og delproblemet er #swap[$n - 2$].

    + Delproblemet er $n - 2$ (input minus en konstant), ikke $n/b$.
    + Master Theorem kræver delform $T(n/b)$ med $b > 1$, så den gælder ikke.
    + Værdierne $4, 12, 30, 68, dots.h$ vokser eksponentielt ($Theta(2^(n/2))$), ikke polynomielt. Så (a) og (b) er også forkerte.

    Svar: kan ikke løses med Master Theorem.
  ],
)

#qcard(
  tag: [Master Theorem: kan den løses? (forkert form)],
  source: "MCQ juni 2017, Spm. 4",
  theory: <th-rec-hole>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$3$] thin T(n^(#swap[$1\/4$])) + #swap[$n^(3\/4)$]$],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^alpha)$ med $alpha = log_4 3$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(4\/3))$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (f): rekursionsligningen *kan ikke løses* med Master Theorem.],
  blueprint: [
    Tjek formen. Master Theorem kræver, at det rekursive argument er $n$ divideret med et konstant $b$.

    + *Tjek formen.* Er argumentet en rod ($n^(1\/4)$) eller på anden vis ikke $n/b$, er den ikke direkte på Master-form.
    + *Substituér.* Sæt $n = 2^m$ og $S(m) = T(2^m)$, så argumentet bliver lineært i $m$.
    + *Tjek drivledet.* For standard Master Theorem skal drivledet være polynomielt i $m$, $Theta(m^c)$.
    + *Konkludér.* Er drivledet eksponentielt i $m$, gælder standard-Master Theorem ikke. Vælg "kan ikke løses".
  ],
  worked: [
    Argumentet her er #swap[$n^(1\/4)$], ikke $n/b$.

    + Sæt $n = 2^m$ og $S(m) = T(2^m)$. Så er $T(n^(1\/4)) = S(m/4)$ og $n^(3\/4) = 2^((3\/4) m)$.
    + Det giver $S(m) = 3 thin S(m/4) + 2^((3\/4) m)$.
    + Standard-Master Theorem holder drivledet op mod $m^(log_4 3)$, men $2^((3\/4) m)$ er eksponentielt i $m$, ikke polynomielt. Den gælder ikke.

    Svar: kan ikke løses med Master Theorem.
  ],
)

#qcard(
  tag: [Master Theorem: log-faktor er tilfælde 2],
  source: "MCQ juni 2019, Spm. 3",
  theory: <th-rec-hole>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = T(n\/#swap[$4$]) + #swap[$log n$]$],
  options: (
    [$T(n) = Theta(1)$],
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(log^2 n)$],
    [$T(n) = Theta(n^(1\/4))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (c): $T(n) = Theta(log^2 n)$ — tilfælde 2 med $k = 1$.],
  blueprint: [
    Med $a = 1$ er $n^alpha = 1$, og $f(n) = log n = Theta(n^0 log^1 n)$. Det er tilfælde 2, ikke et hul.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$. Er $a = 1$, er $alpha = 0$ og $n^alpha = 1$.
    + *Sammenlign.* Er $f(n) = Theta(n^alpha log^k n)$ med $k >= 0$, er det tilfælde 2.
    + *Skriv svaret.* Tilfælde 2 giver $Theta(n^alpha log^(k+1) n)$, her $Theta(log^2 n)$.
  ],
  worked: [
    Tallene her er $a = 1$, $b = #swap[$4$]$ og $f(n) = #swap[$log n$]$.

    + Skelseksponenten: $alpha = log_4 1 = 0$, så $n^alpha = 1$.
    + $f(n) = log n = Theta(n^0 log^1 n)$, altså tilfælde 2 med $k = 1$.
    + Svaret er $Theta(n^alpha log^(k+1) n) = Theta(1 dot log^2 n) = Theta(log^2 n)$.

    Svar: $T(n) = Theta(log^2 n)$. (I 3. udgave manglede $k$-leddet, og den blev svaret "kan ikke løses".)
  ],
)

#qcard(
  tag: [Master Theorem: svaret skiftede med 4. udgave],
  source: "MCQ juni 2015, Spm. 2",
  theory: <th-rec-hole>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning? $T(n) = #swap[$5$] dot T(n\/#swap[$5$]) + #swap[$n log n$]$],
  options: (
    [$T(n) = Theta(n^p)$ med $p = log_5 5$],
    [$T(n) = Theta(n^p log^2 n)$ med $p = log_5 5$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [Mulighed (b): $T(n) = Theta(n log^2 n)$ — tilfælde 2 med $k = 1$ (4. udgave). I 2015 var nøglen "kan ikke løses", fordi sættet brugte 3. udgave.],
  blueprint: [
    Samme ligning som i 2021-sættet, men her ser du, hvordan svaret flyttede sig. Før 2023 faldt $n log n$ i hullet; med 4. udgaves $k$-led er den tilfælde 2.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Er $f(n) = Theta(n^alpha log^k n)$ med $k >= 0$, er det tilfælde 2.
    + *Skriv svaret.* Tilfælde 2 giver $Theta(n^alpha log^(k+1) n)$.
  ],
  worked: [
    Tallene her er $a = #swap[$5$]$, $b = #swap[$5$]$ og $f(n) = #swap[$n log n$]$.

    + Skelseksponenten: $alpha = log_5 5 = 1$, så $n^alpha = n$.
    + $f(n) = n log n = Theta(n^1 log^1 n)$, altså tilfælde 2 med $k = 1$.
    + Svaret er $Theta(n^alpha log^(k+1) n) = Theta(n log^2 n)$.

    Svar: $T(n) = Theta(n log^2 n)$ til eksamen i år. (Den oprindelige 2015-nøgle svarede "kan ikke løses" under 3. udgave.)
  ],
)

#note(title: [Master-sætningen (Master theorem)])[Samme skabelon, fire udfald. Regn $alpha = log_b a$, og lad $f(n)$ dyste mod $n^alpha$: vinder $n^alpha$, tilfælde 1; uafgjort, et ekstra $log n$ (tilfælde 2); vinder $f$, tilfælde 3.]
