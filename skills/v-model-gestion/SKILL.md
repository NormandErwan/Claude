---
name: v-model-gestion
version: 1.2.1
description: >
  Skill pour les artefacts de gestion de projet dans le modèle V : plan de
  projet, registre des risques, registre des decisions, gestion des
  configurations, gestion des évolutions, tableau de bord, et jalons de
  revue. Utiliser quand on démarre un projet, quand on gère des risques,
  quand le client demande une évolution, ou quand on prepare une revue de
  jalon. Complément obligatoire de tous les autres skills V-model.
---

# Artefacts de gestion

## Contexte

Les artefacts de gestion pilotent le projet sans décrire ce qu'on construit.
Ils répondent a : **est-ce que le projet se deroule comme prévu, et sinon que fait-on ?**

Ces documents existent en parallele du V -- ils ne sont pas dans le V, ils l'entourent.

---

## Roles

| Role | Responsabilité |
|---|---|
| Chef de projet | Plan, tableau de bord, jalons |
| Responsable technique | Registre des risques, registre des decisions, gestion des configurations |
| Tout le monde | Signaler les risques et blocages |

---

## 1. Plan de projet

**Objectif :** contrat interne de l'équipe. Établi en début de projet,
mis à jour à chaque jalon significatif.

**Template :**
```
# Phases et jalons

- [Phase] : [dates de debut et fin]
- [Jalon] : [date] -- [critère de validation]

## Dépendances

- [Phase A] bloque [Phase B] car [raison]
- [Livraison externe] attendue le [date] -- bloque [Phase X]

## Allocation des ressources

- [Personne / Équipe] : [activite] de [date] a [date]

## Hypothèses de planification

****hp-001 :** ** [hypothèse]. Si invalide : [impact sur le plan].
****hp-002 :** ** [hypothèse]. Si invalide : [impact sur le plan].
```

**Règle :** si le plan suppose quelque chose sur l'environnement extérieur,
c'est une hypothèse de planification -- elle doit être documentée.

---

## 2. Registre des risques

**Objectif :** liste vivante des risques identifiés. Mise à jour à chaque revue.

**Format par risque :**

