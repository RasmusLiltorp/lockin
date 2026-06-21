#import "../lib.typ": *

== Greedy-algoritmer

En greedy-algoritme (greedy algorithm) bygger løsningen op ét skridt ad gangen og tager hver gang det, der ser bedst ud lige nu, uden at fortryde. Hurtigt, men kun korrekt hvis det lokale valg beviseligt giver den globalt bedste løsning.

Til eksamen kommer det to steder fra. Huffman-kodning (Huffman coding) (næsten hvert år): byg et træ ud fra symbolfrekvenser og aflæs en kodeordslængde eller det samlede antal bit. Og argumentet for, *hvorfor* et greedy-valg er optimalt — typisk et ombytningsargument (exchange argument).

=== Sådan løser du den <th-greedy-huffman>

Huffman giver hyppige symboler korte koder og sjældne symboler lange. Et symbols kodeordslængde er dybden af dets blad: jo dybere, jo flere bit.

#recipe(
  title: "Byg Huffman-træet",
  [Skriv symbolerne op med deres frekvenser. Der er #swap[$n$] af dem.],
  [Læg alle bladene i en min-prioritetskø (min-priority queue) med frekvensen som nøgle.],
  [Tag de to mindste vægte $x$ og $y$ ud, lav en knude med vægt $x + y$, og læg den tilbage. Notér $x + y$; det er den interne knudes vægt.],
  [Gentag til der er ét træ tilbage — #swap[$n - 1$] merges.],
  [Kodeordslængden for et symbol er dybden af dets blad.],
)

Tanken er, at sjældne tegn skal langt ned i træet og dermed have lange koder, mens hyppige tegn skal sidde tæt på roden med korte koder. Du slår altid de to mindste vægte sammen, igen og igen, til der kun er én knude tilbage. Den er roden.

Koderne aflæser du bagefter ved at gå fra roden ned til hvert tegn. Venstre kant tæller som 0 og højre som 1, og antallet af kanter ned til tegnet er antallet af bit i dets kode, altså bladets dybde.

Tag puljen $a:500$, $b:400$, $c:300$, $d:250$, $e:200$, $f:150$. De fem merges bliver:

#table(
  columns: (auto, auto, auto),
  inset: 7pt,
  align: (center, left, left),
  stroke: 0.4pt + hair,
  table.header([*Trin*], [*To mindste*], [*Ny knude*]),
  [1], [$f:150 + e:200$], [$"ef" = 350$],
  [2], [$d:250 + c:300$], [$"cd" = 550$],
  [3], [$"ef":350 + b:400$], [$"efb" = 750$],
  [4], [$a:500 + "cd":550$], [$"acd" = 1050$],
  [5], [$"efb":750 + "acd":1050$], [$"rod" = 1800$],
)

Det giver træet:

```
rod
├─ efb
│  ├─ ef
│  │  ├─ f
│  │  └─ e
│  └─ b
└─ acd
   ├─ a
   └─ cd
      ├─ c
      └─ d
```

Vil du fx have kodelængden for $c$, tæller du kanterne fra roden: $"rod" -> "acd" -> "cd" -> c$, altså 3 kanter, så $c$ fylder 3 bit.

For et symbol $s$ med frekvens $"freq"(s)$ og bladdybde $"depth"(s)$ er det samlede antal bit:

#eq[$ sum_s "freq"(s) dot "depth"(s) $]

Den sum er lig summen af alle interne knuders vægte, du skrev op undervejs:

#eq[$ sum_s "freq"(s) dot "depth"(s) = sum_("interne knuder") "vægt" $]

#note(title: [Interne vægte])[Genvejen via interne vægte er hurtigst: læg blot de noterede merge-summer sammen. For o:150, p:100, q:25, r:125, s:200, t:50, u:75 bliver de interne vægte $75, 150, 225, 300, 425, 725$, og $75+150+225+300+425+725 = 1900$ bit. Slip for at holde styr på dybder.]

#trap(title: [Flere gyldige træer])[Ved samme vægt kan begge træer vælges først, og venstre/højre er frit, så der findes flere gyldige Huffman-træer. Men dybder og pris er ens uanset valget — svar trygt på dem. Kun "tegn træet" har flere rigtige svar.]

