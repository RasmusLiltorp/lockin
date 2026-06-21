#import "../lib.typ": *

=== Søgestrukturer: BST, rød-sorte træer, hashing

Søgestrukturer fylder i de skriftlige sæt, og opgaverne gentager sig år efter år. Du skal tjekke eller redigere et binært søgetræ (binary search tree), verificere eller indsætte i et rød-sort træ (red-black tree), farve et træ lovligt eller tælle alle lovlige farvninger, køre en åben hashtabel (open-addressing hash table) med lineær, kvadratisk eller dobbelt probing (linear, quadratic, or double probing), og udvide et BST med felter som `maxGap` eller en hjørnerektangel. Alt sammen er trace-arbejde. Kend reglerne, og kør input igennem ét trin ad gangen.

#qcard(
  tag: [BST: verificér, indsæt, slet (binært søgetræ)],
  source: "DM507 jan 2007, Opg. 1 (20%)",
  theory: <th-bst-bst-ops>,
  prompt: [
    *(a)* Er træet et binært søgetræ? Roden er #swap[$4$]; venstre barn #swap[$2$] (med venstre barn #swap[$1$]); højre barn #swap[$20$] med venstre barn #swap[$8$] og højre barn #swap[$25$]; node #swap[$8$] har børn #swap[$7$] og #swap[$14$]; node #swap[$14$] har venstre barn #swap[$11$]. \
    *(b)* Tegn træet efter sletning af nøgle #swap[$5$] med `TREE-DELETE` (CLRS). Træet: rod #swap[$5$]; venstre #swap[$2$] (børn #swap[$1$] og #swap[$4$], hvor #swap[$4$] har venstre barn #swap[$3$]); højre #swap[$11$] (venstre barn #swap[$6$], højre barn #swap[$12$]); #swap[$6$] har højre barn #swap[$8$]; #swap[$8$] har børn #swap[$7$] og #swap[$10$]. \
    *(c)* Tegn træet efter indsættelse af nøgle #swap[$16$] med `TREE-INSERT` (CLRS). Træet: rod #swap[$10$]; venstre #swap[$5$] (venstre barn #swap[$3$]); højre #swap[$21$] med venstre barn #swap[$15$] og højre barn #swap[$30$]; #swap[$15$] har børn #swap[$11$] og #swap[$17$].
  ],
  answer: [(a) Ja, in-order giver $1, 2, 4, 7, 8, 11, 14, 20, 25$ — strengt voksende. (b) #swap[$6$] bliver ny rod (efterfølger), #swap[$8$] rykker op som venstre barn af #swap[$11$]. (c) #swap[$16$] bliver venstre barn af #swap[$17$].],
  blueprint: [
    BST-reglen er global: alt i venstre undertræ er mindre end noden, alt i højre er større. De tre operationer kører ens hver gang.

    + *Verificér.* Lav en in-order gennemgang (in-order traversal) (venstre, node, højre). Resultatet er sorteret hvis og kun hvis det er et BST. Første usorterede par peger på fejlen.
    + *Indsæt.* Gå ned fra roden: venstre når #swap[nøglen] er mindre, højre når den er større. Den tomme plads, du rammer, bliver et nyt blad.
    + *Slet.* Har noden $z$ to børn, så find efterfølgeren (successor) $y =$ minimum i højre undertræ (subtree). Flyt $y$ op på $z$'s plads (transplantér først $y$ ud, hvis $y$ ikke er direkte barn af $z$).
  ],
  worked: [
    + *(a)* Træet, og in-order-gennemgangen node for node (venstre, node, højre):
      ```
                4
              /   \
             2     20
            /     /  \
           1     8    25
                / \
               7  14
                  /
                11

      in-order: 1, 2, 4, 7, 8, 11, 14, 20, 25
      ```
      Hvert nabopar vokser: $1<2<4<7<8<11<14<20<25$. Ingen faldende skridt, så sekvensen er strengt voksende, og træet _er_ et binært søgetræ. (Tjek på de kritiske noder: $8, 14$ ligger i venstre undertræ af $20$, begge $> 4$ og $< 20$; $11 < 14$ og $> 8$.)
    + *(b)* `TREE-DELETE` af $z = 5$. Starttræet:
      ```
                5
              /   \
             2     11
            / \   /  \
           1   4 6   12
              /   \
             3     8
                  / \
                 7  10
      ```
      $z = 5$ har to børn, så efterfølgeren $y = $ minimum i højre undertræ. Gå til $11$, så hele vejen ned ad venstre: $11 -> 6$, og $6$ har intet venstre barn, så $y = 6$. \
      $y = 6$ er ikke direkte barn af $z$ (det er barnebarn). CLRS transplanterer derfor først $y$ ud med dens højre barn $x = 8$, så $8$ overtager $6$'s plads under $11$:
      ```
                5
              /   \
             2     11
            / \   /  \
           1   4 8   12
              /  / \
             3  7  10
      ```
      Sæt så $y."right" = $ det gamle højre undertræ af $z$ (rodet ved $11$), og transplantér $y = 6$ ind på $z$'s plads med $z."left" = 2$:
      ```
                6
              /   \
             2     11
            / \   /  \
           1   4 8   12
              /  / \
             3  7  10
      ```
      Ny rod $6$; venstre $= 2$ (børn $1, 4$; $4$ har venstre barn $3$); højre $= 11$ (venstre barn $8$ med børn $7, 10$; højre barn $12$).
    + *(c)* `TREE-INSERT` af $16$. Starttræet og søgestien:
      ```
                10
              /    \
             5      21
            /      /  \
           3     15    30
                /  \
               11  17

      16 > 10  -> højre til 21
      16 < 21  -> venstre til 15
      16 > 15  -> højre til 17
      16 < 17  -> venstre for 17 (tom)  -> indsæt her
      ```
      Resultat: $16$ bliver venstre barn af $17$:
      ```
                10
              /    \
             5      21
            /      /  \
           3     15    30
                /  \
               11  17
                   /
                  16
      ```
  ],
)

