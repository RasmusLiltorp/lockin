#import "../lib.typ": *

== Relationer, ækvivalens og ordning

En relation (relation) på $A$ er en samling ordnede par (ordered pairs) fra $A$. Du skriver $(a,b) in R$ når $a$ er relateret til $b$:

#eq[$ R subset.eq A times A $]

Til eksamen får du en relation som liste, matrix eller graf. Du skal afgøre hvilke egenskaber den har, om den er ækvivalensrelation (equivalence relation) eller ordning (order), eller udregne en lukning (closure) eller ækvivalensklasserne (equivalence classes). Alt bygger på fire egenskaber og tre definitioner.

=== Sådan løser du den

Læs relationen som en graf: hvert element er en knude, og $(a,b) in R$ er en pil fra $a$ til $b$. De fire egenskaber bliver da til billeder, du kan aflæse.

#metadata(none) <th-rel-properties>
#recipe(
  title: "Tjek de fire egenskaber",
  [*Refleksiv (reflexive).* Hvert element peger på sig selv.
  #eq[$ (a,a) in R "for alle" a in A $]
  Graf: løkke på hver knude. Matrix: hele diagonalen er $1$. Mangler bare én løkke, er den ikke refleksiv.

  Matrix over $A = {a, b, c}$ (række $=$ fra, søjle $=$ til, i rækkefølgen $a, b, c$; felt $(i,j) = 1$ betyder $(i,j) in R$):
  #eq[$ mat(1, 1, 0; 0, 1, 0; 0, 0, 1) $]
  Diagonalen — felterne $(a,a), (b,b), (c,c)$ — er lutter $1$, så hvert element har sin løkke. Den er refleksiv, uanset hvad der står uden for diagonalen. Ét $0$ på diagonalen ville vælte det.],
  [*Symmetrisk (symmetric).* Går en pil den ene vej, går den også den anden.
  #eq[$ (a,b) in R ==> (b,a) in R $]
  Hver pil skal have sin modsatte. Én pil uden makker vælter det.
  #eq[$ mat(0, 1, 0; 1, 0, 1; 0, 1, 0) $]
  Matricen er spejlet i diagonalen (lig sin egen transponerede): felt $(a,b)$ og felt $(b,a)$ er begge $1$, og det samme for $(b,c)$ og $(c,b)$. Stod der et enligt $1$ uden sit spejlfelt, fejlede den.],
  [*Antisymmetrisk (antisymmetric).* To forskellige elementer peger aldrig begge veje.
  #eq[$ (a,b) in R and (b,a) in R ==> a = b $]
  Find ét par $(a,b)$ og $(b,a)$ med $a != b$, så fejler den. Løkker er tilladt.
  #eq[$ mat(1, 1, 1; 0, 1, 1; 0, 0, 1) $]
  Øvre trekant må gerne være fyldt, men så skal spejlfeltet under diagonalen være $0$: aldrig $1$ i både felt $(i,j)$ og felt $(j,i)$ når $i != j$. Diagonalen (løkkerne) er ligegyldig her. Stod der $1$ i både $(a,b)$ og $(b,a)$, fejlede den.],
  [*Transitiv (transitive).* Kan du gå $a -> b -> c$, skal genvejen $a -> c$ også være der.
  #eq[$ (a,b) in R and (b,c) in R ==> (a,c) in R $]
  Tjek hver to-trins-kæde for sin genvej. Ét hul vælter det.
  #eq[$ mat(0, 1, 1; 0, 0, 1; 0, 0, 0) $]
  Felt $(a,b) = 1$ og felt $(b,c) = 1$, så genvejen, felt $(a,c)$, skal også være $1$ — og det er den. Var $(a,c)$ et $0$, manglede kæden sin genvej, og relationen fejlede.],
)

Antisymmetrisk er ikke det modsatte af symmetrisk. En relation kan være begge dele ($=$) eller ingen af delene.

