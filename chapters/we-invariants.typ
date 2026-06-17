#import "../lib.typ": *

=== Løkkeinvarianter (loop invariants), korrekthed og køretid

De skriftlige eksamener vender den samme skabelon igen og igen: en lille iterativ eller rekursiv algoritme, hvor du skal bevise en løkkeinvariant (loop invariant) med initialisering (initialization)/vedligehold (maintenance)/afslutning (termination), bruge den til at aflæse returværdien, og til sidst sætte køretiden (running time). Et par af opgaverne spørger i stedet, hvilke udsagn der faktisk *er* invarianter.

#qcard(
  tag: [Løkkeinvariant: bevis + aflæs output + køretid],
  source: "DM507 juni 2010, Opg. 3 (25%)",
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
    + *(a)* $n = 55$: $d$ løber $55, 27, 13, 6, 3, 1$, og bittene bliver $b_0 ... b_5 = 1,1,1,0,1,1$. Stop ved $d = 0$, så $k = 5$ og $b_5 b_4 b_3 b_2 b_1 b_0 = 110111$. Tjek: $32+16+4+2+1 = 55$.

    + *(b) Initialisering.* Før første test er $i = 0$, $d = n$, og summen tom, så
      #eq[$ d dot 2^i + sum_(j=0)^(i-1) b_j dot 2^j = n dot 2^0 + 0 = n. $]
      $d = n >= 0$, så (ii) holder.

    + *(b) Vedligehold.* Antag invarianten ved en test med $d > 0$. Kroppen sætter $b_i = d mod 2$, $d' = d mono("div") 2$, $i' = i + 1$. Med identiteten er $d = 2 d' + b_i$, så
      #eq[$ d' dot 2^(i') + sum_(j=0)^(i'-1) b_j dot 2^j = (2 d' + b_i) dot 2^i + sum_(j=0)^(i-1) b_j dot 2^j = d dot 2^i + sum_(j=0)^(i-1) b_j dot 2^j = n. $]
      $d > 0$ heltal giver $d' >= 0$.

    + *(c) Afslutning.* $d$ er et ikke-negativt heltal og aftager strengt ($d mono("div") 2 < d$ for $d >= 1$), så løkken stopper ved $d = 0$. Invarianten giver da $n = sum_(j=0)^(k) b_j dot 2^j$ med hvert $b_j in {0,1}$. Den sidste runde havde $d = 1$ ved indgang, så $b_k = 1$ — ingen førende nul. Outputtet er præcis $n$'s binære form.

    + *(d) Køretid.* $approx floor(log_2 n) + 1 = Theta(log n)$ runder, $O(1)$ arbejde hver. Svar: $Theta(log n)$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: bevis + aflæs output + køretid],
  source: "DM507 juni 2012, Opg. 6 (20%)",
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
    + *(a)* $n = 53$: $(i, k)$ ved testene er $(53,0), (52,0), (26,1), (13,2), (12,2), (6,3), (3,4), (2,4), (1,5)$. Stop ved $i = 1$, returnerer $k = 5$. Tjek: $2^5 = 32 <= 53 < 64$.

    + *(b) Initialisering.* Før første test: $i = n$, $k = 0$, så $floor(log i) + k = floor(log n)$. $i = n$ er heltal.

    + *(b) Vedligehold.* Antag invarianten ved en test med $i > 1$.
      - $i$ lige: $i' = i\/2$ (heltal), $k' = k + 1$, så
        #eq[$ floor(log(i\/2)) + (k+1) = (floor(log i) - 1) + k + 1 = floor(log i) + k = floor(log n). $]
      - $i$ ulige ($i >= 3$): $i' = i - 1$ (heltal), $k$ uændret, og $floor(log(i-1)) = floor(log i)$, så summen er bevaret.

    + *(c) Afslutning.* Hvert skridt tæller det positive heltal $i$ strengt ned, så løkken stopper ved $i = 1$. Invarianten giver $floor(log 1) + k = floor(log n)$, og $floor(log 1) = 0$, så $k = floor(log n)$.

    + *(d) Køretid.* Mellem to halveringer er der højst én $-1$, og der er $floor(log n)$ halveringer fra $n$ til 1. Altså $<= 2 floor(log n) + O(1) = Theta(log n)$ runder. Svar: $Theta(log n)$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: bevis invariant + aflæs output],
  source: "DM507 juni 2009, Opg. 2 (15%)",
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
    + *Initialisering.* Før første test er $i = 0$, $s = 0$, så $s = 0 = 0^2 = i^2$.

    + *Vedligehold.* Antag $s = i^2$. Kroppen sætter $s' = s + 2i + 1$ og $i' = i + 1$, så
      #eq[$ s' = i^2 + 2i + 1 = (i+1)^2 = (i')^2. $]

    + *Afslutning.* Løkken stopper første gang $s > n$. Invarianten giver $i^2 = s > n$, så $i > sqrt(n)$. Forrige test gik igennem, så $(i-1)^2 <= n$, altså $i - 1 <= sqrt(n)$. Dermed
      #eq[$ i - 1 <= sqrt(n) < i quad => quad i - 1 = floor(sqrt(n)). $]
      Svar: $r = i - 1 = floor(sqrt(n))$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: bevis + korrekthed],
  source: "DM507 juni 2008, Opg. 5 (15%)",
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
    + *(a) Initialisering.* Ved $i = k$, før kroppen, er $c = 1$. Invarianten kræver $c = a^(B_(k+1)) = a^0 = 1$. Sandt.

    + *(a) Vedligehold.* Antag $c = a^(B_(i+1))$ ved start af runde $i$. Kroppen:
      - $c <- c dot c$ giver $c = (a^(B_(i+1)))^2 = a^(2 B_(i+1))$.
      - $mono("if") B[i]=1: c <- c dot a$ ganger med $a^(b_i)$, så
        #eq[$ c = a^(2 B_(i+1)) dot a^(b_i) = a^(2 B_(i+1) + b_i) = a^(B_i). $]
      Tælleren bliver $i - 1$, og invarianten ved næste runde kræver $c = a^(B_((i-1)+1)) = a^(B_i)$. Passer.

    + *(b) Korrekthed.* Løkken kører $i = k, k-1, ..., 0$, altså $k + 1$ runder — endeligt, så den stopper. Efter runden $i = 0$ giver vedligehold $c = a^(B_0) = a^b$, og det returneres. Køretid: $Theta(k) = Theta(log b)$ multiplikationer.
  ],
)

