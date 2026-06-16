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
  blueprint: [
    Du kender landingspladsen og skal finde, hvilke startværdier der kunne ende der. Prøv dem alle.

    + *Aflæs tabellen.* Noter hvilke pladser der var optaget før indsættelsen, og hvilken plads den nye nøgle endte på.
    + *Linear probing.* Probe-sekvensen er $h(k,i) = (h'(k) + i) mod m$, altså start ved #swap[$h'$] og gå ét skridt frem ad gangen til første tomme plads.
    + *Prøv hver kandidat.* For hvert mulige $h'$ følger du sekvensen fra den startplads, til du rammer en tom plads. Lander den på den observerede plads, er kandidaten gyldig.
    + *Saml svaret.* Behold de startværdier, hvis sekvens ender på den rigtige plads.
  ],
  worked: [
    Optagne pladser før indsættelsen: $#swap[${0,2,4,6}$]$. Tomme: $#swap[${1,3,5}$]$. Nøglen 97 endte på plads #swap[1], og $m = #swap[7]$.

    Jeg prober hver startværdi frem til første tomme plads:

    - $h'=0$: plads 0 er optaget, gå til 1. Tom, lander på 1. Passer.
    - $h'=1$: plads 1 er tom, lander på 1. Passer.
    - $h'=2$: 2 optaget, gå til 3. Tom, lander på 3. Forkert.
    - $h'=3$: 3 tom, lander på 3. Forkert.
    - $h'=4$: 4 optaget, gå til 5. Tom, lander på 5. Forkert.
    - $h'=5$: 5 tom, lander på 5. Forkert.
    - $h'=6$: 6 optaget, gå til 0 (wrap), også optaget, gå til 1. Tom, lander på 1. Passer.

    Kun $0$, $1$ og $6$ rammer plads 1.

    Svar: $h'(97) in {0, 1, 6}$, altså (a), (b) og (g).
  ],
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
