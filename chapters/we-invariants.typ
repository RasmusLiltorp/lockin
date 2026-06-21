#import "../lib.typ": *

=== Løkkeinvarianter (loop invariants), korrekthed og køretid

De skriftlige eksamener vender den samme skabelon igen og igen: en lille iterativ eller rekursiv algoritme, hvor du skal bevise en løkkeinvariant (loop invariant) med initialisering (initialization)/vedligehold (maintenance)/afslutning (termination), bruge den til at aflæse returværdien, og til sidst sætte køretiden (running time). Et par af opgaverne spørger i stedet, hvilke udsagn der faktisk *er* invarianter.

#qcard(
  tag: [Løkkeinvariant: bevis + aflæs output + køretid (terminering)],
  source: "DM507 juni 2010, Opg. 3 (25%)",
  theory: <th-inv-prove>,
  prompt: [
    `BinaryDigits(n)` udskriver $n$ i binær:
    #eq[$
      &i <- 0; quad d <- n \
      &mono("while") d > 0: quad b_i <- d mod 2; quad d <- d mono("div") 2; quad i <- i + 1 \
      &k <- i - 1
    $]
    Brug heltalsidentiteten (integer division identity) $x = y dot (x mono("div") y) + (x mod y)$.
    *(a)* Kør algoritmen på #swap[$n = 55$] og angiv bittene. \
    *(b)* Bevis invarianten ved hver løkketest: (i) #swap[$n = d dot 2^i + sum_(j=0)^(i-1) b_j dot 2^j$] og (ii) $d >= 0$. \
    *(c)* Vis, at outputtet er $n$'s binære repræsentation. \
    *(d)* Angiv køretiden.
  ],
  answer: [(a) $k = 5$, bits $110111 = 55$. (b) holder ved induktion (induction). (c) ved exit er $d = 0$, så summen er netop $n$. (d) $Theta(log n)$.],
  blueprint: [
    Spejl en sum-invariant: det, der er behandlet, plus det, der er tilbage, giver hele tiden $n$.

    + *Initialisering.* Indsæt startværdierne. Den tomme sum er 0, så højresiden reducerer til #swap[$n$].
    + *Vedligehold.* Brug heltalsidentiteten $d = 2 dot (d mono("div") 2) + (d mod 2)$ til at vise, at den nye tilstand giver samme sum.
    + *Afslutning.* $d$ aftager strengt mod 0. Ved $d = 0$ falder $d dot 2^i$-leddet væk, og summen er #swap[returrepræsentationen].
    + *Køretid.* $d$ halveres hver runde fra $n$ til 0, altså $Theta(log n)$ runder med $O(1)$ arbejde hver.
  ],
  worked: [
    + *(a)* Kør på $n = 55$. Hver runde læser $b_i = d mod 2$ og halverer derefter $d$ med heltalsdivision. Tabellen viser tilstanden lige før hver løkketest, med den bit der skrives i runden:

      ```
      test   i   d    b_i = d mod 2   d div 2
      ----------------------------------------
       1     0  55         1            27
       2     1  27         1            13
       3     2  13         1             6
       4     3   6         0             3
       5     4   3         1             1
       6     5   1         1             0
       7     6   0   <- d = 0, stop; sæt k = i-1 = 5
      ```

      Bittene er $b_0 ... b_5 = 1,1,1,0,1,1$, altså $b_5 b_4 b_3 b_2 b_1 b_0 = 110111$. Tjek: $32+16+4+2+1 = 55$. Svar: $k = 5$, bits $110111$.

    + *(b) Initialisering.* Før første test er $i = 0$, $d = n$, og summen tom, så
      #eq[$ d dot 2^i + sum_(j=0)^(i-1) b_j dot 2^j = n dot 2^0 + 0 = n. $]
      Begge dele holder ved start: (i) er $n = n$, og (ii) er $d = n >= 0$.

    + *(b) Vedligehold.* Antag invarianten ved en test med $d > 0$. Kroppen sætter $b_i = d mod 2$, $d' = d mono("div") 2$, $i' = i + 1$. Heltalsidentiteten med $y = 2$ giver $d = 2 d' + b_i$, så den nye venstreside bliver
      #eq[$ d' dot 2^(i') + sum_(j=0)^(i'-1) b_j dot 2^j = d' dot 2^(i+1) + sum_(j=0)^(i) b_j dot 2^j = 2 d' dot 2^i + b_i dot 2^i + sum_(j=0)^(i-1) b_j dot 2^j. $]
      Sæt $2 d' dot 2^i + b_i dot 2^i = (2 d' + b_i) dot 2^i = d dot 2^i$, og resten er den gamle sum, så udtrykket er $d dot 2^i + sum_(j=0)^(i-1) b_j dot 2^j = n$ pr. antagelsen. (i) er bevaret. For (ii): $d > 0$ heltal giver $d' = d mono("div") 2 >= 0$.

    + *(c) Afslutning.* $d$ er et ikke-negativt heltal (ved (ii)) og aftager strengt, for $d mono("div") 2 < d$ når $d >= 1$. En strengt aftagende følge af ikke-negative heltal kan ikke køre uendeligt, så løkken stopper, og den stopper netop første gang $d = 0$. Sæt $d = 0$ ind i (i): leddet $d dot 2^i$ falder væk, så $n = sum_(j=0)^(i-1) b_j dot 2^j = sum_(j=0)^(k) b_j dot 2^j$ med $k = i - 1$ og hvert $b_j in {0,1}$. Den sidste runde havde $d = 1$ ved indgang, så $b_k = 1 mod 2 = 1$, dvs. ingen førende nul. Outputtet er præcis $n$'s binære repræsentation.

    + *(d) Køretid.* $d$ halveres fra $n$ til 0, hvilket sker efter $floor(log_2 n) + 1$ runder (for $n = 55$ var det 6 runder, jf. tabellen). Hver runde er $O(1)$ arbejde. Svar: $Theta(log n)$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: bevis + aflæs output + køretid (terminering)],
  source: "DM507 juni 2012, Opg. 6 (20%)",
  theory: <th-inv-prove>,
  prompt: [
    `IntegerLog(n)` beregner $floor(log n)$:
    #eq[$
      &k <- 0; quad i <- n \
      &mono("while") i > 1: quad i mono(" lige"): i <- i\/2, k <- k+1; quad mono("ellers"): i <- i - 1 \
      &mono("return") k
    $]
    Givne fakta: $floor(log(n\/2)) = floor(log n) - 1$, og $floor(log(n-1)) = floor(log n)$ for ulige $n$.
    *(a)* Kør på #swap[$n = 53$] og angiv $(i, k)$ ved hver test. \
    *(b)* Bevis invarianten ved hver test: (i) #swap[$floor(log i) + k = floor(log n)$] og (ii) $i$ er et heltal. \
    *(c)* Vis korrekthed: algoritmen returnerer $floor(log n)$. \
    *(d)* Angiv køretiden.
  ],
  answer: [(a) returnerer $k = 5 = floor(log 53)$. (b) holder ved induktion over begge grene. (c) ved exit er $i = 1$, så $k = floor(log n)$. (d) $Theta(log n)$.],
  blueprint: [
    Invarianten balancerer det resterende $floor(log i)$ mod tælleren $k$. Når kroppen har flere grene, så tjek vedligehold for hver.

    + *Initialisering.* Indsæt $i = n$, $k = 0$. Da er #swap[invarianten] $floor(log n) + 0$.
    + *Vedligehold.* Gennemgå lige-grenen (brug $floor(log(i\/2)) = floor(log i) - 1$) og ulige-grenen (brug $floor(log(i-1)) = floor(log i)$) hver for sig.
    + *Afslutning.* $i$ aftager strengt mod 1. Ved $i = 1$ er $floor(log 1) = 0$, så #swap[returværdien] $k = floor(log n)$.
    + *Køretid.* Tæl runderne: $floor(log n)$ halveringer, hver fulgt af højst én $-1$, altså $Theta(log n)$.
  ],
  worked: [
    + *(a)* Kør på $n = 53$. Hver runde: er $i$ lige, halvér og tæl op; er $i$ ulige, træk 1 fra (det gør $i$ lige til næste runde). Tabellen viser $(i, k)$ lige før hver løkketest og hvad grenen gør:

      ```
      test    i    k    gren
      ---------------------------------------
       1     53    0    ulige: i <- 52
       2     52    0    lige:  i <- 26, k <- 1
       3     26    1    lige:  i <- 13, k <- 2
       4     13    2    ulige: i <- 12
       5     12    2    lige:  i <- 6,  k <- 3
       6      6    3    lige:  i <- 3,  k <- 4
       7      3    4    ulige: i <- 2
       8      2    4    lige:  i <- 1,  k <- 5
       9      1    5    i = 1, stop; return k = 5
      ```

      Returnerer $k = 5$. Tjek: $2^5 = 32 <= 53 < 64$, så $floor(log 53) = 5$. ✓

    + *(b) Initialisering.* Før første test: $i = n$, $k = 0$, så (i) er $floor(log i) + k = floor(log n) + 0 = floor(log n)$, og (ii) holder, da $i = n$ er heltal.

    + *(b) Vedligehold.* Antag invarianten ved en test med $i > 1$. Der er to grene:
      - $i$ lige: $i' = i\/2$ er heltal, $k' = k + 1$. Med det givne faktum $floor(log(i\/2)) = floor(log i) - 1$:
        #eq[$ floor(log i') + k' = floor(log(i\/2)) + (k+1) = (floor(log i) - 1) + k + 1 = floor(log i) + k = floor(log n). $]
      - $i$ ulige (og $i > 1$, så $i >= 3$): $i' = i - 1$ er heltal, $k$ uændret. Med $floor(log(i-1)) = floor(log i)$ for ulige $i$:
        #eq[$ floor(log i') + k' = floor(log(i-1)) + k = floor(log i) + k = floor(log n). $]
      Begge grene bevarer (i), og begge holder $i'$ som heltal, så (ii) er bevaret.

    + *(c) Afslutning.* $i$ er et positivt heltal og aftager strengt hver runde (lige-grenen halverer, ulige-grenen trækker 1 fra), så løkken kan ikke køre uendeligt og stopper netop ved $i = 1$. Sæt $i = 1$ i (i): $floor(log 1) + k = floor(log n)$, og $floor(log 1) = 0$, så $k = floor(log n)$. Det er præcis returværdien.

    + *(d) Køretid.* Der er $floor(log n)$ halveringer fra $n$ ned til 1, og mellem to halveringer kan der højst ligge én $-1$ (et $-1$ gør $i$ lige, så næste runde halverer). Altså $<= 2 floor(log n) + O(1)$ runder med $O(1)$ arbejde hver. Svar: $Theta(log n)$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: bevis invariant + aflæs output (terminering)],
  source: "DM507 juni 2009, Opg. 2 (15%)",
  theory: <th-inv-prove>,
  prompt: [
    Betragt `KvadratRod(n)`:
    #eq[$
      &i <- 0; quad s <- 0 \
      &mono("while") s <= n: quad s <- s + 2i + 1; quad i <- i + 1 \
      &r <- i - 1; quad mono("return") r
    $]
    *(a)* Bevis løkkeinvarianten: ved hver løkketest gælder #swap[$s = i^2$]. \
    *(b)* Brug invarianten til at vise, at `KvadratRod` returnerer det største heltal $<= sqrt(n)$, altså #swap[$r = floor(sqrt(n))$].
  ],
  answer: [(a) holder ved induktion. (b) ved exit er $r = i - 1 = floor(sqrt(n))$.],
  blueprint: [
    Bevis invarianten med de tre skridt, og brug den så på exit-testen til at aflæse returværdien.

    + *Initialisering.* Indsæt startværdierne og tjek, at #swap[invarianten] holder.
    + *Vedligehold.* Antag $s = i^2$. Anvend kroppens tildelinger og vis, at det holder igen.
    + *Afslutning.* Kombinér exit-betingelsen med invarianten (som holder ved den fejlende test) og læs #swap[returværdien] af.
  ],
  worked: [
    Hele idéen er, at $s$ altid står på det kvadrattal $i$ peger på, fordi $2i+1$ netop er springet fra $i^2$ til $(i+1)^2$. Her er løkken på $n = 12$ med tilstanden $(i, s)$ lige før hver test. Bemærk at $s = i^2$ i hver række:

    ```
    test   i    s     test s <= 12 ?     krop: s <- s + 2i+1, i <- i+1
    ----------------------------------------------------------------
     1     0    0      0 <= 12 ja         s <- 1,  i <- 1
     2     1    1      1 <= 12 ja         s <- 4,  i <- 2
     3     2    4      4 <= 12 ja         s <- 9,  i <- 3
     4     3    9      9 <= 12 ja         s <- 16, i <- 4
     5     4   16     16 <= 12 nej -> stop; r = i-1 = 3
    ```

    $floor(sqrt(12)) = 3$, og algoritmen giver $r = 3$. Nu beviset.

    + *Initialisering.* Før første test er $i = 0$, $s = 0$, så $s = 0 = 0^2 = i^2$. Invarianten holder.

    + *Vedligehold.* Antag $s = i^2$ ved en test, der består ($s <= n$). Kroppen sætter $s' = s + 2i + 1$ og $i' = i + 1$, så
      #eq[$ s' = i^2 + 2i + 1 = (i+1)^2 = (i')^2. $]
      Altså holder $s' = (i')^2$ ved næste test — invarianten er bevaret.

    + *Afslutning.* $s$ vokser strengt hver runde ($2i + 1 >= 1 > 0$), så $s$ overskrider før eller siden ethvert endeligt $n$, og løkken stopper første gang $s > n$. Ved den fejlende test giver invarianten $i^2 = s > n$, altså $i > sqrt(n)$. Den foregående test bestod, så dengang var $s = (i-1)^2 <= n$, altså $i - 1 <= sqrt(n)$. Tilsammen:
      #eq[$ i - 1 <= sqrt(n) < i quad => quad i - 1 = floor(sqrt(n)). $]
      Svar: $r = i - 1 = floor(sqrt(n))$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: bevis + korrekthed (korrekthed)],
  source: "DM507 juni 2008, Opg. 5 (15%)",
  theory: <th-inv-prove>,
  prompt: [
    `Eksp(a, B)` beregner $a^b$ ud fra bittene af $b$ (MSB$->$LSB, `B[k]` er MSB):
    #eq[$
      &k <- mono("length")(B) - 1; quad c <- 1 \
      &mono("for") i <- k mono(" downto ") 0: \
      &quad c <- c dot c; quad mono("if") B[i] = 1: c <- c dot a \
      &mono("return") c
    $]
    Lad $B_(i+1)$ være tallet dannet af de $k - i$ mest betydende bits af $b$, så $B_(k+1) = 0$ og $B_0 = b$.
    *(a)* Bevis invarianten: ved starten af løkkekroppen (lige efter $i$ er sat) gælder #swap[$c = a^(B_(i+1))$]. \
    *(b)* Konkludér, at `Eksp` returnerer $a^b$.
  ],
  answer: [(a) holder ved induktion via $B_i = 2 B_(i+1) + b_i$. (b) ved exit er $c = a^(B_0) = a^b$; $k+1$ runder, så den stopper.],
  blueprint: [
    Nøglerelationen er $B_i = 2 B_(i+1) + b_i$ (skub præfikset én bit til venstre og tilføj $b_i$), så $a^(B_i) = (a^(B_(i+1)))^2 dot a^(b_i)$ — netop hvad én kropsrunde gør.

    + *Initialisering.* Ved $i = k$ er $c = 1 = a^0 = a^(B_(k+1))$.
    + *Vedligehold.* $c <- c dot c$ kvadrerer; $mono("if") B[i]=1$ ganger med #swap[$a$], så $c$ bliver $a^(B_i)$ — invarianten ved næste $i$.
    + *Afslutning.* Efter runden $i = 0$ er $c = a^(B_0) = a^b$. Løkken kører $k+1$ runder, så den terminerer.
  ],
  worked: [
    + *Konkret kør.* Tag $a = 3$, $b = 13 = 1101_2$, så $k = 3$ og bittene fra MSB er $B = [1,1,0,1]$. $B_(i+1)$ er præfikset af de mest betydende bits, læst som tal. Tabellen viser $c$ (som potens af 3) lige efter hver runde, og at $c = a^(B_i)$ holder:

      ```
      i   B[i]   c <- c*c        if B[i]: c <- c*a     B_i (præfiks)   c
      ----------------------------------------------------------------------
      3    1     3^0 -> 3^0      B=1: 3^0 -> 3^1        1   (1)         3^1
      2    1     3^1 -> 3^2      B=1: 3^2 -> 3^3        11  (3)         3^3
      1    0     3^3 -> 3^6      B=0: ingen             110 (6)         3^6
      0    1     3^6 -> 3^12     B=1: 3^12 -> 3^13      1101(13)        3^13
      ```

      Efter $i = 0$ er $c = 3^13 = a^b$. ✓

    + *(a) Initialisering.* Ved $i = k$, før kroppen kører første gang, er $c = 1$. Invarianten kræver $c = a^(B_(k+1)) = a^0 = 1$, da $B_(k+1) = 0$ (tomt præfiks). Sandt.

    + *(a) Vedligehold.* Antag $c = a^(B_(i+1))$ ved start af runde $i$. Nøglerelationen er $B_i = 2 B_(i+1) + b_i$: at tilføje bit $b_i$ til præfikset svarer til at skifte det ét til venstre (gange med 2) og lægge $b_i$ til. Kroppen:
      - $c <- c dot c$ giver $c = (a^(B_(i+1)))^2 = a^(2 B_(i+1))$.
      - $mono("if") B[i]=1: c <- c dot a$ ganger med $a^(b_i)$ (hvis $b_i = 0$ sker intet, hvilket også er $dot a^0$), så
        #eq[$ c = a^(2 B_(i+1)) dot a^(b_i) = a^(2 B_(i+1) + b_i) = a^(B_i). $]
      Tælleren bliver $i - 1$, og invarianten ved næste runde kræver $c = a^(B_((i-1)+1)) = a^(B_i)$. Passer.

    + *(b) Korrekthed og terminering.* `for`-løkken kører $i = k, k-1, ..., 0$, altså præcis $k + 1$ runder — et endeligt, fast antal, så den stopper. Efter den sidste runde ($i = 0$) giver vedligehold $c = a^(B_0) = a^b$, fordi $B_0 = b$ pr. definition. Det er returværdien. Køretid: $k + 1 = Theta(k) = Theta(log b)$ multiplikationer.
  ],
)