#qcard(
  tag: [Rød-sort: verificér + indsæt (rød-sort træ)],
  source: "DM02 jan 2005, Opg. 1 (15%)",
  theory: <th-bst-rb-insert>,
  prompt: [
    *(a)* Hvilke af $T_1$–$T_4$ er rød-sorte træer? Begrund. (B = sort, R = rød; NIL-blade er sorte.) \
    - $T_1$: rod #swap[$5$] (B); #swap[$3$] (B), #swap[$7$] (B); under $3$: #swap[$2$] (B) med venstre barn #swap[$1$] (R), og #swap[$4$] (B); under $7$: #swap[$6$] (B) og #swap[$9$] (R) med børn #swap[$8$] (B), #swap[$10$] (B).
    - $T_2$: rod #swap[$2$] (B), børn #swap[$1$] (R), #swap[$3$] (R).
    - $T_3$: rod #swap[$10$] (B); #swap[$8$] (B), #swap[$9$] (B); under $8$: #swap[$4$] (B) med venstre barn #swap[$1$] (R), og #swap[$5$] (B); under $9$: #swap[$6$] (B) og #swap[$7$] (R) med børn #swap[$2$] (B), #swap[$3$] (B).
    - $T_4$: rod #swap[$3$] (B); venstre #swap[$2$] (R) hvis venstre barn er #swap[$1$] (R); højre #swap[$4$] (R).
    *(b)* Indsæt nøgle #swap[$5$] i træet med `RB-INSERT` + fixup; vis hvert trin. Starttræ: rod #swap[$4$] (B); #swap[$2$] (R) [børn #swap[$1$] (B), #swap[$3$] (B)]; #swap[$9$] (R) [børn #swap[$7$] (B), #swap[$10$] (B)]; #swap[$7$] har børn #swap[$6$] (R), #swap[$8$] (R).
  ],
  answer: [(a) $T_1, T_2, T_3$ er gyldige; $T_4$ er ikke (rød $2$ har rødt barn $1$). (b) To Case-1-omfarvninger, ingen rotationer; $5$(R) ender som venstre barn af $6$(B).],
  blueprint: [
    Et rød-sort træ skal opfylde: rod sort, intet rødt-rødt par, og samme sort-højde (black-height) på hver rod-til-NIL-sti.

    + *Verificér.* Gå hver node igennem og tjek de tre egenskaber. Fejler én, så navngiv noden.
    + *Indsæt.* BST-indsæt den nye nøgle som et _rødt_ blad.
    + *Fixup.* Mens den nye node $z$ har rød forælder: er onklen rød (Case 1), omfarv (recolor) forælder og onkel sort, bedstefar rød, ryk $z$ op. Er onklen sort (Case 2/3), rotér (rotate) og omfarv.
    + *Afslut.* Farv roden sort.
  ],
  worked: [
    + *(a)* $T_1, T_2, T_3$: rod sort, intet rødt-rødt par, alle stier har samme antal sorte (her $3$ inkl. NIL). Gyldige. $T_4$: node $2$ er rød med rødt venstre barn $1$ — bryder reglen om at en rød node kun må have sorte børn. _Ikke_ gyldig.
    + *(b)* Starttræet (suffiks B = sort, R = rød):
      ```
                4B
              /    \
            2R      9R
           /  \    /  \
         1B   3B  7B  10B
                 /  \
               6R    8R
      ```
      BST-indsæt: $5 > 4 ->$ højre til $9$; $5 < 9 ->$ venstre til $7$; $5 < 7 ->$ venstre til $6$; $5 < 6 ->$ venstre for $6$ (tom). Indsæt $5$ rød:
      ```
                4B
              /    \
            2R      9R
           /  \    /  \
         1B   3B  7B  10B
                 /  \
               6R    8R
              /
            5R          <- ny node z
      ```
      Fixup, trin 1: $z = 5$(R), forælder $6$(R) — rødt-rødt-brud. $6$ er venstre barn af $7$, så onkel $=$ $7$'s højre barn $= 8$(R). Onkel rød $=>$ Case 1: omfarv forælder $6 ->$ B, onkel $8 ->$ B, bedstefar $7 ->$ R; ryk $z := 7$.
      ```
                4B
              /    \
            2R      9R
           /  \    /  \
         1B   3B  7R  10B
                 /  \
               6B    8B
              /
            5R          <- z er rykket op til 7
      ```
      Trin 2: $z = 7$(R), forælder $9$(R) — brud. $9$ er højre barn af $4$, så onkel $=$ $4$'s venstre barn $= 2$(R). Onkel rød $=>$ Case 1: omfarv $9 ->$ B, $2 ->$ B, bedstefar $4 ->$ R; ryk $z := 4$.
      ```
                4R          <- z
              /    \
            2B      9B
           /  \    /  \
         1B   3B  7R  10B
                 /  \
               6B    8B
              /
            5R
      ```
      $z = 4$ er roden, så løkken slutter. Sidste skridt farver roden sort ($4 ->$ B):
      ```
                4B
              /    \
            2B      9B
           /  \    /  \
         1B   3B  7R  10B
                 /  \
               6B    8B
              /
            5R
      ```
      Kun omfarvninger, ingen rotationer. $5$(R) er venstre barn af $6$(B), intet rødt-rødt-par, og hver rod-til-NIL-sti har samme antal sorte.
  ],
)

