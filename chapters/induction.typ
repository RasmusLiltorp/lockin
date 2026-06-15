#import "../lib.typ": *

== Matematisk induktion

Induktion beviser, at $P(n)$ gælder for alle heltal fra et startpunkt og opefter. Du viser det for det mindste $n$, og at det gælder for det næste tal når det gælder for ét. Så vælter de som dominobrikker.

To dele skal på plads.

#eq[$ "Basis:" quad P(n_0) "er sand." $]

#eq[$ "Induktionsskridt:" quad P(k) arrow.r.double P(k+1) quad "for alle" k >= n_0. $]

Til eksamen skriver du sjældent et bevis selv. Du får flere kandidat-"beviser" for samme påstand og skal afgøre, hvilke der holder. Du leder efter fejl: en basis der starter forkert, et skridt der går den forkerte vej, eller et algebraskridt der ikke passer.

=== Sådan løser du den

#recipe(
  title: "Skriv et induktionsbevis",
  [Skriv $P(n)$ op og find startværdien #swap[$n_0$], det mindste $n$ påstanden skal gælde for.],
  [*Basis.* Sæt $n = n_0$ ind på begge sider og tjek at det stemmer.],
  [*Induktionsantagelse (IA).* Antag $P(k)$ sand for et fast $k >= n_0$.],
  [*Induktionsskridt.* Vis $P(k+1)$ med IA. For en sum trækker du det sidste led ud og erstatter resten med IA:],
  [
    #eq[$ sum_(i=1)^(k+1) f(i) = (sum_(i=1)^k f(i)) + f(k+1). $]
    For en ulighed begrænser du $(k+1)$-siden med IA og kendte fakta, fx $3^(k+1) = 3 dot 3^k$.
  ],
  [*Konkluder.* Basis plus induktionsskridt giver $P(n)$ for alle $n >= n_0$.],
)

#recipe(
  title: "Afgør om en kandidat er et gyldigt bevis",
  [*Starter basis rigtigt?* Det skal tjekkes ved mindste $n$, #swap[$n_0$]. Starter det for højt, er der et hul, og beviset er ugyldigt.],
  [*Går skridtet rigtig vej?* Det skal udlede $P(k+1)$ ud fra $P(k)$. At udlede det mindre tilfælde fra det større beviser intet.],
  [*Bruges IA ved rigtigt indeks?* Antagelsen er kun antaget ved $k$. At bruge den ved $k+1$ er ulovligt.],
  [*Er hvert skridt sandt?* Én forkert lighed eller ulighed dræber beviset. Hold øje med brøktricks som $1/2 > 1/3$.],
)

#trap[Et "bevis" der starter ved målet $P(k+1)$ og arbejder sig ned til hypotesen $P(k)$ antager det, det skulle bevise. Baglæns er ugyldigt, også når hver linje er algebraisk sand.]

#trap[At gange IA med en konstant og stiltiende bytte den ud med det næste led er en klassisk fælde. Siderne er ikke ens:
#eq[$ 4(2^n + 3^n) != 2^(n+1) + 3^(n+1). $]
Tjek at to sider er lig hinanden, før du kæder dem sammen.]

#note[SDU regner $NN = {0, 1, 2, dots}$, så $0$ er med. For "for alle $n in NN$" er basis $n = 0$, ikke $n = 1$. En ekstra basis (fx også $n = 1$) skader ikke.]

=== Tilbagevendende eksamensspørgsmål

#qcard(
  tag: [Induktion: hvilke kandidatbeviser er gyldige?],
  source: "MCQ juni 2025, Spm. 34 (samme som DM547 jan 2019, Spm. 3)",
  prompt: [Bevis at #swap[$3^n - 1$ er lige] for alle $n in NN$. Hvilke argumenter er gyldige induktionsbeviser? (en eller flere korrekte)],
  options: (
    [Basis $3^0 - 1 = 0$ lige. Skridt ($n >= 0$): $3^(n+1) - 1 = 3 dot 3^n - 1 = 3(3^n - 1) + 2 = 3 dot 2k + 2 = 2(3k+1)$, ved IA.],
    [Basis $3^0 - 1 = 0$ og $3^1 - 1 = 2$ lige. Skridt ($n >= 2$): $3^n - 1 = 3(3^(n-1) - 1) + 2 = 3 dot 2k + 2 = 2(3k+1)$.],
    [Basis $3^2 - 1 = 8$ lige. Skridt ($n >= 3$): $3^n - 1 = 3(3^(n-1) - 1) + 2 = 2(3k+1)$.],
    [Basis $3^0 - 1 = 0$ lige. Skridt ($n >= 0$): $3^n - 1 = 2k <==> 3^n = 2k + 1 <==> 3^(n+1) = 6k + 3 <==> 3^(n+1) - 1 = 2(3k+1)$.],
    [Basis $3^0 - 1 = 0$ lige. Skridt ($n >= 1$): $3^n - 1 = 1/3 dot 3^(n+1) - 1 = 1/3 dot 2k = 2 dot k/3$, med $k/3 in ZZ$.],
  ),
  answer: [Gyldige: (a), (b) og (d).],
  worked: [IA: $3^m - 1 = 2k$ for et $k in ZZ$.
    - *(a) gyldig.* Basis $n = 0$ korrekt, skridtet går forlæns, $2$ sat uden for parentes.
    - *(b) gyldig.* Den ekstra basis $n = 1$ er overflødig men harmløs. Skridtet dækker stadig alle $n$.
    - *(c) ugyldig.* Basis starter ved $n = 2$, så $n = 0$ og $n = 1$ dækkes aldrig. Hul.
    - *(d) gyldig.* Reversibel kæde fra IA der lander på $3^(n+1) - 1 = 2(3k+1)$, lige.
    - *(e) ugyldig.* Kræver $3^(n+1) - 1 = 2k$, det der skal bevises, ikke IA. Og $k/3 in ZZ$ er ubegrundet.],
)

