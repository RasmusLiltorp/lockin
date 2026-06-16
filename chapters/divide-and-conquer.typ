#import "../lib.typ": *

== Divide & Conquer

Divide-and-conquer er rekursion som designmetode: del problemet i mindre stykker af samme slags, løs hvert rekursivt og saml svarene. Basistilfældet løses direkte.

De tre trin:

#recipe(
  title: "De tre trin",
  [*Del op.* Skær inputtet i mindre dele.],
  [*Erobr.* Løs hver del med et rekursivt kald.],
  [*Kombinér.* Lim delsvarene sammen til det fulde svar.],
)

Hvert kald deler i #swap[$a$] delproblemer af størrelse #swap[$n/b$] og bruger #swap[$f(n)$] arbejde på at dele op og kombinere. Det giver rekursionsligningen:

#eq[$ T(n) = a thin T(n/b) + f(n) $]

Den løses med Master Theorem: sammenlign $f(n)$ med $n^(log_b a)$ og find det dominerende led. Resten af kapitlet er to algoritmer: Strassen og max-sum.

=== Sådan løser du den

#recipe(
  title: "Analysér en divide-and-conquer-algoritme",
  [Find de tre trin: hvordan splittes inputtet (del op), hvad er de rekursive kald (erobr), hvad koster det at samle svarene (kombinér).],
  [Tæl de rekursive kald #swap[$a$] og delproblemets størrelse #swap[$n/b$]. Ét kald er nok.],
  [Mål det ikke-rekursive arbejde #swap[$f(n)$] (del op plus kombinér). For matrixarbejde er det blokadditionerne, $Theta(n^2)$.],
  [Opstil rekursionsligningen og løs den med Master Theorem (se kapitlet om rekursionsligninger).],
)

#note(title: [Rekursionstræet])[Rekursionstræet er kontrolflowet tegnet ud: hver knude er ét kald, roden er det øverste kald, bladene er basistilfælde. Afviklingen er dybde-først: ned i et barn, bliv færdig, videre til næste. Kaldstakken er stien fra rod til det kald, du er i nu.]

==== Strassen: matrixmultiplikation

Naiv multiplikation af to $n times n$-matricer koster $Theta(n^3)$: hver af de $n^2$ outputtal er et prikprodukt med $n$ multiplikationer.

Del hver matrix i fire $n/2 times n/2$-blokke og gang blokvis. Den oplagte opskrift bruger 8 delmultiplikationer plus billige blokadditioner:

#eq[$ T(n) = 8 thin T(n/2) + n^2 = Theta(n^3) $]

Ingen gevinst: 8 delmultiplikationer er præcis det arbejde, den kubiske metode allerede laver.

Strassen [1969] regner de samme fire outputblokke ud med kun *7* produkter. De ekstra additioner er $Theta(n^2)$ og betyder intet. Færre rekursive kald flytter eksponenten:

#eq[$ T(n) = 7 thin T(n/2) + n^2 = Theta(n^(log_2 7)) = O(n^2.81) $]

#trap(title: [7 mod 8 produkter])[Gevinsten er 7 mod 8, fordi $log_2 7 = 2.807 < 3$. Matrixprodukter er ikke kommutative, så rækkefølgen af faktorerne i hvert produkt $P_i$ skal holdes.]

==== Max-sum: maximum subarray

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
  tag: [Strassen: køretid for naiv blokmultiplikation],
  source: "Strassen slides (SE4-DMAD F26)",
  prompt: [Naiv rekursiv matrixmultiplikation deler hver $n times n$-matrix i fire blokke og kalder rekursivt med #swap[$8$] delmultiplikationer:
  #eq[$ T(n) = #swap[$8$] thin T(n\/#swap[$2$]) + n^2 $]
  Hvilken $Theta$-grænse gælder, og slår den den naive $Theta(n^3)$?],
  answer: [$T(n) = Theta(n^3)$. Ingen forbedring.],
  worked: [$a = #swap[$8$]$, $b = #swap[$2$]$, $f(n) = n^2$. Skellet er $alpha = log_2 8 = 3$, så
  #eq[$ n^alpha = n^3. $]
  Her er $f(n) = n^2 = O(n^(3 - epsilon))$ med $epsilon = 1$, polynomielt mindre. Master case 1 giver $T(n) = Theta(n^3)$, samme som den kubiske metode.],
)

#qcard(
  tag: [Strassen: køretid med 7 delprodukter],
  source: "Strassen slides (SE4-DMAD F26)",
  prompt: [Strassen regner de fire outputblokke ud med #swap[$7$] delmultiplikationer i stedet for 8:
  #eq[$ T(n) = #swap[$7$] thin T(n\/#swap[$2$]) + n^2 $]
  Hvad er køretiden?],
  answer: [$T(n) = Theta(n^(log_2 7)) = O(n^2.81)$.],
  worked: [$a = #swap[$7$]$, $b = #swap[$2$]$, $f(n) = n^2$. Skellet er $alpha = log_2 7 = 2.807...$, så
  #eq[$ n^alpha approx n^2.81. $]
  Her er $f(n) = n^2 = O(n^(alpha - epsilon))$, polynomielt mindre, så Master case 1 giver $T(n) = Theta(n^alpha) = O(n^2.81)$. Det slår $Theta(n^3)$ fordi $log_2 7 < 3$.],
)

#qcard(
  tag: [Max-sum: køretid og plads for Kadane],
  source: "Max-sum slides (SE4-DMAD F26)",
  prompt: [Hvad er køretid og ekstra pladsforbrug for #swap[Kadanes algoritme (MaxSum3)] til maximum subarray-problemet?],
  answer: [$Theta(n)$ tid, $O(1)$ plads.],
  worked: [Ét gennemløb med $n$ iterationer á $Theta(1)$ arbejde (to `max`-opdateringer) giver $Theta(n)$. Algoritmen holder kun to tal (`maxSoFar`, `maxEndingHere`) uden ekstra array, så pladsen er $O(1)$. MaxSum1 er $Theta(n^3)$ (tre løkker), MaxSum2 er $Theta(n^2)$ (to løkker); hvert spring fjerner én løkke ved at genbruge den forrige sum.],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning],
  source: "MCQ juni 2023, Spm. 2",
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
  worked: [$a = #swap[$1$]$, $b = #swap[$2$]$, $f(n) = #swap[$n^(1/2)$]$. Skellet er $alpha = log_2 1 = 0$, så
  #eq[$ n^alpha = n^0 = 1. $]
  Her er $f(n) = n^(0.5)$ polynomielt større end $1$, altså $f(n) = Omega(n^(0 + epsilon))$, så Master case 3. Tjek regularitet:
  #eq[$ a thin f(n/b) = sqrt(n/2) = sqrt(n)/sqrt(2) <= c thin sqrt(n), quad c = 1/sqrt(2) < 1. $]
  Den holder, så $T(n) = Theta(f(n)) = Theta(n^(1/2))$.],
)