#qcard(
  tag: [Rød-sort: verificér + indsæt (rød-sort træ)],
  source: "DM507 juni 2011, Opg. 1 (18%)",
  theory: <th-bst-rb-insert>,
  prompt: [
    *(a)* Hvilke af otte træer $T_1$–$T_8$ er gyldige rød-sorte træer? (Fede noder sorte, resten røde; små cirkler er sorte NIL-blade.) \
    - $T_1$: rod #swap[$1$] (B); børn #swap[$2$] (B), #swap[$3$] (B).
    - $T_2$: rod #swap[$2$] (R).
    - $T_3$: rod #swap[$2$] (B); børn #swap[$1$] (R), #swap[$3$] (R).
    - $T_4$: rod #swap[$2$] (B); børn #swap[$1$] (B), #swap[$3$] (B).
    - $T_5$: #swap[$2$] (B); #swap[$1$] (R); #swap[$3$] (R) med højre barn #swap[$4$] (R).
    - $T_6$: #swap[$2$] (B); #swap[$1$] (R); #swap[$3$] (R) med højre barn #swap[$4$] (B).
    - $T_7$: #swap[$2$] (B); #swap[$1$] (B); #swap[$4$] (R) med venstre barn #swap[$3$] (B).
    - $T_8$: #swap[$2$] (B); #swap[$1$] (B); #swap[$4$] (B) med venstre barn #swap[$3$] (R).
    *(b)* Indsæt nøgle #swap[$3$] i træet $T$ med `RB-INSERT` + fixup. $T$: rod #swap[$7$] (B); #swap[$5$] (R) [børn #swap[$2$] (B), #swap[$6$] (B)]; #swap[$8$] (B) [højre barn #swap[$9$] (R)]; #swap[$2$] har børn #swap[$1$] (R), #swap[$4$] (R).
  ],
  answer: [(a) $T_1, T_3, T_4, T_8$ er gyldige. (b) Case 1 efterfulgt af Case 3 (højre-rotation om $7$); $5$ bliver ny rod.],
  blueprint: [
    Samme to job som altid: tjek RB-egenskaberne, eller kør en indsættelse med fixup.

    + *Verificér.* Rod sort; intet rødt-rødt par; samme sort-højde på hver gren (en NIL-side tæller som sort-højde $1$).
    + *Indsæt.* BST-indsæt som rødt blad.
    + *Fixup.* Onkel rød: Case 1 (omfarv, ryk op). Onkel sort, $z$ "indre" barn: Case 2 (rotér til Case 3). Onkel sort, $z$ "ydre" barn: Case 3 (omfarv + rotér om bedstefar).
    + *Afslut.* Farv roden sort.
  ],
  worked: [
    + *(a)* $T_2$: rød rod — fejler. $T_5$: rød $3$ har rødt barn $4$ — rødt-rødt. $T_6$: under $3$ har NIL-venstre sort-højde $1$, men stien gennem $4$(B) sort-højde $2$ — ulige. $T_7$: under $4$ har stien gennem $3$(B) sort-højde $2$, højre NIL kun $1$ — ulige. Resten ($T_1, T_3, T_4, T_8$) opfylder alt.
    + *(b)* Starttræet (suffiks B = sort, R = rød):
      ```
              7B
            /    \
          5R      8B
         /  \       \
        2B   6B      9R
       /  \
      1R   4R
      ```
      BST-indsæt $3$: $3 < 7 ->$ venstre til $5$; $3 < 5 ->$ venstre til $2$; $3 > 2 ->$ højre til $4$; $3 < 4 ->$ venstre for $4$ (tom). Indsæt $3$ rød:
      ```
              7B
            /    \
          5R      8B
         /  \       \
        2B   6B      9R
       /  \
      1R   4R
           /
          3R          <- ny node z
      ```
      Fixup, trin 1: $z = 3$(R), forælder $4$(R) — rødt-rødt-brud. $4$ er højre barn af $2$, så onkel $=$ $2$'s venstre barn $= 1$(R). Onkel rød $=>$ Case 1: omfarv forælder $4 ->$ B, onkel $1 ->$ B, bedstefar $2 ->$ R; ryk $z := 2$.
      ```
              7B
            /    \
          5R      8B
         /  \       \
        2R   6B      9R
       /  \
      1B   4B
           /
          3R          <- z er rykket op til 2
      ```
      Trin 2: $z = 2$(R), forælder $5$(R) — brud. $5$ er venstre barn af $7$, så onkel $=$ $7$'s højre barn $= 8$(B). Onkel sort. $z = 2$ er venstre barn af $5$, og $5$ er venstre barn af $7$, så $z$ er "venstre-venstre" (ydre) $=>$ Case 3: omfarv forælder $5 ->$ B, bedstefar $7 ->$ R, og højre-rotér om $7$. Ved rotationen rykker $5$ op på $7$'s plads, $7$ bliver $5$'s højre barn, og $5$'s gamle højre barn $6$ flytter over som $7$'s venstre barn:
      ```
              5B
            /    \
          2R      7R
         /  \    /  \
        1B   4B 6B   8B
            /          \
           3R           9R
      ```
      $z$'s nye forælder $5$ er sort (efter Case 3 stopper løkken), og roden $5$ er allerede sort. Færdig. Resultat: rod $5$(B); venstre $2$(R) [børn $1$(B), $4$(B); $3$(R) venstre barn af $4$]; højre $7$(R) [børn $6$(B), $8$(B); $9$(R) højre barn af $8$]. Intet rødt-rødt-par, og hver rod-til-NIL-sti har samme antal sorte.
  ],
)

