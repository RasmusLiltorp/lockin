#import "../lib.typ": *

== Bevismetoder

Et bevis (proof) viser, at en påstand gælder i hvert tilfælde, den dækker. Til eksamen skal du bevise eller modbevise korte påstande om hele og rationale tal, eller vælge det gyldige bevis fra en menu. Tre metoder dækker næsten alt: direkte (direct), kontraposition (contraposition) og modstrid (contradiction).

Først oversætter du ordene til algebra. Et lige tal er

#eq[$ 2k $]

et ulige tal er

#eq[$ 2k + 1 $]

for et heltal $k$. Et rationalt tal (rational number) er en brøk

#eq[$ a/b, quad a, b in ZZ, quad b != 0. $]

For "irrationel" (irrational) findes ingen formel. Du antager det modsatte — at tallet *er* rationelt — og rammer en modstrid.

=== Sådan løser du den

#metadata(none) <th-proof-direct>
#recipe(
  title: "Direkte bevis — for P ⟹ Q",
  [Antag $P$. Skriv hver hypotese på algebraform: #swap[ulige] $= 2k+1$, #swap[lige] $= 2k$.],
  [Byg udtrykket, påstanden handler om — typisk #swap[summen] eller #swap[produktet].],
  [Reducer. Sæt $2$ uden for parentes for *lige*, eller skriv på formen $2 dot ("heltal") + 1$ for *ulige*.],
  [Konkludér, at udtrykket har den påståede form. Så gælder $Q$.],
)

#metadata(none) <th-proof-contra>
#recipe(
  title: "Kontraposition — for P ⟹ Q",
  [Skriv den kontraponerede (contrapositive) $not Q arrow.r not P$. Negér begge sider: f.eks. $not Q$ = "#swap[$n$ er ulige]" og $not P$ = "#swap[$n^3 + 5$ er lige]".],
  [Antag $not Q$, og bevis $not P$ ved direkte udregning.],
  [Det er nok: $not Q arrow.r not P$ er logisk det samme som $P arrow.r Q$.],
)

#metadata(none) <th-proof-contradiction>
#recipe(
  title: "Modstrid — for \"X er irrationel\" eller en vilkårlig P ⟹ Q",
  [Antag det modsatte. For "irrationel": antag at #swap[$r x$] *er* rationel, altså $= c/d$ med heltal og $d != 0$. For $P arrow.r Q$: antag $P and not Q$.],
  [Brug de øvrige rationale hypoteser (på brøkform) til at isolere den faktor, der skulle være irrationel.],
  [Vis, at faktoren kommer ud som rationel. Det modsiger antagelsen, som dermed falder.],
)

Et fjerde greb dækker "bevis eller modbevis" om en for-alle-påstand: ét modeksempel (counterexample) slår den ihjel.

#note(title: [Modeksempel først])[Ved "bevis eller modbevis" prøv et modeksempel først. Vælg "pæne" værdier, der falder sammen. F.eks. modbeviser $sqrt(2) dot sqrt(2) = 2$ påstanden om, at produktet af to irrationale tal altid er irrationelt.]

#trap(title: [Ikke den omvendte])[Kontraposition er $not Q arrow.r not P$, ikke den omvendte (converse) $Q arrow.r P$. Den omvendte er den hyppigste forkerte MCQ-mulighed. Negér en disjunktion (disjunction) med De Morgan: $not(a > c/2 or b > c/2)$ bliver $a <= c/2 and b <= c/2$, altså et *OG*.]

