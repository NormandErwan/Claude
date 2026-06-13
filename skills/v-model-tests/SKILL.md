---
name: v-model-tests
version: 1.0.0
description: >
  Skill pour la branche droite du modèle en V : tests unitaires, tests
  d'intégration, tests d'acceptance et tests de validation système. Utiliser
  quand on doit ecrire des tests de n'importe quel niveau, générer des
  procedures de test, ou maintenir la matrice de traçabilité tests/exigences.
  Chaque niveau de test est le miroir d'un niveau de spécification et se
  prepare en même temps que ce niveau, pas après l'implémentation.
---

# Tests : branche droite du V

## Principe fondamental

**Tester n'est pas trouver des bugs.**
Tester, c'est vérifier qu'une decision prise a gauche du V est respectee a droite.

- Un test sans exigence tracée n'a pas de raison d'être.
- Une exigence sans test est non vérifiable -- donc inutile.
- Les cas de test s'ecrivent depuis les critères d'acceptance, pas depuis le code.
- Chaque niveau de test se prepare **en même temps** que son niveau miroir.

---

## Navigation par niveau de test

| Niveau | Miroir de | Section |
|---|---|---|
| Tests unitaires | Niveau 4 (LLD) | Section 1 |
| Tests d'intégration | Niveau 3 (HLD) | Section 2 |
| Tests d'acceptance | Niveau 2 (SRS) | Section 3 |
| Tests de validation système | Niveau 1 (SRD) | Section 4 |
| Matrice de traçabilité | Tous niveaux | Section 5 |

---

## 1. Tests unitaires (miroir du LLD)

**Verifient :** chaque composant fait ce que sa spécification détaillée stipule.
**Isolement :** toutes les dependances sont remplacees par des substituts (mocks/stubs).

### Template de generation de tests unitaires

```
**Contexte :**

**LLD du composant :** [contenu ou référence]
**Implémentation :** [code du composant]

## Tâche

- Generer les tests unitaires pour [NomComposant].

## Contraintes

- Un test positif et un test négatif pour chaque règle metier du LLD
- Couvrir les cas limites identifies dans le LLD
- Couvrir chaque transition de la machine d'états si applicable
- Nommage : [Methode]_[Condition]_[ResultatAttendu]
- Chaque test référence son exigence source en commentaire
- Les dependances sont toutes mockees (aucune vraie BDD, aucun vrai reseau)

## Format

- Un bloc de test par règle metier, avec le cas positif et négatif adjacents
```

### Règles de couverture

La couverture de code (code coverage) est un indicateur insuffisant seul.
Ce qui compte : chaque règle metier du LLD a au moins un test positif et un négatif.

**Questions a poser pour chaque règle LLD :**
- Qu'est-ce qui se passe quand la precondition est satisfaite ?
- Qu'est-ce qui se passe quand elle ne l'est pas ?
- Qu'est-ce qui se passe a la limite exacte (cas frontiere) ?

**Règle obligatoire pour toute règle a seuil numérique : 3 cas minimum.**
```
Cas 1 : valeur strictement inférieure au seuil  -> comportement nominal
Cas 2 : valeur exactement egale au seuil        -> cas frontiere (souvent le plus revealateur)
Cas 3 : valeur strictement supérieure au seuil  -> comportement de rejet
```
Le cas 2 est celui que les développeurs oublient le plus souvent et
qui revele les erreurs de comparaison (< vs <=).

---

## 2. Tests d'intégration (miroir du HLD)

**Verifient :** les composants communiquent comme l'architecture le specifie.
**Pas de mock des dependances internes.** Implémentations reelles.

### Template de generation de tests d'intégration

```
# Contexte

- Section HLD / ADR concernee : [contenu]
**Composants testes :** [liste]
**Implémentations disponibles :** [fichiers ou références]

## Tâche

- Generer les tests d'intégration pour [interaction entre composants].

## Contraintes

- Utiliser les implémentations reelles (pas de mocks internes)
- Seules les dependances externes sont simulees (reseau, BDD de production)
- Couvrir les scenarios de panne (perte de liaison, erreur de persistance)
- Couvrir les comportements specifies dans les ADRs pertinents
- Chaque test référence son ADR ou exigence source

## Format

- Un test par comportement d'intégration specifie dans le HLD
```

### Scenarios prioritaires

- Flux de données nominal entre composants.
- Propagation des erreurs (un composant en erreur impacte-t-il correctement les autres ?).
- Comportements lors des transitions d'état (machine d'états inter-composants).
- Garanties de persistance (integrite en cas de coupure).

---