#metadata(none) <th-rel-classify>
#recipe(
  title: "Klassificér relationen",
  [*Ækvivalensrelation:* refleksiv, symmetrisk og transitiv. Den deler $A$ op i klasser. Klassen for $a$ er alt, $a$ er relateret til:
  #eq[$ [a] = { x in A mid(|) (a,x) in R } $]
  Klasserne overlapper ikke og dækker hele $A$ — en partition (partition).],
  [*Partiel ordning (partial order):* refleksiv, antisymmetrisk og transitiv. Som ækvivalens, men antisymmetrisk i stedet for symmetrisk. Eksempler: $<=$ på tal og "går op i" på heltal.],
  [*Total ordning (total order):* en partiel ordning hvor alle par kan sammenlignes, altså $(a,b) in R$ eller $(b,a) in R$ for ethvert par. $<=$ er total; "går op i" er ikke ($2$ og $3$ går ikke op i hinanden).],
)

En lukning er den mindste relation, der indeholder $R$ og har en ønsket egenskab. Du tilføjer kun par, fjerner aldrig.

#metadata(none) <th-rel-closure>
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
  tag: [Relation: hvilke egenskaber har den? (transitiv)],
  source: "MCQ juni 2025, Spm. 35 (flere korrekte)",
  theory: <th-rel-properties>,
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
    Relationen er #swap[${(a,a),(a,b),(b,a),(c,c)}$] på ${a,b,c}$. Grundmængden er ${a,b,c}$, så jeg går alle tre elementer og alle par igennem.

    *Refleksiv?* Hvert element skal have sin løkke $(x,x)$:

    - $a$: $(a,a) in R$ #sym.arrow.r ok.
    - $b$: $(b,b) in.not R$ #sym.arrow.r mangler.
    - $c$: $(c,c) in R$ #sym.arrow.r ok.

    Løkken på $b$ mangler #sym.arrow.r *ikke refleksiv.*

    *Symmetrisk?* Hvert par $(x,y)$ skal have sin modsatte $(y,x)$:

    - $(a,a)$: modsat er $(a,a)$ selv #sym.arrow.r ok.
    - $(a,b)$: modsat $(b,a) in R$ #sym.arrow.r ok.
    - $(b,a)$: modsat $(a,b) in R$ #sym.arrow.r ok.
    - $(c,c)$: modsat er $(c,c)$ selv #sym.arrow.r ok.

    Alle par har deres makker #sym.arrow.r *symmetrisk.*

    *Antisymmetrisk?* Find to forskellige elementer med pile begge veje. Her er både $(a,b)$ og $(b,a)$ med, og $a != b$ #sym.arrow.r *ikke antisymmetrisk.*

    *Transitiv?* Tjek hver to-trins-kæde $(x,y),(y,z)$ for genvejen $(x,z)$:

    - $(a,b),(b,a) ==> (a,a)$: $(a,a) in R$ #sym.arrow.r ok.
    - $(b,a),(a,b) ==> (b,b)$: $(b,b) in.not R$ #sym.arrow.r mangler.

    Genvejen $(b,b)$ mangler #sym.arrow.r *ikke transitiv.*

    Klassificering: ækvivalensrelation kræver refleksiv (fejler) og partiel ordning kræver antisymmetrisk (fejler). Begge falder.

    Svar: kun (b).
  ],
)

#qcard(
  tag: [Relation: hvilke egenskaber har den? (transitiv)],
  source: "MCQ juni 2021, Spm. 37 (flere rigtige)",
  theory: <th-rel-properties>,
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

    *Refleksiv?* Tjek løkken på hvert element:

    - $a$: $(a,a) in R$ #sym.arrow.r ok.
    - $b$: $(b,b) in R$ #sym.arrow.r ok.
    - $c$: $(c,c) in R$ #sym.arrow.r ok.

    Hele diagonalen er der #sym.arrow.r *refleksiv.*

    *Symmetrisk?* Tjek modsat par for de par der ikke ligger på diagonalen:

    - $(a,b)$: modsat $(b,a) in.not R$ #sym.arrow.r mangler.

    Ét par uden makker er nok #sym.arrow.r *ikke symmetrisk.*

    *Antisymmetrisk?* Find to forskellige elementer med pile begge veje. De eneste tovejspar her er $(a,a),(b,b),(c,c)$, og de ligger alle på diagonalen ($x = y$). Intet par $(x,y),(y,x)$ med $x != y$ #sym.arrow.r *antisymmetrisk.*

    *Transitiv?* Tjek hver to-trins-kæde for sin genvej:

    - $(a,a),(a,b) ==> (a,b)$: $in R$ #sym.arrow.r ok.
    - $(a,a),(a,c) ==> (a,c)$: $in R$ #sym.arrow.r ok.
    - $(a,b),(b,b) ==> (a,b)$: $in R$ #sym.arrow.r ok.
    - $(a,b),(b,c) ==> (a,c)$: $in R$ #sym.arrow.r ok.
    - $(b,b),(b,c) ==> (b,c)$: $in R$ #sym.arrow.r ok.
    - $(b,c),(c,c) ==> (b,c)$: $in R$ #sym.arrow.r ok.
    - $(a,c),(c,c) ==> (a,c)$: $in R$ #sym.arrow.r ok.

    Alle kæder lukker #sym.arrow.r *transitiv.*

    Klassificering: ækvivalensrelation kræver symmetri (fejler). Partiel ordning kræver refleksiv, antisymmetrisk og transitiv — alle tre holder #sym.arrow.r partiel ordning.

    Svar: (a), (c), (d), (f).
  ],
)

