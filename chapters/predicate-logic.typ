#import "../lib.typ": *

== Prædikatlogik og kvantorer

Et prædikat (predicate) er et udsagn med en fri variabel (free variable), fx "$x$ er lige". Det har ingen sandhedsværdi (truth value), før du binder $x$. En kvantor (quantifier) binder variablen og gør prædikatet til et færdigt udsagn.

De to kvantorer er $forall$ ("for alle") og $exists$ ("der findes mindst ét"). De læses altid over et domæne (domain) — mængden $x$ kommer fra, typisk $ZZ$, $NN$ eller $RR$.

#eq[$ forall x : P(x) quad quad exists x : P(x) $]

Domænet afgør alt: samme prædikat kan skifte sandhedsværdi, når domænet ændres.

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

#recipe(
  title: [Fornægt et kvantificeret udsagn (intet $not$ i svaret)],
  [Skub $not$ indad én kvantor ad gangen. Hver kvantor vender.],
  [Når $not$ er inde ved prædikatet, byt relationen ud med sin modsætning uden at efterlade et $not$. $not(a < b)$ bliver #swap[$a >= b$]; $not(a = b)$ bliver $a != b$.],
  [Tjek: fornægtelsen skal have modsat sandhedsværdi af originalen.],
)

Vending-reglerne er:

#eq[$ not forall x : P(x) quad equiv quad exists x : not P(x) $]

#eq[$ not exists x : P(x) quad equiv quad forall x : not P(x) $]

#trap(title: [Vend alle kvantorer])[De Morgan for kvantorer vender alle kvantorer i rækken. Fornægtelsen af $exists x exists y : P$ er $forall x forall y : not P$, ikke $forall x exists y : not P$. En "ækvivalens" med kun den ene kvantor vendt er et klassisk falsk MCQ-svar (juni 2021 Spm. 35, juni 2023 Spm. 34).]

#trap(title: [Vakuøst sand implikation])[En implikation inde i en kvantor er vakuøst sand (vacuously true), når forudsætningen er falsk. $forall x : (x != 0 -> dots)$ er automatisk opfyldt ved $x = 0$, så $x = 0$ kan aldrig være modeksempel her.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Kvantorer: hvilke udsagn er sande?],
  source: "MCQ juni 2025, Spm. 33 (flere rigtige)",
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
    Domænet er $ZZ$ (i (a) dog $ZZ^+$). Hvert udsagn for sig:

    + (a) For positive $x$ er $-x < 0 < x$, så $x > -x$ holder. Sand.
    + (b) $2x = x+2$ gælder kun ved $x = 2$, så $forall$-udsagnet er falsk. Dermed er fornægtelsen sand.
    + (c) $x^2 = 5$ har ingen heltalsløsning, for $sqrt(5)$ er ikke et heltal. Falsk.
    + (d) Hold $x$ fast og vælg $y = x + 101$. Så er $y > x + 100$, og vidnet bygges af $x$. Sand.
    + (e) Prøv $y = 0$: $(x+0)^2 = x^2$, og det er ikke $< x^2$. Intet fast $x$ virker for alle $y$. Falsk.
    + (f) Vælg $y = 1$: så er $x dot 1 = x$ for hvert $x$. Det indre udsagn holder, så fornægtelsen er falsk.

    Svar: sande er (a), (b), (d).
  ],
)

