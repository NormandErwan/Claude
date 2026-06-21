---
name: v-model-equipe
version: 1.3.0
description: >
  Skill pour les pratiques d'équipe dans le modèle V : Définition of Ready,
  Définition of Done, backlog, estimation, revue de code, intégration des
  développeurs juniors, dette technique, et organisation Agile. Utiliser
  quand on organise le travail d'équipe, quand on fait une revue de code,
  quand on crée des tâches pour des juniors, ou quand on structure un sprint.
  Complément de tous les skills V-model pour la dimension collective du travail.
---

# Pratique d'équipe

## Contexte

Ce skill répond à : **comment l'équipe travaille au quotidien pour produire
ce que les specs décrivent ?**

Il s'applique en parallèle de tous les autres skills du V.
La méthode sans pratique d'équipe reste théorique.

---

## Roles dans l'équipe

| Role | Responsabilité quotidienne |
|---|---|
| Responsable produit (PO) | Priorise le backlog, valide les critères d'acceptance |
| Responsable technique | Produit HLD et LLD, disponible pour les questions de conception |
| Développeur | Implemente depuis le LLD, signale les ambiguïtés |
| Reviewer | Revue de code (peut être le responsable technique ou un pair) |

---

## 1. Définition of Ready (DoR)

Ce qu'une tâche doit satisfaire avant qu'un développeur puisse la commencer.
**Une tâche non Ready ne doit pas entrer dans un sprint.**

```
# Définition of ready — [nom du projet]

- [ ] L'exigence source est identifiée et tracée (SW-F-XXX)
- [ ] Les critères d'acceptance sont écrits et non ambigus
- [ ] La section LLD pertinente est complète et validée
- [ ] Les dépendances externes sont levées (API disponible, interface spécifiée)
- [ ] La tâche est estimée par l'équipe
- [ ] La Définition of Done est connue de tous
```

---

## 2. Définition of Done (DoD)

Ce qu'une tâche doit satisfaire pour être considérée terminée.
**Affichée et rappelée — pas mémorisée.**

```
# Définition of done — [nom du projet]

- [ ] Le code est écrit et compilé sans avertissement
- [ ] Les tests unitaires passent (au moins positif + négatif par règle LLD)
- [ ] La revue de code est faite et les [bloquant] sont levés
- [ ] Les artefacts du V concernés sont à jour (LLD a minima si implémentation)
- [ ] La tâche est tracée vers son exigence dans la matrice de traçabilité
- [ ] Le LLD est mis à jour si une ambiguïté a été résolue pendant l'implémentation
```

---

## 3. Structurer le travail : du besoin à la tâche

```
Exigence (SW-F-XXX du SRS)
    |
    v
**Feature :** ensemble cohérent dérivé d'une ou plusieurs exigences
    |
    v
**User Story :** unité de valeur du point de vue utilisateur
    En tant que [role], je veux [action] afin de [bénéfice].
    |
    v
Tâche (Task) : unité réalisable en < 1 jour par un développeur
```

**Critères d'acceptance d'une User Story :**
Conditions observables qui permettent de dire que la Story est satisfaite.
Elles font le lien avec les procédures de test d'acceptance.

---

## 4. Backlog et refinement

**Deux erreurs fréquentes :**
- Backlog comme poubelle : tout entre, rien ne sort, priorités opaques.
- Backlog figé : s'il ne change pas, on ne l'utilise pas pour piloter.

**Session de refinement (1h par semaine) :**
```
Objectifs :
- [ ] Vérifier que les stories du prochain sprint sont Ready
- [ ] Découper les stories trop grosses (> 2 jours)
- [ ] Estimer les items non estimés
- [ ] Réordonner selon les priorités actuelles
- [ ] Supprimer ce qui n'a plus de valeur
**Participants :** responsable produit + responsable technique + développeurs
```

---

## 5. Estimation

**L'objectif de l'estimation n'est pas la précision -- c'est la détection des incompréhensions.**

Quand deux développeurs estiment très différemment une même tâche,
c'est presque toujours parce qu'ils ne comprennent pas la même chose.
La discussion qui s'ensuit a plus de valeur que le chiffre final.

**Planning Poker :**
- Chaque développeur estime en silence.
- Révélation simultanée.
- Les écarts importants déclenchent une discussion.
- On ne moyenne pas -- on comprend l'écart.

**Sur une petite équipe de juniors :**
Commencer par des estimations en jours (plus intuitif que les Story Points).
Passer aux points quand l'équipe a acquis le réflexe d'estimer ensemble.

---

## 6. Revue de code

**Deux objectifs simultanés : améliorer le code ET développer le développeur.**
Ces deux objectifs ne sont pas toujours servis par les mêmes commentaires.

### Structure de revue

**Passe 1 -- Correctness et sécurité (prioritaire)**
- Écarts par rapport au LLD.
- Violations des contrats d'erreur spécifiés.
- Problèmes de sécurité au regard des SW-S-XXX.
- Conditions de concurrence (contraintes transversales HLD).

**Passe 2 -- Architecture et lisibilité**
- Violations des règles transversales du HLD.
- Couplages non justifiés.
- Lisibilité et nommage.

### Catégories de commentaires

```
[bloquant]    Doit être corrigé avant merge. Violation du LLD ou de la sécurité.
[suggestion]  Amélioration recommandée. Non bloquante.
[question]    Clarification demandée. Peut révéler un problème ou une incompréhension.
[nit]         Detail mineur de style. A traiter en dernier, jamais bloquant.
```

### Template de revue de code

