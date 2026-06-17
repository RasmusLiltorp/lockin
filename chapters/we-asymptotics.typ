#import "../lib.typ": *

=== Asymptotik på skriftlig eksamen

To slags opgaver her. Den ene beder dig afgøre rene $O$-, $Theta$-, $o$- og $omega$-påstande ved at sammenligne, hvor hurtigt to funktioner vokser. Den anden beder dig aflæse en $Theta$- eller $O$-køretid direkte fra pseudokode (pseudocode) med indlejrede løkker (nested loops).

#qcard(
  tag: [O-påstande: sandt/falsk],
  source: "DM507 jan 2007, Opg. 3 (15%)",
  prompt: [Afgør for hver påstand, om den er sand eller falsk.
    + #swap[$n^2 in Omega(n)$]
    + #swap[$n in Theta(n^2)$]
    + #swap[$n log n in o(n^2)$]
    + #swap[$log n in O(sqrt(n))$]
    + #swap[$n! in omega(2^n)$]
  ],
  answer: [1, 3, 4, 5 er sande; 2 er falsk.],
  blueprint: [
    Hver påstand er en grænseværdi-test på forholdet $f(n)\/g(n)$.

    + *Skriv forholdet op.* Sæt $f$ over $g$ og se, hvad $f(n)\/g(n)$ går mod for $n -> oo$.
    + *Match med notationen.* $O$: grænsen er endelig. $o$: grænsen er $0$. $Omega$: grænsen er $> 0$ (gerne $oo$). $omega$: grænsen er $oo$. $Theta$: grænsen er en konstant $> 0$.
    + *Brug vækststigen ved tvivl.* $log n < sqrt(n) < n < n log n < n^2 < dots.h < 2^n < n!$.
  ],
  worked: [
    + $n^2\/n = n -> oo$, så $n^2$ vokser mindst lige så hurtigt som $n$. Sand.
    + $n\/n^2 = 1\/n -> 0$, så $n in o(n^2)$, og dermed $n in.not Theta(n^2)$. Falsk.
    + $(n log n)\/n^2 = (log n)\/n -> 0$, så $n log n in o(n^2)$. Sand.
    + $(log n)\/sqrt(n) -> 0$, så $log n in O(sqrt(n))$ (faktisk $o$). Sand.
    + $n!\/2^n -> oo$, fordi hver ny faktor $k$ til sidst overstiger $2$. Sand.
  ],
)

#qcard(
  tag: [Sortér efter vækst],
  source: "DM507 juni 2008, Opg. 2a (10%)",
  prompt: [Angiv den asymptotiske rækkefølge (langsomst- til hurtigst-voksende) af funktionerne #swap[$sqrt(n), 2^n, (log_10 n)^2, n, log_2 n$].],
  answer: [$log_2 n prec (log_10 n)^2 prec sqrt(n) prec n prec 2^n$.],
  blueprint: [
    Sortér ved at placere hver funktion i sin vækstklasse.

    + *Klassificér.* Logaritmisk $prec$ poly-logaritmisk $prec$ polynomiel (efter voksende eksponent) $prec$ eksponentiel.
    + *Ignorér konstanter.* Grundtal i $log$ og konstante faktorer ændrer ikke klassen.
    + *Sortér inden for polynomierne.* Mindre eksponent kommer først ($n^(1\/2) prec n^1$).
  ],
  worked: [
    + $log_2 n = Theta(log n)$ er den langsomste.
    + $(log_10 n)^2 = Theta((log n)^2)$ er poly-logaritmisk: hurtigere end $log n$, men langsommere end enhver positiv potens af $n$.
    + $sqrt(n) = n^(1\/2) prec n^1 = n$ (mindre eksponent).
    + $2^n$ slår ethvert polynomium.

    Rækkefølge: $log_2 n prec (log_10 n)^2 prec sqrt(n) prec n prec 2^n$.
  ],
)

