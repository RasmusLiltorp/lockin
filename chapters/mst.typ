#import "../lib.typ": *

== Minimum udspændende træer <th-mst-cut>

Givet en vægtet, sammenhængende, urettet graf (weighted, connected, undirected graph) er et minimum udspændende træ (minimum spanning tree, MST) den billigste måde at forbinde alle knuderne: vælg kanter så alt hænger sammen og den samlede vægt er mindst mulig.

Et udspændende træ (spanning tree) har altid én kant mindre end antal knuder.

#eq[$ |"kanter i MST"| = n - 1 $]

Til eksamen kører du Kruskal eller Prim i hånden. Spørgsmålet er typisk "hvilken kant tilføjes sidst", "hvilken kant forkastes først", eller "hvor mange komponenter er der nu".

=== Sådan løser du den

Begge algoritmer er grådige (greedy) og bygger på samme cut-idé: den letteste kant der krydser et cut gennem grafen er altid sikker at vælge. De adskiller sig kun i, hvordan de vælger næste sikre kant.

#metadata(none) <th-mst-kruskal>
#recipe(
  title: "Kruskal — sortér kanterne, tag den letteste der ikke laver en kreds",
  [Giv hver knude sin egen komponent.],
  [Sortér alle kanter efter vægt, letteste først.],
  [Gennemløb kanterne. Tag kant $(u,v)$ hvis $u$ og $v$ ligger i hver sin komponent, og slå komponenterne sammen. Ligger de allerede sammen, laver kanten en kreds: spring den over.],
  [Stop når du har #swap[$n - 1$] kanter.],
)

