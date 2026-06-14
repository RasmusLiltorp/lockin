#import "../lib.typ": *

== Relationer, ækvivalens og ordning

En relation på $A$ er en samling ordnede par fra $A$. Du skriver $(a,b) in R$ når $a$ er relateret til $b$:

#eq[$ R subset.eq A times A $]

Til eksamen får du en relation som liste, matrix eller graf. Du skal afgøre hvilke egenskaber den har, om den er ækvivalensrelation eller ordning, eller udregne en lukning eller ækvivalensklasserne. Alt bygger på fire egenskaber og tre definitioner.

=== Sådan løser du den

Læs relationen som en graf: hvert element er en knude, og $(a,b) in R$ er en pil fra $a$ til $b$. De fire egenskaber bliver da til billeder, du kan aflæse.

#recipe(
  title: "Tjek de fire egenskaber",
  [*Refleksiv.* Hvert element peger på sig selv.
  #eq[$ (a,a) in R "for alle" a in A $]
  Graf: løkke på hver knude. Matrix: hele diagonalen er $1$. Mangler bare én løkke, er den ikke refleksiv.],
  [*Symmetrisk.* Går en pil den ene vej, går den også den anden.
  #eq[$ (a,b) in R ==> (b,a) in R $]
  Hver pil skal have sin modsatte. Én pil uden makker vælter det.],
  [*Antisymmetrisk.* To forskellige elementer peger aldrig begge veje.
  #eq[$ (a,b) in R and (b,a) in R ==> a = b $]
  Find ét par $(a,b)$ og $(b,a)$ med $a != b$, så fejler den. Løkker er tilladt.],
  [*Transitiv.* Kan du gå $a -> b -> c$, skal genvejen $a -> c$ også være der.
  #eq[$ (a,b) in R and (b,c) in R ==> (a,c) in R $]
  Tjek hver to-trins-kæde for sin genvej. Ét hul vælter det.],
)

Antisymmetrisk er ikke det modsatte af symmetrisk. En relation kan være begge dele ($=$) eller ingen af delene.

#recipe(
  title: "Klassificér relationen",
  [*Ækvivalensrelation:* refleksiv, symmetrisk og transitiv. Den deler $A$ op i klasser. Klassen for $a$ er alt, $a$ er relateret til:
  #eq[$ [a] = { x in A mid(|) (a,x) in R } $]
  Klasserne overlapper ikke og dækker hele $A$ — en partition.],
  [*Partiel ordning:* refleksiv, antisymmetrisk og transitiv. Som ækvivalens, men antisymmetrisk i stedet for symmetrisk. Eksempler: $<=$ på tal og "går op i" på heltal.],
  [*Total ordning:* en partiel ordning hvor alle par kan sammenlignes, altså $(a,b) in R$ eller $(b,a) in R$ for ethvert par. $<=$ er total; "går op i" er ikke ($2$ og $3$ går ikke op i hinanden).],
)

En lukning er den mindste relation, der indeholder $R$ og har en ønsket egenskab. Du tilføjer kun par, fjerner aldrig.

#recipe(
  title: "Udregn en lukning",
  [*Refleksiv lukning:* tilføj en løkke på hvert element i $A$.
  #eq[$ r(R) = R union { (a,a) mid(|) a in A } $]
  Husk også løkker på elementer, der ikke optræder i noget par.],
  [*Symmetrisk lukning:* tilføj den modsatte af hvert par.
  #eq[$ s(R) = R union R^(-1) $]
  Tilføj ikke diagonalløkker — det hører til den refleksive lukning.],
  [*Transitiv lukning:* tilføj genveje, til der ikke er flere.
  #eq[$ t(R): quad (a,b), (b,c) in R ==> "tilføj" (a,c) $]
  Gentag på den voksende mængde, til intet nyt dukker op. $(a,c)$ er med, hvis der findes en sti fra $a$ til $c$ i grafen.],
)

#note[$=$ er refleksiv, symmetrisk og antisymmetrisk på én gang — altså både ækvivalensrelation og partiel ordning. "Samme paritet" og "kongruens mod $m$" er ækvivalensrelationer; $<=$ og "går op i" er partielle ordninger.]

#trap[Der findes ingen antisymmetrisk lukning. En lukning tilføjer kun par, men antisymmetri kræver, at du fjerner enten $(a,b)$ eller $(b,a)$ når $a != b$.]

#trap[Refleksiv lukning rammer hvert element i $A$, også dem uden par. På $A = {1,2,3,4}$ med $R = {(1,3),(2,2)}$ tilføjer du $(1,1), (3,3)$ og $(4,4)$, selvom $4$ ikke står i noget par.]

Et *Hasse-diagram* tegner en partiel ordning uden støj. Fjern alle løkker og hver kant, der følger af transitivitet; behold kun kanter, hvor intet element ligger strengt imellem. Tegn det mindste element nederst og udelad pilespidser. Et element er maksimalt, hvis ingen linje går opad fra det, og minimalt, hvis ingen går nedad.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  source: "MCQ juni 2025, Spm. 35 (flere korrekte)",
  prompt: [Lad $R = #swap[${(a,a),(a,b),(b,a),(c,c)}$]$ være en relation på ${a,b,c}$. Hvilke udsagn er sande?],
  options: (
    [$R$ er refleksiv],
    [$R$ er symmetrisk],
    [$R$ er antisymmetrisk],
    [$R$ er transitiv],
    [$R$ er en ækvivalensrelation],
    [$R$ er en partiel ordning],
  ),
  answer: [Kun (b), $R$ er symmetrisk.],
  worked: [Refleksiv: $(b,b)$ mangler, nej. Symmetrisk: $(a,b)$ har $(b,a)$, og løkkerne er deres egne makkere, ja. Antisymmetrisk: $(a,b)$ og $(b,a)$ med $a != b$, nej. Transitiv: $(b,a)$ og $(a,b)$ kræver $(b,b)$, som mangler, nej. Ækvivalens og partiel ordning fejler dermed begge.],
)

