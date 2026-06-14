#import "../lib.typ": *

== Korrekthed og løkkeinvarianter

En løkkeinvariant er et udsagn, der er sandt hver gang løkkebetingelsen testes. Holder det ved hver test, holder det også ved den sidste, hvor løkken stopper. Dér ved du noget præcist om variablerne, og det giver svaret.

Beviset er induktion: invarianten holder før første test, ét gennemløb bevarer den, og løkken stopper til sidst. Til eksamen skal du enten *bevise* en given invariant eller *afgøre*, hvilke udsagn der er invarianter.

=== Sådan løser du den

#recipe(
  title: "Bevis en løkkeinvariant",
  [Skriv invarianten op med kodens variabler, fx $s = i^2$.],
  [*Initialisering.* Indsæt værdierne lige før første test, og tjek at udsagnet holder.],
  [*Vedligeholdelse.* Antag det holder ved en test. Anvend kroppens tildelinger, og vis at det holder igen ved næste test.],
  [*Terminering.* Vis at løkken stopper: en heltalsstørrelse aftager eller vokser strengt mod grænsen. Kombinér exit-betingelsen med invarianten (som stadig holder ved den fejlende test) og læs outputtet af.],
)

Initialisering er basistilfældet, vedligeholdelse er induktionsskridtet, og terminering er hvor du høster korrektheden.

#recipe(
  title: "Afgør hvilke kandidater der er invarianter",
  [Skriv starttilstanden op (værdierne lige før første test) og hvad kroppen gør ved hver variabel.],
  [Tjek hver kandidat ved den *første* test. Er den falsk, kassér den.],
  [Kør ét gennemløb i hånden og tjek igen. En kandidat, der bryder efter et skridt, ryger ud.],
  [Behold udsagn, der er sande ved *hver* test, også exit-testen. Der kan være flere.],
)

#note[Vedligeholdelse alene beviser ikke korrekthed. Du skal bruge alle tre dele: rigtig start, hvert skridt bevarer det, og løkken stopper et sted, hvor invarianten giver svaret.]

#trap[Exit-testen kan skyde forbi grænsen. En `while x < n` kan stoppe med $x > n$, så $x <= n$ er typisk *ikke* en invariant, selvom $x < n$ holder inde i kroppen. Tjek altid kandidaten ved den fejlende exit-test.]

#trap[En invariant skal være sand *ved testen*, både første og sidste gang. $r = n!$ i en fakultetsløkke er kun sandt ved sidste test, ikke første, så det er ikke en invariant, selvom det beskriver resultatet.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  source: "DM507 juni 2009, Opg. 2",
  prompt: [
    Betragt `KvadratRod(n)`:
    #eq[$
      &i <- 0; quad s <- 0 \
      &mono("while") s <= n: quad s <- s + 2i + 1; quad i <- i + 1 \
      &r <- i - 1; quad mono("return") r
    $]
    *(a)* Bevis løkkeinvarianten: ved starten af while-løkken (altså ved løkketesten) gælder #swap[$s = i^2$]. \
    *(b)* Brug invarianten til at vise, at `KvadratRod` returnerer det største heltal $<= sqrt(n)$, altså #swap[$r = floor(sqrt(n))$].
  ],
  answer: [Invarianten holder ved induktion. Ved exit er $r = i - 1 = floor(sqrt(n))$.],
  worked: [
    *(a) Initialisering.* Før første test er $i = 0$ og $s = 0$, så
    #eq[$ s = 0 = 0^2 = i^2. $]
    *Vedligeholdelse.* Antag $s = i^2$ ved en test. Kroppen sætter $s' = s + 2i + 1$ og $i' = i + 1$, så
    #eq[$ s' = i^2 + 2i + 1 = (i+1)^2 = (i')^2. $]
    Altså holder $s = i^2$ ved hver test. \
    *(b) Terminering.* Løkken stopper første gang $s > n$. Da giver invarianten $i^2 = s > n$, så $i > sqrt(n)$. Forrige test gik igennem, så $(i-1)^2 <= n$, altså $i - 1 <= sqrt(n)$. Dermed
    #eq[$ i - 1 <= sqrt(n) < i quad => quad i - 1 = floor(sqrt(n)). $]
    Returværdien er $r = i - 1 = floor(sqrt(n))$.
  ],
)

