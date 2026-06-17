#import "../lib.typ": *

== Relationer, ækvivalens og ordning

En relation (relation) på $A$ er en samling ordnede par (ordered pairs) fra $A$. Du skriver $(a,b) in R$ når $a$ er relateret til $b$:

#eq[$ R subset.eq A times A $]

Til eksamen får du en relation som liste, matrix eller graf. Du skal afgøre hvilke egenskaber den har, om den er ækvivalensrelation (equivalence relation) eller ordning (order), eller udregne en lukning (closure) eller ækvivalensklasserne (equivalence classes). Alt bygger på fire egenskaber og tre definitioner.

=== Sådan løser du den

Læs relationen som en graf: hvert element er en knude, og $(a,b) in R$ er en pil fra $a$ til $b$. De fire egenskaber bliver da til billeder, du kan aflæse.

#recipe(
  title: "Tjek de fire egenskaber",
  [*Refleksiv (reflexive).* Hvert element peger på sig selv.
  #eq[$ (a,a) in R "for alle" a in A $]
  Graf: løkke på hver knude. Matrix: hele diagonalen er $1$. Mangler bare én løkke, er den ikke refleksiv.],
  [*Symmetrisk (symmetric).* Går en pil den ene vej, går den også den anden.
  #eq[$ (a,b) in R ==> (b,a) in R $]
  Hver pil skal have sin modsatte. Én pil uden makker vælter det.],
  [*Antisymmetrisk (antisymmetric).* To forskellige elementer peger aldrig begge veje.
  #eq[$ (a,b) in R and (b,a) in R ==> a = b $]
  Find ét par $(a,b)$ og $(b,a)$ med $a != b$, så fejler den. Løkker er tilladt.],
  [*Transitiv (transitive).* Kan du gå $a -> b -> c$, skal genvejen $a -> c$ også være der.
  #eq[$ (a,b) in R and (b,c) in R ==> (a,c) in R $]
  Tjek hver to-trins-kæde for sin genvej. Ét hul vælter det.],
)

Antisymmetrisk er ikke det modsatte af symmetrisk. En relation kan være begge dele ($=$) eller ingen af delene.

#recipe(
  title: "Klassificér relationen",
  [*Ækvivalensrelation:* refleksiv, symmetrisk og transitiv. Den deler $A$ op i klasser. Klassen for $a$ er alt, $a$ er relateret til:
  #eq[$ [a] = { x in A mid(|) (a,x) in R } $]
  Klasserne overlapper ikke og dækker hele $A$ — en partition (partition).],
  [*Partiel ordning (partial order):* refleksiv, antisymmetrisk og transitiv. Som ækvivalens, men antisymmetrisk i stedet for symmetrisk. Eksempler: $<=$ på tal og "går op i" på heltal.],
  [*Total ordning (total order):* en partiel ordning hvor alle par kan sammenlignes, altså $(a,b) in R$ eller $(b,a) in R$ for ethvert par. $<=$ er total; "går op i" er ikke ($2$ og $3$ går ikke op i hinanden).],
)

En lukning er den mindste relation, der indeholder $R$ og har en ønsket egenskab. Du tilføjer kun par, fjerner aldrig.

#recipe(
  title: "Udregn en lukning",
  [*Refleksiv lukning (reflexive closure):* tilføj en løkke på hvert element i $A$.
  #eq[$ r(R) = R union { (a,a) mid(|) a in A } $]
  Husk også løkker på elementer, der ikke optræder i noget par.],
  [*Symmetrisk lukning (symmetric closure):* tilføj den modsatte af hvert par.
  #eq[$ s(R) = R union R^(-1) $]
  Tilføj ikke diagonalløkker — det hører til den refleksive lukning.],
  [*Transitiv lukning (transitive closure):* tilføj genveje, til der ikke er flere.
  #eq[$ t(R): quad (a,b), (b,c) in R ==> "tilføj" (a,c) $]
  Gentag på den voksende mængde, til intet nyt dukker op. $(a,c)$ er med, hvis der findes en sti fra $a$ til $c$ i grafen.],
)

#note(title: [Relationstyper])[$=$ er refleksiv, symmetrisk og antisymmetrisk på én gang — altså både ækvivalensrelation og partiel ordning. "Samme paritet" og "kongruens mod $m$" er ækvivalensrelationer; $<=$ og "går op i" er partielle ordninger.]