| Champ | Description |
|---|---|
| Identifiant | RSK-XXX |
| Description | [Quoi pourrait mal se passer, et comment] |
| Probabilité | Faible / Moyenne / Élevée |
| Impact | Faible / Moyen / Élevé -- [conséquence concrète] |
| Strategie | Mitigation / Contingence / Acceptation / Transfert |
| Action | [Ce qu'on fait concretement] |
| Proprietaire | [Qui surveille ce risque] |
| Statut | Ouvert / Surveille / Clos |

**Stratégies :**
- **Mitigation :** réduire la probabilité (ex. : prototype technique avant le design).
- **Contingence :** plan B si le risque se matérialise.
- **Acceptation :** on assume -- décision documentée, pas ignorée.
- **Transfert :** rendre le risque contractuel (assurance, clause pénale).

**Template de détection de risques :**
```
**Contexte :** [phase ou niveau du projet]

**Tâche :** Identifier les risques non encore documentés

## Contraintes

- Risques techniques (hypothèses non confirmées, dépendances externes)
- Risques planning (livraisons tierces, disponibilité des parties prenantes)
- Risques métier (évolution du besoin, contraintes réglementaires)
- Risques équipe (compétences, disponibilité)

## Format

**Pour chaque risque :** description, probabilité, impact, strategie proposee
```

---

## 3. Registre des decisions

**Distinct des ADRs techniques.** Couvre les decisions de gestion :
périmètre, budget, organisation, arbitrages client.

**Format :**
```
# DCL-XXX — [date]

**Décision :** [ce qui a été décidé]
**Contexte :** [pourquoi cette décision était nécessaire]
**Parties prenantes :** [qui a décidé]
**Conséquences :** [impact sur le périmètre / planning / budget]
**Référence :** [CR-XXX si lié à une demande d'évolution]
```

**Règle :** toute decision qui modifie le périmètre, le budget ou le planning
doit avoir une entree dans ce registre. Même les petites.

---

## 4. Gestion des configurations

**Objectif :** garantir qu'on sait exactement ce qui a été livré à quelle date.

**Éléments sous configuration :**
- Code source (versionne avec tags).
- Documents du V (SRD, SRS, HLD, LLD, procedures de test).
- Fichiers de parametres et de configuration.

**Baseline :** photo du système à un instant donné (typiquement à chaque jalon).
Elle répond a : "qu'est-ce qu'on a livre exactement le [date] ?"

**Politique de baseline :**
```
# Baseline [nom] — [date du jalon]

**Code :** [tag git ou version]
****SRD :** ** [version]
****SRS :** ** [version]
- HLD + ADRs : [version]
****LLD :** ** [version par composant]
**Procedures de test :** [version]
**Statut des tests :** [résultats]
```

---

## 5. Gestion des évolutions (Change Management — interne ou client)

Quand une évolution est demandée en cours de projet — par le client, ou par
l'équipe technique quand l'implémentation révèle qu'une décision amont est
erronée (voir `v-model-implementation`).

**Processus :**

```
# Étape 1

**CR-XXX — [date] :**
**Demande :** [description de ce que le client veut]
**Demandeur :** [client / partie prenante / équipe technique]

**Étape 2 :** Impact Assessment
**Impact fonctionnel :** [documents du V a modifier]
**Impact planning :** [nombre de jours de charge supplémentaire]
**Impact budget :** [cout additionnel]
**Documents impactes :** [SRD / SRS / HLD / LLD / tests]

**Étape 3 :** Décision
- Accepté / Refusé / Différé -- [justification]
**Si accepté :** [mise à jour du plan et des documents]
**Validé par :** [selon politique de délégation ci-dessous]

POLITIQUE DE DÉLÉGATION (à définir en début de projet et documenter dans la Charte) :
- < 1 jour-homme, dans l'enveloppe budget -> Responsable technique seul
- 1 à 5 jours-homme                       -> Responsable technique + confirmation client
- > 5 jours-homme ou hors enveloppe       -> Client + direction, par avenant contractuel

**Étape 4 :** Mise à jour
**Documents modifies :** [liste]
**Baseline mise à jour :** [version]
**Registre des decisions :** DCL-XXX
```

**Le scope creep se produit quand les étapes 1 a 3 sont absentes.**
Chaque petite demande non tracée s'accumule silencieusement.

---

## 6. Tableau de bord et rapport d'avancement

**Fréquence :** hebdomadaire ou par sprint.

**Template :**
```
# Rapport d'avancement — [date]


## Avancement

**Jalons complétés :** [liste]
**Jalons en retard :** [liste + cause + nouveau délai prévu]
**Avancement global :** [X% complete selon plan]

## Risques actifs

**[rsk-xxx] :** [statut + action en cours]

## Décisions en attente

- [Ce qui bloque et qui doit trancher, avec echeance]

## Prevision a fin de projet

**Délai :** [à jour / retard de N semaines / avance]
**Budget :** [à budget / dépassement de N %]
```

**Signal d'alarme :** un tableau de bord toujours vert jusqu'au jour ou tout
s'effondre n'est pas un outil de pilotage -- c'est de la communication descendante.
Les problèmes doivent remonter tot, pas être caches.

---

## 7. Jalons de revue

| Jalon | Après | Ce qu'on verifie |
|---|---|---|
| SRR (System Requirements Review) | Niveau 1 | Exigences système complètes et cohérentes |
| SFR (Software Functional Review) | Niveau 2 | Exigences logiciel couvrent les exigences système |
| PDR (Preliminary Design Review) | Niveau 3 | Architecture satisfait les exigences, risques maîtrisés |
| CDR (Critical Design Review) | Niveau 4 | Conception suffisante pour démarrer l'implémentation |
| TRR (Test Readiness Review) | Avant tests | Environnement prêt, procédures écrites |
| FAT (Factory Acceptance Test) | Après tests | Système satisfait les exigences -- livraison autorisée |

**En contexte défense :** ces jalons sont souvent contractuels et donnent lieu
à des revues formelles avec le client, avec un compte-rendu signé.

---

## Template de preparation d'un jalon de revue

```
**Contexte :** Jalon [nom] — [date]

**Tâche :** Préparer le dossier de revue

## Contraintes

- Lister les livrables attendus a ce jalon
- Vérifier la porte de validation du niveau correspondant
- Identifier les points ouverts (risques, décisions en attente, écarts)
- Préparer les questions que le client posera probablement

## Format

**Livrables disponibles :** [liste avec statut]
**Points ouverts :** [liste avec responsable et echeance]
**Questions anticipées :** [liste avec réponses préparées]
```

---

## Anti-patterns fréquents

- Registre des risques créé en début de projet et jamais mis à jour.
- Decisions orales non tracées dans le registre -- impossible a retrouver 3 mois après.
- Évolutions acceptees verbalement sans CR ni impact assessment.
- Tableau de bord prepare pour "rassurer" plutot que pour piloter.
- Jalons purement administratifs (on signe mais on ne valide pas vraiment).
- Baselines non maintenues : impossible de savoir ce qui a été livre quand.
