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

#note[Ved "bevis eller modbevis" prøv et modeksempel først. Vælg "pæne" værdier, der falder sammen. F.eks. modbeviser $sqrt(2) dot sqrt(2) = 2$ påstanden om, at produktet af to irrationale tal altid er irrationelt.]

#trap[Kontraposition er $not Q arrow.r not P$, ikke den omvendte $Q arrow.r P$. Den omvendte er den hyppigste forkerte MCQ-mulighed. Negér en disjunktion med De Morgan: $not(a > c/2 or b > c/2)$ bliver $a <= c/2 and b <= c/2$, altså et *OG*.]

#trap[En "forskellig fra nul"-hypotese bærer ofte hele beviset. I "(rationalt $!= 0$) $times$ (irrationelt) er irrationelt" er det $r != 0$, der lader dig dividere med $r$. Drop den, og beviset bryder sammen, for $0 dot x = 0$ er rationel.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  source: "DM04 Opg 1 (Rosen 1.7 #1)",
  prompt: [Brug et direkte bevis til at vise, at #swap[summen] af to #swap[ulige] heltal er #swap[lige].],
  answer: [Sandt. Summen af to ulige tal er $2(a+b+1)$, altså lige.],
  worked: [Lad $m = 2a+1$ og $n = 2b+1$ for heltal $a, b$. Så er
  #eq[$ m + n = (2a+1) + (2b+1) = 2a + 2b + 2 = 2(a+b+1). $]
  $a+b+1$ er et heltal, så $m+n = 2 dot ("heltal")$ er lige. $qed$],
)

#qcard(
  source: "DM04 Opg 17 (Rosen 1.7 #17)",
  prompt: [Vis, at hvis $n$ er et heltal og #swap[$n^3 + 5$] er ulige, så er #swap[$n$] lige — ved (a) kontraposition, (b) modstrid.],
  answer: [Begge virker. Ulige $n$ gør $n^3$ ulige, så $n^3 + 5 = "ulige" + "ulige" = "lige"$.],
  worked: [
  *(a) Kontraposition.* Bevis "hvis $n$ er ulige, så er $n^3 + 5$ lige". Lad $n = 2k+1$. Så er $n^3$ ulige, sig $n^3 = 2j+1$, og
  #eq[$ n^3 + 5 = 2j + 6 = 2(j+3) $]
  er lige. Den kontraponerede holder, altså også det oprindelige. $qed$

  *(b) Modstrid.* Antag $n^3 + 5$ ulige og $n$ ulige. Så er $n^3$ ulige, og $n^3 + 5 = "ulige" + "ulige" = "lige"$ — modstrid. Altså er $n$ lige. $qed$],
)

#qcard(
  source: "DM04 Opg 41 (Rosen 1.7 #41)",
  prompt: [Bevis eller modbevis: produktet af et #swap[rationalt tal forskelligt fra nul] og et #swap[irrationelt] tal er irrationelt.],
  answer: [Sandt. Bevises ved modstrid.],
  worked: [Lad $r$ være rationel og $!= 0$ og $x$ irrationel. Skriv $r = a/b$ med heltal $a != 0$, $b != 0$. Antag for modstrid, at $r x$ er rationel, $r x = c/d$ med heltal $c, d$ og $d != 0$. Så er
  #eq[$ x = (r x)/r = (c\/d)/(a\/b) = (c b)/(d a). $]
  Da $a != 0$ og $d != 0$, er $d a != 0$, og $c b, d a$ er heltal. Så er $x$ rationel. Modstrid. Altså er $r x$ irrationel. $qed$],
)

#qcard(
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
  worked: [Her er $P: a+b>c$ og $Q: a > c/2 or b > c/2$. Ved De Morgan er $not Q$ lig $a <= c/2 and b <= c/2$, og $not P$ er $a+b <= c$. Læg de to uligheder sammen:
  #eq[$ a + b <= c/2 + c/2 = c, $]
  altså $not P$. Forkast resten: (a) dropper $b$, (b) kludrer i De Morgan-negationen, (c) beviser den omvendte $Q arrow.r P$, og (e) bruger skarp $<$ og en forkert negation.],
)
