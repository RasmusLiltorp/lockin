#import "../lib.typ": *

=== Dynamisk programmering (dynamic programming)

De store DP-opgaver fra de skriftlige eksamener. De spørger næsten altid om det samme. Udfyld en tabel ud fra en given rekursion (recurrence), skriv den iterative bottom-up-algoritme med køretid og plads, og argumentér for korrektheden via optimal delstruktur (optimal substructure). Varianterne her dækker strenge, træer, 2-D-bjælker og de opgaver, hvor man bare skal tælle strukturer.

#qcard(
  tag: [DP: udfyld tabel + bottom-up + korrekthed (bottom-up)],
  source: "DM507 juni 2010, Opg. 4 (25%)",
  theory: <th-dp-build>,
  prompt: [
    Vægtet længste fælles delsekvens (longest common subsequence). Tegn $w(a) = #swap[$2$]$, $w(b) = #swap[$4$]$, $w(c) = #swap[$1$]$, $w(d) = #swap[$3$]$, og find den fælles delsekvens af $X$ og $Y$ med størst samlet vægt. $W(i, j)$ er værdien for præfikserne $X_i$ og $Y_j$:
    #eq[$
      W(i, j) = cases(
        0 & "hvis" i = 0 "eller" j = 0,
        max{W(i-1, j), W(i, j-1)} & "hvis" x_i != y_j,
        max{W(i-1, j), W(i, j-1), W(i-1, j-1) + w(x_i)} & "hvis" x_i = y_j,
      )
    $]
    *(a)* Udfyld $W$-tabellen for $X = #swap[$a c b d$]$ og $Y = #swap[$b a c d a$]$. \
    *(b)* Skriv den iterative DP-algoritme og angiv køretid. \
    *(c)* Argumentér for, at rekursionen er korrekt.
  ],
  answer: [(a) $W(4, 5) = #swap[$7$]$ (delsekvensen $b d$, vægt $4 + 3$). (b) $Theta(n m)$ tid og plads. (c) Optimal delstruktur via casen på, om $x_i$ og $y_j$ matches.],
  blueprint: [
    Samme tre nabofelter hver gang: $W[i-1][j]$, $W[i][j-1]$ og diagonalen $W[i-1][j-1]$.

    + *Rand.* Sæt række 0 og søjle 0 til 0 (tom delsekvens har vægt 0).
    + *Udfyld.* Løb $i$ udefra, $j$ indefra. Er $x_i != y_j$, tag max af de to nabofelter. Er $x_i = y_j$, tag også diagonalen plus $w(x_i)$.
    + *Aflæs.* Svaret står i $W[n][m]$.
    + *Korrekthed.* Betragt en optimal fælles delsekvens $Z$. Matcher $Z$ det sidste lige par, så er resten optimal på $X_(i-1), Y_(j-1)$; ellers er den dækket af et af nabofelterne. Max'en dækker begge.
  ],
  worked: [
    $X = a c b d$, $Y = b a c d a$, vægte $w(a) = 2$, $w(b) = 4$, $w(c) = 1$, $w(d) = 3$. Rækker $i = 0..4$ (tegnene i $X$), søjler $j = 0..5$ (tegnene i $Y$). Række 0 og søjle 0 er rand $= 0$.

    Her er hele tabellen. Hver celle er enten max af de to nabofelter (ovenfor $W(i-1,j)$, til venstre $W(i,j-1)$), eller — når $x_i = y_j$ — også diagonalen plus vægten:

    ```
          j=0   b    a    c    d    a
    i=0    0    0    0    0    0    0
    a      0    0    2    2    2    2
    c      0    0    2    3    3    3
    b      0    4    4    4    4    4
    d      0    4    4    4    7    7
    ```

    Udvalgte celler, regnet ud med rekursionen og de faktiske tal:

    + Række $a$, $j = 2$ ($y_2 = a$): $x_1 = a = y_2$, match. $max{W(0,2) = 0, thin W(1,1) = 0, thin W(0,1) + w(a) = 0 + 2 = 2} = 2$. Resten af rækken arver de 2 fra venstre (ingen flere matches mod $a$).
    + Række $c$, $j = 3$ ($y_3 = c$): $x_2 = c = y_3$, match. $max{W(1,3) = 2, thin W(2,2) = 2, thin W(1,2) + w(c) = 2 + 1 = 3} = 3$.
    + Række $b$, $j = 1$ ($y_1 = b$): $x_3 = b = y_1$, match. $max{W(2,1) = 0, thin W(3,0) = 0, thin W(2,0) + w(b) = 0 + 4 = 4} = 4$. Den 4 breder sig til højre i hele rækken.
    + Række $d$, $j = 4$ ($y_4 = d$): $x_4 = d = y_4$, match. $max{W(3,4) = 4, thin W(4,3) = 4, thin W(3,3) + w(d) = 4 + 3 = 7} = 7$.
    + En ikke-match, fx række $d$, $j = 1$ ($x_4 = d != b = y_1$): bare $max{W(3,1) = 4, thin W(4,0) = 0} = 4$.

    Nederste højre celle $W(4, 5) = 7$ er svaret. Backtrack fra $(4,5)$: diagonalen blev brugt ved $b$ (vægt 4) og ved $d$ (vægt 3), så delsekvensen er $b d$ med samlet vægt $4 + 3 = 7$.

    Algoritmen fylder $(n+1)(m+1)$ celler med $O(1)$ arbejde hver, så $Theta(n m)$ tid og plads (reducerbar til $Theta(min(n, m))$ med rullende rækker).

    Svar: $W(4, 5) = 7$.
  ],
)