#qcard(
  tag: [Induktion: hvilke kandidatbeviser er gyldige?],
  source: "DM547 jan 2021, Spm. 5 (12%)",
  prompt: [Påstand: #swap[$2^n + 3^n < 4^n$] for $n >= #swap[$2$]$. Hvilke af 5.a–5.g er gyldige induktionsbeviser?],
  options: (
    [Basis $n = 2$. Skridt ganger IA med $4$: $4(2^n + 3^n) < 4 dot 4^n$, og springer så til $2^(n+1) + 3^(n+1) < 4^(n+1)$.],
    [Basis $n = 3$, ellers korrekt skridt.],
    [Basis $n = 2$, skridt $n-1 arrow.r n$ med samme gangetrick som 5.a: $4(2^(n-1) + 3^(n-1)) != 2^n + 3^n$.],
    [Skridtet starter ved målet $2^n + 3^n < 4^n$ og udleder hypotesen $2^(n-1) + 3^(n-1) < 4^(n-1)$ (baglæns).],
    [Skridtet starter ved $2^(n+1) + 3^(n+1) < 4^(n+1)$ (målet) og udleder $2^n + 3^n < 4^n$.],
    [Basis $n = 2$. Skridt forlæns: $2^(n+1) + 3^(n+1) = 2 dot 2^n + 3 dot 3^n < 3(2^n + 3^n) < 3 dot 4^n < 4 dot 4^n = 4^(n+1)$.],
    [Skriver $2^n + 3^n = 1/2 dot 2^(n+1) + 1/3 dot 3^(n+1)$, og påstår $< 1/3 (2^(n+1) + 3^(n+1))$.],
  ),
  answer: [Kun (f) er gyldig.],
  worked: [Basis: $2^n + 3^n < 4^n$ holder først ved $n = 2$ ($13 < 16$), fejler ved $n = 0, 1$. Så $n_0 = 2$.
    - *(a) ugyldig.* $4(2^n + 3^n) != 2^(n+1) + 3^(n+1)$ (venstresiden er $2^(n+2) + dots$), så sidste implikation er ubegrundet.
    - *(b) ugyldig.* Basis $n = 3$ springer $n = 2$ over.
    - *(c) ugyldig.* Samme gangefejl som (a), skrevet med $n-1 arrow.r n$.
    - *(d) ugyldig.* Går baglæns fra målet til hypotesen.
    - *(e) ugyldig.* Antager konklusionen ved $n+1$ og udleder det mindre tilfælde.
    - *(f) gyldig.* Hver ulighed holder: $2 dot 2^n < 3 dot 2^n$, så IA ved indeks $n$, så $3 dot 4^n < 4 dot 4^n$. Forlæns.
    - *(g) ugyldig.* Kræver $1/2 < 1/3$ på $2^(n+1)$-leddet (falsk), og bruger IA ved $n+1$.],
)

#qcard(
  tag: [Induktion: hvilke kandidatbeviser er gyldige?],
  source: "MCQ juni 2023, Spm. 35",
  prompt: [Hvilke er korrekte induktionsbeviser for #swap[$sum_(i=1)^n ((1/2)^(i-1) - (1/2)^i) = 1 - (1/2)^n$] for alle $n >= 1$? (en eller flere korrekte)],
  options: (
    [Basis $n = 1, 2$ tjekket; ind.ant.: summen til $k-1$ er $1 - (1/2)^(k-1)$ for $k >= 3$; skridtet ($k >= 3$) splitter summen til $k$ og indsætter, forlæns $k-1 arrow.r.double k$.],
    [Basis $n = 1$; ind.ant.: summen til $k-1$ er $1 - (1/2)^(k-1)$ for $k >= 2$; skridtet udleder summen til $k = 1 - (1/2)^k$, forlæns $k-1 arrow.r.double k$.],
    [Basis $n = 1$; ind.ant.: summen til $k$ er $1 - (1/2)^k$ for $k >= 1$; skridtet udleder udsagnet ved $k-1$ (nedad, $k arrow.r.double k-1$).],
  ),
  answer: [Gyldige: (a) og (b).],
  worked: [Identiteten teleskoperer. Indsættelsen i skridtet er:
    #eq[$ (1 - (1/2)^(k-1)) + ((1/2)^(k-1) - (1/2)^k) = 1 - (1/2)^k. $]
    - *(a) gyldig.* Basis $n = 1, 2$ ($n = 2$ overflødigt). Forlæns skridt $k-1 arrow.r.double k$, korrekt algebra.
    - *(b) gyldig.* Basis $n = 1$, samme forlæns skridt.
    - *(c) ugyldig.* Algebraen er fin, men antager resultatet ved $k$ og går tilbage til $k-1$. Induktion skal gå opad fra basis.],
)
