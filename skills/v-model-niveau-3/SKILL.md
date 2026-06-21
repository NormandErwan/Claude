---
name: v-model-niveau-3
version: 1.3.0
description: >
  Skill pour le Niveau 3 du modèle en V : Architecture / High-Level Design.
  Utiliser après validation du SRS pour décider la structure du système
  logiciel et documenter chaque choix structurant via des ADRs. Déclencher
  quand on doit concevoir l'architecture, rédiger un HLD, un SAD, un dossier
  d'architecture, ou des Architecture Decision Records. Prérequis :
  v-model-niveau-2 valide. Skill suivant : v-model-niveau-4.
---

# Niveau 3 : Architecture / High-Level Design (HLD)

## Contexte

**Répond à :** comment le logiciel est-il structuré pour satisfaire les exigences ?
**Premier niveau où on répond au "comment". Chaque choix structurant doit être justifié.**
**Input :** SRS valide.
**Output :** Software Architecture Document (SAD / HLD) + ADRs.
**Skill suivant :** `v-model-niveau-4` (un LLD par composant).

---

## Roles

| Role | Responsabilité |
|---|---|
| Architecte / Responsable technique | Produit le HLD et les ADRs |
| Responsable technique | Valide que l'architecture satisfait les NFRs |
| Développeur senior | Contribue aux ADRs, évalue la faisabilité |
| Client / Autorite de validation | Revue lors du PDR (Preliminary Design Review) |

---

## Principe fondateur

Le HLD ne dit pas "voici comment implementer X".
Il dit "voici les composants qui existent, pourquoi ils existent, et pourquoi
cette structure satisfait les exigences -- en particulier les NFRs".

**Une architecture sans justification est une architecture imposee.**
Les développeurs qui ne comprennent pas pourquoi l'architecture est ainsi
vont la contourner ou la violer.

---

## 1. Vue d'ensemble architecturale

Decomposition du système en composants majeurs et leurs relations.
Outil recommande : diagramme C4 niveau Conteneurs.

**Template de description de composant :**
```
[NomComposant]
**Responsabilité unique :** [ce que ce composant fait, et seulement ca]
**Ce qu'il ne fait pas :** [delimitation explicite]
**Depend de :** [interfaces qu'il consomme]
**Expose :** [interfaces qu'il publie]
**Justification de l'existence :** [quelle exigence justifie ce composant]
```

**Règle structurante fondamentale :** un composant = une responsabilité.
Si la description d'un composant contient "et", il fait probablement deux choses.

---

## 2. ADR -- Format et processus

Chaque décision architecturale structurante fait l'objet d'un ADR.
Un ADR non écrit est une décision qui sera remise en question indéfiniment.

**Template ADR :**
```
# ADR-XXX — [titre de la décision]

**Date :** [date]
**Statut :** [Proposé / Accepté / Déprécié / Remplacé par ADR-YYY]

## Contexte

- [Situation qui rend cette décision nécessaire]
- [Exigences concernées : SW-F-XXX, SW-NF-XXX, SYS-H-XXX]

## Options considérées

**Option A :** [description]
+ [avantage]
- [inconvénient]
**Option B :** [description]
+ [avantage]
- [inconvénient]

## Décision

- [Option retenue]

## Justification

- [Pourquoi cette option satisfait mieux les exigences concernées]
- [Pourquoi les autres options ont été écartées]

## Hypothèses

- [Ce qui doit être vrai pour que cette décision reste valide]
- [Si une hypothèse est invalidée : revoir cet ADR]

## Conséquences

- [Impact sur les autres composants]
- [Dette technique introduite si applicable]
- [Contraintes posées sur les niveaux inférieurs]
```

**Quand créer un ADR :**
- Choix de pattern de communication entre composants.
- Choix de technologie de persistance.
- Choix d'isolation d'un protocole ou d'une dépendance externe.
- Toute décision dont la remise en cause coûterait plus d'une journée.

---

## 3. Interfaces entre composants

Pas encore les signatures de methode -- c'est le Niveau 4.
Ici : qui depend de qui, dans quelle direction, via quel contrat de haut niveau.

**Template :**
```
# Interfaces

- [ComposantA] -> [ComposantB] via [InterfaceNomee]
**Direction :** [A consomme B / A publie vers B]
**Nature :** [synchrone / événement / flux]

## Règles de dépendance

- [Règle 1 : ex. "les dépendances ne remontent jamais vers l'UI"]
- [Règle 2 : ex. "aucun composant ne référence une implémentation concrète"]
```