#qcard(
  tag: [DP: udfyld tabel + bottom-up + korrekthed (bottom-up)],
  source: "DM507 juni 2009, Opg. 5 (25%)",
  theory: <th-dp-build>,
  prompt: [
    Længste palindromiske delsekvens (longest palindromic subsequence). For $S = x_1 ... x_n$ findes længden af den længste delsekvens, der er et palindrom (palindrome). Rekursionen (1-indekseret):
    #eq[$
      "LP"(i, j) = cases(
        0 & "hvis" i > j,
        1 & "hvis" i = j,
        2 + "LP"(i+1, j-1) & "hvis" i < j "og" x_i = x_j,
        max{"LP"(i+1, j), "LP"(i, j-1)} & "hvis" i < j "og" x_i != x_j,
      )
    $]
    *(a)* Udfyld tabellen for $S = #swap[$A L B A$]$. \
    *(b)* Skriv den iterative DP-algoritme. \
    *(c)* Angiv køretid og plads.
  ],
  answer: [(a) $"LP"(1, 4) = #swap[$3$]$ (palindromet $A B A$ eller $A L A$). (b) Fyld efter voksende delstrenglængde. (c) $Theta(n^2)$ tid og plads.],
  blueprint: [
    Kun den øvre trekant $i <= j$ bruges. Fyld efter voksende delstrenglængde, så alle delkald allerede står klar.

    + *Diagonal.* Sæt $L[i][i] = 1$ (én karakter er et palindrom af længde 1).
    + *Voksende længde.* For $"len" = 2..n$ og hvert startindeks $i$ sæt $j = i + "len" - 1$.
    + *Matcher enderne.* Er $x_i = x_j$, så $L[i][j] = 2 + L[i+1][j-1]$ (med $L[i][j] = 2$ når $"len" = 2$). Ellers $max{L[i+1][j], L[i][j-1]}$.
    + *Aflæs.* Svaret er $L[1][n]$.
  ],
  worked: [
    $S = A L B A$, altså $x_1 = A$, $x_2 = L$, $x_3 = B$, $x_4 = A$. Kun den øvre trekant $i <= j$ bruges; fyld efter voksende delstrenglængde, så hvert delkald allerede står klar.

    ```
          j=1  j=2  j=3  j=4
    i=1    1    1    1    3
    i=2    .    1    1    1
    i=3    .    .    1    1
    i=4    .    .    .    1
    ```

    Sådan blev cellerne fyldt, lag for lag:

    + *Længde 1 (diagonalen):* $"LP"(i,i) = 1$ for alle $i$. Én karakter er altid et palindrom.
    + *Længde 2:* $"LP"(1,2)$: $x_1 = A != L = x_2$, så $max{"LP"(2,2) = 1, thin "LP"(1,1) = 1} = 1$. $"LP"(2,3)$: $L != B$, $max{1, 1} = 1$. $"LP"(3,4)$: $B != A$, $max{1, 1} = 1$.
    + *Længde 3:* $"LP"(1,3)$: $x_1 = A != B = x_3$, så $max{"LP"(2,3) = 1, thin "LP"(1,2) = 1} = 1$. $"LP"(2,4)$: $L != A$, $max{"LP"(3,4) = 1, thin "LP"(2,3) = 1} = 1$.
    + *Længde 4:* $"LP"(1,4)$: $x_1 = A = x_4$, match! $2 + "LP"(2,3) = 2 + 1 = 3$. Det indre $"LP"(2,3) = 1$ er allerede regnet (giver enten $B$ eller $L$ som midte), så palindromet er $A B A$ eller $A L A$.

    Svaret står i $L[1][4] = 3$.

    $O(n^2)$ tabelceller à $O(1)$ giver $Theta(n^2)$ tid og $Theta(n^2)$ plads (reducerbar til $Theta(n)$ med to rækker, hvis kun længden ønskes).

    Svar: $"LP"(1, 4) = 3$.
  ],
)

#qcard(
  tag: [DP: udfyld tabel + bottom-up + korrekthed (bottom-up)],
  source: "DM02 januar 2006, Opg. 4 (25%)",
  theory: <th-dp-build>,
  prompt: [
    Strengfletning. $z$ er en flet af $x$ og $y$, hvis $z$ kan dannes ved at flette karaktererne fra $x$ og $y$, så hver streng beholder sin rækkefølge. $T[i][j]$ er sand netop når præfikset $z[1..i+j]$ er en fletning af $x[1..i]$ og $y[1..j]$:
    #eq[$
      T[i][j] = (i > 0 and z[i+j] = x_i and T[i-1][j]) or (j > 0 and z[i+j] = y_j and T[i][j-1])
    $]
    med $T[0][0] = "sand"$. Her er $x = #swap[$a k t$]$, $y = #swap[$b e a t e$]$, $z = #swap[$a b e k a t t e$]$. \
    *(a)* Udfyld sandhedstabellen for $i = 0..3$, $j = 0..5$. \
    *(b)* Hvor mange gange kaldes $"Flet"(x, y, z, #swap[$2$], #swap[$3$])$ i den naive rekursion (uden memoisering (memoization), kortslutning på $or$)? \
    *(c)* Skriv en iterativ DP-algoritme, der afgør om $z$ er en flet, og angiv køretid.
  ],
  answer: [(a) $T[3][5] = "sand"$, så $z$ er en flet. (b) Præcis $#swap[$1$]$ kald. (c) $Theta(n m)$ tid og plads.],
  blueprint: [
    Hver celle ser kun opad ($T[i-1][j]$) og til venstre ($T[i][j-1]$), og kun hvis karakteren i $z$ passer.

    + *Start.* $T[0][0] = "sand"$ (tomme præfikser fletter til den tomme streng).
    + *Udfyld.* For hver $(i, j)$ er cellen sand, hvis $z[i+j]$ matcher $x_i$ og feltet ovenfor er sandt, eller matcher $y_j$ og feltet til venstre er sandt.
    + *Aflæs.* $z$ er en flet netop når $T[n][m]$ er sand.
    + *Naiv optælling.* Følg pseudokoden: kald kun videre når karakteren matcher, og husk at $or$ kortslutter — er venstre gren sand, springes højre over.
  ],
  worked: [
    $x = a k t$ ($n = 3$), $y = b e a t e$ ($m = 5$), $z = a b e k a t t e$. Celle $T[i][j]$ ser på $z[i+j]$: er det $= x_i$ og feltet ovenfor sandt, eller $= y_j$ og feltet til venstre sandt. Rand $T[0][0] = "sand"$ (S = sand, F = falsk):

    ```
          j=0  j=1  j=2  j=3  j=4  j=5
    i=0    S    F    F    F    F    F
    i=1    S    S    S    F    F    F
    i=2    F    F    S    S    S    F
    i=3    F    F    F    S    S    S
    ```

    Udvalgte celler, regnet med rekursionen ($z = a b e k a t t e$, så $z[1..8] = a,b,e,k,a,t,t,e$):

    + $T[0][1]$: $z[1] = a$, men $y_1 = b != a$ og $i = 0$ udelukker $x$-grenen. Falsk. Hele række 0 falder, undtagen randen.
    + $T[1][1]$: $z[2] = b$. $x$-gren: $b != x_1 = a$, nej. $y$-gren: $b = y_1$ og $T[1][0] = S$, ja. Sand.
    + $T[1][2]$: $z[3] = e$. $x$-gren: $e != a$. $y$-gren: $e = y_2$ og $T[1][1] = S$. Sand.
    + $T[2][2]$: $z[4] = k$. $x$-gren: $k = x_2$ og $T[1][2] = S$, ja. Sand. (Her bidrager $x$, ikke $y$.)
    + $T[3][3]$: $z[6] = t$. $x$-gren: $t = x_3$ og $T[2][3] = S$, ja. Sand.
    + $T[3][5]$: $z[8] = e$. $x$-gren: $e != x_3 = t$, nej. $y$-gren: $e = y_5$ og $T[3][4] = S$, ja. Sand — det er nederste højre celle.

    + (a) $T[3][5] = "sand"$, så $a b e k a t t e$ er en fletning af $a k t$ og $b e a t e$.
    + (b) Trace fra $(3, 5)$: $z[8] = e = y_5$, kald $(3, 4)$; $z[7] = t = x_3$, kald $(2, 4)$; $z[6] = t = y_4$, kald $(2, 3)$ — kald nr. 1. Derfra synker stien $(2,3) -> (2,2) -> (1,2) -> (1,1) -> (1,0) -> (0,0)$, alt returnerer sandt og kortslutter opad. Ingen anden gren rammer $(2, 3)$. Svar: $1$ kald.
    + (c) Bottom-up over $(n+1)(m+1)$ celler à $O(1)$ giver $Theta(n m)$ tid og plads (reducerbar til $Theta(min(n, m))$ med rullende række). Det fjerner den eksponentielle eksplosion i den naive rekursion.

    Svar: $T[3][5]$ sand; nøjagtig 1 kald til $"Flet"(...,2,3)$.
  ],
)

