#import "../lib.typ": *

== Udsagnslogik og sandhedstabeller <th-logic-truthtable>

Et udsagn (proposition) er enten sandt eller falsk. Konnektiverne (connectives) $not$ (ikke), $and$ (og), $or$ (eller), $->$ (medfører), $<->$ (hvis og kun hvis) og $plus.o$ (XOR) binder udsagn sammen til større udsagn.

En sandhedstabel (truth table) skriver alle muligheder op. Hver variabel er sand (T) eller falsk (F), så $n$ variable giver

#eq[$ 2^n $]

rækker. For hver række afgør du, om hele udsagnet er sandt.

Eksamen giver en liste påstande og spørger, hvilke der er sande. Du skal kunne fire ting: afgøre om to udsagn er ækvivalente (equivalent), om et udsagn er en tautologi (tautology), om det er opfyldeligt (satisfiable), og antal rækker i tabellen.

=== Sådan løser du den

Lær de fire grundkonnektiver udenad.

#table(
  columns: (auto, auto, auto, auto, auto, auto),
  inset: 6pt,
  align: center + horizon,
  stroke: 0.4pt + hair,
  table.header([$p$], [$q$], [$p and q$], [$p or q$], [$p -> q$], [$p <-> q$]),
  [T], [T], [T], [T], [T], [T],
  [T], [F], [F], [T], [F], [F],
  [F], [T], [F], [T], [T], [F],
  [F], [F], [F], [F], [T], [T],
)

#note(title: [Konnektivernes sandhed])[$p -> q$ er kun falsk i rækken T $->$ F; er $p$ falsk, er implikationen automatisk sand. $p <-> q$ er sand når $p$ og $q$ er ens; $p plus.o q$ når de er forskellige.]

#recipe(
  title: "Byg en sandhedstabel",
  [Tæl de forskellige variable. Med $n$ får tabellen #swap[$2^n$] rækker, én per kombination af T og F.],
  [Lav en kolonne per deludtryk, inderste først: negationer, så $and$ og $or$, så $->$, $<->$ og $plus.o$.],
  [Udfyld kolonnerne efter tabellen ovenfor, op til hele formlen.],
  [Læs sidste kolonne: alle T er tautologi, alle F kontradiktion (contradiction), blandet kontingens (contingency).],
)

#recipe(
  title: "Svar på de fire spørgsmålstyper",
  [*Ækvivalens* ($A equiv B$): stil de to kolonner op side om side. Ens i alle rækker betyder ækvivalente; én afvigende række afgør det.],
  [*Tautologi*: sidste kolonne er T overalt. Genvej for $X -> Y$: antag det falsk ($X$ sand, $Y$ falsk) og søg en modstrid (contradiction). Findes ingen, er det en tautologi.],
  [*Opfyldelig* ("kan $p$ tildeles, så $Z$ bliver sand"): ja, hvis blot én række gør $Z$ sand.],
  [*Antal rækker*: $2^n$, hvor $n$ er antal #swap[forskellige] variable.],
)

#metadata(none) <th-logic-equiv>
Lær de tilbagevendende ækvivalenser udenad. De Morgan:

#eq[$ not(p and q) equiv not p or not q quad quad not(p or q) equiv not p and not q $]

Materiel implikation (material implication) og kontraposition (contraposition):

#eq[$ p -> q equiv not p or q quad quad p -> q equiv not q -> not p $]

Biimplikation (biconditional):

#eq[$ p <-> q equiv (p -> q) and (q -> p) $]

#note(title: [De Morgan for kvantorer])[De Morgan gælder også for kvantorer. $not forall x : P(x)$ er det samme som $exists x : not P(x)$, og $not exists x : P(x)$ er $forall x : not P(x)$. Tænk på $forall$ som et stort $and$ over hele domænet og $exists$ som et stort $or$, så er kvantor-reglerne bare De Morgan i det uendelige. Den fulde gennemgang står i prædikatlogik-kapitlet.]

#trap(title: [Tæl forskellige variable])[Tæl *forskellige* variable. $p or not p$ har én, altså 2 rækker, ikke 4. $(p or not q) and q$ har to, altså 4, ikke 8.]