#metadata(none) <th-greedy-producerbar>
#trap(title: [Optimal vs. producerbar])[Optimal betyder ikke, at Huffman kan bygge det. Huffman merger altid de to aktuelt mindste vægte, så et producerbart træ må have interne vægte, der passer med den tvungne merge-rækkefølge. To optimale træer kan have hvert sit sæt interne vægte; kun dem der matcher Huffmans merges er gyldige.]

Aktivitetsudvælgelse (activity selection) er det andet klassiske greedy-problem: du har aktiviteter med start- og sluttider og vil have flest mulige uden overlap.

#recipe(
  title: "Aktivitetsudvælgelse",
  [Sortér de #swap[$n$] aktiviteter efter voksende sluttidspunkt.],
  [Gå dem igennem og vælg en aktivitet hvis den ikke overlapper den senest valgte; ellers spring den over.],
  [Resultatet er en størst mulig mængde uden overlap.],
)

Køretiden er domineret af sorteringen:

#eq[$ O(n log n) $]

#note(title: [Korrekt greedy-valg])[De andre greedy-valg fejler: korteste aktivitet, færrest overlap og tidligste start har alle modeksempler. Kun tidligste sluttidspunkt er optimalt. Beviset er en invariant — "en optimal løsning indeholder de hidtidige valg" — lukket med et ombytningsargument.]

#trap(title: [0-1-rygsæk])[Greedy efter værditæthed (value density) løser fractional rygsæk (knapsack) optimalt, men fejler for 0-1. Kapacitet 50, genstande (vægt 10, \$60), (vægt 20, \$100), (vægt 30, \$120): tæthed tager de to første og får \$160, men optimum er de to sidste med \$220. 0-1-rygsæk kræver dynamisk programmering.]

#metadata(none) <th-greedy-exchange>
Skal du *bevise* greedy optimal, brug et ombytningsargument: tag en vilkårlig optimal løsning OPT og vis, at du kan bytte ét element i OPT ud med greedy-valget uden at gøre OPT værre eller ugyldig. Gentaget bliver OPT til greedy-løsningen, så greedy er også optimal.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Huffman: kodeordslængde for et symbol (kodeordslængde)],
  source: "MCQ juni 2025, Spm. 13 (samme skabelon juni 2019/2021/2023)",
  theory: <th-greedy-huffman>,
  prompt: [En fil indeholder tegn med hyppigheder: o=#swap[$150$], p=#swap[$100$], q=#swap[$25$], r=#swap[$125$], s=#swap[$200$], t=#swap[$50$], u=#swap[$75$]. Byg et Huffman-træ. Hvor mange bit er der i kodeordet for #swap[$q$]?],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [(d) $4$.],
  blueprint: [
    Byg træet og tæl skridtene ned til bladet.

    + *Sortér.* Skriv symbolerne op med frekvens og stil dem efter #swap[voksende frekvens].
    + *Merge.* Tag de to mindste vægte, lav en knude med summen, og læg den tilbage i køen.
    + *Gentag.* Bliv ved til der er ét træ. Hold øje med hvilke merges #swap[dit symbol] ender under.
    + *Aflæs.* Kodeordslængden er bladets dybde, altså antallet af merges symbolet sidder under.
  ],
  worked: [
    Læg alle blade i køen sorteret efter voksende frekvens. Hvert greedy-skridt tager de to mindste vægte, slår dem sammen, og lægger den nye knude tilbage i køen. Køen vises som indhold efter hvert merge:

    ```
    Start: [ q:25, t:50, u:75, p:100, r:125, o:150, s:200 ]

    m1: to mindste q:25 + t:50 = 75 (qt)
        kø: [ u:75, (qt):75, p:100, r:125, o:150, s:200 ]
    m2: to mindste u:75 + (qt):75 = 150 (uqt)
        kø: [ p:100, r:125, (uqt):150, o:150, s:200 ]
    m3: to mindste p:100 + r:125 = 225 (pr)
        kø: [ (uqt):150, o:150, s:200, (pr):225 ]
    m4: to mindste (uqt):150 + o:150 = 300 (uqto)
        kø: [ s:200, (pr):225, (uqto):300 ]
    m5: to mindste s:200 + (pr):225 = 425 (spr)
        kø: [ (uqto):300, (spr):425 ]
    m6: to mindste (uqto):300 + (spr):425 = 725 (rod)
        kø: [ (rod):725 ]
    ```

    $q$ blev slugt i m1 (under $q t$), den knude i m2 (under $u q t$), den i m4 (under $u q t o$), og den i m6 (roden). Det er fire merges over bladet $q$, altså dybde 4.

    Svar: 4 bit.
  ],
)

