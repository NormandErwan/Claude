---
name: write-french
version: 1.3.1
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

| Instead of | Write |
|---|---|
| « Ta valeur devient indirecte » | « Ce que tu apportes passe désormais par le travail des autres » |
| « jamais annulé - déplacé au pire » | « Ne l'annule jamais : au pire, déplace-le » |
| « Réversible et peu coûteuse : tranche vite, seul » | « Quand la décision est réversible et peu coûteuse, tranche vite et seul » |

### 3. Term used before being defined

Jargon the reader must already know to follow the sentence - a legal term of art
or a trade word counts exactly as much as an abstract management noun. Test: would
a competent reader outside this specific field stumble on it? If yes, define it at
first use, or replace it with what it describes - regardless of which field it
came from.

Same defect, three more sources the writer misses because they know them cold:
a named person, framework or methodology dropped without introduction (« Cockburn »,
« Patton »), a bare acronym or initialism standing for an organization, standard or
named checklist (« PMI », « INVEST »), and the document's own coined shorthand used
as if self-evidently precise (« cette frontière », « adossé »). The general test
above ("would a reader outside the field stumble?") does not apply to this trio -
a reader fluent in the field is exactly who stops noticing these went unglossed.
Test instead: could you write out in French, right now, what the acronym's letters
stand for and why the checklist or standard matters here? If the sentence doesn't
already say that, neither does the reader's memory of it. Rule: any named reference,
acronym/initialism or internal shorthand used in body prose gets a one-clause gloss
at first mention - even when an appendix or bibliography elsewhere in the same
document explains it in full, or the term is a recognized industry standard inside
the field. A guide must be self-contained on a single read-through; a reader does
not arrive at paragraph three having already read the annex, and does not carry a
professional certification just because the writer does.

| Instead of | Write |
|---|---|
| « Tu as maintenant un pouvoir asymétrique » | « Tu évalues les autres, ils ne t'évaluent pas : la même remarque n'a plus le même poids » |
| « cherche l'intérêt derrière la position » | « cherche ce que chacun veut vraiment obtenir, au-delà de ce qu'il réclame » |
| « un comportement toxique » | « des remarques qui humilient quelqu'un devant les autres » |
| « le squelette ambulant de Cockburn, les tranches de release de Patton » | « le squelette ambulant d'Alistair Cockburn - une version minimale de l'application, qui prouve que l'architecture tient - et les tranches de release de Jeff Patton » |
| « l'arbre de livrables du PMI » | « l'arbre de livrables du Project Management Institute (PMI), l'organisme qui édicte le référentiel de gestion de projet PMBOK » |
| « le critère testable d'INVEST » | « le critère testable d'INVEST - la grille en six critères (Independent, Negotiable, Valuable, Estimable, Small, Testable) qui évalue une user story » |
| « Écrire cette frontière avant le premier raffinage » | « Décider par écrit, avant le premier raffinage, ce qui relève du raffinage interne ou de l'avenant contractuel » |

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

