---
name: v-model-tests
version: 1.2.1
description: >
  Skill pour la branche droite du modèle en V : tests unitaires, tests
  d'intégration, tests d'acceptance et tests de validation système. Utiliser
  quand on doit écrire des tests de n'importe quel niveau, générer des
  procédures de test, ou maintenir la matrice de traçabilité tests/exigences.
  Chaque niveau de test est le miroir d'un niveau de spécification et se
  prépare en même temps que ce niveau, pas après l'implémentation.
---

# Tests : branche droite du V

## Principe fondamental

**Tester n'est pas trouver des bugs.**
Tester, c'est vérifier qu'une décision prise à gauche du V est respectée à droite.

- Un test sans exigence tracée n'a pas de raison d'être.
- Une exigence sans test est non vérifiable -- donc inutile.
- Les cas de test s'écrivent depuis les critères d'acceptance, pas depuis le code.
- Chaque niveau de test se prépare **en même temps** que son niveau miroir.

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

**Vérifient :** chaque composant fait ce que sa spécification détaillée stipule.
**Isolement :** toutes les dépendances sont remplacées par des substituts (mocks/stubs).

### Template de generation de tests unitaires

```
**Contexte :**

**LLD du composant :** [contenu ou référence]
**Implémentation :** [code du composant]

## Tâche

- Générer les tests unitaires pour [NomComposant].

## Contraintes

- Un test positif et un test négatif pour chaque règle métier du LLD
- Couvrir les cas limites identifiés dans le LLD
- Couvrir chaque transition de la machine d'états si applicable
- Nommage : [Méthode]_[Condition]_[RésultatAttendu]
- Chaque test référence son exigence source en commentaire
- Les dépendances sont toutes mockées (aucune vraie BDD, aucun vrai réseau)

## Format

- Un bloc de test par règle metier, avec le cas positif et négatif adjacents
```

### Règles de couverture

La couverture de code (code coverage) est un indicateur insuffisant seul.
Ce qui compte : chaque règle metier du LLD a au moins un test positif et un négatif.

**Questions à poser pour chaque règle LLD :**
- Qu'est-ce qui se passe quand la précondition est satisfaite ?
- Qu'est-ce qui se passe quand elle ne l'est pas ?
- Qu'est-ce qui se passe à la limite exacte (cas frontière) ?

**Règle obligatoire pour toute règle à seuil numérique : 3 cas minimum.**
```
Cas 1 : valeur strictement inférieure au seuil  -> comportement nominal
Cas 2 : valeur exactement égale au seuil        -> cas frontière (souvent le plus révélateur)
Cas 3 : valeur strictement supérieure au seuil  -> comportement de rejet
```
Le cas 2 est celui que les développeurs oublient le plus souvent et
qui révèle les erreurs de comparaison (< vs <=).

---

## 2. Tests d'intégration (miroir du HLD)

**Vérifient :** les composants communiquent comme l'architecture le spécifie.
**Pas de mock des dépendances internes.** Implémentations réelles.

### Template de generation de tests d'intégration

```
# Contexte

- Section HLD / ADR concernee : [contenu]
**Composants testes :** [liste]
**Implémentations disponibles :** [fichiers ou références]

## Tâche

- Générer les tests d'intégration pour [interaction entre composants].

## Contraintes

- Utiliser les implémentations réelles (pas de mocks internes)
- Seules les dépendances externes sont simulées (réseau, BDD de production)
- Couvrir les scénarios de panne (perte de liaison, erreur de persistance)
- Couvrir les comportements spécifiés dans les ADRs pertinents
- Chaque test référence son ADR ou exigence source

## Format

- Un test par comportement d'intégration spécifié dans le HLD
```

### Scénarios prioritaires

- Flux de données nominal entre composants.
- Propagation des erreurs (un composant en erreur impacte-t-il correctement les autres ?).
- Comportements lors des transitions d'état (machine d'états inter-composants).
- Garanties de persistance (intégrité en cas de coupure).

---

## 3. Tests d'acceptance (miroir du SRS)

**Vérifient :** le logiciel satisfait ses exigences du point de vue de l'utilisateur.
**En défense :** souvent formels, avec procès-verbal signé.

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

## Critère de succès

- [Condition observable et mesurable]

## Critère d'échec

- [Ce qui constitue un échec -- aussi précis que le succès]

## Matériel spécifique

- [Si applicable : banc de simulation, équipement de mesure, etc.]
```

### Template de generation de procedures d'acceptance

```
**Contexte :**