#qcard(
  tag: [Lukninger: er den angivne lukning korrekt? (lukning)],
  source: "MCQ juni 2025, Spm. 36 (flere korrekte)",
  theory: <th-rel-closure>,
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
    Grundmængden er $A = {a,b,c,d}$. Jeg regner hver lukning selv og sammenligner med påstanden par for par.

    *(a)* Refleksiv lukning af $emptyset$: tilføj $(x,x)$ for hvert element i $A$, og der er intet andet at beholde. Det giver ${(a,a),(b,b),(c,c),(d,d)}$ — netop diagonalen #sym.arrow.r *passer.*

    *(b)* Refleksiv lukning af ${(a,b),(b,c)}$: behold de to par og tilføj diagonalen, altså $r(R) = {(a,b),(b,c),(a,a),(b,b),(c,c),(d,d)}$. Påstanden er ${(a,c)}$ — hverken de oprindelige par, løkkerne eller blot $(a,c)$ (som ikke engang er en refleksiv tilføjelse) #sym.arrow.r *falsk.*

    *(c)* Symmetrisk lukning af ${(a,a),(a,b),(c,d)}$: tilføj kun modsatte par. $(a,a)$ er sin egen modsatte, $(a,b)$ giver $(b,a)$, $(c,d)$ giver $(d,c)$. Resultat: ${(a,a),(a,b),(b,a),(c,d),(d,c)}$. Påstanden indeholder også løkkerne $(b,b),(c,c),(d,d)$, men dem tilføjer symmetrisk lukning ikke #sym.arrow.r *falsk.*

    *(d)* Symmetrisk lukning af ${(a,b),(b,a),(b,c)}$: $(a,b)$ og $(b,a)$ er hinandens modsatte og allerede der; $(b,c)$ kræver $(c,b)$. Resultat: ${(a,b),(b,a),(b,c),(c,b)}$. Påstanden er kun ${(a,b),(b,a)}$ — den har tabt $(b,c)$ og mangler $(c,b)$ #sym.arrow.r *falsk.*

    *(e)* Transitiv lukning af #swap[${(a,b),(b,c),(c,d)}$]: følg kæden $a -> b -> c -> d$ og tilføj genveje.

    - $a -> b -> c$ #sym.arrow.r $(a,c)$.
    - $b -> c -> d$ #sym.arrow.r $(b,d)$.
    - $a -> c -> d$ (ny kant $(a,c)$) #sym.arrow.r $(a,d)$.

    Resultat: ${(a,b),(b,c),(c,d),(a,c),(b,d),(a,d)}$ — netop den påståede mængde #sym.arrow.r *passer.*

    *(f)* Transitiv lukning af ${(a,b),(c,d)}$: den ene kant ender i $b$, den anden starter i $c$. Ingen kæde $(x,y),(y,z)$ findes, så intet tilføjes og relationen er uændret #sym.arrow.r *passer.*

    Svar: (a), (e) og (f).
  ],
)

