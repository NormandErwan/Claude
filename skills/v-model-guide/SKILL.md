---
name: v-model-guide
version: 1.4.0
description: >
  Point d'entrée unique pour la méthode V de développement logiciel. Utiliser
  ce skill pour tout projet logiciel structuré : démarrage de projet, question
  sur la méthode, doute sur quelle étape suivre, ou ambiguïté découverte en
  cours de travail. Contient le routage vers le bon skill selon le rôle et la
  tâche, la vue d'ensemble du modèle en V, et le protocole d'escalade.
  Déclencher systématiquement en début de projet ou quand le rôle ou l'étape
  suivante est incertaine.
---

# Guide méthode V -- Point d'entrée

## Utilisation de ce skill

**Étape 1 :** Identifier le role et la tâche dans le tableau ci-dessous.
**Étape 2 :** Lire le skill correspondant avant toute action.
**Étape 3 :** Revenir ici si une ambiguïté bloque la progression.

---

## Matrice de routage : Role x Tâche -> Skill

| Role | Tâche | Skill |
|---|---|---|
| Tout rôle | Démarrer un projet, comprendre la méthode | Ce skill (vue d'ensemble ci-dessous) |
| Analyste / Responsable produit | Capturer le besoin client, faisabilité | `v-model-phase-amont` |
| Analyste / Responsable produit | Définir les exigences système | `v-model-niveau-1` |
| Analyste / Responsable produit | Définir les exigences logiciel | `v-model-niveau-2` |
| Architecte / Responsable technique | Concevoir l'architecture, rédiger les ADRs | `v-model-niveau-3` |
| Architecte / Responsable technique | Specifier un composant en detail | `v-model-niveau-4` |
| Développeur | Implementer un composant depuis une spec | `v-model-implementation` |
| Développeur | LLD ambigu ou incomplet sur un point précis | Protocole d'escalade ci-dessous |
| Développeur / Testeur | Ecrire des tests (tous types) | `v-model-tests` |
| Responsable technique | Revue de code, tâches pour juniors | `v-model-équipe` |
| Chef de projet / Responsable technique | Risques, jalons, decisions de gestion | `v-model-gestion` |
| Tout rôle | Ambiguïté ou blocage en cours de travail | Protocole d'escalade ci-dessous |
| Tout rôle | Premier brouillon d'un artefact terminé | Revue critique ci-dessous |

Un même individu peut tenir plusieurs roles. Lire le skill correspondant a la tâche du moment.

---

## Vue d'ensemble du modèle en V

```
PHASE AMONT
|  Besoin -> Faisabilité -> Business Case -> Charte       [v-model-phase-amont]
|
+-- NIV 1 : Exigences système   <---------> Tests de validation système
|   [v-model-niveau-1]                      [v-model-tests]
|
+---- NIV 2 : Exigences logiciel <-------> Tests d'acceptance
|     [v-model-niveau-2]                   [v-model-tests]
|
+------ NIV 3 : Architecture    <--------> Tests d'intégration
|       [v-model-niveau-3]                 [v-model-tests]
|
+-------- NIV 4 : Conception    <--------> Tests unitaires
|         [v-model-niveau-4]               [v-model-tests]
|
+---------- IMPLÉMENTATION                 [v-model-implementation]
```

**Branche gauche :** on raffine -- du problème vers la solution.
**Branche droite :** on vérifie -- chaque niveau définit ses tests en miroir.
**Flux inverses normaux :** une décision de conception peut invalider une spec.
Remonter explicitement via le protocole d'escalade.

---

## Distinctions fondamentales

**Exigence vs Spécification**
- Exigence : besoin exprime par une partie prenante, dans son vocabulaire.
- Spécification : reformulation précise, non ambiguë, vérifiable, pour l'équipe.
- Plus on descend dans le V, plus on bascule vers la spécification.

**Quoi vs Comment**
- Niveaux 1 et 2 : quoi faire (agnostique à la solution technique).
- Niveaux 3 et 4 : comment le faire (decisions techniques).
- Une spécification de niveau 2 qui dit "comment" contraint inutilement l'implémentation.

---

## Porte de validation entre niveaux

Chaque niveau produit une porte de validation.
Ne pas passer au niveau N+1 si la porte du niveau N est incomplete.
Chaque skill de niveau contient sa porte de validation spécifique.

---

## Protocole d'escalade

Quand une ambiguïté ou un blocage est découvert en cours de travail :

**1. Identifier le niveau d'origine de l'ambiguïté**

| Ambiguïté trouvee pendant | Remonter a |
|---|---|
| Implémentation | Niveau 4 (LLD) |
| Tests unitaires | Niveau 4 (LLD) |
| Tests d'intégration | Niveau 3 (HLD) |
| Tests d'acceptance | Niveau 2 (SRS) |
| Conception detail (niv 4) | Niveau 3 ou 2 |
| Architecture (niv 3) | Niveau 2 ou 1 |

**2. Mettre à jour le document du niveau d'origine.**
Le document est la source de verite. Pas le code, pas un message de discussion.

**3. Reprendre depuis le niveau corrigé.**
Vérifier si les niveaux inférieurs sont impactes.

**4. Tracer la decision dans le registre** (`v-model-gestion`).

---

## Revue critique de premier brouillon

Tout premier brouillon d'un artefact (EBO, SRD, SRS, HLD, LLD, plan de
tests) passe cette revue AVANT toute validation client ou passage au
niveau suivant. Ce n'est pas optionnel : un brouillon non revu n'est pas
montrable.