#trap(title: [Omvendt og invers])[Kontrapositionen (contrapositive) $not q -> not p$ er ækvivalent med $p -> q$. Den omvendte (converse) $q -> p$ og den inverse (inverse) $not p -> not q$ er det ikke, men er ækvivalente med hinanden.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Udsagnslogik: hvilke udsagn er sande? (sandhedstabel)],
  source: "MCQ juni 2023, Spm. 33",
  theory: <th-logic-truthtable>,
  prompt: [Lad $p,q,r$ være udsagn. Hvilke af nedenstående udsagn er sande? (Et eller flere svar.)],
  options: (
    [$(p and q) or (p and not q)$ er ækvivalent med #swap[$p$].],
    [Hvis $p <-> not q$ er sand, så er $p and not q$ også sand.],
    [$p -> (p or q)$ er en tautologi.],
    [Hvis $q$ er sand og $r$ er falsk, kan $p$ tildeles en sandhedsværdi, så $(not p and q) or (p and r)$ er sand.],
    [Sandhedstabellen for $(p -> q) and r$ har #swap[otte] rækker.],
  ),
  answer: [Sande: 0, 2, 3, 4. Falsk: 1.],
  blueprint: [
    Du får en stak påstande og skal sige, hvilke der holder. De fleste hører til en af fire typer, nemlig ækvivalens, tautologi, opfyldelighed og antal rækker.

    + *Oversæt.* Skriv #swap[hver påstand] om til en formel, og noter de forskellige variable.
    + *Vælg metode.* Skal to udsagn være ens, eller hele udsagnet sandt, så byg sandhedstabellen eller forenkl med lovene. Spørger den om opfyldelighed, leder du efter bare én række, der gør udsagnet sandt. Spørger den om antal rækker, tæller du forskellige variable og regner #swap[$2^n$].
    + *Genvej for implikation.* Antag $X #sym.arrow.r Y$ falsk, altså $X$ sand og $Y$ falsk, og søg en modstrid. Finder du ingen, er den en tautologi.
    + *Skriv svaret af* for hver påstand.
  ],
  worked: [
    De fem påstande tages én ad gangen, og hver kolonne fyldes ud række for række.

    *(0) $(p and q) or (p and not q) equiv p$?* Stil de to sider op over alle fire rækker:

    ```
    p q | p∧q  ¬q  p∧¬q | (p∧q)∨(p∧¬q) | p
    ----+------------------+-------------+--
    T T |  T    F    F   |      T       | T
    T F |  F    T    T   |      T       | T
    F T |  F    F    F   |      F       | F
    F F |  F    T    F   |      F       | F
    ```

    Den sammensatte kolonne og $p$-kolonnen er ens i alle fire rækker. Algebraisk: $(p and q) or (p and not q) = p and (q or not q) = p and T = p$. Sand.

    *(1) Hvis $p <-> not q$ er sand, så er $p and not q$ sand?* Find de rækker, hvor forleddet $p <-> not q$ er sandt, og se på bagleddet der:

    ```
    p q | ¬q  p↔¬q | p∧¬q
    ----+----------+-----
    T T |  F    F   |  F
    T F |  T    T   |  T
    F T |  F    T   |  F   <- forled sandt, bagled falsk
    F F |  T    F   |  F
    ```

    I rækken $p=F, q=T$ er forleddet sandt, men bagleddet falsk. Et modeksempel, så implikationen holder ikke. Falsk.

    *(2) $p -> (p or q)$ tautologi?* Sidste kolonne skal være T overalt:

    ```
    p q | p∨q | p→(p∨q)
    ----+-----+--------
    T T |  T  |   T
    T F |  T  |   T
    F T |  T  |   T
    F F |  F  |   T
    ```

    Alle fire rækker er T. Når $p$ er sand er $p or q$ sand, og når $p$ er falsk er implikationen vakuøst sand. Tautologi. Sand.

    *(3) Med $q=T, r=F$: kan $p$ vælges, så $(not p and q) or (p and r)$ er sand?* Indsæt $q=T, r=F$ og prøv begge værdier af $p$:

    ```
    p | ¬p∧q  p∧r | (¬p∧q)∨(p∧r)
    --+-------------+------------
    T | F∧T=F  T∧F=F |     F
    F | T∧T=T  F∧F=F |     T   <- sand
    ```

    Med $p=F$ bliver udtrykket sandt. Opfyldelig. Sand.

    *(4) Tabellen for $(p -> q) and r$ har 8 rækker?* Tre forskellige variable $p, q, r$, så antal rækker er $2^3 = 8$. Sand.

    Svar: 0, 2, 3, 4 er sande, og 1 er falsk.
  ],
)

#qcard(
  tag: [Udsagnslogik: hvilke udsagn er sande? (sandhedstabel)],
  source: "MCQ juni 2021, Spm. 34",
  theory: <th-logic-truthtable>,
  prompt: [Lad $p,q,r,s$ være udsagn. Hvilke af følgende sammensatte udsagn er sande? (Et eller flere svar.)],
  options: (
    [Hvis $p$ er sand og $q$ er falsk, så er $p or q or r$ sand.],
    [$p and q$ er falsk hvis og kun hvis $p or q$ er falsk.],
    [Hvis $p and not q$ er sand, så er $p or not q$ også sand.],
    [$not p or not q$ er ækvivalent med $not(p and q)$.],
    [Hvis $p <-> q$ er sand, så er $not p -> not q$ også sand.],
    [Hvis $p -> q$ er sand og $p$ er falsk, så er $q$ også falsk.],
    [Sandhedstabellen for $p or q <-> r and s$ har #swap[8] rækker.],
    [Sandhedstabellen for $p or not p$ har #swap[4] rækker.],
    [$p$ kan tildeles en sandhedsværdi, så $(p <-> q) and (p plus.o q)$ er sand.],
    [Hvis $p$ er sand, kan $q$ tildeles en sandhedsværdi, så $p and (not p or not q)$ er sand.],
  ),
  answer: [Sande: 0, 2, 3, 4, 9. Falske: 1, 5, 6, 7, 8.],
  blueprint: [
    Samme fire typer som før, bare med flere påstande og op til fire variable i spil.

    + *Oversæt.* Læs #swap[hver påstand] som en formel, og find de forskellige variable.
    + *Bestem typen.* Er det en ækvivalens, en tautologi, et spørgsmål om opfyldelighed eller om antal rækker.
    + *Brug lovene direkte.* De Morgan, materiel implikation ($p #sym.arrow.r q equiv not p or q$) og kontraposition afgør de fleste påstande, uden at du tegner hele tabellen.
    + *Find et modeksempel.* En "hvis ... så"-påstand er falsk, hvis du kan gøre forleddet sandt og bagleddet falsk på samme tid.
  ],
  worked: [
    Ti påstande, hver afgjort med de relevante rækker fyldt ud.

    *(0) Hvis $p=T, q=F$, er $p or q or r$ sand?* Forleddet binder $p=T$. En disjunktion er sand, så snart ét led er sandt, og $p=T$, så $p or q or r = T$ uanset $r$. Sand.

    *(1) $p and q$ falsk $<->$ $p or q$ falsk?* Stil de to "falskhedsbetingelser" op:

    ```
    p q | p∧q | p∨q
    ----+-----+----
    T T |  T  |  T
    T F |  F  |  T
    F T |  F  |  T
    F F |  F  |  F
    ```

    $p and q$ er falsk i 3 rækker, $p or q$ er falsk i kun 1. Tag $p=T, q=F$: $p and q$ falsk, men $p or q$ sand. Bikonditionalen kræver, at "$p and q$ falsk" og "$p or q$ falsk" altid følges ad, og det gør de ikke. Falsk.

    *(2) Hvis $p and not q$ sand, så $p or not q$ sand?* $p and not q$ er kun sand i én række, $p=T, q=F$. Der er $not q=T$, så $p or not q = T or T = T$. Forled sandt medfører bagled sandt. Sand.

    *(3) $not p or not q equiv not(p and q)$?* De Morgan, tjekket række for række:

    ```
    p q | ¬p  ¬q  ¬p∨¬q | p∧q  ¬(p∧q)
    ----+-------------------+-----------
    T T |  F   F    F    |  T     F
    T F |  F   T    T    |  F     T
    F T |  T   F    T    |  F     T
    F F |  T   T    T    |  F     T
    ```

    Kolonnerne $not p or not q$ og $not(p and q)$ er ens i alle fire rækker. Sand.

    *(4) Hvis $p <-> q$ sand, så $not p -> not q$ sand?* $p <-> q$ sand betyder $p$ og $q$ ens, altså rækkerne $(T,T)$ og $(F,F)$. Tjek $not p -> not q$ i begge:

    ```
    p q | ¬p  ¬q | ¬p→¬q   (kun rækker hvor p↔q sand)
    ----+--------+------
    T T |  F   F |   T
    F F |  T   T |   T
    ```

    I begge rækker er $not p -> not q$ sand. Sand.

    *(5) Hvis $p -> q$ sand og $p$ falsk, så $q$ falsk?* Sæt $p=F$. Så er $p -> q$ sand for begge værdier af $q$. Vælg $q=T$: forleddet ($p->q$ sand, $p$ falsk) holder, men bagleddet "$q$ falsk" er forkert. Modeksempel. Falsk.

    *(6) Tabellen for $p or q <-> r and s$ har 8 rækker?* Fire forskellige variable $p,q,r,s$, så $2^4 = 16$ rækker, ikke 8. Falsk.

    *(7) Tabellen for $p or not p$ har 4 rækker?* Kun én forskellig variabel, $p$, så $2^1 = 2$ rækker, ikke 4. Falsk.

    *(8) Kan $p$ vælges, så $(p <-> q) and (p plus.o q)$ er sand?* $<->$ og $plus.o$ er hinandens negation, så de er aldrig sande samtidig:

    ```
    p q | p↔q  p⊕q | (p↔q)∧(p⊕q)
    ----+----------+-----------
    T T |  T    F   |     F
    T F |  F    T   |     F
    F T |  F    T   |     F
    F F |  T    F   |     F
    ```

    Konjunktionen er falsk i alle rækker. Ikke opfyldelig. Falsk.

    *(9) Hvis $p$ sand, kan $q$ vælges, så $p and (not p or not q)$ er sand?* Sæt $p=T$, så bliver $not p = F$, og udtrykket reducerer til $T and (F or not q) = not q$. Vælg $q=F$: $not q = T$. Så $p and (not p or not q) = T$. Opfyldelig. Sand.

    Svar: 0, 2, 3, 4, 9 er sande, resten falske.
  ],
)

#qcard(
  tag: [Udsagnslogik: hvilke udsagn er sande? (sandhedstabel)],
  source: "MCQ juni 2025, Spm. 32",
  theory: <th-logic-truthtable>,
  prompt: [Lad $p,q,r$ være udsagn. Hvilke sammensatte udsagn er sande? (Et eller flere svar.)],
  options: (
    [Hvis $p$ er sand og $q$ er falsk, så er $p or not q$ sand.],
    [Hvis $p$ er sand, så er $p plus.o p$ også sand.],
    [Sandhedstabellen for $p plus.o q$ har to rækker.],
    [Sandhedstabellen for $(p or not q) and q$ har 8 rækker.],
    [$not(p and q)$ og $not p and not q$ er ækvivalente.],
    [$p -> q$ og $p or not q$ er ækvivalente.],
    [$(p -> q) -> p$ er en tautologi.],
    [$p and q$ er en kontingens.],
  ),
  answer: [Sande: 0, 7. Falske: 1, 2, 3, 4, 5, 6.],
  blueprint: [
    Igen de fire typer, men her dukker også kontingens op, altså et udsagn der hverken er altid sandt eller altid falsk.

    + *Oversæt.* Skriv #swap[hver påstand] som en formel, og tæl de forskellige variable.
    + *Tjek de korte påstande først.* Antal rækker er $2^n$, og $p plus.o p$, $p and not p$ og lignende har en fast værdi, du kan slå op med det samme.
    + *Test ækvivalenser med lovene.* Er du i tvivl, så find én tildeling, hvor de to sider giver forskelligt. Det vælter påstanden.
    + *Aflæs slutkolonnen.* Kun T er tautologi, kun F er kontradiktion, blandet er kontingens.
  ],
  worked: [
    Otte påstande, hver afgjort med de relevante rækker.

    *(0) Hvis $p=T, q=F$, er $p or not q$ sand?* Indsæt: $not q = not F = T$, så $p or not q = T or T = T$. Sand.

    *(1) Hvis $p$ sand, er $p plus.o p$ sand?* XOR er sand, når de to led er forskellige. Her er begge led $p$, altså ens, så $p plus.o p = F$ for begge værdier af $p$:

    ```
    p | p⊕p
    --+----
    T |  F
    F |  F
    ```

    Ved $p=T$ er $p plus.o p = F$. Falsk.

    *(2) Tabellen for $p plus.o q$ har to rækker?* To forskellige variable, så $2^2 = 4$ rækker, ikke 2. Falsk.

    *(3) Tabellen for $(p or not q) and q$ har 8 rækker?* To forskellige variable $p, q$, så $2^2 = 4$ rækker, ikke 8. Falsk.

    *(4) $not(p and q) equiv not p and not q$?* Tjek begge sider:

    ```
    p q | p∧q  ¬(p∧q) | ¬p  ¬q  ¬p∧¬q
    ----+------------+-----------------
    T T |  T     F    |  F   F    F
    T F |  F     T    |  F   T    F   <- afviger
    F T |  F     T    |  T   F    F   <- afviger
    F F |  F     T    |  T   T    T
    ```

    Allerede ved $p=T, q=F$ er $not(p and q) = T$ men $not p and not q = F$. Den rigtige De Morgan er $not(p and q) equiv not p or not q$. Falsk.

    *(5) $p -> q equiv p or not q$?* Den korrekte materielle implikation er $p -> q equiv not p or q$. Tjek den påståede ækvivalens:

    ```
    p q | p→q | ¬q  p∨¬q
    ----+-----+----------
    T T |  T  |  F    T
    T F |  F  |  T    T
    F T |  T  |  F    F   <- afviger
    F F |  T  |  T    T
    ```

    Ved $p=F, q=T$ er $p -> q = T$ men $p or not q = F$. Falsk.

    *(6) $(p -> q) -> p$ tautologi?* Søg en falsk række. En implikation er kun falsk ved sandt forled og falsk bagled, altså $p -> q$ sand og $p$ falsk. Tag $p=F, q=F$:

    ```
    p q | p→q | (p→q)→p
    ----+-----+--------
    F F |  T  |  T→F = F   <- falsk
    ```

    Der findes en falsk række, så det er ingen tautologi. Falsk.

    *(7) $p and q$ kontingens?* En kontingens er hverken altid sand eller altid falsk:

    ```
    p q | p∧q
    ----+----
    T T |  T   <- sand her
    T F |  F
    F T |  F
    F F |  F   <- falsk her
    ```

    Sand i én række, falsk i tre. Blandet, altså kontingens. Sand.

    Svar: 0 og 7 er sande, resten falske.
  ],
)

#qcard(
  tag: [Udsagnslogik: find de ækvivalente udsagn (ækvivalens)],
  source: "DM547 Reeksamen marts 2019, Spm. 3",
  theory: <th-logic-equiv>,
  prompt: [Hvilke udsagn er ækvivalente med #swap[$not(p and q)$]?],
  options: (
    [$p or q$],
    [$not p or q$],
    [$not p or not q$],
    [$(p plus.o q) or (not p and not q)$],
    [$p -> q$],
    [$p -> not q$],
    [$q -> not p$],
    [$p <-> not q$],
  ),
  answer: [Ækvivalente: 2, 3, 5, 6 (svarende til opg. 3.3, 3.4, 3.6, 3.7).],
  blueprint: [
    Du skal finde de udsagn, der har samme sandhedstabel som et givet måludtryk.

    + *Læg målet fast.* Find sandhedstabellen for #swap[$not(p and q)$], altså i hvilke rækker den er sand og falsk.
    + *Tjek hver kandidat.* Sammenlign kandidatens kolonne med målet, række for række.
    + *Brug lovene som genvej.* De Morgan, materiel implikation og kontraposition omskriver tit en kandidat til målet uden tabel.
    + *Et udsagn er ækvivalent*, hvis det matcher i alle rækker. Én afvigende række er nok til at forkaste det.
  ],
  worked: [
    Læg først målets kolonne fast. $not(p and q)$ er falsk netop dér, hvor $p and q$ er sand, altså kun ved $(T,T)$:

    ```
    p q | p∧q | ¬(p∧q)  = MÅL
    ----+-----+--------
    T T |  T  |   F
    T F |  F  |   T
    F T |  F  |   T
    F F |  F  |   T
    ```

    Målmønstret er altså $F, T, T, T$ ned gennem rækkerne. Hver kandidat fyldes ud og holdes op mod det.

    *(0) $p or q$*:

    ```
    p q | p∨q | MÅL
    ----+-----+----
    T T |  T  |  F   <- afviger
    T F |  T  |  T
    F T |  T  |  T
    F F |  F  |  T   <- afviger
    ```
    Afviger ved $(T,T)$. Nej.

    *(1) $not p or q$*:

    ```
    p q | ¬p  ¬p∨q | MÅL
    ----+----------+----
    T T |  F    T  |  F   <- afviger
    T F |  F    F  |  T   <- afviger
    F T |  T    T  |  T
    F F |  T    T  |  T
    ```
    Afviger ved $(T,T)$ og $(T,F)$. Nej.

    *(2) $not p or not q$* — De Morgan:

    ```
    p q | ¬p  ¬q  ¬p∨¬q | MÅL
    ----+-------------------+----
    T T |  F   F    F    |  F
    T F |  F   T    T    |  T
    F T |  T   F    T    |  T
    F F |  T   T    T    |  T
    ```
    Ens i alle fire. Ja.

    *(3) $(p plus.o q) or (not p and not q)$*:

    ```
    p q | p⊕q  ¬p∧¬q | (p⊕q)∨(¬p∧¬q) | MÅL
    ----+------------+--------------+----
    T T |  F     F   |      F        |  F
    T F |  T     F   |      T        |  T
    F T |  T     F   |      T        |  T
    F F |  F     T   |      T        |  T
    ```
    Ens i alle fire. Ja.

    *(4) $p -> q$* (materiel implikation $= not p or q$):

    ```
    p q | p→q | MÅL
    ----+-----+----
    T T |  T  |  F   <- afviger
    T F |  F  |  T   <- afviger
    F T |  T  |  T
    F F |  T  |  T
    ```
    Afviger. Nej.

    *(5) $p -> not q$* $equiv not p or not q$:

    ```
    p q | ¬q  p→¬q | MÅL
    ----+----------+----
    T T |  F    F  |  F
    T F |  T    T  |  T
    F T |  F    T  |  T
    F F |  T    T  |  T
    ```
    Ens i alle fire (samme kolonne som (2)). Ja.

    *(6) $q -> not p$* $equiv not q or not p$:

    ```
    p q | ¬p  q→¬p | MÅL
    ----+----------+----
    T T |  F    F  |  F
    T F |  F    T  |  T
    F T |  T    T  |  T
    F F |  T    T  |  T
    ```
    Ens i alle fire. Ja.

    *(7) $p <-> not q$*:

    ```
    p q | ¬q  p↔¬q | MÅL
    ----+----------+----
    T T |  F    F  |  F
    T F |  T    T  |  T
    F T |  F    F  |  T   <- afviger
    F F |  T    F  |  T   <- afviger
    ```
    Afviger ved $(F,T)$ og $(F,F)$. Nej.

    Svar: 2, 3, 5, 6 er ækvivalente med $not(p and q)$.
  ],
)
