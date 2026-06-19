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
    Fletteorden (altid de to aktuelt mindste):

    + $e(10) + f(12) = 22$
    + $d(20) + {e,f}(22) = 42$
    + $b(28) + a(33) = 61$
    + ${d,e,f}(42) + c(52) = 94$
    + ${b,a}(61) + {{d,e,f},c}(94) = 155$ (rod)

    Aflæs koderne fra rod-til-løv-stierne: $b=00, a=01, c=11, d=100, e=1010, f=1011$. Det er multimængden af kodelængder, der er fastlagt; den enkelte 0/1-streng kan variere med side-valget.
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
    Fletteorden (de to aktuelt mindste):

    + $b(7) + a(9) = 16$
    + $d(10) + f(15) = 25$
    + ${b,a}(16) + c(24) = 40$
    + $g(25) + {d,f}(25) = 50$
    + ${{b,a},c}(40) + {g,{d,f}}(50) = 90$
    + $e(55) + (90) = 145$ (rod)

    Koderne: $e=0$, $c=101$, $g=110$, $b=1000$, $a=1001$, $d=1110$, $f=1111$. Samlet $= 9 dot 4 + 7 dot 4 + 24 dot 3 + 10 dot 4 + 55 dot 1 + 15 dot 4 + 25 dot 3 = 366$ bit.
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
    Fletteorden:

    + $f(50) + c(75) = 125$
    + $g(100) + d(125) = 225$
    + ${f,c}(125) + b(150) = 275$
    + $e(200) + {g,d}(225) = 425$
    + ${f,c,b}(275) + a(300) = 575$
    + ${e,g,d}(425) + {f,c,b,a}(575) = 1000$ (rod)

    Én kode: $a=11, e=00, b=101, d=011, g=010, c=1001, f=1000$. Samlet $= 300 dot 2 + 200 dot 2 + 150 dot 3 + 125 dot 3 + 100 dot 3 + 75 dot 4 + 50 dot 4 = 2625$ bit.
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
    Fletteorden:

    + $y(100) + o(150) = 250$
    + $u(200) + {y,o}(250) = 450$
    + $i(300) + a(400) = 700$
    + ${u,y,o}(450) + {i,a}(700) = 1150$
    + $e(750) + (1150) = 1900$ (rod)

    Én kode: $e=0, u=100, i=110, a=111, y=1010, o=1011$. Samlet $= 750 dot 1 + 200 dot 3 + 100 dot 4 + 150 dot 4 + 300 dot 3 + 400 dot 3 = 4450$ bit.
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
    Fletteorden:

    + $y(200) + "ø"(300) = 500$
    + $"å"(400) + (500) = 900$
    + $z(600) + "æ"(800) = 1400$
    + $(900) + x(1000) = 1900$
    + $(1400) + (1900) = 3300$ (rod)

    Én kode: $x=11, z=00, "æ"=01, "å"=100, y=1010, "ø"=1011$. Samlet $= 1000 dot 2 + 800 dot 2 + 600 dot 2 + 400 dot 3 + 200 dot 4 + 300 dot 4 = 8000$ bit. (Samme tal fås som $500 + 900 + 1400 + 1900 + 3300 = 8000$.)
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
    *(a)* Kost $= 150 dot 2 + 250 dot 2 + 350 dot 2 + 100 dot 3 + 150 dot 3 = 300 + 500 + 700 + 300 + 450 = 2250$ bit.

    *(b)* Gå fra roden: $100 -> a$, $00 -> b$, $00 -> b$, $11 -> e$, $01 -> d$, $101 -> c$, $01 -> d$. Resultat: `abbedcd`.

    *(c)* De tvungne Huffman-fletninger på ${100,150,150,250,350}$:
    + $100 + 150 = 250$
    + $150 + 250 = 400$
    + $250 + 350 = 600$
    + $400 + 600 = 1000$

    Et frembringeligt træ skal have interne vægte præcis ${250, 400, 600, 1000}$. Tjek hver kandidat: matcher multimængden, er træet frembringeligt; dukker fx to $500$-noder op, har det parret noget Huffman aldrig ville, og er ikke frembringeligt — selv om det er optimalt. (I kilden: $H_2, H_5$ ja; $H_3, H_4$ nej.)
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
    Koderne fra træet: $a=0, f=11, b=1000, c=1001, d=1010, e=1011$.

    Opdel strengen ved at gå fra roden: $11 | 0 | 1001 | 0 | 1010 | 1011$ $-> f, a, c, a, d, e$. Afkodet tekst: `facade`. Ingen bit bliver til overs.
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
    + *Induktion.* Efter $v$ er tilføjet og $e(v)$ slettet, danner resten en mindre skov. Pr. induktion finder algoritmen en mindste overdækning af resten, og ${v} union ("grådig på rest")$ er da en mindste overdækning af hele træet.

    *(b)* Rod træet et vilkårligt sted og behandl knuder i post-order (børn før forælder). Når $v$ besøges: er en kant fra $v$ til et barn stadig udækket, læg $v$ i $V'$ og marker alle kanter ved $v$ (til børn og til forælder) som dækkede. Hver knude besøges én gang, hver kant ses konstant mange gange; DFS er $O(V + E)$, og et træ har $E = n - 1$, så i alt $O(n)$.
  ],
)
