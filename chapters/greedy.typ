#import "../lib.typ": *

== Greedy-algoritmer

En greedy-algoritme bygger løsningen op ét skridt ad gangen og tager hver gang det, der ser bedst ud lige nu, uden at fortryde. Hurtigt, men kun korrekt hvis det lokale valg beviseligt giver den globalt bedste løsning.

Til eksamen kommer det to steder fra. Huffman-kodning (næsten hvert år): byg et træ ud fra symbolfrekvenser og aflæs en kodeordslængde eller det samlede antal bit. Og argumentet for, *hvorfor* et greedy-valg er optimalt — typisk et ombytningsargument.

=== Sådan løser du den

Huffman giver hyppige symboler korte koder og sjældne symboler lange. Et symbols kodeordslængde er dybden af dets blad: jo dybere, jo flere bit.

#recipe(
  title: "Byg Huffman-træet",
  [Skriv symbolerne op med deres frekvenser. Der er #swap[$n$] af dem.],
  [Læg alle bladene i en min-prioritetskø med frekvensen som nøgle.],
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

Aktivitetsudvælgelse er det andet klassiske greedy-problem: du har aktiviteter med start- og sluttider og vil have flest mulige uden overlap.

#recipe(
  title: "Aktivitetsudvælgelse",
  [Sortér de #swap[$n$] aktiviteter efter voksende sluttidspunkt.],
  [Gå dem igennem og vælg en aktivitet hvis den ikke overlapper den senest valgte; ellers spring den over.],
  [Resultatet er en størst mulig mængde uden overlap.],
)

Køretiden er domineret af sorteringen:

#eq[$ O(n log n) $]

#note(title: [Korrekt greedy-valg])[De andre greedy-valg fejler: korteste aktivitet, færrest overlap og tidligste start har alle modeksempler. Kun tidligste sluttidspunkt er optimalt. Beviset er en invariant — "en optimal løsning indeholder de hidtidige valg" — lukket med et ombytningsargument.]

#trap(title: [0-1-rygsæk])[Greedy efter værditæthed løser fractional rygsæk optimalt, men fejler for 0-1. Kapacitet 50, genstande (vægt 10, \$60), (vægt 20, \$100), (vægt 30, \$120): tæthed tager de to første og får \$160, men optimum er de to sidste med \$220. 0-1-rygsæk kræver dynamisk programmering.]

Skal du *bevise* greedy optimal, brug et ombytningsargument: tag en vilkårlig optimal løsning OPT og vis, at du kan bytte ét element i OPT ud med greedy-valget uden at gøre OPT værre eller ugyldig. Gentaget bliver OPT til greedy-løsningen, så greedy er også optimal.

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Huffman: kodeordslængde for et symbol],
  source: "MCQ juni 2025, Spm. 13 (samme skabelon juni 2019/2021/2023)",
  prompt: [En fil indeholder tegn med hyppigheder: o=#swap[$150$], p=#swap[$100$], q=#swap[$25$], r=#swap[$125$], s=#swap[$200$], t=#swap[$50$], u=#swap[$75$]. Byg et Huffman-træ. Hvor mange bit er der i kodeordet for #swap[$q$]?],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [(d) $4$.],
  worked: [Sortér: q:25, t:50, u:75, p:100, r:125, o:150, s:200. Merges: $q+t=75$; $u+75=150$; $p+r=225$; $o+150=300$; $s+225=425$; $300+425=725$ (rod). $q$ ligger under $(q+t)$, $(u+75)$, $(o+150)$ og roden: dybde 4, altså 4 bit.],
)

#qcard(
  tag: [Huffman: samlet antal bit],
  source: "MCQ juni 2025, Spm. 14",
  prompt: [Et Huffman-træ for en fil med hyppigheder o=#swap[$150$], p=#swap[$100$], q=#swap[$25$], r=#swap[$125$], s=#swap[$200$], t=#swap[$50$], u=#swap[$75$] (i alt #swap[$725$] symboler). Hvor mange bit fylder de 725 symboler tilsammen Huffman-kodet?],
  options: ([$1800$], [$1825$], [$1900$], [$1925$], [$2000$], [$2075$], [$2100$]),
  answer: [(c) $1900$.],
  worked: [Genvej via interne vægte: merges gav $75, 150, 225, 300, 425, 725$, og $75+150+225+300+425+725 = 1900$. Tjek med $sum "freq" dot "depth"$: $150 dot 2 + 200 dot 2 + 100 dot 3 + 125 dot 3 + 75 dot 3 + 25 dot 4 + 50 dot 4 = 1900$.],
)

#qcard(
  tag: [Huffman: kodeordslængde for et symbol],
  source: "MCQ juni 2021, Spm. 12",
  prompt: [En fil indeholder tegnene med hyppigheder: a=#swap[$200$], b=#swap[$250$], c=#swap[$100$], d=#swap[$350$], e=#swap[$400$]. Byg et Huffman-træ. Hvor mange bit er der i kodeordet for #swap[$d$]?],
  options: ([$1$], [$2$], [$3$], [$4$]),
  answer: [(b) $2$.],
  worked: [Merges: $c+a=300$; $b+d=600$; $300+e=700$; $600+700=1300$ (rod). $d$ er barn af $(b+d)$, som er barn af roden: dybde 2, altså 2 bit.],
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
  worked: [Huffmans tvungne merges: $100+150=250$; $150+250=400$; $250+350=600$; $400+600=1000$. Et producerbart træ må have interne vægte $250, 400, 600, 1000$. H2 og H5 giver begge netop dem og matcher. H3 og H4 giver $250, 500, 500, 1000$; de to 500-taller er parringer Huffman aldrig laver — optimale, men ikke producerbare.],
)