#qcard(
  tag: [Rød-sort: slet (rød-sort træ)],
  source: "DM507 juni 2009, Opg. 1b (6%)",
  theory: <th-bst-rb-delete>,
  prompt: [
    Slet noden med nøgle #swap[$2$] fra det rød-sorte træ med `RB-Delete` (CLRS); tegn resultatet. Træet (B = sort, R = rød): rod #swap[$9$] (B); #swap[$2$] (R) [børn #swap[$1$] (B), #swap[$7$] (B)]; #swap[$12$] (B) [højre barn #swap[$15$] (R)]; #swap[$7$] har børn #swap[$5$] (R), #swap[$8$] (R).
  ],
  answer: [Efterfølger $5$ rykker op på $2$'s plads og overtager farven rød; ingen fixup (fjernet node var rød).],
  blueprint: [
    `RB-Delete`: erstat noden med dens efterfølger, og kør kun fixup hvis en _sort_ node forsvandt.

    + *Find efterfølger.* Har $z$ to børn, så er $y =$ minimum i $z$'s højre undertræ. Husk $y$'s oprindelige farve. Lad $x = y."right"$ (noden der rykker ind på $y$'s plads).
    + *Splice.* Klip $y$ ud, sæt den hvor $z$ var, og giv $y$ farven $z$ havde.
    + *Fixup.* Var $y$'s oprindelige farve _sort_, så kør `RB-Delete-Fixup($x$)`. Var den rød, behøves ingen fixup.
  ],
  worked: [
    + Starttræet (suffiks B = sort, R = rød):
      ```
              9B
            /    \
          2R      12B
         /  \        \
        1B   7B       15R
            /  \
          5R    8R
      ```
    + $z =$ node $2$ har to børn, så efterfølgeren $y = "minimum"$ i $z$'s højre undertræ. Gå til $7$, så hele vejen ned ad venstre: $7 -> 5$, og $5$ har intet venstre barn, så $y = 5$. Husk $y$'s farve: _rød_. Lad $x = y."right" = $NIL (noden der rykker ind på $y$'s plads).
    + $y = 5$ er ikke direkte barn af $z$, men ligger i $z$'s højre undertræ. CLRS klipper først $y$ ud (dens plads under $7$ bliver NIL), sætter $y."right" = z."right" = 7$, og transplanterer $y = 5$ ind på $z$'s plads med $z."left" = 1$ som venstre barn. Til sidst får $y$ farven $z$ havde (rød):
      ```
              9B
            /    \
          5R      12B
         /  \        \
        1B   7B       15R
              \
               8R
      ```
    + $y$'s oprindelige farve var _rød_ $->$ ingen `RB-Delete-Fixup`. \
      Resultat: rod $9$(B); $5$(R) [børn $1$(B), $7$(B)]; $12$(B) [højre barn $15$(R)]; $7$ har kun rødt højre barn $8$. Sort-højderne stemmer (hver rod-til-NIL-sti har samme antal sorte), og der er intet rødt-rødt par.
  ],
)

#qcard(
  tag: [Rød-sort: lovlig farvning + indsæt (farvelægning)],
  source: "DM507 juni 2015, Opg. 8 (10%)",
  theory: <th-bst-rb-rules>,
  prompt: [
    *(a)* Farv træet, så det bliver et gyldigt rød-sort træ (NIL-blade sorte): rod #swap[$b$], børn #swap[$a$] (venstre) og #swap[$d$] (højre); #swap[$d$] har børn #swap[$c$] (venstre) og #swap[$e$] (højre); #swap[$a$], #swap[$c$], #swap[$e$] er blade mod NIL. \
    *(b)* Indsæt nøgle #swap[$11$] med `RB-Insert` i: rod #swap[$5$] (B); venstre #swap[$3$] (B) med røde børn #swap[$2$], #swap[$4$]; højre #swap[$7$] (B) med venstre #swap[$6$] (B), højre #swap[$9$] (B); #swap[$9$] har røde børn #swap[$8$], #swap[$10$]. Hvilket af $T_1$–$T_4$ giver det?
  ],
  answer: [(a) Sort: $b, a, d$; rød: $c, e$ (eller alternativt sort $b,a,c,e$, rød $d$). (b) Case 1 (onkel $8$ rød); resultatet er $T_2$.],
  blueprint: [
    To job: find en lovlig farvning, eller kør en indsættelse.

    + *Farvning.* Rod sort; en rød node har kun sorte børn; hver rod-til-NIL-sti har samme sort-højde. Skub indre noder mod sort, og gør den dybere sides blade røde for at udligne sort-højderne.
    + *Indsæt.* BST-indsæt som rødt blad, kør fixup (onkel rød $->$ Case 1; onkel sort $->$ rotér), farv roden sort.
  ],
  worked: [
    + *(a)* Stien $b -> a ->$NIL har $1$ indre node; stien $b -> d -> {c, e} ->$NIL har $2$. Gør $a, d$ sorte og $c, e$ røde. Så har hver rod-til-NIL-sti sort-højde $2$. (Gyldigt alternativ: sort ${b, a, c, e}$, rød ${d}$.)
    + *(b)* Starttræet (suffiks B = sort, R = rød):
      ```
                5B
              /    \
            3B      7B
           /  \    /  \
          2R   4R 6B   9B
                      /  \
                    8R    10R
      ```
      BST-indsæt $11$: $11 > 5 ->$ højre til $7$; $11 > 7 ->$ højre til $9$; $11 > 9 ->$ højre til $10$; $11 > 10 ->$ højre for $10$ (tom). Indsæt $11$ rød:
      ```
                5B
              /    \
            3B      7B
           /  \    /  \
          2R   4R 6B   9B
                      /  \
                    8R    10R
                            \
                             11R   <- ny node z
      ```
      Fixup, trin 1: $z = 11$(R), forælder $10$(R) — rødt-rødt-brud. $10$ er højre barn af $9$, så onkel $=$ $9$'s venstre barn $= 8$(R). Onkel rød $=>$ Case 1: omfarv forælder $10 ->$ B, onkel $8 ->$ B, bedstefar $9 ->$ R; ryk $z := 9$.
      ```
                5B
              /    \
            3B      7B
           /  \    /  \
          2R   4R 6B   9R   <- z er rykket op til 9
                      /  \
                    8B    10B
                            \
                             11R
      ```
      Trin 2: $z = 9$(R), forælder $7$(B). Forælderen er sort, så der er intet brud $->$ løkken stopper. Roden $5$ er allerede sort. Færdig. \
      Resultat: rod $5$(B); venstre $3$(B): $2$(R), $4$(R); højre $7$(B): $6$(B), $9$(R); $9 ->$ børn $8$(B), $10$(B); $10 ->$ højre barn $11$(R). Kun én Case-1-omfarvning, ingen rotationer. Dette er $T_2$.
  ],
)

#qcard(
  tag: [Rød-sort: tæl alle lovlige farvninger (farvelægning)],
  source: "DM507 juni 2012, Opg. 1 (10%)",
  theory: <th-bst-rb-rules>,
  prompt: [
    Cirklerne er rigtige noder, du farver; firkanterne er sorte NIL-blade. \
    *(a)* Angiv én lovlig rød-sort-farvning af $T_1$. $T_1$ (kun cirkler): #swap[$a$] med børn #swap[$b$], #swap[$c$]; #swap[$b$] har to NIL-børn; #swap[$c$] har venstre barn #swap[$f$] og NIL til højre; #swap[$f$] har to NIL-børn. (Altså $4$ rigtige noder: $a, b, c, f$.) \
    *(b)* Angiv _alle_ lovlige farvninger af $T_2$. $T_2$ (kun cirkler): #swap[$a$] med børn #swap[$b$], #swap[$c$]; #swap[$b$] har børn #swap[$d$], #swap[$e$]; #swap[$c$] har børn #swap[$f$], #swap[$g$]; $d, e, f, g$ har hver to NIL-børn. (Et perfekt $3$-niveau-træ: $a$; $b, c$; $d, e, f, g$.)
  ],
  answer: [(a) Præcis én: sort $a, b, c$, rød $f$. (b) Præcis $5$ farvninger.],
  blueprint: [
    En node må kun være rød, hvis begge børn er sorte _og_ alle rod-til-NIL-stier beholder samme sort-antal.

    + *Sæt NIL sorte og rod sort.*
    + *Vælg sort-højde $b h$* (antal sorte på en rod-til-NIL-sti, NIL talt med).
    + *Farv* de indre noder, så ingen rød har et rødt barn, og hver sti rammer præcis $b h$ sorte.
    + *Find én:* giv én gyldig farvning. *Find alle:* variér systematisk $b h$ og rød-placeringerne.
  ],
  worked: [
    + *(a)* Under $c$ løber venstre sti $c -> f ->$NIL, mens højre kun er $c -> g$(NIL). For samme sort-antal _skal_ $f$ være rød (ellers har $f$-siden én sort mere). Med $f$ rød har hver rod-til-NIL-sti samme sort-højde: $a, b, c$ sorte, $f$ rød. Det er den eneste lovlige farvning.
    + *(b)* De nederste rigtige noder $d, e, f, g$ sidder på NIL-blade, så gør man én af dem rød, korter den den stis sort-antal med én. For at holde alle fire stier i balance kan man kun vippe et helt søskendepar samtidig, eller skubbe det røde et niveau op. De $5$ tilfælde (sort $|$ rød):
      #eq[$
        &1. quad a b c d e f g quad | quad "(alle sorte)" \
        &2. quad a b c quad | quad d e f g \
        &3. quad a b f g quad | quad c d e \
        &4. quad a c d e quad | quad b f g \
        &5. quad a d e f g quad | quad b c
      $]
      $a$ er altid sort (roden).
  ],
)