**Avant de commencer.** Annoncer : « Je démarre la revue critique
de [nom de l'artefact]. »

**Pourquoi maintenant.** Les défauts structurants (solution présupposée,
hors-périmètre, critère non vérifiable) coûtent peu à corriger sur le
brouillon 1, beaucoup sur le brouillon 6.

**Vérification préalable — Propagation ADR→LLD.** Si le projet contient des
ADRs et des LLDs, exécuter cette vérification avant les 5 lentilles.

1. **Détection ADR postérieur à LLD :** pour chaque ADR, comparer sa date avec
   la date de dernière révision des LLDs mentionnés dans son §Conséquences.
   Tout ADR daté après l'un de ces LLDs est un *ADR candidat*.

2. **Liste de propagation :** pour chaque ADR candidat, lire explicitement son
   §Conséquences et lister les LLDs que ce paragraphe contraint de mettre à
   jour, avec la formulation exacte du texte source.

**Sortie obligatoire — une ligne par ADR candidat :**

```
ADR-XXX ([date ADR]) > LLD-[composant] ([date LLD])
  §Conséquences impose : LLD-[composant], LLD-[composant], ...
  Statut : [À METTRE À JOUR / Vérifié à jour]
```

Si aucun ADR candidat trouvé : écrire `Propagation ADR→LLD : RAS`.
Sans cette sortie, la vérification n'a pas eu lieu.

**Les 5 lentilles.** Pour chaque lentille, rédiger une ligne de résultat
explicite — y compris si aucun problème n'est trouvé.

| Lentille | Question |
|---|---|
| Héritage | Le brouillon reprend-il du vocabulaire de solution ou des décisions de l'artefact d'entrée, au lieu de les reformuler en besoin ? |
| Périmètre | Chaque élément tracé vers l'artefact d'entrée ? Tout orphelin est-il qualifié : clarification dans le périmètre, ou demande d'évolution à tracer via v-model-gestion ? |
| Vérifiabilité | Chaque critère mesure-t-il la propriété visée, et non un proxy ? Est-il observable de l'extérieur ? |
| Abstraction | Des éléments similaires en nombre auraient-ils dû être unifiés en une règle générale avant d'être énumérés ? |
| Couverture | Tout l'artefact d'entrée est-il couvert par au moins un élément ? |

**Sortie obligatoire — une ligne par lentille :**

```
**Héritage :** [observation ou AUCUN PROBLÈME]
**Périmètre :** [observation ou AUCUN PROBLÈME]
**Vérifiabilité :** [observation ou AUCUN PROBLÈME]
**Abstraction :** [observation ou AUCUN PROBLÈME]
**Couverture :** [observation ou AUCUN PROBLÈME]
Bloquants corrigés avant de poursuivre : oui / non
```

Sans cette sortie écrite, la revue n'a pas eu lieu.

### Drapeaux rouges — STOP

- « Je ferai l'analyse critique plus tard / sur une version plus stable »
- « Le brouillon est évident, il n'y a rien à critiquer »
- « C'est l'artefact d'entrée qui contient la solution, ce n'est pas mon problème »
- « Cet ajout est utile, donc il est dans le périmètre »

Chacun signifie : revue critique non faite. La faire maintenant.

---

## Structure de fichiers du projet

```
docs/
  amont/         -- EBO, faisabilité, business case, charte
  requirements/  -- srd.md, srs.md, traceability.md
  design/
    hld.md
    adr/         -- Un fichier par ADR (ADR-001-*.md)
    lld/         -- Un fichier par composant
  tests/         -- Procedures, matrice de traçabilité
  management/    -- Risques, decisions, backlog
```

Règle : toute decision existe dans un fichier versionne.

---

## Règles d'or

1. Le document précède le code. Aucun composant n'est implémenté sans LLD valide.
2. L'ambiguïté remonte -- elle n'est pas résolue sur place.
3. La traçabilité se maintient en temps réel, pas reconstituée après coup.
4. La validation humaine est obligatoire à chaque niveau.
5. Un fichier par décision. Ce qui n'est pas écrit n'existe pas.
6. Tout premier brouillon passe la revue critique avant d'être montré ou validé.
