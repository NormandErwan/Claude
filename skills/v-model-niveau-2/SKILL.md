---
name: v-model-niveau-2
version: 1.2.0
description: >
  Skill pour le Niveau 2 du modèle en V : Exigences logiciel (Software
  Requirements Spécification). Utiliser après validation du SRD pour allouer
  les exigences système au logiciel et les raffiner en spécifications
  vérifiables. Déclencher quand on redige un SRS, une STB, ou qu'on definit
  ce que le logiciel doit faire. Prerequis : v-model-niveau-1 valide.
  Skill suivant : v-model-niveau-3.
---

# Niveau 2 : Exigences logiciel (SRS)

## Contexte

**Répond a :** qu'est-ce que le logiciel prend en charge parmi toutes les exigences système ?
**Premier niveau ou l'équipe de developpement est l'audience principale.**
**Input :** SRD valide.
**Output :** Software Requirements Spécification (SRS).
**Skill suivant :** `v-model-niveau-3`.

---

## Roles

| Role | Responsabilité |
|---|---|
| Analyste / Responsable produit | Redige le SRS |
| Responsable technique | Valide la faisabilité technique de chaque exigence |
| Representant client | Valide les critères d'acceptance |
| Expert sécurité (si applicable) | Valide les exigences de surete et sécurité |

---

## 1. Allocation des exigences système

Première decision : pour chaque exigence système, ce qui la satisfait.

**Template d'allocation :**

| Exigence système | Logiciel | Materiel | Procedure | Partage |
|---|---|---|---|---|
| SYS-F-XXX : [intitule] | X | | | |
| SYS-F-YYY : [intitule] | | | | X (logiciel + operateur) |

**Règle :** chaque exigence logiciel doit pointer vers au moins une exigence système.
Une exigence logiciel sans parent système est du hors-périmètre.

---

## 2. Exigences fonctionnelles logiciel

Les exigences système allouees au logiciel, reformulees avec suffisamment
de precision pour être implementables et testables.

**Questions a se poser :**
- Quel comportement observable le logiciel produit-il ?
- Dans quelle sequence, dans quel état ?
- Quelles règles metier s'appliquent ?

**Template par exigence :**
```
### SW-F-XXX : le logiciel doit [comportement précis].

**Origine :** SYS-F-YYY
**Critère d'acceptance :** [condition observable qui prouve que l'exigence est satisfaite]
```

---

## 3. Exigences non-fonctionnelles logiciel

Les NFRs système vagues deviennent des mesures précises avec condition de mesure.

**Règle absolue : une NFR sans seuil numérique et sans condition de mesure
est inutile. Elle sera source de litige en recette.**

**Si la NFR ne peut pas être reformulee sans input client :**
Ne pas inventer un seuil. Creer une question explicite et bloquer l'avancement :
```
# Question client — [date]

**NFR concernee :** SYS-NF-XXX ("[intitule vague]")
**Question :** Quel est le seuil acceptable pour [metrique] ?
- Dans quelles conditions (charge, environnement) ?
**Bloque :** passage au Niveau 3 sur les composants dependants de cette NFR.
```
Envoyer au client et attendre une reponse avant de continuer.

**Template :**
```
### SW-NF-XXX ([catégorie]) : [Métrique] doit être [seuil] dans les conditions suivantes :
- Charge : [nombre d'utilisateurs, volume de données]
- Environnement : [materiel cible, configuration]
- Duree : [periode de mesure si applicable]
**Origine :** SYS-NF-YYY
**Methode de verification :** [test / analyse / inspection / demonstration]
```

---

## 4. Exigences d'interface logicielle

Pas encore la spécification d'API -- c'est le Niveau 4. Ici : le "quoi", pas le "comment".

**Template :**
```
# # SW-I-XXX


- [description de l'interface].
- Format / protocole : [si impose par une contrainte externe]
**Origine :** SYS-I-YYY
```

---

## 5. Exigences de surete et sécurité

En contexte defense ou critique, ce bloc peut être plus volumineux que les fonctionnels.