#qcard(
  tag: [DP: udfyld tabel + bottom-up + korrekthed (bottom-up)],
  source: "DM02 januar 2005, Opg. 4 (25%)",
  theory: <th-dp-build>,
  prompt: [
    Blokscore. En fælles delsekvens $F$ af strengene $S$ og $T$ deles i færrest mulige blokke $b$, hvor hver blok er en sammenhængende delstreng i både $S$ og $T$. Blokscoren er $|F| - b$, og parrets blokscore er max over alle fælles delsekvenser. $B(i, j)$ er blokscoren af præfikserne $S_i$ og $T_j$:
    #eq[$
      B(i, j) = cases(
        0 & "hvis" i = 0 "eller" j = 0,
        max{B(i, j-1), B(i-1, j)} & "hvis" s_i != t_j,
        max{B(i, j-1), B(i-1, j), B(i - m_(i j), j - m_(i j)) + m_(i j) - 1} & "hvis" s_i = t_j,
      )
    $]
    hvor $m_(i j)$ er længden af det længste fælles suffiks af $S_i$ og $T_j$. \
    *(a)* Udfyld tabellen for $S = #swap[$b b c b a$]$, $T = #swap[$b c c b b a$]$. \
    *(b)* Argumentér for rekursionen. \
    *(c)* Skriv DP-pseudokode og angiv køretid.
  ],
  answer: [(a) $B(5, 6) = #swap[$2$]$ (delsekvensen $b b b a$, blokke $b b | b a$). (b) Optimal delstruktur via casen på matchende suffiks. (c) $O(m n dot min(m, n))$ naivt, $Theta(m n)$ med forberegnet suffiks-tabel.],
  blueprint: [
    Som almindelig LCS, men matchgrenen lægger et helt sammenhængende suffiks på i stedet for én karakter.

    + *Rand.* Række 0 og søjle 0 er 0 (tomt præfiks har score 0).
    + *Ikke-match.* Er $s_i != t_j$, så $max{B(i, j-1), B(i-1, j)}$.
    + *Match.* Er $s_i = t_j$, find det længste fælles suffiks $m_(i j)$ og overvej også $B(i - m_(i j), j - m_(i j)) + m_(i j) - 1$ (en blok på $m_(i j)$ tegn koster netop én blok).
    + *Korrekthed.* En optimal $F$ enten ignorerer det matchende par (de to nabofelter) eller slutter med en blok, der dækker det fælles suffiks (tredje led). Max'en dækker begge.
  ],
  worked: [
    $S = b b c b a$ (rækker $i = 1..5$), $T = b c c b b a$ (søjler $j = 1..6$). Forbereg først suffikstabellen $L[i][j]$ (længste fælles suffiks af $S_i$ og $T_j$): $L[i][j] = L[i-1][j-1] + 1$ ved match, ellers 0.

    ```
    L:    j: b  c  c  b  b  a
    i= b     1  0  0  1  1  0
       b     1  0  0  1  2  0
       c     0  2  1  0  0  0
       b     1  0  0  2  1  0
       a     0  0  0  0  0  2
    ```

    Selve $B$-tabellen. Rand $= 0$. Ved ikke-match: $max$ af nabofelterne. Ved match: også $B[i-m][j-m] + m - 1$ med $m = L[i][j]$:

    ```
          j=0  b  c  c  b  b  a
    i=0    0   0  0  0  0  0  0
    b      0   0  0  0  0  0  0
    b      0   0  0  0  0  1  1
    c      0   0  1  1  1  1  1
    b      0   0  1  1  1  1  1
    a      0   0  1  1  1  1  2
    ```

    Repræsentative celler (blok-leddet for en match med suffikslængde $m$ er $B(i-m, j-m) + m - 1$):

    + $B(2,5)$ ($s_2 = b = t_5$, match, $m = L[2][5] = 2$, suffikset $b b$): kandidater $B(2,4) = 0$, $B(1,5) = 0$, og blok-leddet $B(0, 3) + 2 - 1 = 0 + 1 = 1$. Max $= 1$. (Blokken $b b$ er 2 tegn i én blok, scorer $2 - 1 = 1$.)
    + $B(3,2)$ ($s_3 = c = t_2$, match, $m = L[3][2] = 2$, suffikset $b c$): blok-leddet $B(1, 0) + 2 - 1 = 0 + 1 = 1$, mens nabofelterne $B(3,1) = 0$ og $B(2,2) = 0$. Max $= 1$.
    + $B(5,6)$ ($s_5 = a = t_6$, match, $m = L[5][6] = 2$, suffikset $b a$): nabofelterne $B(5,5) = 1$ og $B(4,6) = 1$; blok-leddet $B(3, 4) + 2 - 1 = 1 + 1 = 2$. Max $= 2$. Her lægges $a$-blokken oven på det $B(3,4) = 1$, der allerede dækker $b b$ — netop delsekvensen $b b b a$ delt $b b | b a$.

    + $B(5, 6) = 2$: den bedste fælles delsekvens er $F = b b b a$, delt i 2 blokke $b b | b a$, begge sammenhængende i $S$ og $T$. Score $|F| - b = 4 - 2 = 2$.
    + Køretid: $Theta(m n)$ celler, men hver matchcelle kan skanne op til $min(i, j)$ tegn tilbage efter $m_(i j)$, så naivt $O(m n dot min(m, n))$. Forbereg suffikslængderne med en ekstra $Theta(m n)$-tabel ($L[i][j] = L[i-1][j-1] + 1$ ved match, ellers 0), så bliver hver celle $O(1)$ og det hele $Theta(m n)$.

    Svar: $B(5, 6) = 2$.
  ],
)

