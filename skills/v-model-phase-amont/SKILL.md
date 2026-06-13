---
name: v-model-phase-amont
version: 1.1.0
description: >
  Skill pour la phase amont d'un projet logiciel : capture du besoin
  operationnel, etude de faisabilité, business case, charte de projet.
  Utiliser avant tout travail technique, quand le client exprime un besoin,
  quand on démarre un projet, ou quand on doit justifier l'existence du projet.
  Prerequis obligatoire avant v-model-niveau-1.
---

# Phase amont

## Contexte

La phase amont répond a une question differente du reste du V :
**pourquoi ce projet, et est-il viable ?**
Pas encore "que doit faire le système" -- c'est "doit-on construire ce système".

**Input :** besoin exprime par le client (verbal, email, appel d'offres).
**Output :** quatre documents qui autorisent le projet a exister.
**Skill suivant :** `v-model-niveau-1` (Exigences système).

---

## Roles

| Role | Responsabilité |
|---|---|
| Analyste / Responsable produit | Produit EBO et Business Case |
| Chef de projet | Produit l'etude de faisabilité et la Charte |
| Decideur (direction, client) | Valide et signe la Charte |

---

## 1. Expression du Besoin Operationnel (EBO)

**Objectif :** capturer le problème du client dans son vocabulaire, sans contrainte de solution.

**Questions a poser au client :**
- Quel problème souffrez-vous aujourd'hui ? Comment se manifeste-t-il concretement ?
- Qui est impacte, et comment ?
- Dans quel contexte operationnel le système sera-t-il utilise ?
- Qu'est-ce qui serait different si le problème etait resolu ?

**Ordre de travail recommande :**
1. Produire un draft d'EBO depuis ce qu'on a (même incomplet).
2. Poser les questions au client pour valider et combler les zones floues.
3. Mettre a jour le draft jusqu'a validation client.
Ne pas attendre les reponses du client pour commencer -- le draft force
les bonnes questions et accelere la conversation.

**Template EBO :**
```
**Contexte :** [situation actuelle, acteurs, environnement]

**Problème :** [ce qui ne fonctionne pas, impact concret]
**Besoin :** [ce que le client veut pouvoir faire]
**Exclus :** [ce qui est explicitement hors périmètre]
**Hypothèses :** [ce qu'on suppose sur le contexte]
```

**Règles :**
- Aucune mention de technologie ou d'architecture.
- Aucune solution proposee -- uniquement le problème.
- Le client doit se reconnaitre dans ce document.

---

## 2. Etude de faisabilité

**Objectif :** vérifier que le problème est soluble dans les contraintes données.

**Template :**
```
# Faisabilité technique

**Capacités requises :** [ce que le système doit savoir faire]
**Maturité technologique :** [disponible / a developper / rupture]
**Conclusion :** [faisable / risque / non faisable]

## Faisabilité financiere

**Estimation grossière :** [ordres de grandeur, mois-homme]
**Enveloppe disponible :** [budget communique]
**Conclusion :** [coherent / tension / incompatible]

## Faisabilité calendaire

**Delai demande :** [date souhaitee par le client]
**Delai estime :** [avec les ressources disponibles]
**Conclusion :** [tenable / serré / impossible]

## Faisabilité organisationnelle

**Competences disponibles :** [ce qu'on a]
**Montee en competence requise :** [ce qu'on doit acquerir]
**Conclusion :** [autonome / accompagne / bloquant]

## Conclusion globale

**Faisable :** [oui / non / oui sous conditions]
**Conditions :** [périmètre, ressources, hypothèses a confirmer]
```

---

## 3. Business Case

**Objectif :** justifier l'investissement pour les decideurs.

**Template :**
```
# Business case

**Problème résolu :** [en une phrase, impact mesurable]
**Valeur attendue :** [gain operationnel, réduction de risque, conformite]
**Coût estimé :** [mois-homme, infrastructure, licences]
**Alternatives considérées :** [pourquoi écartées]
**Risques principaux :** [2-3 risques cles]
**Recommandation :** [developper / acheter / ne pas faire]
```

---

## 4. Charte de projet

**Objectif :** acte officiel qui autorise le projet. Nomme les responsables, fixe les contraintes.

**Template :**
```
# Périmètre

**Inclus :** [ce que le système couvre]
**Exclu :** [ce qui est hors périmètre -- aussi important que l'inclus]

## Responsables

**Responsable technique :** [nom]
**Représentant client :** [nom]
**Autorité de validation finale :** [nom]

## Budget et delai

**Budget alloué :** [mois-homme ou euros]
**Jalon de livraison :** [date]
**Jalons intermediaires :** [si applicable]

## Critères de succes

- [Ce qui doit être vrai pour que le projet soit considéré reussi]

## Contraintes majeures

- [Normes, certifications, environnements imposes, stacks techniques imposes]

## Signatures

- [Client] [Date]
- [Responsable technique] [Date]
```

---

## Porte de validation -- Phase amont

Ne pas démarrer le Niveau 1 si une de ces cases est vide.

```
- [ ] L'EBO est valide par le client (il se reconnait dans le problème decrit)
- [ ] La faisabilité conclut "faisable" ou "faisable sous conditions documentees"
- [ ] Les conditions de faisabilité sont acceptees par les parties prenantes
- [ ] La Charte est signee par le client ET le responsable technique
- [ ] Le périmètre exclu est aussi clair que le périmètre inclus
- [ ] Les hypothèses de planification sont documentees (pas implicites)
```

---

## Minimum viable (petit projet)

Sur un projet de quelques jours, Business Case et Charte peuvent être fusionnes
en un seul email ou compte-rendu de reunion de 30 minutes.
L'important : la decision de faire est tracée quelque part, même en une phrase.

**Ce qui ne peut pas être supprime :** la validation du périmètre par le client
et la liste des hypothèses. Sans elles, le scope creep est garantie.

---

## Anti-patterns frequents

- EBO ecrit par l'équipe technique sans avoir parle au client.
- Périmètre défini uniquement par ce qu'on inclut (pas ce qu'on exclut).
- Hypothèses de planification implicites ("on suppose que...") non ecrites.
- Charte non signee = projet sans mandat clair.
- Passer au Niveau 1 avant que le client ait valide l'EBO.