#qcard(
  tag: [Lukning: udregn den transitive lukning (transitiv lukning)],
  source: "MCQ juni 2023, Spm. 36 (3 point)",
  theory: <th-rel-closure>,
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
    Relationen er #swap[${(a,b),(b,a),(b,b),(b,c)}$] på ${a,b,c}$. Som graf: $a -> b$, $b -> a$, $b -> b$ (løkke), $b -> c$. Bemærk at $a$ og $b$ peger på hinanden, så der er en cykel, og den giver løkker i lukningen.

    *Runde 1.* Tag hver kæde $(x,y),(y,z)$ og tilføj $(x,z)$:

    - $(a,b),(b,a) ==> (a,a)$ #sym.arrow.r ny.
    - $(a,b),(b,b) ==> (a,b)$ #sym.arrow.r findes.
    - $(a,b),(b,c) ==> (a,c)$ #sym.arrow.r ny.
    - $(b,a),(a,b) ==> (b,b)$ #sym.arrow.r findes.
    - $(b,b),(b,a) ==> (b,a)$ #sym.arrow.r findes.
    - $(b,b),(b,c) ==> (b,c)$ #sym.arrow.r findes.

    Efter runde 1: ${(a,a),(a,b),(a,c),(b,a),(b,b),(b,c)}$.

    *Runde 2.* De nye kanter er $(a,a)$ og $(a,c)$. Tjek om de åbner genveje:

    - $(a,a),(a,b) ==> (a,b)$ #sym.arrow.r findes.
    - $(a,a),(a,c) ==> (a,c)$ #sym.arrow.r findes.
    - $(a,c),(c,?)$: $c$ har ingen udgående kant #sym.arrow.r intet.

    Runde 2 tilføjer intet, så vi stopper.

    Svar: $t(R) = {(a,a),(a,b),(a,c),(b,a),(b,b),(b,c)}$.
  ],
)

#qcard(
  tag: [Lukning: udregn den transitive lukning (transitiv lukning)],
  source: "MCQ juni 2021, Spm. 38",
  theory: <th-rel-closure>,
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
    Relationen er #swap[${(a,b),(a,c),(b,b),(c,d),(d,e)}$]. Som graf: $a -> b$, $a -> c$, $b -> b$ (løkke), $c -> d$, $d -> e$. Hovedstien er $a -> c -> d -> e$.

    *Runde 1.* Tag hver kæde $(x,y),(y,z)$ og tilføj $(x,z)$:

    - $(a,b),(b,b) ==> (a,b)$ #sym.arrow.r findes.
    - $(a,c),(c,d) ==> (a,d)$ #sym.arrow.r ny.
    - $(c,d),(d,e) ==> (c,e)$ #sym.arrow.r ny.

    Efter runde 1: ${(a,b),(a,c),(a,d),(b,b),(c,d),(c,e),(d,e)}$.

    *Runde 2.* De nye kanter er $(a,d)$ og $(c,e)$:

    - $(a,d),(d,e) ==> (a,e)$ #sym.arrow.r ny.
    - $(c,e),(e,?)$: $e$ har ingen udgående kant #sym.arrow.r intet.

    Efter runde 2: tilføj $(a,e)$.

    *Runde 3.* Den nye kant er $(a,e)$; $e$ har ingen udgående kant, så intet tilføjes. Stop.

    Løkken $(b,b)$ peger kun tilbage på $b$, som ellers ingen udgående kant har, så den åbner aldrig nye genveje.

    Svar: $t(R) = {(a,b),(a,c),(a,d),(a,e),(b,b),(c,d),(c,e),(d,e)}$.
  ],
)

#qcard(
  tag: [Lukning: udregn den symmetriske lukning (symmetrisk lukning)],
  source: "DM547 januar 2021, Spørgsmål 7 (3%)",
  theory: <th-rel-closure>,
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
    Relationen er $T = #swap[${(a,b),(b,b),(c,d),(d,e)}$]$. Formlen er $s(T) = T union T^(-1)$: behold alt i $T$, og tilføj den modsatte $(y,x)$ for hvert par $(x,y)$.

    Gå hvert par igennem:

    - $(a,b)$: modsat $(b,a) in.not T$ #sym.arrow.r tilføj $(b,a)$.
    - $(b,b)$: modsat er $(b,b)$ selv #sym.arrow.r intet nyt.
    - $(c,d)$: modsat $(d,c) in.not T$ #sym.arrow.r tilføj $(d,c)$.
    - $(d,e)$: modsat $(e,d) in.not T$ #sym.arrow.r tilføj $(e,d)$.

    De fire oprindelige par plus $(b,a),(d,c),(e,d)$. Ingen ekstra diagonalløkker (det hører til den refleksive lukning), og ingen kædning (det hører til den transitive).

    Svar: $s(T) = {(a,b),(b,a),(b,b),(c,d),(d,c),(d,e),(e,d)}$.
  ],
)

