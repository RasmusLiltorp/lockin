#import "../lib.typ": *

== Greedy-algoritmer

En greedy-algoritme (greedy algorithm) bygger løsningen op ét skridt ad gangen og tager hver gang det, der ser bedst ud lige nu, uden at fortryde. Hurtigt, men kun korrekt hvis det lokale valg beviseligt giver den globalt bedste løsning.

Til eksamen kommer det to steder fra. Huffman-kodning (Huffman coding) (næsten hvert år): byg et træ ud fra symbolfrekvenser og aflæs en kodeordslængde eller det samlede antal bit. Og argumentet for, *hvorfor* et greedy-valg er optimalt — typisk et ombytningsargument (exchange argument).

=== Sådan løser du den

Huffman giver hyppige symboler korte koder og sjældne symboler lange. Et symbols kodeordslængde er dybden af dets blad: jo dybere, jo flere bit.

#recipe(
  title: "Byg Huffman-træet",
  [Skriv symbolerne op med deres frekvenser. Der er #swap[$n$] af dem.],
  [Læg alle bladene i en min-prioritetskø (min-priority queue) med frekvensen som nøgle.],
  [Tag de to mindste vægte $x$ og $y$ ud, lav en knude med vægt $x + y$, og læg den tilbage. Notér $x + y$; det er den interne knudes vægt.],
  [Gentag til der er ét træ tilbage — #swap[$n - 1$] merges.],
  [Kodeordslængden for et symbol er dybden af dets blad.],
)

For et symbol $s$ med frekvens $"freq"(s)$ og bladdybde $"depth"(s)$ er det samlede antal bit:

#eq[$ sum_s "freq"(s) dot "depth"(s) $]

Den sum er lig summen af alle interne knuders vægte, du skrev op undervejs:

#eq[$ sum_s "freq"(s) dot "depth"(s) = sum_("interne knuder") "vægt" $]

#note(title: [Interne vægte])[Genvejen via interne vægte er hurtigst: læg blot de noterede merge-summer sammen. For o:150, p:100, q:25, r:125, s:200, t:50, u:75 bliver de interne vægte $75, 150, 225, 300, 425, 725$, og $75+150+225+300+425+725 = 1900$ bit. Slip for at holde styr på dybder.]

#trap(title: [Flere gyldige træer])[Ved samme vægt kan begge træer vælges først, og venstre/højre er frit, så der findes flere gyldige Huffman-træer. Men dybder og pris er ens uanset valget — svar trygt på dem. Kun "tegn træet" har flere rigtige svar.]

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

Skal du *bevise* greedy optimal, brug et ombytningsargument: tag en vilkårlig optimal løsning OPT og vis, at du kan bytte ét element i OPT ud med greedy-valget uden at gøre OPT værre eller ugyldig. Gentaget bliver OPT til greedy-løsningen, så greedy er også optimal.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Huffman: kodeordslængde for et symbol],
  source: "MCQ juni 2025, Spm. 13 (samme skabelon juni 2019/2021/2023)",
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
    Sortér efter frekvens: q:25, t:50, u:75, p:100, r:125, o:150, s:200.

    + $q+t=75$
    + $u+75=150$
    + $p+r=225$
    + $o+150=300$
    + $s+225=425$
    + $300+425=725$ #sym.arrow.r rod

    $q$ sidder under $(q+t)$, derefter $(u+75)$, så $(o+150)$ og til sidst roden. Det er 4 merges, så dybde 4.

    Svar: 4 bit.
  ],
)

#qcard(
  tag: [Huffman: samlet antal bit],
  source: "MCQ juni 2025, Spm. 14",
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
    Genvejen er at lægge de interne vægte sammen. Merges gav:

    + $75, 150, 225, 300, 425, 725$
    + $75+150+225+300+425+725 = 1900$

    Tjek med $sum "freq" dot "depth"$:

    $ 150 dot 2 + 200 dot 2 + 100 dot 3 + 125 dot 3 + 75 dot 3 + 25 dot 4 + 50 dot 4 = 1900 $

    Svar: 1900 bit.
  ],
)