#qcard(
  tag: [Huffman: samlet antal bit (interne vægte)],
  source: "MCQ juni 2025, Spm. 14",
  theory: <th-greedy-huffman>,
  prompt: [Et Huffman-træ for en fil med hyppigheder o=#swap[$150$], p=#swap[$100$], q=#swap[$25$], r=#swap[$125$], s=#swap[$200$], t=#swap[$50$], u=#swap[$75$] (i alt #swap[$725$] symboler). Hvor mange bit fylder de 725 symboler tilsammen Huffman-kodet?],
  options: ([$1800$], [$1825$], [$1900$], [$1925$], [$2000$], [$2075$], [$2100$]),
  answer: [(c) $1900$.],
  blueprint: [
    Byg træet og læg de interne vægte sammen.

    + *Sortér* symbolerne efter #swap[frekvens].
    + *Merge* de to mindste igen og igen, og skriv hver merge-sum op.
    + *Læg sammen.* Summen af alle merge-summerne er det samlede antal bit.
    + *Tjek* eventuelt med $sum "freq" dot "depth"$ hvis du vil være sikker.
  ],
  worked: [
    Samme træ som forrige spørgsmål. Kør Huffman fra den sorterede kø og notér vægten af hver intern knude undervejs:

    ```
    Start: [ q:25, t:50, u:75, p:100, r:125, o:150, s:200 ]

    m1: q:25 + t:50   = 75    kø: [ u:75, 75, p:100, r:125, o:150, s:200 ]
    m2: u:75 + 75      = 150   kø: [ p:100, r:125, 150, o:150, s:200 ]
    m3: p:100 + r:125  = 225   kø: [ 150, o:150, s:200, 225 ]
    m4: 150 + o:150    = 300   kø: [ s:200, 225, 300 ]
    m5: s:200 + 225    = 425   kø: [ 300, 425 ]
    m6: 300 + 425      = 725   kø: [ 725 ]  (rod)
    ```

    De interne vægte er $75, 150, 225, 300, 425, 725$. Det samlede antal bit er deres sum:

    #eq[$ 75+150+225+300+425+725 = 1900 $]

    Kontrol via $sum "freq" dot "depth"$ med dybderne fra træet ($o,s$ på dybde 2, $u,p,r$ på dybde 3, $q,t$ på dybde 4):

    #eq[$ 150 dot 2 + 200 dot 2 + 100 dot 3 + 125 dot 3 + 75 dot 3 + 25 dot 4 + 50 dot 4 = 1900 $]

    Svar: 1900 bit.
  ],
)

#qcard(
  tag: [Huffman: samlet antal bit (interne vægte)],
  source: "MCQ juni 2017, Spm. 18",
  theory: <th-greedy-huffman>,
  prompt: [En fil indeholder tegn med hyppigheder: a=#swap[$100$], b=#swap[$200$], c=#swap[$300$], d=#swap[$400$], e=#swap[$500$], f=#swap[$600$], g=#swap[$700$] (i alt #swap[$2800$] tegn). Byg et Huffman-træ. Hvor mange bit fylder den kodede fil i alt?],
  options: ([$7300$], [$7400$], [$7500$], [$7600$], [$8100$], [$8300$], [$8500$]),
  answer: [Mulighed (b): $7400$.],
  blueprint: [
    Byg træet og læg de interne vægte sammen.

    + *Sortér* symbolerne efter #swap[frekvens].
    + *Merge* de to mindste igen og igen, og skriv hver merge-sum op.
    + *Læg sammen.* Summen af alle merge-summerne er det samlede antal bit.
  ],
  worked: [
    Sortér bladene efter voksende frekvens og kør Huffman. Hvert skridt tager de to mindste vægte; køen vises efter hvert merge:

    ```
    Start: [ a:100, b:200, c:300, d:400, e:500, f:600, g:700 ]

    m1: a:100 + b:200 = 300   kø: [ 300, c:300, d:400, e:500, f:600, g:700 ]
    m2: 300 + c:300   = 600   kø: [ d:400, e:500, 600, f:600, g:700 ]
    m3: d:400 + e:500 = 900   kø: [ 600, f:600, g:700, 900 ]
    m4: 600 + f:600   = 1200  kø: [ g:700, 900, 1200 ]
    m5: g:700 + 900   = 1600  kø: [ 1200, 1600 ]
    m6: 1200 + 1600   = 2800  kø: [ 2800 ]  (rod)
    ```

    De interne vægte er $300, 600, 900, 1200, 1600, 2800$. Summen er det samlede antal bit:

    #eq[$ 300+600+900+1200+1600+2800 = 7400 $]

    Svar: 7400 bit.
  ],
)

