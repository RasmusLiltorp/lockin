#import "../lib.typ": *

== Prædikatlogik og kvantorer <th-pred-truth>

Et prædikat (predicate) er et udsagn med en fri variabel (free variable), fx "$x$ er lige". Det har ingen sandhedsværdi (truth value), før du binder $x$. En kvantor (quantifier) binder variablen og gør prædikatet til et færdigt udsagn.

De to kvantorer er $forall$ ("for alle") og $exists$ ("der findes mindst ét"). De læses altid over et domæne (domain) — mængden $x$ kommer fra, typisk $ZZ$, $NN$ eller $RR$.

#eq[$ forall x : P(x) quad quad exists x : P(x) $]

De domæner du møder i opgaverne:
- $ZZ$ — heltal (integers): $dots, -2, -1, 0, 1, 2, dots$. Negative tal, nul og positive tal, men ingen brøker.
- $NN$ — naturlige tal (naturals): $0, 1, 2, 3, dots$. Heltallene fra og med nul og opefter (nogle bøger starter ved $1$; her tæller $0$ med).
- $ZZ^+$ — de positive heltal: $1, 2, 3, dots$. Det samme som $NN$, bare uden $0$.
- $RR$ — reelle tal (reals): alle tal på tallinjen, også brøker og irrationale tal som $1.5$, $sqrt(2)$ og $pi$.

Domænet afgør alt: samme prædikat kan skifte sandhedsværdi, når domænet ændres. "$exists x : x^2 = 2$" er falsk over $ZZ$ (intet heltal går op), men sand over $RR$ (det er $sqrt(2)$).

Eksamen spørger om tre ting: sandhedsværdien af et (ofte indlejret) udsagn over et givet domæne; fornægtelsen (negation) af et udsagn uden $not$ tilbage; og rækkefølgen i en kvantorrække (quantifier sequence). I MCQ-versionerne vurderes hvert valg sand/falsk for sig, og flere kan være rigtige.

=== Sådan løser du den