#trap(title: [Antisymmetrisk lukning])[Der findes ingen antisymmetrisk lukning. En lukning tilføjer kun par, men antisymmetri kræver, at du fjerner enten $(a,b)$ eller $(b,a)$ når $a != b$.]

#trap(title: [Refleksiv lukning])[Refleksiv lukning rammer hvert element i $A$, også dem uden par. På $A = {1,2,3,4}$ med $R = {(1,3),(2,2)}$ tilføjer du $(1,1), (3,3)$ og $(4,4)$, selvom $4$ ikke står i noget par.]

Et *Hasse-diagram (Hasse diagram)* tegner en partiel ordning uden støj. Fjern alle løkker og hver kant, der følger af transitivitet; behold kun kanter, hvor intet element ligger strengt imellem. Tegn det mindste element nederst og udelad pilespidser. Et element er maksimalt (maximal), hvis ingen linje går opad fra det, og minimalt (minimal), hvis ingen går nedad.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Relation: hvilke egenskaber har den?],
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
  blueprint: [
    Du har en relation som liste og skal afgøre hvilke egenskaber den har. Gå de fire grundegenskaber igennem hver for sig, og lad de to klassificeringer falde ud af dem.

    + *Refleksiv?* Tjek at $(x,x)$ er med for hvert element i #swap[grundmængden]. Mangler bare én løkke, er svaret nej.
    + *Symmetrisk?* For hvert par $(x,y)$ i #swap[relationen], er $(y,x)$ så også med? Ét par uden makker vælter den.
    + *Antisymmetrisk?* Find to forskellige elementer hvor både $(x,y)$ og $(y,x)$ er med. Findes et sådant par, er den ikke antisymmetrisk.
    + *Transitiv?* For hver kæde $(x,y)$ og $(y,z)$ skal genvejen $(x,z)$ være der. Ét manglende par vælter den.
    + Saml op: refleksiv + symmetrisk + transitiv giver ækvivalensrelation, refleksiv + antisymmetrisk + transitiv giver partiel ordning.
  ],
  worked: [
    Relationen er #swap[${(a,a),(a,b),(b,a),(c,c)}$] på ${a,b,c}$.

    - *Refleksiv?* $(b,b)$ mangler #sym.arrow.r nej.
    - *Symmetrisk?* $(a,b)$ har sin makker $(b,a)$, og løkkerne $(a,a),(c,c)$ er deres egne makkere #sym.arrow.r ja.
    - *Antisymmetrisk?* $(a,b)$ og $(b,a)$ er begge med med $a != b$ #sym.arrow.r nej.
    - *Transitiv?* $(b,a)$ og $(a,b)$ kræver $(b,b)$, som mangler #sym.arrow.r nej.

    Ækvivalensrelation kræver refleksiv, og partiel ordning kræver antisymmetrisk. Begge fejler, så ingen af dem holder.

    Svar: kun (b).
  ],
)

#qcard(
  tag: [Relation: hvilke egenskaber har den?],
  source: "MCQ juni 2021, Spm. 37 (flere rigtige)",
  prompt: [Betragt relationen $R$ på ${a,b,c}$: $R = #swap[${(a,a),(a,b),(a,c),(b,b),(b,c),(c,c)}$]$. Hvilke udsagn om $R$ er sande?],
  options: (
    [$R$ er refleksiv],
    [$R$ er symmetrisk],
    [$R$ er antisymmetrisk],
    [$R$ er transitiv],
    [$R$ er en ækvivalensrelation],
    [$R$ er en partiel ordning],
  ),
  answer: [Mulighed (a), (c), (d), (f): $R$ er refleksiv, antisymmetrisk, transitiv og en partiel ordning.],
  blueprint: [
    Du har en relation som liste og skal afgøre hvilke egenskaber den har. Gå de fire grundegenskaber igennem hver for sig, og lad de to klassificeringer falde ud af dem.

    + *Refleksiv?* Tjek at $(x,x)$ er med for hvert element i #swap[grundmængden]. Mangler bare én løkke, er svaret nej.
    + *Symmetrisk?* Har hvert par $(x,y)$ sin makker $(y,x)$? Ét par uden makker vælter den.
    + *Antisymmetrisk?* Find to forskellige elementer hvor både $(x,y)$ og $(y,x)$ er med. Findes et sådant par, er den ikke antisymmetrisk.
    + *Transitiv?* For hver kæde $(x,y),(y,z)$ skal genvejen $(x,z)$ være der. Ét manglende par vælter den.
    + Saml op: refleksiv + symmetrisk + transitiv giver ækvivalensrelation, refleksiv + antisymmetrisk + transitiv giver partiel ordning.
  ],
  worked: [
    Relationen er #swap[${(a,a),(a,b),(a,c),(b,b),(b,c),(c,c)}$] på ${a,b,c}$.

    - *Refleksiv?* $(a,a),(b,b),(c,c)$ er alle med #sym.arrow.r ja.
    - *Symmetrisk?* $(a,b)$ er med, men $(b,a)$ mangler #sym.arrow.r nej.
    - *Antisymmetrisk?* De eneste tovejspar er på diagonalen, så $x = y$ holder #sym.arrow.r ja.
    - *Transitiv?* $(a,b),(b,c)$ lukker med $(a,c)$, som er der; alle kæder lukker #sym.arrow.r ja.

    Ækvivalensrelation kræver symmetri, som fejler. Partiel ordning kræver refleksiv, antisymmetrisk og transitiv, som alle holder.

    Svar: (a), (c), (d), (f).
  ],
)

