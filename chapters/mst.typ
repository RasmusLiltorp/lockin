#import "../lib.typ": *

== Minimum udspændende træer

Givet en vægtet, sammenhængende, urettet graf (weighted, connected, undirected graph) er et minimum udspændende træ (minimum spanning tree, MST) den billigste måde at forbinde alle knuderne: vælg kanter så alt hænger sammen og den samlede vægt er mindst mulig.

Et udspændende træ (spanning tree) har altid én kant mindre end antal knuder.

#eq[$ |"kanter i MST"| = n - 1 $]

Til eksamen kører du Kruskal eller Prim i hånden. Spørgsmålet er typisk "hvilken kant tilføjes sidst", "hvilken kant forkastes først", eller "hvor mange komponenter er der nu".

=== Sådan løser du den

Begge algoritmer er grådige (greedy) og bygger på samme cut-idé: den letteste kant der krydser et cut gennem grafen er altid sikker at vælge. De adskiller sig kun i, hvordan de vælger næste sikre kant.

#recipe(
  title: "Kruskal — sortér kanterne, tag den letteste der ikke laver en kreds",
  [Giv hver knude sin egen komponent.],
  [Sortér alle kanter efter vægt, letteste først.],
  [Gennemløb kanterne. Tag kant $(u,v)$ hvis $u$ og $v$ ligger i hver sin komponent, og slå komponenterne sammen. Ligger de allerede sammen, laver kanten en kreds: spring den over.],
  [Stop når du har #swap[$n - 1$] kanter.],
)

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
  tag: [Kruskal: hvilken kant tilføjes sidst?],
  source: "MCQ juni 2025, Spm. 21",
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
    9 knuder, så jeg skal bruge 8 kanter.

    + $a c (2)$ #sym.arrow.r tilføjes.
    + $f g (3)$ #sym.arrow.r tilføjes.
    + $b e (5)$ #sym.arrow.r tilføjes.
    + $f h (6)$ #sym.arrow.r tilføjes.
    + $b f (8)$ #sym.arrow.r tilføjes (binder ${b,e}$ og ${f,g,h}$ sammen).
    + $e j (9)$ #sym.arrow.r tilføjes.
    + $e h (11)$ #sym.arrow.r forkastes; $e$ og $h$ sidder allerede sammen via $e$–$b$–$f$–$h$.
    + $i j (14)$ #sym.arrow.r tilføjes.
    + $a b (15)$ #sym.arrow.r tilføjes; den hægter ${a,c}$ på resten og er kant nummer 8.

    Svar: $(a,b)$, den sidste kant ind.
  ],
)

#qcard(
  tag: [Kruskal: hvilken kant tilføjes sidst?],
  source: "MCQ juni 2021, Spm. 22",
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
    8 knuder, så jeg skal bruge 7 kanter.

    + $e f (0)$ #sym.arrow.r tilføjes.
    + $c d (2)$ #sym.arrow.r tilføjes.
    + $g b (3)$ #sym.arrow.r tilføjes.
    + $d b (5)$ #sym.arrow.r tilføjes.
    + $a c (6)$ #sym.arrow.r tilføjes.
    + $g d (7)$ #sym.arrow.r forkastes; $g$ og $d$ sidder allerede sammen.
    + $e a (8)$ #sym.arrow.r tilføjes (kant nummer 6).
    + $a g (9)$ #sym.arrow.r forkastes.
    + $g h (10)$ #sym.arrow.r tilføjes; kant nummer 7 og dermed den sidste.
    + $h b (11)$ og $f c (12)$ #sym.arrow.r forkastes begge.

    Svar: $(g, h)$ med vægt 10, den sidste kant ind.
  ],
)

#qcard(
  tag: [Kruskal: antal komponenter ved første forkastning],
  source: "MCQ juni 2025, Spm. 22",
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
    Her er $n = 9$. Jeg tager kanterne i vægtrækkefølge og tæller med.

    + $a c (2)$, $f g (3)$, $b e (5)$, $f h (6)$, $b f (8)$, $e j (9)$ #sym.arrow.r seks kanter taget.
    + $e h (11)$ #sym.arrow.r forkastes; $e$ og $h$ hænger allerede sammen via $e$–$b$–$f$–$h$. Det er den første kant der ryger ud.

    Med $k = 6$ tagne kanter: $9 - 6 = 3$.

    Svar: 3 komponenter.
  ],
)

#qcard(
  tag: [Kruskal: antal komponenter ved første forkastning],
  source: "MCQ juni 2019, Spm. 18",
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
    Her er $n = 9$. Jeg undersøger kanterne i vægtrækkefølge og tæller de otte første.

    + $i e (1)$ tages, $b c (1)$ tages, $g b (2)$ tages, $a f (3)$ tages, $a b (4)$ tages.
    + $f b (5)$ #sym.arrow.r forkastes (kreds).
    + $g c (6)$ #sym.arrow.r forkastes (kreds).
    + $h d (6)$ #sym.arrow.r tages.

    Otte kanter undersøgt, heraf $k = 6$ taget: $9 - 6 = 3$. Komponenterne er ${a,b,c,f,g}$, ${h,d}$ og ${i,e}$.

    Svar: 3 komponenter.
  ],
)