#qcard(
  tag: [O-regneregler: sandt/falsk],
  source: "DM507 juni 2011, Opg. 2 (15%)",
  prompt: [Lad $f_1, f_2, g_1, g_2$ være positive funktioner med $f_1 in O(g_1)$ og $f_2 in O(g_2)$. Hvilke af nedenstående er #emph[altid] sande?
    + #swap[$f_1(n) + f_2(n) in O(g_1(n) + g_2(n))$]
    + #swap[$g_1(n) + g_2(n) in Omega(f_1(n) + f_2(n))$]
    + #swap[$f_1(n)\/f_2(n) in O(g_1(n)\/g_2(n))$]
  ],
  answer: [(a) sand, (b) sand, (c) falsk.],
  blueprint: [
    Enten udled reglen af definitionen, eller knæk den med et modeksempel.

    + *Skriv definitionen.* $f in O(g)$ betyder $f(n) <= c dot g(n)$ for et $c > 0$ og alle store $n$.
    + *Prøv at udlede.* Sæt $f_1 <= c_1 g_1$ og $f_2 <= c_2 g_2$ ind, og se om konklusionen følger med konkrete konstanter.
    + *Find modeksempel, hvis den ikke holder.* Vælg simple konkrete $f_1, f_2, g_1, g_2$ der opfylder forudsætningerne, men bryder konklusionen.
  ],
  worked: [
    + *(a) sand.* $f_1 <= c_1 g_1$ og $f_2 <= c_2 g_2$ for store $n$, så $f_1 + f_2 <= c_1 g_1 + c_2 g_2 <= max(c_1, c_2)(g_1 + g_2)$. Med $c = max(c_1, c_2)$ er det $O$-grænsen.
    + *(b) sand.* Det er (a) skrevet om: $f_1 + f_2 <= c(g_1 + g_2)$ giver $g_1 + g_2 >= (1\/c)(f_1 + f_2)$, altså $Omega$. Generelt $f in O(g) <==> g in Omega(f)$.
    + *(c) falsk.* Tag $f_1 = n, g_1 = n$ og $f_2 = 1, g_2 = n$ (begge forudsætninger holder, da $1 <= n$). Så er $f_1\/f_2 = n$, men $g_1\/g_2 = n\/n = 1$, og $n in.not O(1)$.
  ],
)

#qcard(
  tag: [O-påstande: sandt/falsk],
  source: "DM507 juni 2013, Opg. 2 (10%)",
  prompt: [Afgør for hver påstand, om den er sand eller falsk.
    + #swap[$n in O(n^(2\/3))$]
    + #swap[$n in O((3\/2)^n)$]
    + #swap[$5n^7 + 7n^5 in O(n^6)$]
    + #swap[$(log n)^2 in O(2^(log n))$]
    + #swap[$n^1 in O(1)$]
    + #swap[$1\/n in O(log n)$]
  ],
  answer: [ii, iv, vi sande; i, iii, v falske.],
  blueprint: [
    $f in O(g)$ netop når $f(n)\/g(n)$ holder sig begrænset for $n -> oo$.

    + *Sammenlign klasser.* Højere potens slår lavere; enhver eksponentiel med grundtal $> 1$ slår ethvert polynomium; $log$-potenser slår konstanter, men taber til enhver positiv potens.
    + *Reducér summer.* I en sum af potenser bestemmer den højeste potens klassen.
    + *Test forholdet.* Går $f(n)\/g(n)$ mod $oo$, er $f in.not O(g)$.
  ],
  worked: [
    + $n\/n^(2\/3) = n^(1\/3) -> oo$. En højere potens er ikke $O$ af en lavere. Falsk.
    + $(3\/2)^n$ er eksponentiel og slår det lineære $n$. Sand.
    + Ledende led $5n^7$, og $n^7\/n^6 = n -> oo$. Falsk.
    + $2^(log n) = n$ (grundtal $2$). $(log n)^2\/n -> 0$, så $(log n)^2 in O(n)$. Sand.
    + $n\/1 = n -> oo$. Falsk.
    + $1\/n -> 0$, begrænset af $log n$ for $n >= 1$. Sand.
  ],
)