**Points a couvrir :**
- Classification des données traitees.
- Traçabilité des actions operateur (qui a fait quoi, quand).
- Comportements en mode degrade et fail-safe.
- Niveaux d'integrite requis (si norme applicable).

**Template :**
```
# # SW-S-XXX


**Origine :** SYS-NF-YYY ou SYS-C-YYY
**Methode de verification :** [inspection / test / analyse]
```

---

## 6. Exigences de verification

La branche droite du V commence ici -- chaque exigence definit comment elle sera verifiee.

**Methodes de verification :**
- **Test :** execution sur le système, mesure du résultat.
- **Analyse :** raisonnement mathematique ou logique (quand le test est impossible).
- **Inspection :** revue du code ou de la configuration.
- **Demonstration :** observation en conditions reelles.

**Template :**
```
# # SW-V-XXX


**Preconditions :** [état du système avant le test]
**Critère de succes :** [mesure précise]
**Critère d'échec :** [ce qui constitue un échec]
```

---

## Template de validation d'une NFR

```
**Contexte :** SRS en cours, NFR candidate

**Tâche :** Valider que SW-NF-XXX est mesurable

## Contraintes

- Le seuil est numérique ou catégoriel non ambigu
- La condition de mesure est specifiee (charge, environnement)
- La methode de verification est identifiée
- Un technicien peut concevoir le test sans poser de question
**Format :** Valide / Invalide + reformulation si invalide
```

---

## Template de revue complete du SRS

```
**Contexte :** SRS complet, SRD valide

**Tâche :** Auditer le SRS

## Contraintes

- Verifier que chaque exigence logiciel a un parent système
- Verifier que chaque NFR a un seuil et une condition de mesure
- Verifier que chaque exigence a une methode de verification
- Identifier les exigences système non allouees (oublis potentiels)

## Format

- Exigences sans parent système
- NFRs sans seuil mesurable
- Exigences sans methode de verification
- Exigences système non couvertes
```

---

## Matrice de traçabilité initiale

A maintenir des ce niveau dans `docs/requirements/traceability.md`.

| Exigence logiciel | Origine système | Methode de verification | Statut |
|---|---|---|---|
| SW-F-001 | SYS-F-001 | Test | A implementer |
| SW-NF-001 | SYS-NF-001 | Test | A implementer |

---

## Porte de validation -- Niveau 2

Ne pas démarrer le Niveau 3 si une case est vide.

```
- [ ] Chaque exigence logiciel pointe vers au moins une exigence système
- [ ] Toutes les exigences système allouees au logiciel sont couvertes
- [ ] Toutes les NFRs ont un seuil numérique et une condition de mesure
- [ ] Toutes les exigences ont une methode de verification identifiée
- [ ] Les exigences de sécurité couvrent traçabilité, mode degrade, classification des données
- [ ] La matrice de traçabilité est initialisee
- [ ] Le responsable technique a valide la faisabilité technique de chaque exigence
```

---

## Minimum viable (petit projet)

Si les niveaux 1 et 2 sont fusionnes, conserver :
- Les identifiants distincts (SYS-F-XXX et SW-F-XXX).
- L'allocation (même implicite, la noter).
- Les seuils numériques sur toutes les NFRs.
- La methode de verification sur chaque exigence.

---

## Anti-patterns frequents

- NFRs copiees du SRD sans quantification ("le système doit être rapide").
- Exigences fonctionnelles qui decrivent une implémentation ("le logiciel utilise une queue").
- Absence de methode de verification -- l'exigence ne sera pas testee.
- Exigences de sécurité reportees "a plus tard".
- Matrice de traçabilité non initialisee -- elle sera impossible a reconstituer ensuite.
- Renommer un composant avec sed plutôt qu'à la main : le nom apparaît à la fois
  en texte libre (où la mise à jour est souhaitable) et dans des identifiants
  stables comme REQ-AUTH-001 ou ADR-AuthModule-01 (où elle ne l'est pas).
  Toujours lire le document, identifier tous les contextes d'apparition, et éditer
  chaque occurrence selon son contexte. Le brise-traçabilité silencieux est un
  anti-pattern critique dans la méthode V.