| Instead of | Write |
|---|---|
| « Cette frontière n'est pas étanche, et il vaut mieux le dire que le masquer : cinq points du document ont besoin d'un dimensionnement pour fonctionner — E2.5, §5.2... » | « Cette frontière a une exception, assumée plutôt que cachée. Cinq points du document ont besoin d'un minimum de dimensionnement pour fonctionner : E2.5, §5.2... » |
| « Il ne correspond ni à une couche (« la base de données »), ni à un composant (« le service d'authentification »). » | « Il ne correspond pas à une couche, comme « la base de données ». Il ne correspond pas non plus à un composant, comme « le service d'authentification ». » |
| « se lit mieux que « Import d'un fichier conforme », et c'est la forme employée par les patterns du §4 » | « « Importer un fichier conforme » se lit mieux que « Import d'un fichier conforme ». C'est aussi la forme employée par les patterns du §4. » |
| « Un découpage qui n'a que des tranches n'a pas de périmètre — il ne peut ni se contractualiser, ni se contrôler en couverture » | « Un découpage qui ne contient que des tranches, sans lots, n'a pas de périmètre : il ne peut ni être contractualisé, ni être contrôlé en couverture. » |

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

## Red Flags - Stop And Rewrite

- The English back-translation reads better than your French
- An adjective doing the work of a noun (« Fréquent et petit vaut mieux... »)
- A colon or a dash standing in for the verb
- An abstract noun carrying the sentence: valeur, impact, niveau, dimension
- A jargon term used now, explained later, or never
- A named person, framework, bare acronym/initialism or internal shorthand term
  with no gloss at first use, even if an appendix explains it or the acronym is
  well known inside the field
- A sentence you could cut in two with a period and lose nothing
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
  specialists in the field all recognize it - the general "would an outside
  reader stumble" test does not apply here; a fluent reader is who stops seeing
  it as jargon
- Swapping a precise term for a more idiomatic-sounding one and drifting the
  meaning in the process - « ne vaut plus rien » is not « ne vaut rien »
- Rewriting a sentence that had no defect, for style alone
- Leaving two independent claims joined by « et », « : » or « — » because each
  half, alone, is grammatically fine - defect 6 is about idea count, not grammar
- Running the review pass on a chat reply, or skipping it on a deliverable

## Real-World Impact

Blind-scored defects per 1000 words, no-skill vs skill, across four
independent topics, registers and genres (informal management coaching,
formal technical craft, formal legal/administrative, impersonal scientific
synthesis):

| Topic | No skill | v1.0.0 | v1.1.0/1.2.0 |
|---|---|---|---|
| Management | 14.5 | 4.6 | 4.41 |
| Pastry technique | 7.26 | 3.64 | 3.14 |
| Tenant rights | 3.87 | 11.3 (regression) | 2.29 |
| Sleep/memory synthesis (held-out) | 8.76 | - | 6.22 |

v1.0.0 helped informal and technical registers but made formal legal French
worse - it missed jargon outside management vocabulary and let idiomatic
swaps drift meaning. v1.1.0 (defect 5's precision-over-idiom guardrail,
generalized defect 3) fixed the regression without hurting the other two,
and held up on a fourth topic never used to derive the fix, including a
genre with no direct address and no actionable-step structure.

**Known limit, confirmed three times across four topics, not fixed by
wording alone:** the skill still lets one field-specific term through
unglossed each time it is tested on a new domain (`pousse` in pastry,
`d'équerre` in a pastry retest, `taille d'effet` here) - a writer fluent
in a field under-flags its own jargon as jargon even when told to check
for it. Category 3's rule is sound; catching this needs a second-pass
reviewer role, not another rewording of the definition.

**v1.3.0 - defects 3 (extended) and 6, held-out topic (formal technical
methodology, dense cross-referenced corpus, a fifth register/genre):**
blind A/B, v1.2.0 vs v1.3.0, each version applied by an independent agent
that saw only its own skill text and the source excerpt (`examples/baseline-guide-lead-tech-fr.md`,
~1900 words), scored by a third agent blind to which version produced which
output:

| Defect | v1.2.0 (old) | v1.3.0 (new) |
|---|---|---|
| 3 - named refs/internal jargon unglossed | 3.62 | 3.05 |
| 6 - one sentence, several ideas | 5.68 | 2.04 |

Defect 6 dropped by two thirds - v1.2.0 had no rule against it and left 11
of the excerpt's fused sentences untouched; v1.3.0 split 7 of them cleanly.
Defect 3's extended scope (named authors, internal shorthand) moved less -
both versions still let acronym/framework references (PMI, INVEST) through
unglossed, so the fix reduces but does not close that gap. Spot-check of
defects 1, 2, 4, 5 found no regression from the new rules; one anglicism
(« legacy ») happened to survive in the new-skill run and not the old-skill
one, sampling noise rather than a rule conflict.

**v1.3.1 - why PMI/INVEST slipped through, and the fix.** A `craft-prompt`
pass on defect 3's extension found a real wording gap, not executor
carelessness: both worked examples (Cockburn, Patton) are full person names,
so nothing primed the acronym/initialism pattern; and the category's general
test ("would a reader outside the field stumble?") actively argues the wrong
way for a trade acronym - a reader fluent in project management or agile
does not stumble on PMI or INVEST, so applying that test literally says
skip them. Fix: named the acronym/initialism case explicitly alongside named
persons and frameworks, added a dedicated test ("could you write out what
the letters stand for, right now?") that does not defer to field-familiarity,
and added PMI/INVEST as worked table examples. Verified by direct inspection
against the v1.3.0 output rather than a fresh blind rescore: on
`baseline-guide-lead-tech-fr.md`, PMI and INVEST are the only two named-
reference instances that differ between the two rule texts (every other
instance - Cockburn, Patton, a third uncredited name, the document's own
"adossé" - is governed by wording neither version changed) and both are
now explicitly covered by name and by test. Estimated defect 3: ~2.1/1000w,
down from 3.05 - a further ~30% cut, on top of v1.2.0 -> v1.3.0's ~16%.
No separate isolated executor/scorer agents were available in this session
to rerun the full blind A/B, so this number is a traceable manual count,
not a fresh third-party score - flagged here rather than presented as
equivalent-strength evidence to the table above.

**Cross-topic check, v1.2.0 vs v1.3.1, a second formal-methodology document
(`examples/baseline-guide-cadrage-technique-fr.md`, ~2050 words, same
author/register as the guide-2 excerpt, different content - technical
scoping instead of project breakdown):** same manual-count method as above
(no isolated agents available), cataloguing every fused-sentence and
named-reference/acronym candidate against each version's literal rule text:

| Defect | v1.2.0 (old) | v1.3.1 (new) | vs. guide-2 result |
|---|---|---|---|
| 6 - one sentence, several ideas | ~5.35 (11/11 fused sentences untouched) | ~1.46 (3/11 remain) | Confirmed - comparable or better (-73% vs -64%) |
| 3 - named refs/internal jargon unglossed | high (0/8 named refs glossed - the rule does not exist) | partial (5/8 fixed) | Partially confirmed - the single-name-drop and acronym pattern generalizes, but exposes a new gap: a sentence listing seven bare surnames in one clause (`Nygard, Brown, Fowler, Klein, Cockburn, Fairbanks, Poppendieck`) is a structure neither version's worked examples cover, and three of the seven (Klein, Cockburn, Poppendieck - the ones never mentioned again) stay unglossed under both |

Defect 6 generalizes cleanly to a fresh document - not overfit to the
guide-2 excerpt. Defect 3 generalizes for the pattern it was built to catch
(one named reference embedded in a clause, or a bare acronym) but surfaces
a distinct, not-yet-fixed failure mode: a bare list of several names in one
enumerating sentence. Left as a known gap rather than patched now - it needs
its own worked example and wasn't part of this round's ask.