**SRS valide :** [exigences concernees SW-F-XXX, SW-S-XXX]

## Tâche

- Rédiger les procédures de test acceptance pour [liste d'exigences].

## Contraintes

- Méthode de vérification selon SW-V-XXX pour chaque exigence
- Critère de succès numérique et non ambigu
- Préconditions complètement spécifiées
- Étapes exécutables par un technicien sans interprétation

## Format

- Une procedure complete par exigence, format standardise ci-dessus
```

---

## 4. Tests de validation système (miroir du SRD)

**Vérifient :** le système complet, dans son environnement réel (ou proche),
satisfait les exigences système.
**Implique :** logiciel + matériel cible + interfaces réelles ou simulateurs haute fidélité.

**Règle de dérivation depuis les parcours :**
- Flux nominal d'un parcours → un scénario TVS principal (TC-SYS-F-XXX-NOM)
- Chaque variante d'erreur d'un parcours → un scénario TVS alternatif (TC-SYS-F-XXX-ERR-N)
- Un parcours sans scénario TVS = validation système incomplète

### Format de procedure de validation système

```
# Procédure de test : TC-SYS-F-XXX

**Exigence source :** SYS-F-XXX
**Méthode :** [test / analyse / inspection / démonstration]
**Environnement :** [matériel et configuration requis]

## Préconditions

- [Configuration système complète requise]
- [Simulateurs ou équipements nécessaires]

## Scénario

- [Parcours source : NOM-PARCOURS, flux : nominal / variante N]
- [Description du scénario opérationnel joué]

## Étapes

- 1. [Action]
- 2. [Mesure]
- ...

## Critère de succès

- [Mesure précise sur N répétitions si applicable]

## Critère d'échec

- [Seuil de rejet]
```

### Template de generation de procedures TVS

```
**Contexte :**

**SRD valide :** [exigences concernées SYS-F-XXX]
**Parcours utilisateur :** [liste des parcours documentés en phase amont]

## Tâche

- Générer les procédures de validation système pour [liste d'exigences].

## Contraintes

- Chaque parcours utilisateur documenté en phase amont a au moins un scénario TVS associé
- Les variantes d'erreur des parcours génèrent des scénarios TVS distincts
- Environnement de test spécifié (matériel cible ou simulateur haute fidélité)
- Critère de succès mesurable et non ambigu

## Format

- Une procédure complète par scénario, format standardisé ci-dessus
```

### Points spécifiques à la validation système

- Tester dans les conditions opérationnelles réelles si possible.
- Inclure des utilisateurs réels (pas uniquement des ingénieurs).
- Tester les scénarios de panne et de mode dégradé.
- Documenter les déviations entre conditions de test et conditions opérationnelles.

---

## 5. Matrice de traçabilité tests / exigences

À maintenir dans `docs/tests/traceability.md`. Mise à jour après chaque sprint.

**Format :**

| Identifiant test | Type | Exigence source | Niveau | Statut |
|---|---|---|---|---|
| [nom du test] | Unitaire | SW-F-XXX | Niveau 4 | Passe / Échec / À exécuter |
| TC-SW-F-XXX | Acceptance | SW-F-XXX | Niveau 2 | À exécuter |

**Requêtes de contrôle régulier :**

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
- [ ] Toutes les règles métier du LLD ont au moins un test positif et négatif
- [ ] Tous les tests d'intégration passent
- [ ] Tous les ADRs ont au moins un test d'intégration associé
- [ ] Toutes les procédures d'acceptance sont exécutées et les résultats documentés
- [ ] Toutes les procédures de validation système sont exécutées
- [ ] Chaque parcours utilisateur (flux nominal + variantes) a au moins un scénario TVS associé
- [ ] La matrice de traçabilité est complète (aucune exigence sans test)
- [ ] Les procès-verbaux de recette sont signés (si requis contractuellement)
```

---

## Anti-patterns fréquents

- Tests écrits en lisant le code (testent ce que le code fait, pas ce qu'il devrait faire).
- Tests sans assertion (ils passent toujours, ne vérifient rien).
- Tests qui dépendent les uns des autres (ordre d'exécution caché).
- Procédures d'acceptance sans critère de succès numérique.
- Matrice de traçabilité reconstituée en fin de projet.
- Tests unitaires avec de vraies dépendances (réseau, BDD) -- ce sont des tests d'intégration.
- "On testera quand ce sera fini" -- les tests se préparent en même temps que les specs.
