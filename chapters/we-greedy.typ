#import "../lib.typ": *

=== Grådige (greedy) problemer: Huffman og træer

De grådige eksamensopgaver er af to slags. Huffman-opgaverne beder dig bygge træet ved at flette de to mindste igen og igen, og derfra læse koder af, regne den kodede størrelse eller afkode en bitstreng. Et par af dem spørger også, hvilke optimale træer Huffman faktisk kan frembringe. Den anden slags er grådige træalgoritmer som mindste knude-overdækning (minimum vertex cover), hvor du skal bevise korrektheden med et ombytningsargument (exchange argument) og bagefter give en lineær implementation.

#qcard(
  tag: [Huffman: byg træ og læs koder (Huffman-træ)],
  source: "DM507 jan 2007, Opg. 2a (8%)",
  theory: <th-greedy-huffman>,
  prompt: [Tegn Huffman-træet for alfabetet #swap[${a,b,c,d,e,f}$ med frekvenser $a=33$, $b=28$, $c=52$, $d=20$, $e=10$, $f=12$]. Angiv en kode pr. symbol.],
  answer: [Kodelængder $a=2, b=2, c=2, d=3, e=4, f=4$. Fx $b=00, a=01, c=11, d=100, e=1010, f=1011$. Selve 0/1-mærkningen er ikke entydig.],
  blueprint: [
    Samme tre skridt hver gang. Kun #swap[frekvenstabellen] (frequency table) skifter.

    + *Lav løvene.* Læg ét løv pr. symbol med dets frekvens (frequency) i en min-prioritetskø (min-priority queue).
    + *Flet to mindste.* Gentag til ét træ er tilbage: udtræk de to mindste noder, lav en intern node med vægt = summen og dem som børn, indsæt den igen.
    + *Mærk kanter.* Venstre $= 0$, højre $= 1$. Et symbols kode er strengen fra rod til løv.
  ],
  worked: [
    Sortér løvene efter frekvens og læg dem i køen. Hvert skridt trækker de to forreste (mindste) ud, fletter dem til en node med deres sum, og indsætter den på rette plads. Køens tilstand vises før og efter hver fletning:

    ```
    Start (sorteret): [ e10  f12  d20  b28  a33  c52 ]

    Flet e10 + f12 = 22:
      udtræk e10, f12  ->  ny node {ef}22
      kø: [ d20  {ef}22  b28  a33  c52 ]

    Flet d20 + {ef}22 = 42:
      udtræk d20, {ef}22  ->  ny node {def}42
      kø: [ b28  a33  {def}42  c52 ]

    Flet b28 + a33 = 61:
      udtræk b28, a33  ->  ny node {ba}61
      kø: [ {def}42  c52  {ba}61 ]

    Flet {def}42 + c52 = 94:
      udtræk {def}42, c52  ->  ny node {defc}94
      kø: [ {ba}61  {defc}94 ]

    Flet {ba}61 + {defc}94 = 155:  (rod)
      kø: [ {bafdec}155 ]
    ```

    Mærk hver venstrekant $0$ og hver højrekant $1$ og læs rod-til-løv-stierne: $b=00, a=01, c=11, d=100, e=1010, f=1011$. Det er multimængden af kodelængder ($2,2,2,3,4,4$), der er fastlagt; den enkelte 0/1-streng kan variere med side-valget.
  ],
)