## 3. Tests d'acceptance (miroir du SRS)

**Verifient :** le logiciel satisfait ses exigences du point de vue de l'utilisateur.
**En defense :** souvent formels, avec proces-verbal signe.

### Format de procedure de test acceptance

```
# Procédure de test : TC-SW-F-XXX

**Exigence source :** SW-F-XXX
**Méthode :** [test / analyse / inspection / démonstration]
**Auteur :** [nom]
**Date de rédaction :** [date]

## Préconditions

- [État du système avant le test]
- [Données ou configuration nécessaires]

## Étapes

- 1. [Action précise]
- 2. [Action précise]
- ...

## Critère de succes

- [Condition observable et mesurable]

## Critère d'échec

- [Ce qui constitue un échec -- aussi précis que le succes]

## Materiel spécifique

- [Si applicable : banc de simulation, equipement de mesure, etc.]
```

### Template de generation de procedures d'acceptance

```
**Contexte :**

**SRS valide :** [exigences concernees SW-F-XXX, SW-S-XXX]

## Tâche

- Rediger les procedures de test acceptance pour [liste d'exigences].

## Contraintes

- Methode de verification selon SW-V-XXX pour chaque exigence
- Critère de succes numérique et non ambigu
- Preconditions completement specifiees
- Étapes executables par un technicien sans interpretation

## Format

- Une procedure complete par exigence, format standardise ci-dessus
```

---

## 4. Tests de validation système (miroir du SRD)

**Verifient :** le système complet, dans son environnement reel (ou proche),
satisfait les exigences système.
**Implique :** logiciel + materiel cible + interfaces reelles ou simulateurs haute fidelite.

### Format de procedure de validation système

```
# Procédure de test : TC-SYS-F-XXX

**Exigence source :** SYS-F-XXX
**Méthode :** [test / analyse / inspection / démonstration]
**Environnement :** [materiel et configuration requis]

## Préconditions

- [Configuration système complete requise]
- [Simulateurs ou equipements nécessaires]

## Scénario

- [Description du scenario operationnel teste]

## Étapes

- 1. [Action]
- 2. [Mesure]
- ...

## Critère de succes

- [Mesure précise sur N repetitions si applicable]

## Critère d'échec

- [Seuil de rejet]
```

### Points spécifiques a la validation système

- Tester dans les conditions operationnelles reelles si possible.
- Inclure des utilisateurs reels (pas uniquement des ingenieurs).
- Tester les scenarios de panne et de mode degrade.
- Documenter les deviations entre conditions de test et conditions operationnelles.

---

## 5. Matrice de traçabilité tests / exigences

A maintenir dans `docs/tests/traceability.md`. Mise a jour après chaque sprint.

**Format :**

| Identifiant test | Type | Exigence source | Niveau | Statut |
|---|---|---|---|---|
| [nom du test] | Unitaire | SW-F-XXX | Niveau 4 | Passe / Échec / A exécuter |
| TC-SW-F-XXX | Acceptance | SW-F-XXX | Niveau 2 | A exécuter |

**Requetes de controle regulier :**

```
# Tâche

## Contraintes

- Lister les exigences sans test associé (couverture manquante)
- Lister les tests sans exigence (code non demande)
- Lister les tests en échec avec leur exigence source

## Format

**Exigences non couvertes :** [liste]
**Tests orphelins :** [liste]
**Échecs actifs :** [liste avec impact sur livraison]
```

---

## Porte de validation -- Tests

Avant livraison :

```
- [ ] Tous les tests unitaires passent
- [ ] Toutes les règles metier du LLD ont au moins un test positif et négatif
- [ ] Tous les tests d'intégration passent
- [ ] Tous les ADRs ont au moins un test d'intégration associé
- [ ] Toutes les procedures d'acceptance sont exécutées et les résultats documentes
- [ ] Toutes les procedures de validation système sont executees
- [ ] La matrice de traçabilité est complete (aucune exigence sans test)
- [ ] Les proces-verbaux de recette sont signes (si requis contractuellement)
```

---

## Anti-patterns frequents

- Tests ecrits en lisant le code (testent ce que le code fait, pas ce qu'il devrait faire).
- Tests sans assertion (ils passent toujours, ne verifient rien).
- Tests qui dependent les uns des autres (ordre d'execution cache).
- Procedures d'acceptance sans critère de succes numérique.
- Matrice de traçabilité reconstituee en fin de projet.
- Tests unitaires avec de vraies dependances (reseau, BDD) -- ce sont des tests d'intégration.
- "On testera quand ce sera fini" -- les tests se preparent en même temps que les specs.