#qcard(
  tag: [Hashing: lineær probing (linear probing)],
  source: "jun 2016, Problem 4 (6%)",
  theory: <th-bst-linear-probing>,
  prompt: [
    Åben hashtabel, $m = #swap[$11$]$ pladser, lineær probing, $h'(x) = (#swap[$7$] x + #swap[$4$]) mod #swap[$11$]$, så $h(x, k) = (h'(x) + k) mod #swap[$11$]$ for $k = 0, 1, 2, dots$. Starttabel (plads $0..10$): #swap[`67 20 17 _ 33 _ 16 2 _ _ 15`]. Indsæt #swap[$18$], derefter #swap[$26$]; vis tabellen efter hver. (Tom $=$ x.)
  ],
  answer: [Efter $18$: `67 20 17 x 33 x 16 2 x 18 15`. Efter $26$: `67 20 17 26 33 x 16 2 x 18 15`.],
  blueprint: [
    Probe-sekvensen (probe sequence) er $h(x, k) = (h'(x) + k) mod m$ for $k = 0, 1, 2, dots$ Placér $x$ i den første tomme plads.

    + *Basis.* Regn $h'(x)$.
    + *Probe.* Tæl $k$ op fra $0$ og gå én plads ad gangen frem (med wrap mod $m$), indtil du rammer en tom plads.
    + *Placér.* Sæt $x$ dér.
  ],
  worked: [
    + Indsæt $18$: $h'(18) = (7 dot 18 + 4) mod 11 = 130 mod 11 = 9$. Plads $9$ tom $->$ placér. \
      `67 20 17 x 33 x 16 2 x 18 15`
    + Indsæt $26$: $h'(26) = (182 + 4) mod 11 = 186 mod 11 = 10$. Plads $10 = 15$ (optaget). $k=1$: plads $0 = 67$. $k=2$: plads $1 = 20$. $k=3$: plads $2 = 17$. $k=4$: plads $3$ tom $->$ placér. \
      `67 20 17 26 33 x 16 2 x 18 15`
  ],
)