#qcard(
  tag: [Korrekthed ved induktion + opstil køretid (induktion)],
  source: "DM02 jan 2005, Opg. 2 (15%)",
  theory: <th-inv-prove>,
  prompt: [
    Betragt `Mult(a, b)` for positive heltal:
    #eq[$
      &mono("if") a = 1: mono("return") b \
      &mono("else"): mono("return") mono("Mult")(floor(a\/2), 2b) + b dot (a mod 2)
    $]
    *(a)* Bevis ved induktion på $a$, at `Mult(a,b)` returnerer #swap[$a b$]. \
    *(b)* Opstil rekursionsligningen (recurrence equation) for køretiden $T(a)$ og løs den.
  ],
  answer: [(a) $mono("Mult")(a,b) = a b$ ved stærk induktion (strong induction). (b) $T(a) = T(floor(a\/2)) + Theta(1) = Theta(log a)$.],
  blueprint: [
    Bevis korrektheden ved stærk induktion på rekursionsargumentet, og opstil køretiden ved at tælle arbejdet uden for kaldet.

    + *Basis.* Vis påstanden direkte for det mindste argument (her #swap[$a = 1$]).
    + *Skridt.* Antag påstanden for alle mindre argumenter. Erstat det rekursive kald med induktionshypotesen og forenkl mod målet.
    + *Køretid.* Tæl $O(1)$-arbejdet uden for kaldet; argumentet skrumper $a -> floor(a\/2)$. Skriv $T(a) = T(floor(a\/2)) + Theta(1)$ og løs.
  ],
  worked: [
    + *Konkret kør.* $mono("Mult")(6, 7)$ folder ud nedad til basis og samler op på vej tilbage:

      ```
      Mult(6,7)  = Mult(3,14) + 7*(6 mod 2=0) = Mult(3,14) + 0
      Mult(3,14) = Mult(1,28) + 14*(3 mod 2=1) = Mult(1,28) + 14
      Mult(1,28) = 28                              (basis a=1)

      tilbage:  Mult(3,14) = 28 + 14 = 42
                Mult(6,7)  = 42 + 0  = 42 = 6*7   ✓
      ```

    + *(a) Basis.* $a = 1$: algoritmen returnerer $b = 1 dot b$, så påstanden $mono("Mult")(a,b) = a b$ holder.

    + *(a) Skridt.* Lad $a >= 2$ og antag (stærk induktion) at $mono("Mult")(a', b') = a' b'$ for alle $a' < a$ og alle $b'$. Da $floor(a\/2) < a$ for $a >= 2$, giver hypotesen med $a' = floor(a\/2)$ og $b' = 2b$:
      #eq[$ mono("Mult")(floor(a\/2), 2b) = floor(a\/2) dot 2b. $]
      Returværdien fra `else`-grenen er derfor
      #eq[$ floor(a\/2) dot 2b + b dot (a mod 2) = b dot (2 floor(a\/2) + (a mod 2)) = b dot a, $]
      hvor $2 floor(a\/2) + (a mod 2) = a$ er heltalsdivisionsidentiteten ($x = y dot (x mono("div") y) + (x mod y)$ med $y = 2$). Ved induktion gælder $mono("Mult")(a,b) = a b$ for alle $a >= 1$.

    + *(b) Køretid.* Ét kald laver $O(1)$ arbejde (en sammenligning, et `floor`, en multiplikation, en addition) og laver ét rekursivt kald på $floor(a\/2)$. Så
      #eq[$ T(1) = Theta(1), quad T(a) = T(floor(a\/2)) + Theta(1) quad (a >= 2). $]
      Master-sætningen med $a_M = 1$, $b_M = 2$, $f(n) = Theta(1)$: kritisk eksponent $log_(b_M) a_M = log_2 1 = 0$, så $n^(log_b a) = n^0 = 1 = Theta(f(n))$ — tilfælde 2. Altså $T(a) = Theta(n^0 log n) = Theta(log a)$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: hvilke udsagn er invarianter? (løkkeinvariant)],
  source: "DM507 juni 2013, Opg. 6 (10%)",
  theory: <th-inv-decide>,
  prompt: [
    Betragt `Factorial(n)`:
    #eq[$
      &i <- n; quad r <- 1 \
      &mono("while") i > 1: quad r <- r dot i; quad i <- i - 1 \
      &mono("return") r
    $]
    For heltal $n >= 1$, angiv for hvert udsagn, om det er en løkkeinvariant (sandt hver gang while-testen evalueres): (i) #swap[$i >= 1$], (ii) #swap[$r = i!$], (iii) #swap[$r! dot i! = n!$], (iv) #swap[$r = n!\/i!$], (v) #swap[$r = n!$].
  ],
  answer: [Invarianter: (i) og (iv).],
  blueprint: [
    Skriv værdierne ved hver test op og test hver kandidat mod dem.

    + Notér starttilstanden (lige før første test) og hvad kroppen gør ved hver variabel.
    + Tjek #swap[kandidaten] ved første test. Er den falsk dér, ryger den ud.
    + Kør ét gennemløb i hånden og tjek igen. En kandidat, der bryder efter ét skridt, ryger ud.
    + Behold de udsagn, der er sande ved hver test, exit-testen inklusive.
  ],
  worked: [
    Skriv tilstanden $(i, r)$ op ved hver løkketest. Kroppen sætter $r <- r dot i$ og derefter $i <- i - 1$, så efter $m$ runder er $i = n - m$ og $r$ er produktet af de tal, $i$ har stået på indtil nu: $r = n (n-1) dots.c (n-m+1)$, dvs. $r = n! \/ (n-m)!$.

    ```
    test   i       r                     r = n!/i?
    ------------------------------------------------
     1     n       1                      n!/n!
     2     n-1     n                      n!/(n-1)!
     3     n-2     n(n-1)                 n!/(n-2)!
     ...
    sidste 1       n(n-1)...2 = n!        n!/1!
    ```

    Test nu hver kandidat mod tabellen — den skal være sand i *hver* række, exit-testen ($i = 1$) inklusive:

    - *(i)* $i >= 1$: invariant. $i$ løber $n, n-1, ..., 1$ og kommer aldrig under 1 (testen stopper ved $i = 1$, hvor den stadig holder).
    - *(ii)* $r = i!$: nej. Ved første test er $r = 1$, men $i! = n!$, som kun er $1$ når $n = 1$. Falder allerede ved start.
    - *(iii)* $r! dot i! = n!$: nej. Sand ved første test ($1! dot n! = n!$), men efter ét skridt er $(r, i) = (n, n-1)$, og $n! dot (n-1)! != n!$ for $n > 2$. Brydes efter første runde.
    - *(iv)* $r = n!\/i!$: invariant. Det er netop kolonnen længst til højre. Tjek: ved start $n!\/n! = 1 = r$; kroppen ganger $r$ med det aktuelle $i$ og tæller så $i$ ned, hvilket flytter præcis én faktor fra nævneren op i $r$ og bevarer $r = n!\/i!$.
    - *(v)* $r = n!$: nej. Kun sand ved sidste test ($i = 1$); ved start er $r = 1 != n!$ for $n > 1$.

    Svar: (i) og (iv).
  ],
)