#recipe(
  title: "Sandhedsværdi af et kvantificeret udsagn",
  [Skriv domænet op først (#swap[$ZZ$], $NN$, $RR$, $ZZ^+$). Et udsagn kan være sandt over $RR$ og falsk over $ZZ$.],
  [Læs kvantorrækken udefra og ind, venstre mod højre. Den yderste vælges først; de indre må afhænge af den.],
  [Yderste $forall x$: ét modeksempel (counterexample) gør hele udsagnet falsk.],
  [Yderste $exists x$: angiv ét $x$, der virker.],
  [Indlejret $forall x exists y$: hold $x$ fast og byg $y$ som formel i $x$, fx $y = x+1$ eller $y = -x$. Virker formlen altid, er udsagnet sandt.],
  [Indlejret $exists x forall y$: find ét fast $x$, der får det indre $forall y$ til at holde for alle $y$. Test grænsetilfælde som $y = 0$. Ubegrænsede domæner slår som regel disse ihjel.],
)

Rækkefølgen er ikke ligegyldig. $forall x exists y$ lader $y$ afhænge af $x$ — hvert $x$ vælger sit eget $y$. $exists y forall x$ kræver ét $y$, der virker for alle $x$.

#eq[$ forall x exists y : P(x,y) quad != quad exists y forall x : P(x,y) $]

#note(title: [Kvantorrækkefølge])[Bytter du en $forall$ og en $exists$, vender sandhedsværdien næsten altid. Det er den hyppigst testede fælde. "Hvert tal har et større" er sandt over $NN$; "der findes ét tal større end alle" er falsk.]

#metadata(none) <th-pred-neg>
#recipe(
  title: [Fornægt et kvantificeret udsagn (intet $not$ i svaret)],
  [Skub $not$ indad én kvantor ad gangen. Hver kvantor vender.],
  [Rammer $not$ et sammensat prædikat, så fortsæt med De Morgan indeni. $and$ bliver $or$ og $or$ bliver $and$, og $not(P -> Q)$ bliver $P and not Q$. Først når $not$ står helt inde ved en enkelt relation, bytter du den ud.],
  [Når $not$ er inde ved prædikatet, byt relationen ud med sin modsætning uden at efterlade et $not$. $not(a < b)$ bliver #swap[$a >= b$]; $not(a = b)$ bliver $a != b$.],
  [Tjek: fornægtelsen skal have modsat sandhedsværdi af originalen.],
)

Vending-reglerne er:

#eq[$ not forall x : P(x) quad equiv quad exists x : not P(x) $]

#eq[$ not exists x : P(x) quad equiv quad forall x : not P(x) $]

Når $not$ er skubbet forbi alle kvantorer og rammer et sammensat prædikat, vender du videre med De Morgan og implikationsreglen indeni:

#eq[$ not(P and Q) equiv not P or not Q quad quad not(P or Q) equiv not P and not Q quad quad not(P -> Q) equiv P and not Q $]

#trap(title: [Vend alle kvantorer])[De Morgan for kvantorer vender alle kvantorer i rækken. Fornægtelsen af $exists x exists y : P$ er $forall x forall y : not P$, ikke $forall x exists y : not P$. En "ækvivalens" med kun den ene kvantor vendt er et klassisk falsk MCQ-svar (juni 2021 Spm. 35, juni 2023 Spm. 34).]

#trap(title: [Vakuøst sand implikation])[En implikation inde i en kvantor er vakuøst sand (vacuously true), når forudsætningen er falsk. $forall x : (x != 0 -> dots)$ er automatisk opfyldt ved $x = 0$, så $x = 0$ kan aldrig være modeksempel her.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Kvantorer: hvilke udsagn er sande? (kvantor)],
  source: "MCQ juni 2025, Spm. 33 (flere rigtige)",
  theory: <th-pred-truth>,
  prompt: [Hvilke udsagn er sande? (Et eller flere korrekte svar.)],
  options: (
    [$forall x in ZZ^+ : x > -x$],
    [$not forall x in ZZ : #swap[$2x = x+2$]$],
    [$exists x in ZZ : x^2 = #swap[$5$]$],
    [$forall x in ZZ : exists y in ZZ : y > x + #swap[$100$]$],
    [$exists x in ZZ : forall y in ZZ : (x+y)^2 < x^2$],
    [$not forall x in ZZ : exists y in ZZ : x dot y = x$],
  ),
  answer: [Sande: (a), (b), (d).],
  blueprint: [
    Du får flere kvantificerede udsagn over ét fast domæne, og hvert udsagn skal vurderes for sig.

    + *Skriv domænet op.* Notér mængden #swap[$ZZ$] og hold fast i den. Det samme udsagn kan være sandt over $RR$ og falsk over $ZZ$.
    + *Tag den yderste kvantor først.* Ved $forall$ leder du efter ét modeksempel. Ved $exists$ rækker det at finde ét vidne (witness).
    + *Ved $forall x exists y$:* hold $x$ fast og byg $y$ som en formel i $x$, fx $y = x+1$. Virker formlen for hvert $x$, er udsagnet sandt.
    + *Ved $exists x forall y$:* find ét fast $x$, der holder for alle $y$, og test grænsetilfælde som $y = 0$. Over et ubegrænset domæne falder de fleste af disse.
    + *Står der $not$ foran:* afgør først det indre udsagn, og vend så svaret.
  ],
  worked: [
    Domænet er $ZZ$ (i (a) dog $ZZ^+ = {1, 2, 3, dots}$). Hvert udsagn afgøres ved at tage den yderste kvantor først.

    *(a) $forall x in ZZ^+ : x > -x$.* Yderste er $forall$, så jeg leder efter ét modeksempel. Hold et vilkårligt positivt $x$ fast. Da $x >= 1 > 0$, er $-x <= -1 < 0$, altså $-x < 0 < x$, og dermed $x > -x$. Det gælder for hvert positivt $x$ uden undtagelse, så der findes intet modeksempel. Sand.

    *(b) $not forall x in ZZ : 2x = x+2$.* Afgør først det indre $forall x : 2x = x+2$. Løs ligningen: $2x = x+2 <=> x = 2$. Den holder altså kun ved $x=2$. Et modeksempel er $x=0$: $2 dot 0 = 0$ men $0+2 = 2$, og $0 != 2$. Det indre $forall$ er derfor falsk, og $not$ foran vender det til sand. Sand.

    *(c) $exists x in ZZ : x^2 = 5$.* Yderste er $exists$, så jeg søger ét vidne. Gennemgå kvadraterne omkring 5:
    $2^2 = 4$ og $3^2 = 9$ (og $(-2)^2 = 4$, $(-3)^2 = 9$), så 5 springes over. Der findes intet heltal med kvadrat $5$, fordi $sqrt(5) approx 2.236$ ikke er et heltal. Intet vidne. Falsk.

    *(d) $forall x in ZZ : exists y in ZZ : y > x + 100$.* Indlejret $forall x exists y$: hold $x$ fast og byg $y$ som formel i $x$. Vælg $y = x + 101$. Så er $y = x + 101 > x + 100$, opfyldt for hvert $x$. Et eksempel: $x = 7 ==> y = 108 > 107$. Da konstruktionen virker for ethvert $x$, er udsagnet sandt. Sand.

    *(e) $exists x in ZZ : forall y in ZZ : (x+y)^2 < x^2$.* Indlejret $exists x forall y$: et fast $x$ skal få det indre $forall y$ til at holde for alle $y$. Test grænsetilfældet $y=0$: $(x+0)^2 = x^2$, og $x^2 < x^2$ er falsk. Altså fejler det indre $forall y$ allerede ved $y=0$, uanset hvilket $x$ jeg vælger. Intet fast $x$ duer. Falsk.

    *(f) $not forall x in ZZ : exists y in ZZ : x dot y = x$.* Afgør først det indre $forall x exists y : x dot y = x$. Hold $x$ fast og vælg $y = 1$: $x dot 1 = x$, sandt for hvert $x$. Det indre $forall$ er altså sandt, og $not$ foran vender det til falsk. Falsk.

    Svar: sande er (a), (b), (d).
  ],
)

#qcard(
  tag: [Kvantorer: hvilke udsagn er sande? (+ fornægtelse)],
  source: "MCQ juni 2023, Spm. 34 (flere rigtige)",
  theory: <th-pred-truth>,
  prompt: [Domæne $ZZ$. Hvilke udsagn er sande? (Et eller flere korrekte svar.)],
  options: (
    [$forall x in ZZ : x^2 > 2x$],
    [$not exists x in ZZ : x^2 > 2x$],
    [$forall x in ZZ : (x < #swap[$5$] or x^2 > 2x)$],
    [$forall x in ZZ : exists y in ZZ : x + y = 2x$],
    [$not exists x in ZZ : forall y in ZZ : x + y = 2x$],
    [$forall x in ZZ : forall y in ZZ : x + y = 2x$],
    [$not exists x exists y : x + y = 2x quad <==> quad forall x exists y : x + y != 2x$],
  ),
  answer: [Sande: (c), (d), (e).],
  blueprint: [
    Samme opgavetype som før, men nu er ét af udsagnene en påstået ækvivalens mellem en fornægtelse og en omskrivning.

    + *Læs domænet og udsagnet,* og tag den yderste kvantor først som ved sandhedsværdi-opgaverne.
    + *Afgør hvert udsagn for sig.* Ved $forall$ søger du et modeksempel; ved $exists$ et vidne.
    + *Ved en påstået ækvivalens:* fornægt #swap[venstresiden] korrekt med De Morgan, hvor du vender alle kvantorer i rækken. Sammenlign så de to siders sandhedsværdi. Et bikonditional er kun sandt, når begge sider har samme værdi.
  ],
  worked: [
    Domænet er $ZZ$. Hvert udsagn afgøres med den yderste kvantor først.

    *(a) $forall x in ZZ : x^2 > 2x$.* Yderste $forall$, søg et modeksempel. Prøv $x=0$: $0^2 = 0$ og $2 dot 0 = 0$, så $0 > 0$ er falsk. Modeksempel fundet. Falsk.

    *(b) $not exists x in ZZ : x^2 > 2x$.* Afgør det indre $exists x : x^2 > 2x$ ved at finde ét vidne. Prøv $x=3$: $3^2 = 9$ og $2 dot 3 = 6$, og $9 > 6$. Vidnet holder, så det indre $exists$ er sandt. $not$ foran vender til falsk. Falsk.

    *(c) $forall x in ZZ : (x < 5 or x^2 > 2x)$.* Yderste $forall$, så hvert $x$ skal gøre disjunktionen sand. Del i to tilfælde:
    - Hvis $x < 5$: første led $x < 5$ er sandt, så disjunktionen er sand.
    - Hvis $x >= 5$: så er $x > 0$ og $x - 2 >= 3 > 0$, altså $x(x-2) > 0$, dvs. $x^2 - 2x > 0$, dvs. $x^2 > 2x$. Andet led er sandt.

    I begge tilfælde er mindst ét led sandt, så disjunktionen holder for hvert $x$. (Selv de negative heltal og $x in {0,1,2,3,4}$ fanges af $x < 5$.) Sand.

    *(d) $forall x in ZZ : exists y in ZZ : x + y = 2x$.* Indlejret $forall x exists y$: hold $x$ fast og byg $y$. Ligningen $x + y = 2x$ giver $y = x$. Vælg altså $y = x$: så er $x + x = 2x$, sandt for hvert $x$. Konstruktionen virker altid. Sand.

    *(e) $not exists x in ZZ : forall y in ZZ : x + y = 2x$.* Afgør det indre $exists x forall y : x + y = 2x$. For et fast $x$ kræver det indre $forall y$, at $x + y = 2x$ for alle $y$, dvs. $y = x$ for alle $y$. Det kan ikke holde: vælg blot $y = x + 1$, så er $x + y = 2x + 1 != 2x$. Intet $x$ duer, så det indre $exists x$ er falsk. $not$ foran vender til sand. Sand.

    *(f) $forall x in ZZ : forall y in ZZ : x + y = 2x$.* Yderste $forall$, søg et modeksempel-par. Prøv $x=0, y=1$: $0 + 1 = 1$ og $2 dot 0 = 0$, og $1 != 0$. Modeksempel. Falsk.

    *(g) $not exists x exists y : x + y = 2x quad <==> quad forall x exists y : x + y != 2x$.* Afgør hver side og sammenlign.

    Venstresiden, trin for trin. Først det inderste: $exists x exists y : x + y = 2x$ har vidnet $x = y = 0$ ($0 + 0 = 0$), så det er sandt. $not$ foran gør venstresiden *falsk*.

    Den korrekte fornægtelse ville være
    #eq[$ not exists x exists y : P equiv forall x forall y : not P $]
    altså med *begge* kvantorer vendt til $forall$. Højresiden i opgaven har $forall x exists y$ — den inderste kvantor er ikke vendt, så det er den forkerte omskrivning.

    Højresiden selv: $forall x exists y : x + y != 2x$. Hold $x$ fast og vælg $y = x + 1$: $x + y = 2x + 1 != 2x$. Virker for hvert $x$, så højresiden er *sand*.

    Venstre falsk, højre sand, så bikonditionalen (biconditional) er falsk. Falsk.

    Svar: sande er (c), (d), (e).
  ],
)

#qcard(
  tag: [Kvantorer: hvilke udsagn er sande? (+ fornægtelse)],
  source: "MCQ juni 2021, Spm. 35 (flere rigtige)",
  theory: <th-pred-truth>,
  prompt: [Domæne $ZZ$. Hvilke udsagn er sande? (Et eller flere korrekte svar.)],
  options: (
    [$exists a in ZZ : a^2 + 1 = #swap[$82$]$],
    [$forall a in ZZ : a < 2a$],
    [$exists a in ZZ : exists b in ZZ : a = b$],
    [$exists a in ZZ : forall b in ZZ : 2a > b$],
    [$forall a in ZZ : exists b in ZZ : a = 2b$],
    [$forall a in ZZ : exists b in ZZ : a = b + #swap[$2$]$],
    [$forall a in ZZ : forall b in ZZ : (a < b or a > b)$],
    [$not exists a forall b : a^2 = b quad <==> quad exists a forall b : a^2 != b$],
    [$not exists a in ZZ : forall b in ZZ : a^2 = b$],
  ),
  answer: [Sande: (a), (c), (f), (i).],
  blueprint: [
    Igen en stak udsagn over ét domæne, og igen gemmer der sig en påstået ækvivalens med en fornægtelse i bunken.

    + *Læs domænet og tag den yderste kvantor først.* Ved $forall$ søger du et modeksempel; ved $exists$ et vidne.
    + *Afgør hvert udsagn for sig.* Ved indlejring holder du den ydre variabel fast og bygger den indre som formel.
    + *Ved en påstået ækvivalens:* fornægt #swap[den ene side] med De Morgan og vend alle kvantorer. Sammenlign så sandhedsværdierne; bikonditionalen er kun sand, når de er ens.
  ],
  worked: [
    Domænet er $ZZ$. Hvert udsagn afgøres med den yderste kvantor først.

    *(a) $exists a in ZZ : a^2 + 1 = 82$.* Yderste $exists$, søg et vidne. Løs: $a^2 + 1 = 82 <=> a^2 = 81 <=> a = plus.minus 9$. Begge $9$ og $-9$ ligger i $ZZ$. Vidne fundet ($a = 9$: $81 + 1 = 82$). Sand.

    *(b) $forall a in ZZ : a < 2a$.* Yderste $forall$, søg et modeksempel. Omskriv: $a < 2a <=> 0 < a$. Det fejler for hvert $a <= 0$. Modeksempel $a = 0$: $0 < 0$ er falsk. Falsk.

    *(c) $exists a in ZZ : exists b in ZZ : a = b$.* To $exists$, byg ét par. Vælg $a = b = 0$: $0 = 0$. Vidne fundet. Sand.

    *(d) $exists a in ZZ : forall b in ZZ : 2a > b$.* Indlejret $exists a forall b$: et fast $a$ skal opfylde $2a > b$ for *alle* $b$. Men $b$ løber over hele $ZZ$ og er ubegrænset opadtil. For ethvert valgt $a$ findes et for stort $b$, fx $b = 2a$: så er $2a > 2a$ falsk. Intet fast $a$ duer. Falsk.

    *(e) $forall a in ZZ : exists b in ZZ : a = 2b$.* Indlejret $forall a exists b$: hold $a$ fast, find $b$ med $a = 2b$, dvs. $b = a/2$. Det er kun et heltal, når $a$ er lige. Modeksempel: $a = 1$ er ulige, og $b = 1/2 in.not ZZ$, så intet $b$ duer. Det indre $exists b$ fejler for $a = 1$, og dermed fejler $forall a$. Falsk.

    *(f) $forall a in ZZ : exists b in ZZ : a = b + 2$.* Indlejret $forall a exists b$: hold $a$ fast og byg $b$. Ligningen $a = b + 2$ giver $b = a - 2$. Det er et heltal for hvert heltal $a$. Eksempel $a = 5 ==> b = 3$: $3 + 2 = 5$. Virker altid. Sand.

    *(g) $forall a in ZZ : forall b in ZZ : (a < b or a > b)$.* To $forall$, søg et modeksempel-par. Prøv $a = b$ (fx $a = b = 0$): så er $a < b$ falsk og $a > b$ falsk, altså disjunktionen falsk. Modeksempel. Falsk.

    *(h) $not exists a forall b : a^2 = b quad <==> quad exists a forall b : a^2 != b$.* Fornægt venstresidens kerne korrekt, trin for trin:
    #eq[$ not exists a forall b : a^2 = b equiv forall a exists b : not(a^2 = b) equiv forall a exists b : a^2 != b $]
    Begge kvantorer vender ($exists -> forall$, $forall -> exists$). Den korrekte fornægtelse er altså $forall a exists b : a^2 != b$. Opgavens højreside er $exists a forall b : a^2 != b$ — ingen af kvantorerne er vendt, så det er den forkerte omskrivning, og de to sider får ikke samme sandhedsværdi. Bikonditionalen er falsk. Falsk.

    *(i) $not exists a in ZZ : forall b in ZZ : a^2 = b$.* Afgør kernen $exists a forall b : a^2 = b$. Den kræver ét fast $a$, hvis kvadrat $a^2$ er lig med *hvert* heltal $b$ samtidig. Men $a^2$ er ét bestemt tal, fx tag $a = 3$: så skulle $9 = b$ for alle $b$, hvilket fejler ved $b = 0$. Intet $a$ duer, så kernen er falsk. $not$ foran vender til sand. Sand.

    Svar: sande er (a), (c), (f), (i).
  ],
)

#qcard(
  tag: [Kvantorer: sandhedsværdi + fornægt uden ¬ (fornægtelse)],
  source: "Eksamen feb 2015, Opg. 4 (DM03 Opg. 4)",
  theory: <th-pred-neg>,
  prompt: [$NN = {0,1,2,dots}$. Først (4a): hvilke af i og ii er sande?
    + $forall x in NN : exists y in NN : x < y$
    + $exists y in NN : forall x in NN : x < y$

  Dernæst (4b): angiv fornægtelsen af i uden $not$ i svaret.],
  answer: [4a: i er sand, ii er falsk. 4b: $#swap[$exists x in NN : forall y in NN : x >= y$]$.],
  blueprint: [
    Opgaven har to dele: først afgøre sandhed, så fornægte et udsagn uden at lade $not$ stå tilbage i svaret.

    + *Afgør sandhed udsagn for udsagn,* med yderste kvantor først.
    + *Til fornægtelsen:* skub $not$ ind én kvantor ad gangen, så hver kvantor vender. Byt til sidst #swap[relationen] ud med sin modsætning, så der ikke står $not$ tilbage; $not(a < b)$ bliver $a >= b$.
    + *Tjek til slut,* at fornægtelsen har modsat sandhedsværdi af originalen.
  ],
  worked: [
    Domænet er $NN = {0,1,2,dots}$.

    *4a-i. $forall x in NN : exists y in NN : x < y$.* Indlejret $forall x exists y$: hold $x$ fast og byg $y$ som formel i $x$. Vælg $y = x + 1$. Da $x + 1 in NN$ og $x < x + 1$, er det indre $exists y$ opfyldt. Eksempler: $x = 0 ==> y = 1$, $x = 7 ==> y = 8$. Konstruktionen virker for hvert $x$. Sand.

    *4a-ii. $exists y in NN : forall x in NN : x < y$.* Her byttes rækkefølgen: nu påstås ét fast $y$, der er større end *alle* $x$, altså et største naturligt tal. Test den faste $y$ mod grænsetilfældet $x = y$: $y < y$ er falsk. For ethvert valgt $y$ findes altså et $x$ (nemlig $x = y$, eller $x = y+1$) der vælter det indre $forall x$. Intet $y$ duer. Falsk.

    Samme prædikat $x < y$, byttet kvantorrækkefølge, vendt sandhedsværdi — netop fælden fra noten.

    *4b. Fornægt i (uden $not$ i svaret).* Skub $not$ ind én kvantor ad gangen; hver kvantor vender, og til sidst byttes relationen:

    #eq[$ not (forall x : exists y : x < y) equiv exists x : not(exists y : x < y) equiv exists x : forall y : not(x < y) $]

    Sidste trin: byt relationen ud med sin modsætning, så der ikke står $not$ tilbage. $not(x < y)$ bliver $x >= y$:

    #eq[$ equiv exists x in NN : forall y in NN : x >= y $]

    I ord: der findes et naturligt tal $x$, som er større end eller lig med hvert $y$, altså et største tal. Tjek sandhedsværdien: det er falsk (intet største naturligt tal findes), og originalen i var sand. Modsat sandhedsværdi, så fornægtelsen er korrekt.
  ],
)