#qcard(
  tag: [Hashing: kvadratisk probing (quadratic probing)],
  source: "DM507 juni 2015, Opg. 4 (7%)",
  theory: <th-bst-linear-probing>,
  prompt: [
    Tabel $H$ af størrelse $m = #swap[$11$]$, kvadratisk probing, $h'(x) = (#swap[$3$] x + #swap[$5$]) mod #swap[$11$]$, $c_1 = #swap[$3$]$, $c_2 = #swap[$1$]$, så $h(x, i) = (h'(x) + #swap[$3$] i + i^2) mod #swap[$11$]$. Start: indeks $0=#swap[$13$]$, $1=#swap[$39$]$, $3=#swap[$36$]$, $8=#swap[$23$]$, $9=#swap[$5$]$ (resten tomme). Indsæt #swap[$22$], #swap[$16$], #swap[$17$] i den rækkefølge; vis tabellen efter hver. (Tom $=$ x.)
  ],
  answer: [$22 ->$ plads $5$; $16 ->$ plads $2$; $17 ->$ plads $7$. Slut: `13 39 16 36 x 22 x 17 23 5 x`.],
  blueprint: [
    For hver nøgle $x$ og probe $i = 0, 1, 2, dots$: plads $= (h'(x) + c_1 i + c_2 i^2) mod m$. Første tomme plads vinder.

    + *Basis.* Regn $h'(x)$.
    + *Probe.* For $i = 0, 1, 2, dots$ udregn $(h'(x) + c_1 i + c_2 i^2) mod m$.
    + *Placér.* Sæt $x$ i den første tomme plads.
  ],
  worked: [
    + Indsæt $22$: $h'(22) = 71 mod 11 = 5$. $i=0 ->$ plads $5$ tom $->$ placér. \
      `13 39 x 36 x 22 x x 23 5 x`
    + Indsæt $16$: $h'(16) = 53 mod 11 = 9$. $i=0 ->$ $9$ optaget. $i=1 -> (9 + 3 + 1) mod 11 = 2$ tom $->$ placér. \
      `13 39 16 36 x 22 x x 23 5 x`
    + Indsæt $17$: $h'(17) = 56 mod 11 = 1$. $i=0 -> 1$ optaget. $i=1 -> 5$ optaget. $i=2 -> (1 + 6 + 4) = 11 mod 11 = 0$ optaget. $i=3 -> (1 + 9 + 9) = 19 mod 11 = 8$ optaget. $i=4 -> (1 + 12 + 16) = 29 mod 11 = 7$ tom $->$ placér. \
      `13 39 16 36 x 22 x 17 23 5 x`
  ],
)

#qcard(
  tag: [Hashing: dobbelt hashing (double hashing)],
  source: "DM507 juni 2014, Opg. 4 (6%)",
  theory: <th-bst-double-hashing>,
  prompt: [
    Tabelstørrelse $m = #swap[$13$]$. $h_1(x) = (#swap[$5$] x + #swap[$1$]) mod #swap[$13$]$, $h_2(x) = #swap[$1$] + (x mod #swap[$12$])$. Probe-sekvens $h(x, i) = (h_1(x) + i dot h_2(x)) mod #swap[$13$]$. Starttabel (indeks : værdi): #swap[$0:18$, $2:8$, $5:6$, $8:30$, $9:25$, $11:2$, $12:23$] (resten tomme). Indsæt #swap[$3$], #swap[$5$], #swap[$15$] i den rækkefølge; angiv den endelige tabel.
  ],
  answer: [$3 ->$ plads $3$; $5 ->$ plads $6$; $15 ->$ plads $10$. Slut: `18 x 8 3 x 6 5 x 30 25 15 2 23`.],
  blueprint: [
    For hver nøgle: regn $h_1$ og $h_2$, prøv $i = 0, 1, 2, dots$ på indeks $(h_1 + i dot h_2) mod m$ til en tom plads.

    + *Basis-hash.* Regn $h_1(x)$ (startplads) og $h_2(x)$ (skridtlængde).
    + *Probe.* Tæl $i$ op fra $0$; hvert skridt hopper $h_2(x)$ frem (med wrap mod $m$).
    + *Placér.* Sæt $x$ i den første tomme plads.
  ],
  worked: [
    + Indsæt $3$: $h_1 = 16 mod 13 = 3$, $h_2 = 1 + 3 = 4$. $i=0 ->$ plads $3$ tom $->$ placér.
    + Indsæt $5$: $h_1 = 26 mod 13 = 0$, $h_2 = 1 + 5 = 6$. $i=0 ->$ $0$ optaget; $i=1 -> (0 + 6) = 6$ tom $->$ placér.
    + Indsæt $15$: $h_1 = 76 mod 13 = 11$, $h_2 = 1 + (15 mod 12) = 1 + 3 = 4$. Probe $11$ (optaget), $11+4=15 mod 13 = 2$ (optaget), $11+8=19 mod 13 = 6$ (nu $5$, optaget), $11+12=23 mod 13 = 10$ tom $->$ placér. \
      Slut: `18 x 8 3 x 6 5 x 30 25 15 2 23`.
  ],
)

#qcard(
  tag: [Augmenteret BST: maxGap (augmentering)],
  source: "DM507 juni 2010, Opg. 5 (15%)",
  theory: <th-bst-augment>,
  prompt: [
    Hver node $v$ gemmer $v."key"$ plus #swap[$v."maxGap"$] (største afstand mellem to på hinanden følgende nøgler i $v$'s undertræ), #swap[$v."max"$] (største nøgle) og #swap[$v."min"$] (mindste nøgle). For et et-nøgle-undertræ er $v."maxGap" = 0$. \
    *(a)* Beregn en nodes felter i $O(1)$ ud fra dens to børn. \
    *(b)* Argumentér for, at felterne kan vedligeholdes under indsæt/slet i et RB-træ uden at ændre $O(log n)$. \
    *(c)* Find i $O(log n)$ en nøgle, hvis afstand til sin forgænger er lig roden $r."maxGap"$.
  ],
  answer: [(a) $v."min", v."max"$ fra børnenes; $v."maxGap" = max$ af de to børns $"maxGap"$ og de to straddle-afstande $v."key" - L."max"$ og $R."min" - v."key"$. (b) Felterne afhænger kun af node + børn, så augmenteringssætningen (CLRS) holder $O(log n)$. (c) Følg den fire-vejs-gren ned, der realiserede $G$.],
  blueprint: [
    En augmentering (augmentation), der er en funktion af en node og dens to børns gemte felter, komponerer nedefra-op (augmenteringssætningen (augmentation theorem) for RB-træer).

    + *Felter $O(1)$.* Sæt $v."min" = L."min"$ (eller $v."key"$ uden venstre barn), $v."max" = R."max"$. For $v."maxGap"$ er kandidaterne: gaps i hvert undertræ, plus de to straddle-gaps om $v$.
    + *Vedligehold.* Indsæt/slet ændrer kun én rod-til-blad-sti — genregn felterne nedefra-op, $O(1)$ pr. node. Rotationer er lokale: genregn de to roterede noder ($O(1)$).
    + *Find nøgle.* Gå ned fra roden, altid ind i et undertræ der stadig rummer en gap af størrelse $G$. Tjek hvilken af de fire kandidater der realiserede $v."maxGap"$.
  ],
  worked: [
    + *(a)* $v."min" = L."min"$ hvis $L != $NIL ellers $v."key"$; $v."max" = R."max"$ hvis $R != $NIL ellers $v."key"$. For
      #eq[$ v."maxGap" = max(L."maxGap", R."maxGap", v."key" - L."max", R."min" - v."key"), $]
      hvor termer for manglende børn udelades. Da BST ordner nøglerne, er $L."max"$ in-order-forgænger til $v."key"$ og $R."min"$ dens efterfølger, så de to straddle-gaps er netop de nye nabonøgle-afstande gennem $v$. Læser kun $v."key"$ og børnenes felter — $O(1)$.
    + *(b)* Hvert felt afhænger kun af $v$ og dens to børn (a). Ved CLRS' augmenteringssætning kan et felt, der genregnes i $O(1)$ fra node + børn, vedligeholdes under RB-indsæt/slet uden at ændre grænsen: selve indsæt/slet ændrer kun langs én rod-til-blad-sti ($O(log n)$ noder, $O(1)$ hver), og de $O(1)$ rotationer pr. operation er lokale.
    + *(c)* Lad $G = r."maxGap"$. Ved node $v$: er $R != $NIL og $R."min" - v."key" = G$, returnér $R."min"$ (forgænger $v."key"$). Er $L != $NIL og $v."key" - L."max" = G$, returnér $v."key"$ (forgænger $L."max"$). Ellers ligger den maksimale gap helt i venstre ($L."maxGap" = G$) eller højre undertræ — gå derned og gentag. Ét af de fire tilfælde rammer altid, da $v."maxGap"$ var $max$ af netop dem. Ét niveau ned pr. skridt, $O(1)$ arbejde $-> O(log n)$.
  ],
)

