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
    Her er de fem påstande, kørt igennem hver for sig.

    + (0) $(p and q) or (p and not q) = p and (q or not q) = p$. Sand.
    + (1) Prøv $p=F, q=T$. Så bliver $p <-> not q$ til $F <-> F = T$, men $p and not q = F$. Sand antagelse, falsk konklusion, så påstanden er falsk.
    + (2) Er $p$ sand, er $p or q$ sand. Er $p$ falsk, er implikationen sand af sig selv. Tautologi.
    + (3) Med $q=T, r=F$ skrumper formlen til $not p$. Vælg $p=F$, så er den sand. Opfyldelig.
    + (4) Tre variable giver $2^3 = 8$ rækker. Sand.

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
    Ti påstande, en linje per styk.

    + (0) $p$ sand gør disjunktionen (disjunction) sand. Sand.
    + (1) $p and q$ er falsk i 3 rækker, $p or q$ kun i 1, så de falder ikke sammen. Falsk.
    + (2) $p and not q$ tvinger $p$ sand, så $p or not q$ er sand. Sand.
    + (3) De Morgan, præcis ens. Sand.
    + (4) $p <-> q$ betyder $p = q$, så $not p -> not q$ gælder altid. Sand.
    + (5) $p$ falsk gør $p -> q$ sand for begge værdier af $q$. Falsk.
    + (6) Fire forskellige variable giver $2^4 = 16$ rækker, ikke 8. Falsk.
    + (7) Én variabel giver $2^1 = 2$ rækker, ikke 4. Falsk.
    + (8) $<->$ og $plus.o$ er hinandens negation, så konjunktionen (conjunction) er aldrig sand. Falsk.
    + (9) $p=T, q=F$ giver $T and (F or T) = T$. Sand.

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
    Otte påstande, en linje hver.

    + (0) $p=T, q=F$ giver $not q = T$, så $p or T = T$. Sand.
    + (1) $p plus.o p = F$ altid. Falsk.
    + (2) $p plus.o q$ har to variable, altså $2^2 = 4$ rækker, ikke to. Falsk.
    + (3) $(p or not q) and q$ har to variable, altså 4 rækker, ikke 8. Falsk.
    + (4) Ved $p=T, q=F$ er $not(T and F) = T$, men $not T and not F = F$. Den rigtige lov er $not(p and q) equiv not p or not q$. Falsk.
    + (5) $p -> q equiv not p or q$, ikke $p or not q$. Ved $p=F, q=T$ er de forskellige. Falsk.
    + (6) Ved $p=F, q=F$ er $p -> q = T$, så $(p -> q) -> p$ bliver $T -> F = F$. Falsk.
    + (7) $p and q$ er kun sand ved $(T,T)$, falsk ellers. Blandet, altså kontingens. Sand.

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
    Målet $not(p and q)$ er falsk i præcis én række, $(T,T)$, og sand i de tre andre. Hold hver kandidat op mod det.

    + (0) $p or q$ er sand ved $(T,T)$, hvor målet er falsk. Nej.
    + (1) $not p or q$ er falsk ved $(T,F)$, hvor målet er sand. Nej.
    + (2) De Morgan, præcis ens. Ja.
    + (3) Sand undtagen ved $(T,T)$, altså samme mønster. Ja.
    + (4) $p -> q$ er falsk ved $(T,F)$. Nej.
    + (5) $p -> not q equiv not p or not q$, samme som målet. Ja.
    + (6) $q -> not p equiv not q or not p$, igen samme. Ja.
    + (7) $p <-> not q$ er falsk ved $(T,T)$ og $(F,F)$. Nej.

    Svar: 2, 3, 5, 6 er ækvivalente med $not(p and q)$.
  ],
)
