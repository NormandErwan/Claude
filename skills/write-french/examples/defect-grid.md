# French defect grid

Scoring rubric for French text meant for a human reader. Derived from a
baseline guide generated with no language instruction (`baseline-guide.md`).

Count each category separately. A rewrite that removes calques but tightens
the syntax further is not an improvement - it moved the defect, it did not
remove it.

Note on encoding: the repo is ASCII-only, but the French cells below carry
their accents. Unaccented French is misspelled French, and a rubric for
French cannot demonstrate the defect it is meant to catch.

## 1. Calque - English phrasing transposed word for word

A phrase that only makes sense once translated back to English.

| Baseline | Problem | Fix |
|---|---|---|
| « Tu seras moins souvent l'expert de la pièce » | *the expert in the room* - « la pièce » names nothing here | « Tu ne seras plus le plus compétent de l'équipe sur chaque sujet » |
| « le bruit venu d'en haut » | *noise from above* | « les demandes et les urgences de la direction » |
| « c'est un défaut de conception » (about a team) | *design flaw*, an engineering metaphor applied to people | « c'est ton organisation qui est en cause, pas les personnes » |
| « Fréquent et petit vaut mieux que rare et solennel » | *small and frequent beats rare and formal*; adjectives used as nouns | « Mieux vaut un retour court et régulier qu'un long entretien une fois par an » |

## 2. Compression that costs the meaning

The sentence is short because a word carrying the meaning was dropped.

| Baseline | Problem | Fix |
|---|---|---|
| « Ta valeur devient indirecte » | abstract, never unpacked | « Ce que tu apportes passe désormais par le travail des autres » |
| « jamais annulé - déplacé au pire » | ellipsis; the reader reconstructs the sentence | « Ne l'annule jamais : au pire, déplace-le » |
| « se discute » / « se défend » | the intended contrast is implied, not stated | « ... peut se discuter » / « ... pousse l'autre à se justifier » |
| « Réversible et peu coûteuse : tranche vite, seul » | the subject « une décision » has disappeared | « Quand la décision est réversible et peu coûteuse, tranche vite et seul » |

## 3. Term used before being defined

Jargon the reader must already know to follow the sentence. Covers named
people/frameworks, bare acronyms/initialisms, and a document's own coined
shorthand too, not just abstract nouns - and covers a term glossed only in
an appendix or bibliography, since the reader meets it in the body first.

| Baseline | Problem |
|---|---|
| « un pouvoir asymétrique » | never explained |
| « cherche l'intérêt derrière la position » | negotiation vocabulary, opaque without prior knowledge |
| « comportement toxique » | covers everything, so names nothing |
| « le niveau d'autonomie » | defined two lines after its first use |
| « le squelette ambulant de Cockburn, les tranches de release de Patton » | named methodology authors, never introduced in body text - only in a sources appendix |
| « l'arbre de livrables du PMI », « le critère testable d'INVEST » | bare acronyms/initialisms - a reader fluent in the field won't stumble on them, which is exactly why the general "would an outside reader stumble" test misses this case; test instead whether the sentence itself says what the letters stand for |
| « Écrire cette frontière avant le premier raffinage » | « frontière » is the document's own metaphor, never cashed out into a concrete action |

## 6. One sentence, several ideas

Every word is fine and the French is correct - two independent claims are
joined at a conjunction, dash or colon that a period would split cleanly.

| Baseline | Problem |
|---|---|
| « Cette frontière n'est pas étanche, et il vaut mieux le dire que le masquer : cinq points du document ont besoin d'un dimensionnement... » | two claims (there is an exception; five points need it) forced into one sentence |
| « Il ne correspond ni à une couche (...), ni à un composant (...). » | two independent negations sharing one sentence |
| « Un découpage qui n'a que des tranches n'a pas de périmètre — il ne peut ni se contractualiser, ni se contrôler en couverture » | a claim and its consequence, each complete alone |

## 4. Wrong or non-existent French

| Baseline | Problem |
|---|---|
| « N'intervient que si le résultat est en jeu » | the imperative is « n'interviens » |
| « en public et en précis » | « en précis » does not exist |

## 5. Lexical ambiguity

The first reading is not the intended one.

| Baseline | Problem |
|---|---|
| « Les gens se contredisent en réunion » | reads as contradicting themselves; mutual contradiction was meant |
| « pèse lourd chez l'autre » | an invented turn of phrase |
