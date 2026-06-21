---
name: v-model-phase-amont
version: 1.3.0
description: >
  Skill pour la phase amont d'un projet logiciel : capture du besoin
  opérationnel, étude de faisabilité, business case, charte de projet,
  parcours utilisateur. Utiliser avant tout travail technique, quand le client
  exprime un besoin, quand on démarre un projet, ou quand on doit justifier
  l'existence du projet. Prérequis obligatoire avant v-model-niveau-1.
---

# Phase amont

## Contexte

La phase amont répond à une question différente du reste du V :
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
**Maturité technologique :** [disponible / à développer / rupture]
**Conclusion :** [faisable / risque / non faisable]

## Faisabilité financière

**Estimation grossière :** [ordres de grandeur, mois-homme]
**Enveloppe disponible :** [budget communiqué]
**Conclusion :** [cohérent / tension / incompatible]

## Faisabilité calendaire

**Délai demandé :** [date souhaitée par le client]
**Délai estimé :** [avec les ressources disponibles]
**Conclusion :** [tenable / serré / impossible]

## Faisabilité organisationnelle

**Compétences disponibles :** [ce qu'on a]
**Montée en compétence requise :** [ce qu'on doit acquérir]
**Conclusion :** [autonome / accompagné / bloquant]

## Conclusion globale

**Faisable :** [oui / non / oui sous conditions]
**Conditions :** [périmètre, ressources, hypothèses à confirmer]
```

---

## 3. Business Case

**Objectif :** justifier l'investissement pour les decideurs.

**Template :**
```
# Business case

**Problème résolu :** [en une phrase, impact mesurable]
**Valeur attendue :** [gain opérationnel, réduction de risque, conformité]
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

## Budget et délai

**Budget alloué :** [mois-homme ou euros]
**Jalon de livraison :** [date]
**Jalons intermédiaires :** [si applicable]

## Critères de succès

- [Ce qui doit être vrai pour que le projet soit considéré réussi]

## Contraintes majeures

- [Normes, certifications, environnements imposés, stacks techniques imposés]

## Signatures

- [Client] [Date]
- [Responsable technique] [Date]
```

---

## 5. Parcours utilisateur

**Objectif :** modéliser qui fait quoi dans quel ordre avant d'écrire la première exigence.

**Règle de couverture :** au moins un parcours par acteur primaire identifié dans l'EBO,
au moins un parcours d'erreur par parcours principal.

**Template :**

```markdown
# Parcours utilisateur : [NOM-PARCOURS]

**Acteur :** [rôle exact tel que défini dans l'EBO]
**Déclencheur :** [événement qui lance l'interaction]
**Précondition :** [état du système avant le déclencheur]
**Objectif opérationnel :** [ce que l'acteur cherche à accomplir]

## Étapes — flux nominal

| # | Action acteur | Réponse système | Résultat observable |
|---|---|---|---|
| 1 | | | |

## Variantes

| Variante | Étape de divergence | Comportement attendu |
|---|---|---|
| Erreur : [cas] | Étape N | |
| Cas limite : [cas] | Étape N | |

## Exigences SYS couvertes

- [SYS-F-XXX] — à compléter lors de la rédaction du SRD
```

**Arborescence :**

```
docs/00-amont/
  04-user-journeys.md   ← nouveau
```

---

## Porte de validation -- Phase amont

Ne pas démarrer le Niveau 1 si une de ces cases est vide.

```
- [ ] L'EBO est validé par le client (il se reconnaît dans le problème décrit)
- [ ] La faisabilité conclut "faisable" ou "faisable sous conditions documentees"
- [ ] Les conditions de faisabilité sont acceptées par les parties prenantes
- [ ] La Charte est signée par le client ET le responsable technique
- [ ] Le périmètre exclu est aussi clair que le périmètre inclus
- [ ] Les hypothèses de planification sont documentées (pas implicites)
- [ ] Au moins un parcours utilisateur documenté par acteur primaire de l'EBO
- [ ] Chaque parcours a au moins une variante d'erreur
- [ ] La colonne "Exigences SYS couvertes" sera complétée au Niveau 1
```

---

## Minimum viable (petit projet)

Sur un projet de quelques jours, Business Case et Charte peuvent être fusionnes
en un seul email ou compte-rendu de reunion de 30 minutes.
L'important : la decision de faire est tracée quelque part, même en une phrase.

**Ce qui ne peut pas être supprimé :** la validation du périmètre par le client
et la liste des hypothèses. Sans elles, le scope creep est garantie.

Sur un petit projet, un tableau 3 colonnes (étape / action / résultat) suffit pour les
parcours, mais le parcours lui-même ne peut pas être supprimé.

---

## Anti-patterns fréquents

- EBO écrit par l'équipe technique sans avoir parlé au client.
- Périmètre défini uniquement par ce qu'on inclut (pas ce qu'on exclut).
- Hypothèses de planification implicites ("on suppose que...") non écrites.
- Charte non signée = projet sans mandat clair.
- Passer au Niveau 1 avant que le client ait validé l'EBO.
- Parcours écrits après le SRD (ils ne servent alors plus à trouver les exigences manquantes).
- Parcours uniquement happy path (les variantes d'erreur sont la source des exigences de robustesse).
- Acteur générique "utilisateur" sans rôle défini (un parcours sans acteur nommé ne couvre rien).
