#import "../lib.typ": *

== Søgestrukturer: BST, augmenteret BST, hashing

En ordbog skal kunne slå op, indsætte og slette. Skal den også svare på "hvad kommer før/efter denne nøgle" eller gå igennem alt i sorteret orden, kræver det en *ordnet* ordbog.

Et balanceret søgetræ (rød-sort træ) klarer alt i $O(log n)$. En hashtabel klarer opslag, indsæt og slet i $O(1)$ i gennemsnit, men kan ikke svare på de ordnede spørgsmål.

At *augmentere* et BST betyder, at hver knude gemmer ekstra info om hele sit deltræ (antal knuder, største $y$-værdi, en sum), så du kan svare på nye spørgsmål i $O(log n)$.

Til eksamen skal du opstille ligningerne for et augmenteret felt, simulere en hashtabel skridt for skridt og udvælge worst-case-køretider.

=== Sådan løser du den

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

#note(title: [Nøglefelt vs. ikke-nøglefelt])[Nøglefelt vs. ikke-nøglefelt afgør formlen. Træet er sorteret efter *én* nøgle, fx $x$. Et ekstremum af *nøglen* ligger fast: største $x$ er den højreste knude, mindste $x$ den venstreste.

#eq[$ v."xmax" = v."right"."xmax", quad v."xmin" = v."left"."xmin" $]

Et ikke-nøglefelt (fx $y$) er ikke sorteret af træet, så kig på begge børn og knuden selv:

#eq[$ v."ymax" = max(v.y, space v."left"."ymax", space v."right"."ymax") $]
]

#trap(title: [Vedligeholdelse af augmentering])[Vedligeholdelse rører ikke kun bladet eller kun roden. En indsæt eller slet ændrer knuderne langs én rod-til-blad-sti plus $O(1)$ rotationer; du genberegner felterne nedefra og op langs den sti, altså $O(log n)$ knuder. Et fuldt inorder-gennemløb er $O(n)$ og dermed forkert svar på et $O(log n)$-spørgsmål.]

For ordensstatistik gemmer hver knude `size`. NIL er en sentinel med `size = 0`, så `x.left.size` altid er defineret. Rangen i eget deltræ:

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

#recipe(
  title: "Simulér en hashtabel med open addressing",
  [Noter tabelstørrelsen #swap[$m$] og hvilke pladser der er optaget før indsættelsen.],
  [Find probe-sekvensen. Linear probing:],
  [Indsæt ved at prøve $i = 0, 1, 2, dots$ til *første tomme plads*. Søgning gør det samme og stopper ved nøglen eller en tom plads.],
  [Til "hvilke $h'$-værdier er mulige": prøv hver kandidat, simulér probingen, og behold den hvis landingen rammer den observerede plads.],
)

#eq[$ h(k, i) = (h'(k) + i) mod m $]

Double hashing bruger en anden funktion til skridtlængden:

#eq[$ h(k, i) = (h_1(k) + i dot h_2(k)) mod m $]

#note(title: [Chaining])[Chaining er den anden kollisionsmetode: hver plads peger på en liste over de nøgler, der hasher dertil. Indsæt er $O(1)$ (forrest i listen), søg og slet er $Theta(|"liste"|)$. Worst case hasher alle $n$ nøgler til samme plads, så listen får længde $n$ og søgning bliver $Theta(n)$. Bruger du balancerede træer i stedet for lister, falder worst case til $O(log n)$. I praksis er hashing $O(1)$ for søg, indsæt og slet.]

#trap(title: [Open addressing])[Open addressing kræver $n <= m$; sigt efter en fyldningsgrad omkring $n approx m\/4$. Slet markerer pladsen som slettet uden at tømme den, ellers afbryder en senere søgning for tidligt. Vælg $m$ som primtal, så probe-sekvensen når alle pladser. Quadratic probing er ude af pensum.]

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