#qcard(
  tag: [Huffman: byg træ og læs koder (Huffman-træ)],
  source: "DM507 jan 2008, Opg. 1a (8%)",
  theory: <th-greedy-huffman>,
  prompt: [Tegn et Huffman-træ for alfabetet #swap[$a,b,c,d,e,f,g$ med frekvenser $a=9$, $b=7$, $c=24$, $d=10$, $e=55$, $f=15$, $g=25$].],
  answer: [Kodelængder $e=1, c=3, g=3, b=a=d=f=4$. Samlet $= 366$ bit. 0/1-tildelingen pr. kant er ikke entydig.],
  blueprint: [
    Samme tre skridt som altid. Kun #swap[frekvenstabellen] skifter.

    + *Lav løvene.* Ét løv pr. symbol med dets frekvens i en min-prioritetskø.
    + *Flet to mindste.* Udtræk de to mindste, lav en intern node med vægt = summen og dem som børn, indsæt igen. Gentag til ét træ.
    + *Mærk og læs.* Venstre $= 0$, højre $= 1$. Symbolets kode er rod-til-løv-strengen.
  ],
  worked: [
    Sortér løvene efter frekvens og læg dem i køen. Hvert skridt udtrækker de to mindste, fletter dem til summen og indsætter på rette plads:

    ```
    Start (sorteret): [ b7  a9  d10  f15  c24  g25  e55 ]

    Flet b7 + a9 = 16:
      udtræk b7, a9  ->  ny node {ba}16
      kø: [ d10  f15  {ba}16  c24  g25  e55 ]

    Flet d10 + f15 = 25:
      udtræk d10, f15  ->  ny node {df}25
      kø: [ {ba}16  c24  g25  {df}25  e55 ]

    Flet {ba}16 + c24 = 40:
      udtræk {ba}16, c24  ->  ny node {bac}40
      kø: [ g25  {df}25  {bac}40  e55 ]

    Flet g25 + {df}25 = 50:
      udtræk g25, {df}25  ->  ny node {gdf}50
      kø: [ {bac}40  {gdf}50  e55 ]

    Flet {bac}40 + {gdf}50 = 90:
      udtræk {bac}40, {gdf}50  ->  ny node {bacgdf}90
      kø: [ e55  {bacgdf}90 ]

    Flet e55 + 90 = 145:  (rod)
      kø: [ {e bacgdf}145 ]
    ```

    Mærk venstre $0$, højre $1$ og læs koderne: $e=0$, $c=101$, $g=110$, $b=1000$, $a=1001$, $d=1110$, $f=1111$. Kodelængder: $e=1$; $c,g=3$; $b,a,d,f=4$. Samlet $= 9 dot 4 + 7 dot 4 + 24 dot 3 + 10 dot 4 + 55 dot 1 + 15 dot 4 + 25 dot 3 = 36 + 28 + 72 + 40 + 55 + 60 + 75 = 366$ bit.
  ],
)

#qcard(
  tag: [Huffman: byg træ og læs koder (Huffman-træ)],
  source: "DM507 juni 2010, Opg. 1b (5%)",
  theory: <th-greedy-huffman>,
  prompt: [Angiv et Huffman-træ for alfabetet med frekvenser #swap[$a=300$, $b=150$, $c=75$, $d=125$, $e=200$, $f=50$, $g=100$].],
  answer: [Kodelængder $a=2, e=2, b=3, d=3, g=3, c=4, f=4$. Samlet (vægtet stilængde) $= 2625$ bit.],
  blueprint: [
    De samme tre skridt. Husk: den samlede bitlængde er summen af alle interne noders vægte.

    + *Lav løvene.* Ét løv pr. symbol i en min-prioritetskø efter #swap[frekvens].
    + *Flet to mindste.* Udtræk de to mindste, sammenlæg til ny intern node, indsæt igen. Gentag til ét træ.
    + *Mærk og tæl.* Venstre $= 0$, højre $= 1$. Vægtet stilængde (weighted path length) $= sum_c "freq"(c) dot |"kode"(c)|$.
  ],
  worked: [
    Sortér løvene efter frekvens og kør køen ned. Hvert skridt udtrækker de to mindste, fletter til summen og indsætter på rette plads:

    ```
    Start (sorteret): [ f50  c75  g100  d125  b150  e200  a300 ]

    Flet f50 + c75 = 125:
      udtræk f50, c75  ->  ny node {fc}125
      kø: [ g100  d125  {fc}125  b150  e200  a300 ]

    Flet g100 + d125 = 225:
      udtræk g100, d125  ->  ny node {gd}225
      kø: [ {fc}125  b150  e200  {gd}225  a300 ]

    Flet {fc}125 + b150 = 275:
      udtræk {fc}125, b150  ->  ny node {fcb}275
      kø: [ e200  {gd}225  {fcb}275  a300 ]

    Flet e200 + {gd}225 = 425:
      udtræk e200, {gd}225  ->  ny node {egd}425
      kø: [ {fcb}275  a300  {egd}425 ]

    Flet {fcb}275 + a300 = 575:
      udtræk {fcb}275, a300  ->  ny node {fcba}575
      kø: [ {egd}425  {fcba}575 ]

    Flet {egd}425 + {fcba}575 = 1000:  (rod)
      kø: [ {egdfcba}1000 ]
    ```

    Mærk venstre $0$, højre $1$. Én kode: $a=11, e=00, b=101, d=011, g=010, c=1001, f=1000$. Vægtet stilængde $= 300 dot 2 + 200 dot 2 + 150 dot 3 + 125 dot 3 + 100 dot 3 + 75 dot 4 + 50 dot 4 = 600 + 400 + 450 + 375 + 300 + 300 + 200 = 2625$ bit.
  ],
)

