---
name: v-model-niveau-3
version: 1.2.0
description: >
  Skill pour le Niveau 3 du modèle en V : Architecture / High-Level Design.
  Utiliser après validation du SRS pour décider la structure du système
  logiciel et documenter chaque choix structurant via des ADRs. Déclencher
  quand on doit concevoir l'architecture, rédiger un HLD, un SAD, un dossier
  d'architecture, ou des Architecture Decision Records. Prerequis :
  v-model-niveau-2 valide. Skill suivant : v-model-niveau-4.
---

# Niveau 3 : Architecture / High-Level Design (HLD)

## Contexte

**Répond a :** comment le logiciel est-il structure pour satisfaire les exigences ?
**Premier niveau ou on répond au "comment". Chaque choix structurant doit être justifie.**
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

Chaque decision architecturale structurante fait l'objet d'un ADR.
Un ADR non ecrit est une decision qui sera remise en question indefiniment.

**Template ADR :**
```
# ADR-XXX — [titre de la décision]

**Date :** [date]
**Statut :** [Proposé / Accepté / Déprécié / Remplacé par ADR-YYY]

## Contexte

- [Situation qui rend cette décision nécessaire]
- [Exigences concernees : SW-F-XXX, SW-NF-XXX, SYS-H-XXX]

## Options considérées

**Option A :** [description]
+ [avantage]
- [inconvenient]
**Option B :** [description]
+ [avantage]
- [inconvenient]

## Decision

- [Option retenue]

## Justification

- [Pourquoi cette option satisfait mieux les exigences concernees]
- [Pourquoi les autres options ont été ecartees]

## Hypothèses

- [Ce qui doit être vrai pour que cette décision reste valide]
- [Si une hypothèse est invalidee : revoir cet ADR]

## Consequences

- [Impact sur les autres composants]
- [Dette technique introduite si applicable]
- [Contraintes posees sur les niveaux inférieurs]
```

**Quand creer un ADR :**
- Choix de pattern de communication entre composants.
- Choix de technologie de persistance.
- Choix d'isolation d'un protocole ou d'une dependance externe.
- Toute decision dont la remise en cause couterait plus d'une journee.

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

## Regles de dependance

- [Regle 1 : ex. "les dependances ne remontent jamais vers l'UI"]
- [Regle 2 : ex. "aucun composant ne reference une implementation concrete"]
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

Comment le logiciel s'execute sur le materiel cible.

**Questions a couvrir :**
- Sur quel(s) environnement(s) le logiciel s'execute-t-il ?
- Y a-t-il des composants serveur ? Des dependances d'infrastructure ?
- Comment est distribue le logiciel (installeur, conteneur, service...) ?

---

## Template de brainstorming architectural

```
**Contexte :** SRS valide [fournir le SRS ou les exigences clés]

**Tâche :** Proposer 2-3 architectures candidates

## Contraintes

- Pour chaque architecture : composants, interfaces, avantages, risques
- Evaluer explicitement chaque NFR cle : [lister SW-NF-XXX pertinents]
- Identifier l'exigence la plus difficile a satisfaire dans chaque option
- Si deux architectures satisfont les memes NFRs a egalite, evaluer :
- (a) Testabilité : peut-on tester chaque composant indépendamment ?
- (b) Evolutivite : quelle architecture absorbe mieux les changements probables ?
- (c) Complexité pour l'équipe : compte tenu du niveau des développeurs

## Format

**Architecture A :** [nom evocateur]
**Composants :** ...
**Satisfait SW-NF-XXX car :** ...
**Risque principal :** ...
- [repeter pour B et C]
**Recommandation :** [avec justification sur les 3 critères si egalite NFRs]
```

---

## Template de validation du HLD

```
**Contexte :** HLD complet, SRS valide

**Tâche :** Valider que le HLD satisfait le SRS

## Contraintes

- Pour chaque NFR du SRS : montrer comment l'architecture la satisfait
- Identifier les NFRs pour lesquelles la satisfaction n'est pas evidente
- Identifier les couplages sans justification dans un ADR
- Verifier que chaque composant a une responsabilité unique

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
- [ ] Chaque composant a une responsabilité unique documentee
- [ ] Chaque decision structurante a un ADR avec options considerees et justification
- [ ] Chaque NFR du SRS a une explication de satisfaction dans le HLD
- [ ] Les dependances entre composants sont documentees et justifiees
- [ ] Les contraintes transversales sont listees et vérifiables
- [ ] La vue de déploiement est coherente avec les contraintes du SRD (SYS-C-XXX)
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

## Anti-patterns frequents

- Architecture "big ball of mud" : composants sans responsabilité claire.
- Decisions sans ADR : "on a décidé comme ça" sans trace du pourquoi.
- ADR sans options considerees : une decision sans alternatives évaluées
  n'est pas une decision -- c'est une habitude.
- NFRs non adressees par l'architecture : elles seront des surprises a l'intégration.
- Couplage fort injustifie entre composants.
- Architecture figee : un ADR peut être remplace (statut "Deprecie") --
  l'important est que le remplacement soit aussi documente.
- Renommer un composant dans le HLD avec sed : les ADRs référencés comme
  "ADR-003 : Choix du composant AuthModule" ont un identifiant numérique stable
  (ADR-003) et un titre qui peut évoluer. sed ne peut pas distinguer les deux.
  Lire le HLD section par section avant tout remplacement de terme.
