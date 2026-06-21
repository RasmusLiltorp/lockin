#import "../lib.typ": *

== Divide & Conquer

Divide-and-conquer er rekursion (recursion) som designmetode: del problemet i mindre stykker af samme slags, løs hvert rekursivt og saml svarene. Basistilfældet (base case) løses direkte.

De tre trin:

#recipe(
  title: "De tre trin",
  [*Del op.* Skær inputtet i mindre dele.],
  [*Erobr.* Løs hver del med et rekursivt kald.],
  [*Kombinér.* Lim delsvarene sammen til det fulde svar.],
)

Hvert kald deler i #swap[$a$] delproblemer af størrelse #swap[$n/b$] og bruger #swap[$f(n)$] arbejde på at dele op og kombinere. Det giver rekursionsligningen (recurrence):

#eq[$ T(n) = a thin T(n/b) + f(n) $]

Den løses med Master Theorem: sammenlign $f(n)$ med $n^(log_b a)$ og find det dominerende led. Resten af kapitlet er to algoritmer: Strassen og max-sum.

=== Sådan løser du den <th-dc-method>

#recipe(
  title: "Analysér en divide-and-conquer-algoritme",
  [Find de tre trin: hvordan splittes inputtet (del op), hvad er de rekursive kald (erobr), hvad koster det at samle svarene (kombinér).],
  [Tæl de rekursive kald #swap[$a$] og delproblemets størrelse #swap[$n/b$]. Ét kald er nok.],
  [Mål det ikke-rekursive arbejde #swap[$f(n)$] (del op plus kombinér). For matrixarbejde er det blokadditionerne, $Theta(n^2)$.],
  [Opstil rekursionsligningen og løs den med Master Theorem (se kapitlet om rekursionsligninger).],
)

#note(title: [Rekursionstræet])[Rekursionstræet (recursion tree) er kontrolflowet tegnet ud: hver knude er ét kald, roden er det øverste kald, bladene er basistilfælde. Afviklingen er dybde-først (depth-first): ned i et barn, bliv færdig, videre til næste. Kaldstakken (call stack) er stien fra rod til det kald, du er i nu.]

==== Strassen: matrixmultiplikation (matrix multiplication) <th-dc-strassen>

Naiv multiplikation af to $n times n$-matricer koster $Theta(n^3)$: hver af de $n^2$ outputtal er et prikprodukt med $n$ multiplikationer.

Del hver matrix i fire $n/2 times n/2$-blokke og gang blokvis. Den oplagte opskrift bruger 8 delmultiplikationer plus billige blokadditioner:

#eq[$ T(n) = 8 thin T(n/2) + n^2 = Theta(n^3) $]

Ingen gevinst: 8 delmultiplikationer er præcis det arbejde, den kubiske metode allerede laver.

Strassen [1969] regner de samme fire outputblokke ud med kun *7* produkter. De ekstra additioner er $Theta(n^2)$ og betyder intet. Færre rekursive kald flytter eksponenten:

#eq[$ T(n) = 7 thin T(n/2) + n^2 = Theta(n^(log_2 7)) = O(n^2.81) $]

#trap(title: [7 mod 8 produkter])[Gevinsten er 7 mod 8, fordi $log_2 7 = 2.807 < 3$. Matrixprodukter er ikke kommutative, så rækkefølgen af faktorerne i hvert produkt $P_i$ skal holdes.]

==== Max-sum: maximum subarray <th-dc-maxsum>

Find det sammenhængende stykke af et array med den største sum. Det tomme stykke tæller med og har værdien 0, så svaret bliver aldrig negativt; er alle tal negative, vinder det tomme stykke.

Tre algoritmer, hver genbruger det arbejde den forrige smed væk:

#table(
  columns: (auto, 1fr, auto),
  inset: 7pt,
  align: (left + horizon, left, center + horizon),
  stroke: 0.4pt + hair,
  table.header([*Algoritme*], [*Idé*], [*Tid*]),
  [MaxSum1], [Brute force: gensummér hvert stykke fra bunden, tre løkker], [$Theta(n^3)$],
  [MaxSum2], [For hvert startpunkt udvides den løbende sum med én addition], [$Theta(n^2)$],
  [MaxSum3 (Kadane)], [Bedste stykke der slutter i $i$ udvider det forrige], [$Theta(n)$],
)

Kadane bygger på én observation: det bedste stykke der slutter i position $i$ er enten det bedste der sluttede i $i-1$ udvidet med $A[i]$, eller det tomme stykke:

