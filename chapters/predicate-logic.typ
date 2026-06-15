#import "../lib.typ": *

== Prædikatlogik og kvantorer

Et prædikat er et udsagn med en fri variabel, fx "$x$ er lige". Det har ingen sandhedsværdi, før du binder $x$. En kvantor binder variablen og gør prædikatet til et færdigt udsagn.

De to kvantorer er $forall$ ("for alle") og $exists$ ("der findes mindst ét"). De læses altid over et domæne — mængden $x$ kommer fra, typisk $ZZ$, $NN$ eller $RR$.

#eq[$ forall x : P(x) quad quad exists x : P(x) $]

Domænet afgør alt: samme prædikat kan skifte sandhedsværdi, når domænet ændres.

Eksamen spørger om tre ting: sandhedsværdien af et (ofte indlejret) udsagn over et givet domæne; fornægtelsen af et udsagn uden $not$ tilbage; og rækkefølgen i en kvantorrække. I MCQ-versionerne vurderes hvert valg sand/falsk for sig, og flere kan være rigtige.

=== Sådan løser du den

#recipe(
  title: "Sandhedsværdi af et kvantificeret udsagn",
  [Skriv domænet op først (#swap[$ZZ$], $NN$, $RR$, $ZZ^+$). Et udsagn kan være sandt over $RR$ og falsk over $ZZ$.],
  [Læs kvantorrækken udefra og ind, venstre mod højre. Den yderste vælges først; de indre må afhænge af den.],
  [Yderste $forall x$: ét modeksempel gør hele udsagnet falsk.],
  [Yderste $exists x$: angiv ét $x$, der virker.],
  [Indlejret $forall x exists y$: hold $x$ fast og byg $y$ som formel i $x$, fx $y = x+1$ eller $y = -x$. Virker formlen altid, er udsagnet sandt.],
  [Indlejret $exists x forall y$: find ét fast $x$, der får det indre $forall y$ til at holde for alle $y$. Test grænsetilfælde som $y = 0$. Ubegrænsede domæner slår som regel disse ihjel.],
)

Rækkefølgen er ikke ligegyldig. $forall x exists y$ lader $y$ afhænge af $x$ — hvert $x$ vælger sit eget $y$. $exists y forall x$ kræver ét $y$, der virker for alle $x$.

#eq[$ forall x exists y : P(x,y) quad != quad exists y forall x : P(x,y) $]

#note[Bytter du en $forall$ og en $exists$, vender sandhedsværdien næsten altid. Det er den hyppigst testede fælde. "Hvert tal har et større" er sandt over $NN$; "der findes ét tal større end alle" er falsk.]

#recipe(
  title: [Fornægt et kvantificeret udsagn (intet $not$ i svaret)],
  [Skub $not$ indad én kvantor ad gangen. Hver kvantor vender.],
  [Når $not$ er inde ved prædikatet, byt relationen ud med sin modsætning uden at efterlade et $not$. $not(a < b)$ bliver #swap[$a >= b$]; $not(a = b)$ bliver $a != b$.],
  [Tjek: fornægtelsen skal have modsat sandhedsværdi af originalen.],
)

Vending-reglerne er:

#eq[$ not forall x : P(x) quad equiv quad exists x : not P(x) $]

#eq[$ not exists x : P(x) quad equiv quad forall x : not P(x) $]

#trap[De Morgan for kvantorer vender alle kvantorer i rækken. Fornægtelsen af $exists x exists y : P$ er $forall x forall y : not P$, ikke $forall x exists y : not P$. En "ækvivalens" med kun den ene kvantor vendt er et klassisk falsk MCQ-svar (juni 2021 Spm. 35, juni 2023 Spm. 34).]

#trap[En implikation inde i en kvantor er vakuøst sand, når forudsætningen er falsk. $forall x : (x != 0 -> dots)$ er automatisk opfyldt ved $x = 0$, så $x = 0$ kan aldrig være modeksempel her.]

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
  worked: [
    (a) For positive $x$ er $-x < 0 < x$. Sand. \
    (b) $2x = x+2$ kun ved $x = 2$, så $forall$-udsagnet er falsk og fornægtelsen sand. \
    (c) $x^2 = 5$ har ingen heltalsløsning. Falsk. \
    (d) Hold $x$ fast, vælg $y = x + 101 > x + 100$. Vidnet bygges af $x$. Sand. \
    (e) $y = 0$ giver $(x+0)^2 = x^2$, ikke $< x^2$. Intet $x$ virker for alle $y$. Falsk. \
    (f) $y = 1$ giver $x dot 1 = x$ for hvert $x$, så det indre udsagn holder og fornægtelsen er falsk.
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
  worked: [
    (a) Fejler ved $x = 0$ ($0 > 0$ falsk). Falsk. \
    (b) $x = 3$ giver $9 > 6$, så $exists$ holder og fornægtelsen er falsk. \
    (c) Er $x < 5$, holder første led. Er $x >= 5$, er $x(x-2) > 0$, så $x^2 > 2x$. Sand. \
    (d) $y = x$ giver $x + x = 2x$. Sand. \
    (e) Det indre $forall y : x + y = 2x$ tvinger $y = x$ for hvert $y$ — umuligt. $exists x$ er falsk, fornægtelsen sand. \
    (f) Fejler ved $x = 0, y = 1$. Falsk. \
    (g) Venstresiden er falsk (vidne $x = y = 0$). Korrekt De Morgan af $not exists x exists y$ er $forall x forall y$, ikke $forall x exists y$. Højresiden er sand (vælg $y = x+1$). $F <==> T$ er falsk.
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
  worked: [
    (a) $a^2 = 81 => a = plus.minus 9 in ZZ$. Sand. \
    (b) $a < 2a <==> 0 < a$, fejler for $a <= 0$. Falsk. \
    (c) $a = b = 0$. Sand. \
    (d) $2a > b$ for alle $b$ kræver $b$ begrænset opadtil, men $b$ løber over hele $ZZ$. Falsk. \
    (e) $a = 2b$ kræver $a$ lige; ulige $a$ (fx 1) fejler. Falsk. \
    (f) $b = a - 2$ findes altid. Sand. \
    (g) Fejler når $a = b$. Falsk. \
    (h) Korrekt fornægtelse af $exists a forall b : a^2 = b$ er $forall a exists b : a^2 != b$, ikke $exists a forall b : a^2 != b$. Bikonditionalen parrer to udsagn med forskellig sandhedsværdi. Falsk. \
    (i) $exists a forall b : a^2 = b$ kræver ét $a$, hvis kvadrat er hvert heltal — umuligt. Udsagnet er falsk, fornægtelsen sand.
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
  worked: [
    4a-i. Hold $x$ fast, vælg $y = x + 1$. Sand. \
    4a-ii. Påstår ét $y$ større end hvert $x$ — et største naturligt tal. Tag $x = y$, så fejler $x < y$. Falsk. Samme prædikat, byttet rækkefølge, vendt sandhedsværdi. \
    4b. Skub $not$ ind og vend hver kvantor:
    #eq[$ not (forall x exists y : x < y) equiv exists x forall y : not(x < y) equiv exists x forall y : x >= y $]
    I ord: "der findes et naturligt tal $x$ større end eller lig med hvert $y$" (et største tal). Falsk, som det skal være.
  ],
)
