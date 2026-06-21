#import "../lib.typ": *

=== Asymptotik på skriftlig eksamen

To slags opgaver her. Den ene beder dig afgøre rene $O$-, $Theta$-, $o$- og $omega$-påstande ved at sammenligne, hvor hurtigt to funktioner vokser. Den anden beder dig aflæse en $Theta$- eller $O$-køretid direkte fra pseudokode (pseudocode) med indlejrede løkker (nested loops).

#qcard(
  tag: [O-påstande: sandt/falsk (vækststigen)],
  source: "DM507 jan 2007, Opg. 3 (15%)",
  theory: <th-asym-ladder>,
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
    Hver test er forholdet $f(n)\/g(n)$ for $n -> oo$. Husk: grænse $> 0$ (gerne $oo$) giver $Omega$; grænse $oo$ giver $omega$; grænse $0$ giver $o$; endelig grænse giver $O$; konstant $> 0$ giver $Theta$.

    + $f = n^2, g = n$. Forholdet:
      #eq[$ (n^2)/n = n -> oo. $]
      Grænsen er $oo > 0$, så $n^2 in Omega(n)$. *Sand.*
    + $f = n, g = n^2$. Forholdet:
      #eq[$ n/(n^2) = 1/n -> 0. $]
      Grænsen er $0$, ikke en konstant $> 0$, så $n in o(n^2)$ og dermed $n in.not Theta(n^2)$. *Falsk.*
    + $f = n log n, g = n^2$. Forholdet:
      #eq[$ (n log n)/(n^2) = (log n)/n -> 0, $]
      da $log n$ vokser langsommere end $n$. Grænse $0$ giver $n log n in o(n^2)$. *Sand.*
    + $f = log n, g = sqrt(n)$. Sæt $m = sqrt(n)$, så $log n = 2 log m$, og forholdet bliver
      #eq[$ (log n)/sqrt(n) = (2 log m)/m -> 0. $]
      Grænse $0$ (endelig), så $log n in O(sqrt(n))$ (endda $o$). *Sand.*
    + $f = n!, g = 2^n$. Skriv forholdet som et produkt af faktorer:
      #eq[$ (n!)/(2^n) = 1/2 dot 2/2 dot 3/2 dot 4/2 dots.h n/2 = product_(k=1)^n k/2. $]
      For $k >= 3$ er hver faktor $k\/2 > 1$, og de bliver vilkårligt store, så produktet $-> oo$. Altså $n! in omega(2^n)$. *Sand.*
  ],
)

#qcard(
  tag: [Sortér efter vækst (vækststigen)],
  source: "DM507 juni 2008, Opg. 2a (10%)",
  theory: <th-asym-ladder>,
  prompt: [Angiv den asymptotiske rækkefølge (langsomst- til hurtigst-voksende) af funktionerne #swap[$sqrt(n), 2^n, (log_10 n)^2, n, log_2 n$].],
  answer: [$log_2 n prec (log_10 n)^2 prec sqrt(n) prec n prec 2^n$.],
  blueprint: [
    Sortér ved at placere hver funktion i sin vækstklasse.

    + *Klassificér.* Logaritmisk $prec$ poly-logaritmisk $prec$ polynomiel (efter voksende eksponent) $prec$ eksponentiel.
    + *Ignorér konstanter.* Grundtal i $log$ og konstante faktorer ændrer ikke klassen.
    + *Sortér inden for polynomierne.* Mindre eksponent kommer først ($n^(1\/2) prec n^1$).
  ],
  worked: [
    Først fjernes grundtal og konstante faktorer, da de ikke ændrer vækstklassen:
    #eq[$ log_2 n = (ln n)/(ln 2) = Theta(log n), quad (log_10 n)^2 = ((ln n)/(ln 10))^2 = Theta((log n)^2). $]

    Nu rangeres parvis med forholdstesten.

    + $log n$ mod $(log n)^2$: forholdet $(log n)\/(log n)^2 = 1\/log n -> 0$, så $log_2 n prec (log_10 n)^2$.
    + $(log n)^2$ mod $sqrt(n)$: sæt $m = log n$, så $n = 2^m$ (basis $2$) og $sqrt(n) = 2^(m\/2)$. Forholdet
      #eq[$ ((log n)^2)/sqrt(n) = m^2/2^(m\/2) -> 0, $]
      da en eksponentiel i $m$ slår ethvert polynomium i $m$. Altså $(log_10 n)^2 prec sqrt(n)$.
    + $sqrt(n)$ mod $n$: forholdet $n^(1\/2)\/n^1 = n^(-1\/2) -> 0$ (mindre eksponent), så $sqrt(n) prec n$.
    + $n$ mod $2^n$: forholdet $n\/2^n -> 0$, da enhver eksponentiel med grundtal $> 1$ slår ethvert polynomium. Altså $n prec 2^n$.

    Kæd uligheder sammen:
    #eq[$ log_2 n prec (log_10 n)^2 prec sqrt(n) prec n prec 2^n. $]
  ],
)