#qcard(
  tag: [Huffman: samlet antal bit],
  source: "MCQ juni 2017, Spm. 18",
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
    Sortér: 100, 200, 300, 400, 500, 600, 700.

    + $100+200=300$
    + $300+300=600$
    + $400+500=900$
    + $600+600=1200$
    + $700+900=1600$
    + $1200+1600=2800$ #sym.arrow.r rod

    Læg de interne vægte sammen:

    $ 300+600+900+1200+1600+2800 = 7400 $

    Svar: 7400 bit.
  ],
)

#qcard(
  tag: [Huffman: samlet antal bit],
  source: "MCQ juni 2021, Spm. 13",
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
    Sortér: c:100, a:200, b:250, d:350, e:400.

    + $c+a=300$
    + $b+d=600$
    + $300+e=700$
    + $600+700=1300$ #sym.arrow.r rod

    Læg de interne vægte sammen:

    $ 300+600+700+1300 = 2900 $

    Svar: 2900 bit.
  ],
)

#qcard(
  tag: [Huffman: samlet antal bit],
  source: "MCQ juni 2023, Spm. 13",
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
    Sortér: 15, 30, 35, 40, 90, 125.

    + $15+30=45$
    + $35+40=75$
    + $45+90=135$
    + $75+125=200$
    + $135+200=335$ #sym.arrow.r rod

    Læg de interne vægte sammen:

    $ 45+75+135+200+335 = 785 $

    Svar: 785 bit.
  ],
)

#qcard(
  tag: [Huffman: kodeordslængde for et symbol],
  source: "MCQ juni 2021, Spm. 12",
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
    Sortér: c:100, a:200, b:250, d:350, e:400.

    + $c+a=300$
    + $b+d=600$
    + $300+e=700$
    + $600+700=1300$ #sym.arrow.r rod

    $d$ er barn af $(b+d)$, og $(b+d)$ er barn af roden. Det er 2 merges over $d$, så dybde 2.

    Svar: 2 bit.
  ],
)

#qcard(
  tag: [Huffman: kodeordslængde for et symbol],
  source: "MCQ juni 2019, Spm. 21",
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
    Sortér: f:150, e:200, d:250, c:300, b:400, a:500.

    + $f+e=350$
    + $d+c=550$
    + $b+a=900$
    + $350+550=900$
    + $900+900=1800$ #sym.arrow.r rod

    $c$ sidder under $(d+c)$, så under $(350+550)$ og til sidst roden. Det er 3 merges, så dybde 3.

    Svar: 3 bit.
  ],
)

#qcard(
  tag: [Huffman: kodeordslængde for et symbol],
  source: "MCQ juni 2023, Spm. 12",
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
    Sortér: c:15, f:30, h:35, d:40, b:90, g:125.

    + $c+f=45$
    + $h+d=75$
    + $45+75=120$
    + $90+120=210$
    + $125+210=335$ #sym.arrow.r rod

    $d$ sidder under $(h+d)$, så under $(45+75)$, så under $(90+120)$ og til sidst roden. Det er 4 merges, så dybde 4.

    Svar: 4 bit.
  ],
)

#qcard(
  tag: [Huffman: hvilke optimale træer er producerbare?],
  source: "DM507 juni 2012, Opg. 5c",
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
    Huffmans tvungne merges:

    + $100+150=250$
    + $150+250=400$
    + $250+350=600$
    + $400+600=1000$ #sym.arrow.r rod

    Et producerbart træ må altså have de interne vægte $250, 400, 600, 1000$.

    - H2 og H5 rammer netop de fire vægte og matcher.
    - H3 og H4 giver $250, 500, 500, 1000$. De to 500-taller er parringer Huffman aldrig laver, så de er optimale men ikke producerbare.

    Svar: kun H2 og H5.
  ],
)

#qcard(
  tag: [Huffman: bitlængde af en streng],
  source: "MCQ juni 2019, Spm. 22",
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
    Byg træet: $f+e=350$, $d+c=550$, $b+a=900$, $350+550=900$, $900+900=1800$. Det giver dybderne a=2, b=2, c=3, d=3, e=3, f=3.

    Strengen "caffebad" er $c, a, f, f, e, b, a, d$:

    $ 3+2+3+3+3+2+2+3 = 21 $

    Svar: 21 bit.
  ],
)