#qcard(
  tag: [Lukninger: er den angivne lukning korrekt?],
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
  blueprint: [
    Hvert udsagn påstår en bestemt lukning af #swap[en relation]. Regn lukningen selv og sammenlign med påstanden. Hold styr på hvilken slags lukning der spørges om, for de tilføjer hver sin slags par.

    + *Refleksiv lukning:* tilføj en løkke $(x,x)$ på hvert element i #swap[grundmængden], også dem uden par. Tilføj intet andet.
    + *Symmetrisk lukning:* tilføj den modsatte $(y,x)$ for hvert par $(x,y)$. Tilføj ikke løkker, og kæd ikke par sammen.
    + *Transitiv lukning:* tilføj genveje $(x,z)$ så længe der findes en kæde $(x,y),(y,z)$. Gentag på den voksende mængde til intet nyt dukker op.
    + Sammenlign din mængde med påstanden par for par. Stemmer de præcist, er udsagnet sandt.
  ],
  worked: [
    Grundmængden er $A = {a,b,c,d}$. Tjek hvert udsagn for sig.

    - *(a)* Refleksiv lukning af $emptyset$ er præcis diagonalen ${(a,a),(b,b),(c,c),(d,d)}$ #sym.arrow.r passer.
    - *(b)* Refleksiv lukning tilføjer løkker, ikke genvejen $(a,c)$ #sym.arrow.r falsk.
    - *(c)* Symmetrisk lukning tilføjer kun modsatte par, ikke løkkerne $(b,b),(c,c),(d,d)$ #sym.arrow.r falsk.
    - *(d)* $(b,c)$ skal blive til $(b,c),(c,b)$, men begge mangler i påstanden #sym.arrow.r falsk.
    - *(e)* Langs kæden $a -> b -> c -> d$ får du genvejene $(a,c),(b,d),(a,d)$, og det er netop mængden #sym.arrow.r passer.
    - *(f)* $(a,b)$ og $(c,d)$ kan ikke kædes sammen, så relationen er uændret #sym.arrow.r passer.

    Svar: (a), (e) og (f).
  ],
)

#qcard(
  tag: [Lukning: udregn den transitive lukning],
  source: "MCQ juni 2023, Spm. 36 (3 point)",
  prompt: [Betragt relationen på ${a,b,c}$: $R = #swap[${(a,b),(b,a),(b,b),(b,c)}$]$. Angiv den transitive lukning af $R$.],
  answer: [$t(R) = {(a,a),(a,b),(a,c),(b,a),(b,b),(b,c)}$.],
  blueprint: [
    Den transitive lukning tilføjer en genvej hver gang du kan gå to skridt. Læs #swap[relationen] som en graf og tilføj par til det stopper.

    + Skriv #swap[relationen] op som kanter i en graf.
    + Find hver kæde $(x,y),(y,z)$ og tilføj genvejen $(x,z)$, hvis den ikke allerede er der.
    + Kør runden igen på den større mængde, for de nye par kan selv åbne nye genveje.
    + Stop når en hel runde ikke tilføjer noget. Resultatet: $(x,z)$ er med præcis når der findes en sti fra $x$ til $z$.
  ],
  worked: [
    Relationen er #swap[${(a,b),(b,a),(b,b),(b,c)}$] på ${a,b,c}$.

    Se på hvor $b$ kan nå hen: $b$ peger på $a$, $b$ og $c$.

    - $(a,b)$ + $(b,a)$ #sym.arrow.r tilføj $(a,a)$.
    - $(a,b)$ + $(b,c)$ #sym.arrow.r tilføj $(a,c)$.
    - $(a,b)$ + $(b,b)$ #sym.arrow.r giver $(a,b)$, som allerede er der.

    $c$ har ingen udgående kanter, så den åbner ingen nye genveje. En runde mere tilføjer intet.

    Svar: $t(R) = {(a,a),(a,b),(a,c),(b,a),(b,b),(b,c)}$.
  ],
)

