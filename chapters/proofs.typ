#import "../lib.typ": *

== Bevismetoder

Et bevis viser, at en påstand gælder i hvert tilfælde, den dækker. Til eksamen skal du bevise eller modbevise korte påstande om hele og rationale tal, eller vælge det gyldige bevis fra en menu. Tre metoder dækker næsten alt: direkte, kontraposition og modstrid.

Først oversætter du ordene til algebra. Et lige tal er

#eq[$ 2k $]

et ulige tal er

#eq[$ 2k + 1 $]

for et heltal $k$. Et rationalt tal er en brøk

#eq[$ a/b, quad a, b in ZZ, quad b != 0. $]

For "irrationel" findes ingen formel. Du antager det modsatte — at tallet *er* rationelt — og rammer en modstrid.

=== Sådan løser du den

#recipe(
  title: "Direkte bevis — for P ⟹ Q",
  [Antag $P$. Skriv hver hypotese på algebraform: #swap[ulige] $= 2k+1$, #swap[lige] $= 2k$.],
  [Byg udtrykket, påstanden handler om — typisk #swap[summen] eller #swap[produktet].],
  [Reducer. Sæt $2$ uden for parentes for *lige*, eller skriv på formen $2 dot ("heltal") + 1$ for *ulige*.],
  [Konkludér, at udtrykket har den påståede form. Så gælder $Q$.],
)

#recipe(
  title: "Kontraposition — for P ⟹ Q",
  [Skriv den kontraponerede $not Q arrow.r not P$. Negér begge sider: f.eks. $not Q$ = "#swap[$n$ er ulige]" og $not P$ = "#swap[$n^3 + 5$ er lige]".],
  [Antag $not Q$, og bevis $not P$ ved direkte udregning.],
  [Det er nok: $not Q arrow.r not P$ er logisk det samme som $P arrow.r Q$.],
)

#recipe(
  title: "Modstrid — for \"X er irrationel\" eller en vilkårlig P ⟹ Q",
  [Antag det modsatte. For "irrationel": antag at #swap[$r x$] *er* rationel, altså $= c/d$ med heltal og $d != 0$. For $P arrow.r Q$: antag $P and not Q$.],
  [Brug de øvrige rationale hypoteser (på brøkform) til at isolere den faktor, der skulle være irrationel.],
  [Vis, at faktoren kommer ud som rationel. Det modsiger antagelsen, som dermed falder.],
)

Et fjerde greb dækker "bevis eller modbevis" om en for-alle-påstand: ét modeksempel slår den ihjel.

#note(title: [Modeksempel først])[Ved "bevis eller modbevis" prøv et modeksempel først. Vælg "pæne" værdier, der falder sammen. F.eks. modbeviser $sqrt(2) dot sqrt(2) = 2$ påstanden om, at produktet af to irrationale tal altid er irrationelt.]

#trap(title: [Ikke den omvendte])[Kontraposition er $not Q arrow.r not P$, ikke den omvendte $Q arrow.r P$. Den omvendte er den hyppigste forkerte MCQ-mulighed. Negér en disjunktion med De Morgan: $not(a > c/2 or b > c/2)$ bliver $a <= c/2 and b <= c/2$, altså et *OG*.]

#trap(title: [Forskellig fra nul])[En "forskellig fra nul"-hypotese bærer ofte hele beviset. I "(rationalt $!= 0$) $times$ (irrationelt) er irrationelt" er det $r != 0$, der lader dig dividere med $r$. Drop den, og beviset bryder sammen, for $0 dot x = 0$ er rationel.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Bevismetode: direkte bevis om lige/ulige],
  source: "DM04 Opg 1 (Rosen 1.7 #1)",
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
    Her er $m = 2a+1$ og $n = 2b+1$ for heltal $a, b$.

    + Læg de to sammen:
      #eq[$ m + n = (2a+1) + (2b+1) = 2a + 2b + 2 = 2(a+b+1). $]
    + $a+b+1$ er et heltal, kald det $t$, så $m + n = 2t$.
    + Et tal på formen $2t$ er lige.

    Svar: summen er lige. $qed$
  ],
)

#qcard(
  tag: [Bevismetode: kontraposition og modstrid],
  source: "DM04 Opg 17 (Rosen 1.7 #17)",
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
    Påstand: er #swap[$n^3+5$] ulige, så er #swap[$n$] lige.

    *(a) Kontraposition.* Vis i stedet: er $n$ ulige, så er $n^3+5$ lige.

    + Sæt $n = 2k+1$. Så er $n^3$ ulige, sig $n^3 = 2j+1$.
    + Læg $5$ til:
      #eq[$ n^3 + 5 = 2j + 6 = 2(j+3), $]
      som er lige.
    + Den kontraponerede holder, så det oprindelige holder også. $qed$

    *(b) Modstrid.* Antag $n^3+5$ ulige og samtidig $n$ ulige.

    + Ulige $n$ gør $n^3$ ulige.
    + Så er $n^3 + 5 = "ulige" + "ulige" = "lige"$.
    + Det strider mod, at $n^3+5$ skulle være ulige.

    Svar: $n$ er lige. $qed$
  ],
)

#qcard(
  tag: [Bevismetode: modstrid om rationalt/irrationelt],
  source: "DM04 Opg 41 (Rosen 1.7 #41)",
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
    Lad $r$ være rationel og $!= 0$, og lad $x$ være irrationel.

    + Skriv $r = a/b$ med heltal $a != 0$ og $b != 0$.
    + Antag for modstrid, at $r x$ er rationel, sig $r x = c/d$ med heltal $c, d$ og $d != 0$.
    + Isolér $x$:
      #eq[$ x = (r x)/r = (c\/d)/(a\/b) = (c b)/(d a). $]
    + Her er $d a != 0$, fordi $a != 0$ og $d != 0$, og både $c b$ og $d a$ er heltal. Så er $x$ rationel.
    + Det strider mod, at $x$ er irrationel.

    Svar: $r x$ er irrationel. $qed$
  ],
)

#qcard(
  tag: [Bevismetode: vælg det gyldige bevis],
  source: "MCQ juni 2021, Spm. 36",
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
    Her er $P: a+b>c$ og $Q: a > c/2 or b > c/2$.

    + Negér med De Morgan: $not Q$ er $a <= c/2 and b <= c/2$, og $not P$ er $a+b <= c$.
    + Antag $not Q$ og læg de to uligheder sammen:
      #eq[$ a + b <= c/2 + c/2 = c, $]
      altså $not P$. Det er præcis mulighed (d).
    + Tjek resten:
      - (a) dropper $b$ undervejs.
      - (b) negerer forkert med De Morgan.
      - (c) beviser den omvendte $Q arrow.r P$.
      - (e) bruger skarp $<$ og en forkert negation.

    Svar: mulighed (d). $qed$
  ],
)
