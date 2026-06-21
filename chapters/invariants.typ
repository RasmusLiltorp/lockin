#import "../lib.typ": *

== Korrekthed og løkkeinvarianter

En løkkeinvariant (loop invariant) er et udsagn, der er sandt hver gang løkkebetingelsen (loop condition) testes. Holder det ved hver test, holder det også ved den sidste, hvor løkken stopper. Dér ved du noget præcist om variablerne, og det giver svaret.

Beviset er induktion: invarianten holder før første test, ét gennemløb bevarer den, og løkken stopper til sidst. Til eksamen skal du enten *bevise* en given invariant eller *afgøre*, hvilke udsagn der er invarianter.

=== Sådan løser du den <th-inv-method>

#metadata(none) <th-inv-prove>
#recipe(
  title: "Bevis en løkkeinvariant",
  [Skriv invarianten op med kodens variabler, fx $s = i^2$.],
  [*Initialisering* (initialization)*.* Indsæt værdierne lige før første test, og tjek at udsagnet holder.],
  [*Vedligeholdelse* (maintenance)*.* Antag det holder ved en test. Anvend kroppens tildelinger, og vis at det holder igen ved næste test.],
  [*Terminering* (termination)*.* Vis at løkken stopper: en heltalsstørrelse aftager eller vokser strengt mod grænsen. Kombinér exit-betingelsen med invarianten (som stadig holder ved den fejlende test) og læs outputtet af.],
)

Initialisering er basistilfældet (base case), vedligeholdelse er induktionsskridtet (induction step), og terminering er hvor du høster korrektheden (correctness).

#metadata(none) <th-inv-decide>
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
  tag: [Løkkeinvariant: bevis invariant + aflæs output (terminering)],
  source: "DM507 juni 2009, Opg. 2",
  theory: <th-inv-prove>,
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
    Invarianten er $s = i^2$ ved hver løkketest. Først et konkret gennemløb for $n = 10$, så de tre dele kan ses i tal. Her er $(i, s)$ aflæst lige før hver test, og kroppen sætter $s <- s + 2i + 1$ efterfulgt af $i <- i + 1$:

    ```
    test #   i   s     s <= n ?   s = i^2 ?
    1        0   0      0<=10 ja    0 = 0^2  ja
    2        1   1      1<=10 ja    1 = 1^2  ja
    3        2   4      4<=10 ja    4 = 2^2  ja
    4        3   9      9<=10 ja    9 = 3^2  ja
    5        4  16     16<=10 NEJ  16 = 4^2  ja  -> stop
    ```

    Løkken stopper ved test 5 med $i = 4$, $s = 16$. Bagefter $r <- i - 1 = 3$, og $floor(sqrt(10)) = 3$. Invarianten $s = i^2$ holdt ved samtlige fem tests, exit-testen inklusive. Nu det generelle bevis.

    *(a) Bevis af invarianten $s = i^2$.*

    + *Initialisering.* Lige før første test er $i = 0$ og $s = 0$ (sat i linje 1). Indsæt:
      #eq[$ s = 0 = 0^2 = i^2. $]
      Invarianten holder ved første test.

    + *Vedligeholdelse.* Antag $s = i^2$ ved en vilkårlig test, hvor kroppen kører (dvs. $s <= n$). Kald værdierne efter kroppen $i'$ og $s'$. Kroppen sætter først $s' = s + 2i + 1$, derefter $i' = i + 1$. Indsæt induktionsantagelsen $s = i^2$:
      #eq[$ s' = s + 2i + 1 = i^2 + 2i + 1. $]
      Højresiden er kvadratet på en sum: $i^2 + 2i + 1 = (i+1)^2$. Og $i + 1 = i'$, så
      #eq[$ s' = (i+1)^2 = (i')^2. $]
      Altså holder $s = i^2$ igen ved næste test. Ved induktion holder den ved hver test.

    *(b) Aflæsning af returværdien.*

    + *Terminering.* Hver iteration øger $s$ med $2i + 1 >= 1 > 0$, så $s$ vokser strengt. Da $s$ er et voksende heltal, overskrider det før eller siden $n$, og løkken stopper. Den stopper første gang $s > n$.
    + *Kombinér exit-test og invariant.* Ved exit holder invarianten stadig: $s = i^2$. Exit-betingelsen er $s > n$, så
      #eq[$ i^2 = s > n quad => quad i > sqrt(n). $]
    + *Brug den sidste vellykkede test.* Iterationen før exit gik igennem, dvs. ved den test var $s <= n$ med $s = (i-1)^2$ (værdien af $s$ svarende til det dengang ét-mindre $i$). Altså
      #eq[$ (i-1)^2 <= n quad => quad i - 1 <= sqrt(n). $]
    + *Klem $sqrt(n)$ inde.* De to uligheder giver
      #eq[$ i - 1 <= sqrt(n) < i. $]
      Det største heltal $<= sqrt(n)$ er netop $i - 1$, så $floor(sqrt(n)) = i - 1$.

    Til sidst sætter koden $r <- i - 1$ og returnerer $r$.

    Svar: $r = i - 1 = floor(sqrt(n))$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: hvilke udsagn er invarianter? (løkkeinvariant)],
  source: "DM507 juni 2013, Opg. 6",
  theory: <th-inv-decide>,
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
    Kroppen sætter $r <- r dot i$ og derefter $i <- i - 1$, og kører så længe $i > 1$. Først et konkret gennemløb for $n = 4$. Værdierne $(i, r)$ er aflæst lige før hver while-test:

    ```
    test #   i   r         i > 1 ?
    1        4   1          4>1 ja   -> r=1*4=4,  i=3
    2        3   4          3>1 ja   -> r=4*3=12, i=2
    3        2  12          2>1 ja   -> r=12*2=24,i=1
    4        1  24          1>1 NEJ  -> stop
    ```

    Returnerer $r = 24 = 4!$. Vi tjekker hver kandidat mod denne tabel og argumenterer så generelt. En kandidat er kun invariant, hvis den er sand ved *hver* test (alle fire rækker), exit-testen inklusive.

    - *(a) $i >= 1$.* Tjek rækkerne: $i = 4, 3, 2, 1$, alle $>= 1$. Generelt starter $i$ på $n >= 1$, og kroppen kører kun mens $i > 1$; så længe $i > 1$ er $i - 1 >= 1$, så $i$ falder aldrig under $1$. Sand ved hver test. *Invariant.*

    - *(b) $r = i!$.* Ved første test er $r = 1$ og $i = n$, så kandidaten kræver $1 = n!$. Det er falsk for $n >= 2$ (i tabellen: $1 = 4! = 24$ er falsk). Falder allerede ved første test. *Ikke invariant.*

    - *(c) $r! dot i! = n!$.* Første test: $r = 1$, $i = n$, så $1! dot n! = n! $, sand. Men efter ét skridt (anden test) er $(i, r) = (n-1, n)$, og kandidaten kræver $n! dot (n-1)! = n!$, dvs. $(n-1)! = 1$. Det holder kun for $n - 1 <= 1$. I tabellen ($n=4$): anden test har $r = 4$, $i = 3$, og $4! dot 3! = 24 dot 6 = 144 != 24$. Falder ved anden test. *Ikke invariant.*

    - *(d) $r = n! \/ i!$.* Tjek rækkerne for $n = 4$ ($n! = 24$): test 1 $24\/4! = 24\/24 = 1 = r$; test 2 $24\/3! = 24\/6 = 4 = r$; test 3 $24\/2! = 24\/2 = 12 = r$; test 4 $24\/1! = 24\/1 = 24 = r$. Alle passer. Generelt: ved første test $r = 1 = n!\/n!$. Antag $r = n!\/i!$ ved en test, hvor kroppen kører. Kroppen sætter $r' = r dot i$ og $i' = i - 1$:
      #eq[$ r' = r dot i = n!/i! dot i = n!/(i-1)! = n!/(i')!. $]
      Bevaret. *Invariant.*

    - *(e) $r = n!$.* Ved første test er $r = 1$, så kandidaten kræver $1 = n!$, falsk for $n >= 2$ (i tabellen $1 != 24$). $r = n!$ er først sandt ved exit. Falder ved første test. *Ikke invariant.*

    Svar: (a) og (d).
  ],
)

