#import "../lib.typ": *

== Udsagnslogik og sandhedstabeller

Et udsagn er enten sandt eller falsk. Konnektiverne $not$ (ikke), $and$ (og), $or$ (eller), $->$ (medfører), $<->$ (hvis og kun hvis) og $plus.o$ (XOR) binder udsagn sammen til større udsagn.

En sandhedstabel skriver alle muligheder op. Hver variabel er sand (T) eller falsk (F), så $n$ variable giver

#eq[$ 2^n $]

rækker. For hver række afgør du, om hele udsagnet er sandt.

Eksamen giver en liste påstande og spørger, hvilke der er sande. Du skal kunne fire ting: afgøre om to udsagn er ækvivalente, om et udsagn er en tautologi, om det er opfyldeligt, og antal rækker i tabellen.

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
  [Læs sidste kolonne: alle T er tautologi, alle F kontradiktion, blandet kontingens.],
)

#recipe(
  title: "Svar på de fire spørgsmålstyper",
  [*Ækvivalens* ($A equiv B$): stil de to kolonner op side om side. Ens i alle rækker betyder ækvivalente; én afvigende række afgør det.],
  [*Tautologi*: sidste kolonne er T overalt. Genvej for $X -> Y$: antag det falsk ($X$ sand, $Y$ falsk) og søg en modstrid. Findes ingen, er det en tautologi.],
  [*Opfyldelig* ("kan $p$ tildeles, så $Z$ bliver sand"): ja, hvis blot én række gør $Z$ sand.],
  [*Antal rækker*: $2^n$, hvor $n$ er antal #swap[forskellige] variable.],
)

Lær de tilbagevendende ækvivalenser udenad. De Morgan:

#eq[$ not(p and q) equiv not p or not q quad quad not(p or q) equiv not p and not q $]

Materiel implikation og kontraposition:

#eq[$ p -> q equiv not p or q quad quad p -> q equiv not q -> not p $]

Biimplikation:

#eq[$ p <-> q equiv (p -> q) and (q -> p) $]

#trap(title: [Tæl forskellige variable])[Tæl *forskellige* variable. $p or not p$ har én, altså 2 rækker, ikke 4. $(p or not q) and q$ har to, altså 4, ikke 8.]

#trap(title: [Omvendt og invers])[Kontrapositionen $not q -> not p$ er ækvivalent med $p -> q$. Den omvendte $q -> p$ og den inverse $not p -> not q$ er det ikke, men er ækvivalente med hinanden.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Udsagnslogik: hvilke udsagn er sande?],
  source: "MCQ juni 2023, Spm. 33",
  prompt: [Lad $p,q,r$ være udsagn. Hvilke af nedenstående udsagn er sande? (Et eller flere svar.)],
  options: (
    [$(p and q) or (p and not q)$ er ækvivalent med #swap[$p$].],
    [Hvis $p <-> not q$ er sand, så er $p and not q$ også sand.],
    [$p -> (p or q)$ er en tautologi.],
    [Hvis $q$ er sand og $r$ er falsk, kan $p$ tildeles en sandhedsværdi, så $(not p and q) or (p and r)$ er sand.],
    [Sandhedstabellen for $(p -> q) and r$ har #swap[otte] rækker.],
  ),
  answer: [Sande: 0, 2, 3, 4. Falsk: 1.],
  worked: [
    (0) $(p and q) or (p and not q) = p and (q or not q) = p$. Sand.
    #linebreak() (1) $p=F, q=T$: $p <-> not q$ bliver $F <-> F = T$, men $p and not q = F$. Falsk.
    #linebreak() (2) Sand om $p$ er sand ($p or q$ sand) eller falsk (tom opfyldelse). Tautologi.
    #linebreak() (3) $q=T, r=F$ reducerer formlen til $not p$; vælg $p=F$. Opfyldelig.
    #linebreak() (4) Tre variable giver $2^3 = 8$ rækker. Sand.],
)

#qcard(
  tag: [Udsagnslogik: hvilke udsagn er sande?],
  source: "MCQ juni 2021, Spm. 34",
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
  worked: [
    (0) $p$ sand gør disjunktionen sand. Sand.
    #linebreak() (1) $p and q$ er falsk i 3 rækker, $p or q$ kun i 1. Falsk.
    #linebreak() (2) $p and not q$ tvinger $p$ sand, så $p or not q$ er sand. Sand.
    #linebreak() (3) De Morgan, præcis ens. Sand.
    #linebreak() (4) $p <-> q$ betyder $p = q$, så $not p -> not q$ gælder altid. Sand.
    #linebreak() (5) $p$ falsk gør $p -> q$ sand for begge værdier af $q$. Falsk.
    #linebreak() (6) Fire forskellige variable giver $2^4 = 16$ rækker, ikke 8. Falsk.
    #linebreak() (7) Én variabel giver $2^1 = 2$ rækker, ikke 4. Falsk.
    #linebreak() (8) $<->$ og $plus.o$ er hinandens negation, så konjunktionen er aldrig sand. Falsk.
    #linebreak() (9) $p=T, q=F$ giver $T and (F or T) = T$. Sand.],
)

#qcard(
  tag: [Udsagnslogik: hvilke udsagn er sande?],
  source: "MCQ juni 2025, Spm. 32",
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
  worked: [
    (0) $p=T, q=F$ giver $not q = T$, så $p or T = T$. Sand.
    #linebreak() (1) $p plus.o p = F$ altid. Falsk.
    #linebreak() (2) $p plus.o q$ har to variable, altså $2^2 = 4$ rækker. Falsk.
    #linebreak() (3) $(p or not q) and q$ har to variable, altså 4 rækker. Falsk.
    #linebreak() (4) Ved $p=T, q=F$: $not(T and F) = T$, men $not T and not F = F$. Den rigtige lov er $not(p and q) equiv not p or not q$. Falsk.
    #linebreak() (5) $p -> q equiv not p or q$, ikke $p or not q$. Ved $p=F, q=T$ er de forskellige. Falsk.
    #linebreak() (6) Ved $p=F, q=F$: $p -> q = T$, så $T -> F = F$. Falsk.
    #linebreak() (7) $p and q$ er kun sand ved $(T,T)$, falsk ellers. Blandet, altså kontingens. Sand.],
)

#qcard(
  tag: [Udsagnslogik: find de ækvivalente udsagn],
  source: "DM547 Reeksamen marts 2019, Spm. 3",
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
  worked: [Målkolonnen $not(p and q)$ er falsk i præcis én række, $(T,T)$, og sand i de tre andre. Sammenlign hver kandidats kolonne med den.
    #linebreak() (0) $p or q$ er sand ved $(T,T)$. Nej.
    #linebreak() (1) $not p or q$ er falsk ved $(T,F)$. Nej.
    #linebreak() (2) De Morgan, præcis ens. Ja.
    #linebreak() (3) Sand undtagen ved $(T,T)$. Ja.
    #linebreak() (4) $p -> q$ er falsk ved $(T,F)$. Nej.
    #linebreak() (5) $p -> not q equiv not p or not q$. Ja.
    #linebreak() (6) $q -> not p equiv not q or not p$. Ja.
    #linebreak() (7) $p <-> not q$ er falsk ved $(T,T)$ og $(F,F)$. Nej.],
)