#qcard(
  tag: [DP: udfyld tabel + bottom-up + korrekthed (bottom-up)],
  source: "DM507 januar 2008, Opg. 4 (25%)",
  theory: <th-dp-build>,
  prompt: [
    Ujævnhed. Sorteret følge af positive heltal $X = chevron.l x_1, ..., x_n chevron.r$ og et heltal $W$. Find en delfølge $Y = chevron.l y_1, ..., y_m chevron.r$ med $y_1 = x_1$ og $y_m = x_n$, der minimerer ujævnheden $U = sum_(i=1)^(m-1) (y_(i+1) - y_i - W)^2$. $U(k)$ er den mindste ujævnhed af en delfølge af $chevron.l x_1, ..., x_k chevron.r$ (med $y_1 = x_1$, sluttende i $x_k$):
    #eq[$
      U(k) = min_(1 <= j < k) [U(j) + (x_k - x_j - W)^2], quad U(1) = 0.
    $]
    *(a)* Udfyld $U(k)$ for $X = #swap[$chevron.l 2, 6, 8, 10, 14, 15, 20, 21 chevron.r$]$, $W = #swap[$7$]$. \
    *(b)* Angiv en delfølge med minimal ujævnhed. \
    *(c)* Skriv DP-algoritmen og angiv køretid og plads.
  ],
  answer: [(a) $U(8) = #swap[$2$]$. (b) $Y = #swap[$chevron.l 2, 8, 14, 21 chevron.r$]$ med $U = 2$. (c) $O(n^2)$ tid, $O(n)$ plads.],
  blueprint: [
    Hver $U(k)$ kigger tilbage på alle mulige forgængere $x_j$ og tager den billigste.

    + *Start.* $U(1) = 0$ (ét element, ingen led).
    + *Udfyld.* For $k = 2..n$ minimér $U(j) + (x_k - x_j - W)^2$ over alle $j < k$.
    + *Gem forgænger.* Notér det argmin-$j$, der gav minimum, i et $"pred"$-array.
    + *Backtrack.* Følg $"pred"$ fra $k = n$ tilbage til 1 for at læse delfølgen.
  ],
  worked: [
    $X = chevron.l 2, 6, 8, 10, 14, 15, 20, 21 chevron.r$, $W = 7$. $U(k)$ kigger tilbage på hver forgænger $j < k$ og tager $min_j [U(j) + (x_k - x_j - W)^2]$. $U(1) = 0$.

    ```
    k:      1   2   3   4   5   6   7   8
    x_k:    2   6   8  10  14  15  20  21
    U(k):   0   9   1   1   2   1   3   2
    pred:   -   1   1   1   3   3   5   5
    ```

    Hver $U(k)$ regnet ud (kun de led, der konkurrerer om minimum):

    + $U(2)$: kun $j = 1$. $U(1) + (6-2-7)^2 = 0 + (-3)^2 = 9$. pred $= 1$.
    + $U(3)$: $j=1$: $0 + (8-2-7)^2 = (-1)^2 = 1$. $j=2$: $9 + (8-6-7)^2 = 9 + 25 = 34$. Min $= 1$, pred $= 1$.
    + $U(4)$: $j=1$: $0 + (10-2-7)^2 = 1$. $j=3$: $1 + (10-8-7)^2 = 1 + 25 = 26$. Min $= 1$, pred $= 1$.
    + $U(5)$: $j=3$: $1 + (14-8-7)^2 = 1 + 1 = 2$. $j=4$: $1 + (14-10-7)^2 = 1 + 9 = 10$. Min $= 2$, pred $= 3$.
    + $U(6)$: $j=3$: $1 + (15-8-7)^2 = 1 + 0 = 1$. Min $= 1$, pred $= 3$.
    + $U(7)$: $j=5$: $2 + (20-14-7)^2 = 2 + 1 = 3$. $j=6$: $1 + (20-15-7)^2 = 1 + 4 = 5$. Min $= 3$, pred $= 5$.
    + $U(8)$: $j=5$: $2 + (21-14-7)^2 = 2 + 0 = 2$. $j=6$: $1 + (21-15-7)^2 = 1 + 1 = 2$. $j=7$: $3 + (21-20-7)^2 = 3 + 36 = 39$. Min $= 2$, pred $= 5$.
    + (b) Følg argmin-forgængerne fra $k = 8$: $8 <- 5 <- 3 <- 1$, altså $x$-værdierne $21, 14, 8, 2$. Delfølge $Y = chevron.l 2, 8, 14, 21 chevron.r$ med $U = 1 + 1 + 0 = 2$.
    + (c) Dobbeltløkken kører $sum_(k=2)^n (k-1) = O(n^2)$ iterationer à konstant arbejde, så $O(n^2)$ tid og $O(n)$ plads (et $U$-array, plus et $"pred"$-array, hvis delfølgen skal findes).

    Svar: $U(8) = 2$, $Y = chevron.l 2, 8, 14, 21 chevron.r$.
  ],
)