#qcard(
  tag: [Huffman: samlet antal bit (interne vægte)],
  source: "MCQ juni 2021, Spm. 13",
  theory: <th-greedy-huffman>,
  prompt: [Et Huffman-træ for en fil med hyppigheder a=#swap[$200$], b=#swap[$250$], c=#swap[$100$], d=#swap[$350$], e=#swap[$400$] (i alt #swap[$1300$] tegn). Hvor mange bit fylder de 1300 tegn Huffman-kodet?],
  options: ([$1350$], [$2550$], [$2700$], [$2900$], [$3050$], [$3250$]),
  answer: [Mulighed (d): $2900$.],
  blueprint: [
    Byg træet og læg de interne vægte sammen.

    + *Sortér* symbolerne efter #swap[frekvens].
    + *Merge* de to mindste igen og igen, og skriv hver merge-sum op.
    + *Læg sammen.* Summen af alle merge-summerne er det samlede antal bit.
  ],
  worked: [
    Sortér bladene efter voksende frekvens og kør Huffman. Hvert skridt tager de to mindste vægte; køen vises efter hvert merge:

    ```
    Start: [ c:100, a:200, b:250, d:350, e:400 ]

    m1: to mindste c:100 + a:200 = 300
        kø: [ b:250, (ca):300, d:350, e:400 ]
    m2: to mindste b:250 + (ca):300 = 550   (300 < d:350)
        kø: [ d:350, e:400, (bca):550 ]
    m3: to mindste d:350 + e:400 = 750
        kø: [ (bca):550, (de):750 ]
    m4: to mindste 550 + 750 = 1300
        kø: [ (rod):1300 ]
    ```

    De interne vægte er $300, 550, 750, 1300$. Summen er det samlede antal bit:

    #eq[$ 300+550+750+1300 = 2900 $]

    Svar: 2900 bit.
  ],
)

#qcard(
  tag: [Huffman: samlet antal bit (interne vægte)],
  source: "MCQ juni 2023, Spm. 13",
  theory: <th-greedy-huffman>,
  prompt: [Et Huffman-træ for en fil med hyppigheder b=#swap[$90$], c=#swap[$15$], d=#swap[$40$], f=#swap[$30$], g=#swap[$125$], h=#swap[$35$] (i alt #swap[$335$] tegn). Hvor mange bit fylder de 335 tegn Huffman-kodet?],
  options: ([$770$], [$775$], [$785$], [$790$], [$795$], [$820$], [$1060$]),
  answer: [Mulighed (c): $785$.],
  blueprint: [
    Byg træet og læg de interne vægte sammen.

    + *Sortér* symbolerne efter #swap[frekvens].
    + *Merge* de to mindste igen og igen, og skriv hver merge-sum op.
    + *Læg sammen.* Summen af alle merge-summerne er det samlede antal bit.
  ],
  worked: [
    Sortér bladene efter voksende frekvens og kør Huffman. Hvert skridt tager de to mindste vægte; køen vises efter hvert merge:

    ```
    Start: [ c:15, f:30, h:35, d:40, b:90, g:125 ]

    m1: c:15 + f:30   = 45    kø: [ h:35, d:40, 45, b:90, g:125 ]
    m2: h:35 + d:40   = 75    kø: [ 45, 75, b:90, g:125 ]
    m3: 45 + 75       = 120   kø: [ b:90, 120, g:125 ]
    m4: b:90 + 120    = 210   kø: [ g:125, 210 ]
    m5: g:125 + 210   = 335   kø: [ 335 ]  (rod)
    ```

    De interne vægte er $45, 75, 120, 210, 335$. Summen er det samlede antal bit:

    #eq[$ 45+75+120+210+335 = 785 $]

    Svar: 785 bit.
  ],
)

