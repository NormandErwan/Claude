---
name: v-model-niveau-1
description: >
  Skill pour le Niveau 1 du modèle en V : Exigences système (System
  Requirements Document). Utiliser après validation de la phase amont,
  pour transformer le besoin client en exigences vérifiables et traçables.
  Déclencher quand on doit rédiger ou valider un SRD, des exigences système,
  ou un cahier des charges système. Prerequis : v-model-phase-amont valide.
  Skill suivant : v-model-niveau-2.
---

# Niveau 1 : Exigences système (SRD)

## Contexte

**Répond a :** que doit faire le système complet, et dans quel contexte ?
**Agnostique a la solution :** ne presuppose pas logiciel, materiel, ou procedure.
**Input :** EBO valide + Charte signee.
**Output :** System Requirements Document (SRD).
**Skill suivant :** `v-model-niveau-2`.

---

## Roles

| Role | Responsabilité |
|---|---|
| Analyste / Responsable produit | Redige le SRD |
| Representant client | Valide chaque exigence |
| Responsable technique | Verifie la vérifiabilité et l'absence de solutions presupposees |
| Autorite d'homologation (si applicable) | Valide les exigences reglementaires |

---

## Critères de qualité d'une exigence

Chaque exigence doit être :
- **Unique** : une seule idee par exigence.
- **Vérifiable** : un test est imaginable.
- **Traçable** : elle pointe vers un élément de l'EBO.
- **Non ambiguë** : une seule interpretation possible.
- **Agnostique** : elle ne dit pas "comment", seulement "quoi".

Format d'identifiant : `SYS-F-001` (fonctionnel), `SYS-NF-001` (non-fonctionnel),
`SYS-I-001` (interface), `SYS-C-001` (contrainte), `SYS-H-001` (hypothèse).

**Numérotation par sections dès le départ.** Pour tout SRD non trivial,
numéroter par tranches : SYS-F-1XX, 2XX par sous-domaine fonctionnel ;
même principe pour les autres familles. La numérotation purement
séquentielle oblige à tout renuméroter dès qu'une exigence s'insère
au milieu.

### Anti-patterns de vérifiabilité

Avant de valider le champ « Vérifiable par » de chaque exigence,
parcourir ce tableau.

| Anti-pattern | Exemple | Correction |
|---|---|---|
| Mesurer un proxy | « L'opérateur trouve la fonction rapidement » mesure la vitesse, pas la découvrabilité | Mesurer la propriété visée : « un opérateur non formé atteint la fonction en moins de N actions » |
| Critère non observable | « Le système est intuitif » — rien à observer | Définir un fait observable et mesurable de l'extérieur |
| Méthode = reformulation | « Vérifiable par : vérifier que l'exigence est respectée » | Décrire un test concret : entrée, action, sortie attendue |
| Seuil absent | « Le système doit être disponible » | Donner un seuil et une condition de mesure (renvoyé au niveau 2 si indicatif) |

---

## 0. Audit de l'EBO

L'EBO exprime un besoin, mais peut contenir du vocabulaire de solution
hérité de la phase amont. Avant de rédiger une seule exigence :

1. Parcourir l'EBO et lister tout terme qui désigne un comment plutôt
   qu'un quoi : technologies, composants, mécanismes, artefacts
   techniques (ex. un « tag », un « champ », un « écran »).
2. Pour chaque terme, formuler le besoin sous-jacent : quel but
   opérationnel sert-il ?
3. Rédiger les exigences à partir du besoin reformulé, jamais du terme
   de solution.

Exemple : un EBO qui parle de « tags personal / shared » présuppose un
mécanisme de marquage. Le besoin sous-jacent : distinguer les dépenses
selon à qui elles incombent. C'est ce besoin qui devient l'exigence ;
le mécanisme de tag est une décision de niveau 3 ou 4.

Tracer cet audit : chaque reformulation est une décision à consigner
(registre des décisions, v-model-gestion).

---

## 1. Contexte et périmètre

**Template :**
```
# Périmètre fonctionnel

**Inclus :** [ce que le système couvre]
**Exclu :** [frontière explicite -- aussi important que l'inclus]

## Parties prenantes

- [Role] : [attentes et preoccupations principales]

## Systèmes externes

- [Nom] : [nature de l'interaction]

## Environnement operationnel

- [Conditions d'utilisation : lieu, utilisateurs, contraintes physiques]
```

---

## 2. Exigences fonctionnelles système

**Questions a se poser pour chaque besoin de l'EBO :**
- Qu'est-ce que le système doit permettre a l'operateur de faire ?
- Dans quelles conditions cette action est-elle declenchee ?
- Quelle est la consequence observable attendue ?

**Template par exigence :**
```
### SYS-F-XXX : le système doit [verbe observable] [complément].

**Origine :** [référence EBO]
**Vérifiable par :** [type de test imaginable]
```

**Avant d'énumérer des règles, modéliser.** Si un besoin se traduit par
plusieurs règles qui partagent la même structure (mêmes variables, mêmes
types de cas), arrêter l'énumération dès qu'elles atteignent trois.
Modéliser le besoin sous-jacent de façon abstraite, puis vérifier qu'une
règle générale unique ne le couvre pas. N'énumérer des cas distincts que
s'ils relèvent de logiques réellement différentes.