#qcard(
  tag: [DP: udfyld tabel + bottom-up + korrekthed (bottom-up)],
  source: "jun 2016, Problem 10 (12%)",
  theory: <th-dp-build>,
  prompt: [
    Mindste antal kvadrater. For $n >= 0$ er $K(n)$ det mindste antal heltal, hvis kvadrater summer til $n$:
    #eq[$
      K(0) = 0, quad K(n) = 1 + min{K(n - a^2) : a >= 1, a^2 <= n} quad "for" n >= 1.
    $]
    *(a)* Angiv $K(#swap[$19$])$ og en måde at skrive #swap[$19$] som så mange kvadrater. \
    *(b)* Skriv en DP-algoritme, der beregner $K(n)$, med tid og plads. \
    *(c)* Udvid den til også at uddrage de $k = K(n)$ kvadrater. \
    *(d)* Argumentér for, at rekursionen er korrekt.
  ],
  answer: [(a) $K(19) = #swap[$3$]$, fx $19 = 1^2 + 3^2 + 3^2$. (b) $Theta(n^(3 slash 2))$ tid, $Theta(n)$ plads. (c) Gem det minimerende $a$ pr. $m$ og gå tilbage. (d) Optimal delstruktur via cut-and-paste på ét led.],
  blueprint: [
    1-D tabel $"dp"[0..n]$, fyldt nedefra. Hver indgang prøver alle kvadrater $a^2 <= m$.

    + *Start.* $"dp"[0] = 0$ (den tomme sum er 0).
    + *Udfyld.* For $m = 1..n$ sæt $"dp"[m] = 1 + min_(a^2 <= m) "dp"[m - a^2]$.
    + *Recover.* Gem $"choice"[m] = $ det $a$, der gav minimum; gå fra $m = n$ tilbage og udskriv $a$, sæt $m <- m - a^2$.
    + *Korrekthed.* En optimal løsning for $n$ fjerner ét led $a^2$ og efterlader en optimal løsning for $n - a^2$ (cut-and-paste).
  ],
  worked: [
    Byg $"dp"[0..19]$ nedefra. $"dp"[0] = 0$; for hvert $m$ prøves alle kvadrater $a^2 <= m$, og $"dp"[m] = 1 + min_a "dp"[m - a^2]$. $"choice"[m]$ gemmer det vindende $a$:

    ```
    m:        0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19
    dp[m]:    0  1  2  3  1  2  3  4  2  1  2  3  3  2  3  4  1  2  2  3
    choice:   -  1  1  1  2  1  1  1  2  3  1  1  2  2  1  1  4  1  3  1
    ```

    Repræsentative indgange:

    + $"dp"[4]$: $a=1$ giver $1 + "dp"[3] = 1 + 3 = 4$; $a=2$ giver $1 + "dp"[0] = 1$. Min $= 1$, choice $= 2$. ($4 = 2^2$.)
    + $"dp"[9]$: $a=1: 1 + "dp"[8] = 3$; $a=2: 1 + "dp"[5] = 3$; $a=3: 1 + "dp"[0] = 1$. Min $= 1$, choice $= 3$.
    + $"dp"[19]$: $a=1: 1 + "dp"[18] = 1 + 2 = 3$; $a=2: 1 + "dp"[15] = 1 + 4 = 5$; $a=3: 1 + "dp"[10] = 1 + 2 = 3$; $a=4: 1 + "dp"[3] = 1 + 3 = 4$. Min $= 3$, choice $= 1$.

    Så $K(19) = 3$. Walk via $"choice"$: $m = 19 -> a = 1$, $m = 18 -> a = 3$, $m = 9 -> a = 3$, $m = 0$. Altså $19 = 1^2 + 3^2 + 3^2 = 1 + 9 + 9$. To led er umuligt (intet par kvadrater summer til 19), så minimum er 3.

    + (b) Pseudokode:
      #eq[$
        &"dp"[0] <- 0 \
        &mono("for") m = 1 mono("to") n: \
        &quad "dp"[m] <- min_(a >= 1, thin a^2 <= m) (1 + "dp"[m - a^2])
      $]
      Den indre løkke kører $floor(sqrt(m)) <= sqrt(n)$ gange, så $sum_(m=1)^n sqrt(m) = Theta(n sqrt(n)) = Theta(n^(3 slash 2))$ tid og $Theta(n)$ plads.
    + (c) Gem $"choice"[m] = a$ ved hvert minimum. Walk: $m = n$; mens $m > 0$, udskriv $a = "choice"[m]$ og sæt $m <- m - a^2$. For $n = 19$ giver det $a = 1, 3, 3$. Ekstra $Theta(n)$ plads, uændret samlet kompleksitet.
    + (d) Optimal delstruktur: en optimal $n = a_1^2 + ... + a_k^2$ med $k = K(n)$ giver, når et led $a_k$ fjernes, en repræsentation af $n - a_k^2$ med $k - 1$ kvadrater, så $K(n) >= 1 + min_a K(n - a^2)$. Omvendt giver enhver $a$ plus en optimal løsning for $n - a^2$ en løsning med $1 + K(n - a^2)$ led, så $K(n) <= 1 + min_a K(n - a^2)$. Ligheden følger.

    Svar: $K(19) = 3$.
  ],
)

#qcard(
  tag: [DP på 2-D bjælke (optimale delproblemer)],
  source: "DM507 juni 2013, Opg. 7 (18%)",
  theory: <th-dp-build>,
  prompt: [
    2-D opskæring. En $i times j$ chokoladebjælke skæres langs hele furer i mindre rektangulære bjælker; en $k times l$ bjælke sælges for $P(k, l)$. $C(i, j)$ er den bedste samlede salgsværdi af en $i times j$ bjælke:
    #eq[$
      C(i, j) = max cases(
        P(i, j) \,,
        max_(1 <= s < i) (C(s, j) + C(i-s, j)) & "(vandret snit)" \,,
        max_(1 <= t < j) (C(i, t) + C(i, j-t)) & "(lodret snit)" \,,
      )
    $]
    (randene dropper de snitretninger, der ikke findes; $C(1, 1) = P(1, 1)$). \
    *(a)* Udfyld $4 times 4$-tabellen $C$ for #swap[$P$] givet nedenfor. \
    *(b)* Beskriv DP-algoritmen og angiv tid og plads. \
    *(c)* Argumentér for rekursionen.
  ],
  answer: [(a) $C(4, 4) = #swap[$22$]$. (b) $Theta(n m (n + m))$ tid, $Theta(n m)$ plads. (c) Optimal delstruktur via case på det første snit.],
  blueprint: [
    Fyld i voksende areal: hver celle ser kun på mindre bjælker, der allerede er beregnet.

    + *Grundværdi.* Start hver celle som $P(i, j)$ (sælg hele bjælken usnittet).
    + *Vandrette snit.* For $s = 1..i-1$ prøv $C(s, j) + C(i-s, j)$.
    + *Lodrette snit.* For $t = 1..j-1$ prøv $C(i, t) + C(i, j-t)$.
    + *Korrekthed.* Et optimalt snit gør enten intet ($P(i, j)$) eller har et første snit, der går helt igennem; de to delbjælker skæres uafhængigt og optimalt.
  ],
  worked: [
    Priser #swap[$P$]:

    #align(center)[
      #table(
        columns: 5,
        align: center,
        stroke: none,
        inset: (x: 8pt, y: 4pt),
        table.header([$k slash l$], [1], [2], [3], [4]),
        table.hline(stroke: 0.4pt + hair),
        [1], [1], [2], [3], [4],
        [2], [2], [5], [7], [9],
        [3], [3], [8], [10], [12],
        [4], [5], [8], [17], [21],
      )
    ]

    Fyld $C$ i voksende areal. Hver celle starter som $P(i,j)$ (sælg usnittet) og prøver så alle vandrette snit $C(s,j)+C(i-s,j)$ og lodrette snit $C(i,t)+C(i,j-t)$. Resultattabel:

    ```
    C:    j=1  j=2  j=3  j=4
    i=1    1    2    3    4
    i=2    2    5    7   10
    i=3    3    8   11   16
    i=4    5   10   17   22
    ```

    Repræsentative celler:

    + $C(2,4)$: $P(2,4) = 9$; lodret $t=2$: $C(2,2) + C(2,2) = 5 + 5 = 10$; lodret $t=1$: $C(2,1)+C(2,3) = 2 + 7 = 9$; vandret $s=1$: $C(1,4)+C(1,4) = 4 + 4 = 8$. Max $= 10$ (del på langs i to $2 times 2$).
    + $C(3,3)$: $P(3,3) = 10$; lodret $t=1$: $C(3,1)+C(3,2) = 3 + 8 = 11$; vandret $s=1$: $C(1,3)+C(2,3) = 3 + 7 = 10$. Max $= 11$.
    + $C(4,4)$: $P(4,4) = 21$; lodret $t=1$: $C(4,1)+C(4,3) = 5 + 17 = 22$; alle vandrette og øvrige lodrette snit giver $<= 21$. Max $= 22$ (skær en $4 times 1$-strimmel af for 5 og sælg resten $4 times 3$ for 17).

    + (b) $n m$ celler, hver med $O(i) + O(j) = O(n + m)$ arbejde i de to snitløkker. Tid $Theta(n m (n + m))$, plads $Theta(n m)$.
    + (c) Et optimalt snit er enten ingen snit (sælg for $P(i, j)$) eller har et første snit, der går helt igennem — vandret ved række $s$ eller lodret ved søjle $t$. Bagefter skæres de to delbjælker uafhængigt og hver for sig optimalt, så de bidrager $C(s, j) + C(i-s, j)$ hhv. $C(i, t) + C(i, j-t)$. Max over alt giver rekursionen.

    Svar: $C(4, 4) = 22$.
  ],
)