#qcard(
  tag: [Augmenteret BST: hjørnerektangel (augmentering)],
  source: "DM507 juni 2015, Opg. 10 (15%)",
  theory: <th-bst-augment>,
  prompt: [
    Gem #swap[$n$] punkter (distinkte $x$-koordinater, brugt som BST-nøgler). Hver node $v$ gemmer #swap[$v.x"max"$, $v.x"min"$, $v.y"max"$, $v.y"min"$] $=$ max/min af $x$ og $y$ over $v$'s undertræ (inkl. $v$). Hjørnerektanglen er $["rod".x"min", "rod".x"max"] times ["rod".y"min", "rod".y"max"]$. \
    *(a)* Beregn en nodes fire felter i $O(1)$ fra dens børn. \
    *(b)* Argumentér for vedligehold under indsæt/slet i $O(log n)$. \
    *(c)* Beregn arealet i $O(1)$. \
    *(d)* Find ét punkt på hver side i $O(log n)$. \
    *(e)* Opnå samme resultater med _to_ træer uden augmentering, indsæt/slet stadig $O(log n)$.
  ],
  answer: [(a) $max$/$min$ af $v$'s egen koordinat og børnenes aggregater. (b) Felter afhænger kun af node + børn $->$ CLRS-sætning. (c) Areal $= (x"max" - x"min")(y"max" - y"min")$ fra roden. (d) Min/max $x$ via key-orden; min/max $y$ via $y$-aggregat-nedstigning. (e) Ét træ keyet på $x$, ét på $y$; cache de fire ekstremer.],
  blueprint: [
    Fire aggregat-felter, hver et max/min af nodens egen koordinat og børnenes felter — komponerer nedefra-op.

    + *Felter $O(1)$.* $v.x"max" = max(v.x, L.x"max", R.x"max")$, og tilsvarende for $x"min", y"max", y"min"$. NIL-barn: drop dets term.
    + *Vedligehold.* Som maxGap: indsæt/slet rører $O(log n)$ noder, rotationer er lokale $-> O(log n)$.
    + *Areal.* Læs rodens fire aggregater, $O(1)$.
    + *Sider.* Min/max $x$ er længst venstre/højre node (følg børn fra roden). Min/max $y$: stig ned styret af $y$-aggregaterne.
    + *To træer.* Hold $x$- og $y$-orden i hver sit balancerede BST; ekstremer aflæses direkte.
  ],
  worked: [
    + *(a)* $v.x"max" = max(v.x, L.x"max", R.x"max")$, $v.x"min" = min(v.x, L.x"min", R.x"min")$, og samme for $y"max", y"min"$. Max/min over $<= 3$ værdier $-> O(1)$. NIL-barn: drop dets term ($-infinity$ for max, $+infinity$ for min).
    + *(b)* Hvert felt afhænger kun af node + to børn (a). Ved CLRS' sætning: indsæt/slet rører $O(log n)$ noder, genregn nedefra-op $O(1)$ hver; en rotation ændrer kun de to roterede noders undertræer, genregn $O(1)$. Indsæt $O(1)$ rotationer, slet $O(log n)$ — alt $O(log n)$.
    + *(c)* Areal $= ("rod".x"max" - "rod".x"min") dot ("rod".y"max" - "rod".y"min")$, $O(1)$.
    + *(d)* Venstre/højre side: mindste/største $x =$ længst venstre/højre node ($x$ er nøglen) — følg venstre/højre børn fra roden, $O(log n)$. Bund/top: mindste/største $y$ — stig ned fra roden styret af undertræernes $y$-aggregater; ved hver node enten stop (egen $y$ rammer målet) eller gå ind i det barn, hvis undertræ bærer den ekstreme $y$. Én $O(log n)$-nedstigning.
    + *(e)* Hold punkterne i to balancerede BST'er: træ $X$ keyet på $x$, træ $Y$ keyet på $y$. Areal: min/max $x =$ længst venstre/højre i $X$, min/max $y =$ samme i $Y$; cache de fire ekstremer og opfrisk dem i $O(1)$ pr. indsæt/slet. Sideunkter: længst venstre/højre i $X$ giver venstre/højre side, i $Y$ giver bund/top. Indsæt/slet i begge træer $-> O(log n)$. Ingen aggregat-felter nødvendige.
  ],
)