Exemple : neuf règles de calcul de solde (nature × compte × sens) se
réduisent souvent à une seule règle paramétrée — une énumération, pas
neuf besoins.

---

## 3. Exigences non-fonctionnelles système (NFRs)

Les NFRs s'appliquent transversalement. Elles contraignent l'architecture,
pas une fonction particuliere.

**Categories a couvrir :**

| Categorie | Question a poser |
|---|---|
| Performance | Sous quelle charge, en combien de temps ? |
| Disponibilité | Quel uptime ? Quel temps de redemarrage acceptable ? |
| Fiabilité | Quel taux d'erreur acceptable ? |
| Sécurité | Quel niveau de protection des données ? |
| Maintenabilité | Qui maintient, avec quelle facilite ? |
| Utilisabilité | Qui utilise, avec quelle formation ? |
| Portabilite | Sur quels environnements ? |

**A ce niveau, les seuils sont indicatifs.** Ils seront quantifies au Niveau 2.

---

## 4. Exigences d'interface système

**Template :**
```
### SYS-I-XXX


- [description de l'interface] via [protocole/moyen impose si connu].
```

Couvrir : interfaces utilisateur, interfaces système, interfaces materiel,
interfaces de données.

---

## 5. Contraintes système

Ce qui reduit l'espace des solutions sans être un besoin fonctionnel.
Elles viennent de l'extérieur de l'équipe (reglements, contrats, stack imposee).

```
# # SYS-C-XXX


```

---

## 6. Hypothèses et dependances

Ce sur quoi le système repose mais que l'équipe ne controle pas.

```
# # SYS-H-XXX


**Risque si invalide :** [impact sur le projet].
```

---

## 7. Matrice de traçabilité EBO → SYS

Les origines en ligne dans chaque exigence ne prouvent pas la couverture.
Produire une matrice consolidée, artefact obligatoire du SRD
(docs/requirements/traceability.md).

Format : un tableau à deux colonnes — élément EBO, exigence(s) SYS qui
le couvrent.

La matrice se lit dans les deux sens :
- Élément EBO sans exigence en face : besoin non couvert. Compléter le SRD.
- Exigence SYS sans origine EBO : exigence orpheline. Deux issues, jamais
  une troisième. Soit l'EBO est incomplet : le compléter et tracer. Soit
  c'est une demande d'évolution hors Charte : la tracer comme telle via
  v-model-gestion. Ne jamais laisser une orpheline non qualifiée.

---

## Template de validation d'une exigence système

Avant d'ajouter une exigence au SRD, vérifier :

```
**Contexte :** SRD en cours, EBO valide

**Tâche :** Valider l'exigence [SYS-F-XXX]

## Contraintes

- Elle ne mentionne aucune technologie ni architecture
- Elle ne presuppose pas une solution (agnostique au "comment")
- Elle est vérifiable par observation externe
- Elle pointe vers un élément de l'EBO
- Une seule idee exprimee
**Format :** Valide / Invalide + raison si invalide
```

---

## Template de revue complete du SRD

```
**Contexte :** SRD complet, EBO valide

**Tâche :** Auditer le SRD
**Contraintes :** Verifier pour chaque exigence les 4 critères (unique,
  vérifiable, traçable, non ambiguë). Verifier que toutes les sections
  de l'EBO sont couvertes. Signaler les exigences qui glissent vers le "comment".

## Format

- Liste des exigences invalides avec raison
- Éléments de l'EBO non couverts
- Exigences qui presupposent une solution
```

---

## Porte de validation -- Niveau 1

Ne pas démarrer le Niveau 2 si une case est vide.

```
- [ ] L'audit de l'EBO a été réalisé et ses reformulations tracées
- [ ] Chaque exigence est unique, vérifiable, traçable, non ambiguë
- [ ] Aucune exigence ne présuppose une solution technique
- [ ] Tous les éléments de l'EBO sont couverts par au moins une exigence
- [ ] La matrice EBO → SYS est complète et sans exigence orpheline non qualifiée
- [ ] Le périmètre exclu est documente
- [ ] Les hypothèses sont listees avec leur risque si invalide
- [ ] Le client a valide le SRD (il reconnait son besoin dans ces exigences)
- [ ] L'autorite de validation (homologation) a valide les exigences reglementaires
- [ ] La revue critique de premier brouillon a été effectuée (voir v-model-guide)
```

---

## Minimum viable (petit projet)

Fusionner Niveaux 1 et 2 en un seul document si :
- L'allocation logiciel/materiel/procedure est triviale (tout va au logiciel).
- Le projet est entierement logiciel sans système externe significant.

Dans ce cas, conserver les identifiants distincts (SYS-F-XXX et SW-F-XXX)
même dans un document unique -- la traçabilité reste obligatoire.

---

## Anti-patterns frequents

- Exigences ecrites par l'équipe technique sans validation client.
- NFRs sans seuil ("le système doit être rapide").
- Exigences qui mentionnent une technologie ("le système doit utiliser REST").
- Exigences non traçables vers l'EBO (features inventes par l'équipe).
- Hypothèses implicites non documentees.
- SRD considéré "fige" -- il doit pouvoir être mis à jour via le processus
  de gestion des évolutions (`v-model-gestion`).