#qcard(
  tag: [Huffman: kodeordslængde for et symbol (kodeordslængde)],
  source: "MCQ juni 2021, Spm. 12",
  theory: <th-greedy-huffman>,
  prompt: [En fil indeholder tegnene med hyppigheder: a=#swap[$200$], b=#swap[$250$], c=#swap[$100$], d=#swap[$350$], e=#swap[$400$]. Byg et Huffman-træ. Hvor mange bit er der i kodeordet for #swap[$d$]?],
  options: ([$1$], [$2$], [$3$], [$4$]),
  answer: [(b) $2$.],
  blueprint: [
    Samme metode: byg træet og tæl merges ned til bladet.

    + *Sortér* symbolerne efter #swap[voksende frekvens].
    + *Merge* de to mindste, læg knuden tilbage, gentag til ét træ.
    + *Følg* #swap[dit symbol] ned gennem træet og tæl, hvor mange knuder det ligger under.
    + *Aflæs* dybden som kodeordslængden.
  ],
  worked: [
    Sortér bladene efter voksende frekvens og kør Huffman. Hvert skridt tager de to mindste vægte; køen vises efter hvert merge:

    ```
    Start: [ c:100, a:200, b:250, d:350, e:400 ]

    m1: c:100 + a:200 = 300   kø: [ b:250, 300, d:350, e:400 ]
    m2: b:250 + 300   = 550   kø: [ d:350, e:400, 550 ]
    m3: d:350 + e:400 = 750   kø: [ 550, 750 ]
    m4: 550 + 750     = 1300  kø: [ 1300 ]  (rod)
    ```

    Bladet $d$ blev slugt i m3 (under $d e$), og den knude blev roden i m4. Det er to merges over $d$, så dybde 2.

    Svar: 2 bit.
  ],
)

#qcard(
  tag: [Huffman: kodeordslængde for et symbol (kodeordslængde)],
  source: "MCQ juni 2019, Spm. 21",
  theory: <th-greedy-huffman>,
  prompt: [En fil indeholder tegn med hyppigheder: a=#swap[$500$], b=#swap[$400$], c=#swap[$300$], d=#swap[$250$], e=#swap[$200$], f=#swap[$150$]. Byg et Huffman-træ. Hvor mange bit er der i kodeordet for #swap[$c$]?],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$]),
  answer: [Mulighed (c): $3$.],
  blueprint: [
    Samme metode: byg træet og tæl merges ned til bladet.

    + *Sortér* symbolerne efter #swap[voksende frekvens].
    + *Merge* de to mindste, læg knuden tilbage, gentag til ét træ.
    + *Følg* #swap[dit symbol] ned gennem træet og tæl, hvor mange knuder det sidder under.
    + *Aflæs* dybden som kodeordslængden.
  ],
  worked: [
    Sortér bladene efter voksende frekvens og kør Huffman. Hvert skridt tager de to mindste vægte; køen vises efter hvert merge:

    ```
    Start: [ f:150, e:200, d:250, c:300, b:400, a:500 ]

    m1: f:150 + e:200 = 350   kø: [ d:250, c:300, 350, b:400, a:500 ]
    m2: d:250 + c:300 = 550   kø: [ 350, b:400, a:500, 550 ]
    m3: 350 + b:400   = 750   kø: [ a:500, 550, 750 ]
    m4: a:500 + 550   = 1050  kø: [ 750, 1050 ]
    m5: 750 + 1050    = 1800  kø: [ 1800 ]  (rod)
    ```

    $c$ blev slugt i m2 (under $d c$, vægt 550), den knude i m4 (under $a + 550$, vægt 1050), og den i m5 (roden). Det er tre merges over bladet $c$, så dybde 3.

    Svar: 3 bit.
  ],
)

