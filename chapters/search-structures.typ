#import "../lib.typ": *

== Søgestrukturer: BST, augmenteret BST, hashing

En ordbog (dictionary) skal kunne slå op, indsætte og slette. Skal den også svare på "hvad kommer før/efter denne nøgle" eller gå igennem alt i sorteret orden, kræver det en *ordnet* ordbog.

Et balanceret søgetræ (balanced search tree) (rød-sort træ (red-black tree)) klarer alt i $O(log n)$. En hashtabel (hash table) klarer opslag, indsæt og slet i $O(1)$ i gennemsnit, men kan ikke svare på de ordnede spørgsmål.

At *augmentere* (augment) et BST betyder, at hver knude gemmer ekstra info om hele sit deltræ (subtree) (antal knuder, største $y$-værdi, en sum), så du kan svare på nye spørgsmål i $O(log n)$.

Til eksamen skal du opstille ligningerne for et augmenteret felt, simulere en hashtabel skridt for skridt og udvælge worst-case-køretider.

=== Sådan løser du den <th-bst-augment>

#recipe(
  title: "Augmentér et BST med deltræs-info",
  [Beslut hvad hver knude gemmer om *hele sit deltræ*, fx #swap[$v."size"$] $=$ antal knuder eller #swap[$v."ymax"$] $=$ største $y$-værdi.],
  [Skriv ligningen for feltet ud fra de to børn og knuden selv. For størrelse:],
  [Tjek augmenteringsbetingelsen: kan feltet beregnes i $O(1)$ ud fra børnenes felter, kan det vedligeholdes under indsæt og slet uden ekstra køretid. Det gælder sum, antal, min og max.],
  [En forespørgsel går fra roden ét niveau ad gangen og bruger felterne. Det er $O(log n)$, da træet er balanceret.],
)

#eq[$ v."size" = 1 + v."left"."size" + v."right"."size" $]

For et aggregat over data, som største $y$-værdi i deltræet:

#eq[$ v."ymax" = max(v.y, space v."left"."ymax", space v."right"."ymax") $]

#metadata(none) <th-bst-bst-ops>
#note(title: [Nøglefelt vs. ikke-nøglefelt])[Nøglefelt vs. ikke-nøglefelt afgør formlen. Træet er sorteret efter *én* nøgle, fx $x$. Et ekstremum af *nøglen* ligger fast: største $x$ er den højreste knude, mindste $x$ den venstreste. Selve ekstremerne af nøglen henter du med Tree-Minimum og Tree-Maximum fra lærebogen: Tree-Minimum følger venstre barn fra roden hele vejen ned og ender i den mindste nøgle (venstreste knude), Tree-Maximum følger højre barn ned til den største nøgle (højreste knude). Begge er $O(log n)$ i et balanceret træ.

#eq[$ v."xmax" = v."right"."xmax", quad v."xmin" = v."left"."xmin" $]

Et ikke-nøglefelt (fx $y$) er ikke sorteret af træet, så kig på begge børn og knuden selv:

#eq[$ v."ymax" = max(v.y, space v."left"."ymax", space v."right"."ymax") $]
]

#metadata(none) <th-bst-augment-maintain>
#trap(title: [Vedligeholdelse af augmentering])[Vedligeholdelse rører ikke kun bladet eller kun roden. En indsæt eller slet ændrer knuderne langs én rod-til-blad-sti plus $O(1)$ rotationer; du genberegner felterne nedefra og op langs den sti, altså $O(log n)$ knuder. Et fuldt inorder-gennemløb (inorder traversal) er $O(n)$ og dermed forkert svar på et $O(log n)$-spørgsmål.]

For ordensstatistik (order statistics) gemmer hver knude `size`. NIL er en sentinel med `size = 0`, så `x.left.size` altid er defineret. Rangen (rank) i eget deltræ:

#eq[$ r = x."left"."size" + 1 $]

```
OS-SELECT(x, i)              // knuden med rang i i x's deltræ
  r = x.left.size + 1
  if i == r     return x
  elseif i < r  return OS-SELECT(x.left, i)
  else          return OS-SELECT(x.right, i - r)

OS-RANK(T, x)                // rang af x i hele træet
  r = x.left.size + 1
  y = x
  while y != T.root
    if y == y.p.right
      r = r + y.p.left.size + 1
    y = y.p
  return r
```

#metadata(none) <th-bst-hashing>
#recipe(
  title: "Simulér en hashtabel med open addressing",
  [Noter tabelstørrelsen #swap[$m$] og hvilke pladser der er optaget før indsættelsen.],
  [Find probe-sekvensen (probe sequence). Linear probing:],
  [Indsæt ved at prøve $i = 0, 1, 2, dots$ til *første tomme plads*. Søgning gør det samme og stopper ved nøglen eller en tom plads.],
  [Skal du finde "hvilke $h'$-værdier er mulige": tag én kandidat ad gangen. Lad som om $h'(k)$ er den værdi, kør indsættelsen, og se hvor nøglen lander. Lander den på den plads, nøglen rent faktisk fik, er kandidaten mulig — ellers ikke.],
)

Linear probing prøver pladserne ét hak ad gangen:

#eq[$ h(k, i) = (h'(k) + i) mod m $]

$i$ er hvor mange skridt du har taget: $i = 0$ er hjemmepladsen, $i = 1$ er den næste, og så videre, til du finder en tom plads.

$mod m$ betyder "rest efter division med $m$", og det er bare måden at vikle rundt på, når du løber ud over kanten af tabellen. Med $m = 7$ har du pladserne $0$ til $6$. Lander du på $7$, starter du forfra på plads $0$, $8$ bliver plads $1$, og så videre. For eksempel er $9 mod 7 = 2$, fordi $9 = 7 + 2$. Plads $9$ findes ikke; den er i virkeligheden plads $2$.

I praksis gør det regningen nem. Er tallet allerede under $m$, sker der ingenting, og resten er bare tallet selv. $5 mod 7 = 5$, fordi $5$ er mindre end $7$. Først når summen når $7$ eller derover, wrapper du rundt, så $8 mod 7 = 1$ og $14 mod 7 = 0$. Du kigger altså bare på, om summen har ramt $7$ endnu.

En rest på $0$ betyder ikke "går ikke op", men det modsatte. Resten er $0$, netop når $7$ deler tallet rent, som i $7 mod 7 = 0$, $14 mod 7 = 0$ og $21 mod 7 = 0$. Går det ikke op, er resten det, der bliver tilovers, fx $8 mod 7 = 1$ og $10 mod 7 = 3$.

Pas på rækkefølgen, når du regner. Det er hele summen, der tages modulo, altså $(h'(k) + i) mod m$. Du lægger først sammen og tager så resten, ikke omvendt.

Prøv det med $m = 7$. Sig at både $10$ og $17$ hører hjemme på plads $3$ (deres $h'$ er $3$). Du indsætter $10$ først, og plads $3$ er tom, så $10$ lander der. Nu kommer $17$, men plads $3$ er optaget. Du tager ét skridt ($i = 1$) og får $(3 + 1) mod 7 = 4$. Plads $4$ er tom, så $17$ lander der. Mere er der ikke i probingen: de to stødte sammen, og den nye gik ét skridt frem til en ledig plads.

Double hashing gør det samme, men skridtlængden er ikke altid 1. En ekstra funktion $h_2(k)$ bestemmer, hvor langt hvert hop er:

#eq[$ h(k, i) = (h_1(k) + i dot h_2(k)) mod m $]

$h_1$ siger "start her", og $h_2$ siger "hop så mange ad gangen". Ved hver kollision tager du endnu et hop af samme størrelse. Linear probing er egentlig bare det specialtilfælde, hvor $h_2$ altid er $1$, og double hashing gør springtallet afhængigt af nøglen i stedet.

Læg mærke til, at $h_2(k)$ ikke genberegnes ved hver kollision. Den er en fast værdi for nøglen, ligesom $h_1(k)$, og det eneste, der ændrer sig undervejs, er tælleren $i$.

Det samme eksempel med $m = 7$: nu hører $17$ hjemme på plads $3$ ($h_1 = 3$) med skridtlængde $h_2 = 2$. Plads $3$ er optaget af $10$, så du hopper, og $i = 1$ giver $(3 + 1 dot 2) mod 7 = 5$. Er $5$ tom, lander $17$ der. Linear probing ville have prøvet plads $4$ først, mens double hashing springer direkte til $5$, fordi hoppet er $2$.

#metadata(none) <th-bst-chaining>
#note(title: [Chaining])[Chaining er den anden kollisionsmetode (collision resolution method): hver plads peger på en liste over de nøgler, der hasher dertil. Indsæt er $O(1)$ (forrest i listen), søg og slet er $Theta(|"liste"|)$. Worst case hasher alle $n$ nøgler til samme plads, så listen får længde $n$ og søgning bliver $Theta(n)$. Bruger du balancerede træer i stedet for lister, falder worst case til $O(log n)$. I praksis er hashing $O(1)$ for søg, indsæt og slet.]

#trap(title: [Open addressing])[Open addressing kræver $n <= m$; sigt efter en fyldningsgrad (load factor) omkring $n approx m\/4$. Slet markerer pladsen som slettet uden at tømme den, ellers afbryder en senere søgning for tidligt. Vælg $m$ som primtal, så probe-sekvensen når alle pladser. Quadratic probing er ude af pensum.]

Valget mellem de to strukturer afgøres af spørgsmålstypen:

#table(
  columns: (auto, auto, auto),
  inset: 7pt,
  align: (left, center, center),
  stroke: 0.4pt + hair,
  table.header([*Operation*], [*Balanceret BST*], [*Hashing (gns. / worst)*]),
  [Søg / indsæt / slet], [$O(log n)$], [$O(1)$ / $Theta(n)$],
  [Predecessor / successor], [$O(log n)$], [ikke understøttet],
  [Sorteret gennemløb], [$O(n)$], [ikke understøttet],
)

=== Open addressing trin for trin <th-bst-linear-probing>

I open addressing bor nøglerne direkte i tabellen, uden lister hængt udenpå. Vil to nøgler have samme plads, rykker den nye videre til den næste ledige efter en fast regel. Reglen kaldes probe-sekvensen (probe sequence), og pensum har to af dem: linear probing og double hashing.

Begge starter med en hjælpe-hashfunktion $h'(k)$ (auxiliary hash function), der giver nøglens hjemmeplads. Er hjemmepladsen ledig, lander nøglen der. Er den optaget, prober du videre, og måden du gør det på er hele forskellen mellem de to metoder.

*Linear probing* rykker ét hak ad gangen:

#eq[$ h(k, i) = (h'(k) + i) mod m $]

Er hjemmepladsen optaget, prøver du plads $h'+1$, så $h'+2$, og så videre til den første tomme. Falder du ud over kanten, wrapper du tilbage til plads 0.

Tag tre nøgler med samme hjemmeplads og indsæt dem i en tom tabel ($m = 7$, $h'(k) = k mod 7$, så $10$, $17$ og $24$ alle hører hjemme på plads #swap[3]):

#let htab(..cells) = table(
  columns: (auto,) * 8,
  align: center + horizon,
  stroke: 0.4pt + hair,
  inset: 6pt,
  table.header([], [*0*], [*1*], [*2*], [*3*], [*4*], [*5*], [*6*]),
  ..cells.pos(),
)

#align(center)[
  #stack(
    spacing: 8pt,
    [Indsæt $10$ (plads 3 tom $-> $ lander på 3):],
    htab([værdi], [], [], [], [10], [], [], []),
    [Indsæt $17$ (3 optaget $-> $ prøv 4, tom $->$ lander på 4):],
    htab([værdi], [], [], [], [10], [17], [], []),
    [Indsæt $24$ (3, 4 optaget $-> $ prøv 5, tom $->$ lander på 5):],
    htab([værdi], [], [], [], [10], [17], [24], []),
  )
]

Bemærk hvordan nøglerne klumper sammen i én sammenhængende blok. Det hedder primær klyngedannelse (primary clustering): jo længere blokken bliver, jo længere skal den næste nøgle probe, før den finder plads.

#metadata(none) <th-bst-double-hashing>
*Double hashing* fjerner klyngerne ved at gøre selve skridtlængden afhængig af nøglen:

#eq[$ h(k, i) = (h_1(k) + i dot h_2(k)) mod m $]

$h_1$ giver hjemmepladsen som før, men i stedet for at hoppe ét frem hopper du $h_2(k)$ ad gangen. To nøgler kan dele hjemmeplads og alligevel følge hver sin sti gennem tabellen, fordi deres $h_2$ er forskellig.

Tag tabellen fra før med $10$, $17$, $24$ på plads 3, 4, 5, og indsæt en nøgle med $h_1 = 3$ og $h_2 = 2$:

#align(center)[
  #stack(
    spacing: 8pt,
    htab([værdi], [], [], [], [10], [17], [24], []),
    [
      $i = 0$: plads $3$ optaget. \
      $i = 1$: plads $(3 + 1 dot 2) = 5$ optaget. \
      $i = 2$: plads $(3 + 2 dot 2) = 7 equiv 0$ tom $->$ lander på 0.
    ],
    htab([værdi], [ny], [], [], [10], [17], [24], []),
  )
]

Linear probing ville have lagt den på plads 6; det større skridt springer hen over klyngen i stedet for at lægge sig bag i køen.

#trap(title: [Vælg $h_2$ med omhu])[Skridtlængden $h_2(k)$ skal være forskellig fra 0, ellers står du stille på hjemmepladsen for evigt. Og $h_2(k)$ skal være indbyrdes primisk med $m$ (relatively prime), ellers rammer probe-sekvensen kun nogle af pladserne og kan løbe tør, selvom tabellen ikke er fuld. Vælger du $m$ som primtal, er ethvert $h_2 in {1, dots, m-1}$ automatisk i orden.]

*Baglæns-opgaverne.* Til eksamen får du som regel tabellen før og efter plus landingspladsen, og skal finde hvilke $h'$- eller $h_2$-værdier der kunne have ført dertil. Fremgangen er den samme uanset metode: prøv hver kandidat. Simulér probingen fra den værdi, og behold den, hvis sekvensen ender på den plads, nøglen faktisk fik. Med $m$ lille (typisk 7) er der kun en håndfuld kandidater at tjekke, så det er hurtigere at simulere dem alle end at lede efter en smart genvej.

=== Rød-sort træ <th-bst-rbtree>

Et rød-sort træ er et binært søgetræ (binary search tree), hvor hver knude har en farve, rød eller sort. Farverne er der kun for at holde træet i balance, så højden bliver $O(log n)$ uanset i hvilken rækkefølge du indsætter.

#metadata(none) <th-bst-rb-rules>
#recipe(
  title: "De fem rød-sorte regler",
  [Hver knude er enten rød eller sort.],
  [Roden er sort.],
  [Alle blade (de tomme NIL-knuder) er sorte.],
  [En rød knude har to sorte børn. To røde knuder i træk er forbudt.],
  [Fra en vilkårlig knude har alle stier ned til bladene samme antal sorte knuder. Det tal er knudens *sort-højde* (black-height).],
)

Regel 4 og 5 er dem, der gør arbejdet. Ingen røde i træk betyder, at den længste sti højst er dobbelt så lang som den korteste, og samme sort-højde overalt holder de to ender tæt på hinanden.

