#import "../lib.typ": *

=== Rekursionsligninger med Master Theorem

De skriftlige eksamener åbner næsten altid med en rekursionsopgave (recurrence). Enten skal du løse en eller flere ligninger på formen $T(n) = a thin T(n/b) + f(n)$ med Master Theorem, eller du skal klassificere en håndfuld efter tilfælde og afgøre, hvilke der falder uden for sætningen. Tre tal styrer alt, $a$, $b$ og $f(n)$.

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "DM507 juni 2014, Opg. 1 (8%)",
  theory: <th-rec-method>,
  prompt: [Giv løsningen til hver rekursionsligning:
    + #swap[$T(n) = 2 dot T(n\/3) + n$]
    + #swap[$T(n) = 32 dot T(n\/4) + n^(2.5)$]
  ],
  answer: [(i) $T(n) = Theta(n)$ — tilfælde 3. (ii) $T(n) = Theta(n^(2.5) log n)$ — tilfælde 2.],
  blueprint: [
    Samme fremgangsmåde for hver ligning, uanset om svaret ender i tilfælde 1, 2 eller 3.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent (critical exponent).* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign.* Skriv $f(n) = n^c$ og hold $c$ op mod $alpha$ på vækststigen.
    + *Vælg tilfælde.* $c < alpha$ giver tilfælde 1 ($Theta(n^alpha)$), $c = alpha$ giver tilfælde 2 ($Theta(n^alpha log n)$), $c > alpha$ giver tilfælde 3 ($Theta(f(n))$).
  ],
  worked: [
    + (i) $a = 2$, $b = 3$, $f(n) = n$. Skelseksponenten: $alpha = log_3 2 approx 0.63$. Her er $c = 1 > 0.63$ med en hel potens, så $f$ vinder. Tilfælde 3. Regularitet (regularity condition): $2(n/3) = (2/3)n <= c thin n$ med $c = 2/3 < 1$. Svar: $T(n) = Theta(n)$.
    + (ii) $a = 32$, $b = 4$, $f(n) = n^(2.5)$. Skelseksponenten: $alpha = log_4 32 = 5/2 = 2.5$. Her er $c = 2.5 = alpha$, så $f(n) = Theta(n^alpha)$. Tilfælde 2. Svar: $T(n) = Theta(n^(2.5) log n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "DM507 juni 2013, Opg. 1 (10%)",
  theory: <th-rec-method>,
  prompt: [Giv løsningen til hver rekursionsligning:
    + #swap[$T(n) = 8 dot T(n\/3) + n^2$]
    + #swap[$T(n) = 9 dot T(n\/3) + n^2$]
    + #swap[$T(n) = 10 dot T(n\/3) + n^2$]
  ],
  answer: [(i) $Theta(n^2)$ — tilfælde 3. (ii) $Theta(n^2 log n)$ — tilfælde 2. (iii) $Theta(n^(log_3 10))$ — tilfælde 1.],
  blueprint: [
    Tre ligninger med samme $b$ og samme $f(n)$. Kun $a$ skifter, så det er $alpha = log_3 a$, der afgør tilfældet, holdt op mod $c = 2$.

    + *Aflæs.* Her er #swap[$b = 3$] og #swap[$f(n) = n^2$] fælles, så $c = 2$.
    + *Skelseksponent.* Regn $alpha = log_3 a$ for hver $a$.
    + *Sammenlign.* Hold $c = 2$ op mod $alpha$.
    + *Vælg tilfælde.* $c > alpha$: tilfælde 3. $c = alpha$: tilfælde 2. $c < alpha$: tilfælde 1.
  ],
  worked: [
    Her er $c = 2$ hele vejen.

    + (i) $a = 8$: $alpha = log_3 8 approx 1.89 < 2$. $f$ vinder, tilfælde 3. $T(n) = Theta(n^2)$.
    + (ii) $a = 9$: $alpha = log_3 9 = 2 = c$. Uafgjort, tilfælde 2. $T(n) = Theta(n^2 log n)$.
    + (iii) $a = 10$: $alpha = log_3 10 approx 2.10 > 2$. $n^alpha$ vinder, tilfælde 1. $T(n) = Theta(n^(log_3 10))$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "DM02 jan 2006, Opg. 1c (7%)",
  theory: <th-rec-method>,
  prompt: [Giv den asymptotiske løsning til $#swap[$T(n) = 3 T(n\/3) + n^2$]$.],
  answer: [$T(n) = Theta(n^2)$ — tilfælde 3.],
  blueprint: [
    Én ligning, samme tre skridt.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$].
    + *Skelseksponent.* Regn $alpha = log_b a$.
    + *Sammenlign og vælg.* Vinder $f(n)$ med en hel potens, er det tilfælde 3, og svaret er $Theta(f(n))$.
  ],
  worked: [
    + $a = 3$, $b = 3$, $f(n) = n^2$. Skelseksponenten: $alpha = log_3 3 = 1$, så $n^alpha = n$.
    + Sammenlign $n^2$ mod $n$. $f$ er en hel potens større, $f(n) = Omega(n^(1 + 1))$. Tilfælde 3.
    + Regularitet: $3(n/3)^2 = n^2\/3 <= c thin n^2$ med $c = 1/3 < 1$. Den holder.

    Svar: $T(n) = Theta(n^2)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "DM02 jan 2005, Opg. 2b (15%)",
  theory: <th-rec-method>,
  prompt: [En rekursiv procedure halverer argumentet hvert kald og bruger konstant arbejde udenom. Opstil rekursionsligningen for køretiden $T(a)$ og løs den. Drivledet (driving term) er #swap[$Theta(1)$], og argumentet skrumper fra $a$ til #swap[$floor(a\/2)$].],
  answer: [$T(a) = T(floor(a\/2)) + Theta(1)$, som løser til $T(a) = Theta(log a)$ — tilfælde 2.],
  blueprint: [
    Først opstil ligningen, så løs med Master Theorem.

    + *Tæl arbejdet udenom.* Arbejdet uden for det rekursive kald er #swap[$Theta(1)$], så $f = Theta(1)$.
    + *Opstil.* Med ét kald på det halve argument: $T(a) = T(floor(a\/2)) + Theta(1)$, altså $a = 1$, $b = 2$.
    + *Skelseksponent.* $alpha = log_b a$. Med ét kald er $alpha = 0$ og $n^alpha = 1$.
    + *Løs.* Er $f$ også konstant, står de lige. Tilfælde 2, og $Theta(n^alpha log n)$ bliver til et rent $Theta(log a)$.
  ],
  worked: [
    + Arbejdet udenom er $Theta(1)$ (én floor, én multiplikation, én mod, én addition), og argumentet halveres. Så $T(a) = T(floor(a\/2)) + Theta(1)$.
    + Master-tal: $a = 1$, $b = 2$, $f = Theta(1)$. Skelseksponenten $alpha = log_2 1 = 0$, så $n^alpha = 1$.
    + Sammenlign $f = Theta(1)$ mod $1$. De er lige store, tilfælde 2.
    + Med $n^alpha = 1$ koger $Theta(n^alpha log a)$ ned til $Theta(log a)$.

    Svar: $T(a) = Theta(log a)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs + klassificér (skelseksponenten)],
  source: "DM507 juni 2012, Opg. 3 (15%)",
  theory: <th-rec-method>,
  prompt: [
    *a.* Løs $#swap[$T(n) = 8 dot T(n\/4) + n^(1.5)$]$.

    *b.* Afgør for hver, om Master Theorem (CLRS, Thm. 4.1) kan løse den, og angiv i givet fald tilfældet:
    + #swap[$T(n) = 14 dot T(n\/13) + n$]
    + #swap[$T(n) = 13 dot T(n\/13) + n log n$]
    + #swap[$T(n) = 14 dot T(n\/13) + n log n$]
    + #swap[$T(n) = 13 dot T(n\/14) + n$]
  ],
  answer: [*a.* $T(n) = Theta(n^(1.5) log n)$ — tilfælde 2. *b.* (i) tilfælde 1, (ii) kan ikke løses (hullet), (iii) tilfælde 1, (iv) tilfælde 3.],
  blueprint: [
    For hver ligning: regn $alpha$, hold $f$ op mod $n^alpha$, og pas på, om gabet er en hel potens eller bare en $log$-faktor.

    + *Aflæs og regn $alpha$.* Find #swap[$a$], #swap[$b$], #swap[$f(n)$] og $alpha = log_b a$.
    + *Sammenlign.* Polynomielt mindre $f$ giver tilfælde 1; samme orden tilfælde 2; polynomielt større (plus regularitet) tilfælde 3.
    + *Tjek hullet.* En ekstra $log$-faktor er *ikke* et polynomielt gab. Ligger $f$ kun et $log$ fra $n^alpha$, falder den uden for alle tre tilfælde.
  ],
  worked: [
    *a.* $a = 8$, $b = 4$, $f(n) = n^(1.5)$. Skelseksponenten $alpha = log_4 8 = 1.5 = c$, så $f(n) = Theta(n^alpha)$. Tilfælde 2. Svar: $T(n) = Theta(n^(1.5) log n)$.

    *b.* Sammenlign $f$ mod $n^alpha$ for hver:
    + $alpha = log_13 14 approx 1.03$. $f = n^1$, og $1 < alpha$, så $f = O(n^(alpha - epsilon))$. Tilfælde 1.
    + $alpha = log_13 13 = 1$. $f = n log n$: ikke $Theta(n)$, ikke $O(n^(1 - epsilon))$, og $n log n$ er ikke $Omega(n^(1 + epsilon))$, da $log n$ vokser langsommere end ethvert $n^epsilon$. Falder i hullet — kan ikke løses.
    + $alpha approx 1.03$. $f = n log n$. Da $n^(alpha - 1) = n^(0.03)$ vokser hurtigere end $log n$, er $n log n = O(n^(alpha - epsilon))$ for $0 < epsilon < 0.03$. Tilfælde 1.
    + $alpha = log_14 13 approx 0.97 < 1$. $f = n^1 = Omega(n^(alpha + epsilon))$, og regularitet $13(n/14) = (13\/14)n <= d thin n$ med $d = 13/14 < 1$. Tilfælde 3.
  ],
)

#qcard(
  tag: [Master Theorem: løs + klassificér (skelseksponenten)],
  source: "jun 2016, Problem 1 (10%)",
  theory: <th-rec-method>,
  prompt: [
    For hver rekursionsligning: *(a)* afgør, om lærebogens Master Theorem gælder, og hvilket tilfælde, og *(b)* giv løsningen $T(n)$, hvor den gælder.
    + #swap[$T(n) = 2 T(n\/2) + 1$]
    + #swap[$T(n) = 3 T(n\/3) + n$]
    + #swap[$T(n) = 4 T(n\/4) + n log n$]
    + #swap[$T(n) = 5 T(n\/5) + n^2$]
  ],
  answer: [(i) tilfælde 1, $Theta(n)$. (ii) tilfælde 2, $Theta(n log n)$. (iii) kan ikke løses (hullet). (iv) tilfælde 3, $Theta(n^2)$.],
  blueprint: [
    Samme rutine fire gange. Læg mærke til, at $alpha = 1$ for alle fire her ($a = b$), så det er $f$ alene, der afgør tilfældet.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$], og regn $alpha = log_b a$.
    + *Sammenlign.* Hold $f$ op mod $n^alpha$.
    + *Vælg tilfælde eller dømt ude.* Polynomielt mindre: tilfælde 1. Samme orden: tilfælde 2. Polynomielt større (plus regularitet): tilfælde 3. Kun en $log$-faktor fra: uden for sætningen.
  ],
  worked: [
    For alle fire er $a = b$, så $alpha = log_b a = 1$ og $n^alpha = n$.

    + $f = 1 = O(n^(1 - epsilon))$ (tag $epsilon = 1$). Tilfælde 1. $T(n) = Theta(n)$.
    + $f = n = Theta(n)$. Tilfælde 2. $T(n) = Theta(n log n)$.
    + $f = n log n$. Er det $Omega(n^(1 + epsilon))$? Nej — kun en $log$-faktor over $n$, ikke noget polynomielt $n^epsilon$. Hverken tilfælde 2 eller 3. Kan ikke løses. (Den sande løsning er $Theta(n log^2 n)$, men den fås ikke af sætningen.)
    + $f = n^2 = Omega(n^(1 + 1))$. Regularitet: $5(n/5)^2 = n^2\/5 <= c thin n^2$ med $c = 1/5 < 1$. Tilfælde 3. $T(n) = Theta(n^2)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs rekursionsligning (skelseksponenten)],
  source: "DM507 juni 2010, Opg. 1a (5%)",
  theory: <th-rec-method>,
  prompt: [Løs $#swap[$T(n) = 16 dot T(n\/2) + n^4 + n^2$]$.],
  answer: [$T(n) = Theta(n^4 log n)$ — tilfælde 2.],
  blueprint: [
    Et drivled med to potenser: kun den største tæller, resten drukner.

    + *Aflæs.* Find #swap[$a$], #swap[$b$] og #swap[$f(n)$]. Behold kun den dominerende potens i $f$.
    + *Skelseksponent.* Regn $alpha = log_b a$ og skriv $n^alpha$.
    + *Sammenlign og vælg.* Lander $f(n)$ præcis på $n^alpha$, er det tilfælde 2 med svaret $Theta(n^alpha log n)$.
  ],
  worked: [
    + $a = 16$, $b = 2$, $f(n) = n^4 + n^2$. Her er $n^4$ den store, så $f(n) = Theta(n^4)$; leddet $n^2$ drukner.
    + Skelseksponenten: $alpha = log_2 16 = 4$, så $n^alpha = n^4$.
    + Sammenlign $n^4$ mod $n^4$. De er lige store, $f(n) = Theta(n^alpha)$. Tilfælde 2.

    Svar: $T(n) = Theta(n^4 log n)$.
  ],
)

#qcard(
  tag: [Master Theorem: løs + klassificér (skelseksponenten)],
  source: "DM507 juni 2015, Opg. 1 (10%)",
  theory: <th-rec-method>,
  prompt: [
    For hver rekursionsligning: *(a)* afgør, om lærebogens Master Theorem gælder, og hvilket tilfælde, og *(b)* giv løsningen $T(n)$, hvor den gælder.
    + #swap[$T(n) = 5 dot T(n\/2) + n^2$]
    + #swap[$T(n) = 5 dot T(n\/5) + n log n$]
    + #swap[$T(n) = 2 dot T(n\/5) + n^(1\/2)$]
    + #swap[$T(n) = 2 dot T(n - 2) + n$]
  ],
  answer: [(i) tilfælde 1, $Theta(n^(log_2 5))$. (ii) kan ikke løses (hullet). (iii) tilfælde 3, $Theta(sqrt(n))$. (iv) kan ikke løses (forkert form).],
  blueprint: [
    Tjek først formen, så regn $alpha$ og hold $f$ op mod $n^alpha$. To faldgruber: subtraktiv form og $log$-hullet.

    + *Tjek formen.* Sætningen kræver $T(n) = a dot T(n/b) + f(n)$ med konstante $a >= 1$, $b > 1$. Subtraktiv (subtractive) $T(n - c)$ eller variabel $a\/b$ falder uden for.
    + *Aflæs og regn $alpha$.* Find #swap[$a$], #swap[$b$], #swap[$f(n)$] og $alpha = log_b a$.
    + *Sammenlign.* Polynomielt mindre $f$ giver tilfælde 1; samme orden tilfælde 2; polynomielt større (plus regularitet) tilfælde 3.
    + *Tjek hullet.* En ekstra $log$-faktor er *ikke* et polynomielt gab. Ligger $f$ kun et $log$ fra $n^alpha$, falder den uden for alle tre tilfælde.
  ],
  worked: [
    + $a = 5$, $b = 2$, $f(n) = n^2$. $alpha = log_2 5 approx 2.32$. Da $2 < alpha$ med en hel potens, er $f = O(n^(alpha - epsilon))$. Tilfælde 1. $T(n) = Theta(n^(log_2 5))$.
    + $a = 5$, $b = 5$, $f(n) = n log n$. $alpha = log_5 5 = 1$, så $n^alpha = n$. Her er $f\/n = log n$, kun en $log$-faktor over $n$, ikke noget polynomielt $n^epsilon$. Falder i hullet mellem tilfælde 2 og 3 — kan ikke løses.
    + $a = 2$, $b = 5$, $f(n) = n^(1\/2)$. $alpha = log_5 2 approx 0.43$. Da $0.5 > alpha$ med en polynomiel margin, er $f = Omega(n^(alpha + epsilon))$. Regularitet: $2(n/5)^(1\/2) = (2\/sqrt(5)) n^(1\/2) approx 0.894 dot n^(1\/2) <= d thin n^(1\/2)$ med $d < 1$. Tilfælde 3. $T(n) = Theta(sqrt(n))$.
    + Subtraktiv form $2 dot T(n - 2) + n$, ikke $a dot T(n/b)$. Master Theorem gælder ikke.
  ],
)