#qcard(
  tag: [Lukning: udregn den transitive lukning],
  source: "MCQ juni 2021, Spm. 38",
  prompt: [Angiv den transitive lukning af $#swap[${(a,b),(a,c),(b,b),(c,d),(d,e)}$]$.],
  options: (
    [${}$ (tom mængde)],
    [${(b,b)}$],
    [${(a,d),(c,e)}$],
    [${(a,d),(a,e),(c,e)}$],
    [${(b,a),(c,a),(d,c),(e,d)}$],
    [${(a,b),(a,c),(b,b),(c,d),(d,e)}$],
    [${(a,b),(a,c),(a,d),(b,b),(c,d),(c,e),(d,e)}$],
    [${(a,b),(a,c),(a,d),(a,e),(b,b),(c,d),(c,e),(d,e)}$],
    [${(a,b),(a,c),(b,a),(b,b),(c,a),(c,d),(d,c),(d,e),(e,d)}$],
    [${(a,a),(a,b),(a,c),(b,b),(c,c),(c,d),(d,d),(d,e),(e,e)}$],
    [Relationen har ingen transitiv lukning.],
  ),
  answer: [Mulighed (h): ${(a,b),(a,c),(a,d),(a,e),(b,b),(c,d),(c,e),(d,e)}$.],
  blueprint: [
    Den transitive lukning tilføjer en genvej hver gang du kan gå to skridt. Læs #swap[relationen] som en graf og tilføj par til det stopper.

    + Skriv #swap[relationen] op som kanter i en graf, og behold alle par.
    + Find hver kæde $(x,y),(y,z)$ og tilføj genvejen $(x,z)$, hvis den ikke allerede er der.
    + Kør runden igen på den større mængde, for de nye par kan selv åbne nye genveje.
    + Stop når en hel runde ikke tilføjer noget. Sammenlign så med mulighederne og vælg den, der matcher præcist.
  ],
  worked: [
    Relationen er #swap[${(a,b),(a,c),(b,b),(c,d),(d,e)}$].

    Følg stierne og tilføj genveje:

    - $a -> c -> d$ #sym.arrow.r tilføj $(a,d)$.
    - $a -> d -> e$ #sym.arrow.r tilføj $(a,e)$.
    - $c -> d -> e$ #sym.arrow.r tilføj $(c,e)$.

    $(b,b)$ er en løkke og åbner ingen nye genveje. En runde mere tilføjer intet.

    Svar: $t(R) = {(a,b),(a,c),(a,d),(a,e),(b,b),(c,d),(c,e),(d,e)}$.
  ],
)

#qcard(
  tag: [Lukning: udregn den symmetriske lukning],
  source: "DM547 januar 2021, Spørgsmål 7 (3%)",
  prompt: [Angiv den symmetriske lukning af $T = #swap[${(a,b),(b,b),(c,d),(d,e)}$]$.],
  answer: [$s(T) = {(a,b),(b,a),(b,b),(c,d),(d,c),(d,e),(e,d)}$.],
  blueprint: [
    Den symmetriske lukning gør hver pil tovejs. Formlen er $s(T) = T union T^(-1)$.

    + Behold alle par fra #swap[relationen].
    + For hvert par $(x,y)$ tilføj det modsatte $(y,x)$.
    + Et par $(x,x)$ er sin egen modsatte, så det giver ikke noget nyt.
    + Tilføj ingen ekstra diagonalløkker, og kæd ikke par sammen. Det hører til den refleksive og den transitive lukning.
  ],
  worked: [
    Relationen er #swap[${(a,b),(b,b),(c,d),(d,e)}$].

    Vend hvert par om og tilføj det modsatte:

    - $(a,b)$ #sym.arrow.r tilføj $(b,a)$.
    - $(b,b)$ er sin egen modsatte, intet nyt.
    - $(c,d)$ #sym.arrow.r tilføj $(d,c)$.
    - $(d,e)$ #sym.arrow.r tilføj $(e,d)$.

    Ingen løkker udover dem der allerede var der, og ingen kædning.

    Svar: $s(T) = {(a,b),(b,a),(b,b),(c,d),(d,c),(d,e),(e,d)}$.
  ],
)