#qcard(
  tag: [Huffman: kodeordslængde for et symbol (kodeordslængde)],
  source: "MCQ juni 2023, Spm. 12",
  theory: <th-greedy-huffman>,
  prompt: [En fil indeholder tegn med hyppigheder: b=#swap[$90$], c=#swap[$15$], d=#swap[$40$], f=#swap[$30$], g=#swap[$125$], h=#swap[$35$]. Byg et Huffman-træ. Hvor mange bit er der i kodeordet for #swap[$d$]?],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$]),
  answer: [Mulighed (d): $4$.],
  blueprint: [
    Samme metode: byg træet og tæl merges ned til bladet.

    + *Sortér* symbolerne efter #swap[voksende frekvens].
    + *Merge* de to mindste, læg knuden tilbage, gentag til ét træ.
    + *Følg* #swap[dit symbol] ned gennem træet og tæl knuderne over det.
    + *Aflæs* dybden som kodeordslængden.
  ],
  worked: [
    Sortér bladene efter voksende frekvens og kør Huffman. Hvert skridt tager de to mindste vægte; køen vises efter hvert merge:

    ```
    Start: [ c:15, f:30, h:35, d:40, b:90, g:125 ]

    m1: c:15 + f:30   = 45    kø: [ h:35, d:40, 45, b:90, g:125 ]
    m2: h:35 + d:40   = 75    kø: [ 45, 75, b:90, g:125 ]
    m3: 45 + 75       = 120   kø: [ b:90, 120, g:125 ]
    m4: b:90 + 120    = 210   kø: [ g:125, 210 ]
    m5: g:125 + 210   = 335   kø: [ 335 ]  (rod)
    ```

    $d$ blev slugt i m2 (under $h d$, vægt 75), den knude i m3 (vægt 120), den i m4 (vægt 210), og den i m5 (roden). Det er fire merges over bladet $d$, så dybde 4.

    Svar: 4 bit.
  ],
)

#qcard(
  tag: [Huffman: hvilke optimale træer er producerbare? (producerbart)],
  source: "DM507 juni 2012, Opg. 5c",
  theory: <th-greedy-producerbar>,
  prompt: [Frekvenser a=#swap[$100$], b=#swap[$150$], c=#swap[$150$], d=#swap[$250$], e=#swap[$350$] (i alt 1000). Alle de viste træer er optimale (pris 2250 bit). Hvilke af træerne H2–H5 kan Huffman faktisk producere?],
  options: (
    [H2 $= ((c,d),((a,b),e))$],
    [H3 $= ((b,e),((a,c),d))$],
    [H4 $= ((d,(a,b)),(c,e))$],
    [H5 $= ((b,(a,c)),(d,e))$],
  ),
  answer: [(a) og (d): kun H2 og H5.],
  blueprint: [
    Kør Huffman selv, find de interne vægte den tvinger frem, og se hvilke træer rammer dem.

    + *Kør Huffman* på #swap[frekvenserne] og notér de interne vægte i merge-rækkefølge.
    + *Aflæs* hvert kandidat-træs egne interne vægte.
    + *Match.* Et træ kan produceres netop hvis dets interne vægte er det samme sæt som Huffmans.
    + *Forkast* træer med en intern vægt Huffman aldrig ville lave, også selvom de er optimale.
  ],
  worked: [
    Sortér bladene efter voksende frekvens og kør Huffman. Hvert skridt tager de to mindste vægte; køen vises efter hvert merge:

    ```
    Start: [ a:100, b:150, c:150, d:250, e:350 ]

    m1: a:100 + b:150 = 250   kø: [ c:150, 250, d:250, e:350 ]
    m2: c:150 + 250   = 400   kø: [ d:250, e:350, 400 ]
    m3: d:250 + e:350 = 600   kø: [ 400, 600 ]
    m4: 400 + 600     = 1000  kø: [ 1000 ]  (rod)
    ```

    Huffman tvinger altså de interne vægte $250, 400, 600, 1000$ frem. Et producerbart træ skal have præcis dette sæt. Aflæs hvert kandidat-træs egne interne vægte ved at summere bladene under hver intern knude:

    - H2 $= ((c,d),((a,b),e))$: $a b = 100+150 = 250$, $a b e = 250+350 = 600$, $c d = 150+250 = 400$, rod $= 600+400 = 1000$. Sættet er $250, 400, 600, 1000$ — matcher.
    - H5 $= ((b,(a,c)),(d,e))$: $a c = 100+150 = 250$, $b a c = 150+250 = 400$, $d e = 250+350 = 600$, rod $= 400+600 = 1000$. Sættet er $250, 400, 600, 1000$ — matcher.
    - H3 $= ((b,e),((a,c),d))$: $a c = 100+150 = 250$, $a c d = 250+250 = 500$, $b e = 150+350 = 500$, rod $= 1000$. Sættet er $250, 500, 500, 1000$.
    - H4 $= ((d,(a,b)),(c,e))$: $a b = 100+150 = 250$, $d a b = 250+250 = 500$, $c e = 150+350 = 500$, rod $= 1000$. Sættet er $250, 500, 500, 1000$.

    H3 og H4 har to interne knuder med vægt 500. Huffman ville aldrig parre noget til vægt 500, fordi den efter den første merge (250) altid tager 150 + 250 = 400 før den rører de tunge blade. De er optimale, men ikke producerbare.

    Svar: kun H2 og H5.
  ],
)