#qcard(
  source: "MCQ juni 2025, Spm. 36 (flere korrekte)",
  prompt: [Lad $A = {a,b,c,d}$. Hvilke udsagn er sande?],
  options: (
    [Den refleksive lukning af $emptyset$ på $A$ er ${(a,a),(b,b),(c,c),(d,d)}$],
    [Den refleksive lukning af ${(a,b),(b,c)}$ på $A$ er ${(a,c)}$],
    [Den symmetriske lukning af ${(a,a),(a,b),(c,d)}$ på $A$ er ${(a,a),(a,b),(b,a),(b,b),(c,c),(c,d),(d,c),(d,d)}$],
    [Den symmetriske lukning af ${(a,b),(b,a),(b,c)}$ på $A$ er ${(a,b),(b,a)}$],
    [Den transitive lukning af $#swap[${(a,b),(b,c),(c,d)}$]$ på $A$ er ${(a,b),(a,c),(a,d),(b,c),(b,d),(c,d)}$],
    [Den transitive lukning af ${(a,b),(c,d)}$ på $A$ er ${(a,b),(c,d)}$],
  ),
  answer: [(a), (e) og (f).],
  worked: [(a): refleksiv lukning af den tomme relation er præcis diagonalen, passer. (b): refleksiv lukning tilføjer løkker, ikke $(a,c)$, falsk. (c): symmetrisk lukning tilføjer ikke løkkerne $(b,b),(c,c),(d,d)$, falsk. (d): mangler $(b,c)$ og $(c,b)$, falsk. (e): genvejene $(a,c),(b,d),(a,d)$ langs kæden $a -> b -> c -> d$, passer. (f): ingen par kan kædes sammen, uændret, passer.],
)

#qcard(
  source: "MCQ juni 2023, Spm. 36 (3 point)",
  prompt: [Betragt relationen på ${a,b,c}$: $R = #swap[${(a,b),(b,a),(b,b),(b,c)}$]$. Angiv den transitive lukning af $R$.],
  answer: [$t(R) = {(a,a),(a,b),(a,c),(b,a),(b,b),(b,c)}$.],
  worked: [$b$ når $a, b$ og $c$. Da $(a,b)$ gælder, når $a$ alt det $b$ når: $(a,b)+(b,a)$ giver $(a,a)$, $(a,b)+(b,c)$ giver $(a,c)$, $(a,b)+(b,b)$ giver $(a,b)$. $c$ har ingen udgående kanter, så ingen nye par.],
)

#qcard(
  source: "DM547 januar 2021, Spørgsmål 7 (3%)",
  prompt: [Angiv den symmetriske lukning af $T = #swap[${(a,b),(b,b),(c,d),(d,e)}$]$.],
  answer: [$s(T) = {(a,b),(b,a),(b,b),(c,d),(d,c),(d,e),(e,d)}$.],
  worked: [$s(T) = T union T^(-1)$: tilføj den modsatte af hvert par, altså $(b,a), (d,c)$ og $(e,d)$. $(b,b)$ er sin egen modsatte. Tilføj ikke diagonalløkker, kæd ikke par sammen.],
)

#qcard(
  source: "DM547 januar 2021, Spørgsmål 6 (8%)",
  prompt: [En digraf for relationen $S$ på ${a,b,c,d,e,f}$ har løkker på $a,b,e,f$, kanterne $a->b$, $a->c$, $a->d$, $a->e$, $b->e$, $c->d$, $f->d$, og tovejsparret $e<->f$. Hvilke af følgende gælder: refleksiv, symmetrisk, antisymmetrisk, transitiv, ækvivalensrelation, partiel ordning, total ordning?],
  answer: [Ingen af dem.],
  worked: [Refleksiv: $c$ og $d$ har ingen løkke, nej. Symmetrisk: $a->b$ uden $b->a$, nej. Antisymmetrisk: $e<->f$ med $e != f$, nej. Transitiv: $e->f$ og $f->d$, men intet $e->d$, nej. Når alle fire grundegenskaber fejler, fejler de tre ordningstyper også.],
)

#qcard(
  source: "SE4-DMAD juni 2024, Spm. 6 (4%)",
  prompt: [På ${a,b,c}$, hvilke af disse er ækvivalensrelationer?],
  options: (
    [${(a,a),(b,b),(c,c)}$],
    [${(a,a),(a,b),(b,a),(b,b)}$],
    [${(a,a),(a,b),(b,b),(c,c)}$],
    [${(a,a),(a,b),(b,b),(b,c),(c,c)}$],
    [${(a,a),(a,b),(b,a),(b,b),(c,c)}$],
  ),
  answer: [(a) og (e).],
  worked: [Skal være refleksiv, symmetrisk og transitiv på ${a,b,c}$. (a): bare diagonalen, alle tre holder. (b): $(c,c)$ mangler, ikke refleksiv. (c): $(a,b)$ uden $(b,a)$, ikke symmetrisk. (d): $(a,b)$ uden $(b,a)$, ikke symmetrisk. (e): refleksiv, symmetrisk via $(a,b),(b,a)$, og transitiv (${a,b}$ som blok plus $c$ alene).
  #v(4pt)
  Klasserne i (e): $[a] = [b] = {a,b}$ og $[c] = {c}$, disjunkte og dækkende.],
)
