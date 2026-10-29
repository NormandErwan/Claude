---
name: write-french
version: 1.4.3
description: "Use when the output is French - a chat reply in French, or a French markdown deliverable such as a guide, a report or a synthesis - including when the user writes in French and expects French back. Prevents French that reads as translated English: word-for-word calques, sentences compressed until the meaning is gone, jargon used before it is defined, invented turns of phrase."
---

# Write French

## Overview

French produced without care keeps English thinking under French words. A native
reader rarely calls it wrong; they call it foreign, and they slow down to guess
what was meant.

**Core principle:** write the sentence a French speaker would have written to say
that thing - not the French translation of the English sentence.

Rules below are in English, examples in French with their accents. A translated
example proves nothing about French.

## When to Use

- Any French output: chat replies, guides, reports, syntheses
- The user writes in French, so the reply is French

**Not for:** skills, handoffs, commit messages, PR bodies, code, code
comments, README files and manifests - English by repo rule.

## Concision Has A Floor

Cut filler, politeness, hedging and restatement, always. Never cut a subject, a
verb, an article, a preposition or a linking word that carries the meaning.

A sentence that is short because a load-bearing word is missing is not concise,
it is broken: the reader spends more effort rebuilding it than the word would
have cost. Concision is measured in ideas - one idea per sentence, no idea
twice - never in characters saved.

## The Six Defects

### 1. Calque - English phrasing carried over word for word

The phrase only makes sense once translated back into English. Test: translate
it back; if the English reads better, the French is a calque.

| Instead of | Write |
|---|---|
| « Tu seras moins souvent l'expert de la pièce » | « Tu ne seras plus le plus compétent de l'équipe sur chaque sujet » |
| « le bruit venu d'en haut » | « les demandes et les urgences de la direction » |
| « Fréquent et petit vaut mieux que rare et solennel » | « Mieux vaut un retour court et régulier qu'un long entretien une fois par an » |
| « c'est un défaut de conception » (d'une équipe) | « c'est ton organisation qui est en cause, pas les personnes » |

### 2. Compression that costs the meaning

A word carrying the meaning was dropped to make the sentence shorter.

The excuse changes, the defect doesn't. A writer who prizes saying a lot in a
few words will drop a verb or a referent on the second half of a sentence and
call the result elegant - « X ne fait pas ceci, Y si » (Y does, but the verb
that says so is never written again). It isn't elegant: a reader has to
silently supply whatever was left out, on the writer's behalf, before the
sentence closes. Test: say the sentence once, aloud, as if to someone hearing
it for the first time. If a word is missing before they'd understand it, put
the word back - a shorter sentence that costs the reader a reconstruction is
not concise, per the concision floor above.

| Instead of | Write |
|---|---|
| « Ta valeur devient indirecte » | « Ce que tu apportes passe désormais par le travail des autres » |
| « jamais annulé - déplacé au pire » | « Ne l'annule jamais : au pire, déplace-le » |
| « Réversible et peu coûteuse : tranche vite, seul » | « Quand la décision est réversible et peu coûteuse, tranche vite et seul » |
| « La procédure ne change pas, son destinataire si » | « La procédure reste la même. Seul le destinataire de ce qu'elle produit change. » |

### 3. Term used before being defined

One test covers every shape this defect takes: strip away what the reader is
assumed to already know, and check whether the sentence itself still says what a
reference means and why it is here. If it doesn't, the reference is undefined -
whether that reference is an abstract management noun, a legal term of art, a
trade word, a named person or framework, a bare acronym or initialism, the
document's own coined shorthand, or one name lost inside a list of several. The
forms differ; the failure is always the same one: the writer already knows what
it means, so the sentence never bothers to say it.

The test does not depend on who the reader is - which is exactly why "would a
reader outside the field stumble?" is the wrong question for a named authority or
a trade acronym: a reader fluent in the field is precisely who stops noticing
these went unglossed. Ask the sentence-only question instead: could you write
out, right now, in French, what this stands for and why it matters here? If the
sentence doesn't already say that, neither does the reader's memory of it - and
neither does an appendix or bibliography elsewhere in the document, since the
reader meets the term in the body first, on a single read-through.

One shape needs a different fix, not a different test: several such references
thrown into one enumerating clause (« s'appuie sur des auteurs identifiés —
Nygard, Brown, Fowler, Klein, Cockburn, Fairbanks, Poppendieck »). Glossing every
name inline trades this defect for defect 6 - a wall of parenthetical asides.
Apply the same test per name instead: is this one's contribution established
anywhere else in the document? Yes - leave it bare here; that other point is its
real first use, and the list is only an index of it. Never - it fails the test
exactly as an unglossed acronym would, so it has no place in the enumerating
clause: cut it, and point to wherever the source list already lives (an annex, a
bibliography) instead of pretending it was introduced in body prose.