#qcard(
  tag: [O-påstande: sandt/falsk],
  source: "DM507 juni 2014, Opg. 2 (10%)",
  prompt: [Afgør for hver påstand, om den er sand eller falsk.
    + #swap[$n^2 in O(n^2)$]
    + #swap[$n^2 in Theta(n^2)$]
    + #swap[$n^4 in O(5n^3 + 3n^5)$]
    + #swap[$n^4 in Theta(5n^3 + 3n^5)$]
    + #swap[$n log n in O(n^(1.5))$]
    + #swap[$n in O(log n)$]
    + #swap[$(log n)^(10) in O(n^(0.10))$]
    + #swap[$1 in O(n)$]
    + #swap[$n^2 in o(n^3)$]
    + #swap[$n^3 in omega(n^3)$]
  ],
  answer: [i, ii, iii, v, vii, viii, ix sande; iv, vi, x falske.],
  blueprint: [
    Samme grænseværdi-test, men husk forskellen på de strikse og de svage notationer.

    + *Reducér summer.* I $5n^3 + 3n^5$ bestemmer $n^5$ klassen — den er $Theta(n^5)$.
    + *Brug klasse-rangen.* Konstant $prec log$-potens $prec$ potens (efter eksponent) $prec$ eksponentiel.
    + *Pas på strikse notationer.* $o$ og $omega$ kræver streng ulighed: en funktion er aldrig $o$ eller $omega$ af sig selv.
  ],
  worked: [
    + Samme orden. Sand.
    + Samme orden. Sand.
    + Højre side er $Theta(n^5) >= n^4$. Sand.
    + Højre side er $Theta(n^5)$, og $n^4$ er mindre. Falsk.
    + $log n = o(n^(0.5))$, så $n log n = o(n^(1.5))$. Sand.
    + $n$ vokser hurtigere end $log n$. Falsk.
    + Enhver $log$-potens er $o$ af enhver positiv potens. Sand.
    + Konstant $<= n$. Sand.
    + $n^2\/n^3 = 1\/n -> 0$. Sand.
    + Samme orden, forholdet $-> 1$, ikke $oo$. Falsk.
  ],
)

#qcard(
  tag: [O-påstande: sandt/falsk],
  source: "DM507 juni 2015, Opg. 2 (10%)",
  prompt: [Afgør for hver påstand, om den er sand eller falsk.
    + #swap[$2n in O(n^3)$]
    + #swap[$n^2 in O(3^n)$]
    + #swap[$n(log n)^2 in O(n^3 log n)$]
    + #swap[$n^2 log n in O(n(log n)^3)$]
    + #swap[$n^3 in O(n^2)$]
    + #swap[$3^n in O(2^n)$]
    + #swap[$n^(1\/3) in O(n^(1\/2))$]
    + #swap[$(1\/3)^n in O((1\/2)^n)$]
    + #swap[$3 in O(2)$]
  ],
  answer: [i, ii, iii, vii, viii, ix sande; iv, v, vi falske.],
  blueprint: [
    $f in O(g)$ netop når $limsup f(n)\/g(n) < oo$.

    + *Rangér efter klasse.* Konstant $<<$ logaritmer $<<$ polynomier (efter eksponent) $<<$ eksponentielle (efter grundtal).
    + *To eksponentielle.* $a^n in O(b^n)$ netop når $a <= b$ — også for grundtal under $1$.
    + *Konstanter.* Enhver konstant er $O$ af enhver positiv konstant.
  ],
  worked: [
    + Lineær $<=$ kubisk. Sand.
    + Polynomium $<=$ enhver eksponentiel med grundtal $> 1$. Sand.
    + Forholdet $= (log n)\/n^2 -> 0$. Sand.
    + Forholdet $= (n^2 log n)\/(n(log n)^3) = n\/(log n)^2 -> oo$. Falsk.
    + $n^3 >> n^2$. Falsk.
    + $3^n\/2^n = (3\/2)^n -> oo$. Falsk.
    + Eksponent $1\/3 <= 1\/2$. Sand.
    + $(1\/3)^n\/(1\/2)^n = (2\/3)^n -> 0$. Sand.
    + Begge konstante. Sand.
  ],
)