#qcard(
  tag: [Løkkeinvariant: bevis invariant + aflæs output (terminering)],
  source: "DM507 juni 2012, Opg. 6",
  theory: <th-inv-prove>,
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
    Invarianten er $floor(log i) + k = floor(log n)$ ved hver test. Den balancerer det resterende $floor(log i)$ mod tælleren $k$: hvert skridt flytter præcis så meget fra $i$ til $k$, at summen står stille. Først et konkret gennemløb for $n = 12$, hvor $floor(log_2 12) = 3$ (da $2^3 = 8 <= 12 < 16 = 2^4$). Værdierne $(i, k)$ er aflæst lige før hver test:

    ```
    test #   i    k    gren        floor(log i)+k
    1       12    0    lige        3 + 0 = 3
    2        6    1    lige        2 + 1 = 3
    3        3    2    ulige       1 + 2 = 3
    4        2    2    lige        1 + 2 = 3
    5        1    3    -> stop     0 + 3 = 3
    ```

    Summen er konstant $3 = floor(log 12)$ i alle fem rækker. Løkken stopper ved $i = 1$ med $k = 3$, og returnerer $k = 3 = floor(log 12)$. Nu det generelle bevis.

    *(b) Bevis af invarianten.*

    + *Initialisering.* Lige før første test er $i = n$ og $k = 0$:
      #eq[$ floor(log i) + k = floor(log n) + 0 = floor(log n). $]
      Sand ved første test.

    + *Vedligeholdelse.* Antag $floor(log i) + k = floor(log n)$ ved en test, hvor kroppen kører (dvs. $i > 1$). Kroppen har to grene; vis bevarelse for hver. Kald de nye værdier $i', k'$.
      - *$i$ lige.* Da sætter kroppen $i' = i\/2$ og $k' = k + 1$. Brug det givne faktum $floor(log(i\/2)) = floor(log i) - 1$:
        #eq[$ floor(log i') + k' = floor(log(i\/2)) + (k+1) = (floor(log i) - 1) + (k+1) = floor(log i) + k. $]
        Højresiden er induktionsantagelsen $= floor(log n)$. Bevaret.
      - *$i$ ulige.* Da $i > 1$ og $i$ ulige er $i >= 3$, så $i' = i - 1 >= 2$. Kroppen sætter $i' = i - 1$ og lader $k$ være, $k' = k$. Brug faktummet $floor(log(i-1)) = floor(log i)$ for ulige $i$:
        #eq[$ floor(log i') + k' = floor(log(i-1)) + k = floor(log i) + k = floor(log n). $]
        Bevaret.
      I begge grene holder invarianten ved næste test. Ved induktion holder den ved hver test.

    *(c) Aflæsning af returværdien.*

    + *Terminering.* I begge grene aftager $i$ strengt: lige-grenen halverer ($i\/2 < i$ for $i > 1$), ulige-grenen trækker $1$ fra. $i$ er et positivt heltal, så en strengt aftagende følge af positive heltal når nedad og rammer $i = 1$, hvor testen $i > 1$ fejler. Løkken stopper.
    + *Kombinér exit-test og invariant.* Ved exit er $i = 1$, og invarianten holder stadig:
      #eq[$ floor(log 1) + k = floor(log n). $]
      Da $floor(log 1) = floor(0) = 0$, reducerer dette til
      #eq[$ k = floor(log n). $]

    Koden returnerer $k$.

    Svar: returværdien er $k = floor(log n)$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: hvilke udsagn er invarianter? (løkkeinvariant)],
  source: "MCQ juni 2017, Spm. 23",
  theory: <th-inv-decide>,
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
    Start er $x = 1$, $r = 0$. Kroppen fordobler $x$ ($x <- 2x$) og tæller $r$ én op, og kører mens $x < n$. Først et konkret gennemløb for $n = 3$ (vælges fordi den afslører exit-overshoot). Værdierne $(x, r)$ er aflæst lige før hver test:

    ```
    test #   x   r    x < n=3 ?
    1        1   0     1<3 ja   -> x=2, r=1
    2        2   1     2<3 ja   -> x=4, r=2
    3        4   2     4<3 NEJ  -> stop
    ```

    Returnerer $r = 2 = ceil(log_2 3)$. Bemærk: ved exit (test 3) er $x = 4 > n = 3$, så løkken skyder forbi grænsen. Det afgør flere kandidater. En invariant skal være sand ved *hver* test, exit-testen (række 3) inklusive.

    - *(d) $2^r = x$.* Tjek rækkerne: $2^0 = 1 = x$; $2^1 = 2 = x$; $2^2 = 4 = x$. Alle passer. Generelt: ved første test $2^0 = 1 = x$. Antag $2^r = x$ ved en test, hvor kroppen kører. Kroppen sætter $x' = 2x$ og $r' = r + 1$:
      #eq[$ 2^(r') = 2^(r+1) = 2 dot 2^r = 2 dot x = x'. $]
      Bevaret ved hver test. *Invariant.*

    - *(e) $x < 2n$.* Tjek rækkerne ($2n = 6$): $1 < 6$, $2 < 6$, $4 < 6$. Alle passer, exit-testen med. Generelt: ved første test $x = 1 < 2n$ (da $n >= 1$). Antag $x < 2n$ ved en test, hvor kroppen kører; så var betingelsen $x < n$ opfyldt for at komme ind, og kroppen sætter $x' = 2x < 2n$. Ved exit-testen kommer $x$ fra en iteration, hvor $x_("før") < n$, så $x = 2 x_("før") < 2n$. Sand ved hver test, også exit. *Invariant.*

    - *(a) $x = r + 1$.* Tjek rækkerne: test 1 $1 = 0 + 1$ ja; test 2 $2 = 1 + 1$ ja; test 3 $4 = 2 + 1 = 3$? Nej, $4 != 3$. $x$ vokser eksponentielt ($1, 2, 4, 8, ...$), mens $r + 1$ vokser lineært ($1, 2, 3, 4, ...$). Falder ved tredje test. *Ikke invariant.*

    - *(b) $2^r dot log_2 n = log_2(n\/x)$.* Tjek ved første test ($x = 1$, $r = 0$): venstre $2^0 dot log_2 n = log_2 n$; højre $log_2(n\/1) = log_2 n$. Lige nu sande. Anden test ($x = 2$, $r = 1$, stadig $n = 3$): venstre $2^1 dot log_2 3 = 2 log_2 3 approx 3.17$; højre $log_2(3\/2) approx 0.585$. $3.17 != 0.585$. Falder ved anden test. *Ikke invariant.*

    - *(c) $x <= n$.* Tjek rækkerne: test 1 $1 <= 3$ ja; test 2 $2 <= 3$ ja; test 3 $4 <= 3$? Nej. Exit-testen skyder forbi: inde i kroppen gælder $x < n$, men efter den sidste fordobling kan $x$ overskride $n$, og netop den værdi aflæses ved exit-testen. Falder ved exit. *Ikke invariant.*

    Svar: (d) og (e).
  ],
)