#qcard(
  tag: [O-regneregler: sandt/falsk (Konstante faktorer)],
  source: "DM507 juni 2011, Opg. 2 (15%)",
  theory: <th-asym-limit>,
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
    Start fra definitionen. Forudsætningerne giver konstanter $c_1, c_2 > 0$ og et $n_0$, så for alle $n >= n_0$:
    #eq[$ f_1(n) <= c_1 g_1(n), quad f_2(n) <= c_2 g_2(n). $]

    + *(a) sand.* Læg de to uligheder sammen:
      #eq[$ f_1 + f_2 <= c_1 g_1 + c_2 g_2 <= max(c_1, c_2) dot (g_1 + g_2). $]
      Sæt $c = max(c_1, c_2)$. Så gælder $f_1 + f_2 <= c (g_1 + g_2)$ for alle $n >= n_0$, hvilket er præcis $f_1 + f_2 in O(g_1 + g_2)$.
    + *(b) sand.* Tag uligheden fra (a), $f_1 + f_2 <= c(g_1 + g_2)$, og divider med $c$:
      #eq[$ g_1 + g_2 >= 1/c (f_1 + f_2). $]
      Det er definitionen på $g_1 + g_2 in Omega(f_1 + f_2)$ med konstant $1\/c$. (Generelt: $f in O(g) <==> g in Omega(f)$.)
    + *(c) falsk.* Et modeksempel er nok. Vælg
      #eq[$ f_1 = n, thick g_1 = n, quad f_2 = 1, thick g_2 = n. $]
      Forudsætningerne holder: $n <= 1 dot n$ og $1 <= 1 dot n$. Men forholdene er
      #eq[$ f_1/f_2 = n/1 = n, quad g_1/g_2 = n/n = 1, $]
      og $(f_1\/f_2)\/(g_1\/g_2) = n\/1 = n -> oo$. Så $n in.not O(1)$, og påstanden brydes.
  ],
)

#qcard(
  tag: [O-påstande: sandt/falsk (vækststigen)],
  source: "DM507 juni 2013, Opg. 2 (10%)",
  theory: <th-asym-ladder>,
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
    For hver: tjek om $f(n)\/g(n)$ holder sig begrænset. Går forholdet mod $oo$, er $f in.not O(g)$.

    + $f = n, g = n^(2\/3)$:
      #eq[$ n/(n^(2\/3)) = n^(1 - 2\/3) = n^(1\/3) -> oo. $]
      Ubegrænset, så en højere potens er ikke $O$ af en lavere. *Falsk.*
    + $f = n, g = (3\/2)^n$:
      #eq[$ n/((3\/2)^n) -> 0, $]
      da enhver eksponentiel med grundtal $> 1$ slår det lineære $n$. Begrænset, så *sand.*
    + $f = 5n^7 + 7n^5, g = n^6$. Det ledende led er $5n^7$, så
      #eq[$ (5n^7 + 7n^5)/(n^6) = 5n + 7/n -> oo. $]
      Ubegrænset. *Falsk.*
    + $f = (log n)^2, g = 2^(log n)$. Med grundtal $2$ er $2^(log_2 n) = n$, så
      #eq[$ ((log n)^2)/(2^(log n)) = ((log n)^2)/n -> 0 $]
      (poly-log slår enhver positiv potens). Begrænset, så $(log n)^2 in O(n)$. *Sand.*
    + $f = n, g = 1$:
      #eq[$ n/1 = n -> oo. $]
      Ubegrænset. *Falsk.*
    + $f = 1\/n, g = log n$. For $n -> oo$ er $1\/n -> 0$ mens $log n -> oo$, så
      #eq[$ (1\/n)/(log n) = 1/(n log n) -> 0. $]
      Begrænset. *Sand.*
  ],
)