#qcard(
  tag: [Relation: hvilke egenskaber har den? (digraf)],
  source: "DM547 januar 2021, Spørgsmål 6 (8%)",
  prompt: [En digraf (digraph) for relationen $S$ på ${a,b,c,d,e,f}$ har løkker på $a,b,e,f$, kanterne $a->b$, $a->c$, $a->d$, $a->e$, $b->e$, $c->d$, $f->d$, og tovejsparret $e<->f$. Hvilke af følgende gælder: refleksiv, symmetrisk, antisymmetrisk, transitiv, ækvivalensrelation, partiel ordning, total ordning?],
  answer: [Ingen af dem.],
  blueprint: [
    Her får du relationen som en digraf i stedet for en liste. De fire egenskaber bliver til ting du aflæser direkte på tegningen.

    + *Refleksiv?* Har hvert element i #swap[grundmængden] en løkke? Mangler bare én, er svaret nej.
    + *Symmetrisk?* Har hver pil sin modsatte pil tilbage? Find en enkeltrettet pil, og den fejler.
    + *Antisymmetrisk?* Er der to forskellige knuder med pile begge veje? Et tovejspar mellem ulige knuder vælter den.
    + *Transitiv?* For hver to-trins-sti $x -> y -> z$, findes genvejen $x -> z$? Ét hul vælter den.
    + Klassificér: ækvivalensrelation og de to ordninger kræver hver tre af egenskaberne. Fejler en af de nødvendige, falder klassificeringen med.
  ],
  worked: [
    Aflæs digrafen for $S$ knude for knude.

    - *Refleksiv?* $c$ og $d$ har ingen løkke #sym.arrow.r nej.
    - *Symmetrisk?* $a -> b$ findes, men ikke $b -> a$ #sym.arrow.r nej.
    - *Antisymmetrisk?* $e <-> f$ med $e != f$ #sym.arrow.r nej.
    - *Transitiv?* $e -> f$ og $f -> d$, men $e -> d$ mangler #sym.arrow.r nej.

    Alle fire grundegenskaber fejler. Ækvivalensrelation kræver de første tre, og begge ordninger kræver refleksiv og transitiv, så de falder også.

    Svar: ingen af dem.
  ],
)

#qcard(
  tag: [Relation: hvilke er ækvivalensrelationer?],
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
  blueprint: [
    En ækvivalensrelation skal være refleksiv, symmetrisk og transitiv på hele #swap[grundmængden]. Test hver kandidat mod alle tre, og smid den ud så snart én fejler.

    + *Refleksiv?* Er $(x,x)$ med for hvert element i #swap[grundmængden]? Mangler en løkke, ryger kandidaten.
    + *Symmetrisk?* Har hvert par $(x,y)$ sin makker $(y,x)$? Et par uden makker fælder den.
    + *Transitiv?* Lukker hver kæde $(x,y),(y,z)$ med genvejen $(x,z)$? Et hul fælder den.
    + Overlever en kandidat alle tre, er den en ækvivalensrelation. Klasserne er så elementerne grupperet efter hvad de er relateret til.
  ],
  worked: [
    Grundmængden er ${a,b,c}$. Hver kandidat skal klare refleksiv, symmetrisk og transitiv.

    - *(a)* Bare diagonalen ${(a,a),(b,b),(c,c)}$. Refleksiv, symmetrisk og transitiv #sym.arrow.r ja.
    - *(b)* $(c,c)$ mangler #sym.arrow.r ikke refleksiv.
    - *(c)* $(a,b)$ uden $(b,a)$ #sym.arrow.r ikke symmetrisk.
    - *(d)* $(a,b)$ uden $(b,a)$ #sym.arrow.r ikke symmetrisk.
    - *(e)* Refleksiv, symmetrisk via $(a,b),(b,a)$, og transitiv med ${a,b}$ som blok og $c$ for sig #sym.arrow.r ja.

    Klasserne i (e): $[a] = [b] = {a,b}$ og $[c] = {c}$. De er disjunkte og dækker hele mængden.

    Svar: (a) og (e).
  ],
)