#note(title: [Rød-sort balance])[Et rød-sort træ er balanceret, fordi ingen sti har to røde knuder i træk. Med $k$ sorte knuder på hver rod-til-blad-sti gælder $n >= 2^(k-1) - 1$, så $k - 1 <= log(n+1)$. Den længste sti har højst dobbelt så mange kanter som den korteste, så højden er $<= 2 log(n+1) = O(log n)$.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Augmenteret BST: vælg opdateringsligninger],
  source: "MCQ juni 2015, Spm. 25",
  prompt: [En mængde punkter i planen gemmes i et balanceret binært søgetræ (BST) med punkternes #swap[$x$]-koordinat som nøgle. Hver knude svarer til et punkt og gemmer derudover fire felter for hele sit deltræ: `v.xmax`, `v.xmin`, `v.ymax`, `v.ymin`. Hvilket sæt opdateringsligninger vedligeholder felterne korrekt i knude $v$ ud fra dens børn `v.left`, `v.right` og dens egne koordinater `v.x`, `v.y`?],
  options: (
    [`v.xmax = v.left.xmax`; `v.xmin = v.right.xmin`; `v.ymax = max(v.left.ymax, v.right.ymax, v.y)`; `v.ymin = min(v.left.ymin, v.right.ymin, v.y)`],
    [`v.xmax = v.right.xmax`; `v.xmin = v.left.xmin`; `v.ymax = min(v.left.ymax, v.right.ymax, v.y)`; `v.ymin = max(v.left.ymin, v.right.ymin, v.y)`],
    [`v.ymax = v.right.ymax`; `v.ymin = v.left.ymin`; `v.xmax = max(v.left.xmax, v.right.xmax, v.x)`; `v.xmin = min(v.left.xmin, v.right.xmin, v.x)`],
    [`v.xmax = v.right.xmax`; `v.xmin = v.left.xmin`; `v.ymax = max(v.left.ymax, v.right.ymax, v.y)`; `v.ymin = min(v.left.ymin, v.right.ymin, v.y)`],
  ),
  answer: [Mulighed (d).],
  worked: [Træet er sorteret efter $x$, så `xmax` kommer fra højre barn og `xmin` fra venstre. $y$ er ikke ordnet af træet, så `ymax` og `ymin` kombineres over begge børn og knuden selv. (a) bytter $x$-siderne, (b) bytter $max$ og $min$ på $y$, (c) henter $y$ fra ét fast barn. Kun (d) er rigtig.],
)

#qcard(
  tag: [Augmenteret BST: hvorfor bevares O(log n)?],
  source: "MCQ juni 2015, Spm. 26",
  prompt: [Lad nu søgetræet være et rød-sort træ. Hvilke af følgende er korrekte argumenter for, at informationen i træets knuder kan vedligeholdes under indsættelser og sletninger, uden at ændre de rød-sorte træers køretid på $O(log n)$ for indsættelser og sletninger?],
  options: (
    [Ingen information i knuderne behøver at ændres under indsættelser og sletninger, så de rød-sorte træers $O(log n)$-køretid holder stadig.],
    [Kun roden får ny information, og det er $O(1)$ ekstra arbejde oven i de rød-sorte træers $O(log n)$-køretid, hvilket stadig er $O(log n)$.],
    [Ved indsættelser behøver kun det nye blad ny information ($O(1)$ ekstra), og ved sletninger kan information kun forsvinde, hvilket ikke giver arbejde.],
    [Efter ændringer i træet under indsættelser og sletninger behøver kun knuder på en sti fra et blad til roden ny information, og den kan genberegnes nedefra og op i tid $O(log n)$.],
    [Efter ændringer kan et inorder-gennemløb af træet genoprette informationen i alle knuder i tid $O(log n)$.],
  ),
  answer: [Mulighed (d).],
  worked: [En indsæt eller slet ændrer kun knuder på én rod-til-blad-sti plus $O(1)$ rotationer, og hver rotation ændrer lokalt $O(1)$ felter, der kan genfindes fra børnene. Genberegning nedefra og op koster $O(log n) =$ træets højde. (a) falsk: info ændres. (b) falsk: mere end roden. (c) falsk: sletninger kræver også opdatering. (e) falsk: inorder er $O(n)$.],
)

#qcard(
  tag: [Hashing: hvilke h'-værdier passer? (linear probing)],
  source: "MCQ juni 2021, Spm. 9 (samme type 2015/2017/2019/2023)",
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
  worked: [Optagne pladser: $#swap[${0,2,4,6}$]$, tomme: $#swap[${1,3,5}$]$, og 97 landede i plads #swap[1]. Prob hver startværdi til første tomme plads. $h'=0$: 0 optaget, lander 1. $h'=1$: lander 1. $h'=2 ->$ 3. $h'=3 ->$ 3. $h'=4 ->$ 5. $h'=5 ->$ 5. $h'=6$: 6 og 0 optaget, lander 1. Kun $0, 1, 6$ rammer plads 1.],
)

#qcard(
  tag: [Sortering: hvilke er Θ(n²) i værste fald?],
  source: "MCQ juni 2019, Spm. 27 (worst-case sortering, går igen bredt)",
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
  worked: [CountingSort med univers $k = n^2$ er $Theta(n + n^2) = Theta(n^2)$. RadixSort med 2 cifre i base $n$ er to CountingSort-pas med $k = n$, altså $Theta(n)$. MergeSort er altid $Theta(n log n)$. TreeSort på et rød-sort træ er $n$ indsættelser à $O(log n)$ plus et $O(n)$-gennemløb, altså $Theta(n log n)$. TreeSort på et ubalanceret BST degenererer ved sorteret input til en sti, hvor indsættelse $i$ koster $i$, så summen er $Theta(n^2)$. QuickSort og InsertionSort er $Theta(n^2)$ i worst case.],
)