#qcard(
  tag: [O-påstande: sandt/falsk (vækststigen)],
  source: "DM507 juni 2014, Opg. 2 (10%)",
  theory: <th-asym-ladder>,
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
    For hver: dan forholdet $f(n)\/g(n)$ og se, hvad det går mod. Husk skellet mellem de svage notationer ($O, Omega, Theta$) og de strikse ($o, omega$): de strikse kræver streng ulighed, så en funktion er aldrig $o$ eller $omega$ af sig selv.

    + $f = n^2, g = n^2$. Forholdet $n^2\/n^2 = 1$, en endelig konstant. Endelig grænse giver $O$. *Sand.*
    + Samme forhold $n^2\/n^2 = 1$, en konstant $> 0$. Konstant $> 0$ giver $Theta$. *Sand.*
    + $f = n^4, g = 5n^3 + 3n^5$. Det ledende led i $g$ er $3n^5$, så $g = Theta(n^5)$. Forholdet
      #eq[$ (n^4)/(5n^3 + 3n^5) = (n^4)/(3n^5 (1 + 5\/(3n^2))) = 1/(3n) dot 1/(1 + 5\/(3n^2)) -> 0. $]
      Grænse $0$ er begrænset, så $n^4 in O(n^5)$. *Sand.*
    + Samme $g = Theta(n^5)$, og $n^4$ er en lavere potens. For $Theta$ skal forholdet gå mod en konstant $> 0$, men her gik det mod $0$ (og det omvendte forhold $-> oo$), så de er ikke samme orden. *Falsk.*
    + $f = n log n, g = n^(1.5)$. Forholdet
      #eq[$ (n log n)/(n^(1.5)) = (log n)/(n^(0.5)) -> 0, $]
      da enhver positiv potens af $n$ slår enhver potens af $log n$. Begrænset, så $n log n in O(n^(1.5))$. *Sand.*
    + $f = n, g = log n$. Forholdet
      #eq[$ n/(log n) -> oo, $]
      da $n$ vokser hurtigere end $log n$. Ubegrænset, så $n in.not O(log n)$. *Falsk.*
    + $f = (log n)^(10), g = n^(0.10)$. Forholdet
      #eq[$ ((log n)^(10))/(n^(0.10)) -> 0, $]
      da enhver positiv potens af $n$ (også den lille eksponent $0.10$) til sidst slår enhver potens af $log n$. Begrænset. *Sand.*
    + $f = 1, g = n$. Forholdet $1\/n -> 0$, begrænset, så $1 in O(n)$. *Sand.*
    + $f = n^2, g = n^3$. Forholdet
      #eq[$ (n^2)/(n^3) = 1/n -> 0. $]
      Grænse $0$ (ikke bare begrænset) giver den strikse $o$, så $n^2 in o(n^3)$. *Sand.*
    + $f = n^3, g = n^3$. Forholdet $n^3\/n^3 = 1 -> 1$, ikke $oo$. $omega$ kræver grænse $oo$, så en funktion er aldrig $omega$ af sig selv. *Falsk.*
  ],
)

#qcard(
  tag: [O-påstande: sandt/falsk (vækststigen)],
  source: "DM507 juni 2015, Opg. 2 (10%)",
  theory: <th-asym-ladder>,
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
  tag: [O-påstande: sandt/falsk (vækststigen)],
  source: "jun 2016, Problem 2 (10%)",
  theory: <th-asym-ladder>,
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
  tag: [Aflæs Theta af løkkenest (multiplikativ)],
  source: "DM507 juni 2014, Opg. 9 (16%)",
  theory: <th-asym-loops>,
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
  tag: [Aflæs Theta af løkkenest (multiplikativ)],
  source: "DM507 juni 2015, Opg. 9 (14%)",
  theory: <th-asym-loops>,
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
  tag: [Aflæs Theta af løkkenest (multiplikativ)],
  source: "jun 2016, Problem 9 (8%)",
  theory: <th-asym-loops>,
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