#qcard(
  tag: [Huffman: byg træ og læs koder (Huffman-træ)],
  source: "DM507 juni 2014, Opg. 6 (6%)",
  theory: <th-greedy-huffman>,
  prompt: [Byg et Huffman-træ for frekvenserne #swap[$a:400$, $e:750$, $i:300$, $o:150$, $u:200$, $y:100$ (i alt $1900$)]. Angiv hvert kodeord og den samlede kodede længde.],
  answer: [Kodelængder $e=1, u=3, i=3, a=3, y=4, o=4$. Samlet $= 4450$ bit.],
  blueprint: [
    De samme tre skridt. Den samlede længde er summen af de interne noders vægte.

    + *Lav løvene.* Ét løv pr. symbol i en min-prioritetskø efter #swap[frekvens].
    + *Flet to mindste.* Udtræk de to mindste, sammenlæg, indsæt igen. Gentag til ét træ.
    + *Mærk og tæl.* Venstre $= 0$, højre $= 1$. Samlet $= sum_c "freq"(c) dot |"kode"(c)|$.
  ],
  worked: [
    Sortér løvene efter frekvens og kør køen ned. Hvert skridt udtrækker de to mindste, fletter til summen og indsætter på rette plads:

    ```
    Start (sorteret): [ y100  o150  u200  i300  a400  e750 ]

    Flet y100 + o150 = 250:
      udtræk y100, o150  ->  ny node {yo}250
      kø: [ u200  {yo}250  i300  a400  e750 ]

    Flet u200 + {yo}250 = 450:
      udtræk u200, {yo}250  ->  ny node {uyo}450
      kø: [ i300  a400  {uyo}450  e750 ]

    Flet i300 + a400 = 700:
      udtræk i300, a400  ->  ny node {ia}700
      kø: [ {uyo}450  {ia}700  e750 ]

    Flet {uyo}450 + {ia}700 = 1150:
      udtræk {uyo}450, {ia}700  ->  ny node {uyoia}1150
      kø: [ e750  {uyoia}1150 ]

    Flet e750 + 1150 = 1900:  (rod)
      kø: [ {e uyoia}1900 ]
    ```

    Mærk venstre $0$, højre $1$. Én kode: $e=0, u=100, i=110, a=111, y=1010, o=1011$. Samlet $= 750 dot 1 + 200 dot 3 + 100 dot 4 + 150 dot 4 + 300 dot 3 + 400 dot 3 = 750 + 600 + 400 + 600 + 900 + 1200 = 4450$ bit.
  ],
)