#qcard(
  tag: [DP på rodfæstet træ (optimale delproblemer)],
  source: "DM507 juni 2008, Opg. 6 (25%)",
  theory: <th-dp-build>,
  prompt: [
    Sti-dækning af et vægtet binært træ. En sti-dækning er en delmængde $X$ af knuder, så hver rod-til-blad-sti indeholder netop én knude fra $X$. Maksimér den samlede vægt. $W(x)$ er den optimale vægt for deltræet med rod $x$:
    #eq[$
      W(x) = cases(
        w(x) & "hvis" x "er et blad",
        max(w(x), sum_(c "barn af" x) W(c)) & "hvis" x "er intern".
      )
    $]
    Tegn #swap[Figur 6]: rod $a:12$ med børn $b:8$ og $c:10$; $b$ har børn $d:2$ og $e:2$; $c$ har børn $f:5$ og $g:7$; $g$ har børn $h:6$ og $i:4$. \
    *(a)* Udfyld $W$-tabellen. \
    *(b)* Angiv en optimal sti-dækning. \
    *(c)* Skriv DP-algoritmen og angiv tid og plads.
  ],
  answer: [(a) $W(a) = #swap[$23$]$. (b) $X = #swap[${b, f, h, i}$]$, vægt 23. (c) $Theta(n)$ tid og plads.],
  blueprint: [
    Post-order (post-order traversal): beregn børnene før knuden, og vælg pr. knude mellem "tag $x$" og "tag intet her".

    + *Blad.* $W(x) = w(x)$ (den eneste sti gennem $x$ må vælge $x$).
    + *Intern.* $W(x) = max(w(x), sum_c W(c))$: enten vælg $x$ selv, eller lad børnenes deltræer løse hver sin sti uafhængigt og læg sammen.
    + *Rekonstruér.* Top-down: er $W(x) = w(x)$ og det slog børnesummen, vælg $x$ og stop; ellers gå ned i børnene.
    + *Korrekthed.* Hver rod-til-blad-sti går gennem netop ét barn, så børnenes valg er uafhængige givet valget i $x$.
  ],
  worked: [
    Blade først, så op mod roden:

    + Blade: $W(d) = 2$, $W(e) = 2$, $W(f) = 5$, $W(h) = 6$, $W(i) = 4$.
    + $W(g) = max(7, W(h) + W(i)) = max(7, 10) = 10$.
    + $W(b) = max(8, W(d) + W(e)) = max(8, 4) = 8$.
    + $W(c) = max(10, W(f) + W(g)) = max(10, 15) = 15$.
    + $W(a) = max(12, W(b) + W(c)) = max(12, 23) = 23$.

    #align(center)[
      #table(
        columns: 10,
        align: center,
        stroke: none,
        inset: (x: 6pt, y: 4pt),
        table.header([$x$], [$a$], [$b$], [$c$], [$d$], [$e$], [$f$], [$g$], [$h$], [$i$]),
        table.hline(stroke: 0.4pt + hair),
        [$W(x)$], [*23*], [8], [15], [2], [2], [5], [10], [6], [4],
      )
    ]

    + (b) Top-down: ved $a$ vinder børnesummen $23 > 12$, gå ned. Ved $b$ slår $w = 8$ børnesummen $4$, vælg $b$. Ved $c$ vinder $15 > 10$, gå ned: vælg $f$ (blad); ved $g$ vinder $10 > 7$, gå ned og vælg $h$ og $i$. Dækning $X = {b, f, h, i}$, vægt $8 + 5 + 6 + 4 = 23$.
    + (c) Post-order, $O(1)$ arbejde pr. knude (konstant plus sum af to børn) giver $Theta(n)$ tid; $W$-tabellen plus rekursionsstak giver $Theta(n)$ plads.

    Svar: $W(a) = 23$, $X = {b, f, h, i}$.
  ],
)