#qcard(
  tag: [Korrekthed ved induktion + opstil køretid],
  source: "DM02 jan 2005, Opg. 2 (15%)",
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
    + *(a) Basis.* $a = 1$: returnerer $b = 1 dot b$.

    + *(a) Skridt.* $a >= 2$: antag $mono("Mult")(a', b') = a' b'$ for alle $a' < a$. Da $floor(a\/2) < a$, giver hypotesen $mono("Mult")(floor(a\/2), 2b) = floor(a\/2) dot 2b$. Returværdien er
      #eq[$ 2b dot floor(a\/2) + b dot (a mod 2) = b dot (2 floor(a\/2) + (a mod 2)) = b dot a, $]
      hvor $2 floor(a\/2) + (a mod 2) = a$ er heltalsdivisionsidentiteten. Ved induktion gælder $mono("Mult")(a,b) = a b$ for alle $a >= 1$.

    + *(b) Køretid.* $T(1) = Theta(1)$ og $T(a) = T(floor(a\/2)) + Theta(1)$ for $a >= 2$. Argumentet halveres hvert niveau, så dybden er $approx log_2 a$ med $O(1)$ arbejde per niveau. Master Theorem med $a_M = 1$, $b_M = 2$, $f(n) = Theta(1)$: $n^(log_b a) = n^0 = 1 = f$, tilfælde 2, altså $T(a) = Theta(log a)$.
  ],
)

#qcard(
  tag: [Løkkeinvariant: hvilke udsagn er invarianter?],
  source: "DM507 juni 2013, Opg. 6 (10%)",
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
    Værdierne ved testen er $(i, r) = (n, 1)$, så $(n-1, n)$, $(n-2, n(n-1))$, og videre ned til $(1, n!)$.

    - *(i)* $i >= 1$: invariant. $i$ løber $n, n-1, ..., 1$ og kommer aldrig under 1.
    - *(ii)* $r = i!$: nej. Ved første test er $r = 1$, men $i! = n!$.
    - *(iii)* $r! dot i! = n!$: nej. Sand ved første test ($1! dot n! = n!$), men efter ét skridt er $(r, i) = (n, n-1)$, og $n! dot (n-1)! != n!$ for $n > 2$.
    - *(iv)* $r = n!\/i!$: invariant. Ved første test er $n!\/n! = 1 = r$. Kroppen sætter $r <- r dot i$ og tæller $i$ ned, hvilket bevarer det.
    - *(v)* $r = n!$: nej. Kun sand ved sidste test; $r = 1$ i starten.

    Svar: (i) og (iv).
  ],
)

#qcard(
  tag: [Løkkeinvariant: hvilke udsagn er invarianter?],
  source: "jun 2016, Problem 8 (5%)",
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
    Ved den $k$'te test ($k = 0, 1, ..., n$) er $x = n - k$ og $r = 7k$, med $0 <= k <= n$.

    - *(i)* $r = 7n$: nej. Ved første test ($k = 0$) er $r = 0$, hvilket kun rammer $7n$ når $n = 0$.
    - *(ii)* $r < 7n$: nej. Ved exit-testen ($k = n$) er $r = 7n$, altså ikke strengt mindre.
    - *(iii)* $n - x = 7r$: nej. $n - x = k$, men $7r = 49k$, og de er kun ens ved $k = 0$.
    - *(iv)* $7x + r = 7n$: invariant. $7(n - k) + 7k = 7n$ for alle $k$. Det er netop invarianten, der viser korrekthed.
    - *(v)* $x >= 0$: invariant. $x = n - k$ med $k <= n$, så $x >= 0$ ved hver test.

    Svar: (iv) og (v).
  ],
)