#qcard(
  source: "DM507 juni 2013, Opg. 6",
  prompt: [
    Betragt `Factorial(n)`:
    #eq[$
      &i <- n; quad r <- 1 \
      &mono("while") i > 1: quad r <- r dot i; quad i <- i - 1 \
      &mono("return") r
    $]
    For heltal $n >= 1$, angiv for hvert udsagn om det er en løkkeinvariant (sandt hver gang while-testen evalueres).
  ],
  options: (
    [#swap[$i >= 1$]],
    [#swap[$r = i!$]],
    [#swap[$r! dot i! = n!$]],
    [#swap[$r = n!\/i!$]],
    [#swap[$r = n!$]],
  ),
  answer: [Invarianter: (a) og (d).],
  worked: [
    Værdier ved testen: $(i, r) = (n, 1)$, så $(n-1, n)$, $(n-2, n(n-1))$, …, ned til $(1, n!)$. \
    *(a)* $i >= 1$: invariant. $i$ løber $n, n-1, ..., 1$, aldrig under 1. \
    *(b)* $r = i!$: nej. Ved første test er $r = 1$, men $i! = n!$. \
    *(c)* $r! dot i! = n!$: nej. Sand ved første test ($1! dot n! = n!$), men efter ét skridt er $(r, i) = (n, n-1)$, og $n! dot (n-1)! != n!$ for $n > 2$. \
    *(d)* $r = n!\/i!$: invariant. Ved første test $n!\/n! = 1 = r$. Kroppen sætter $r <- r dot i$ og dekrementerer $i$, hvilket bevarer det. \
    *(e)* $r = n!$: nej. Kun sand ved sidste test; $r = 1$ i starten.
  ],
)

#qcard(
  source: "DM507 juni 2012, Opg. 6",
  prompt: [
    `IntegerLog(n)` beregner $floor(log n)$:
    #eq[$
      &k <- 0; quad i <- n \
      &mono("while") i > 1: quad i mono(" lige"): i <- i\/2, k <- k+1; quad mono("ellers"): i <- i - 1 \
      &mono("return") k
    $]
    Brug fakta $floor(log(n\/2)) = floor(log n) - 1$ og $floor(log(n-1)) = floor(log n)$ for ulige $n$. \
    *(b)* Bevis invarianten #swap[$floor(log i) + k = floor(log n)$]. \
    *(c)* Vis, at løkken returnerer #swap[$floor(log n)$].
  ],
  answer: [Invarianten holder ved induktion. Ved exit er $i = 1$, så $k = floor(log n)$.],
  worked: [
    *(b) Initialisering.* Før første test er $i = n$, $k = 0$, så
    #eq[$ floor(log i) + k = floor(log n) + 0 = floor(log n). $]
    *Vedligeholdelse.* Antag den holder ved en test med $i > 1$. \
    $i$ lige: $i' = i\/2$, $k' = k+1$, så
    #eq[$ floor(log(i\/2)) + (k+1) = (floor(log i) - 1) + k + 1 = floor(log i) + k. $]
    $i$ ulige ($i >= 3$): $i' = i - 1$, $k$ uændret, og $floor(log(i-1)) = floor(log i)$. \
    *(c) Terminering.* Hvert skridt aftager det positive heltal $i$ strengt, så løkken stopper ved $i = 1$. Her er $floor(log 1) = 0$, så invarianten giver $k = floor(log n)$, som returneres.
  ],
)

#qcard(
  source: "MCQ juni 2017, Spm. 23",
  prompt: [
    `LogBaseTo(n)` beregner $ceil(log_2 n)$:
    #eq[$
      &x <- 1; quad r <- 0 \
      &mono("while") x < n: quad x <- 2x; quad r <- r + 1 \
      &mono("return") r
    $]
    Hvilke af udsagnene nedenfor er en løkkeinvariant for algoritmen (altid sand når testen ved starten af while-løkken evalueres) for alle heltal #swap[$n >= 1$]? (Et eller flere svar.)
  ],
  options: (
    [$x = r + 1$],
    [$2^r dot log_2 n = log_2(n\/x)$],
    [$x <= n$],
    [#swap[$2^r = x$]],
    [#swap[$x < 2n$]],
  ),
  answer: [(d) og (e) er begge invarianter.],
  worked: [
    Tjek hvert udsagn ved hver test, exit-testen inklusive. Start: $x = 1$, $r = 0$; kroppen fordobler $x$ og inkrementerer $r$. \
    *(d)* $2^r = x$: invariant. $x$ starter som $2^0 = 1$, og hvert skridt fordobler $x$ mens $r$ vokser med 1. \
    *(e)* $x < 2n$: invariant. Inde i kroppen var $x < n$, så efter fordobling er $x < 2n$; det gælder også ved exit-testen. \
    *(a)* $x = r + 1$: nej. $x$ vokser eksponentielt, $r$ lineært. \
    *(b)* falsk ved simulation. \
    *(c)* $x <= n$: nej. Exit-testen skyder forbi: $n = 3$ giver $x = 4 > 3$.
  ],
)