Rule: any reference used in body prose - named person, framework, acronym,
internal shorthand, or one name inside a longer list - gets a one-clause gloss at
first use, even when an appendix explains it in full or the term is a recognized
industry standard inside the field. A guide must be self-contained on a single
read-through; a reader does not arrive at paragraph three having already read the
annex, and does not carry a professional certification just because the writer
does.

| Instead of | Write |
|---|---|
| « Tu as maintenant un pouvoir asymétrique » | « Tu évalues les autres, ils ne t'évaluent pas : la même remarque n'a plus le même poids » |
| « un comportement toxique » | « des remarques qui humilient quelqu'un devant les autres » |
| « le squelette ambulant de Cockburn, les tranches de release de Patton » | « le squelette ambulant d'Alistair Cockburn - une version minimale de l'application, qui prouve que l'architecture tient - et les tranches de release de Jeff Patton - des regroupements d'éléments assez complets pour être démontrés » |
| « le critère testable d'INVEST » | « le critère testable d'INVEST - la grille en six critères (Independent, Negotiable, Valuable, Estimable, Small, Testable) qui évalue une user story » |
| « Écrire cette frontière avant le premier raffinage » | « Décider par écrit, avant le premier raffinage, ce qui relève du raffinage interne ou de l'avenant contractuel » |
| « Le reste s'appuie sur des auteurs identifiés — Nygard, Brown, Fowler, Klein, Cockburn, Fairbanks, Poppendieck — et sur des compositions assumées » | « Le reste s'appuie sur des auteurs identifiés — Nygard, Brown, Fowler et Fairbanks — et sur des compositions assumées. Ces quatre noms sont cités et glosés plus loin dans le texte. La liste complète des sources est en annexe E. » |

### 4. Wrong or non-existent French

| Instead of | Write |
|---|---|
| « N'intervient que si le résultat est en jeu » | « N'interviens que si le résultat est en jeu » |
| « en public et en précis » | « en public et de façon précise » |

### 5. Lexical ambiguity

The first reading is not the intended one, the turn of phrase was invented, or a
precise/established term was swapped for one that only sounds more idiomatic and
the meaning drifted in the process. In a technical, legal or administrative
register, native means the specialist's exact term, not a looser paraphrase -
check that a swap means exactly the same thing before trusting that it reads
more fluently. This is different from defect 3: there, the term is undefined for
the reader; here, the term was correct and got traded away.

| Instead of | Write |
|---|---|
| « Les gens se contredisent en réunion » | « Les gens osent contredire les autres en réunion » |
| « pèse lourd chez l'autre » | « prend beaucoup d'importance pour la personne qui la reçoit » |
| « une contestation orale ne vaut plus rien » | « une contestation orale ne vaut rien » |

### 6. One sentence, several ideas

Every word is fine and the French is correct - the sentence just joins two
independent claims at a conjunction, dash or colon. Not a calque, not compression:
splitting it changes nothing but the number of sentences. Test: if the sentence
contains two clauses each of which could stand alone as a complete, meaningful
sentence, split it at the joint. This is different from defect 2 - there, a word
is missing; here, nothing is missing, there is just too much in one sentence.

Three or more parallel claims chained by semicolons are the same defect at a
larger scale - and splitting them into bare, unconnected sentences loses the
one thing that justified grouping them: that they stand as independent
evidence for the same point. Fix by announcing the group in a lead sentence,
then giving each claim its own sentence. A semicolon rarely earns its place in
French prose; when several claims need to be held together, a colon that
introduces them does the job the semicolons were being asked to do.