#qcard(
  tag: [Løkkeinvariant: hvilke udsagn er invarianter? (løkkeinvariant)],
  source: "jun 2016, Problem 8 (5%)",
  theory: <th-inv-decide>,
  prompt: [
    Betragt `GangeSyv(n)`, som beregner $7n$:
    #eq[$
      &x <- n; quad r <- 0 \
      &mono("while") x > 0: quad x <- x - 1; quad r <- r + 7 \
      &mono("return") r
    $]
    For heltal $n >= 0$, angiv for hvert udsagn, om det er en løkkeinvariant (sandt hver gang while-testen evalueres): (i) #swap[$r = 7n$], (ii) #swap[$r < 7n$], (iii) #swap[$n - x = 7r$], (iv) #swap[$7x + r = 7n$], (v) #swap[$x >= 0$].
  ],
  answer: [Invarianter: (iv) og (v).],
  blueprint: [
    Skriv tilstanden ved hver test op som funktion af rundetælleren og test hver kandidat mod den.

    + Find tilstanden ved den $k$'te test. Her: efter $k$ runder er #swap[$x = n - k$ og $r = 7k$], med $0 <= k <= n$.
    + Tjek #swap[kandidaten] ved første test ($k = 0$). Er den falsk dér, ryger den ud.
    + Tjek den ved exit-testen ($k = n$) og et par mellemtrin. En kandidat, der bryder ét sted, ryger ud.
    + Behold de udsagn, der er sande ved hver test, både første og sidste inklusive.
  ],
  worked: [
    Kroppen sætter $x <- x - 1$ og $r <- r + 7$, så efter $k$ runder er $x = n - k$ og $r = 7k$. Løkken testes for $k = 0, 1, ..., n$ (ved $k = n$ er $x = 0$ og testen fejler). Tabellen:

    ```
    test (k)   x       r       7x + r      x >= 0?
    -----------------------------------------------
       0       n       0        7n          ja
       1      n-1      7        7n          ja
       2      n-2     14        7n          ja
      ...
       n       0      7n        7n          ja (x=0, stop)
    ```

    Test hver kandidat mod hver række, både første ($k = 0$) og exit ($k = n$):

    - *(i)* $r = 7n$: nej. Ved første test ($k = 0$) er $r = 0$, hvilket kun rammer $7n$ når $n = 0$.
    - *(ii)* $r < 7n$: nej. Ved exit-testen ($k = n$) er $r = 7n$, altså ikke strengt mindre.
    - *(iii)* $n - x = 7r$: nej. Her er $n - x = k$, men $7r = 7 dot 7k = 49k$, og $k = 49k$ kun ved $k = 0$. Brydes efter første runde.
    - *(iv)* $7x + r = 7n$: invariant. $7(n - k) + 7k = 7n - 7k + 7k = 7n$ for alle $k$ (kolonnen er konstant $7n$). Det er netop invarianten, der viser korrekthed: ved exit er $x = 0$, så $r = 7n$.
    - *(v)* $x >= 0$: invariant. $x = n - k$ med $k <= n$, så $x >= 0$ ved hver test, inkl. exit hvor $x = 0$.

    Svar: (iv) og (v).
  ],
)
