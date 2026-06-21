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

    + Skelseksponenten: $alpha = log_b a = log_4 2$. Spørg: hvilken potens af $4$ giver $2$? Da $4^(0.5) = 2$, er $alpha = 0.5$, så skelfunktionen er $n^alpha = n^(0.5)$.
    + Sammenlign $n^alpha = n^(0.5)$ mod $f(n) = n^2$. På vækststigen står $n^2$ langt til højre for $n^(0.5)$, så $f(n)$ er klart størst.
    + Forskellen er $2 - 0.5 = 1.5$ potens, altså mindst en hel. Dermed er $f(n) = Omega(n^(alpha + epsilon))$ med fx $epsilon = 1$, og det er tilfælde 3.
    + Tjek regularitet: $a thin f(n/b) = 2 dot (n/4)^2 = 2 dot n^2/16 = 1/8 n^2 <= c thin n^2$ med $c = 1/8 < 1$. Den holder.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 2^i$ delproblemer, hver af størrelse $n/4^i$, så niveauet koster
    #eq[$ 2^i dot (n/4^i)^2 = 2^i dot n^2/16^i = n^2 dot (2/16)^i = n^2 dot (1/8)^i. $]
    Summen over alle niveauer er en aftagende geometrisk række domineret af roden:
    #eq[$ sum_(i=0)^(log_4 n) n^2 (1/8)^i <= n^2 sum_(i=0)^(infinity) (1/8)^i = n^2 dot 1/(1 - 1/8) = 8/7 n^2 = Theta(n^2). $]
    Roden ($n^2$) bærer arbejdet, hvilket er signaturen på tilfælde 3.

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

    + Skelseksponenten: $alpha = log_b a = log_2 4$. Hvilken potens af $2$ giver $4$? Da $2^2 = 4$, er $alpha = 2$, så $n^alpha = n^2$.
    + Sammenlign $n^alpha = n^2$ mod $f(n) = n^2$. De står samme sted på vækststigen, så $f(n) = Theta(n^alpha)$. Det er tilfælde 2 med $k = 0$.
    + Tilfælde 2 lægger en $log$-faktor på: $T(n) = Theta(n^alpha log^(k+1) n) = Theta(n^2 log n)$.

    Recursionstræet viser hvorfor. På niveau $i$ er der $a^i = 4^i$ delproblemer af størrelse $n/2^i$, så niveauet koster
    #eq[$ 4^i dot (n/2^i)^2 = 4^i dot n^2/4^i = n^2. $]
    Hvert niveau koster altså det samme, $n^2$. Træets dybde er $log_2 n$, så der er $log_2 n + 1$ niveauer, hver med pris $n^2$:
    #eq[$ sum_(i=0)^(log_2 n) n^2 = n^2 (log_2 n + 1) = Theta(n^2 log n). $]
    Lige arbejde på hvert niveau er kendetegnet på tilfælde 2.

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

    + Skelseksponenten: $alpha = log_b a = log_3 4$. Her går det ikke glat op: $3^1 = 3$ og $3^2 = 9$, så $alpha$ ligger mellem $1$ og $2$, præcist $alpha approx 1.26$. Skelfunktionen er $n^alpha approx n^(1.26)$.
    + Sammenlign $n^alpha approx n^(1.26)$ mod $f(n) = n = n^1$. På vækststigen ligger $n^(1.26)$ til højre for $n$, så $n^alpha$ er størst.
    + Afstanden er $1.26 - 1 = 0.26$ potens, så $f(n) = O(n^(alpha - epsilon))$ med fx $epsilon = 0.2$. Det er tilfælde 1, og svaret er $Theta(n^alpha)$.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 4^i$ delproblemer af størrelse $n/3^i$, så niveauet koster
    #eq[$ 4^i dot (n/3^i) = n dot (4/3)^i. $]
    Faktoren $4/3 > 1$ vokser, så niveauerne bliver dyrere nedad, og bladene dominerer. Summen er en voksende geometrisk række:
    #eq[$ sum_(i=0)^(log_3 n) n (4/3)^i = n dot ((4/3)^(log_3 n + 1) - 1)/(4/3 - 1) = Theta(n dot (4/3)^(log_3 n)). $]
    Brug $(4/3)^(log_3 n) = n^(log_3 (4/3)) = n^(log_3 4 - 1)$, så $n dot n^(log_3 4 - 1) = n^(log_3 4) = Theta(n^alpha)$. Bladene bærer arbejdet — signaturen på tilfælde 1.

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

    + Skelseksponenten: $alpha = log_b a = log_4 1$. Hvilken potens af $4$ giver $1$? Da $4^0 = 1$, er $alpha = 0$, så $n^alpha = n^0 = 1$.
    + Sammenlign $n^alpha = 1$ mod $f(n) = 1$. De er ens, $f(n) = Theta(n^alpha)$ med $k = 0$. Det er tilfælde 2.
    + Tilfælde 2 giver $Theta(n^alpha log^(k+1) n) = Theta(1 dot log n) = Theta(log n)$.

    Recursionstræet er her en enkelt kæde, fordi $a = 1$ kun giver ét kald per niveau. På niveau $i$ er der $a^i = 1$ delproblem af størrelse $n/4^i$, og hvert niveau koster $f = 1$:
    #eq[$ 1^i dot 1 = 1. $]
    Kæden stopper, når $n/4^i = 1$, altså ved dybde $i = log_4 n$. Summen er antallet af niveauer:
    #eq[$ sum_(i=0)^(log_4 n) 1 = log_4 n + 1 = Theta(log n). $]

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

    + Skelseksponenten: $alpha = log_b a = log_2 5$. Det går ikke glat op: $2^2 = 4$ og $2^3 = 8$, så $alpha$ ligger mellem $2$ og $3$, præcist $alpha approx 2.32$. Skelfunktionen er $n^alpha approx n^(2.32)$. Pas på rækkefølgen: det er $log_2 5$, ikke $log_5 2$.
    + Sammenlign $n^alpha approx n^(2.32)$ mod $f(n) = n^2$. På vækststigen ligger $n^(2.32)$ til højre for $n^2$, så $n^alpha$ er størst.
    + Afstanden er $2.32 - 2 = 0.32$ potens, så $f(n) = O(n^(alpha - epsilon))$ med fx $epsilon = 0.3$. Det er tilfælde 1.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 5^i$ delproblemer af størrelse $n/2^i$, så niveauet koster
    #eq[$ 5^i dot (n/2^i)^2 = 5^i dot n^2/4^i = n^2 dot (5/4)^i. $]
    Faktoren $5/4 > 1$ vokser, så bladene dominerer. Den geometriske sum bliver
    #eq[$ sum_(i=0)^(log_2 n) n^2 (5/4)^i = Theta(n^2 dot (5/4)^(log_2 n)) = Theta(n^2 dot n^(log_2 (5/4))) = Theta(n^(2 + log_2 5 - 2)) = Theta(n^(log_2 5)). $]
    Bladene bærer arbejdet — tilfælde 1.

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
    Tallene her er $a = #swap[$2$]$, $b = #swap[$5$]$ og $f(n) = #swap[$n^(1\/2)$]$, så $f(n) = n^c$ med $c = 0.5$.

    + Skelseksponenten: $alpha = log_b a = log_5 2$. Det går ikke glat op: $5^0 = 1$ og $5^1 = 5$, så $alpha$ ligger mellem $0$ og $1$, præcist $alpha approx 0.43$. Skelfunktionen er $n^alpha approx n^(0.43)$.
    + Sammenlign eksponenterne: $c = 0.5$ mod $alpha approx 0.43$. Da $c > alpha$, ligger $f(n)$ til højre for $n^alpha$, så $f(n)$ er størst.
    + $f(n) = Omega(n^(alpha + epsilon))$ med fx $epsilon = 0.05$. Det er tilfælde 3. Regularitet: $a thin f(n/b) = 2 (n/5)^(1/2) = 2/sqrt(5) thin n^(1/2) approx 0.89 thin n^(1/2) <= c thin f(n)$ med $c approx 0.89 < 1$. Den holder.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 2^i$ delproblemer af størrelse $n/5^i$, så niveauet koster
    #eq[$ 2^i dot (n/5^i)^(1/2) = 2^i dot n^(1/2)/5^(i/2) = n^(1/2) dot (2/sqrt(5))^i. $]
    Faktoren $2/sqrt(5) approx 0.89 < 1$ aftager, så roden dominerer. Den geometriske sum konvergerer:
    #eq[$ sum_(i=0)^(log_5 n) n^(1/2) (2/sqrt(5))^i <= n^(1/2) sum_(i=0)^(infinity) (0.89)^i = Theta(n^(1/2)). $]
    Roden bærer arbejdet — tilfælde 3.

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

    + Skelseksponenten: $alpha = log_b a = log_4 1$. Da $4^0 = 1$, er $alpha = 0$, så $n^alpha = n^0 = 1$.
    + Sammenlign $f(n) = n = n^1$ mod $n^alpha = 1 = n^0$. Afstanden er $1 - 0 = 1$ potens, så $f$ er en hel potens større.
    + $f(n) = Omega(n^(alpha + epsilon))$ med fx $epsilon = 1$. Det er tilfælde 3. Regularitet: $a thin f(n/b) = 1 dot (n/4) = n/4 <= c thin n$ med $c = 1/4 < 1$. Den holder.

    Recursionstræet er en enkelt kæde, da $a = 1$. På niveau $i$ er der ét delproblem af størrelse $n/4^i$, så niveauet koster $f(n/4^i) = n/4^i$:
    #eq[$ sum_(i=0)^(log_4 n) n/4^i = n sum_(i=0)^(log_4 n) (1/4)^i <= n sum_(i=0)^(infinity) (1/4)^i = n dot 1/(1 - 1/4) = 4/3 n = Theta(n). $]
    Roden ($n$) dominerer den aftagende række — tilfælde 3.

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

    + Skelseksponenten: $alpha = log_b a = log_4 3$. Det går ikke glat op: $4^0 = 1$ og $4^1 = 4$, så $alpha$ ligger mellem $0$ og $1$, præcist $alpha approx 0.79$. Skelfunktionen er $n^alpha approx n^(0.79)$.
    + Sammenlign $f(n) = n = n^1$ mod $n^alpha approx n^(0.79)$. Da $1 > 0.79$, ligger $f(n)$ til højre, så $f$ er størst.
    + Afstanden er $1 - 0.79 = 0.21$ potens, så $f(n) = Omega(n^(alpha + epsilon))$ med fx $epsilon = 0.2$. Det er tilfælde 3. Regularitet: $a thin f(n/b) = 3 dot (n/4) = 3/4 n <= c thin n$ med $c = 3/4 < 1$. Den holder.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 3^i$ delproblemer af størrelse $n/4^i$, så niveauet koster
    #eq[$ 3^i dot (n/4^i) = n dot (3/4)^i. $]
    Faktoren $3/4 < 1$ aftager, så roden dominerer:
    #eq[$ sum_(i=0)^(log_4 n) n (3/4)^i <= n sum_(i=0)^(infinity) (3/4)^i = n dot 1/(1 - 3/4) = 4n = Theta(n). $]
    Roden bærer arbejdet — tilfælde 3.

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
    Tallene her er $a = #swap[$3$]$, $b = #swap[$4$]$ og $f(n) = #swap[$n^(3\/4)$]$, så $f(n) = n^c$ med $c = 0.75$.

    + Skelseksponenten: $alpha = log_b a = log_4 3$. Det går ikke glat op; $alpha$ ligger mellem $log_4 1 = 0$ og $log_4 4 = 1$, præcist $alpha approx 0.79$. Skelfunktionen er $n^alpha approx n^(0.79)$.
    + Sammenlign eksponenterne: $c = 0.75$ mod $alpha approx 0.79$. Da $c < alpha$, ligger $n^alpha$ til højre — $n^alpha$ er størst, om end snævert.
    + Afstanden er $0.79 - 0.75 = 0.04$ potens, så $f(n) = O(n^(alpha - epsilon))$ med fx $epsilon = 0.03$. Det er tilfælde 1.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 3^i$ delproblemer af størrelse $n/4^i$, så niveauet koster
    #eq[$ 3^i dot (n/4^i)^(3/4) = 3^i dot n^(3/4)/4^(3i/4) = n^(3/4) dot (3/4^(3/4))^i. $]
    Da $4^(3/4) = 2.83$, er faktoren $3/2.83 approx 1.06 > 1$, så niveauerne vokser nedad og bladene dominerer:
    #eq[$ sum_(i=0)^(log_4 n) n^(3/4) (1.06)^i = Theta(n^(3/4) dot (1.06)^(log_4 n)) = Theta(n^(log_4 3)). $]
    (Roden ville give $n^(3/4) = n^(0.75)$, men bladene giver den større $n^(0.79)$, så $n^alpha$ vinder — tilfælde 1.)

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
    Står der $3n\/4$ som argument, er $b = 4\/3$, fordi $n/b = n dot 3/4 = 3n\/4$. Tallene er $a = 1$, $b = #swap[$4\/3$]$ og $f(n) = #swap[$n$]$.

    + Skelseksponenten: $alpha = log_b a = log_(4/3) 1$. Da $(4/3)^0 = 1$, er $alpha = 0$, så $n^alpha = n^0 = 1$.
    + Sammenlign $f(n) = n = n^1$ mod $n^alpha = 1 = n^0$. Afstanden er $1$ hel potens, så $f$ er størst.
    + $f(n) = Omega(n^(alpha + epsilon))$ med fx $epsilon = 1$. Det er tilfælde 3. Regularitet: $a thin f(n/b) = 1 dot (3n/4) = (3/4) f(n)$ med $c = 3/4 < 1$. Den holder.

    Recursionstræet er en kæde ($a = 1$). På niveau $i$ er der ét delproblem af størrelse $(3/4)^i n$, så niveauet koster $(3/4)^i n$:
    #eq[$ sum_(i=0)^(log_(4/3) n) (3/4)^i n = n sum_(i=0)^(infinity) (3/4)^i = n dot 1/(1 - 3/4) = 4n = Theta(n). $]
    Roden dominerer den aftagende række — tilfælde 3.

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

    + Skelseksponenten: $alpha = log_b a = log_3 3 = 1$ (et grundtal opløftet i $1$ giver sig selv), så $n^alpha = n$.
    + Sammenlign $n^alpha = n$ mod $f(n) = n$. De står samme sted, $f(n) = Theta(n^alpha)$ med $k = 0$. Det er tilfælde 2.
    + Tilfælde 2 giver $Theta(n^alpha log^(k+1) n) = Theta(n log n)$.

    Recursionstræet viser det direkte. På niveau $i$ er der $a^i = 3^i$ delproblemer af størrelse $n/3^i$, så niveauet koster
    #eq[$ 3^i dot (n/3^i) = n. $]
    Hvert niveau koster $n$. Dybden er $log_3 n$, så der er $log_3 n + 1$ niveauer:
    #eq[$ sum_(i=0)^(log_3 n) n = n (log_3 n + 1) = Theta(n log n). $]
    Lige arbejde på hvert niveau er kendetegnet på tilfælde 2.

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

    + Skelseksponenten: $alpha = log_b a = log_2 3$. Det går ikke glat op: $2^1 = 2$ og $2^2 = 4$, så $alpha$ ligger mellem $1$ og $2$, præcist $alpha approx 1.58$. Skelfunktionen er $n^alpha approx n^(1.58)$.
    + Sammenlign $f(n) = n^2$ mod $n^alpha approx n^(1.58)$. Da $2 > 1.58$, ligger $f(n)$ til højre, så $f$ er størst med ca. en halv potens i overskud.
    + Afstanden er $2 - 1.58 = 0.42$ potens, så $f(n) = Omega(n^(alpha + epsilon))$ med fx $epsilon = 0.4$. Det er tilfælde 3. Regularitet: $a thin f(n/b) = 3 dot (n/2)^2 = 3 dot n^2/4 = 3/4 n^2 <= c thin n^2$ med $c = 3/4 < 1$. Den holder.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 3^i$ delproblemer af størrelse $n/2^i$, så niveauet koster
    #eq[$ 3^i dot (n/2^i)^2 = 3^i dot n^2/4^i = n^2 dot (3/4)^i. $]
    Faktoren $3/4 < 1$ aftager, så roden dominerer:
    #eq[$ sum_(i=0)^(log_2 n) n^2 (3/4)^i <= n^2 sum_(i=0)^(infinity) (3/4)^i = n^2 dot 4 = Theta(n^2). $]
    Roden bærer arbejdet — tilfælde 3.

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
    Tallene her er $a = #swap[$9$]$, $b = #swap[$3$]$ og $f(n) = #swap[$n^(1\/2)$]$, så $f(n) = n^c$ med $c = 0.5$.

    + Skelseksponenten: $alpha = log_b a = log_3 9$. Da $3^2 = 9$, er $alpha = 2$, så $n^alpha = n^2$.
    + Sammenlign $c = 0.5$ mod $alpha = 2$. Da $c < alpha$, ligger $n^alpha$ langt til højre — $n^alpha$ vinder klart.
    + Afstanden er $2 - 0.5 = 1.5$ potens, så $f(n) = O(n^(alpha - epsilon))$ med fx $epsilon = 1$. Det er tilfælde 1.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 9^i$ delproblemer af størrelse $n/3^i$, så niveauet koster
    #eq[$ 9^i dot (n/3^i)^(1/2) = 9^i dot n^(1/2)/3^(i/2) = n^(1/2) dot (9/sqrt(3))^i. $]
    Faktoren $9/sqrt(3) approx 5.2 > 1$ vokser kraftigt, så bladene dominerer:
    #eq[$ sum_(i=0)^(log_3 n) n^(1/2) (9/sqrt(3))^i = Theta(n^(1/2) dot (9/sqrt(3))^(log_3 n)) = Theta(n^2). $]
    Bladene bærer arbejdet — tilfælde 1.

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

    + Skelseksponenten: $alpha = log_b a = log_2 4$. Da $2^2 = 4$, er $alpha = 2$, så $n^alpha = n^2$.
    + Sammenlign $n^alpha = n^2$ mod $f(n) = n^2$. De står samme sted, $f(n) = Theta(n^alpha)$ med $k = 0$. Det er tilfælde 2.
    + Tilfælde 2 giver $Theta(n^alpha log^(k+1) n) = Theta(n^2 log n)$.

    Recursionstræet viser det. På niveau $i$ er der $a^i = 4^i$ delproblemer af størrelse $n/2^i$, så niveauet koster
    #eq[$ 4^i dot (n/2^i)^2 = 4^i dot n^2/4^i = n^2. $]
    Hvert niveau koster $n^2$. Dybden er $log_2 n$, så
    #eq[$ sum_(i=0)^(log_2 n) n^2 = n^2 (log_2 n + 1) = Theta(n^2 log n). $]
    Lige arbejde på hvert niveau — tilfælde 2.

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

    + Skelseksponenten: $alpha = log_b a = log_3 2$. Det går ikke glat op: $3^0 = 1$ og $3^1 = 3$, så $alpha$ ligger mellem $0$ og $1$, præcist $alpha approx 0.63$. Skelfunktionen er $n^alpha approx n^(0.63)$.
    + Sammenlign $f(n) = n log n$ mod $n^alpha approx n^(0.63)$. Selv om $f$ bærer en $log$-faktor, dominerer dens $n^1$-led: afstanden i den rene potens er $1 - 0.63 = 0.37$, altså en hel potens, og $log$-faktoren gør kun $f$ endnu større.
    + Vælg fx $epsilon = 0.3$: så er $n log n = Omega(n^(0.63 + 0.3)) = Omega(n^(0.93))$, fordi $n^1 log n$ til sidst slår $n^(0.93)$. Det er tilfælde 3. Regularitet: $a thin f(n/b) = 2 (n/3) log(n/3) <= c thin n log n$ med $c = 2/3 < 1$ for store $n$. Den holder.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 2^i$ delproblemer af størrelse $n/3^i$, så niveauet koster
    #eq[$ 2^i dot (n/3^i) log(n/3^i) = n (2/3)^i log(n/3^i) <= n (2/3)^i log n. $]
    Faktoren $2/3 < 1$ aftager, så roden dominerer:
    #eq[$ sum_(i=0)^(log_3 n) n (2/3)^i log n <= n log n sum_(i=0)^(infinity) (2/3)^i = n log n dot 3 = Theta(n log n). $]
    Roden bærer arbejdet — tilfælde 3.

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
    Tallene her er $a = #swap[$2$]$, $b = #swap[$2$]$ og $f(n) = #swap[$n^(1\/2)$]$, så $f(n) = n^c$ med $c = 0.5$.

    + Skelseksponenten: $alpha = log_b a = log_2 2 = 1$, så $n^alpha = n$.
    + Sammenlign $c = 0.5$ mod $alpha = 1$. Da $c < alpha$, ligger $n^alpha$ til højre, så $n^alpha$ er størst med en halv potens.
    + $f(n) = O(n^(alpha - epsilon))$ med fx $epsilon = 0.4$. Det er tilfælde 1.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 2^i$ delproblemer af størrelse $n/2^i$, så niveauet koster
    #eq[$ 2^i dot (n/2^i)^(1/2) = 2^i dot n^(1/2)/2^(i/2) = n^(1/2) dot 2^(i/2) = n^(1/2) (sqrt(2))^i. $]
    Faktoren $sqrt(2) > 1$ vokser, så bladene dominerer:
    #eq[$ sum_(i=0)^(log_2 n) n^(1/2) (sqrt(2))^i = Theta(n^(1/2) dot (sqrt(2))^(log_2 n)) = Theta(n^(1/2) dot n^(1/2)) = Theta(n). $]
    (Brug $(sqrt(2))^(log_2 n) = 2^((1/2) log_2 n) = n^(1/2)$.) Bladene bærer arbejdet — tilfælde 1.

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
    Tallene her er $a = 1$, $b = #swap[$2$]$ og $f(n) = #swap[$n^(1\/2)$]$, så $f(n) = n^c$ med $c = 0.5$.

    + Skelseksponenten: $alpha = log_b a = log_2 1$. Da $2^0 = 1$, er $alpha = 0$, så $n^alpha = n^0 = 1$.
    + Sammenlign $c = 0.5$ mod $alpha = 0$. Da $c > alpha$, ligger $f(n)$ til højre — $f$ er $0.5$ potens større.
    + $f(n) = Omega(n^(alpha + epsilon))$ med fx $epsilon = 0.5$. Det er tilfælde 3. Regularitet: $a thin f(n/b) = 1 dot sqrt(n/2) = sqrt(n)/sqrt(2) <= c thin sqrt(n)$ med $c = 1/sqrt(2) approx 0.71 < 1$. Den holder.

    Recursionstræet er en kæde ($a = 1$). På niveau $i$ er der ét delproblem af størrelse $n/2^i$, så niveauet koster $(n/2^i)^(1/2) = n^(1/2) (1/sqrt(2))^i$:
    #eq[$ sum_(i=0)^(log_2 n) n^(1/2) (1/sqrt(2))^i <= n^(1/2) sum_(i=0)^(infinity) (1/sqrt(2))^i = n^(1/2) dot 1/(1 - 1/sqrt(2)) = Theta(n^(1/2)). $]
    Roden dominerer den aftagende række — tilfælde 3.

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
    Tallene her er $a = #swap[$2$]$, $b = #swap[$2$]$ og $f(n) = #swap[$1\/2$]$, altså en konstant $f(n) = Theta(1) = Theta(n^0)$.

    + Skelseksponenten: $alpha = log_b a = log_2 2 = 1$, så $n^alpha = n$.
    + Sammenlign konstanten ($n^0$) mod $n^alpha = n^1$. Afstanden er $1 - 0 = 1$ hel potens, så $n^alpha$ er størst.
    + $f(n) = O(n^(alpha - epsilon))$ med fx $epsilon = 0.5$. Det er tilfælde 1.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 2^i$ delproblemer, hver med konstant pris $1/2$, så niveauet koster
    #eq[$ 2^i dot 1/2 = 2^(i-1). $]
    Niveauerne fordobles nedad, så bladene dominerer. Dybden er $log_2 n$, og der er $2^(log_2 n) = n$ blade:
    #eq[$ sum_(i=0)^(log_2 n) 2^(i-1) = 1/2 (2^(log_2 n + 1) - 1) = 1/2 (2n - 1) = Theta(n). $]
    Bladene bærer arbejdet — tilfælde 1.

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
    Tallene her er $a = 1$, $b = #swap[$2$]$ og $f(n) = #swap[$1\/2$]$, altså en konstant $f(n) = Theta(1) = Theta(n^0)$.

    + Skelseksponenten: $alpha = log_b a = log_2 1$. Da $2^0 = 1$, er $alpha = 0$, så $n^alpha = n^0 = 1$.
    + Sammenlign $f(n) = Theta(n^0)$ mod $n^alpha = n^0$. De står samme sted, $f(n) = Theta(n^alpha)$ med $k = 0$. Det er tilfælde 2.
    + Tilfælde 2 giver $Theta(n^alpha log^(k+1) n) = Theta(1 dot log n) = Theta(log n)$.

    Recursionstræet er en kæde ($a = 1$). På niveau $i$ er der ét delproblem med konstant pris $1/2$:
    #eq[$ sum_(i=0)^(log_2 n) 1/2 = 1/2 (log_2 n + 1) = Theta(log n). $]
    Lige (konstant) arbejde på hvert niveau, ganget med antallet af niveauer — tilfælde 2.

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

    + Skelseksponenten: $alpha = log_b a = log_3 4$. Det går ikke glat op: $3^1 = 3$ og $3^2 = 9$, så $alpha$ ligger mellem $1$ og $2$, præcist $alpha approx 1.26$. Skelfunktionen er $n^alpha approx n^(1.26)$.
    + Sammenlign $f(n) = n log n$ mod $n^alpha approx n^(1.26)$. Den rene potens i $f$ er $n^1$, og afstanden op til $n^(1.26)$ er $0.26$ — en hel potens. En $log$-faktor er svagere end ethvert $n^epsilon$, så $log n$ flytter ikke $f$ op forbi $n^(1.26)$.
    + Vælg fx $epsilon = 0.2$: så er $n log n = O(n^(1.26 - 0.2)) = O(n^(1.06))$, fordi $n^(1.06)$ til sidst slår $n log n$. Det er tilfælde 1.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 4^i$ delproblemer af størrelse $n/3^i$, så niveauet koster
    #eq[$ 4^i dot (n/3^i) log(n/3^i) <= n (4/3)^i log n. $]
    Faktoren $4/3 > 1$ vokser, så bladene dominerer. Bladantallet er $4^(log_3 n) = n^(log_3 4)$, og summen bliver
    #eq[$ sum_(i=0)^(log_3 n) n (4/3)^i log n = Theta(n log n dot (4/3)^(log_3 n)) = Theta(n^(log_3 4)). $]
    (Bladleddet $n^(log_3 4) approx n^(1.26)$ slår rodens $n log n$, så $log$-faktoren forsvinder.) Tilfælde 1.

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

    + Skelseksponenten: $alpha = log_b a = log_5 5 = 1$, så $n^alpha = n$.
    + Skriv $f$ på formen $n^alpha log^k n$: $f(n) = n log n = n^1 log^1 n = Theta(n^alpha log^1 n)$, altså $k = 1 >= 0$. Den rene potens i $f$ matcher $n^alpha = n$ præcist, så det er tilfælde 2 — ikke tilfælde 3 (der kræver en hel ekstra potens, ikke kun et $log$).
    + Tilfælde 2 lægger ét $log$ oveni: $Theta(n^alpha log^(k+1) n) = Theta(n log^2 n)$.

    Recursionstræet viser hvorfor. På niveau $i$ er der $a^i = 5^i$ delproblemer af størrelse $n/5^i$, så niveauet koster
    #eq[$ 5^i dot (n/5^i) log(n/5^i) = n log(n/5^i) = n (log n - i log 5). $]
    Summen over alle $log_5 n$ niveauer er
    #eq[$ sum_(i=0)^(log_5 n) n (log n - i log 5) = n ( (log_5 n + 1) log n - log 5 dot sum_(i=0)^(log_5 n) i ) = Theta(n log^2 n), $]
    fordi $sum i = Theta((log_5 n)^2)$ og $log_5 n = Theta(log n)$. Hver $log$-faktor i $f$ giver én ekstra $log$ i svaret.

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

    + Delproblemet er $n - 2$ (input minus en konstant), ikke $n/b$. Master Theorem kræver delform $T(n/b)$ med et fast $b > 1$ — og der findes intet $b$, så $b dot (n-2) = n$.
    + Konklusion: ligningen er på subtraktiv form og falder uden for Master Theorem.
    + Bekræft med en udrulning, at væksten er eksponentiel og ikke kan ramme noget $Theta(n^p)$. Rul $T(n) = 2 T(n-2) + n$ ned i to-skridt:
    #eq[$ T(n) = 2 T(n-2) + n = 2(2 T(n-4) + (n-2)) + n = 4 T(n-4) + 2(n-2) + n. $]
    Efter $k$ skridt: $T(n) = 2^k T(n - 2k) + sum_(j=0)^(k-1) 2^j (n - 2j)$. Bunden nås ved $k = n/2$, hvor faktoren foran er $2^(n/2)$.
    + Det homogene led $2^(n/2) T(0)$ vokser eksponentielt, så $T(n) = Theta(2^(n/2))$ — ikke polynomielt. Derfor passer hverken (a) eller (b).

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
    Argumentet her er #swap[$n^(1\/4)$], altså en rod af $n$, ikke $n/b$. Det er ikke direkte på Master-form, så vi substituerer.

    + Sæt $n = 2^m$, dvs. $m = log_2 n$, og definér $S(m) = T(2^m)$. Så bliver $T(n^(1\/4)) = T(2^(m/4)) = S(m/4)$, og drivledet $n^(3\/4) = (2^m)^(3/4) = 2^((3\/4) m)$.
    + Indsat: $S(m) = 3 thin S(m/4) + 2^((3\/4) m)$. Nu er argumentet $m/4$ — lineært i $m$ — så formen $a thin S(m/b) + g(m)$ med $a = 3$, $b = 4$ er på plads.
    + Skelseksponenten i $m$-verdenen er $log_b a = log_4 3 approx 0.79$, så skelfunktionen er $m^(0.79)$. Standard-Master Theorem kræver, at drivledet $g(m)$ er polynomielt i $m$, fx $Theta(m^c)$.
    + Men $g(m) = 2^((3\/4) m)$ er eksponentielt i $m$, ikke polynomielt — det ligger uendeligt langt til højre for ethvert $m^c$ på vækststigen. Standard-Master Theorem dækker ikke et eksponentielt drivled, så den gælder ikke.

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

    + Skelseksponenten: $alpha = log_b a = log_4 1$. Da $4^0 = 1$, er $alpha = 0$, så $n^alpha = n^0 = 1$.
    + Skriv $f$ på formen $n^alpha log^k n$: $f(n) = log n = n^0 log^1 n = Theta(n^alpha log^1 n)$, altså $k = 1 >= 0$. Den rene potens matcher $n^alpha = 1$, så det er tilfælde 2.
    + Tilfælde 2 lægger ét $log$ oveni: $Theta(n^alpha log^(k+1) n) = Theta(1 dot log^2 n) = Theta(log^2 n)$.

    Recursionstræet er en kæde ($a = 1$). På niveau $i$ er der ét delproblem af størrelse $n/4^i$, så niveauet koster $log(n/4^i) = log n - i log 4$:
    #eq[$ sum_(i=0)^(log_4 n) (log n - i log 4) = (log_4 n + 1) log n - log 4 dot sum_(i=0)^(log_4 n) i = Theta(log^2 n), $]
    fordi både $log_4 n$ og $sum i = Theta((log_4 n)^2)$ er $Theta(log^2 n)$. En $log$ i $f$ giver én ekstra $log$ i svaret.

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

    + Skelseksponenten: $alpha = log_b a = log_5 5 = 1$, så $n^alpha = n$.
    + Skriv $f$ på formen $n^alpha log^k n$: $f(n) = n log n = n^1 log^1 n = Theta(n^alpha log^1 n)$, altså $k = 1 >= 0$. Den rene potens matcher $n^alpha = n$, så det er tilfælde 2 (ikke 3 — der ville kræve en hel ekstra potens, ikke kun et $log$).
    + Tilfælde 2 lægger ét $log$ oveni: $Theta(n^alpha log^(k+1) n) = Theta(n log^2 n)$.

    Recursionstræet bekræfter det. På niveau $i$ er der $a^i = 5^i$ delproblemer af størrelse $n/5^i$, så niveauet koster
    #eq[$ 5^i dot (n/5^i) log(n/5^i) = n (log n - i log 5). $]
    Summen over alle $log_5 n$ niveauer er
    #eq[$ sum_(i=0)^(log_5 n) n (log n - i log 5) = Theta(n log^2 n), $]
    da $sum i = Theta((log_5 n)^2)$ og $log_5 n = Theta(log n)$.

    Svar: $T(n) = Theta(n log^2 n)$ til eksamen i år. (Den oprindelige 2015-nøgle svarede "kan ikke løses" under 3. udgave.)
  ],
)

#note(title: [Master-sætningen (Master theorem)])[Samme skabelon, fire udfald. Regn $alpha = log_b a$, og lad $f(n)$ dyste mod $n^alpha$: vinder $n^alpha$, tilfælde 1; uafgjort, et ekstra $log n$ (tilfælde 2); vinder $f$, tilfælde 3.]