#qcard(
  tag: [O-påstande: sandt/falsk],
  source: "jun 2016, Problem 2 (10%)",
  prompt: [Afgør for hver påstand, om den er sand eller falsk.
    + #swap[$1 in O(2)$]
    + #swap[$1 in Omega(2)$]
    + #swap[$n in O(n^2)$]
    + #swap[$n in Omega(n^2)$]
    + #swap[$3x + 2x^2 + x^3 in Theta(x + 2x^2 + 3x^3)$]
    + #swap[$log n in o(n\/log n)$]
    + #swap[$n^(1\/2) in o(n\/2^n)$]
    + #swap[$log n in omega(log n)$]
    + #swap[$2^n log n in omega(2^n)$]
    + #swap[$n^2\/log n in O(n(log n)^2)$]
  ],
  answer: [i, ii, iii, v, vi, ix sande; iv, vii, viii, x falske.],
  blueprint: [
    For hvert par $f, g$: tag $lim f(n)\/g(n)$ og match med notationen.

    + *$-> 0$:* $f = o(g)$ (og $O$, men ikke $Omega\/omega\/Theta$).
    + *$-> oo$:* $f = omega(g)$ (og $Omega$).
    + *$-> c != 0$:* $f = Theta(g)$ (så $O$ og $Omega$, men ikke $o\/omega$).
    + *Reducér polynomier* til det højeste led, før du sammenligner.
  ],
  worked: [
    + Begge konstante, $1 <= c dot 2$. Sand.
    + Begge konstante, $1 >= c dot 2$ for lille $c$. Sand.
    + $n\/n^2 -> 0$. Sand.
    + $n$ vokser langsommere end $n^2$. Falsk.
    + Begge er $Theta(x^3)$. Sand.
    + $(log n)\/(n\/log n) = (log^2 n)\/n -> 0$. Sand.
    + $n\/2^n -> 0$, mens $n^(1\/2) -> oo$. Forholdet $-> oo$, ikke $0$. Falsk.
    + En funktion er aldrig $omega$ af sig selv (forhold $= 1$). Falsk.
    + Forholdet $= log n -> oo$. Sand.
    + Forholdet $= (n^2\/log n)\/(n log^2 n) = n\/log^3 n -> oo$, så venstre side er størst. Ikke $O$. Falsk.
  ],
)

#qcard(
  tag: [Aflæs Theta af løkkenest],
  source: "DM507 juni 2014, Opg. 9 (16%)",
  prompt: [Angiv den asymptotiske $O$-køretid som funktion af $n$ for hvert fragment.
    + #swap[`for i=1..n: for j=i..n: s++`]
    + #swap[`for i=1..n: { s=n; while s>1: s=floor(s/2) }`]
    + #swap[`for i=1..n: for j=i..n: for k=i..j: s++`]
    + #swap[`while n>1: { for i=1..n: s++; n=floor(n/2) }`]
  ],
  answer: [Alg1 $O(n^2)$, Alg2 $O(n log n)$, Alg3 $O(n^3)$, Alg4 $O(n)$.],
  blueprint: [
    Tæl iterationer indefra og ud.

    + *Gang/læg sammen.* Indlejrede løkker ganges; uafhængige løkker lægges sammen.
    + *Halvering er $log$.* En `while`, der halverer en værdi, kører $Theta(log n)$ gange.
    + *Aftagende ydre løkke.* En ydre halvering med lineært indre arbejde summer til en geometrisk række $approx 2n$.
    + *Trekantede grænser.* Når indre starter ved $i$ (eller $j$), giver $sum$ et $Theta$ med en lavere konstant, men samme orden som det fulde nest.
  ],
  worked: [
    + $sum_(i=1)^n (n - i + 1) = n(n+1)\/2$. $O(n^2)$.
    + Indre `while` kører $floor(log_2 n)$ gange, ydre $n$ gange. $O(n log n)$.
    + Trippel-nest begrænset af $n$ hver: $sum_i sum_(j >= i) (j - i + 1) = Theta(n^3)$. $O(n^3)$.
    + Arbejde $= n + n\/2 + n\/4 + dots.h approx 2n$. $O(n)$.
  ],
)