#qcard(
  tag: [Huffman: byg træ og læs koder (Huffman-træ)],
  source: "jun 2016, Problem 5 (7%)",
  theory: <th-greedy-huffman>,
  prompt: [Byg et Huffman-træ for frekvenserne #swap[$x:1000$, $y:200$, $z:600$, "æ":$800$, "ø":$300$, "å":$400$ (i alt $3300$)]. Angiv en kode pr. tegn og den samlede kodede længde i bit.],
  answer: [Kodelængder $x=2, z=2, "æ"=2, "å"=3, y=4, "ø"=4$. Samlet $= 8000$ bit.],
  blueprint: [
    De samme tre skridt. Genvej: samlet bitlængde $=$ summen af alle interne noders frekvenser.

    + *Lav løvene.* Ét løv pr. symbol i en min-prioritetskø efter #swap[frekvens].
    + *Flet to mindste.* Udtræk de to mindste, sammenlæg, indsæt igen. Gentag til ét træ.
    + *Mærk og tæl.* Venstre $= 0$, højre $= 1$. Samlet $= sum_c "freq"(c) dot |"kode"(c)|$.
  ],
  worked: [
    Sortér løvene efter frekvens og kør køen ned. Hvert skridt udtrækker de to mindste, fletter til summen og indsætter på rette plads:

    ```
    Start (sorteret): [ y200  ø300  å400  z600  æ800  x1000 ]

    Flet y200 + ø300 = 500:
      udtræk y200, ø300  ->  ny node {yø}500
      kø: [ å400  {yø}500  z600  æ800  x1000 ]

    Flet å400 + {yø}500 = 900:
      udtræk å400, {yø}500  ->  ny node {åyø}900
      kø: [ z600  æ800  {åyø}900  x1000 ]

    Flet z600 + æ800 = 1400:
      udtræk z600, æ800  ->  ny node {zæ}1400
      kø: [ {åyø}900  x1000  {zæ}1400 ]

    Flet {åyø}900 + x1000 = 1900:
      udtræk {åyø}900, x1000  ->  ny node {åyøx}1900
      kø: [ {zæ}1400  {åyøx}1900 ]

    Flet {zæ}1400 + {åyøx}1900 = 3300:  (rod)
      kø: [ {zæåyøx}3300 ]
    ```

    Mærk venstre $0$, højre $1$. Én kode: $x=11, z=00, "æ"=01, "å"=100, y=1010, "ø"=1011$. Samlet $= 1000 dot 2 + 800 dot 2 + 600 dot 2 + 400 dot 3 + 200 dot 4 + 300 dot 4 = 2000 + 1600 + 1200 + 1200 + 800 + 1200 = 8000$ bit. Genvejen — summen af alle interne noders vægte — giver det samme: $500 + 900 + 1400 + 1900 + 3300 = 8000$.
  ],
)

#qcard(
  tag: [Huffman: kodet størrelse, afkodning, frembringelige træer (producerbart)],
  source: "DM507 juni 2012, Opg. 5 (15%)",
  theory: <th-greedy-producerbar>,
  prompt: [
    Frekvenser #swap[$a=100$, $b=150$, $c=150$, $d=250$, $e=350$ (i alt $1000$)]. Træet $H_1$ giver koderne #swap[$b=00, d=01, e=11, a=100, c=101$]. \
    *(a)* Hvor mange bit fylder filen kodet med $H_1$? \
    *(b)* Afkod bitstrengen #swap[$1000000110110101$] med $H_1$. \
    *(c)* Fire andre optimale træer #swap[$H_2, ..., H_5$] har samme kostpris. Afgør hvilke af dem Huffman-algoritmen overhovedet kan frembringe.
  ],
  answer: [(a) $2250$ bit. (b) `abbedcd`. (c) Kun de træer, hvis interne vægte er præcis ${250, 400, 600, 1000}$ — i kilden $H_2$ og $H_5$.],
  blueprint: [
    Tre underspørgsmål, tre vaner.

    + *(a) Kostpris.* $sum_c "freq"(c) dot "depth"(c)$, eller summen af de interne noders vægte.
    + *(b) Afkod.* Gå fra roden, følg hver bit ($0=$ venstre, $1=$ højre). Ved et løv: udskriv symbolet og gå tilbage til roden.
    + *(c) Frembringelig?* Huffman fletter altid de to *aktuelt mindste* vægte. Regn de tvungne flettevægte fra frekvenserne; et træ er frembringeligt netop hvis dets multimængde af interne vægte matcher.
  ],
  worked: [
    *(a)* Koderne $b=00, d=01, e=11$ har længde $2$; $a=100, c=101$ har længde $3$. Vægt hver med sin frekvens:
    #eq[$ "kost" = underbrace(150 dot 2 + 250 dot 2 + 350 dot 2, b\,d\,e) + underbrace(100 dot 3 + 150 dot 3, a\,c) = 300 + 500 + 700 + 300 + 450 = 2250 thin "bit". $]

    *(b)* Afkodning er ét gennemløb af strengen $1000000110110101$. Gå fra roden, følg hver bit, og når en kode rammer et løv: udskriv tegnet og start forfra ved roden. Med koderne $a=100, b=00, c=101, d=01, e=11$:

    ```
    rest af streng         læst kode   tegn   output
    1000000110110101       100         a      a
    0000110110101          00          b      ab
    00110110101            00          b      abb
    110110101              11          e      abbe
    0110101                01           d      abbed
    10101                  101          c      abbedc
    01                     01           d      abbedcd
    (tom)                  --           --     abbedcd
    ```

    Resultat: `abbedcd`. Ingen overskydende bit.

    *(c)* Huffman er tvunget: køen starter sorteret, og hvert skridt fletter de to mindste. På ${100,150,150,250,350}$:

    ```
    Start (sorteret): [ 100  150  150  250  350 ]

    Flet 100 + 150 = 250:   kø: [ 150  250  250  350 ]
    Flet 150 + 250 = 400:   kø: [ 250  350  400 ]
    Flet 250 + 350 = 600:   kø: [ 400  600 ]
    Flet 400 + 600 = 1000:  kø: [ 1000 ]  (rod)
    ```

    De interne vægte er altså tvunget til multimængden ${250, 400, 600, 1000}$. Et optimalt træ er frembringeligt af Huffman netop hvis dets interne noders vægte udgør præcis denne multimængde. Tjek hver kandidat $H_2, ..., H_5$: matcher multimængden, er træet frembringeligt; dukker der fx to $500$-noder op, har træet parret to vægte ($150{+}350$ og $100{+}250$ eller lignende), som Huffman aldrig ville vælge på dét trin — så det er ikke frembringeligt, selv om kostprisen er optimal. (I kilden: $H_2, H_5$ ja; $H_3, H_4$ nej.)
  ],
)