| Instead of | Write |
|---|---|
| « Cette frontière n'est pas étanche, et il vaut mieux le dire que le masquer : cinq points du document ont besoin d'un dimensionnement pour fonctionner — E2.5, §5.2... » | « Cette frontière a une exception, assumée plutôt que cachée. Cinq points du document ont besoin d'un minimum de dimensionnement pour fonctionner : E2.5, §5.2... » |
| « Il ne correspond ni à une couche (« la base de données »), ni à un composant (« le service d'authentification »). » | « Il ne correspond pas à une couche, comme « la base de données ». Il ne correspond pas non plus à un composant, comme « le service d'authentification ». » |
| « se lit mieux que « Import d'un fichier conforme », et c'est la forme employée par les patterns du §4 » | « « Importer un fichier conforme » se lit mieux que « Import d'un fichier conforme ». C'est aussi la forme employée par les patterns du §4. » |
| « Un découpage qui n'a que des tranches n'a pas de périmètre — il ne peut ni se contractualiser, ni se contrôler en couverture » | « Un découpage qui ne contient que des tranches, sans lots, n'a pas de périmètre : il ne peut ni être contractualisé, ni être contrôlé en couverture. » |
| « Trois signaux le confirment : la charge a doublé sans aide supplémentaire ; les retards s'accumulent depuis trois semaines ; deux personnes ont demandé un point individuel cette semaine » | « Trois signaux le confirment. La charge a doublé sans aide supplémentaire. Les retards s'accumulent depuis trois semaines. Deux personnes ont demandé un point individuel cette semaine. » |
| « Ce découpage montre un résultat utilisable dès la première tranche, alors qu'un découpage en couches oblige à finir toute la base de données avant qu'un seul écran fonctionne » | « Ce découpage montre un résultat utilisable dès la première tranche. Un découpage en couches oblige au contraire à finir toute la base de données avant qu'un seul écran fonctionne. » |

## Review Pass - Markdown Deliverables Only

Required before delivering a French guide, report or synthesis. Not required for
chat replies: applying the rules while writing is enough there.

1. Read each sentence against the six defects, one category at a time. Mixing
   the categories in one pass hides the ones you are not looking for.
2. Rewrite only the sentences that actually hit a defect. A sentence with none
   stays untouched - polishing a clean sentence for style, not to fix a listed
   defect, is how new defects get introduced.
3. Rewrite each hit, then re-check the rewrite against all six. Removing a
   calque by compressing further moves the defect into category 2, it does not
   remove it.
4. Last check on the whole text: every jargon term defined at first use, every
   sentence has a subject and a verb.
5. Grill the sentences you found yourself admiring. A sentence that struck you
   as tight, elegant or well-turned while writing it is exactly the one to
   interrogate - the same way a design decision gets questioned before it is
   accepted, not after. Ask what it assumes the reader already knows or can
   reconstruct alone: which word, referent or link did you leave for them to
   supply? Say the sentence once, aloud, as if to someone hearing it for the
   first time with no access to the rest of the document. If they would
   stumble, or need it twice, the elegance was yours, not theirs - rewrite it.
   This step exists because defects 1-6 are patterns, and a sentence can be
   hard to parse on one read without matching any of them by the letter -
   grill it anyway; the reader doesn't care which numbered defect it was.
   Default to plain, direct phrasing over any rhetorical construction -
   cleft sentence (« C'est X qui... »), elliptical antithesis (« X ne fait
   pas ceci, Y si »), a subject-verb-splitting aside (« Le projet — lancé
   en janvier, repoussé deux fois — a finalement livré »), or other. It
   earns its place only by being clearer, never denser: dense rhetoric is
   exactly what makes a writer misjudge their own sentence as elegant, so
   it gets no benefit of the doubt.

## Red Flags - Stop And Rewrite

- The English back-translation reads better than your French
- An adjective doing the work of a noun (« Fréquent et petit vaut mieux... »)
- A colon or a dash standing in for the verb
- An abstract noun carrying the sentence: valeur, impact, niveau, dimension
- A jargon term used now, explained later, or never
- A named person, framework, bare acronym/initialism or internal shorthand term
  with no gloss at first use, even if an appendix explains it or the acronym is
  well known inside the field
- A list of several bare names in one clause where some never come back with
  a gloss anywhere else in the document
- A sentence you could cut in two with a period and lose nothing
- A cleft sentence, elliptical antithesis, subject-verb-splitting
  parenthetical, or other rhetorical construction kept over its plain
  rewrite without the rhetoric being clearer
- You noticed a sentence was elegant before you noticed whether it was clear
- A sentence you rewrote though it hit none of the six defects
- An imperative form you did not actually check
- A turn of phrase you cannot recall ever hearing

## Common Mistakes

- Shortening a clumsy sentence instead of rewriting it - defect 2 replaces defect 1
- Defining a term two lines after its first use and calling it defined
- Treating « toxique », « asymétrique », « indirect » as explanations
- Treating jargon as a management-only problem - a legal term of art
  (« contradictoire ») or a trade word (« pousse ») needs the same gloss
- Treating a bibliography or appendix entry as a definition the body text can
  skip - the reader meets the term in the body first
- Treating a trade acronym (PMI, INVEST, SRD) as self-explanatory because
  specialists in the field all recognize it - the test is whether the sentence
  itself says what it stands for, never whether this reader would stumble on it
- Treating a name in a list as covered because the list around it says "des
  auteurs" - a category word glosses the list's shape, not any one name's
  contribution
- Swapping a precise term for a more idiomatic-sounding one and drifting the
  meaning in the process - « ne vaut plus rien » is not « ne vaut rien »
- Rewriting a sentence that had no defect, for style alone
- Leaving two independent claims joined by « et », « : » or « — » because each
  half, alone, is grammatically fine - defect 6 is about idea count, not grammar
- Treating a sentence's tightness as evidence it is good, instead of testing
  whether a first-time listener would parse it in one pass - cleverness is the
  writer's reward, not the reader's; the grill step exists to catch this
- Keeping a cleft sentence, elliptical antithesis, or subject-verb-splitting
  parenthetical on a dense rhetorical register because it parses without a
  defect, instead of defaulting to the plain phrasing - passing the six
  defects is not a reason to prefer rhetoric
- Running the review pass on a chat reply, or skipping it on a deliverable

## Real-World Impact

Benchmark history and per-version rationale: see `evidence.md`.
