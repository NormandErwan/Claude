---
name: write-french
version: 1.0.0
description: Use when the output is French - a chat reply in French, or a French markdown deliverable such as a guide, a report or a synthesis - including when the user writes in French and expects French back. Prevents French that reads as translated English: word-for-word calques, sentences compressed until the meaning is gone, jargon used before it is defined, invented turns of phrase.
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

**Not for:** skills, handoffs, commit messages, PR bodies, code and code
comments - English by repo rule.

## Concision Has A Floor

Cut filler, politeness, hedging and restatement, always. Never cut a subject, a
verb, an article, a preposition or a linking word that carries the meaning.

A sentence that is short because a load-bearing word is missing is not concise,
it is broken: the reader spends more effort rebuilding it than the word would
have cost. Concision is measured in ideas - one idea per sentence, no idea
twice - never in characters saved.

## The Five Defects

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

Jargon the reader must already know to follow the sentence. Define at first use,
or replace with what it describes.

| Instead of | Write |
|---|---|
| « Tu as maintenant un pouvoir asymétrique » | « Tu évalues les autres, ils ne t'évaluent pas : la même remarque n'a plus le même poids » |
| « cherche l'intérêt derrière la position » | « cherche ce que chacun veut vraiment obtenir, au-delà de ce qu'il réclame » |
| « un comportement toxique » | « des remarques qui humilient quelqu'un devant les autres » |

### 4. Wrong or non-existent French

| Instead of | Write |
|---|---|
| « N'intervient que si le résultat est en jeu » | « N'interviens que si le résultat est en jeu » |
| « en public et en précis » | « en public et de façon précise » |

### 5. Lexical ambiguity

The first reading is not the intended one, or the turn of phrase was invented.

| Instead of | Write |
|---|---|
| « Les gens se contredisent en réunion » | « Les gens osent contredire les autres en réunion » |
| « pèse lourd chez l'autre » | « prend beaucoup d'importance pour la personne qui la reçoit » |

## Review Pass - Markdown Deliverables Only

Required before delivering a French guide, report or synthesis. Not required for
chat replies: applying the rules while writing is enough there.

1. Read each sentence against the five defects, one category at a time. Mixing
   the categories in one pass hides the ones you are not looking for.
2. Rewrite each hit, then re-check the rewrite against all five. Removing a
   calque by compressing further moves the defect into category 2, it does not
   remove it.
3. Last check on the whole text: every jargon term defined at first use, every
   sentence has a subject and a verb.

## Red Flags - Stop And Rewrite

- The English back-translation reads better than your French
- An adjective doing the work of a noun (« Fréquent et petit vaut mieux... »)
- A colon or a dash standing in for the verb
- An abstract noun carrying the sentence: valeur, impact, niveau, dimension
- A jargon term used now, explained later, or never
- An imperative form you did not actually check
- A turn of phrase you cannot recall ever hearing

## Common Mistakes

- Shortening a clumsy sentence instead of rewriting it - defect 2 replaces defect 1
- Defining a term two lines after its first use and calling it defined
- Treating « toxique », « asymétrique », « indirect » as explanations
- Running the review pass on a chat reply, or skipping it on a deliverable