#qcard(
  tag: [Huffman: afkod bitstreng],
  source: "DM507 jan 2007, Opg. 2b (7%)",
  theory: <th-greedy-huffman>,
  prompt: [Brug det givne Huffman-træ #swap[(rod: $0 -> a$, $1 -> X$; $X$: $0 -> Y$, $1 -> f$; $Y$: $0 -> P$, $1 -> Q$; $P$: $0 -> b$, $1 -> c$; $Q$: $0 -> d$, $1 -> e$)] til at afkode bitstrengen #swap[$1101001010101011$].],
  answer: [`facade`. Ingen overskydende bit.],
  blueprint: [
    Afkodning er et rent træ-gennemløb.

    + *Find koderne (valgfrit).* Læs hvert symbols rod-til-løv-streng af træet, fx $a=0, f=11, b=1000, ...$
    + *Gå fra roden.* Følg hver bit: $0=$ venstre, $1=$ højre.
    + *Ved et løv.* Udskriv symbolet og start forfra ved roden. Gentag til strengen er brugt op.
  ],
  worked: [
    Læs først koderne af træet ved at følge hver rod-til-løv-sti (venstre $=0$, højre $=1$):

    ```
    rod -0-> a                  a = 0
    rod -1-> X -1-> f           f = 11
    rod -1-> X -0-> Y -0-> P -0-> b   b = 1000
    rod -1-> X -0-> Y -0-> P -1-> c   c = 1001
    rod -1-> X -0-> Y -1-> Q -0-> d   d = 1010
    rod -1-> X -0-> Y -1-> Q -1-> e   e = 1011
    ```

    Afkod nu $1101001010101011$. Gå fra roden, følg hver bit, og udskriv tegnet ved hvert løv:

    ```
    rest af streng         læst kode   tegn   output
    1101001010101011       11          f      f
    01001010101011         0           a      fa
    1001010101011          1001        c      fac
    010101011              0           a      faca
    10101011               1010        d      facad
    1011                   1011        e      facade
    (tom)                  --          --     facade
    ```

    Afkodet tekst: `facade`. Ingen bit bliver til overs.
  ],
)