#qcard(
  tag: [Kvantorer: hvilke udsagn er sande? (+ fornægtelse)],
  source: "MCQ juni 2023, Spm. 34 (flere rigtige)",
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
    Domænet er $ZZ$. Hvert udsagn for sig:

    + (a) Prøv $x = 0$: $0 > 0$ er falsk, så $forall$ fejler. Falsk.
    + (b) $x = 3$ giver $9 > 6$, så $exists$ holder. Fornægtelsen er dermed falsk.
    + (c) Er $x < 5$, holder første led. Er $x >= 5$, så er $x(x-2) > 0$, altså $x^2 > 2x$. Begge tilfælde holder. Sand.
    + (d) Vælg $y = x$: så er $x + x = 2x$. Sand.
    + (e) Det indre $forall y : x + y = 2x$ kræver $y = x$ for hvert $y$, og det kan ikke lade sig gøre. Så $exists x$ er falsk, og fornægtelsen er sand.
    + (f) Prøv $x = 0, y = 1$: $0 + 1 = 0$ er falsk. Falsk.
    + (g) Tjek de to sider:
      - Venstresiden er falsk. Tag vidnet $x = y = 0$, så holder $x + y = 2x$, og $not exists x exists y$ er dermed falsk.
      - Den korrekte De Morgan af $not exists x exists y$ er $forall x forall y$, ikke $forall x exists y$. Højresiden bruger den forkerte kvantor.
      - Højresiden er sand: vælg $y = x+1$, så er $x + y != 2x$.

      Venstre er falsk, højre er sand, så bikonditionalen (biconditional) er falsk.

    Svar: sande er (c), (d), (e).
  ],
)

#qcard(
  tag: [Kvantorer: hvilke udsagn er sande? (+ fornægtelse)],
  source: "MCQ juni 2021, Spm. 35 (flere rigtige)",
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
    Domænet er $ZZ$. Hvert udsagn for sig:

    + (a) $a^2 + 1 = 82$ giver $a^2 = 81$, altså $a = plus.minus 9$, og begge ligger i $ZZ$. Sand.
    + (b) $a < 2a$ er det samme som $0 < a$, og det fejler for $a <= 0$ (fx $a = 0$). Falsk.
    + (c) Vælg $a = b = 0$. Sand.
    + (d) $2a > b$ for alle $b$ kræver, at $b$ er begrænset opadtil, men $b$ løber over hele $ZZ$. Intet fast $a$ rækker. Falsk.
    + (e) $a = 2b$ kræver, at $a$ er lige. Et ulige $a$ som $1$ har intet $b$. Falsk.
    + (f) Vælg $b = a - 2$; det findes for hvert $a$, og så er $a = b + 2$. Sand.
    + (g) Prøv $a = b$: så er hverken $a < b$ eller $a > b$ opfyldt. Falsk.
    + (h) Tjek de to sider:
      - Den korrekte fornægtelse af $exists a forall b : a^2 = b$ er $forall a exists b : a^2 != b$, ikke $exists a forall b : a^2 != b$. Højresiden har den forkerte ydre kvantor.
      - De to sider får ikke samme sandhedsværdi, så bikonditionalen er falsk.
    + (i) $exists a forall b : a^2 = b$ kræver ét $a$, hvis kvadrat rammer hvert heltal, og det kan ikke lade sig gøre. Udsagnet er falsk, så fornægtelsen er sand.

    Svar: sande er (a), (c), (f), (i).
  ],
)

#qcard(
  tag: [Kvantorer: sandhedsværdi + fornægt uden ¬],
  source: "Eksamen feb 2015, Opg. 4 (DM03 Opg. 4)",
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

    + 4a-i. Hold $x$ fast og vælg $y = x + 1$. Så er $x < y$, og vidnet findes for hvert $x$. Sand.
    + 4a-ii. Her påstås ét $y$, der er større end hvert $x$, altså et største naturligt tal. Tag $x = y$, så fejler $x < y$. Falsk. Samme prædikat, byttet rækkefølge, vendt sandhedsværdi.

    4b. Skub $not$ ind og vend hver kvantor:

    #eq[$ not (forall x exists y : x < y) equiv exists x forall y : not(x < y) equiv exists x forall y : x >= y $]

    I ord: der findes et naturligt tal $x$, som er større end eller lig med hvert $y$, altså et største tal. Det er falsk, og originalen var sand, så fornægtelsen passer.
  ],
)