```
**Contexte :**

**LLD du composant :** [section pertinente]
**Exigences satisfaites :** [SW-F-XXX, SW-S-XXX]
**Diff :** [code à réviser]

## Tâche

- Effectuer une revue en deux passes (correctness puis architecture).

## Contraintes

- Catégoriser chaque commentaire [bloquant] / [suggestion] / [question] / [nit]
- Pour [bloquant] et [suggestion] : expliquer pourquoi (référence au LLD si possible)
- Ne pas réécrire à la place du développeur : poser une question
- Cohérence : mêmes règles sur toutes les PRs.

## Format

- Passe 1 (correctness) : [liste commentaires avec catégorie]
- Passe 2 (architecture) : [liste commentaires avec catégorie]
**Verdict :** [Approuve / Approuve avec modifications mineures / Modifications requises]
```

**Délai maximum : 24 h après ouverture de la PR.**
Une PR qui attend détruit le rythme de l'équipe.

**Si le LLD est silencieux sur un point soulevé en revue :**
Le commentaire devient automatiquement `[question]`, jamais `[bloquant]`.
Formuler ainsi : "Le LLD ne couvre pas ce cas. Est-ce intentionnel ?
Si non, ce point doit être ajouté au LLD avant implémentation."
Ce commentaire peut déclencher une mise à jour du LLD via le protocole
d'escalade (`v-model-guide`). Ne pas bloquer la PR pour un silence du LLD
-- bloquer uniquement pour une violation du LLD.

### Complément pédagogique : session de pair review

Une fois par sprint, revue en pair (reviewer + auteur ensemble) pour :
- Expliquer les décisions de conception (pas seulement les corrections).
- Illustrer un concept général depuis ce code spécifique.
- Identifier un exercice que le développeur peut faire seul après.

---

## 7. Intégration des développeurs juniors

**Leur donner de la surface, pas du fond.**
Un composant entier (même petit) avec une interface définie apprend plus
qu'une succession de corrections de style.

**Le LLD est leur point d'entrée.**
Si le LLD est insuffisant, ils prendront des décisions sans le contexte pour les prendre.
La complétude du LLD est une préalable pour déléguer l'implémentation.

### Template de creation de tâches pour juniors

```
**Contexte :**

**LLD du composant :** [contenu]
**Déjà implemente :** [liste des fichiers existants]

## Tâche

- Générer les tâches d'implémentation pour un développeur junior.

## Contraintes

- Une tâche par unite de travail realisable en < 1 jour
- Pour chaque tâche :
* Résultat attendu (observable)
* Référence a la section LLD
* Interfaces disponibles a utiliser
* Définition of Done spécifique
* Questions a se poser avant de commencer

## Format

- Une fiche de tâche complete par item
```

### Template de preparation de session de pair review pedagogique

```
**Contexte :**

**PR du développeur :** [diff]
**Commentaires de revue :** [liste]

## Tâche

- Préparer une session de pair review de 30 minutes.

## Contraintes

- 2 ou 3 points clés maximum (pas tous les [nit])
- Pour chaque point : la question à poser pour engager la réflexion
- Un concept général a illustrer depuis ce code
- Un exercice court que le développeur peut faire seul après

## Format

**Points a couvrir :** [liste ordonnee par priorité]
**Questions :** [une par point]
**Exercice de suivi :** [description]
```

---

## 8. Gestion de la dette technique

**La rendre visible -- pas l'ignorer.**

**Format de ticket de dette acceptable :**
```
# Dette technique — [composant]

**Description :** [description concrète de l'écart]
**Impact :** [ce que ça empêche ou complique, référence à une exigence si possible]
**Effort estimé :** [X jours]
**Risque si non traité :** [consequence mesurable]
```

**La prioriser explicitement :**
Elle est en concurrence avec les features dans le backlog.
"On la traitera quand on a le temps" = elle ne sera jamais traitée.

**Instaurer la culture du signalement :**
Un junior qui contourne un problème sans le signaler produit de la dette invisible.
Signaler = bien faire son travail. Ne pas signaler = dette cachée.

---

## 9. Organisation hebdomadaire type (Scrum)

```
# Calendrier type de sprint

## Lundi

- Standup (15 min)
- Sprint planning si début de sprint (2-4h)
- Refinement backlog (1h) si milieu de sprint

## Mardi – jeudi

- Standup (15 min)
- Développement
- Revues de code au fil de l'eau (< 24 h après ouverture de PR)

## Vendredi

- Standup (15 min)
- Sprint review — démo de ce qui est terminé (30 min)
- Sprint rétrospective (30-60 min)
```

**Standup (15 min) -- format strict :**
- Ce que j'ai fait hier.
- Ce que je fais aujourd'hui.
- Ce qui me bloque.

Objectif : synchronisation horizontale entre développeurs, pas rapport au chef.
Les bloquants remontent immédiatement -- pas au standup du lendemain.

**Rétrospective -- une seule action concrète par sprint :**
```
Ce qu'on garde | Ce qu'on améliore | Ce qu'on arrête
     [item]    |      [item]        |     [item]
```
Une liste de 12 résolutions non tenues n'est pas une rétrospective.

---

## Anti-patterns fréquents

- DoR et DoD existent sur papier mais ne sont pas vérifiées en pratique.
- Standup = rapport au chef (le responsable technique parle en dernier, pas en premier).
- Revue de code = police du style (les [nit] prennent plus de place que les [bloquant]).
- Juniors uniquement affectés à des tâches de style -- progression lente.
- Dette technique non tracée : "on le sait mais on n'a pas le temps".
- Rétrospective annulée quand le sprint s'est bien passé -- c'est quand qu'on analyse ?