#eq[$ "maxEndingHere"_i = max("maxEndingHere"_(i-1) + A[i], thin 0) $]

#note(title: [Det tomme stykke])[Nullet er det tomme stykke; det nulstiller den løbende sum, før den når at blive negativ. Algoritmen holder kun styr på to tal, så pladsen er $O(1)$.]

#note(title: [Max-produkt via log])[Et max-produkt-problem bliver til max-sum med en logaritme. $log$ er voksende med $log(x y) = log x + log y$, så det bedste produktstykke er det bedste sumstykke af log-værdierne.]

```
MaxSum3(n)                              // Kadane, Theta(n)
  maxSoFar = 0
  maxEndingHere = 0
  for i = 0 to n - 1
    maxEndingHere = max(maxEndingHere + A[i], 0)
    maxSoFar      = max(maxSoFar, maxEndingHere)
  return maxSoFar
```

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Strassen: køretid for naiv blokmultiplikation (Master Theorem)],
  source: "Strassen slides (SE4-DMAD F26)",
  theory: <th-dc-strassen>,
  prompt: [Naiv rekursiv matrixmultiplikation deler hver $n times n$-matrix i fire blokke og kalder rekursivt med #swap[$8$] delmultiplikationer:
  #eq[$ T(n) = #swap[$8$] thin T(n\/#swap[$2$]) + n^2 $]
  Hvilken $Theta$-grænse gælder, og slår den den naive $Theta(n^3)$?],
  answer: [$T(n) = Theta(n^3)$. Ingen forbedring.],
  blueprint: [
    Aflæs $a$ og $b$ fra rekursionen og kør Master Theorem.

    + Aflæs #swap[$a$] (antal kald) og #swap[$b$] (faktor i $n\/b$) samt $f(n)$.
    + Regn skellet $alpha = log_b a$ ud og skriv $n^alpha$ op.
    + Sammenlign $f(n)$ med $n^alpha$: er $f$ polynomielt mindre, lige stor eller større?
    + Vælg den case, sammenligningen peger på, og læs $Theta$-grænsen af.
  ],
  worked: [
    Master Theorem på formen $T(n) = a thin T(n/b) + f(n)$. Jeg aflæser tallene, regner skellet $alpha = log_b a$ og sammenligner $f(n)$ med $n^alpha$.

    + Aflæs koefficienterne direkte fra rekursionen $T(n) = #swap[$8$] thin T(n\/#swap[$2$]) + n^2$:
      #eq[$ a = #swap[$8$], quad b = #swap[$2$], quad f(n) = n^2. $]

    + Regn skellet. Per definition er $alpha = log_b a$, og $log_2 8 = 3$ fordi $2^3 = 8$:
      #eq[$ alpha = log_2 8 = 3 quad ==> quad n^alpha = n^3. $]

    + Sammenlign $f(n) = n^2$ med $n^alpha = n^3$. Forholdet er
      #eq[$ f(n) / n^alpha = n^2 / n^3 = n^(-1) -> 0 quad (n -> oo), $]
      så $f$ vokser langsommere. Mere præcist er $f(n) = n^(3 - 1) = O(n^(alpha - epsilon))$ med $epsilon = 1 > 0$, altså polynomielt mindre end $n^alpha$.

    + Polynomielt mindre $f$ er case 1, og case 1 giver $T(n) = Theta(n^alpha) = Theta(n^3)$.

    Svar: $T(n) = Theta(n^3)$, det samme som den kubiske metode laver i forvejen. Otte delprodukter giver ingen gevinst.
  ],
)

#qcard(
  tag: [Strassen: køretid med 7 delprodukter (Master Theorem)],
  source: "Strassen slides (SE4-DMAD F26)",
  theory: <th-dc-strassen>,
  prompt: [Strassen regner de fire outputblokke ud med #swap[$7$] delmultiplikationer i stedet for 8:
  #eq[$ T(n) = #swap[$7$] thin T(n\/#swap[$2$]) + n^2 $]
  Hvad er køretiden?],
  answer: [$T(n) = Theta(n^(log_2 7)) = O(n^2.81)$.],
  blueprint: [
    Samme fremgang som før: aflæs tallene, find skellet, vælg case.

    + Aflæs #swap[$a$], #swap[$b$] og $f(n)$ fra rekursionen.
    + Regn $alpha = log_b a$ ud. Når $a$ ikke er en pæn potens af $b$, bliver $alpha$ et krummet tal.
    + Sammenlign $f(n)$ med $n^alpha$ og vælg den case, der passer.
    + Læs $Theta$-grænsen af, og hold den op mod den naive $Theta(n^3)$.
  ],
  worked: [
    + Her er $a = #swap[$7$]$, $b = #swap[$2$]$ og $f(n) = n^2$.

    + Skellet bliver $alpha = log_2 7 = 2.807...$, så
      #eq[$ n^alpha approx n^2.81. $]

    + Sammenlign: $f(n) = n^2$ ligger under $n^2.81$, altså $f(n) = O(n^(alpha - epsilon))$ og polynomielt mindre.

    + Det er case 1, som giver $Theta(n^alpha)$.

    Svar: $T(n) = Theta(n^(log_2 7)) = O(n^2.81)$. Det slår $Theta(n^3)$, fordi $log_2 7 < 3$.
  ],
)