#trap(title: [Forskellig fra nul])[En "forskellig fra nul"-hypotese bærer ofte hele beviset. I "(rationalt $!= 0$) $times$ (irrationelt) er irrationelt" er det $r != 0$, der lader dig dividere med $r$. Drop den, og beviset bryder sammen, for $0 dot x = 0$ er rationel.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Bevismetode: direkte bevis om lige/ulige (direkte bevis)],
  source: "DM04 Opg 1 (Rosen 1.7 #1)",
  theory: <th-proof-direct>,
  prompt: [Brug et direkte bevis til at vise, at #swap[summen] af to #swap[ulige] heltal er #swap[lige].],
  answer: [Sandt. Summen af to ulige tal er $2(a+b+1)$, altså lige.],
  blueprint: [
    Direkte bevis: antag forudsætningen og regn dig frem til konklusionen.

    + *Oversæt til algebra.* Skriv hver #swap[ulige] størrelse som $2k+1$ med sit eget heltal, så $2a+1$ og $2b+1$.
    + *Byg udtrykket op.* Stil det op, påstanden handler om, her #swap[summen] $m+n$.
    + *Reducer til formen.* Saml led og sæt $2$ uden for parentes, så du står med $2 dot ("heltal")$ for #swap[lige].
    + *Konkludér.* Udtrykket har formen, konklusionen kræver. $#sym.arrow.r$ påstanden gælder.
  ],
  worked: [
    Vi skal vise: er $m$ og $n$ begge ulige, så er $m + n$ lige. Det er en implikation $P arrow.r Q$, så vi antager forudsætningen $P$ (begge ulige) og regner os frem til konklusionen $Q$ (summen lige).

    + *Oversæt forudsætningen til algebra.* "Ulige" betyder "to gange et heltal, plus én". De to tal behøver ikke det samme heltal, så hvert får sit eget:
      #eq[$ m = 2a + 1, quad n = 2b + 1, quad a\, b in ZZ. $]

    + *Byg udtrykket, påstanden handler om.* Påstanden er om #swap[summen], så vi stiller $m + n$ op og indsætter:
      #eq[$ m + n = (2a + 1) + (2b + 1). $]

    + *Reducer.* Fjern parenteserne og saml leddene. De to ettaller giver $2$:
      #eq[$ (2a + 1) + (2b + 1) = 2a + 2b + 1 + 1 = 2a + 2b + 2. $]

    + *Sæt $2$ uden for parentes.* Alle tre led er delelige med $2$:
      #eq[$ 2a + 2b + 2 = 2(a + b + 1). $]

    + *Konkludér.* Sæt $t = a + b + 1$. Summen af heltal er et heltal, så $t in ZZ$, og
      #eq[$ m + n = 2t. $]
      Et tal på formen $2t$ med $t$ heltal er per definition lige. Dermed er $m + n$ lige, og $Q$ gælder.

    Svar: summen af to ulige heltal er lige. $qed$
  ],
)

#qcard(
  tag: [Bevismetode: kontraposition og modstrid (kontraposition)],
  source: "DM04 Opg 17 (Rosen 1.7 #17)",
  theory: <th-proof-contra>,
  prompt: [Vis, at hvis $n$ er et heltal og #swap[$n^3 + 5$] er ulige, så er #swap[$n$] lige — ved (a) kontraposition, (b) modstrid.],
  answer: [Begge virker. Ulige $n$ gør $n^3$ ulige, så $n^3 + 5 = "ulige" + "ulige" = "lige"$.],
  blueprint: [
    To veje til samme mål for en påstand $P #sym.arrow.r Q$.

    + *Kontraposition.* Vend påstanden til $not Q #sym.arrow.r not P$ og bevis den direkte.
      + Negér hver side. Her bliver $not Q$ til "#swap[$n$ er ulige]" og $not P$ til "#swap[$n^3+5$ er lige]".
      + Antag $not Q$, regn dig frem til $not P$. Det dækker det oprindelige.
    + *Modstrid.* Antag både $P$ og $not Q$ på én gang og jagt en modstrid.
      + Brug antagelserne til at udlede to ting, der ikke kan passe sammen.
      + Når det krakelerer, må $not Q$ falde, så $Q$ står tilbage.
  ],
  worked: [
    Påstanden er $P arrow.r Q$ med $P:$ "$n^3+5$ er ulige" og $Q:$ "$n$ er lige".

    *(a) Kontraposition.* Den kontraponerede er $not Q arrow.r not P$. Negationerne er $not Q:$ "$n$ er ulige" og $not P:$ "$n^3+5$ er lige". Vi skal altså vise: er $n$ ulige, så er $n^3+5$ lige.

    + *Antag $not Q$.* Sæt $n = 2k+1$ for et heltal $k$.
    + *Regn $n^3$ ud.* Brug $(2k+1)^3 = 8k^3 + 12k^2 + 6k + 1$:
      #eq[$ n^3 = 8k^3 + 12k^2 + 6k + 1 = 2(4k^3 + 6k^2 + 3k) + 1. $]
      Med $j = 4k^3 + 6k^2 + 3k in ZZ$ er $n^3 = 2j + 1$, altså ulige.
    + *Læg $5$ til.* Da $5 = 2 dot 2 + 1$:
      #eq[$ n^3 + 5 = (2j + 1) + 5 = 2j + 6 = 2(j + 3). $]
      Med $j + 3 in ZZ$ har $n^3+5$ formen $2 dot ("heltal")$, så det er lige. Det er $not P$.
    + *Konkludér.* Vi har vist $not Q arrow.r not P$, som er logisk ækvivalent med $P arrow.r Q$. Altså holder det oprindelige. $qed$

    *(b) Modstrid.* Antag $P$ og $not Q$ samtidig, og jagt en modsigelse. Altså: $n^3+5$ er ulige (det er $P$), og $n$ er ulige (det er $not Q$).

    + *Brug $not Q$.* Som i (a) giver $n = 2k+1$ at $n^3 = 2j+1$ er ulige.
    + *Læg $5$ til.* Igen $n^3 + 5 = 2j + 6 = 2(j+3)$, altså lige.
    + *Find modstriden.* Vi har nu udledt, at $n^3+5$ er lige. Men antagelsen $P$ siger, at $n^3+5$ er ulige. Et tal kan ikke være både lige og ulige. Modstrid.
    + *Konkludér.* Antagelsen $P and not Q$ kan ikke holde. Da $P$ er givet, må $not Q$ falde, så $Q$ gælder: $n$ er lige.

    Svar: $n$ er lige. $qed$
  ],
)