#qcard(
  tag: [Aflæs Theta af løkkenest],
  source: "DM507 juni 2015, Opg. 9 (14%)",
  prompt: [Angiv $Theta$-køretiden som funktion af $n$.
    #swap[
      ```
      Algoritme1(n)        Algoritme2(n)
        i = n                i = 1
        while i > 1          j = 1
           j = n             while i <= n
           while j > i          while j <= i
              j = j - 1            j = j + 1
           i = i - 1          i = i * 2

      Algoritme3(n)        Algoritme4(n)
        i = 1                i = 1
        while i <= n         while i <= n
           j = 1                j = 1
           while j <= i         while j <= i
              j = j + 1            j = j * 2
           i = i * 2          i = i + 1
      ```
    ]
  ],
  answer: [Alg1 $Theta(n^2)$, Alg2 $Theta(n)$, Alg3 $Theta(n)$, Alg4 $Theta(n log n)$.],
  blueprint: [
    For hver værdi af den ydre $i$, tæl de indre iterationer og summér.

    + *Tjek nulstilling.* Nulstilles den indre tæller hver ydre runde? (Ja i 1, 3, 4 — nej i 2.)
    + *Geometrisk ydre.* En ydre `i *= 2` giver $approx log n$ runder.
    + *Indre fordobling.* En indre `j *= 2` op til $i$ koster $ceil(log_2 i)$ skridt.
    + *Sum af logaritmer.* $sum_(i=1)^n log i = log(n!) = Theta(n log n)$.
  ],
  worked: [
    + *Alg1.* Ydre $i$ fra $n$ ned til $2$; indre tæller fra $n$ ned til $i$, altså $(n - i)$ skridt. $sum_(i=2)^n (n - i) approx n^2\/2$. $Theta(n^2)$.
    + *Alg2.* $j$ nulstilles aldrig. Ydre $i$ fordobles ($approx log n$ runder), men $j$ stiger kun fra $1$ til sidst $i$ ($<= 2n$). Samlet $approx n$. $Theta(n)$.
    + *Alg3.* $j$ nulstilles hver runde; indre kører $i$ gange for $i = 1, 2, 4, dots.h <= n$. Sum $approx 2n$ (geometrisk). $Theta(n)$.
    + *Alg4.* Ydre $i = 1..n$ ($n$ runder); indre fordobler $j$ til $i$, altså $ceil(log_2 i)$ skridt. $sum_(i=1)^n log i = log(n!) = Theta(n log n)$.
  ],
)

#qcard(
  tag: [Aflæs Theta af løkkenest],
  source: "jun 2016, Problem 9 (8%)",
  prompt: [Angiv $Theta$-køretiden i $n$ for hvert fragment.
    + #swap[`for i=1..n: { j=i; while j>0: j=j-1 }`]
    + #swap[`i=1; while i<n: i=i*2`]
    + #swap[`i=1; while i<n: i=i*n`]
    + #swap[`i=1; while i<n: { s=0; while s<n: s=s+i; i=i*2 }`]
  ],
  answer: [Alg1 $Theta(n^2)$, Alg2 $Theta(log n)$, Alg3 $Theta(1)$, Alg4 $Theta(n)$.],
  blueprint: [
    Tæl iterationer fra pseudokoden.

    + *Trekantet sum.* Indre, der kører $i$ gange for $i = 1..n$, giver $sum i = n(n+1)\/2 = Theta(n^2)$.
    + *Fordobling.* `i *= 2` op til $n$ kører $Theta(log n)$ gange.
    + *Ét hop.* `i *= n` springer forbi $n$ i første runde, så løkken kører $Theta(1)$ gange.
    + *Aftagende indre.* Indre, der kører $ceil(n\/i)$ gange for $i = 1, 2, 4, dots.h$, summer geometrisk til $approx 2n$.
  ],
  worked: [
    + Indre kører $i$ gange; $sum_(i=1)^n i = n(n+1)\/2$. $Theta(n^2)$.
    + $i$ fordobles, stopper efter $approx log_2 n$ skridt. $Theta(log n)$.
    + Første runde sætter $i = 1 dot n = n$, og så er $i < n$ falsk. Højst ét skridt. $Theta(1)$.
    + Indre kører $ceil(n\/i)$ gange for $i = 1, 2, 4, dots.h < n$. Samlet $approx n + n\/2 + n\/4 + dots.h = 2n$. $Theta(n)$.
  ],
)