#block(breakable: true, above: 14pt, below: 14pt)[
  #text(weight: "bold", size: 11pt)[Hurtig opslag — hvad gør jeg?]
  #v(4pt)
  Først: hvilken regel er brudt? Find symptomet, og klik dig videre til løsningen.

  #table(
    columns: (auto, auto),
    align: (left, left),
    stroke: none,
    inset: (x: 9pt, y: 5pt),
    table.header([*Hvad du ser på træet*], [*Hvad du gør*]),
    table.hline(stroke: 0.4pt + hair),
    [Roden er rød (regel 2)], [farv roden sort — færdig],
    [To røde knuder i træk (regel 4, sker efter indsæt)], link(<rb-indsaet>)[#underline[ret op med indsæt-tabellen nedenfor]],
    [En sti har færre sorte knuder end en anden, fx 3 mod 2 (regel 5, sker efter slet)], link(<rb-slet>)[#underline[ret op med slet-tabellen nedenfor]],
  )

  #v(9pt)
  _Indsæt: to røde i træk — vælg efter onklens farve og hvor knuden ligger._
  #table(
    columns: (auto, auto, auto),
    align: (left, left, left),
    stroke: none,
    inset: (x: 9pt, y: 5pt),
    table.header([*Onkel*], [*Knuden ligger*], [*Løsning*]),
    table.hline(stroke: 0.4pt + hair),
    [rød], [ligegyldigt], link(<rb-indsaet>)[#underline[farv forælder + onkel sorte, bedsteforælder rød, ryk op]],
    [sort], [yderside (lige linje)], link(<rb-indsaet>)[#underline[farv om og rotér bedsteforælderen]],
    [sort], [inderside (knæk)], link(<rb-indsaet>)[#underline[rotér forælderen først, så bliver det yderside]],
  )
  Til sidst: farv altid roden sort.

  #v(9pt)
  _Slet: en sort knude blev fjernet, så én knude bærer en dobbelt-sort. $w$ er dens søskende._
  #table(
    columns: (auto, auto),
    align: (left, left),
    stroke: none,
    inset: (x: 9pt, y: 5pt),
    table.header([*$w$ og $w$'s børn*], [*Løsning*]),
    table.hline(stroke: 0.4pt + hair),
    [$w$ rød], link(<rb-slet>)[#underline[rotér forælderen + farv om, så er du i et af tilfældene nedenfor]],
    [$w$ sort, begge børn sorte], link(<rb-slet>)[#underline[farv $w$ rød, og ryk dobbelt-sorten op]],
    [$w$ sort, nær barn rødt], link(<rb-slet>)[#underline[rotér $w$ + farv om, videre til sidste tilfælde]],
    [$w$ sort, fjern barn rødt], link(<rb-slet>)[#underline[rotér forælderen, farv om, gør fjerne barn sort — færdig]],
  )
]

#note(title: [Hvorfor det er balanceret])[Med $k$ sorte knuder på hver rod-til-blad-sti gælder $n >= 2^(k-1) - 1$, så $k - 1 <= log(n+1)$. Den længste sti har højst dobbelt så mange kanter som den korteste, så højden er $<= 2 log(n+1) = O(log n)$.]

Når du indsætter eller sletter, kan du komme til at bryde reglerne. Så retter du op med to værktøjer: *omfarvning* (recoloring) (skift en knudes farve) og *rotation*.

En rotation bytter om på en knude og et af dens børn, men holder søgeordenen intakt. Den er $O(1)$ og flytter kun tre pointere. Venstrerotation (left rotation) om $x$ løfter dens højre barn $y$ op; deltræet $beta$ skifter forælder fra $y$ til $x$:

#gdiag({
  gnode((0,1.2), "x1", $x$)
  gnode((-0.7,0.4), "A1", $alpha$)
  gnode((0.7,0.4), "y1", $y$)
  gnode((0.3,-0.4), "B1", $beta$)
  gnode((1.1,-0.4), "C1", $gamma$)
  gedge("x1","A1"); gedge("x1","y1"); gedge("y1","B1"); gedge("y1","C1")

  gnode((3.6,1.2), "y2", $y$)
  gnode((2.9,0.4), "x2", $x$)
  gnode((4.3,0.4), "C2", $gamma$)
  gnode((2.5,-0.4), "A2", $alpha$)
  gnode((3.3,-0.4), "B2", $beta$)
  gedge("y2","x2"); gedge("y2","C2"); gedge("x2","A2"); gedge("x2","B2")
})

#align(center)[#text(size: 9pt, fill: soft)[Venstre: før. Højre: efter venstrerotation om $x$. Ordenen $alpha < x < beta < y < gamma$ holder begge steder.]]

Højrerotation (right rotation) er det spejlvendte og løfter venstre barn op. De to er hinandens modsatte, så en højrerotation kan altid fortrydes med en venstrerotation.

#metadata(none) <rb-indsaet>
#metadata(none) <th-bst-rb-insert>
#recipe(
  title: "Indsæt og ret op",
  [Indsæt den nye knude som i et almindeligt BST, og farv den *rød*. En rød knude kan kun bryde regel 4 (to røde i træk), aldrig sort-højden, så du har kun ét problem at rette.],
  [Er forælderen sort, er du færdig med det samme.],
  [Er forælderen rød, kig på *onklen* (forælderens søskende), og brug et af tre tilfælde:
    - *Onkel rød:* farv forælder og onkel sorte og bedsteforælderen rød. Problemet flytter to niveauer op; fortsæt derfra. Ingen rotation her.
    - *Onkel sort, knuden på indersiden* (zig-zag): rotér om forælderen, så de tre knuder kommer på en lige linje. Nu er du i yderside-tilfældet.
    - *Onkel sort, knuden på ydersiden* (lige linje): farv forælder sort og bedsteforælder rød, og rotér om bedsteforælderen. Færdig.],
  [Farv til sidst altid roden sort.],
)

#note(title: [Inderside eller yderside?])[Kig på de tre knuder bedsteforælder–forælder–barn. Går de samme vej (venstre-venstre eller højre-højre), er barnet på *ydersiden*, og du retter med én rotation. Knækker linjen (venstre-højre eller højre-venstre), er det på *indersiden*, og du bruger en ekstra rotation først for at rette knækket ud.]

Et fuldt eksempel binder reglerne sammen. Indsæt $10, 20, 30, 15, 25, 5$ i et tomt træ:

#recipe(
  title: "Gennemregnet: indsæt 10, 20, 30, 15, 25, 5",
  [*10:* bliver rod, farves sort.],
  [*20:* ind til højre, rød. Forælder $10$ er sort, så færdig.],
  [*30:* ind til højre for $20$, rød. Forælder $20$ er rød, onkel er NIL (sort), og $30$ er på ydersiden (højre-højre). Farv $20$ sort, $10$ rød, og venstrerotér om $10$. Nu er $20$ rod med røde børn $10$ og $30$; rod farves sort.],
  [*15:* ind til højre for $10$, rød. Forælder $10$ rød, onkel $30$ rød. Farv $10$ og $30$ sorte, $20$ rød. Op til roden $20$, der farves sort igen.],
  [*25:* ind til venstre for $30$, rød. Forælder $30$ er sort, så færdig.],
  [*5:* ind til venstre for $10$, rød. Forælder $10$ er sort, så færdig.],
)

#gdiag({
  gnode((1.5,1.2), "n20", $20$)
  gnode((0.7,0.4), "n10", $10$)
  gnode((2.3,0.4), "n30", $30$)
  gnode((0.2,-0.4), "n5", $5$)
  gnode((1.2,-0.4), "n15", $15$)
  gnode((1.9,-0.4), "n25", $25$)
  gedge("n20","n10"); gedge("n20","n30"); gedge("n10","n5"); gedge("n10","n15"); gedge("n30","n25")
})

#align(center)[#text(size: 9pt, fill: soft)[Slutresultat. Sorte: $20, 10, 30$. Røde: $5, 15, 25$. Hver sti fra roden møder to sorte knuder, så sort-højden passer.]]

Sletning bruger samme to værktøjer, men er tungere. Du fjerner knuden som i et almindeligt BST. Var den fjernede knude rød, sker der ikke noget med balancen. Var den sort, mangler der nu en sort på den sti, og knuden, der tog dens plads, bærer en ekstra "dobbelt-sort", som du skubber væk:

#metadata(none) <rb-slet>
#metadata(none) <th-bst-rb-delete>
#recipe(
  title: "Slet og ret op (dobbelt-sort knude x, søskende w)",
  [*w rød:* rotér om forælderen og farv om, så $w$ bliver sort. Det fører dig ned i et af de tre tilfælde nedenfor.],
  [*w sort, begge w's børn sorte:* farv $w$ rød. Den dobbelt-sorte flytter op til forælderen; fortsæt derfra. Er forælderen rød, farv den bare sort, og du er færdig.],
  [*w sort, w's nære barn rødt, fjerne barn sort:* rotér om $w$ og farv om, så det fjerne barn bliver rødt. Nu er du i sidste tilfælde.],
  [*w sort, w's fjerne barn rødt:* rotér om forælderen, flyt forælderens farve over på $w$, og farv både forælderen og $w$'s fjerne barn sorte. Færdig.],
)

#note(title: [Hvad du skal kunne til eksamen])[De fleste spørgsmål tester de fem regler, et indsæt i hånden, eller at både indsæt og slet er $O(log n)$ med højst $O(1)$ rotationer ($2$ for indsæt, $3$ for slet). Den fulde sletnings-fixup bliver sjældent krævet skridt for skridt.]

#trap(title: [Rød knude øverst eller nederst])[To klassiske fælder: roden skal være sort (regel 2), og en ny knude indsættes altid rød. Indsætter du sort, bryder du straks sort-højden (regel 5), som er langt sværere at rette end et par røde i træk.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Augmenteret BST: vælg opdateringsligninger (augmentering)],
  source: "MCQ juni 2015, Spm. 25",
  theory: <th-bst-augment>,
  prompt: [En mængde punkter i planen gemmes i et balanceret binært søgetræ (BST) med punkternes #swap[$x$]-koordinat som nøgle. Hver knude svarer til et punkt og gemmer derudover fire felter for hele sit deltræ: `v.xmax`, `v.xmin`, `v.ymax`, `v.ymin`. Hvilket sæt opdateringsligninger vedligeholder felterne korrekt i knude $v$ ud fra dens børn `v.left`, `v.right` og dens egne koordinater `v.x`, `v.y`?],
  options: (
    [`v.xmax = v.left.xmax`; `v.xmin = v.right.xmin`; `v.ymax = max(v.left.ymax, v.right.ymax, v.y)`; `v.ymin = min(v.left.ymin, v.right.ymin, v.y)`],
    [`v.xmax = v.right.xmax`; `v.xmin = v.left.xmin`; `v.ymax = min(v.left.ymax, v.right.ymax, v.y)`; `v.ymin = max(v.left.ymin, v.right.ymin, v.y)`],
    [`v.ymax = v.right.ymax`; `v.ymin = v.left.ymin`; `v.xmax = max(v.left.xmax, v.right.xmax, v.x)`; `v.xmin = min(v.left.xmin, v.right.xmin, v.x)`],
    [`v.xmax = v.right.xmax`; `v.xmin = v.left.xmin`; `v.ymax = max(v.left.ymax, v.right.ymax, v.y)`; `v.ymin = min(v.left.ymin, v.right.ymin, v.y)`],
  ),
  answer: [Mulighed (d).],
  blueprint: [
    Først finder du ud af, om feltet hænger på nøglen eller ikke. Det afgør formlen.

    + *Hvad er træet sorteret efter?* Her er nøglen #swap[$x$]. Et ekstremum af selve nøglen ligger fast: største #swap[$x$] er den højreste knude, mindste #swap[$x$] den venstreste.
    + *Nøglefelt.* Største nøgle hentes direkte fra højre barn, mindste fra venstre barn. Ingen sammenligning med knuden selv.
    + *Ikke-nøglefelt.* Et felt på en anden koordinat (#swap[$y$]) er ikke ordnet af træet. Tag $max$ eller $min$ over begge børn og knudens egen værdi.
    + *Sortér svarene fra.* Smid de muligheder ud, der bytter venstre/højre på nøglefeltet, eller bytter $max$ og $min$, eller henter et ikke-nøglefelt fra kun ét barn.
  ],
  worked: [
    Nøglen er $x$, og felterne er `xmax`, `xmin`, `ymax`, `ymin`.

    + `xmax` og `xmin` hænger på nøglen. Største $x$ ligger længst til højre, så `xmax = v.right.xmax`. Mindste $x$ ligger længst til venstre, så `xmin = v.left.xmin`.
    + `ymax` og `ymin` hænger på $y$, som træet ikke sorterer efter. Begge børn og knuden selv kan have ekstremet, så `ymax = max(v.left.ymax, v.right.ymax, v.y)` og `ymin = min(...)`.

    Nu tjekker jeg de fire muligheder mod det:

    - (a) bytter venstre og højre på $x$-felterne. Forkert.
    - (b) bytter $max$ og $min$ på $y$. Forkert.
    - (c) henter $y$ fra ét fast barn, som var $y$ sorteret. Forkert.
    - (d) rammer alle fire formler. Rigtig.

    Svar: mulighed (d).
  ],
)

#qcard(
  tag: [Augmenteret BST: vælg opdateringsligninger (augmentering)],
  source: "MCQ juni 2021, Spm. 31",
  theory: <th-bst-augment>,
  prompt: [For en sorteret liste $x_1 <= dots.h <= x_n$ defineres summen af kvadrerede mellemrum $"ssg" = sum_(i=2)^n (x_i - x_(i-1))^2$. Hver knude $v$ gemmer $v.x$ samt $v."min"$, $v."max"$ og $v."ssg"$ for hele sit deltræ. Børnene er $v.l$ og $v.r$. Hvilken formel giver #swap[$v."ssg"$] ud fra børnenes værdier (begge børn findes)?],
  options: (
    [$v."ssg" = v.l."ssg" + v.r."ssg"$],
    [$v."ssg" = v.l."ssg" + (v.r."min" - v.l."max")^2 + v.r."ssg"$],
    [$v."ssg" = v.l."ssg" + (v.x - v.l."max")^2 + (v.x - v.r."min")^2 + v.r."ssg"$],
    [$v."ssg" = v.l."ssg" + (v.r.x - v.l.x)^2 + v.r."ssg"$],
    [$v."ssg" = v.l."ssg" + (v.x - v.l.x)^2 + (v.x - v.r.x)^2 + v.r."ssg"$],
  ),
  answer: [Mulighed (c): $v."ssg" = v.l."ssg" + (v.x - v.l."max")^2 + (v.x - v.r."min")^2 + v.r."ssg"$.],
  blueprint: [
    Et aggregat over nabopar i sorteret orden samles fra venstre del, højre del og de to overgange til knuden selv.

    + *Skriv inorder-rækken ud.* Deltræets nøgler er #swap[venstre deltræ], så $v.x$, så #swap[højre deltræ].
    + *Find de gamle par.* Mellemrummene inde i venstre og højre del er allerede talt med i $v.l."ssg"$ og $v.r."ssg"$.
    + *Find de nye par.* De eneste nye nabopar er $(v.l."max", v.x)$ og $(v.x, v.r."min")$. Brug deltræs-feltet, ikke barnets egen nøgle.
    + *Læg sammen.* Summen er de to indre dele plus de to nye kvadrerede mellemrum.
  ],
  worked: [
    Inorder-nøglerne er $L + [v.x] + R$, hvor $L$'s største er $v.l."max"$ og $R$'s mindste er $v.r."min"$. Summen $"ssg"$ løber over *alle nabopar* i denne sorterede række.

    + Mellemrummene inde i $L$ er allerede talt i $v.l."ssg"$, og inde i $R$ i $v.r."ssg"$.
    + De eneste nabopar, der ikke var med før, er de to overgange til $v$: $(v.l."max", v.x)$ og $(v.x, v.r."min")$. Kvadrering gør fortegnet ligegyldigt.
    + Altså $v."ssg" = v.l."ssg" + (v.x - v.l."max")^2 + (v.x - v.r."min")^2 + v.r."ssg"$.

    Talkontrol. Lad $L = {1, 3}$, $v.x = 6$, $R = {10, 12}$, så hele rækken er $1, 3, 6, 10, 12$.

    ```
    par i L:        (3-1)^2 = 4              -> v.l.ssg = 4
    par i R:        (12-10)^2 = 4            -> v.r.ssg = 4
    overgang v.l.max=3 -> v.x=6:  (6-3)^2 = 9
    overgang v.x=6 -> v.r.min=10: (10-6)^2 = 16
    sum = 4 + 9 + 16 + 4 = 33
    ```

    Direkte over hele rækken: $(3-1)^2 + (6-3)^2 + (10-6)^2 + (12-10)^2 = 4+9+16+4 = 33$. Stemmer med formel (c).

    Mulighederne: (a) glemmer overgangene til $v$; (b) springer $v$ over og bruger ét forkert par; (d) og (e) bruger børnenes egne nøgler i stedet for deltræets ekstrem. Kun (c) rammer.

    Svar: mulighed (c).
  ],
)

#qcard(
  tag: [Augmenteret BST: vælg opdateringsligninger (augmentering)],
  source: "MCQ juni 2023, Spm. 30",
  theory: <th-bst-augment>,
  prompt: [Nøgler $x_1 < dots.h < x_n$ ligger i et rød-sort træ, hver farvet sort eller hvid. En *stime* er et maksimalt løb af på hinanden følgende sort-farvede knuder i inorder. Hver knude $v$ gemmer $v."maxS"$ (længste stime i $T(v)$), $v."maxLS"$ (længste stime der starter ved venstreste nøgle), $v."maxRS"$ (længste stime der ender ved højreste nøgle) og $v."hasWhite"$. Hvilken rekursion beregner #swap[$v."maxS"$] korrekt ud fra børnene $v.l$ og $v.r$?],
  options: (
    [sort: $max{v.l."maxS", space v.r."maxS", space v.l."maxRS" + v.r."maxLS"}$; hvid: $max{v.l."maxS", space v.r."maxS"}$],
    [sort: $max{v.l."maxS", space v.r."maxS", space v.l."maxRS" + 1 + v.r."maxLS"}$; hvid: $max{v.l."maxS", space v.r."maxS"}$],
    [hvid: $max{v.l."maxS", space v.r."maxS", space v.l."maxRS" + 1 + v.r."maxLS"}$; sort: $max{v.l."maxS", space v.r."maxS"}$],
    [sort: $v.l."maxS" + v.r."maxS" + v.l."maxRS" + v.r."maxLS"$; hvid: $v.l."maxS" + v.r."maxS"$],
  ),
  answer: [Mulighed (b): sort knude tager $max{v.l."maxS", space v.r."maxS", space v.l."maxRS" + 1 + v.r."maxLS"}$, hvid knude $max{v.l."maxS", space v.r."maxS"}$.],
  blueprint: [
    Den længste stime i $T(v)$ er den bedste af kun venstre, kun højre, eller en der går gennem $v$. Den gennemgående tæller kun, hvis $v$ selv er sort.

    + *De to rene tilfælde.* Tag den bedste stime fra hvert barn: $v.l."maxS"$ og $v.r."maxS"$.
    + *Den gennemgående.* Kun mulig hvis #swap[$v$ er sort]. Den binder løbet der ender til venstre ($v.l."maxRS"$), $v$ selv ($+1$) og løbet der starter til højre ($v.r."maxLS"$).
    + *Hvid blokerer.* Er $v$ hvid, brydes stimen ved $v$, så kun de to rene tilfælde tæller.
    + *Sortér fra.* Smid svar uden $+1$ (glemmer $v$), svar der bytter sort/hvid, og svar der lægger sammen i stedet for $max$.
  ],
  worked: [
    Den længste stime i $T(v)$ er den bedste af tre kandidater: helt inde i venstre deltræ ($v.l."maxS"$), helt inde i højre ($v.r."maxS"$), eller en der løber gennem $v$ selv. Den gennemgående findes kun, hvis $v$ er sort, og den binder det sorte løb der ender til venstre ($v.l."maxRS"$), $v$ selv ($+1$) og løbet der starter til højre ($v.r."maxLS"$).

    *Sort $v$:* $max{v.l."maxS", space v.r."maxS", space v.l."maxRS" + 1 + v.r."maxLS"}$. *Hvid $v$:* $max{v.l."maxS", space v.r."maxS"}$ (stimen brydes ved $v$).

    Et lille talsekempel for en *sort* $v$. Lad inorder af $T(v)$ være

    ```
    venstre deltræ:  sort sort hvid sort    (maxS=2, maxRS=1)
    v (sort)
    højre deltræ:    sort sort sort hvid    (maxS=3, maxLS=3)
    ```

    De tre kandidater: $v.l."maxS" = 2$, $v.r."maxS" = 3$, og den gennemgående $v.l."maxRS" + 1 + v.r."maxLS" = 1 + 1 + 3 = 5$ (det sammenhængende løb "sort, $v$, sort sort sort"). Maks er $5$ — netop hvad formel (b) giver. Uden $+1$'et fra (a) ville man få $4$ og misse, at $v$ selv hører med.

    - (a) glemmer $+1$ for $v$ selv. Forkert.
    - (c) bytter sort og hvid. Forkert.
    - (d) bruger sum i stedet for $max$. Forkert.
    - (b) rammer både $+1$'et og den rigtige farvebetingelse. Rigtig.

    Svar: mulighed (b).
  ],
)

#qcard(
  tag: [Augmenteret BST: vælg opdateringsligninger (augmentering)],
  source: "MCQ juni 2023, Spm. 31",
  theory: <th-bst-augment>,
  prompt: [Samme augmenterede træ med stimer. Hvordan beregnes #swap[$v."maxLS"$] (længste stime der starter ved venstreste nøgle) ud fra børnene (begge børn findes)?],
  options: (
    [$v."maxLS" = v.l."maxLS"$ hvis $v$'s nøgle er hvid; $v.l."maxS" + 1 + v.r."maxLS"$ hvis $v$'s nøgle er sort],
    [$v."maxLS" = v.l."maxLS"$ hvis hvid; $v.l."maxS" + v.r."maxLS"$ hvis sort],
    [$v."maxLS" = v.l."maxLS"$ hvis $v.l."hasWhite"$ eller $v$ hvid; $v.l."maxS" + 1 + v.r."maxLS"$ ellers],
    [$v."maxLS" = v.l."maxLS"$ hvis $v.l."hasWhite"$ eller $v$ hvid; $v.l."maxS" + v.r."maxLS"$ ellers],
  ),
  answer: [Mulighed (a): $v.l."maxLS"$ hvis $v$ hvid, ellers $v.l."maxS" + 1 + v.r."maxLS"$.],
  blueprint: [
    $"maxLS"$ er det længste sorte løb fra den venstreste nøgle. Grenen afhænger kun af $v$'s *egen* farve.

    + *Hvid $v$.* Løbet brydes ved $v$, så $v."maxLS" = v.l."maxLS"$.
    + *Sort $v$.* Løbet kan kun nå forbi $v$, hvis #swap[hele venstre deltræ er sort] — da er $v.l."maxS"$ lig hele venstre størrelse. Læg $1$ for $v$ og $v.r."maxLS"$ til.
    + *Sortér fra.* Smid svar der betinger på $v.l."hasWhite"$ (forkert felt) eller dropper $+1$'et for $v$.
  ],
  worked: [
    $v."maxLS"$ er det længste sorte løb, der starter ved den *venstreste* nøgle i $T(v)$. Inorder er $L + [v] + R$, og det venstreste element ligger i $L$. To tilfælde efter $v$'s egen farve:

    *Hvid $v$:* løbet kan aldrig nå forbi $v$, fordi en hvid knude bryder det. Så er det præcis $L$'s eget venstre-løb, $v."maxLS" = v.l."maxLS"$.

    *Sort $v$:* løbet kan kun nå forbi $v$ og ind i $R$, hvis *hele* $L$ er sort, for ellers brydes løbet et sted inde i $L$, før det når $v$. "Hele $L$ sort" er netop $v.l."maxS" = |L|$, og så er $v.l."maxLS" = v.l."maxS"$. Læg $1$ for $v$ og $v.r."maxLS"$ til: $v.l."maxS" + 1 + v.r."maxLS"$.

    Konkret, sort $v$ med helt sort venstre deltræ:

    ```
    L:  sort sort sort      (maxS = maxLS = 3, hele L sort)
    v:  sort
    R:  sort sort hvid ...  (maxLS = 2)
    ```

    $v."maxLS" = 3 + 1 + 2 = 6$ — løbet fra venstreste nøgle gennem hele $L$, $v$, og to ind i $R$. Felterne bruger $v.l."maxS"$ (ikke barnets egen nøgle), så aggregatet kan vedligeholdes i $O(1)$.

    Kun (a) har både den rigtige betingelse (på $v$'s egen farve) og $+1$'et. (b) mangler $+1$; (c) og (d) betinger fejlagtigt på $v.l."hasWhite"$.

    Svar: mulighed (a).
  ],
)

#qcard(
  tag: [Augmenteret BST: hvorfor bevares O(log n)? (augmentering)],
  source: "MCQ juni 2015, Spm. 26",
  theory: <th-bst-augment-maintain>,
  prompt: [Lad nu søgetræet være et rød-sort træ. Hvilke af følgende er korrekte argumenter for, at informationen i træets knuder kan vedligeholdes under indsættelser og sletninger, uden at ændre de rød-sorte træers køretid på $O(log n)$ for indsættelser og sletninger?],
  options: (
    [Ingen information i knuderne behøver at ændres under indsættelser og sletninger, så de rød-sorte træers $O(log n)$-køretid holder stadig.],
    [Kun roden får ny information, og det er $O(1)$ ekstra arbejde oven i de rød-sorte træers $O(log n)$-køretid, hvilket stadig er $O(log n)$.],
    [Ved indsættelser behøver kun det nye blad ny information ($O(1)$ ekstra), og ved sletninger kan information kun forsvinde, hvilket ikke giver arbejde.],
    [Efter ændringer i træet under indsættelser og sletninger behøver kun knuder på en sti fra et blad til roden ny information, og den kan genberegnes nedefra og op i tid $O(log n)$.],
    [Efter ændringer kan et inorder-gennemløb af træet genoprette informationen i alle knuder i tid $O(log n)$.],
  ),
  answer: [Mulighed (d).],
  blueprint: [
    Argumentet skal vise to ting: kun få knuder rører sig, og hver opdatering er billig.

    + *Hvilke knuder ændrer felt?* Kun knuderne på #swap[stien fra det berørte blad op til roden], plus de $O(1)$ rotationer balanceringen laver. Resten af træet er urørt.
    + *Kan feltet genberegnes lokalt?* Ja, hvis det kun afhænger af knudens egen værdi og de to børns felter. Så koster én knude $O(1)$.
    + *Saml regnestykket.* Stien er højst træets højde, altså $O(log n)$ knuder, hver til $O(1)$. I alt $O(log n)$, samme som indsæt og slet i forvejen.
    + *Sortér svarene fra.* Et svar, der siger "ingen opdatering", "kun roden" eller "kun ved indsæt", overser stien. Et inorder-gennemløb rører alle knuder og er $O(n)$, ikke $O(log n)$.
  ],
  worked: [
    Træet er rød-sort, så højden er $O(log n)$.

    + En indsæt eller slet ændrer kun knuder på én sti fra blad til rod, plus $O(1)$ rotationer. Hver rotation flytter lokalt på $O(1)$ felter.
    + Hvert felt kan genfindes fra knudens egen værdi og de to børn, så én knude koster $O(1)$.
    + Genberegning nedefra og op langs stien rører $O(log n)$ knuder. Samlet $O(log n)$.

    Mulighederne:

    - (a) påstår at intet felt ændres. Falsk, de gør.
    - (b) siger kun roden. Falsk, hele stien.
    - (c) glemmer at sletninger også skal opdatere. Falsk.
    - (d) rammer stien og genberegningen nedefra og op. Rigtig.
    - (e) bruger inorder, som er $O(n)$. Falsk.

    Svar: mulighed (d).
  ],
)

#qcard(
  tag: [Augmenteret BST: O(1)-forespørgsel fra roden (augmentering)],
  source: "MCQ juni 2015, Spm. 27",
  theory: <th-bst-augment>,
  prompt: [Punkterne ligger i et balanceret BST nøglet på $x$, og hver knude gemmer deltræs-felterne `xmin`, `xmax`, `ymin`, `ymax`. Hvordan kan arealet af det rektangel, punkterne udspænder, bestemmes i #swap[$O(1)$] ud fra træet?],
  options: (
    [Arealet er $v."ymin" times u."ymax"$, hvor $v$ er det venstreste blad og $u$ det højreste blad.],
    [Arealet er $r."xmax" times r."ymax"$, hvor $r$ er roden.],
    [Arealet er $(r."xmax" - r."xmin") times (r."ymax" - r."ymin")$, hvor $r$ er roden.],
    [Arealet findes ved et inorder-gennemløb, der finder mindste og største $x$ og $y$, og derfra sidelængderne.],
  ),
  answer: [Mulighed (c): $(r."xmax" - r."xmin") times (r."ymax" - r."ymin")$.],
  blueprint: [
    Et $O(1)$-svar kræver, at de fire ekstremer allerede er gemt. Roden i et augmenteret træ opsummerer hele mængden.

    + *Skriv formlen for det omsluttende rektangel.* Areal $=$ bredde $times$ højde $= (x_max - x_min)(y_max - y_min)$.
    + *Find ekstremerne i $O(1)$.* I et augmenteret træ holder #swap[roden] aggregatet over alle punkter: `r.xmin`, `r.xmax`, `r.ymin`, `r.ymax`.
    + *Saml.* Sæt rodens fire felter ind i arealformlen.
    + *Sortér fra.* Smid svar der mangler at trække min'erne fra, kun bruger blade, eller bruger et $O(n)$-gennemløb.
  ],
  worked: [
    Det omsluttende rektangel har areal $("bredde") dot ("højde") = (x_max - x_min)(y_max - y_min)$.

    + $O(1)$ kræver, at ekstremerne er forberegnet og gemt.
    + Roden $r$ holder aggregatet over alle punkter, så $r."xmin"$, $r."xmax"$, $r."ymin"$, $r."ymax"$ er de fire ekstremer.
    + Altså areal $= (r."xmax" - r."xmin")(r."ymax" - r."ymin")$.

    (a) bruger kun $y$ fra blade; (b) glemmer at trække min'erne fra; (d) bruger et $O(n)$-inorder. Kun (c).

    Svar: mulighed (c).
  ],
)

#qcard(
  tag: [Augmenteret BST: O(1)-forespørgsel fra roden (augmentering)],
  source: "MCQ juni 2015, Spm. 29",
  theory: <th-bst-augment>,
  prompt: [Vi vil nu nå de samme resultater på en anden måde: arealet af det udspændte rektangel i #swap[$O(1)$] og et punkt på hver af de fire sider i #swap[$O(log n)$], stadig med indsæt og slet i $O(log n)$. Antag at ingen to punkter deler $x$-koordinat, og ingen to deler $y$-koordinat. Det skal klares med *to træer uden ekstra information i nogen knude*. Hvilken datastruktur virker?],
  options: (
    [Et træ er en max-heap nøglet på punkternes $x$; det andet en max-heap nøglet på $y$.],
    [Et træ er en max-heap nøglet på $x$; det andet et rød-sort træ nøglet på $y$, der gemmer største og mindste $y$ i to globale variable.],
    [Begge er rød-sorte træer: ét nøglet på $x$ med største og mindste $x$ gemt i to globale variable, ét nøglet på $y$ med største og mindste $y$ gemt i to globale variable.],
    [Begge er Huffman-træer (Huffman trees): ét med $x$-koordinaterne som hyppigheder, ét med $y$-koordinaterne som hyppigheder.],
  ),
  answer: [Mulighed (c): to rød-sorte træer, ét nøglet på $x$ og ét på $y$, hver med min og max cachet i to globale variable.],
  blueprint: [
    Skriv kravene op først, og kør hver kandidat imod dem. Du skal bruge *både* min og max på begge koordinater, plus indsæt og slet i $O(log n)$.

    + *Kravene.* Areal i $O(1)$, de fire ekstreme punkter (min og max på $x$ og $y$) i $O(log n)$, indsæt og slet i $O(log n)$.
    + *Smid heap'en.* En max-heap giver kun max (eller kun min) i $O(1)$; den anden ekstrem og sletning af et vilkårligt punkt er ikke $O(log n)$.
    + *Smid Huffman.* Et Huffman-træ bygges statisk ud fra hyppigheder og understøtter hverken ekstrem-forespørgsler eller dynamisk indsæt og slet.
    + *Vælg de balancerede træer.* Et rød-sort træ giver venstreste og højreste knude (min og max på nøglen) i $O(log n)$ og indsæt/slet i $O(log n)$. Cacher du min og max i to globale variable, bliver arealet $O(1)$ — og en global variabel er ikke ekstra info i en knude.
  ],
  worked: [
    De fire sider er bestemt af min $x$, max $x$, min $y$ og max $y$, og arealet er $(x_max - x_min)(y_max - y_min)$, ønsket i $O(1)$.

    - (a): to max-heaps giver kun maksimum. Minimum kan ikke hentes, og sletning af et vilkårligt punkt er ikke $O(log n)$. Forkert.
    - (b): heap'en på $x$ kan ikke levere både min og max $x$ i $O(log n)$. Forkert.
    - (d): Huffman-træer koder hyppigheder og bygges statisk; de svarer ikke på ekstremer og understøtter ikke dynamisk indsæt og slet. Forkert.
    - (c): et rød-sort træ på $x$ giver venstreste og højreste punkt (min og max $x$) i $O(log n)$ og indsæt/slet i $O(log n)$; tilsvarende for $y$. Min og max i globale variable gør arealet $O(1)$, og de variable hænger ikke på den enkelte knude. Rammer alle krav.

    Svar: mulighed (c).
  ],
)

#qcard(
  tag: [Augmenteret BST: O(log n)-forespørgsel ned ad træet (flere rigtige) (augmentering)],
  source: "MCQ juni 2015, Spm. 28 (flere rigtige)",
  theory: <th-bst-augment>,
  prompt: [Træet er et balanceret BST nøglet på $x$ og augmenteret i hver knude med deltræs-`xmin`, `xmax`, `ymin`, `ymax`. For hver af de fire sider af det udspændte rektangel vil vi finde et punkt på siden. Hvordan gøres det i #swap[$O(log n)$] med træet? (et eller flere svar)],
  options: (
    [Punkterne på de *vandrette* sider findes med Tree-Maximum og Tree-Minimum. Punktet på højre lodrette side findes med en rekursiv søgning fra roden, der via `xmax`-værdierne går mod største $x$; venstre side via `xmin`.],
    [Punkterne på de *lodrette* sider findes med Tree-Maximum og Tree-Minimum. Punktet på øverste vandrette side findes med en rekursiv søgning fra roden, der via `ymax`-værdierne går mod største $y$; nederste side via `ymin`.],
    [Punkterne på både de vandrette og de lodrette sider findes med Tree-Maximum og Tree-Minimum.],
    [Øverste vandrette punkt findes via en `ymax`-styret søgning fra roden, nederste via `ymin`. Højre lodrette punkt findes via en `xmax`-styret søgning fra roden, venstre via `xmin`.],
    [Punkterne på alle fire sider findes ved et inorder-gennemløb.],
  ),
  answer: [Mulighed (b) (lærebogssvaret). Mulighed (d) er også algoritmisk gyldig, men (b) er det tilsigtede svar med Tree-Maximum/Minimum på nøgledimensionen.],
  blueprint: [
    En lodret side har et ekstremt $x$ (træets nøgle), en vandret side et ekstremt $y$ (ikke nøglen). De to slags kræver hver sin metode.

    + *Find nøglesiderne.* Højre side $=$ største $x$, venstre $=$ mindste $x$. Da $x$ er nøglen, giver #swap[Tree-Maximum] og #swap[Tree-Minimum] dem direkte i $O(log n)$.
    + *Find ikke-nøglesiderne.* Øverste $=$ største $y$, nederste $=$ mindste $y$. $y$ er ikke ordnet af træet, så følg det augmenterede `ymax` (resp. `ymin`): stig fra roden mod barnet, hvis deltræs-`ymax` matcher knudens.
    + *Begge er $O(log n)$.* Hvert skridt går ét niveau ned i et balanceret træ.
    + *Sortér fra.* Smid svar der bruger Tree-Max/Min på $y$ (ikke ordnet), og smid inorder ($O(n)$).
  ],
  worked: [
    Træet er $x$-ordnet og augmenteret med `xmin`/`xmax`/`ymin`/`ymax`.

    - Lodrette sider kræver ekstremt $x$. Da $x$ er nøglen, giver Tree-Maximum det højreste punkt og Tree-Minimum det venstreste, begge $O(log n)$.
    - Vandrette sider kræver ekstremt $y$, som $x$-ordenen ikke arrangerer. Stig fra roden langs barnet, hvis deltræs-`ymax` matcher knudens `ymax`, til øverste punkt (og `ymin` til nederste), hvert $O(log n)$.

    Mulighederne:

    - (a) bruger Tree-Max/Min på $y$-siderne. Forkert.
    - (b) bruger Tree-Max/Min på nøglen ($x$) og augmentering på $y$. Rigtig, lærebogssvaret.
    - (c) bruger Tree-Max/Min på alle fire. Forkert.
    - (d) bruger augmenteret søgning på begge dimensioner. Algoritmisk gyldig, men ikke det tilsigtede svar.
    - (e) bruger inorder, $O(n)$. Forkert.

    Svar: mulighed (b) (og (d) gyldig).
  ],
)

#qcard(
  tag: [Augmenteret BST: O(log n)-forespørgsel ned ad træet (flere rigtige) (augmentering)],
  source: "MCQ juni 2023, Spm. 32",
  theory: <th-bst-augment>,
  prompt: [Med $r."maxS"$ kender vi den længste sorte stimes længde i $O(1)$. Vi vil nu i #swap[$O(log n)$] finde en knude, hvis nøgle er en del af en længste sort stime. Hver algoritme starter med $v = $ rod; kun tilfældet, hvor begge børn findes, beskrives. Hvilken algoritme virker?],
  options: (
    [Hvis $v."maxS" > v.l."maxS"$ og $v."maxS" > v.r."maxS"$, returnér $v$. Ellers hvis $v."maxS" = v.l."maxS"$, gå til $v.l$. Ellers gå til $v.r$.],
    [Hvis $v.l."maxS" > v.r."maxS"$, gå til $v.l$. Ellers hvis $v.l."maxS" < v.r."maxS"$, gå til $v.r$. Ellers returnér $v$.],
    [Hvis $v.l."hasWhite"$, gå til $v.r$. Ellers hvis $v.r."hasWhite"$, gå til $v.l$. Ellers returnér $v$.],
    [Hvis ikke $v."hasWhite"$, returnér $v$. Ellers hvis ikke $v.l."hasWhite"$, gå til $v.l$. Ellers gå til $v.r$.],
  ),
  answer: [Mulighed (a).],
  blueprint: [
    Roden $"maxS"$ er det globale maksimum $M$, og $"maxS"(v) = max("venstre", "højre", "ved-"v)$. Følg kilden til maksimummet ned.

    + *Er maks ved $v$?* Overstiger #swap[$v."maxS"$] begge børns $"maxS"$, ligger den længste stime midt på $v$ — returnér $v$.
    + *Ellers følg kilden.* Gå til det barn, hvis $"maxS"$ er lig $v."maxS"$.
    + *Ét niveau pr. skridt* giver $O(log n)$ i et balanceret træ.
    + *Sortér fra.* Smid svar der ignorerer $v$'s egen værdi (kun sammenligner børn), og svar der bruger `hasWhite` (forkert felt).
  ],
  worked: [
    Rodens $"maxS"$ er det globale maksimum $M$, og for enhver knude gælder $v."maxS" = max(v.l."maxS", space v.r."maxS", space "stime gennem" v)$. Algoritmen følger kilden til $M$ ned i træet, ét niveau ad gangen ($O(log n)$ i et balanceret træ).

    Algoritme (a): hvis $v."maxS"$ er strengt større end *begge* børns $"maxS"$, kommer maksimummet fra stimen gennem $v$ selv — returnér $v$. Ellers gå til det barn, hvis $"maxS"$ er lig $v."maxS"$.

    Eksempel: antag $r."maxS" = 5$, og roden har $v.l."maxS" = 5$, $v.r."maxS" = 3$.

    ```
    v = rod:  v.maxS=5, v.l.maxS=5  => ikke > begge børn
              5 = v.l.maxS, så gå til venstre barn
    v = v.l:  antag v.maxS=5, børn 2 og 4
              5 > 2 og 5 > 4  => returnér v.l (stimen er centreret her)
    ```

    Algoritmen ender på en knude, hvis $"maxS"$ overstiger begge børn, altså en knude, hvis egen nøgle indgår i en længste stime.

    + (a) returnerer $v$, når den længste stime er centreret på $v$, og følger ellers kilden til maksimummet. Rigtig.
    + (b) ignorerer $v$'s egen $"maxS"$ og kan misse stimer centreret på $v$. Forkert.
    + (c) og (d) bruger `hasWhite`, det forkerte felt. Forkert.

    Svar: mulighed (a).
  ],
)

#qcard(
  tag: [Hashing: hvilke h'-værdier passer? (linear probing)],
  source: "MCQ juni 2021, Spm. 9 (samme type 2015/2017/2019/2023)",
  theory: <th-bst-linear-probing>,
  prompt: [En hashtabel $H$ bruger linear probing og en hjælpe-hashfunktion $h'(x)$. Tabellen er nu (indeks 0..6): plads 0 $=$ #swap[12], plads 1 tom, plads 2 $=$ #swap[10], plads 3 tom, plads 4 $=$ #swap[22], plads 5 tom, plads 6 $=$ #swap[31]. Derefter indsættes #swap[97], og tabellen er bagefter: plads 0 $=$ 12, plads 1 $=$ 97, plads 2 $=$ 10, plads 3 tom, plads 4 $=$ 22, plads 5 tom, plads 6 $=$ 31. Tabelstørrelse #swap[$m = 7$]. Hvilke værdier af $h'(97)$ er mulige? (et eller flere svar)],
  options: (
    [$h'(97) = 0$],
    [$h'(97) = 1$],
    [$h'(97) = 2$],
    [$h'(97) = 3$],
    [$h'(97) = 4$],
    [$h'(97) = 5$],
    [$h'(97) = 6$],
  ),
  answer: [Mulighederne (a), (b) og (g): $h'(97) in #swap[${0, 1, 6}$]$.],
  blueprint: [
    Du kender landingspladsen og skal finde, hvilke startværdier der kunne ende der. Prøv dem alle.

    + *Aflæs tabellen.* Noter hvilke pladser der var optaget før indsættelsen, og hvilken plads den nye nøgle endte på.
    + *Linear probing.* Probe-sekvensen er $h(k,i) = (h'(k) + i) mod m$, altså start ved #swap[$h'$] og gå ét skridt frem ad gangen til første tomme plads.
    + *Prøv hver kandidat.* For hvert mulige $h'$ følger du sekvensen fra den startplads, til du rammer en tom plads. Lander den på den observerede plads, er kandidaten gyldig.
    + *Saml svaret.* Behold de startværdier, hvis sekvens ender på den rigtige plads.
  ],
  worked: [
    Tabellen før indsættelsen, og hvor $97$ faktisk endte ($m = 7$, probe-reglen $h(k,i) = (h'(k)+i) mod 7$):

    ```
    indeks:   0    1    2    3    4    5    6
    før:     12    .   10    .   22    .   31      optaget: {0,2,4,6}
    efter:   12   97   10    .   22    .   31      97 landede på plads 1
    ```

    For hvert tænkt $h'(97)$ følger jeg sekvensen $h', h'+1, h'+2, dots$ (mod 7) til den første tomme plads. Lander den på plads 1, er kandidaten gyldig.

    ```
    h'=0:  0 optaget -> 1 TOM            => lander 1   PASSER
    h'=1:  1 TOM                         => lander 1   PASSER
    h'=2:  2 optaget -> 3 TOM            => lander 3   nej
    h'=3:  3 TOM                         => lander 3   nej
    h'=4:  4 optaget -> 5 TOM            => lander 5   nej
    h'=5:  5 TOM                         => lander 5   nej
    h'=6:  6 optaget -> 0 optaget -> 1 TOM (wrap) => lander 1   PASSER
    ```

    Kun $h' in {0, 1, 6}$ ender på plads 1.

    Svar: $h'(97) in {0, 1, 6}$, altså (a), (b) og (g).
  ],
)

#qcard(
  tag: [Hashing: hvilke h'-værdier passer? (linear probing)],
  source: "MCQ juni 2019, Spm. 9 (samme type 2015/2017/2021/2023) (flere rigtige)",
  theory: <th-bst-linear-probing>,
  prompt: [En hashtabel $H$ bruger linear probing og en hjælpe-hashfunktion $h'(x)$. Tabellen er nu (indeks 0..6): plads 0 $=$ #swap[33], plads 1 tom, plads 2 $=$ #swap[27], plads 3 $=$ #swap[32], plads 4 $=$ #swap[55], plads 5 tom, plads 6 $=$ #swap[47]. Derefter indsættes #swap[99], og tabellen er bagefter: plads 0 $=$ 33, plads 1 $=$ 99, plads 2 $=$ 27, plads 3 $=$ 32, plads 4 $=$ 55, plads 5 tom, plads 6 $=$ 47. Tabelstørrelse #swap[$m = 7$]. Hvilke værdier af $h'(99)$ er mulige? (et eller flere svar)],
  options: (
    [$h'(99) = 0$],
    [$h'(99) = 1$],
    [$h'(99) = 2$],
    [$h'(99) = 3$],
    [$h'(99) = 4$],
    [$h'(99) = 5$],
    [$h'(99) = 6$],
  ),
  answer: [Mulighederne (a), (b) og (g): $h'(99) in #swap[${0, 1, 6}$]$.],
  blueprint: [
    Du kender landingspladsen og skal finde, hvilke startværdier der kunne ende der. Prøv dem alle.

    + *Aflæs tabellen.* Noter hvilke pladser der var optaget før indsættelsen, og hvilken plads den nye nøgle endte på.
    + *Linear probing.* Probe-sekvensen er $h(k,i) = (h'(k) + i) mod m$, altså start ved #swap[$h'$] og gå ét skridt frem ad gangen til første tomme plads.
    + *Prøv hver kandidat.* For hvert mulige $h'$ følger du sekvensen fra den startplads, til du rammer en tom plads. Lander den på den observerede plads, er kandidaten gyldig.
    + *Saml svaret.* Behold de startværdier, hvis sekvens ender på den rigtige plads.
  ],
  worked: [
    Tabellen før og efter ($m = 7$, $h(k,i) = (h'(k)+i) mod 7$):

    ```
    indeks:   0    1    2    3    4    5    6
    før:     33    .   27   32   55    .   47      optaget: {0,2,3,4,6}
    efter:   33   99   27   32   55    .   47      99 landede på plads 1
    ```

    For hvert tænkt $h'(99)$ følger jeg sekvensen til første tomme plads:

    ```
    h'=0:  0 optaget -> 1 TOM                          => lander 1   PASSER
    h'=1:  1 TOM                                       => lander 1   PASSER
    h'=2:  2 -> 3 -> 4 optaget -> 5 TOM                => lander 5   nej
    h'=3:  3 -> 4 optaget -> 5 TOM                     => lander 5   nej
    h'=4:  4 optaget -> 5 TOM                          => lander 5   nej
    h'=5:  5 TOM                                       => lander 5   nej
    h'=6:  6 optaget -> 0 optaget -> 1 TOM (wrap)      => lander 1   PASSER
    ```

    Kun $h' in {0, 1, 6}$ ender på plads 1.

    Svar: $h'(99) in {0, 1, 6}$, altså (a), (b) og (g).
  ],
)

#qcard(
  tag: [Hashing: hvilken rækkefølge/nøgle passer? (linear probing)],
  source: "MCQ juni 2017, Spm. 8 (flere rigtige)",
  theory: <th-bst-linear-probing>,
  prompt: [For en funktion $h'(x)$ gælder #swap[$h'(7)=2$, $h'(9)=2$, $h'(13)=3$, $h'(17)=4$]. En hashtabel $H$ bruger linear probing med $h'(x)$. Fra en tom tabel er #swap[${7,9,13,17}$] indsat i en eller anden rækkefølge, og resultatet er: plads 2 $=$ 9, plads 3 $=$ 7, plads 4 $=$ 17, plads 5 $=$ 13 (resten tomme, $m = 11$). Hvilke af følgende indsættelsesrækkefølger kan have været brugt? (et eller flere svar)],
  options: (
    [$7, 9, 13, 17$],
    [$13, 7, 17, 9$],
    [$9, 17, 7, 13$],
    [$17, 13, 9, 7$],
    [$9, 7, 17, 13$],
  ),
  answer: [Mulighederne (c) og (e): $9,17,7,13$ og $9,7,17,13$ gengiver begge tabellen.],
  blueprint: [
    Simulér hver kandidat-rækkefølge fra en tom tabel og sammenlign med målet. Et hurtigt tjek: en nøgle der er skubbet væk fra sin hjemmeplads, må være indsat *efter* den nøgle, der sidder på hjemmepladsen.

    + *Aflæs.* Noter hver nøgles hjemmeplads $h'(x)$, tabelstørrelsen #swap[$m$], og målpladserne.
    + *Find afhængighederne.* En nøgle på sin hjemmeplads og en anden skubbet ét frem $==>$ den første blev indsat før den anden.
    + *Simulér.* For hver rækkefølge prober du hver nøgle fra dens hjemmeplads til første tomme plads.
    + *Behold dem, der matcher* måltabellen præcist.
  ],
  worked: [
    Hjemmepladser ($m = 11$): $h'(9) = 2$, $h'(7) = 2$, $h'(13) = 3$, $h'(17) = 4$. Måltabellen:

    ```
    indeks:  2   3   4   5
    mål:     9   7  17  13
    ```

    To afhængigheder: $9$ sidder på sin hjemmeplads 2, mens $7$ (samme hjem 2) er skubbet til 3, så $9$ må komme før $7$. Og $17$ sidder på hjemmeplads 4, mens $13$ (hjem 3) er skubbet forbi til 5, så $17$ må komme før $13$.

    Jeg simulerer hver rækkefølge fra tom tabel (kun pladser 2–5 vises):

    ```
    (a) 7,9,13,17:
      7 -> 2 TOM        : [.  7  .  .]
      9 -> 2 opt -> 3   : [.  7  9  .]   forkert (mål har 9 på 2)

    (b) 13,7,17,9:
      13 -> 3 TOM       : [.  . 13  .]   forkert (mål har 7 på 3)

    (c) 9,17,7,13:
      9  -> 2 TOM       : [9  .  .  .]
      17 -> 4 TOM       : [9  . 17  .]
      7  -> 2 opt -> 3  : [9  7 17  .]
      13 -> 3 opt,4 opt -> 5 : [9 7 17 13]   PASSER

    (d) 17,13,9,7:
      17 -> 4           ; 13 -> 3 ; 9 -> 2 ; 7 -> 2 opt,3,4,5 opt -> 6
                           gier 7 på plads 6   forkert

    (e) 9,7,17,13:
      9  -> 2 TOM       : [9  .  .  .]
      7  -> 2 opt -> 3  : [9  7  .  .]
      17 -> 4 TOM       : [9  7 17  .]
      13 -> 3 opt,4 opt -> 5 : [9 7 17 13]   PASSER
    ```

    Kun (c) og (e) gengiver måltabellen.

    Svar: (c) og (e).
  ],
)

#qcard(
  tag: [Hashing: hvilken rækkefølge/nøgle passer? (linear probing)],
  source: "MCQ juni 2023, Spm. 9 (flere rigtige)",
  theory: <th-bst-linear-probing>,
  prompt: [For en funktion $h_1(x)$ gælder #swap[$h_1(22)=6$, $h_1(33)=1$, $h_1(44)=4$, $h_1(55)=1$, $h_1(66)=6$, $h_1(77)=1$]. En hashtabel af længde syv bruger linear probing med $h_1$. Fra en tom tabel er #swap[${22,33,44,55,66,77}$] indsat i en eller anden rækkefølge, og resultatet er: plads 0 $=$ 22, plads 1 $=$ 77, plads 2 $=$ 55, plads 3 $=$ 33, plads 4 $=$ 44, plads 5 tom, plads 6 $=$ 66. Hvilke nøgler kan være indsat #swap[først]? (et eller flere svar)],
  options: (
    [$22$],
    [$33$],
    [$44$],
    [$55$],
    [$66$],
    [$77$],
  ),
  answer: [Mulighederne (c), (e) og (f): $44$, $66$ og $77$.],
  blueprint: [
    Den først indsatte nøgle møder en tom tabel, så den lander præcis på sin hjemmeplads uden probing.

    + *Aflæs.* Noter hver nøgles hjemmeplads $h_1(x)$ og dens faktiske plads i den færdige tabel.
    + *Sammenlign.* En nøgle kan være indsat først, netop hvis dens faktiske plads er lig dens hjemmeplads.
    + *Saml* alle nøgler, hvor de to falder sammen.
  ],
  worked: [
    Den først indsatte nøgle møder en tom tabel og lander derfor præcis på sin hjemmeplads $h_1$ uden at probe. En nøgle kan altså kun være først, hvis dens faktiske plads $=$ dens hjemmeplads.

    ```
    nøgle:  hjem h1   faktisk plads   først muligt?
     22       6           0 (wrap)        nej   (6 != 0)
     33       1           3               nej   (1 != 3)
     44       4           4               JA    (4  = 4)
     55       1           2               nej   (1 != 2)
     66       6           6               JA    (6  = 6)
     77       1           1               JA    (1  = 1)
    ```

    Kun $44$, $66$ og $77$ sidder på deres egen hjemmeplads.

    Svar: $44$, $66$, $77$ — altså (c), (e) og (f).
  ],
)

#qcard(
  tag: [Hashing: hvilken rækkefølge/nøgle passer? (linear probing)],
  source: "MCQ juni 2025, Spm. 9 (flere rigtige)",
  theory: <th-bst-linear-probing>,
  prompt: [For en funktion $h_1(x)$ gælder #swap[$h_1(44)=2$, $h_1(55)=5$, $h_1(66)=1$, $h_1(77)=2$, $h_1(88)=5$, $h_1(99)=6$]. En hashtabel af længde syv bruger linear probing med $h_1$. Fra en tom tabel er #swap[${44,55,66,77,88,99}$] indsat i en eller anden rækkefølge, og resultatet er: plads 0 $=$ 99, plads 1 $=$ 66, plads 2 $=$ 44, plads 3 $=$ 77, plads 4 tom, plads 5 $=$ 88, plads 6 $=$ 55. Hvilke nøgler kan være indsat #swap[sidst]? (et eller flere svar)],
  options: (
    [$44$],
    [$55$],
    [$66$],
    [$77$],
    [$88$],
    [$99$],
  ),
  answer: [Mulighederne (c), (d) og (f): $66$, $77$ og $99$.],
  blueprint: [
    En nøgle kan være sidst, netop hvis den sidder for *enden* af sin probe-klynge, så ingen anden nøgle var afhængig af, at den allerede lå der.

    + *Aflæs.* Noter hver nøgles hjemmeplads $h_1(x)$ og dens faktiske plads.
    + *Fjern kandidaten.* For hver nøgle: tag den ud, og tjek om de andre fem stadig kan gengive resten af tabellen.
    + *Indsæt sidst.* Prober kandidaten fra sin hjemmeplads og lander den præcis på sin faktiske plads, kan den være sidst.
    + *Saml* alle, der består.
  ],
  worked: [
    Hjemmeplads $->$ faktisk plads, og måltabellen ($m = 7$):

    ```
    nøgle:  44  55  66  77  88  99
    hjem:    2   5   1   2   5   6
    plads:   2   6   1   3   5   0

    indeks:  0   1   2   3   4   5   6
    mål:    99  66  44  77   .  88  55
    ```

    En nøgle kan være sidst, hvis (1) probing fra dens hjem hen over de andre fem rammer dens egen plads, *og* (2) de andre fem kan gengive deres egne fem pladser uden den. Krav (1) holder for alle seks her, så krav (2) afgør det. Jeg fjerner kandidaten og spørger, om de fem øvrige stadig kan ende rigtigt:

    ```
    fjern 44: ingen anden nøgle lander på plads 2, så 77 (hjem 2)
              ville lande på 2 i stedet for 3.            FEJLER
    fjern 55: plads 6 bliver tom, så 99 (hjem 6) lander på 6
              i stedet for at wrappe til 0.               FEJLER
    fjern 66: plads 1 nås kun af 66; ingen anden afhænger
              af 66, og 66 (hjem 1) -> 1 sidst.           KAN
    fjern 77: 77 (hjem 2) prober 2(44 opt) -> 3 tom; 77 er
              hale på 44, ingen afhænger af den.          KAN
    fjern 88: plads 5 bliver tom, så 55 (hjem 5) lander på 5
              i stedet for 6.                             FEJLER
    fjern 99: 99 (hjem 6) prober 6(55 opt) -> 0 tom (wrap);
              99 er hale på wrap-klyngen, ingen afhænger. KAN
    ```

    Svar: $66$, $77$, $99$ — altså (c), (d) og (f).
  ],
)

#qcard(
  tag: [Hashing: trace med quadratic probing (quadratic probing)],
  source: "MCQ juni 2015, Spm. 7",
  theory: <th-bst-linear-probing>,
  prompt: [Hashtabellen $H$ bruger quadratic probing med hjælpe-hashfunktion #swap[$h'(x) = (3x + 5) mod 11$] og konstanter #swap[$c_1 = 3$, $c_2 = 1$]. Probe-sekvens: $h(x,i) = (h'(x) + c_1 dot i + c_2 dot i^2) mod #swap[$11$]$. Starttabel (indeks: værdi): #swap[$0:13$, $1:39$, $3:36$, $8:23$, $9:5$] (pladserne 2,4,5,6,7,10 tomme). Indsæt værdierne #swap[$22$, $16$, $17$] (i den rækkefølge). Hvilken tabel viser $H$ bagefter?],
  options: (
    [$0:13 thin 1:39 thin 2:17 thin 3:36 thin 5:22 thin 8:23 thin 9:5 thin 10:16$],
    [$0:13 thin 1:39 thin 2:16 thin 3:36 thin 4:17 thin 5:22 thin 8:23 thin 9:5$],
    [$0:13 thin 1:39 thin 2:16 thin 3:36 thin 5:22 thin 7:17 thin 8:23 thin 9:5$],
    [$0:13 thin 1:39 thin 2:16 thin 3:36 thin 5:22 thin 8:23 thin 9:5 thin 10:17$],
  ),
  answer: [Mulighed (c): $0:13, thick 1:39, thick 2:16, thick 3:36, thick 5:22, thick 7:17, thick 8:23, thick 9:5$.],
  blueprint: [
    Quadratic probing følger samme idé som linear probing, men skridtlængden vokser kvadratisk. Kør én nøgle ad gangen på den opdaterede tabel.

    + *Probe-funktion.* $h(x,i) = (h'(x) + c_1 i + c_2 i^2) mod m$.
    + *For hver værdi* starter du ved $i = 0$ og øger $i$, til du finder en tom plads.
    + *Indsæt* og fortsæt med næste værdi på den nu opdaterede tabel.
  ],
  worked: [
    Probe-funktionen er $h(x,i) = (h'(x) + 3i + i^2) mod 11$ med $h'(x) = (3x+5) mod 11$. Starttabellen:

    ```
    idx:  0   1   2   3   4   5   6   7   8   9  10
    val: 13  39   .  36   .   .   .   .  23   5   .
    ```

    *Indsæt $22$:* $h' = (3 dot 22 + 5) mod 11 = 71 mod 11 = 5$.

    ```
    i=0: slot (5+0+0) mod 11 = 5  TOM  -> 22 her
    idx:  0   1   2   3   4   5   6   7   8   9  10
    val: 13  39   .  36   .  22   .   .  23   5   .
    ```

    *Indsæt $16$:* $h' = (3 dot 16 + 5) mod 11 = 53 mod 11 = 9$.

    ```
    i=0: slot 9                 optaget (5)
    i=1: slot (9+3+1) mod 11 = 2  TOM  -> 16 her
    idx:  0   1   2   3   4   5   6   7   8   9  10
    val: 13  39  16  36   .  22   .   .  23   5   .
    ```

    *Indsæt $17$:* $h' = (3 dot 17 + 5) mod 11 = 56 mod 11 = 1$.

    ```
    i=0: slot 1                   optaget (39)
    i=1: slot (1+3+1)=5           optaget (22)
    i=2: slot (1+6+4)=11 mod 11=0 optaget (13)
    i=3: slot (1+9+9)=19 mod 11=8 optaget (23)
    i=4: slot (1+12+16)=29 mod 11=7  TOM  -> 17 her
    ```

    Sluttabel:

    ```
    idx:  0   1   2   3   4   5   6   7   8   9  10
    val: 13  39  16  36   .  22   .  17  23   5   .
    ```

    Det er $0:13, thin 1:39, thin 2:16, thin 3:36, thin 5:22, thin 7:17, thin 8:23, thin 9:5$.

    Svar: mulighed (c).
  ],
)

#qcard(
  tag: [Hashing: hvilke h₂-værdier passer? (double hashing)],
  source: "MCQ juni 2019, Spm. 10 (samme type 2021/2023/2025) (flere rigtige)",
  theory: <th-bst-double-hashing>,
  prompt: [En hashtabel $H$ bruger double hashing med hjælpe-hashfunktioner $h_1(x)$ og $h_2(x)$. Tabellen er nu (indeks 0..6): #swap[$0:33$, 1 tom, $2:27$, $3:32$, $4:55$, 5 tom, $6:47$]. Derefter indsættes #swap[99], som ender på plads #swap[1]. Probe-sekvens: $h(x,i) = (h_1(x) + i dot h_2(x)) mod #swap[$7$]$. Hvis #swap[$h_1(99) = 2$], hvilke værdier af $h_2(99)$ er mulige? (et eller flere svar)],
  options: (
    [$h_2(99) = 1$],
    [$h_2(99) = 2$],
    [$h_2(99) = 3$],
    [$h_2(99) = 4$],
    [$h_2(99) = 5$],
    [$h_2(99) = 6$],
  ),
  answer: [Mulighederne (b), (d) og (f): $h_2(99) in #swap[${2, 4, 6}$]$.],
  blueprint: [
    Du kender $h_1$ og landingspladsen og skal finde, hvilke skridtlængder $h_2$ rammer den. Prøv dem alle.

    + *Aflæs.* Noter optagne pladser før indsættelsen, tabelstørrelsen #swap[$m$], $h_1$ og landingspladsen.
    + *Double hashing.* Probe-sekvensen er $h(x,i) = (h_1(x) + i dot h_2(x)) mod m$ for $i = 0, 1, 2, dots.h$
    + *Prøv hver kandidat.* For hvert mulige $h_2$ stepper du $i$ frem, til du rammer en tom plads.
    + *Behold* de $h_2$, hvis første tomme plads er lig den observerede landingsplads.
  ],
  worked: [
    Tabellen før indsæt ($m = 7$, $h_1 = 2$, sekvens $(2 + i dot h_2) mod 7$):

    ```
    idx:  0   1   2   3   4   5   6
    val: 33   .  27  32  55   .  47      optaget: {0,2,3,4,6}
                                          99 skal lande på plads 1
    ```

    For hvert $h_2$ stepper jeg $i = 0,1,2,dots$ til første tomme plads (o $=$ optaget):

    ```
    h2=1:  2(o) 3(o) 4(o) 5 TOM                    => 5   nej
    h2=2:  2(o) 4(o) 6(o) (8 mod 7=)1 TOM          => 1   PASSER
    h2=3:  2(o) 5 TOM                              => 5   nej
    h2=4:  2(o) 6(o) (10 mod7=)3(o) 0(o) 4(o) 1 TOM => 1  PASSER
    h2=5:  2(o) (7 mod 7=)0(o) 5 TOM               => 5   nej
    h2=6:  2(o) (8 mod 7=)1 TOM                    => 1   PASSER
    ```

    Svar: $h_2(99) in {2, 4, 6}$ — altså (b), (d) og (f).
  ],
)

#qcard(
  tag: [Hashing: hvilke h₂-værdier passer? (double hashing)],
  source: "MCQ juni 2021, Spm. 10 (flere rigtige)",
  theory: <th-bst-double-hashing>,
  prompt: [En hashtabel $H$ bruger double hashing med $h_1(x)$ og $h_2(x)$. Tabellen er nu (indeks 0..6): #swap[$0:12$, 1 tom, $2:10$, 3 tom, $4:22$, 5 tom, $6:31$]. Derefter indsættes #swap[97], som ender på plads #swap[1]. Probe-sekvens: $h(x,i) = (h_1(x) + i dot h_2(x)) mod #swap[$7$]$. Hvis #swap[$h_1(97) = 0$], hvilke værdier af $h_2(97)$ er mulige? (et eller flere svar)],
  options: (
    [$h_2(97) = 1$],
    [$h_2(97) = 2$],
    [$h_2(97) = 3$],
    [$h_2(97) = 4$],
    [$h_2(97) = 5$],
    [$h_2(97) = 6$],
  ),
  answer: [Mulighederne (a), (b) og (d): $h_2(97) in #swap[${1, 2, 4}$]$.],
  blueprint: [
    Samme fremgang som altid for double hashing: kend $h_1$ og landingspladsen, og prøv hver $h_2$.

    + *Aflæs.* Noter optagne pladser, $m$, $h_1$ og landingspladsen.
    + *Double hashing.* $h(x,i) = (h_1(x) + i dot h_2(x)) mod m$.
    + *Prøv hver kandidat* og find dens første tomme plads.
    + *Behold* de $h_2$, der lander på den observerede plads.
  ],
  worked: [
    Tabellen før indsæt ($m = 7$, $h_1 = 0$, sekvens $(0 + i dot h_2) mod 7$):

    ```
    idx:  0   1   2   3   4   5   6
    val: 12   .  10   .  22   .  31      optaget: {0,2,4,6}
                                          97 skal lande på plads 1
    ```

    For hvert $h_2$ (o $=$ optaget):

    ```
    h2=1:  0(o) 1 TOM                      => 1   PASSER
    h2=2:  0(o) 2(o) 4(o) 6(o) (8 mod7=)1 TOM => 1   PASSER
    h2=3:  0(o) 3 TOM                      => 3   nej
    h2=4:  0(o) 4(o) (8 mod 7=)1 TOM       => 1   PASSER
    h2=5:  0(o) 5 TOM                      => 5   nej
    h2=6:  0(o) 6(o) (12 mod 7=)5 TOM      => 5   nej
    ```

    Svar: $h_2(97) in {1, 2, 4}$ — altså (a), (b) og (d).
  ],
)

#qcard(
  tag: [Hashing: hvilke h₂-værdier passer? (double hashing)],
  source: "MCQ juni 2023, Spm. 10 (flere rigtige)",
  theory: <th-bst-double-hashing>,
  prompt: [En hashtabel $H$ af længde #swap[$8$] bruger double hashing med $h_1, h_2$. Før indsættelse af #swap[25] (indeks 0..7): #swap[$0:13$, $1:56$, $3:32$, $4:91$, $6:82$], resten tomme. 25 ender på plads #swap[5]. Probe-sekvens: $h(x,i) = (h_1(x) + i dot h_2(x)) mod #swap[$8$]$. Hvis #swap[$h_1(25) = 3$], hvilke værdier af $h_2(25)$ er mulige? (et eller flere svar)],
  options: (
    [$h_2(25) = 1$],
    [$h_2(25) = 2$],
    [$h_2(25) = 3$],
    [$h_2(25) = 4$],
    [$h_2(25) = 5$],
    [$h_2(25) = 6$],
    [$h_2(25) = 7$],
  ),
  answer: [Mulighederne (a), (b) og (e): $h_2(25) in #swap[${1, 2, 5}$]$.],
  blueprint: [
    Bemærk at tabelstørrelsen her er #swap[$8$], ikke 7. Ellers samme fremgang.

    + *Aflæs.* Noter optagne pladser, $m$, $h_1$ og landingspladsen.
    + *Double hashing.* $h(x,i) = (h_1(x) + i dot h_2(x)) mod m$.
    + *Prøv hver kandidat* og find dens første tomme plads.
    + *Behold* de $h_2$, der lander på den observerede plads.
  ],
  worked: [
    Bemærk $m = 8$ her. Tabellen før indsæt ($h_1 = 3$, sekvens $(3 + i dot h_2) mod 8$):

    ```
    idx:  0   1   2   3   4   5   6   7
    val: 13  56   .  32  91   .  82   .      optaget: {0,1,3,4,6}
                                              25 skal lande på plads 5
    ```

    For hvert $h_2$ (o $=$ optaget):

    ```
    h2=1:  3(o) 4(o) 5 TOM                          => 5   PASSER
    h2=2:  3(o) 5 TOM                               => 5   PASSER
    h2=3:  3(o) 6(o) (9 mod8=)1(o) 4(o) 7 TOM       => 7   nej
    h2=4:  3(o) 7 TOM                               => 7   nej
    h2=5:  3(o) (8 mod 8=)0(o) 5 TOM                => 5   PASSER
    h2=6:  3(o) (9 mod 8=)1(o) 7 TOM                => 7   nej
    h2=7:  3(o) (10 mod 8=)2 TOM                    => 2   nej
    ```

    Svar: $h_2(25) in {1, 2, 5}$ — altså (a), (b) og (e).
  ],
)

#qcard(
  tag: [Hashing: hvilke h₂-værdier passer? (double hashing)],
  source: "MCQ juni 2025, Spm. 10 (flere rigtige)",
  theory: <th-bst-double-hashing>,
  prompt: [En hashtabel $H$ af længde #swap[$7$] bruger double hashing med $h_1(x)$ og $h_2(x)$. Før indsættelse: #swap[$H = [47, 50, \_, \_, 35, 21, \_]$] (pladserne 0,1,4,5 optaget; 2,3,6 tomme). #swap[99] indsættes på plads #swap[2]. Probe-sekvens: $h(x,i) = (h_1(x) + i dot h_2(x)) mod #swap[$7$]$. Hvis #swap[$h_2(99) = 2$], hvilke værdier af $h_1(99)$ er mulige? (et eller flere svar)],
  options: (
    [$h_1(99) = 0$],
    [$h_1(99) = 1$],
    [$h_1(99) = 2$],
    [$h_1(99) = 3$],
    [$h_1(99) = 4$],
    [$h_1(99) = 5$],
    [$h_1(99) = 6$],
  ),
  answer: [Mulighederne (a), (c) og (f): $h_1(99) in #swap[${0, 2, 5}$]$.],
  blueprint: [
    Her er det $h_2$ der er fast og $h_1$ der varierer, men sekvensen er den samme. Prøv hver startværdi.

    + *Aflæs.* Noter optagne pladser, $m$, det faste $h_2$ og landingspladsen.
    + *Double hashing.* $h(x,i) = (h_1(x) + i dot h_2(x)) mod m$.
    + *Prøv hver kandidat $h_1$* og find dens første tomme plads.
    + *Behold* de $h_1$, der lander på den observerede plads.
  ],
  worked: [
    Her er $h_2 = 2$ fast, og $h_1$ varierer. Tabellen før indsæt ($m = 7$, sekvens $(h_1 + 2i) mod 7$):

    ```
    idx:  0   1   2   3   4   5   6
    val: 47  50   .   .  35  21   .      optaget: {0,1,4,5}
                                          99 skal lande på plads 2
    ```

    For hvert $h_1$ (o $=$ optaget):

    ```
    h1=0:  0(o) 2 TOM                   => 2   PASSER
    h1=1:  1(o) 3 TOM                   => 3   nej
    h1=2:  2 TOM                        => 2   PASSER
    h1=3:  3 TOM                        => 3   nej
    h1=4:  4(o) 6 TOM                   => 6   nej
    h1=5:  5(o) (7 mod 7=)0(o) 2 TOM    => 2   PASSER
    h1=6:  6 TOM                        => 6   nej
    ```

    Svar: $h_1(99) in {0, 2, 5}$ — altså (a), (c) og (f).
  ],
)

#qcard(
  tag: [Sortering: hvilke er Θ(n²) i værste fald? (sortering)],
  source: "MCQ juni 2019, Spm. 27 (worst-case sortering, går igen bredt)",
  theory: <th-bst-rbtree>,
  prompt: [Vi betragter sortering af #swap[$n$] heltal med værdier i intervallet $[0, #swap[$n^2$])$. Med TreeSort menes algoritmen, der indsætter tallene ét ad gangen i et søgetræ og derefter laver et inorder-gennemløb. Hvilke af følgende algoritmer har worst-case-køretid $Theta(n^2)$? (et eller flere svar)],
  options: (
    [CountingSort],
    [RadixSort, hvor heltallene behandles som bestående af to cifre med værdier i intervallet $[0, n)$.],
    [MergeSort],
    [TreeSort, hvor det binære søgetræ er et rød-sort træ.],
    [TreeSort, hvor det binære søgetræ er et ubalanceret søgetræ.],
    [QuickSort],
    [InsertionSort],
  ),
  answer: [Mulighederne (a), (e), (f) og (g): CountingSort, ubalanceret TreeSort, QuickSort og InsertionSort.],
  blueprint: [
    Gå hver algoritme igennem og find dens worst case. Pas på, at universets størrelse #swap[$k$] tæller med for de tællende sorteringer.

    + *Tællende sorteringer.* CountingSort er $Theta(n + k)$, så et stort univers ($k = #swap[$n^2$]$) gør den langsom. RadixSort deler tallene i cifre og kører ét CountingSort-pas per ciffer med lille basis.
    + *Sammenligningssorteringer med garanti.* MergeSort er altid $Theta(n log n)$, uanset input.
    + *TreeSort afhænger af træet.* Balanceret træ giver $n$ indsættelser à $O(log n)$. Et ubalanceret BST kan degenerere til en sti ved sorteret input.
    + *Sammenligningssorteringer uden garanti.* QuickSort og InsertionSort har $Theta(n^2)$ worst case.
    + *Saml dem, der rammer $Theta(n^2)$.*
  ],
  worked: [
    Vi sorterer $n$ heltal i intervallet $[0, n^2)$, så universet er $k = n^2$.

    - *CountingSort:* $Theta(n + k) = Theta(n + n^2) = Theta(n^2)$. Rammer.
    - *RadixSort, 2 cifre i base $n$:* to CountingSort-pas, hvert med $k = n$, altså $Theta(n)$. Rammer ikke.
    - *MergeSort:* altid $Theta(n log n)$. Rammer ikke.
    - *TreeSort, rød-sort træ:* $n$ indsættelser à $O(log n)$ plus et $O(n)$-gennemløb, altså $Theta(n log n)$. Rammer ikke.
    - *TreeSort, ubalanceret BST:* sorteret input gør træet til en sti. Indsættelse nummer $i$ går $i$ skridt ned, og $sum_(i=1)^n i = Theta(n^2)$. Rammer.
    - *QuickSort:* worst case $Theta(n^2)$. Rammer.
    - *InsertionSort:* worst case $Theta(n^2)$. Rammer.

    Svar: (a), (e), (f) og (g).
  ],
)

#qcard(
  tag: [Rød-sort træ: gyldig farvelægning? (flere rigtige) (farvelægning)],
  source: "MCQ juni 2015, Spm. 19 (flere rigtige)",
  theory: <th-bst-rb-rules>,
  prompt: [Hvilke farvelægninger af knuderne i træet gør det til et lovligt rød-sort træ? (et eller flere svar) Træet: rod #swap[$b$] med børn #swap[$a$] og #swap[$d$]; $a$ har to NIL-børn; $d$ har børn $c$ og $e$; både $c$ og $e$ har to NIL-børn.],
  options: (
    [Sorte: $b, d$; Røde: $a, c, e$],
    [Sorte: $a, b, c, e$; Rød: $d$],
    [Sorte: $a, b, d$; Røde: $c, e$],
    [Sorte: $a, c, e$; Røde: $b, d$],
    [Sorte: $a, b, c, d, e$; Røde: ingen],
  ),
  answer: [Mulighederne (b) og (c): begge opfylder alle tre rød-sorte regler.],
  blueprint: [
    Tegn træet med eksplicitte sorte NIL-blade, og tjek de tre regler på hver kandidat. En farvelægning er kun lovlig, hvis alle tre holder.

    + *List stierne.* Skriv hver rod-til-NIL-sti op.
    + *Regel 2: roden sort.* Smid enhver farvelægning med rød rod.
    + *Regel 4: ingen rød-rød.* Smid enhver med en rød knude, der har et rødt barn.
    + *Regel 5: ens sort-højde.* Tæl sorte knuder (NIL tæller som sort) på hver sti. Alle skal være ens.
  ],
  worked: [
    Træet med eksplicitte sorte NIL-blade. De tre rod-til-NIL-stier er:

    ```
    sti P1:  b - a - NIL
    sti P2:  b - d - c - NIL
    sti P3:  b - d - e - NIL
    ```

    For hver kandidat tjekker jeg de tre regler og tæller sorte knuder pr. sti (NIL tæller som 1 sort). Sort-højden skal være ens på P1, P2, P3.

    *(a) sorte $b,d$; røde $a,c,e$.* Rod $b$ sort: ok. Ingen rød-rød ($a,c,e$ har kun NIL-børn): ok.

    ```
    P1: b(B) a(R) NIL(B)            -> 2 sorte
    P2: b(B) d(B) c(R) NIL(B)       -> 3 sorte
    ```

    $2 != 3$, sort-højden bryder. Ugyldig.

    *(b) sorte $a,b,c,e$; rød $d$.* Rod sort: ok. $d$(R) har børn $c,e$ sorte: ingen rød-rød.

    ```
    P1: b(B) a(B) NIL(B)            -> 3 sorte
    P2: b(B) d(R) c(B) NIL(B)       -> 3 sorte
    P3: b(B) d(R) e(B) NIL(B)       -> 3 sorte
    ```

    Alle 3. Gyldig.

    *(c) sorte $a,b,d$; røde $c,e$.* Rod sort: ok. $c,e$(R) har kun NIL-børn: ingen rød-rød.

    ```
    P1: b(B) a(B) NIL(B)            -> 3 sorte
    P2: b(B) d(B) c(R) NIL(B)       -> 3 sorte
    P3: b(B) d(B) e(R) NIL(B)       -> 3 sorte
    ```

    Alle 3. Gyldig.

    *(d) sorte $a,c,e$; røde $b,d$.* Rod $b$ rød: bryder regel 2. Og $b$–$d$ er rød-rød. Ugyldig.

    *(e) alle sorte.*

    ```
    P1: b(B) a(B) NIL(B)            -> 3 sorte
    P2: b(B) d(B) c(B) NIL(B)       -> 4 sorte
    ```

    $3 != 4$. Ugyldig.

    Svar: (b) og (c).
  ],
)

#qcard(
  tag: [Rød-sort træ: gyldig farvelægning? (flere rigtige) (farvelægning)],
  source: "MCQ juni 2017, Spm. 19 (flere rigtige)",
  theory: <th-bst-rb-rules>,
  prompt: [For hvilke af træerne nedenfor kan knuderne farvelægges, så træet bliver et lovligt rød-sort træ? (et eller flere svar) Cirkler er indre knuder, der skal farves rød eller sort; sorte firkanter er NIL-blade.],
  options: (
    [Rod med venstre $=$ NIL-blad og højre $=$ indre knude med to NIL-børn.],
    [Zigzag-kæde: rod (venstre $=$ NIL) $->$ højre indre knude (højre $=$ NIL) $->$ venstre indre knude med to NIL-børn.],
    [Rod med to indre børn; venstre barn har to indre børn, hvert med to NIL-børn; højre barn har venstre $=$ indre (to NIL), højre $=$ NIL-blad.],
    [Rod med to indre børn; venstre $=$ (NIL, indre(to NIL)); højre $=$ (indre, NIL), hvor den indre $=$ (NIL, indre(to NIL)).],
    [Rod med to indre børn; venstre deltræ $=$ ((indre(to NIL), NIL), indre(to NIL)); højre deltræ $=$ (indre(to NIL), indre(to NIL)).],
  ),
  answer: [Mulighederne (a), (c) og (e): de kan farvelægges lovligt; (b) og (d) kan ikke (sort-højden kan ikke balanceres).],
  blueprint: [
    Et træ kan farvelægges, netop hvis *mindst én* tildeling opfylder alle tre regler. Den afgørende test er som regel sort-højde-balancen.

    + *Læs træet.* Cirkler $=$ indre knuder at farve; firkanter $=$ NIL-blade (altid sorte, tæller 1 sort hver).
    + *Krav.* Rod sort, ingen rød-rød, og ens sort-højde på hver rod-til-NIL-sti.
    + *Test balancen.* NIL-blade på vidt forskellige dybder, eller knuder med kun ét barn i kæde, bryder typisk sort-højden.
    + *Rapportér* hvert træ, der tillader mindst én lovlig farvelægning.
  ],
  worked: [
    Nøgletal pr. træ: hvor mange indre knuder ligger på den korteste og den længste rod-til-NIL-sti. På en sti med $s$ indre knuder kan antallet af *sorte* indre knuder højst være $s$ (alle sorte) og mindst $ceil(s\/2)$ (røde og sorte skiftevis, da to røde i træk er forbudt). Alle stier skal ramme samme sorttælling. Lægger man den uniforme NIL-sort til, er det ligegyldigt; det er de indre sorte, der skal stemme.

    *(a)* korteste sti 1 indre, længste 2 indre.

    ```
    sti rod-NIL:        1 indre  -> sorte i [1, 1]
    sti rod-højre-NIL:  2 indre  -> sorte i [1, 2]
    ```

    Begge kan ramme 1 sort: farv rod sort, højre rød. Gyldig.

    *(b)* zigzag, korteste sti 1 indre, længste 3 indre.

    ```
    sti rod-NIL:            1 indre  -> sorte i [1, 1]
    sti rod-r1-r2-NIL:      3 indre  -> sorte i [2, 3]
    ```

    Den korte sti kan højst give 1 sort, den lange kræver mindst 2 (ellers to røde i træk). Intervallerne $[1,1]$ og $[2,3]$ overlapper ikke. Ugyldig.

    *(c)* korteste sti 2 indre, længste 3 indre.

    ```
    sti rod-R-NIL:          2 indre  -> sorte i [1, 2]
    sti rod-L-Lbarn-NIL:    3 indre  -> sorte i [2, 3]
    ```

    Begge kan ramme 2 sorte. En konkret farvelægning: rod og begge dybde-2-knuder sorte, de yderste blade-knuder røde. Gyldig.

    *(d)* fælden ligger i højre deltræ $R$ alene. $R = (R_("inner"), "NIL")$, og $R_("inner") = ("NIL", R_("inner2"))$. Stierne *inde i* $R$:

    ```
    R-NIL:                   1 indre (R)               -> sorte i [1, 1]
    R-Rinner-Rinner2-NIL:    3 indre                   -> sorte i [2, 3]
    ```

    Allerede her overlapper $[1,1]$ og $[2,3]$ ikke, så $R$ kan ikke farves lovligt uanset resten. Ugyldig.

    *(e)* korteste sti 3 indre, længste 4 indre.

    ```
    korteste:  3 indre  -> sorte i [2, 3]
    længste:   4 indre  -> sorte i [2, 4]
    ```

    Begge kan ramme 2 (eller 3) sorte uden rød-rød-konflikt langs nogen delt sti. En lovlig farvelægning findes. Gyldig.

    Svar: (a), (c) og (e).
  ],
)

#qcard(
  tag: [Rød-sort træ: gyldig farvelægning? (flere rigtige) (farvelægning)],
  source: "MCQ juni 2023, Spm. 21 (flere rigtige)",
  theory: <th-bst-rb-rules>,
  prompt: [Hvilke delmængder af knuder gør træet til et lovligt rød-sort træ, hvis præcis den delmængde farves rød (resten sort)? (et eller flere svar) BST: rod #swap[$5$]; $5$'s børn $3$ og $7$; $3$'s børn $2$ og $4$; $7$'s børn $6$ og $9$; $2$'s venstre barn $1$; $9$'s venstre barn $8$; knuderne $4, 6, 1, 8$ har kun NIL-børn.],
  options: (
    [${1, 3, 6, 8, 9}$],
    [${1, 5, 8}$],
    [${1, 3, 7, 8}$],
    [${1, 8}$],
    [${1, 2, 4, 7, 8}$],
  ),
  answer: [Mulighederne (c) og (d): begge er lovlige.],
  blueprint: [
    Rekonstruér træet med eksplicitte sorte NIL-blade. En delmængde er lovlig, netop hvis alle tre regler holder.

    + *Rod sort.* Smid enhver delmængde, der farver roden rød.
    + *Ingen rød-rød.* Smid enhver, hvor en rød knude har et rødt barn.
    + *Ens sort-højde.* Tæl sorte (NIL $=$ sort) på hver rod-til-NIL-sti. Alle skal være ens.
    + *Behold* de delmængder, der består alle tre.
  ],
  worked: [
    Træet med dybder (NIL-blade er sorte og tæller 1):

    ```
                 5
               /   \
              3     7
             / \   / \
            2   4 6   9
           /         /
          1         8
    ```

    De seks rod-til-NIL-stier: $5"-"3"-"2"-"1"-"N$, $5"-"3"-"2"-"N$, $5"-"3"-"4"-"N$, $5"-"7"-"6"-"N$, $5"-"7"-"9"-"8"-"N$, $5"-"7"-"9"-"N$.

    *(a) ${1,3,6,8,9}$:* $9$ er rød og har rødt barn $8$. Rød-rød. Ugyldig.

    *(b) ${1,5,8}$:* roden $5$ er rød. Bryder regel 2. Ugyldig.

    *(c) ${1,3,7,8}$:* rod $5$ sort, ingen rød-rød (de røde $1,3,7,8$ har kun sorte/NIL-børn). Sort-tælling pr. sti (sorte indre $+$ NIL):

    ```
    5(B) 3(R) 2(B) 1(R) NIL   -> 3,2,N = 3
    5(B) 3(R) 2(B) NIL        -> 5,2,N = 3
    5(B) 3(R) 4(B) NIL        -> 5,4,N = 3
    5(B) 7(R) 6(B) NIL        -> 5,6,N = 3
    5(B) 7(R) 9(B) 8(R) NIL   -> 5,9,N = 3
    5(B) 7(R) 9(B) NIL        -> 5,9,N = 3
    ```

    Alle 3. Gyldig.

    *(d) ${1,8}$:* rod sort, kun $1$ og $8$ røde (begge blade, ingen rød-rød). Alle øvrige knuder sorte:

    ```
    5(B) 3(B) 2(B) 1(R) NIL   -> 5,3,2,N = 4
    5(B) 3(B) 2(B) NIL        -> 5,3,2,N = 4
    5(B) 3(B) 4(B) NIL        -> 5,3,4,N = 4
    5(B) 7(B) 6(B) NIL        -> 5,7,6,N = 4
    5(B) 7(B) 9(B) 8(R) NIL   -> 5,7,9,N = 4
    5(B) 7(B) 9(B) NIL        -> 5,7,9,N = 4
    ```

    Alle 4. Gyldig.

    *(e) ${1,2,4,7,8}$:* $2$ er rød og har rødt barn $1$. Rød-rød. Ugyldig.

    Svar: (c) og (d).
  ],
)

#qcard(
  tag: [Rød-sort træ: gyldig farvelægning? (flere rigtige) (farvelægning)],
  source: "MCQ juni 2025, Spm. 23 (flere rigtige)",
  theory: <th-bst-rb-rules>,
  prompt: [Hvilke delmængder af knuder gør træet til et lovligt rød-sort træ, når de farves rød (resten sort)? (et eller flere svar) BST: rod #swap[$5$]; $5 ->$ venstre $3$, højre $8$; $3 ->$ venstre $1$, højre $4$; $8 ->$ venstre $6$, højre $9$; $1 ->$ højre barn $2$; $6 ->$ venstre barn $7$. NIL-blade er sorte.],
  options: (
    [${2, 7}$],
    [${1, 2, 4, 7, 8}$],
    [${2, 5, 7}$],
    [${2, 3, 6, 7, 9}$],
    [${2, 3, 7, 8}$],
  ),
  answer: [Mulighederne (a) og (e): begge er lovlige.],
  blueprint: [
    Samme tre regler. Bemærk dybderne: rod, niveau 2, niveau 3, niveau 4 — sort-højden skal stemme over alle stier.

    + *Rod sort.* Smid delmængder med rød rod.
    + *Ingen rød-rød.* Smid delmængder med en rød knude, der har et rødt barn.
    + *Ens sort-højde.* Tæl sorte (NIL $=$ sort) på hver sti.
    + *Behold* dem, der består alle tre.
  ],
  worked: [
    Træet (NIL-blade er sorte, tæller 1):

    ```
                 5
               /   \
              3     8
             / \   / \
            1   4 6   9
             \   /
              2 7
    ```

    Stierne: $5"-"3"-"1"-"2"-"N$, $5"-"3"-"1"-"N$, $5"-"3"-"4"-"N$, $5"-"8"-"6"-"7"-"N$, $5"-"8"-"6"-"N$, $5"-"8"-"9"-"N$.

    *(a) ${2,7}$:* rod $5$ sort. Kun $2$ og $7$ røde — begge blade med sorte NIL-børn, ingen rød-rød. Alle øvrige knuder sorte:

    ```
    5(B) 3(B) 1(B) 2(R) NIL   -> 5,3,1,N = 4
    5(B) 3(B) 1(B) NIL        -> 5,3,1,N = 4
    5(B) 3(B) 4(B) NIL        -> 5,3,4,N = 4
    5(B) 8(B) 6(B) 7(R) NIL   -> 5,8,6,N = 4
    5(B) 8(B) 6(B) NIL        -> 5,8,6,N = 4
    5(B) 8(B) 9(B) NIL        -> 5,8,9,N = 4
    ```

    Alle 4. Gyldig.

    *(b) ${1,2,4,7,8}$:* $1$ er rød og har rødt barn $2$. Rød-rød. Ugyldig.

    *(c) ${2,5,7}$:* roden $5$ er rød. Ugyldig.

    *(d) ${2,3,6,7,9}$:* $6$ er rød og har rødt barn $7$. Rød-rød. Ugyldig.

    *(e) ${2,3,7,8}$:* rod $5$ sort. Røde $3$ (sorte børn $1,4$), $8$ (sorte børn $6,9$), plus bladene $2,7$. Ingen rød-rød:

    ```
    5(B) 3(R) 1(B) 2(R) NIL   -> 5,1,N = 3
    5(B) 3(R) 1(B) NIL        -> 5,1,N = 3
    5(B) 3(R) 4(B) NIL        -> 5,4,N = 3
    5(B) 8(R) 6(B) 7(R) NIL   -> 5,6,N = 3
    5(B) 8(R) 6(B) NIL        -> 5,6,N = 3
    5(B) 8(R) 9(B) NIL        -> 5,9,N = 3
    ```

    Alle 3. Gyldig.

    Svar: (a) og (e).
  ],
)

#qcard(
  tag: [Rød-sort træ: gyldig farvelægning? (flere rigtige) (farvelægning)],
  source: "MCQ juni 2019, Spm. 23",
  theory: <th-bst-rb-rules>,
  prompt: [På hvor mange måder kan knuderne i træet farves, så det bliver et lovligt rød-sort træ? Cirkler er indre knuder (farves rød eller sort), sorte firkanter er NIL-blade. Struktur: rod med børn #swap[$A$] og #swap[$B$]; $A ->$ børn $A_1, A_2$, hver med to NIL-børn; $B ->$ børn $B_1$ og $B_2$; $B_1$ har venstre NIL og højre indre knude $C$ (to NIL-børn); $B_2$ har venstre NIL og højre indre knude $D$; $D$ har venstre NIL og højre indre knude $E$ (to NIL-børn). Rod-til-NIL-stierne passerer 3, 4 eller 5 indre knuder.],
  options: (
    [På ingen måder.],
    [På én måde.],
    [På to måder.],
    [På tre måder.],
    [På fire måder.],
  ),
  answer: [Mulighed (a): på ingen måder.],
  blueprint: [
    En farvelægning er lovlig, netop hvis alle tre regler holder samtidig. Står stiernes længder i forvejen for skævt, kan sort-højden ikke reddes, uanset farverne.

    + *Læs træet.* Cirkler $=$ indre knuder at farve; firkanter $=$ NIL-blade (altid sorte, tæller 1 sort hver).
    + *Krav.* Rod sort, ingen rød-rød, og ens sort-højde på hver rod-til-NIL-sti.
    + *Tjek balancen.* Tæl indre knuder på den korteste og den længste sti. Spænder de over flere niveauer, må de korte stier hente ekstra sorte et sted fra — og det kan røde knuder ikke give.
    + *Konkludér.* Findes der ingen tildeling med ens sort-højde og ingen rød-rød, er svaret "på ingen måder".
  ],
  worked: [
    Indre knuder: rod, $A$, $B$, $A_1$, $A_2$, $B_1$, $B_2$, $C$, $D$, $E$ (10 i alt). NIL-bladene er sorte og tæller 1.

    Det hurtige modbevis ligger i den højre kæde $B_2 - D - E$. Hver af knuderne $B_2$ og $D$ har et NIL-barn på den ene side og en længere gren på den anden:

    ```
    B2 = (NIL, D),  D = (NIL, E),  E = (NIL, NIL)
    ```

    Stierne *inde i* deltræet $B_2$ (talt i indre knuder):

    ```
    B2 - NIL:           1 indre (B2)      -> sorte i [1, 1]
    B2 - D - NIL:       2 indre           -> sorte i [1, 2]
    B2 - D - E - NIL:   3 indre           -> sorte i [2, 3]
    ```

    Den korteste sti ($B_2$-NIL) kan højst give 1 sort indre knude; den længste ($B_2$-$D$-$E$-NIL) kræver mindst 2 (ellers to røde i træk). Intervallerne $[1,1]$ og $[2,3]$ overlapper ikke, så deltræet $B_2$ kan ikke få ens sort-højde — uanset hvad resten af træet farves.

    Da $B_2$ alene er ufarvbart, er hele træet det også. Gennemsøger man alle $2^(10)$ farvelægninger med rod sort, ingen rød-rød og fælles sort-højde, overlever ingen.

    Svar: mulighed (a), på ingen måder.
  ],
)

#qcard(
  tag: [Rød-sort træ: indsæt og ret op (rød-sort træ)],
  source: "MCQ juni 2015, Spm. 20",
  theory: <th-bst-rb-insert>,
  prompt: [I det rød-sorte træ indsættes #swap[$11$] med lærebogens algoritme. Hvordan ser træet ud bagefter? Starttræ: rod #swap[$5$] (sort); $5 ->$ venstre $3$ (sort), højre $7$ (rød); $3 ->$ børn $2$ (rød), $4$ (rød); $7 ->$ børn $6$ (sort), $9$ (sort); $9 ->$ børn $8$ (rød), $10$ (rød).],
  options: (
    [$11$ indsat som rødt højrebarn af $10$; ingen omfarvning/rotation (rød-rød ikke rettet).],
    [Forkert omfarvnings-/rotationskonfiguration: $3,4,6,7,8,10$ sorte, $9$ rød, $11$ rød under $10$.],
    [Rod $7$ (sort); $7 ->$ venstre $5$ (rød), højre $9$ (rød); $5 ->$ venstre $3$ (sort) [med $2,4$ røde], højre $6$ (sort); $9 ->$ venstre $8$ (sort), højre $10$ (sort) med rødt højrebarn $11$.],
    [Forkert rotation: rod $5$; $5 ->$ højre $9$; $9 ->$ venstre $7$ med børn $6,8$, højre $10$ med $11$; venstre side $3,2,4$.],
  ),
  answer: [Mulighed (c).],
  blueprint: [
    Indsæt som rødt blad, og ret op opefter. Vælg rette tilfælde efter onklens farve, og tving roden sort til sidst.

    + *BST-indsæt* nøglen som et rødt blad.
    + *Mens forælderen er rød*, kig på onklen.
    + *Onkel rød:* farv forælder og onkel sorte, bedsteforælder rød, ryk $z$ op til bedsteforælderen, gentag.
    + *Onkel sort/NIL:* rotation. Ret først knækket ud (inderside $->$ rotér forælder), farv så forælder sort og bedsteforælder rød, og rotér bedsteforælderen.
    + *Til sidst:* tving roden sort, og match resultatet.
  ],
  worked: [
    Notation: knude(farve), B $=$ sort, R $=$ rød. Starttræet:

    ```
                5(B)
              /      \
           3(B)      7(R)
          /   \      /   \
        2(R)  4(R) 6(B)  9(B)
                        /   \
                      8(R)  10(R)
    ```

    *Trin 1 — BST-indsæt $11$ som rødt blad.* Sti: $11 > 5 ->$ højre, $11 > 7 ->$ højre, $11 > 9 ->$ højre, $11 > 10 ->$ højre. $11$ bliver rødt højrebarn af $10$:

    ```
                      9(B)
                     /   \
                   8(R)  10(R)
                            \
                           11(R)     <- ny knude z, rød-rød med 10
    ```

    *Trin 2 — z = 11, forælder $10$(R): rød-rød.* Bedsteforælder $9$(B), onkel $= 8$(R) er rød. Tilfælde "onkel rød": farv forælder $10$ og onkel $8$ sorte, bedsteforælder $9$ rød, flyt $z$ op til $9$:

    ```
                      9(R)            <- z rykket hertil
                     /   \
                   8(B)  10(B)
                            \
                           11(R)
    ```

    *Trin 3 — z = 9(R), forælder $7$(R): ny rød-rød.* Bedsteforælder $5$(B), onkel $= 3$(B) er sort. $9$ er højrebarn af $7$, og $7$ er højrebarn af $5$: lige højre-højre-linje (yderside). Farv $7$ sort, $5$ rød, og venstrerotér om $5$. $7$ stiger op; $5$ bliver $7$'s venstrebarn og overtager $7$'s gamle venstre barn $6$ som sit nye højrebarn:

    ```
                7(B)
              /      \
           5(R)      9(R)
          /   \      /   \
        3(B)  6(B) 8(B)  10(B)
        / \                  \
      2(R)4(R)              11(R)
    ```

    *Trin 4 — tving roden sort.* $7$ er allerede sort. Færdig. Hver rod-til-NIL-sti møder nu to sorte indre knuder; sort-højden passer.

    Det er mulighed (c).
  ],
)

#qcard(
  tag: [Rød-sort træ: indsæt og ret op (rød-sort træ)],
  source: "MCQ juni 2021, Spm. 23",
  theory: <th-bst-rb-insert>,
  prompt: [Indsæt nøglen #swap[$21$] i det rød-sorte træ (dobbeltcirkler $=$ røde). Starttræ: rod #swap[$24$] (sort); venstre $18$ (rød) med venstre $5$ (sort, med røde børn $2$ og $7$) og højre $20$ (sort, med rødt højrebarn $23$); rodens højre $26$ (sort, med rødt højrebarn $27$). Hvilket træ er resultatet?],
  options: (
    [Naiv BST-indsæt: $20$(sort) beholder rødt højrebarn $23$, og $23$ får nyt rødt venstrebarn $21$. Rød-rød ikke rettet.],
    [Hele træet omstruktureret med $21$ som ny rod, $5$(rød) og $26$(rød) som børn.],
    [Under $18$: $21$ er sort og sidder, hvor $20$ var, med røde børn $20$ og $23$. Resten uændret.],
    [Under $18$: $20$ forbliver sort, dens røde højrebarn $23$ får et nyt rødt venstrebarn $21$ (kun-omfarvning, ingen rotation).],
  ),
  answer: [Mulighed (c).],
  blueprint: [
    BST-indsæt som rød, ret så op. Er forælderen rød og onklen sort/NIL, er det et rotationstilfælde — ikke kun omfarvning.

    + *BST-indsæt* nøglen som rød.
    + *Tjek forælder.* Sort $->$ færdig. Rød $->$ kig på onklen.
    + *Onkel sort/NIL: trinode-omstrukturering.* Tag bedsteforælder, forælder, barn; medianen rykker op og bliver sort, de to andre bliver dens røde børn.
    + *Match* slutkonfigurationen.
  ],
  worked: [
    Notation: knude(farve). Starttræet (kun det relevante venstre deltræ vist i detalje):

    ```
                  24(B)
                /       \
            18(R)       26(B)
           /     \          \
         5(B)    20(B)      27(R)
        /  \        \
      2(R) 7(R)    23(R)
    ```

    *Trin 1 — BST-indsæt $21$ som rødt blad.* Sti: $21 < 24 ->$ venstre, $21 > 18 ->$ højre, $21 > 20 ->$ højre, $21 < 23 ->$ venstre. $21$ bliver rødt venstrebarn af $23$:

    ```
            20(B)
               \
              23(R)
              /
            21(R)        <- ny knude z, rød-rød med 23
    ```

    *Trin 2 — z = 21(R), forælder $23$(R): rød-rød.* Bedsteforælder $20$(B), onkel $= 20$'s venstre $=$ NIL (sort). $23$ er højrebarn af $20$, og $21$ er venstrebarn af $23$: højre-venstre-knæk (zigzag, inderside).

    *Trin 3 — rotation.* Knækket rettes med en trinode-omstrukturering af ${20, 21, 23}$. Medianen $21$ rykker op på $20$'s plads, $20$ bliver dens venstrebarn, $23$ dens højrebarn. Farv $21$ sort, $20$ og $23$ røde:

    ```
              21(B)
              /   \
           20(R)  23(R)
    ```

    Hængt tilbage under $18$'s højre-link, resten af træet urørt. Roden $24$ er stadig sort.

    Svar: mulighed (c).
  ],
)

#qcard(
  tag: [Rød-sort træ: indsæt og ret op (rød-sort træ)],
  source: "MCQ juni 2023, Spm. 22",
  theory: <th-bst-rb-insert>,
  prompt: [Indsæt nøglen #swap[$25$] i det rød-sorte træ (dobbeltcirkler $=$ røde). Starttræ: rod #swap[$18$] (sort); venstre $9$ (rød), $9 ->$ venstre $7$ (sort) med venstre rødt $4$, $9 ->$ højre $15$ (sort) med røde børn $11$ og $16$; rodens højre $21$ (sort), $21 ->$ venstre NIL, højre $24$ (rød). Hvilket træ er resultatet?],
  options: (
    [Højre $21$(sort), $21 ->$ højre $24$(rød), $24 ->$ højre $25$(rød); rød-rød $24 "-" 25$ ikke rettet.],
    [Fuldt omstruktureret træ med rod $16$.],
    [Højre barn $24$(sort) med røde børn $21$ og $25$; venstre deltræ uændret.],
    [Højre $21$(sort), $21 ->$ højre $24$(rød), $24 ->$ højre $25$(rød); rød-rød ikke rettet.],
  ),
  answer: [Mulighed (c).],
  blueprint: [
    Indsæt som rødt blad. Sort forælder $->$ færdig; rød forælder $->$ kig på onklen. Sort/NIL onkel betyder rotation: lige linje (LL/RR) er én rotation, knæk (LR/RL) to.

    + *BST-indsæt* den nye nøgle som rødt blad.
    + *Forælder sort?* Færdig.
    + *Forælder rød, onkel rød?* Omfarv og ryk op.
    + *Forælder rød, onkel sort/NIL?* Rotér. Den nye deltræs-rod bliver sort, dens børn røde. Hold roden sort.
  ],
  worked: [
    Notation: knude(farve). Starttræet:

    ```
                  18(B)
                /       \
             9(R)       21(B)
            /    \          \
         7(B)    15(B)      24(R)
         /       /   \
       4(R)   11(R) 16(R)
    ```

    *Trin 1 — BST-indsæt $25$ som rødt blad.* Sti: $25 > 18 ->$ højre, $25 > 21 ->$ højre, $25 > 24 ->$ højre. $25$ bliver rødt højrebarn af $24$:

    ```
            21(B)
               \
              24(R)
                 \
                25(R)      <- ny knude z, rød-rød med 24
    ```

    *Trin 2 — z = 25(R), forælder $24$(R): rød-rød.* Bedsteforælder $21$(B), onkel $= 21$'s venstre $=$ NIL (sort). $25$ er højrebarn af $24$, og $24$ er højrebarn af $21$: lige højre-højre-linje (yderside).

    *Trin 3 — venstrerotér om $21$.* $24$ stiger op under $18$'s højre-link; $21$ bliver $24$'s venstrebarn, $25$ forbliver højrebarn. Farv $24$ sort, $21$ rød, $25$ rød:

    ```
              24(B)
              /   \
           21(R)  25(R)
    ```

    Roden $18$ er stadig sort, sort-højden bevaret.

    Svar: mulighed (c).
  ],
)

#qcard(
  tag: [Rød-sort træ: indsæt og ret op (rød-sort træ)],
  source: "MCQ juni 2025, Spm. 24",
  theory: <th-bst-rb-insert>,
  prompt: [Indsæt nøglen #swap[$10$] i det rød-sorte træ (dobbeltcirkler $=$ røde). Starttræ: rod #swap[$22$] (sort); venstre $17$ (rød); $17 ->$ venstre $8$ (sort) med rødt højrebarn $12$; $17 ->$ højre $20$ (sort) med røde børn $19$ (venstre), $21$ (højre); rodens højre $25$ (sort) med rødt højrebarn $26$. Hvilket træ er resultatet?],
  options: (
    [Ny rod $20$: $20$(B) med røde børn $17$ og $25$; $17$ har børn $10$(B) [med røde $8, 12$] og $19$; $25$ har børn $22$ og $26$.],
    [Samme form som start, men $10$ indsat som rødt venstrebarn af $12$, ingen rebalancering.],
    [Samme som start, men $10$ indsat som sort venstrebarn af rødt $12$ under $8$, ingen rotation.],
    [Under $17$'s venstre erstatter knude $10$ (sort) $8$'s plads, med røde børn $8$ (venstre) og $12$ (højre), begge blade; højre side ($20,19,21$) og $25,26,22$ uændret.],
  ),
  answer: [Mulighed (d).],
  blueprint: [
    Indsæt som rødt blad, og ret op. Sort/NIL onkel $->$ rotation: LL/RR er enkelt, LR/RL er dobbelt. Den nye deltræs-rod bliver sort med røde børn.

    + *BST-indsæt* nøglen som rødt blad.
    + *Forælder sort?* Færdig.
    + *Forælder rød, onkel rød?* Omfarv og ryk op.
    + *Forælder rød, onkel sort/NIL?* Rotér efter linjens form (lige eller knæk).
    + *Hold roden sort.*
  ],
  worked: [
    Notation: knude(farve). Starttræet:

    ```
                  22(B)
                /       \
             17(R)      25(B)
            /    \          \
         8(B)    20(B)      26(R)
            \    /   \
          12(R)19(R)21(R)
    ```

    *Trin 1 — BST-indsæt $10$ som rødt blad.* Sti: $10 < 22 ->$ venstre, $10 < 17 ->$ venstre, $10 > 8 ->$ højre til $12$, $10 < 12 ->$ venstre. $10$ bliver rødt venstrebarn af $12$:

    ```
          8(B)
             \
            12(R)
            /
          10(R)        <- ny knude z, rød-rød med 12
    ```

    *Trin 2 — z = 10(R), forælder $12$(R): rød-rød.* Bedsteforælder $8$(B), onkel $= 8$'s venstre $=$ NIL (sort). $12$ er højrebarn af $8$, og $10$ er venstrebarn af $12$: højre-venstre-knæk (zigzag, inderside).

    *Trin 3 — dobbeltrotation.* Højrerotér først om $12$, så de tre kommer på lige linje, derefter venstrerotér om $8$. $10$ bliver deltræs-rod med $8$ som venstrebarn og $12$ som højrebarn. Farv $10$ sort, $8$ og $12$ røde (begge nu blade):

    ```
              10(B)
              /   \
            8(R)  12(R)
    ```

    Højre side ($20, 19, 21$) og $25, 26, 22$ urørt; roden $22$ stadig sort.

    Svar: mulighed (d).
  ],
)
