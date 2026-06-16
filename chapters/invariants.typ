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

#note(title: [Alle tre dele])[Vedligeholdelse alene beviser ikke korrekthed. Du skal bruge alle tre dele: rigtig start, hvert skridt bevarer det, og løkken stopper et sted, hvor invarianten giver svaret.]

#trap(title: [Exit-testen skyder forbi])[Exit-testen kan skyde forbi grænsen. En `while x < n` kan stoppe med $x > n$, så $x <= n$ er typisk *ikke* en invariant, selvom $x < n$ holder inde i kroppen. Tjek altid kandidaten ved den fejlende exit-test.]

#trap(title: [Sand ved første test])[En invariant skal være sand *ved testen*, både første og sidste gang. $r = n!$ i en fakultetsløkke er kun sandt ved sidste test, ikke første, så det er ikke en invariant, selvom det beskriver resultatet.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Løkkeinvariant: bevis invariant + aflæs output],
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
  blueprint: [
    Bevis invarianten med de tre induktionsskridt, og brug den så på exit-testen til at aflæse returværdien.

    + *Initialisering.* Indsæt startværdierne lige før første test og tjek at #swap[invarianten] holder.
    + *Vedligehold.* Antag den holder ved en test. Anvend kroppens tildelinger og vis at den holder igen ved næste test.
    + *Afslutning.* Skriv exit-betingelsen op. Kombinér den med invarianten (som holder ved den fejlende test) og læs #swap[returværdien] af.
  ],
  worked: [
    Løkken tæller $i$ op og holder $s = i^2$ undervejs.

    + *Initialisering.* Før første test er $i = 0$ og $s = 0$, så
      #eq[$ s = 0 = 0^2 = i^2. $]

    + *Vedligehold.* Antag $s = i^2$ ved en test. Kroppen sætter $s' = s + 2i + 1$ og $i' = i + 1$, så
      #eq[$ s' = i^2 + 2i + 1 = (i+1)^2 = (i')^2. $]
      Invarianten holder altså ved hver test.

    + *Afslutning.* Løkken stopper første gang $s > n$. Her giver invarianten $i^2 = s > n$, så $i > sqrt(n)$. Forrige test gik igennem, så $(i-1)^2 <= n$, altså $i - 1 <= sqrt(n)$. Dermed
      #eq[$ i - 1 <= sqrt(n) < i quad => quad i - 1 = floor(sqrt(n)). $]

    Svar: $r = i - 1 = floor(sqrt(n))$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: hvilke udsagn er invarianter?],
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
  blueprint: [
    Skriv værdierne ved hver test op og test så hver kandidat mod dem.

    + Notér starttilstanden (værdierne lige før første test) og hvad kroppen gør ved hver variabel.
    + Tjek #swap[kandidaten] ved første test. Er den falsk dér, ryger den ud.
    + Kør ét gennemløb i hånden og tjek igen. En kandidat der bryder efter ét skridt, ryger ud.
    + Behold de udsagn der er sande ved hver test, exit-testen inklusive.
  ],
  worked: [
    Værdierne ved testen er $(i, r) = (n, 1)$, så $(n-1, n)$, $(n-2, n(n-1))$, og videre ned til $(1, n!)$.

    - *(a)* $i >= 1$: invariant. $i$ løber $n, n-1, ..., 1$ og kommer aldrig under 1.
    - *(b)* $r = i!$: nej. Ved første test er $r = 1$, men $i! = n!$.
    - *(c)* $r! dot i! = n!$: nej. Sand ved første test ($1! dot n! = n!$), men efter ét skridt er $(r, i) = (n, n-1)$, og $n! dot (n-1)! != n!$ for $n > 2$.
    - *(d)* $r = n!\/i!$: invariant. Ved første test er $n!\/n! = 1 = r$. Kroppen sætter $r <- r dot i$ og tæller $i$ ned, hvilket bevarer det.
    - *(e)* $r = n!$: nej. Kun sand ved sidste test; $r = 1$ i starten.

    Svar: (a) og (d).
  ],
)

#qcard(
  tag: [Løkkeinvariant: bevis invariant + aflæs output],
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
  blueprint: [
    Bevis invarianten med de tre skridt. Når kroppen har flere grene, så tjek vedligehold for hver gren.

    + *Initialisering.* Indsæt startværdierne og tjek at #swap[invarianten] holder før første test.
    + *Vedligehold.* Antag den holder ved en test. Gennemgå hver gren af kroppen og vis at den holder igen.
    + *Afslutning.* Vis at en heltalsstørrelse aftager strengt, så løkken stopper. Aflæs #swap[returværdien] af invarianten ved exit.
  ],
  worked: [
    Invarianten balancerer det resterende $floor(log i)$ mod tælleren $k$.

    + *Initialisering.* Før første test er $i = n$ og $k = 0$, så
      #eq[$ floor(log i) + k = floor(log n) + 0 = floor(log n). $]

    + *Vedligehold.* Antag den holder ved en test med $i > 1$.
      - $i$ lige: $i' = i\/2$ og $k' = k+1$, så
        #eq[$ floor(log(i\/2)) + (k+1) = (floor(log i) - 1) + k + 1 = floor(log i) + k. $]
      - $i$ ulige ($i >= 3$): $i' = i - 1$ og $k$ er uændret, og $floor(log(i-1)) = floor(log i)$.

    + *Afslutning.* Hvert skridt tæller det positive heltal $i$ strengt ned, så løkken stopper ved $i = 1$. Her er $floor(log 1) = 0$, så invarianten giver $k = floor(log n)$.

    Svar: returværdien er $k = floor(log n)$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: hvilke udsagn er invarianter?],
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
  blueprint: [
    Test hver kandidat ved hver gennemgang, og pas især på exit-testen, der kan skyde forbi grænsen.

    + Notér starttilstanden og hvad kroppen gør ved hver variabel.
    + Tjek #swap[kandidaten] ved første test, og kassér den hvis den er falsk dér.
    + Kør ét gennemløb og tjek igen. Tjek til sidst kandidaten ved den fejlende exit-test.
    + Behold de udsagn der er sande ved hver test.
  ],
  worked: [
    Start er $x = 1$ og $r = 0$. Kroppen fordobler $x$ og tæller $r$ én op.

    - *(d)* $2^r = x$: invariant. $x$ starter som $2^0 = 1$, og hvert skridt fordobler $x$ mens $r$ vokser med 1.
    - *(e)* $x < 2n$: invariant. Inde i kroppen var $x < n$, så efter fordobling er $x < 2n$, og det gælder også ved exit-testen.
    - *(a)* $x = r + 1$: nej. $x$ vokser eksponentielt, $r$ lineært.
    - *(b)* $2^r dot log_2 n = log_2(n\/x)$: nej, falsk ved simulation.
    - *(c)* $x <= n$: nej. Exit-testen skyder forbi: $n = 3$ giver $x = 4 > 3$.

    Svar: (d) og (e).
  ],
)