#qcard(
  tag: [Bevismetode: modstrid om rationalt/irrationelt (modstrid)],
  source: "DM04 Opg 41 (Rosen 1.7 #41)",
  theory: <th-proof-contradiction>,
  prompt: [Bevis eller modbevis: produktet af et #swap[rationalt tal forskelligt fra nul] og et #swap[irrationelt] tal er irrationelt.],
  answer: [Sandt. Bevises ved modstrid.],
  blueprint: [
    Skal du vise, at noget er irrationelt, findes der ingen formel for "irrationel". Antag det modsatte i stedet.

    + *Skriv det rationale på brøkform.* Det #swap[rationale tal] bliver $a/b$ med heltal og nævner $!= 0$.
    + *Antag modstrid.* Antag, at #swap[hele produktet] også er rationelt, altså $= c/d$ med heltal og $d != 0$.
    + *Isolér den faktor, der skulle være irrationel.* Løs ligningen, så den #swap[irrationelle] størrelse står alene.
    + *Vis den kommer ud som brøk.* Hvis den ender som heltal over heltal med nævner $!= 0$, er den rationel. Det modsiger antagelsen, som dermed falder.
  ],
  worked: [
    Påstanden er sand. Der findes ingen formel for "irrationel", så vi beviser den ved modstrid: antag det modsatte og udled noget umuligt.

    Lad $r$ være rationel med $r != 0$, og lad $x$ være irrationel. Vi vil vise, at produktet $r x$ er irrationelt.

    + *Skriv det rationale på brøkform.* Da $r$ er rationel og $!= 0$:
      #eq[$ r = a/b, quad a\, b in ZZ, quad b != 0, quad a != 0. $]
      Bemærk $a != 0$: var $a = 0$, ville $r = 0$, og det er udelukket. Denne "$!= 0$"-detalje bærer hele beviset.
    + *Antag modstrid.* Antag, at $r x$ alligevel er rationel. Så kan den skrives som en brøk:
      #eq[$ r x = c/d, quad c\, d in ZZ, quad d != 0. $]
    + *Isolér $x$.* Da $r != 0$ kan vi dividere med $r$, dvs. gange med $1/r = b/a$:
      #eq[$ x = (r x)/r = c/d dot b/a = (c b)/(d a). $]
    + *Vis, at $x$ kommer ud som brøk.* Tælleren $c b$ er et heltal (produkt af heltal), og nævneren $d a$ er et heltal. Nævneren er ikke nul: $d != 0$ og $a != 0$, så $d a != 0$. Dermed er $x$ skrevet som heltal over heltal med nævner $!= 0$, altså rationel.
    + *Find modstriden.* Vi forudsatte, at $x$ er irrationel, men har netop udledt, at $x$ er rationel. Et tal er enten det ene eller det andet, aldrig begge. Modstrid.
    + *Konkludér.* Antagelsen om at $r x$ er rationel kan ikke holde. Altså er $r x$ irrationel.

    Svar: produktet $r x$ er irrationelt. $qed$
  ],
)