#qcard(
  tag: [DP på rodfæstet træ (optimale delproblemer)],
  source: "DM507 juni 2011, Opg. 5 (25%)",
  theory: <th-dp-build>,
  prompt: [
    Maksimum-vægt uafhængig mængde (maximum-weight independent set) i et rodfæstet træ (rooted tree). Hver knude har en positiv vægt. En mængde er uafhængig, hvis den ikke indeholder to naboer (er $x$ med, er hverken $x$'s børn eller forælder med). To værdier pr. knude:
    #eq[$
      "With"[x] &= w[x] + sum_(c "barn") "Without"[c], \
      "Without"[x] &= sum_(c "barn") max("With"[c], "Without"[c]).
    $]
    Svaret er $max("With"["rod"], "Without"["rod"])$. \
    Tegn #swap[T2]: rod $a(1)$ med børn $b(2)$, $c(5)$, $d(4)$; $b$ har børn $e(2)$ og $f(3)$; $c$ er et blad; $d$ har barn $g(2)$; $e$ har barn $h(4)$. \
    *(a)* Udfyld With/Without-tabellen. \
    *(b)* Angiv en uafhængig mængde af maksimal vægt. \
    *(c)* Skriv DP-algoritmen og angiv tid og plads.
  ],
  answer: [(a) Se tabellen; $max("With"[a], "Without"[a]) = #swap[$16$]$. (b) ${c, d, f, h}$, vægt 16. (c) $Theta(n)$ tid og plads.],
  blueprint: [
    To værdier pr. knude i én post-order: bedste vægt hvis $x$ tages, og hvis $x$ udelades.

    + *With.* Tag $x$: så er ingen børn med, og hvert barn bidrager $"Without"[c]$.
    + *Without.* Udelad $x$: hvert barn må selv vælge sit bedste, $max("With"[c], "Without"[c])$.
    + *Svar.* $max("With"["rod"], "Without"["rod"])$.
    + *Rekonstruér.* Top-down: ved hver knude se, om With eller Without realiserede max'en, og vælg børnenes muligheder derefter.
  ],
  worked: [
    Blade først, så op mod roden:

    + Blade $c, f, g, h$: With $=$ egen vægt, Without $= 0$.
    + $e$: With $= w[e] + "Without"[h] = 2 + 0 = 2$; Without $= max("With"[h], "Without"[h]) = 4$.
    + $b$: With $= 2 + "Without"[e] + "Without"[f] = 2 + 4 + 0 = 6$; Without $= max(2, 4) + max(3, 0) = 7$.
    + $d$: With $= 4 + "Without"[g] = 4$; Without $= max(2, 0) = 2$.
    + $a$: With $= 1 + "Without"[b] + "Without"[c] + "Without"[d] = 1 + 7 + 0 + 2 = 10$; Without $= max(6, 7) + max(5, 0) + max(4, 2) = 7 + 5 + 4 = 16$.

    #align(center)[
      #table(
        columns: 9,
        align: center,
        stroke: none,
        inset: (x: 6pt, y: 4pt),
        table.header([$x$], [$a$], [$b$], [$c$], [$d$], [$e$], [$f$], [$g$], [$h$]),
        table.hline(stroke: 0.4pt + hair),
        [With], [10], [6], [5], [4], [2], [3], [2], [4],
        [Without], [*16*], [7], [0], [2], [4], [0], [0], [0],
      )
    ]

    + (b) Roden: $max(10, 16) = 16$ ved at udelade $a$. Spor pr. barn: $b$ udelades ($7 > 6$), $c$ inkluderes, $d$ inkluderes; under $b$ udelades $e$ og inkluderes $f$; under $e$ inkluderes $h$; under $d$ udelades $g$. Mængde ${c, d, f, h}$, vægt $5 + 4 + 3 + 4 = 16$.
    + (c) Én post-order, $O(1)$ arbejde pr. (knude, barn)-par; antallet af par er $n - 1$ kanter, så $Theta(n)$ tid. To arrays plus rekursionsstak giver $Theta(n)$ plads.

    Svar: $16$, realiseret af ${c, d, f, h}$.
  ],
)

#qcard(
  tag: [DP på rodfæstet træ (optimale delproblemer)],
  source: "DM507 januar 2007, Opg. 5 (30%)",
  theory: <th-dp-build>,
  prompt: [
    Parsimoni på et binært træ (small phylogeny / Fitch). Et binært træ, hvor hver knude har 0 eller 2 børn; hvert blad holder et tegn fra alfabetet $Sigma$. Tildel tegn til de interne knuder, så antallet af overgangskanter (kanter, hvis to ender har forskellige tegn) minimeres. Pr. knude:
    #eq[$
      "Cost"(k, a) = min_b ["trans"(a, b) + "Cost"("venstre", b)] + min_b ["trans"(a, b) + "Cost"("højre", b)],
    $]
    hvor $"trans"(a, b) = 0$ hvis $a = b$, ellers 1; blad: 0 hvis dets tegn er $a$, ellers $infinity$. Svar $= min_a "Cost"("rod", a)$. \
    Tegn træet: rod $x_1 -> (x_2, x_3)$; $x_2 -> (x_4, "blad" x_5 = C)$; $x_3 -> ("blad" x_6 = A, "blad" x_7 = C)$; $x_4 -> ("blad" x_8 = A, "blad" x_9 = B)$; $Sigma = #swap[${A, B, C}$]$. \
    *(a)* Tildel tegn, der minimerer overgangskanter. \
    *(b)* Hvor mange gange kaldes $"Cost"$ med #swap[$x_4$] som argument i den naive rekursion? \
    *(c)* Vis, at den naive $"TotalCost"$ kører i $Omega(|Sigma|^(log_2 n))$. \
    *(d)* Omskriv med DP og angiv tid og plads.
  ],
  answer: [(a) Minimum $#swap[$3$]$ overgangskanter (fx alle interne $= C$). (b) $#swap[$27$]$ kald. (c) En knude i dybde $d$ får $|Sigma|^(d+1)$ kald; et balanceret træ giver $Omega(|Sigma|^(log_2 n))$. (d) $Theta(n |Sigma|^2)$ tid, $Theta(n |Sigma|)$ plads.],
  blueprint: [
    Bottom-up tabel $C[1..n][1..|Sigma|]$: kun $n dot |Sigma|$ distinkte delproblemer, som den naive rekursion genberegner eksponentielt mange gange.

    + *Blad.* $C[k][a] = 0$ hvis bladets tegn er $a$, ellers $infinity$.
    + *Intern.* For hvert tegn $a$ tag $min_b ("trans"(a, b) + C["venstre"][b]) + min_b ("trans"(a, b) + C["højre"][b])$.
    + *Svar.* $min_a C["rod"][a]$, rekonstruér top-down ved at vælge de minimerende tegn.
    + *Naiv optælling.* Rod-kaldet giver $|Sigma|$ kald; hvert internt $"Cost"$-kald udløser $|Sigma|$ kald pr. barn. En knude i dybde $d$ får $|Sigma|^(d+1)$ kald.
  ],
  worked: [
    Interne knuder: $x_1, x_2, x_3, x_4$. Blade: $x_5 = C, x_6 = A, x_7 = C, x_8 = A, x_9 = B$.

    + (a) Fyld DP-tabellen $C[k][a]$ i post-order. Blade: $0$ for eget tegn, $infinity$ ellers. Intern knude: $C[k][a] = min_b ("trans"(a,b) + C["v"][b]) + min_b ("trans"(a,b) + C["h"][b])$.

    ```
    Knude    C[.][A]  C[.][B]  C[.][C]
    x8 (A)      0       inf      inf
    x9 (B)     inf       0       inf
    x5 (C)     inf      inf       0
    x6 (A)      0       inf      inf
    x7 (C)     inf      inf       0
    x4           1        1        2
    x3           1        2        1
    x2           2        2        2
    x1           3        4        3
    ```

    Repræsentative interne knuder:

    + $x_4$ (børn $x_8 = A$, $x_9 = B$): for $a = A$ er venstre $min_b("trans"(A,b) + C[x_8][b]) = "trans"(A,A) + 0 = 0$ og højre $min_b("trans"(A,b) + C[x_9][b]) = "trans"(A,B) + 0 = 1$, så $C[x_4][A] = 0 + 1 = 1$. For $a = C$: venstre $"trans"(C,A) + 0 = 1$, højre $"trans"(C,B) + 0 = 1$, sum $2$.
    + $x_3$ (børn $x_6 = A$, $x_7 = C$): for $a = C$ er venstre $"trans"(C,A) + 0 = 1$, højre $"trans"(C,C) + 0 = 0$, så $C[x_3][C] = 1$. For $a = A$: $0 + "trans"(A,C) = 0 + 1 = 1$.
    + $x_1$ (børn $x_2$, $x_3$): for $a = C$ er venstre $min_b("trans"(C,b) + C[x_2][b]) = "trans"(C,C) + 2 = 2$, højre $min_b("trans"(C,b) + C[x_3][b]) = "trans"(C,C) + 1 = 1$, så $C[x_1][C] = 2 + 1 = 3$.

    Svaret er $min_a C[x_1][a] = min(3, 4, 3) = 3$. Et minimerende valg: alle interne knuder $= C$, hvilket giver overgangskanterne $x_3 - x_6 (C slash A)$, $x_4 - x_8 (C slash A)$, $x_4 - x_9 (C slash B)$ — netop 3.
    + (b) $x_4$ ligger i dybde 2 ($x_1 -> x_2 -> x_4$), så kald $= |Sigma|^(2+1) = 3^3 = 27$.
    + (c) En knude i dybde $d$ får $|Sigma|^(d+1)$ kald à $>= 1$ arbejde. Et balanceret fuldt binært træ har højde $h = Theta(log_2 n)$, og de dybeste knuder alene får $|Sigma|^(h+1) >= |Sigma|^(log_2 n)$ kald. Altså $T(n) in Omega(|Sigma|^(log_2 n))$. Bemærk $|Sigma|^(log_2 n) = n^(log_2 |Sigma|)$ — polynomielt i $n$, men med eksponent voksende i $|Sigma|$.
    + (d) Fyld $C$ i post-order. Hver intern knude beregner $|Sigma|$ indgange, hver et $min$ over $|Sigma|$ for venstre og $|Sigma|$ for højre barn, så $Theta(|Sigma|^2)$ pr. knude. Med $n$ knuder: $Theta(n |Sigma|^2)$ tid og $Theta(n |Sigma|)$ plads.

    Svar: 3 overgangskanter; 27 kald; $Omega(|Sigma|^(log_2 n))$; DP $Theta(n |Sigma|^2)$ tid.
  ],
)