#qcard(
  tag: [Max-sum: køretid og plads for Kadane (maximum subarray)],
  source: "Max-sum slides (SE4-DMAD F26)",
  theory: <th-dc-maxsum>,
  prompt: [Hvad er køretid og ekstra pladsforbrug for #swap[Kadanes algoritme (MaxSum3)] til maximum subarray-problemet?],
  answer: [$Theta(n)$ tid, $O(1)$ plads.],
  blueprint: [
    Tæl løkker for tiden og tæl gemte tal for pladsen.

    + Find ydre struktur: hvor mange #swap[indlejrede løkker] kører over inputtet? Det giver tiden.
    + Tjek arbejdet pr. iteration. Er det konstant, ganger du bare op.
    + Tæl hvor meget ekstra hukommelse algoritmen holder ud over selve inputtet. Det giver pladsen.
  ],
  worked: [
    + Kadane kører ét gennemløb, altså $n$ iterationer.

    + Hver iteration laver to `max`-opdateringer, det er $Theta(1)$ arbejde. Så tiden er $n dot Theta(1) = Theta(n)$.

    + Algoritmen gemmer kun to tal undervejs, `maxSoFar` og `maxEndingHere`, og bruger ikke noget ekstra array. Pladsen er $O(1)$.

    Til sammenligning: MaxSum1 har tre løkker og er $Theta(n^3)$, MaxSum2 har to og er $Theta(n^2)$. Hvert trin sparer en løkke ved at genbruge den forrige sum.

    Svar: $Theta(n)$ tid og $O(1)$ plads.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (Master Theorem)],
  source: "MCQ juni 2023, Spm. 2",
  theory: <th-dc-method>,
  prompt: [Hvilket af nedenstående svar gælder for følgende rekursionsligning?
  #eq[$ T(n) = #swap[$1$] thin T(n\/#swap[$2$]) + #swap[$n^(1\/2)$] $]],
  options: (
    [$T(n) = Theta(log n)$],
    [$T(n) = Theta(n^(1/2))$],
    [$T(n) = Theta(n)$],
    [$T(n) = Theta(n log n)$],
    [$T(n) = Theta(n^(3/2))$],
    [$T(n) = Theta(n^2)$],
    [Rekursionsligningen kan ikke løses med Master Theorem.],
  ),
  answer: [(b) $T(n) = Theta(n^(1/2))$.],
  blueprint: [
    Find skellet, sammenlign med $f(n)$, og husk regularitetstjekket i case 3.

    + Aflæs #swap[$a$], #swap[$b$] og #swap[$f(n)$], og regn $alpha = log_b a$ ud.
    + Sammenlign $f(n)$ med $n^alpha$. Når $f$ er polynomielt større, peger det på case 3.
    + Inden du lander på case 3, tjek regularitet: findes der $c < 1$ med $a thin f(n\/b) <= c thin f(n)$?
    + Holder den, er svaret $Theta(f(n))$.
  ],
  worked: [
    + Her er $a = #swap[$1$]$, $b = #swap[$2$]$ og $f(n) = #swap[$n^(1/2)$]$.

    + Skellet bliver $alpha = log_2 1 = 0$, så
      #eq[$ n^alpha = n^0 = 1. $]

    + Sammenlign: $f(n) = n^(0.5)$ er polynomielt større end $1$, altså $f(n) = Omega(n^(0 + epsilon))$. Det peger på case 3.

    + Regularitetstjek:
      #eq[$ a thin f(n/b) = sqrt(n/2) = sqrt(n)/sqrt(2) <= c thin sqrt(n), quad c = 1/sqrt(2) < 1. $]
      Den holder.

    Svar: $T(n) = Theta(f(n)) = Theta(n^(1/2))$, altså (b).
  ],
)