#qcard(
  tag: [Hashing: dobbelt hashing (double hashing)],
  source: "DM02 jan 2006, Opg. 1a (7%)",
  theory: <th-bst-double-hashing>,
  prompt: [
    Åben hashtabel, $m = #swap[$11$]$ pladser. $h_1(k) = k mod #swap[$11$]$, $h_2(k) = #swap[$1$] + (k mod #swap[$10$])$, probe-sekvens $h(k, i) = (h_1(k) + i dot h_2(k)) mod #swap[$11$]$. Starttabel (indeks : værdi): #swap[$3:14$, $7:3$, $9:41$] (resten tomme). Indsæt nøgle #swap[$18$]; hvilken plads ender den i?
  ],
  answer: [$18 ->$ plads $5$ ($h_1 = 7$ optaget, $i=1$ rammer $5$).],
  blueprint: [
    For hver nøgle: regn $h_1$ og $h_2$, og prøv $i = 0, 1, 2, dots$ på indeks $(h_1 + i dot h_2) mod m$, indtil en plads er tom.

    + *Basis-hash.* Regn $h_1(k)$ (startplads) og $h_2(k)$ (skridtlængde).
    + *Probe.* Tæl $i$ op fra $0$; hvert skridt hopper $h_2(k)$ frem (med wrap mod $m$).
    + *Placér.* Sæt $k$ i den første tomme plads.
  ],
  worked: [
    + Indsæt $18$: $h_1 = 18 mod 11 = 7$, $h_2 = 1 + (18 mod 10) = 9$.
    + $i=0 -> (7 + 0) mod 11 = 7$ optaget (værdi $3$).
    + $i=1 -> (7 + 9) mod 11 = 16 mod 11 = 5$ tom $->$ placér. \
      Svar: plads $5$.
  ],
)

#qcard(
  tag: [Augmenteret RB-træ: MinAbove (augmentering)],
  source: "DM507 jan 2008, Opg. 3 (30%)",
  theory: <th-bst-augment>,
  prompt: [
    Punkter i planen med positive heltalskoordinater og distinkte $x$-værdier. De ligger i et rød-sort træ keyet på $x$; hver node $v$ gemmer desuden #swap[$v.y"max"$] $=$ største $y$-koordinat i $v$'s undertræ. Forespørgslen $"MinAbove"(t)$ returnerer blandt alle punkter med $y >= t$ det med mindst $x$ (eller "none"). \
    *(a)* Beregn $"MinAbove"(#swap[$10$])$ for punkterne #swap[$(4,9), (5,17), (19,6), (23,10), (25,15), (40,7)$]. \
    *(b)* Argumentér for, at $y"max"$ kan vedligeholdes under indsæt/slet uden at ændre $O(log n)$. \
    *(c)* Illustrér indsættelsen af punktet #swap[$(30,11)$] (opdatér $y"max"$ langs stien). \
    *(d)* Giv en $O(log n)$-algoritme for $"MinAbove"(t)$.
  ],
  answer: [(a) $(5,17)$. (b) $y"max"$ afhænger kun af node + børn $->$ CLRS' augmenteringssætning holder $O(log n)$. (c) $(30,11)$ bliver rød venstre-blad under $(40,7)$; kun $(40,7).y"max"$ ændres til $11$, ingen rotation. (d) Foretræk venstre undertræ når $L.y"max" >= t$, ellers noden selv, ellers højre — én rod-til-blad-sti.],
  blueprint: [
    Et felt, der kun afhænger af noden selv og dens to børns felter, kan vedligeholdes uden at ændre RB-grænserne (augmenteringssætningen). Forespørgslen bruger feltet til at beskære.

    + *Feltet.* $v.y"max" = max(v.y, L.y"max", R.y"max")$; et manglende barn tæller som $-infinity$.
    + *Vedligehold.* Indsæt/slet rører kun én rod-til-blad-sti — genregn $y"max"$ nedefra-op, $O(1)$ pr. node. En rotation er lokal: genregn den nederste node først, så den øverste.
    + *Forespørgsel.* Foretræk altid venstre side (mindst $x$), hvis den stadig kan rumme et punkt med $y >= t$ (dvs. $L.y"max" >= t$); ellers tjek noden selv; ellers gå til højre.
  ],
  worked: [
    + *(a)* Punkter med $y >= 10$: $(5,17), (23,10), (25,15)$. Mindst $x$ blandt dem er $5$. Så $"MinAbove"(10) = (5,17)$.
    + *(b)* Hvert felt afhænger kun af node og dens to børn: $v.y"max" = max(v.y, L.y"max", R.y"max")$. Ved CLRS' augmenteringssætning kan et sådant felt vedligeholdes uden at ændre grænsen. Indsæt/slet ændrer kun langs én rod-til-blad-sti ($O(log n)$ noder, $O(1)$ hver), og de $O(1)$ rotationer pr. operation genregner blot de to roterede noder ($O(1)$). Alt $O(log n)$.
    + *(c)* Starttræ (rod $(19,6)$, $y"max"=17$): venstre $(4,9)$ ($y"max"=17$, højre barn $(5,17)$); højre $(25,15)$ med børn $(23,10)$ og $(40,7)$. \
      BST-søgning på $x=30$: $30 > 19 ->$ højre til $(25,15)$; $30 > 25 ->$ højre til $(40,7)$; $30 < 40 ->$ venstre barn af $(40,7)$ (tomt). Indsæt $(30,11)$ som rødt blad, $y"max" = 11$. \
      Opdatér op ad stien: $(40,7).y"max" = max(7, 11) = 11$ (var $7$); $(25,15).y"max" = max(15, 10, 11) = 15$ (uændret); $(19,6).y"max" = max(6, 17, 15) = 17$ (uændret). Forælder $(40,7)$ er sort, så ingen rød-rød-konflikt og ingen rotation.
    + *(d)* Kald $"MinAbove"("rod", t)$:
      #eq[$
        &"MinAbove"(v, t): \
        &quad "hvis" v = "NIL" "eller" v.y"max" < t: quad "returnér NONE" \
        &quad "hvis" L != "NIL" "og" L.y"max" >= t: quad "returnér MinAbove"(L, t) \
        &quad "hvis" v.y >= t: quad "returnér" v \
        &quad "returnér MinAbove"(R, t)
      $]
      Første vagt forkaster et helt undertræ i $O(1)$ via $y"max"$. Vi går ind i præcis ét barn pr. niveau, så vi følger én rod-til-blad-sti $-> O(log n)$. Korrekt: punkterne er ordnet på $x$ venstre-mod-højre, så hvis venstre undertræ rummer et punkt med $y >= t$, har det mindre $x$ end både noden og hele højre undertræ og må være svaret; ellers vinder noden selv (alt til venstre fejler); ellers ligger svaret til højre.
  ],
)