#qcard(
  tag: [Bevismetode: vælg det gyldige bevis (kontraposition)],
  source: "MCQ juni 2021, Spm. 36",
  theory: <th-proof-contra>,
  prompt: [Angiv et korrekt bevis for: $a + b > c arrow.r a > #swap[$c/2$] or b > #swap[$c/2$]$.],
  options: (
    [$a+b>c arrow.r a > c - c/2 arrow.r a > c/2 arrow.r a > c/2 or b > c/2$],
    [$a+b <= c arrow.r a <= c - b arrow.r a <= c/2 or b <= c/2$],
    [$a > c/2 or b > c/2 arrow.r a + b > c/2 + c/2 arrow.r a + b > c$],
    [$a <= c/2 and b <= c/2 arrow.r a + b <= c/2 + c/2 arrow.r a + b <= c$],
    [$a < c/2 or b < c/2 arrow.r 2a < c or 2b < c arrow.r a + b < c$],
  ),
  answer: [Mulighed (d): $a <= c/2 and b <= c/2 arrow.r a+b <= c/2 + c/2 arrow.r a+b <= c$. Et gyldigt kontrapositionsbevis.],
  blueprint: [
    Skal du plukke det gyldige bevis ud af en menu, så tjek hver mulighed mod logikken i stedet for at lade dig friste af noget, der ligner.

    + *Skriv $P$ og $Q$ ned.* Find forudsætningen og konklusionen i #swap[implikationen].
    + *Negér begge med De Morgan.* Et #swap[*eller*] i $Q$ bliver til et *og* i $not Q$, og omvendt.
    + *Find buddet, der viser $not Q #sym.arrow.r not P$.* Det er en gyldig kontraposition.
    + *Sortér fælderne fra.* Pas på den omvendte $Q #sym.arrow.r P$, en sjusket negation og skarpe uligheder, der er smuttet ind.
  ],
  worked: [
    Her er $P: a+b>c$ og $Q: a > c/2 or b > c/2$. Et gyldigt kontrapositionsbevis viser $not Q arrow.r not P$.

    + *Negér begge sider med De Morgan.* I $Q$ står et *eller*, så $not Q$ bliver et *og*, og hver skarpe $>$ vendes til $<=$:
      #eq[$ not Q: quad a <= c/2 and b <= c/2. $]
      $not P$ er negationen af $a+b>c$:
      #eq[$ not P: quad a + b <= c. $]
    + *Bevis $not Q arrow.r not P$ direkte.* Antag $not Q$. Begge uligheder peger samme vej ($<=$), så de må lægges sammen led for led:
      #eq[$ a + b <= c/2 + c/2 = c. $]
      Det er netop $not P$. Kæden $a <= c/2 and b <= c/2 arrow.r a+b <= c/2 + c/2 arrow.r a+b <= c$ er præcis mulighed (d).

    + *Sortér fælderne fra, mulighed for mulighed:*
      - *(a)* $a+b>c arrow.r a > c - c/2 arrow.r a > c/2 or ...$: skridtet $a + b > c arrow.r a > c - c/2$ kræver, at man erstatter $b$ med $c/2$, men der er ingen grund til $b <= c/2$. $b$ tabes undervejs. Ugyldigt.
      - *(b)* $a + b <= c arrow.r a <= c - b arrow.r a <= c/2 or b <= c/2$: negationen af $Q$ skal give et *og*, ikke et *eller*. Forkert De Morgan. Ugyldigt.
      - *(c)* $a > c/2 or b > c/2 arrow.r a+b > c$: dette starter fra $Q$ og slutter i $P$, altså den omvendte $Q arrow.r P$. Den omvendte er ikke det samme som $P arrow.r Q$. Desuden følger $a+b>c$ ikke af, at kun ét af tallene er $> c/2$. Ugyldigt.
      - *(e)* $a < c/2 or b < c/2 arrow.r 2a < c or 2b < c arrow.r a+b<c$: bruger skarp $<$ (skal være $<=$) og en forkert negation, og $a+b<c$ følger ikke af, at ét tal er lille. Ugyldigt.

    Svar: mulighed (d) er det eneste gyldige kontrapositionsbevis. $qed$
  ],
)
