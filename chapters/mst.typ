#import "../lib.typ": *

== Minimum udspændende træer

Givet en vægtet, sammenhængende, urettet graf er et minimum udspændende træ (MST) den billigste måde at forbinde alle knuderne: vælg kanter så alt hænger sammen og den samlede vægt er mindst mulig.

Et udspændende træ har altid én kant mindre end antal knuder.

#eq[$ |"kanter i MST"| = n - 1 $]

Til eksamen kører du Kruskal eller Prim i hånden. Spørgsmålet er typisk "hvilken kant tilføjes sidst", "hvilken kant forkastes først", eller "hvor mange komponenter er der nu".

=== Sådan løser du den

Begge algoritmer er grådige og bygger på samme cut-idé: den letteste kant der krydser et cut gennem grafen er altid sikker at vælge. De adskiller sig kun i, hvordan de vælger næste sikre kant.

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
  [Find den letteste kant der går fra $C$ ud til en knude udenfor. Tag kanten, og læg den nye knude ind i $C$.],
  [Gentag til alle knuder er i $C$.],
)

#note[Er alle kantvægte forskellige, er MST'et entydigt: Kruskal og Prim giver samme træ, selv om de tager kanterne i hver sin rækkefølge.]

#trap[Kruskal ser på alle kanter i vægtrækkefølge. Prim ser kun på kanter der rører den knudemængde han har bygget. De tager derfor sjældent kanterne i samme rækkefølge.]

#trap[En kant forkastes netop når begge endepunkter allerede sidder i samme komponent — det ville give en kreds.]

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
  worked: [9 knuder, så 8 kanter. Letteste først: $a c (2)$, $f g (3)$, $b e (5)$, $f h (6)$, $b f (8)$, $e j (9)$, spring $e h (11)$ over (kreds), $i j (14)$. Til sidst binder $a b (15)$ ${a,c}$ til resten — den 8. og sidste kant.],
)

#qcard(
  tag: [Kruskal: antal komponenter ved første forkastning],
  source: "MCQ juni 2025, Spm. 22",
  prompt: [Fortsæt med Kruskals algoritme på samme graf. I det første øjeblik hvor en undersøgt kant ikke tages med, hvor mange sammenhængskomponenter har $(V, A)$? ($V$ er alle knuder, $A$ er de kanter der er taget indtil nu.)],
  options: ([$1$], [$2$], [$3$], [$4$], [$5$], [$6$]),
  answer: [(c) #swap[$3$].],
  worked: [$n = 9$. Tagne kanter: $a c (2)$, $f g (3)$, $b e (5)$, $f h (6)$, $b f (8)$, $e j (9)$ — 6 stk. Næste, $e h (11)$, er den første forkastede ($e$ og $h$ allerede forbundet via $e$–$b$–$f$–$h$). Med 6 kanter: $9 - 6 = 3$ komponenter.],
)

#qcard(
  tag: [Prim: hvilken knude tilføjes sidst?],
  source: "MCQ juni 2023, Spm. 20",
  prompt: [Brug Prims algoritme til at finde et MST med start i knude #swap[$a$]. Urettede vægtede kanter: $b c=5$, $c a=11$, $a f=10$, $f e=7$, $b d=13$, $c h=9$, $a h=2$, $a i=3$, $f i=4$, $e g=8$, $d h=1$, $h i=6$, $i g=12$. Hvilken knude tilføjes sidst til MST'et?],
  options: ([$b$], [$d$], [$e$], [$g$]),
  answer: [(a) #swap[$b$].],
  worked: [Voks $C$ fra $a$, hvert skridt letteste kant ud af $C$: $a h (2) arrow.r h$, $h d (1) arrow.r d$, $a i (3) arrow.r i$, $f i (4) arrow.r f$, $f e (7) arrow.r e$, $e g (8) arrow.r g$, $c h (9) arrow.r c$, $b c (5) arrow.r b$. Sidst er $b$.],
)

#qcard(
  tag: [Kruskal: hvilken kant forkastes først?],
  source: "MCQ juni 2019, Spm. 17",
  prompt: [Kør Kruskals algoritme på grafen $G_3$. Knuder $a, b, c, d, e, f, g, h, i$ med vægtede kanter: $(a,f)=3$, $(a,b)=4$, $(f,g)=8$, $(f,b)=5$, $(g,b)=2$, $(g,c)=6$, $(b,c)=1$, $(h,c)=9$, $(h,d)=6$, $(h,i)=9$, $(i,d)=7$, $(i,e)=1$, $(c,d)=8$, $(d,e)=7$. Hvilken kant er den første der undersøges af algoritmen, men ikke tages med i MST'et?],
  options: ([Kanten $(b, f)$], [Kanten $(c, g)$], [Kanten $(d, i)$], [Kanten $(d, e)$], [Kanten $(f, g)$], [Kanten $(h, i)$]),
  answer: [(a) kanten $(b, f)$, vægt #swap[$5$].],
  worked: [Letteste først: $b c (1)$, $i e (1)$, $g b (2)$, $a f (3)$, $a b (4)$ — nu er ${a,b,c,f,g}$ én komponent. Næste, $(f,b)=5$, har begge endepunkter i den komponent: en kreds, og den første forkastede kant.],
)