#metadata(none) <th-mst-prim>
#recipe(
  title: "Prim — voks ét træ ud fra en startknude",
  [Vælg en startknude #swap[$r$]. Den besøgte mængde $C$ er ${r}$.],
  [Find den letteste kant der går fra $C$ ud til en knude udenfor. Tag kanten — den er en MST-kant — og gem den som den nye knudes forælder $v.pi$, før du lægger knuden ind i $C$.],
  [Gentag til alle knuder er i $C$. MST'et er nu de #swap[$n - 1$] kanter du tog: kantmængden ${(v, v.pi)}$ for hver knude pånær startknuden.],
)

#note(title: [Aflæs kanterne])[Det er *kanterne*, ikke knuderne, der er træet — alle knuder ender jo med at være med uanset hvad. I bogens notation gemmer hver knude $v$ sin indkomne kant som forælderen $v.pi$, og hele MST'et er $A = {(v, v.pi) | v in.not {r}}$. For Kruskal er det endnu mere ligetil: træet er de kanter du accepterede undervejs (dem der ikke lavede en kreds). Begge ender med $n - 1$ kanter.]

#note(title: [Extract-Min])[Prim køres ofte med en min-prioritetskø (min-priority queue), og så spørger eksamen til Extract-Min frem for til selve træet, men det er samme algoritme. Hver knude uden for træet bærer en nøgle, nemlig vægten af den letteste kant der forbinder den til det du har bygget indtil nu (uendelig, hvis ingen kant rører den endnu). Extract-Min er den køoperation der fjerner og returnerer knuden med den mindste nøgle; den knude lægges ind i træet, og bagefter opdateres naboernes nøgler. Startknuden har nøgle 0 og kommer derfor ud først. Rækkefølgen knuderne forlader køen i, er den samme som rækkefølgen de føjes til MST'et. Så "hvilken knude udtages sidst med Extract-Min" er bare "hvilken knude føjes sidst til træet", løst nøjagtig som Prim-opskriften ovenfor.]

#note(title: [Prim som UCS])[Kender du UCS (uniform cost search), så er Prim stort set UCS uden et goal: du trækker den billigste knude ud af køen, lægger den ind, og bliver ved til hele grafen er med i stedet for at stoppe ved et mål. Den ene forskel ligger i nøglen — i Prim vægter du den enkelte kant ind til træet, ikke den samlede vej fra start. Netop dét gør resultatet til et MST og ikke et korteste-vej-træ (shortest-path tree).]

#note(title: [Entydigt MST])[Er alle kantvægte forskellige, er MST'et entydigt: Kruskal og Prim giver samme træ, selv om de tager kanterne i hver sin rækkefølge.]

#trap(title: [Forskellig rækkefølge])[Kruskal ser på alle kanter i vægtrækkefølge. Prim ser kun på kanter der rører den knudemængde han har bygget. De tager derfor sjældent kanterne i samme rækkefølge.]

#trap(title: [Hvornår forkastes en kant])[En kant forkastes netop når begge endepunkter allerede sidder i samme komponent — det ville give en kreds.]

Begge algoritmer kører på en sammenhængende graf i:

#eq[$ O(m log n) $]

For Kruskal dominerer sorteringen af kanterne. For Prim er det en min-prioritetskø: $n$ udtræk af nærmeste knude og op til $m$ nøgleopdateringer.

Hver tagen kant smelter to komponenter til én, så efter $k$ kanter gælder:

#eq[$ "antal komponenter" = n - k $]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Kruskal: hvilken kant tilføjes sidst? (Kruskal)],
  source: "MCQ juni 2025, Spm. 21",
  theory: <th-mst-kruskal>,
  prompt: [Brug Kruskals algoritme til at finde et MST (læs næste spørgsmål først). Knuder $a, b, c, e, f, g, h, i, j$. Kanter med vægte: $(a,c)=#swap[$2$]$, $(a,b)=#swap[$15$]$, $(b,e)=5$, $(b,f)=8$, $(c,e)=20$, $(c,j)=17$, $(e,h)=11$, $(e,j)=9$, $(f,h)=6$, $(f,g)=3$, $(g,i)=19$, $(h,i)=16$, $(h,j)=21$, $(i,j)=14$. Hvilken kant tilføjes sidst til MST'et?],
  options: ([$(a, b)$], [$(i, j)$], [$(h, j)$], [$(e, h)$], [$(h, i)$], [$(e, j)$]),
  answer: [(a) $(a, b)$.],
  blueprint: [
    Spørgsmålet om den sidst tilføjede kant er bare Kruskal kørt til ende. Den tungeste accepterede kant er svaret.

    + *Tæl knuderne.* Du skal bruge #swap[$n - 1$] kanter, så ved $n$ knuder er det $n - 1$ stop.
    + *Sortér kanterne efter vægt*, letteste først.
    + *Gå listen igennem.* Tag en kant hvis dens to endepunkter ligger i hver sin komponent; ellers spring den over.
    + *Bliv ved* til du har $n - 1$ kanter. Den sidste du tog, er svaret.
  ],
  worked: [
    9 knuder, så jeg skal bruge 8 kanter. Sorteret kantliste:

    ```
    ac=2  fg=3  be=5  fh=6  bf=8  ej=9  eh=11  ij=14  ab=15  hi=16  cj=17  gi=19  ce=20  hj=21
    ```

    Jeg starter med hver knude i sin egen komponent og kører listen igennem. Kolonnen "Komponenter" viser union-find-tilstanden efter skridtet; "taget" tæller MST-kanterne:

    ```
    start:           {a} {b} {c} {e} {f} {g} {h} {i} {j}        taget=0
    ac=2   TAG       {a,c} {b} {e} {f} {g} {h} {i} {j}          taget=1
    fg=3   TAG       {a,c} {b} {e} {f,g} {h} {i} {j}            taget=2
    be=5   TAG       {a,c} {b,e} {f,g} {h} {i} {j}              taget=3
    fh=6   TAG       {a,c} {b,e} {f,g,h} {i} {j}                taget=4
    bf=8   TAG       {a,c} {b,e,f,g,h} {i} {j}                  taget=5
    ej=9   TAG       {a,c} {b,e,f,g,h,j} {i}                    taget=6
    eh=11  FORKAST   e,h allerede i {b,e,f,g,h,j} -> kreds      taget=6
    ij=14  TAG       {a,c} {b,e,f,g,h,i,j}                      taget=7
    ab=15  TAG       {a,b,c,e,f,g,h,i,j}  (alt samlet)          taget=8 <- sidste
    ```

    Kant nummer 8 er $a b = 15$, som hægter komponenten ${a,c}$ på resten. Det er den sidste kant ind.

    Svar: $(a,b)$.
  ],
)

#qcard(
  tag: [Kruskal: hvilken kant tilføjes sidst? (Kruskal)],
  source: "MCQ juni 2021, Spm. 22",
  theory: <th-mst-kruskal>,
  prompt: [Kør Kruskals algoritme på grafen (urettet, vægtet): $e a=#swap[$8$]$, $a g=9$, $g h=10$, $e f=0$, $a c=6$, $g d=7$, $g b=3$, $h b=11$, $f c=12$, $c d=2$, $d b=5$. Hvilken kant er den sidste der undersøges og tages med i MST'et?],
  options: ([$(e, a)$], [$(a, g)$], [$(g, h)$], [$(a, c)$], [$(g, d)$], [$(h, b)$]),
  answer: [Mulighed (c): $(g, h)$, vægt $10$.],
  blueprint: [
    Den sidst accepterede kant er Kruskal kørt til ende. Pas på: kanter senere i sorteringen kan stadig blive forkastet, så det er den sidste *accepterede* kant, ikke den sidste undersøgte.

    + *Tæl knuderne.* Du skal bruge #swap[$n - 1$] kanter.
    + *Sortér kanterne efter vægt*, letteste først.
    + *Gå listen igennem* og accepter en kant når dens to endepunkter ligger i hver sin komponent.
    + *Bliv ved* til du har $n - 1$ kanter. Den sidste du accepterede, er svaret — også selvom der ligger flere kanter efter den i sorteringen.
  ],
  worked: [
    8 knuder, så jeg skal bruge 7 kanter. Sorteret kantliste:

    ```
    ef=0  cd=2  gb=3  db=5  ac=6  gd=7  ea=8  ag=9  gh=10  hb=11  fc=12
    ```

    Pas på: kanter senere i sorteringen kan stadig blive forkastet, så svaret er den sidste *accepterede* kant. Union-find-tilstand efter hvert skridt:

    ```
    start:           {a} {b} {c} {d} {e} {f} {g} {h}           taget=0
    ef=0   TAG       {a} {b} {c} {d} {e,f} {g} {h}             taget=1
    cd=2   TAG       {a} {b} {c,d} {e,f} {g} {h}               taget=2
    gb=3   TAG       {a} {b,g} {c,d} {e,f} {h}                 taget=3
    db=5   TAG       {a} {b,c,d,g} {e,f} {h}                   taget=4
    ac=6   TAG       {a,b,c,d,g} {e,f} {h}                     taget=5
    gd=7   FORKAST   g,d allerede i {a,b,c,d,g} -> kreds        taget=5
    ea=8   TAG       {a,b,c,d,e,f,g} {h}                       taget=6
    ag=9   FORKAST   a,g allerede sammen -> kreds               taget=6
    gh=10  TAG       {a,b,c,d,e,f,g,h}  (alt samlet)           taget=7 <- sidste
    hb=11  -         (alt allerede samlet, ses ikke)            taget=7
    fc=12  -         (alt allerede samlet, ses ikke)            taget=7
    ```

    Den sidste *accepterede* kant er $g h = 10$, selvom $h b$ og $f c$ ligger efter den i listen.

    Svar: $(g, h)$ med vægt 10.
  ],
)

#qcard(
  tag: [Kruskal: antal komponenter ved første forkastning (sammenhængskomponenter)],
  source: "MCQ juni 2025, Spm. 22",
  theory: <th-mst-cut>,
  prompt: [Fortsæt med Kruskals algoritme på samme graf. I det første øjeblik hvor en undersøgt kant ikke tages med, hvor mange sammenhængskomponenter (connected components) har $(V, A)$? ($V$ er alle knuder, $A$ er de kanter der er taget indtil nu.)],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [(c) #swap[$3$].],
  blueprint: [
    Hver tagen kant smelter to komponenter til én, så efter $k$ kanter er der $n - k$ komponenter. Du skal bare vide hvor mange kanter der er taget, lige før den første forkastelse.

    + *Kør Kruskal* og tæl kanterne du tager med.
    + *Stop ved den første kant der springes over* (begge endepunkter i samme komponent). Lad #swap[$k$] være antal tagne kanter på det tidspunkt.
    + *Aflæs svaret* som $n - k$ komponenter.
  ],
  worked: [
    Her er $n = 9$, samme graf som forrige spørgsmål. Sorteret kantliste:

    ```
    ac=2  fg=3  be=5  fh=6  bf=8  ej=9  eh=11  ...
    ```

    Jeg kører Kruskal og stopper i det øjeblik en kant forkastes første gang. Union-find-tilstanden:

    ```
    start:           {a} {b} {c} {e} {f} {g} {h} {i} {j}       taget=0
    ac=2   TAG       {a,c} {b} {e} {f} {g} {h} {i} {j}         taget=1
    fg=3   TAG       {a,c} {b} {e} {f,g} {h} {i} {j}           taget=2
    be=5   TAG       {a,c} {b,e} {f,g} {h} {i} {j}             taget=3
    fh=6   TAG       {a,c} {b,e} {f,g,h} {i} {j}               taget=4
    bf=8   TAG       {a,c} {b,e,f,g,h} {i} {j}                 taget=5
    ej=9   TAG       {a,c} {b,e,f,g,h,j} {i}                   taget=6
    eh=11  FORKAST   e,h allerede i {b,e,f,g,h,j} -> kreds      taget=6 <- første forkastning
    ```

    Lige før den første forkastning er der $k = 6$ tagne kanter, så antal komponenter er $n - k = 9 - 6 = 3$. De tre komponenter er ${a,c}$, ${b,e,f,g,h,j}$ og ${i}$.

    Svar: 3 komponenter.
  ],
)

#qcard(
  tag: [Kruskal: antal komponenter ved første forkastning (sammenhængskomponenter)],
  source: "MCQ juni 2019, Spm. 18",
  theory: <th-mst-cut>,
  prompt: [Fortsæt med Kruskals algoritme på grafen $G_3$. Knuder $a, b, c, d, e, f, g, h, i$ med vægtede kanter: $(a,f)=3$, $(a,b)=4$, $(f,g)=8$, $(f,b)=5$, $(g,b)=2$, $(g,c)=6$, $(b,c)=1$, $(h,c)=9$, $(h,d)=6$, $(h,i)=9$, $(i,d)=7$, $(i,e)=1$, $(c,d)=8$, $(d,e)=7$. Hvor mange sammenhængskomponenter har $(V, A)$ efter at #swap[$8$] kanter er undersøgt? ($V$ er alle knuder, $A$ er de kanter der er taget indtil nu.)],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [Mulighed (c): $3$.],
  blueprint: [
    Her tælles der efter et fast antal *undersøgte* kanter, ikke ved den første forkastelse. Forkastede kanter tæller med i de undersøgte, men ikke i $A$. Efter $k$ tagne kanter er der $n - k$ komponenter.

    + *Sortér kanterne efter vægt*, letteste først.
    + *Gå listen igennem* og tæl både de undersøgte og de tagne kanter hver for sig.
    + *Stop når du har undersøgt* #swap[det angivne antal] kanter. Lad $k$ være antal *tagne* kanter på det tidspunkt.
    + *Aflæs svaret* som $n - k$ komponenter.
  ],
  worked: [
    Her er $n = 9$. Her tælles der efter et fast antal *undersøgte* kanter (8 stk.), ikke ved første forkastning. Forkastede kanter tæller med i de undersøgte, men ikke i $A$. Sorteret kantliste:

    ```
    bc=1  ie=1  gb=2  af=3  ab=4  fb=5  gc=6  hd=6  id=7  de=7  fg=8  cd=8  hc=9  hi=9
    ```

    Jeg undersøger de otte første og fører union-find. "und." tæller undersøgte, "tag" tæller tagne:

    ```
    start:           {a} {b} {c} {d} {e} {f} {g} {h} {i}       und=0  tag=0
    bc=1   TAG       {a} {b,c} {d} {e} {f} {g} {h} {i}         und=1  tag=1
    ie=1   TAG       {a} {b,c} {d} {e,i} {f} {g} {h}           und=2  tag=2
    gb=2   TAG       {a} {b,c,g} {d} {e,i} {f} {h}             und=3  tag=3
    af=3   TAG       {a,f} {b,c,g} {d} {e,i} {h}               und=4  tag=4
    ab=4   TAG       {a,b,c,f,g} {d} {e,i} {h}                 und=5  tag=5
    fb=5   FORKAST   f,b allerede i {a,b,c,f,g} -> kreds        und=6  tag=5
    gc=6   FORKAST   g,c allerede i {a,b,c,f,g} -> kreds        und=7  tag=5
    hd=6   TAG       {a,b,c,f,g} {d,h} {e,i}                   und=8  tag=6 <- stop
    ```

    Efter 8 undersøgte kanter er $k = 6$ taget, så $n - k = 9 - 6 = 3$. Komponenterne er ${a,b,c,f,g}$, ${d,h}$ og ${e,i}$.

    Svar: 3 komponenter.
  ],
)

#qcard(
  tag: [Prim: hvilken knude tilføjes sidst? (Prim)],
  source: "MCQ juni 2023, Spm. 20",
  theory: <th-mst-prim>,
  prompt: [Brug Prims algoritme til at finde et MST med start i knude #swap[$a$]. Urettede vægtede kanter: $b c=5$, $c a=11$, $a f=10$, $f e=7$, $b d=13$, $c h=9$, $a h=2$, $a i=3$, $f i=4$, $e g=8$, $d h=1$, $h i=6$, $i g=12$. Hvilken knude tilføjes sidst til MST'et?],
  options: ([$b$], [$d$], [$e$], [$g$]),
  answer: [(a) #swap[$b$].],
  blueprint: [
    Den sidst tilføjede knude i Prim er den sidste der trækkes ind i træet $C$.

    + *Start i* #swap[startknuden] og sæt $C$ til kun den knude.
    + *Find den letteste kant* der går fra $C$ ud til en knude udenfor.
    + *Tag kanten*, læg den nye knude ind i $C$, og noter rækkefølgen.
    + *Gentag* til alle knuder er i $C$. Den knude der kom ind sidst, er svaret.
  ],
  worked: [
    Jeg vokser træet $C$ ud fra $a$. Hvert skridt tager den letteste kant der krydser ud af $C$, trækker naboknuden ind og opdaterer nøglerne for de knuder der stadig står udenfor. Nøglen for en udenforstående knude er vægten af den letteste kant der forbinder den til $C$ ($infinity$ hvis ingen rører den endnu).

    Naboer pr. knude: $a:{c 11, f 10, h 2, i 3}$, $h:{c 9, d 1, i 6}$, $d:{b 13}$, $i:{f 4, g 12}$, $f:{e 7}$, $e:{g 8}$, $c:{b 5}$.

    ```
    C           ind   via       nøgler udenfor C (efter opdatering)
    -----------------------------------------------------------------
    {a}          a    -         b=inf c=11 d=inf e=inf f=10 g=inf h=2 i=3
    {a,h}        h    ah=2      b=inf c=9  d=1   e=inf f=10 g=inf      i=3
    {a,h,d}      d    hd=1      b=13  c=9        e=inf f=10 g=inf      i=3
    {a,h,d,i}    i    ai=3      b=13  c=9        e=inf f=4  g=12
    {+f}         f    fi=4      b=13  c=9        e=7        g=12
    {+e}         e    fe=7      b=13  c=9                   g=8
    {+g}         g    eg=8      b=13  c=9
    {+c}         c    ch=9      b=5
    {+b}         b    bc=5      -                                  <- sidst
    ```

    Hver "ind"-knude er den med mindste nøgle blandt dem udenfor. Indrækkefølge: $a, h, d, i, f, e, g, c, b$. De otte kanter i "via"-kolonnen er MST'et (9 knuder giver 8 kanter).

    Svar: $b$ kommer ind sidst, så (a).
  ],
)

#qcard(
  tag: [Prim: hvilken knude tilføjes sidst? (Prim)],
  source: "MCQ juni 2015, Spm. 8",
  theory: <th-mst-prim>,
  prompt: [Kør Prims algoritme på grafen med start i knude #swap[$a$]. Den første knude der udtages af prioritetskøen med Extract-Min er $a$. Hvilken knude udtages sidst? Urettede vægtede kanter: $a b=#swap[$17$]$, $a e=11$, $a d=8$, $b e=5$, $e d=18$, $b c=14$, $e c=3$, $c d=25$.],
  options: ([Knuden $b$], [Knuden $c$], [Knuden $d$], [Knuden $e$]),
  answer: [Mulighed (a): #swap[$b$].],
  blueprint: [
    Med en min-prioritetskø er Extract-Min-rækkefølgen den samme som rækkefølgen knuderne føjes til træet. Den sidst udtagne knude er altså den sidst tilføjede.

    + *Sæt nøgler.* Startknuden får nøgle $0$, alle andre $infinity$. Alle knuder ligger i køen.
    + *Extract-Min.* Tag knuden med mindste nøgle ud, og noter rækkefølgen.
    + *Opdater naboer.* For hver nabo der stadig er i køen: er kantvægten mindre end naboens nøgle, så sæt nøglen ned.
    + *Gentag* til køen er tom. Den sidst udtagne knude — den med størst nøgle til sidst — er svaret.
  ],
  worked: [
    Jeg starter med $"key"[a] = 0$ og resten $infinity$; alle knuder ligger i køen. Hvert Extract-Min tager knuden med mindste nøgle ud, og bagefter sænkes naboernes nøgler hvis kanten ind er lettere. Naboer: $a:{b 17, e 11, d 8}$, $d:{e 18, c 25}$, $e:{b 5, c 3}$, $c:{b 14}$.

    ```
    ude    via       nøgler i køen (efter opdatering)
    ---------------------------------------------------
    -      -         a=0  b=inf c=inf d=inf e=inf
    a      start     -    b=17  c=inf d=8   e=11
    d      ad=8      -    b=17  c=25        e=11   (ed=18>11: nej)
    e      ae=11     -    b=5   c=3                (be=5<17, ec=3<25)
    c      ec=3      -    b=5                      (bc=14>5: nej)
    b      eb=5      -    -                                  <- sidst
    ```

    Hver række udtager den mindste nøgle i køen. Udtagsrækkefølge: $a, d, e, c, b$. Sidst ude er $b$ med nøgle 5.

    Svar: $b$.
  ],
)

#qcard(
  tag: [Prim: vælg alle MST-kanter (Prim)],
  source: "MCQ juni 2015, Spm. 9 (flere rigtige)",
  theory: <th-mst-prim>,
  prompt: [Samme graf. Hvilke af nedenstående kanter ligger i det MST som Prims algoritme returnerer? (En eller flere.) Knuder $a, b, c, d, e$ med urettede vægtede kanter: $a b=17$, $a e=11$, $a d=#swap[$8$]$, $b e=5$, $e d=18$, $b c=14$, $e c=3$, $c d=25$.],
  options: ([Kanten $(a, b)$], [Kanten $(b, c)$], [Kanten $(c, d)$], [Kanten $(d, a)$], [Kanten $(b, e)$], [Kanten $(e, d)$]),
  answer: [Mulighed (d) og (e): kanterne $(d, a)$ og $(b, e)$.],
  blueprint: [
    Her er svaret hele kantmængden, ikke en enkelt kant. Da vægtene er forskellige, er MST'et entydigt — kør Prim (eller Kruskal) og tjek hver mulighed mod resultatet.

    + *Kør Prim* fra startknuden og saml de kanter du tager.
    + *Skriv MST'ets kantmængde* op; den er fast når vægtene er forskellige.
    + *Gå mulighederne igennem* og marker hver kant der ligger i MST'et.
    + *Vælg alle* de muligheder hvis kant er med.
  ],
  worked: [
    Samme graf som forrige spørgsmål, men nu skal jeg samle hele MST-kantmængden. Prim fra $a$ tager hvert skridt den letteste kant der krydser ud af træet $C$ og opdaterer nøglerne. Naboer: $a:{b 17, e 11, d 8}$, $d:{e 18, c 25}$, $e:{b 5, c 3}$, $c:{b 14}$.

    ```
    C           ind  via       nøgler udenfor C
    ------------------------------------------------
    {a}          a   -         b=17 c=inf d=8  e=11
    {a,d}        d   ad=8      b=17 c=25       e=11   (ed=18>11: nej)
    {a,d,e}      e   ae=11     b=5  c=3               (be=5<17, ec=3<25)
    {a,d,e,c}    c   ec=3      b=5                    (bc=14>5: nej)
    {a,d,e,c,b}  b   eb=5      -
    ```

    MST'ets kanter er "via"-kolonnen: ${(a,d), (a,e), (e,c), (e,b)}$ med samlet vægt $8 + 11 + 3 + 5 = 27$. Da alle vægte er forskellige, er træet entydigt. Tjek mulighederne mod kantmængden:

    ```
    (a,b)  nej   (b,c)  nej   (c,d)  nej
    (d,a)  JA    (b,e)  JA    (e,d)  nej
    ```

    Svar: $(d, a)$ og $(b, e)$.
  ],
)

#qcard(
  tag: [Kruskal: hvilken kant forkastes først? (Kruskal)],
  source: "MCQ juni 2019, Spm. 17",
  theory: <th-mst-kruskal>,
  prompt: [Kør Kruskals algoritme på grafen $G_3$. Knuder $a, b, c, d, e, f, g, h, i$ med vægtede kanter: $(a,f)=3$, $(a,b)=4$, $(f,g)=8$, $(f,b)=5$, $(g,b)=2$, $(g,c)=6$, $(b,c)=1$, $(h,c)=9$, $(h,d)=6$, $(h,i)=9$, $(i,d)=7$, $(i,e)=1$, $(c,d)=8$, $(d,e)=7$. Hvilken kant er den første der undersøges af algoritmen, men ikke tages med i MST'et?],
  options: ([Kanten $(b, f)$], [Kanten $(c, g)$], [Kanten $(d, i)$], [Kanten $(d, e)$], [Kanten $(f, g)$], [Kanten $(h, i)$]),
  answer: [(a) kanten $(b, f)$, vægt #swap[$5$].],
  blueprint: [
    Den først forkastede kant er den letteste kant hvis to endepunkter allerede ligger i samme komponent når Kruskal når frem til den.

    + *Sortér kanterne efter vægt*, letteste først.
    + *Gå listen igennem* og hold styr på hvilke knuder der hænger sammen.
    + *Den første kant hvor begge endepunkter allerede sidder i samme komponent* laver en kreds. Den er svaret; stop der.
  ],
  worked: [
    Samme graf $G_3$ som tidligere. Den først forkastede kant er den letteste kant hvis to endepunkter allerede ligger i samme komponent. Sorteret kantliste:

    ```
    bc=1  ie=1  gb=2  af=3  ab=4  fb=5  gc=6  hd=6  ...
    ```

    Union-find-tilstand, kør til første forkastning:

    ```
    start:           {a} {b} {c} {d} {e} {f} {g} {h} {i}       taget=0
    bc=1   TAG       {a} {b,c} {d} {e} {f} {g} {h} {i}         taget=1
    ie=1   TAG       {a} {b,c} {d} {e,i} {f} {g} {h}           taget=2
    gb=2   TAG       {a} {b,c,g} {d} {e,i} {f} {h}             taget=3
    af=3   TAG       {a,f} {b,c,g} {d} {e,i} {h}               taget=4
    ab=4   TAG       {a,b,c,f,g} {d} {e,i} {h}                 taget=5
    fb=5   FORKAST   f,b allerede i {a,b,c,f,g} -> kreds        taget=5 <- første forkastning
    ```

    Den første kant hvor begge endepunkter allerede sad i samme komponent er $f b = 5$.

    Svar: $(b,f)$ med vægt 5.
  ],
)

#qcard(
  tag: [Kruskal: hvilken kant forkastes først? (Kruskal)],
  source: "MCQ juni 2021, Spm. 21",
  theory: <th-mst-kruskal>,
  prompt: [Kør Kruskals algoritme på grafen (urettet, vægtet): $e a=#swap[$8$]$, $a g=9$, $g h=10$, $e f=0$, $a c=6$, $g d=7$, $g b=3$, $h b=11$, $f c=12$, $c d=2$, $d b=5$. Hvilken kant er den første der undersøges, men ikke tages med i MST'et?],
  options: ([Kanten $(e, a)$], [Kanten $(a, g)$], [Kanten $(g, h)$], [Kanten $(a, c)$], [Kanten $(g, d)$], [Kanten $(h, b)$]),
  answer: [Mulighed (e): kanten $(g, d)$, vægt #swap[$7$].],
  blueprint: [
    Den først forkastede kant er den letteste kant hvis to endepunkter allerede ligger i samme komponent når Kruskal når frem til den.

    + *Sortér kanterne efter vægt*, letteste først.
    + *Gå listen igennem* og hold styr på hvilke knuder der hænger sammen.
    + *Den første kant hvor begge endepunkter allerede sidder i samme komponent* laver en kreds. Den er svaret; stop der.
  ],
  worked: [
    Samme graf som spørgsmål 22. Den først forkastede kant er den letteste kant hvis to endepunkter allerede sidder i samme komponent. Sorteret kantliste:

    ```
    ef=0  cd=2  gb=3  db=5  ac=6  gd=7  ea=8  ag=9  gh=10  hb=11  fc=12
    ```

    Union-find-tilstand, kør til første forkastning:

    ```
    start:           {a} {b} {c} {d} {e} {f} {g} {h}           taget=0
    ef=0   TAG       {a} {b} {c} {d} {e,f} {g} {h}             taget=1
    cd=2   TAG       {a} {b} {c,d} {e,f} {g} {h}               taget=2
    gb=3   TAG       {a} {b,g} {c,d} {e,f} {h}                 taget=3
    db=5   TAG       {a} {b,c,d,g} {e,f} {h}                   taget=4
    ac=6   TAG       {a,b,c,d,g} {e,f} {h}                     taget=5
    gd=7   FORKAST   g,d allerede i {a,b,c,d,g} -> kreds        taget=5 <- første forkastning
    ```

    Den første kant hvor begge endepunkter allerede lå i samme komponent er $g d = 7$.

    Svar: $(g,d)$ med vægt 7.
  ],
)