#qcard(
  tag: [Prim: hvilken knude tilføjes sidst?],
  source: "MCQ juni 2023, Spm. 20",
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
    Jeg vokser $C$ ud fra $a$. Hvert skridt tager den letteste kant ud af $C$ og trækker en ny knude ind, og den kant er en MST-kant.

    #table(
      columns: 3,
      align: (center, center, left),
      stroke: 0.4pt + hair,
      inset: (x: 9pt, y: 5pt),
      table.header([*Skridt*], [*Knude ind*], [*Kant taget*]),
      [1], [$h$], [$a h = 2$],
      [2], [$d$], [$h d = 1$],
      [3], [$i$], [$a i = 3$],
      [4], [$f$], [$f i = 4$],
      [5], [$e$], [$f e = 7$],
      [6], [$g$], [$e g = 8$],
      [7], [$c$], [$c h = 9$],
      [8], [$b$], [$b c = 5$],
    )
    De otte kanter i højre kolonne er MST'et (9 knuder giver 8 kanter).

    Svar: $b$ kommer ind sidst, så (a).
  ],
)

#qcard(
  tag: [Prim: hvilken knude tilføjes sidst?],
  source: "MCQ juni 2015, Spm. 8",
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
    Jeg starter med $"key"[a] = 0$ og resten $infinity$.

    + Extract $a$. Opdater: $b = 17$, $e = 11$, $d = 8$.
    + Mindste nøgle er $d (8)$. Extract $d$. Naboer $e (18 > 11)$ og $c (25)$ giver ingen forbedring.
    + Mindste nøgle er $e (11)$. Extract $e$. Opdater $b -> 5$, $c -> 3$.
    + Mindste nøgle er $c (3)$. Extract $c$. $b (14)$ giver ingen forbedring.
    + Tilbage er $b (5)$. Extract $b$ til sidst.

    Udtagsrækkefølge: $a, d, e, c, b$. Sidst ude er $b$.

    Svar: $b$.
  ],
)

#qcard(
  tag: [Prim: vælg alle MST-kanter],
  source: "MCQ juni 2015, Spm. 9 (flere rigtige)",
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
    Prim fra $a$ tager den letteste kant ud af træet hvert skridt:

    + $a d = 8$ #sym.arrow.r ind.
    + $a e = 11$ #sym.arrow.r ind.
    + $e c = 3$ #sym.arrow.r ind.
    + $e b = 5$ #sym.arrow.r ind.

    MST'et er ${(a,d), (a,e), (e,c), (b,e)}$ med samlet vægt $27$. Tjek mulighederne: $(a,b)$ nej, $(b,c)$ nej, $(c,d)$ nej, $(d,a)$ ja, $(b,e)$ ja, $(e,d)$ nej.

    Svar: $(d, a)$ og $(b, e)$.
  ],
)

#qcard(
  tag: [Kruskal: hvilken kant forkastes først?],
  source: "MCQ juni 2019, Spm. 17",
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
    Jeg tager kanterne i vægtrækkefølge og holder øje med komponenterne.

    + $b c (1)$ #sym.arrow.r tilføjes.
    + $i e (1)$ #sym.arrow.r tilføjes.
    + $g b (2)$ #sym.arrow.r tilføjes.
    + $a f (3)$ #sym.arrow.r tilføjes.
    + $a b (4)$ #sym.arrow.r tilføjes; nu er ${a,b,c,f,g}$ samlet i én komponent.
    + $f b (5)$ #sym.arrow.r forkastes; både $f$ og $b$ ligger i den komponent, så kanten laver en kreds.

    Svar: $(b,f)$ med vægt 5, den første kant der springes over.
  ],
)

#qcard(
  tag: [Kruskal: hvilken kant forkastes først?],
  source: "MCQ juni 2021, Spm. 21",
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
    Jeg tager kanterne i vægtrækkefølge og holder øje med komponenterne.

    + $e f (0)$ #sym.arrow.r tilføjes.
    + $c d (2)$ #sym.arrow.r tilføjes.
    + $g b (3)$ #sym.arrow.r tilføjes.
    + $d b (5)$ #sym.arrow.r tilføjes; binder ${c,d}$ og ${g,b}$ sammen til ${c,d,g,b}$.
    + $a c (6)$ #sym.arrow.r tilføjes; hægter $a$ på ${a,c,d,g,b}$.
    + $g d (7)$ #sym.arrow.r forkastes; $g$ og $d$ ligger allerede i samme komponent.

    Svar: $(g,d)$ med vægt 7, den første kant der springes over.
  ],
)