#qcard(
  tag: [Huffman: bitlængde af en streng (kodeordslængde)],
  source: "MCQ juni 2019, Spm. 22",
  theory: <th-greedy-huffman>,
  prompt: [Vi ser stadig på et Huffman-træ for input a=#swap[$500$], b=#swap[$400$], c=#swap[$300$], d=#swap[$250$], e=#swap[$200$], f=#swap[$150$]. Hvor mange bit fylder strengen #swap["caffebad"] kodet med dette træ?],
  options: ([$18$], [$19$], [$20$], [$21$], [$22$], [$23$], [$24$]),
  answer: [Mulighed (d): $21$.],
  blueprint: [
    Find hvert tegns kodeordslængde i træet og læg dem sammen tegn for tegn.

    + *Byg træet.* Merge de to mindste vægte igen og igen til ét træ.
    + *Aflæs dybder.* Hvert symbols kodeordslængde er dybden af dets blad.
    + *Læg sammen.* Summér kodeordslængderne over alle tegn i #swap[strengen].
  ],
  worked: [
    Byg først træet. Sortér bladene efter voksende frekvens og kør Huffman; køen vises efter hvert merge:

    ```
    Start: [ f:150, e:200, d:250, c:300, b:400, a:500 ]

    m1: f:150 + e:200 = 350   kø: [ d:250, c:300, 350, b:400, a:500 ]
    m2: d:250 + c:300 = 550   kø: [ 350, b:400, a:500, 550 ]
    m3: 350 + b:400   = 750   kø: [ a:500, 550, 750 ]
    m4: a:500 + 550   = 1050  kø: [ 750, 1050 ]
    m5: 750 + 1050    = 1800  kø: [ 1800 ]  (rod)
    ```

    Aflæs dybden af hvert blad ved at tælle merges over det:

    - $a$: under $a + 550$ (m4), under roden (m5). Dybde 2.
    - $b$: under $350 + b$ (m3), under roden (m5). Dybde 2.
    - $c$: under $d c$ (m2), under $a + 550$ (m4), under roden (m5). Dybde 3.
    - $d$: under $d c$ (m2), under $a + 550$ (m4), under roden (m5). Dybde 3.
    - $e$: under $f e$ (m1), under $350 + b$ (m3), under roden (m5). Dybde 3.
    - $f$: under $f e$ (m1), under $350 + b$ (m3), under roden (m5). Dybde 3.

    Strengen "caffebad" er tegnrækken $c, a, f, f, e, b, a, d$. Læg deres kodeordslængder sammen:

    #eq[$ underbrace(3, c) + underbrace(2, a) + underbrace(3, f) + underbrace(3, f) + underbrace(3, e) + underbrace(2, b) + underbrace(2, a) + underbrace(3, d) = 21 $]

    Svar: 21 bit.
  ],
)