#qcard(
  tag: [Grådig på træer: mindste knude-overdækning (ombytningsargument)],
  source: "DM507 juni 2009, Opg. 4 (20%)",
  theory: <th-greedy-exchange>,
  prompt: [
    En knude-overdækning af $G = (V, E)$ er en delmængde $V' subset.eq V$, så hver kant rører mindst én knude i $V'$. Vi vil have en *mindste* knude-overdækning af et træ. Lad $e(v)$ være kanterne, der rører $v$. Betragt algoritmen:
    #eq[$
      &V' <- emptyset \
      &mono("while") E != emptyset: \
      &quad "vælg en knude" v "med et barn" u "uden børn (et løv)" \
      &quad V' <- V' union {v}; quad E <- E - e(v) \
      &mono("return") V'
    $]
    *(a)* Bevis, at algoritmen finder en mindste knude-overdækning. \
    *(b)* Giv en implementation, der kører i #swap[$O(n)$].
  ],
  answer: [(a) Korrekt via ombytningsargument: en forælder $v$ er mindst lige så god som løvet $u$, plus induktion på resttræet. (b) Post-order DFS (post-order depth-first search), der lægger $v$ i $V'$ når en kant til et barn stadig er udækket; $O(n)$.],
  blueprint: [
    Et grådigt korrekthedsbevis på træer har tre dele, og implementationen er et bottom-up-gennemløb.

    + *Overdækning / terminering.* Løkken fjerner kanter, til $E = emptyset$, og hver fjernet kant rørte en valgt knude. Altså er $V'$ en overdækning.
    + *Ombytning (grådigt valg).* Tag et løv $u$ med forælder $v$. Kanten $(u,v)$ skal dækkes, så enhver overdækning $C$ rummer $u$ eller $v$. Vis $C' = C - {u} + {v}$ stadig dækker og ikke er større — $v$ er mindst lige så god.
    + *Induktion (optimal delstruktur).* Efter $v$ er valgt og $e(v)$ slettet, er resten en mindre instans; induktion afslutter.
    + *Lineær implementation.* Rod træet, behandl knuder bottom-up (post-order DFS). Hold `inCover[v]` og om kanten til forælderen er dækket. Hver knude og kant ses konstant mange gange $-> O(n)$.
  ],
  worked: [
    *(a)*
    + *$V'$ er en overdækning.* Hver runde sletter $e(v)$, alle kanter $v$ dækker. Løkken stopper først ved $E = emptyset$, så hver kant blev slettet ved at røre en valgt knude.
    + *Det grådige valg ligger i et optimum.* Lad $u$ være et løv og $v$ dets forælder. Kanten $(u,v)$ skal dækkes, så en hvilken som helst overdækning $C$ rummer $u$ eller $v$. Er $v in C$: fint. Er $v in.not C$, så $u in C$; sæt $C' = C - {u} + {v}$. Da $u$ er et løv (grad $1$), er $(u,v)$ den eneste kant $u$ dækkede, og $v$ dækker den også. Så $C'$ dækker alt $C$ dækkede, og $|C'| <= |C|$. Der findes altså et mindste overdækning, der rummer $v$. Pointe: $v$ kan dække både $(u,v)$ og kanten op til sin egen forælder, mens $u$ kun dækker $(u,v)$.
    + *Induktion på antal kanter.* Påstand: algoritmen returnerer en mindste overdækning af enhver skov.
      - *Basis ($E = emptyset$):* `while`-løkken kører slet ikke, og $V' = emptyset$. Uden kanter er den tomme mængde en gyldig overdækning, og ingen mindre findes — altså mindste.
      - *Induktionsskridt:* antag påstanden for alle skove med færre end $|E|$ kanter. Algoritmen vælger et løv $u$ med forælder $v$ og lægger $v$ i $V'$. Fra ombytningstrinnet ovenfor findes en mindste overdækning $C^*$ med $v in C^*$. Slet nu $v$ og $e(v)$. Tilbage er en skov $T'$ med færre kanter, og $C^* - {v}$ dækker $T'$. Den er endda mindste for $T'$, for kunne $T'$ klares med færre knuder, kunne $T$ også klares med færre end $|C^*|$. Pr. induktion finder algoritmen en mindste overdækning $D$ af $T'$, og $|D| = |C^*| - 1$. Så har ${v} union D$ størrelse $|C^*|$ og er en mindste overdækning af $T$.

    *(b)* Rod træet et vilkårligt sted og behandl knuder i post-order (børn før forælder). Hold for hver knude et flag `covered[v]` (er kanten op til forælderen dækket?). Når $v$ besøges, er alle børn færdige; er der et barn $c$ med `covered[c] = false`, så er kanten $(v,c)$ stadig udækket — læg $v$ i $V'$ og sæt `covered` for $v$ selv og alle dets børn til `true`.

    Lille eksempel: sti $r - v - u$ rodet i $r$ ($u$ er løv, $v$ midten):

    ```
    besøg u (løv):   ingen børn          -> covered[u] = false
    besøg v:         barn u udækket      -> V' = {v}; covered[v]=covered[u]=true
    besøg r:         barn v er dækket    -> gør intet
    resultat: V' = {v}   (én knude dækker begge kanter)
    ```

    Hver knude besøges én gang, hver kant ses konstant mange gange; DFS er $O(V + E)$, og et træ har $E = n - 1$, så i alt $O(n)$.
  ],
)