---

## 4. Contraintes transversales

Decisions qui s'appliquent a tous les composants.

**Template :**
```
# # HLD-T-XXX


**Justification :** [quelle exigence ou ADR l'impose]
**Vérifiable par :** [inspection statique / test / revue]
```

Exemples typiques : gestion de la concurrence, strategie de logging,
injection de dependances, politique de gestion d'erreur.

---

## 5. Vue de déploiement

Comment le logiciel s'exécute sur le matériel cible.

**Questions à couvrir :**
- Sur quel(s) environnement(s) le logiciel s'exécute-t-il ?
- Y a-t-il des composants serveur ? Des dépendances d'infrastructure ?
- Comment est distribué le logiciel (installeur, conteneur, service...) ?

---

## Template de brainstorming architectural

```
**Contexte :** SRS valide [fournir le SRS ou les exigences clés]

**Tâche :** Proposer 2-3 architectures candidates

## Contraintes

- Pour chaque architecture : composants, interfaces, avantages, risques
- Évaluer explicitement chaque NFR clé : [lister SW-NF-XXX pertinents]
- Identifier l'exigence la plus difficile à satisfaire dans chaque option
- Si deux architectures satisfont les mêmes NFRs à égalité, évaluer :
- (a) Testabilité : peut-on tester chaque composant indépendamment ?
- (b) Evolutivite : quelle architecture absorbe mieux les changements probables ?
- (c) Complexité pour l'équipe : compte tenu du niveau des développeurs

## Format

**Architecture A :** [nom evocateur]
**Composants :** ...
**Satisfait SW-NF-XXX car :** ...
**Risque principal :** ...
- [répéter pour B et C]
**Recommandation :** [avec justification sur les 3 critères si égalité NFRs]
```

---

## Template de validation du HLD

```
**Contexte :** HLD complet, SRS valide

**Tâche :** Valider que le HLD satisfait le SRS

## Contraintes

- Pour chaque NFR du SRS : montrer comment l'architecture la satisfait
- Identifier les NFRs pour lesquelles la satisfaction n'est pas évidente
- Identifier les couplages sans justification dans un ADR
- Vérifier que chaque composant a une responsabilité unique

## Format

**NFRs satisfaites :** [liste avec justification]
**NFRs a risque :** [liste avec plan d'action]
**Couplages injustifies :** [liste]
**Composants a refactorer :** [liste avec raison]
```

---

## Porte de validation -- Niveau 3

Ne pas démarrer le Niveau 4 si une case est vide.

```
- [ ] Chaque composant a une responsabilité unique documentée
- [ ] Chaque décision structurante a un ADR avec options considérées et justification
- [ ] Chaque NFR du SRS a une explication de satisfaction dans le HLD
- [ ] Les dépendances entre composants sont documentées et justifiées
- [ ] Les contraintes transversales sont listées et vérifiables
- [ ] La vue de déploiement est cohérente avec les contraintes du SRD (SYS-C-XXX)
- [ ] Le HLD a été revu lors du PDR (Preliminary Design Review)
```

---

## Minimum viable (petit projet)

Fusionner HLD et LLD en un seul document si le projet a moins de 5 composants.
Dans ce cas, conserver absolument :
- Un ADR pour chaque decision dont la remise en cause couterait une journee.
- La description de responsabilité de chaque composant.
- Les règles de dependance.

---

## Anti-patterns fréquents

- Architecture "big ball of mud" : composants sans responsabilité claire.
- Décisions sans ADR : "on a décidé comme ça" sans trace du pourquoi.
- ADR sans options considérées : une décision sans alternatives évaluées
  n'est pas une décision -- c'est une habitude.
- NFRs non adressées par l'architecture : elles seront des surprises à l'intégration.
- Couplage fort injustifié entre composants.
- Architecture figée : un ADR peut être remplacé (statut "Déprécié") --
  l'important est que le remplacement soit aussi documenté.
- Renommer un composant dans le HLD avec sed : les ADRs référencés comme
  "ADR-003 : Choix du composant AuthModule" ont un identifiant numérique stable
  (ADR-003) et un titre qui peut évoluer. sed ne peut pas distinguer les deux.
  Lire le HLD section par section avant tout remplacement de terme.