#qcard(
  tag: [Relation: hvilke egenskaber har den? (digraf) (transitiv)],
  source: "DM547 januar 2021, Spørgsmål 6 (8%)",
  theory: <th-rel-properties>,
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
    Skriv digrafen ud som parmængde. Løkker på $a,b,e,f$ giver $(a,a),(b,b),(e,e),(f,f)$; de enkeltrettede kanter giver $(a,b),(a,c),(a,d),(a,e),(b,e),(c,d),(f,d)$; tovejsparret $e<->f$ giver $(e,f),(f,e)$.

    *Refleksiv?* Hvert af de seks elementer skal have en løkke:

    - $a,b,e,f$: løkke #sym.arrow.r ok.
    - $c$: ingen løkke #sym.arrow.r mangler.
    - $d$: ingen løkke #sym.arrow.r mangler.

    Løkker på $c$ og $d$ mangler #sym.arrow.r *ikke refleksiv.*

    *Symmetrisk?* Tag en enkeltrettet kant: $(a,b) in S$, men $(b,a) in.not S$ #sym.arrow.r *ikke symmetrisk.*

    *Antisymmetrisk?* Find to forskellige knuder med pile begge veje: $(e,f)$ og $(f,e)$ er begge med, og $e != f$ #sym.arrow.r *ikke antisymmetrisk.*

    *Transitiv?* Find en to-trins-sti uden genvej: $(e,f),(f,d) ==> (e,d)$, men $(e,d) in.not S$ #sym.arrow.r *ikke transitiv.*

    Alle fire grundegenskaber fejler. Ækvivalensrelation kræver refleksiv, symmetrisk og transitiv; begge ordninger kræver refleksiv og transitiv. Da refleksiv allerede fejler, falder alle tre klassificeringer.

    Svar: ingen af dem.
  ],
)

#qcard(
  tag: [Relation: hvilke er ækvivalensrelationer? (ækvivalensrelation)],
  source: "SE4-DMAD juni 2024, Spm. 6 (4%)",
  theory: <th-rel-classify>,
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
    Grundmængden er ${a,b,c}$. Hver kandidat skal klare refleksiv, symmetrisk og transitiv; den ryger ud så snart én fejler.

    *(a)* ${(a,a),(b,b),(c,c)}$ — kun diagonalen.

    - Refleksiv: $(a,a),(b,b),(c,c)$ alle med #sym.arrow.r ok.
    - Symmetrisk: hvert par er sin egen modsatte #sym.arrow.r ok.
    - Transitiv: eneste kæder er $(x,x),(x,x) ==> (x,x)$, alle med #sym.arrow.r ok.

    Alle tre holder #sym.arrow.r *ækvivalensrelation.*

    *(b)* ${(a,a),(a,b),(b,a),(b,b)}$ — løkken $(c,c)$ mangler #sym.arrow.r *ikke refleksiv.*

    *(c)* ${(a,a),(a,b),(b,b),(c,c)}$ — $(a,b) in R$ men $(b,a) in.not R$ #sym.arrow.r *ikke symmetrisk.*

    *(d)* ${(a,a),(a,b),(b,b),(b,c),(c,c)}$ — $(a,b) in R$ men $(b,a) in.not R$ #sym.arrow.r *ikke symmetrisk.* (Også ikke transitiv: $(a,b),(b,c) ==> (a,c)$, som mangler.)

    *(e)* ${(a,a),(a,b),(b,a),(b,b),(c,c)}$.

    - Refleksiv: $(a,a),(b,b),(c,c)$ alle med #sym.arrow.r ok.
    - Symmetrisk: $(a,b)$ har $(b,a)$; resten er på diagonalen #sym.arrow.r ok.
    - Transitiv: tjek kæderne. $(a,b),(b,a) ==> (a,a)$ ok; $(b,a),(a,b) ==> (b,b)$ ok; $(a,b),(b,b) ==> (a,b)$ ok; $(b,a),(a,a) ==> (b,a)$ ok #sym.arrow.r ok.

    Alle tre holder #sym.arrow.r *ækvivalensrelation.*

    Klasserne i (e): $[a] = {x mid(|) (a,x) in R} = {a,b}$, $[b] = {a,b}$, $[c] = {c}$. Altså to klasser ${a,b}$ og ${c}$ — de er disjunkte og dækker hele ${a,b,c}$.

    Svar: (a) og (e).
  ],
)