#qcard(
  tag: [Tæl strukturer (Catalan, heap, BST)],
  source: "jun 2016, Problem 7 (9%)",
  theory: <th-dp-build>,
  prompt: [
    Tæl binære træer. \
    *(a)* Hvor mange former har et binært træ med #swap[$3$] knuder? \
    *(b)* Hvor mange træer med 3 knuder og nøglerne #swap[$1, 2, 3$] overholder max-heap-orden (max-heap order) (forælder $>=$ børn)? \
    *(c)* Hvor mange overholder inorder (in-order) (binær søgetræ-orden)? \
    *(d)* Hvor mange overholder begge?
  ],
  answer: [(a) $#swap[$5$]$ ($C_3$). (b) $#swap[$6$]$. (c) $#swap[$5$]$. (d) $#swap[$1$]$.],
  blueprint: [
    Skeln formen (Catalan-tal, Catalan numbers) fra mærkningen (heap/BST-betingelser).

    + *Former.* Antal binære træformer på $n$ knuder er Catalan-tallet $C_n = 1/(n+1) binom(2n, n)$.
    + *Max-heap.* Roden er tvunget til at være maksimum; gennemgå hver form og tæl gyldige mærkninger.
    + *BST.* Inorder fastlægger hvilken nøgle der sidder hvor, så der er præcis ét BST pr. form.
    + *Begge.* Kun den venstre-kæde, hvor max er rod og nøglerne falder ned ad kæden, opfylder både BST og heap.
  ],
  worked: [
    + (a) $C_3 = 1/4 binom(6, 3) = 20 slash 4 = 5$ former.
    + (b) Roden tvinges til 3. De 4 kædeformer tvinger $3 > 2 > 1$ (1 mærkning hver $= 4$); den balancerede form lader ${1, 2}$ frit bytte børn ($= 2$). I alt $4 + 2 = 6$.
    + (c) Inorder fastlægger nøglerne pr. form, så præcis ét BST pr. form: $5$.
    + (d) I et BST er højre barn altid større, hvilket bryder max-heap, medmindre der intet højre barn er. Kun venstre-kæden $3 -> 2 -> 1$ opfylder begge: inorder giver $1, 2, 3$ og heap $3 > 2 > 1$. Svar $1$.

    Svar: 5, 6, 5, 1.
  ],
)

#qcard(
  tag: [Tæl strukturer (Catalan, heap, BST)],
  source: "DM507 juni 2008, Opg. 4 (10%)",
  theory: <th-dp-build>,
  prompt: [
    Tæl strukturer. \
    *(a)* Skriv alle binære min-heaps (min-heaps) på prioriteterne #swap[$1, 2, 3, 4$]. \
    *(b)* Skriv alle binære søgetræer af højde #swap[$2$] med nøglerne #swap[$1, 2, 3, 4$].
  ],
  answer: [(a) $#swap[$3$]$ min-heaps. (b) $#swap[$6$]$ BST'er af højde 2.],
  blueprint: [
    + *Heap-formen.* Et 4-knuders binært heap har fast (komplet) form: rod, to børn, ét barnebarn under venstre barn.
    + *Heap-orden.* Roden tvinges til at være globalt minimum; placér resten, så forælder $<$ barn.
    + *BST-højde.* Højde 2 betyder længste rod-til-blad-sti har 2 kanter. Generér alle BST'er (vælg hver nøgle som rod, rekursér på nøgleintervaller) og behold dem med højde 2.
    + *Tæl.* Antal BST'er på 4 distinkte nøgler er $C_4 = 14$; behold dem af højde 2.
  ],
  worked: [
    + (a) Roden tvinges til 1. Den faste form (rod, to børn, barnebarn under venstre barn) udfyldes med ${2, 3, 4}$, så forælder $<$ barn. Det giver 3 heaps (array $[$rod, venstre, højre, barnebarn$]$): $[1, 2, 3, 4]$, $[1, 2, 4, 3]$, $[1, 3, 2, 4]$.
    + (b) Af de $C_4 = 14$ BST'er har 6 højde 2 (resten er højde-3 zig-zag-stier). I $"nøgle"("venstre", "højre")$-notation: $1(., 3(2, 4))$, $2(1, 3(., 4))$, $2(1, 4(3, .))$, $3(1(., 2), 4)$, $3(2(1, .), 4)$, $4(2(1, 3), .)$.

    Svar: 3 min-heaps; 6 BST'er af højde 2.
  ],
)
