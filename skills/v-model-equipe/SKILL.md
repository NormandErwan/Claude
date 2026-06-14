---
name: v-model-equipe
version: 1.2.0
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

Ce skill répond a : **comment l'équipe travaille au quotidien pour produire
ce que les specs decrivent ?**

Il s'applique en parallele de tous les autres skills du V.
La methode sans pratique d'équipe reste theorique.

---

## Roles dans l'équipe

| Role | Responsabilité quotidienne |
|---|---|
| Responsable produit (PO) | Priorise le backlog, valide les critères d'acceptance |
| Responsable technique | Produit HLD et LLD, disponible pour les questions de conception |
| Développeur | Implemente depuis le LLD, signale les ambiguites |
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

## 3. Structurer le travail : du besoin a la tâche

```
Exigence (SW-F-XXX du SRS)
    |
    v
**Feature :** ensemble coherent derive d'une ou plusieurs exigences
    |
    v
**User Story :** unite de valeur du point de vue utilisateur
    En tant que [role], je veux [action] afin de [benefice].
    |
    v
Tâche (Task) : unite realisable en < 1 jour par un développeur
```

**Critères d'acceptance d'une User Story :**
Conditions observables qui permettent de dire que la Story est satisfaite.
Elles font le lien avec les procedures de test d'acceptance.

---

## 4. Backlog et refinement

**Deux erreurs frequentes :**
- Backlog comme poubelle : tout entre, rien ne sort, priorites opaques.
- Backlog fige : s'il ne change pas, on ne l'utilise pas pour piloter.

**Session de refinement (1h par semaine) :**
```
Objectifs :
- [ ] Verifier que les stories du prochain sprint sont Ready
- [ ] Decouper les stories trop grosses (> 2 jours)
- [ ] Estimer les items non estimes
- [ ] Reordonner selon les priorites actuelles
- [ ] Supprimer ce qui n'a plus de valeur
**Participants :** responsable produit + responsable technique + développeurs
```

---

## 5. Estimation

**L'objectif de l'estimation n'est pas la precision -- c'est la détection des incomprehensions.**

Quand deux développeurs estiment très differemment une même tâche,
c'est presque toujours parce qu'ils ne comprennent pas la même chose.
La discussion qui s'ensuit a plus de valeur que le chiffre final.

**Planning Poker :**
- Chaque développeur estime en silence.
- Revelation simultanee.
- Les écarts importants declenchent une discussion.
- On ne moyenne pas -- on comprend l'écart.

**Sur une petite équipe de juniors :**
Commencer par des estimations en jours (plus intuitif que les Story Points).
Passer aux points quand l'équipe a acquis le reflexe d'estimer ensemble.

---

## 6. Revue de code

**Deux objectifs simultanes : ameliorer le code ET developper le développeur.**
Ces deux objectifs ne sont pas toujours servis par les memes commentaires.

### Structure de revue

**Passe 1 -- Correctness et sécurité (prioritaire)**
- Écarts par rapport au LLD.
- Violations des contrats d'erreur specifies.
- Problèmes de sécurité au regard des SW-S-XXX.
- Conditions de concurrence (contraintes transversales HLD).

**Passe 2 -- Architecture et lisibilite**
- Violations des règles transversales du HLD.
- Couplages non justifies.
- Lisibilite et nommage.

### Categories de commentaires

```
[bloquant]    Doit être corrigé avant merge. Violation du LLD ou de la sécurité.
[suggestion]  Amelioration recommandee. Non bloquante.
[question]    Clarification demandee. Peut reveler un problème ou une incomprehension.
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

- Categoriser chaque commentaire [bloquant] / [suggestion] / [question] / [nit]
- Pour [bloquant] et [suggestion] : expliquer pourquoi (référence au LLD si possible)
- Ne pas reecrire a la place du développeur : poser une question
- Cohérence : memes règles sur toutes les PRs

## Format

- Passe 1 (correctness) : [liste commentaires avec categorie]
- Passe 2 (architecture) : [liste commentaires avec categorie]
**Verdict :** [Approuve / Approuve avec modifications mineures / Modifications requises]
```

**Delai maximum : 24h après ouverture de la PR.**
Une PR qui attend detruit le rythme de l'équipe.

**Si le LLD est silencieux sur un point souleve en revue :**
Le commentaire devient automatiquement `[question]`, jamais `[bloquant]`.
Formuler ainsi : "Le LLD ne couvre pas ce cas. Est-ce intentionnel ?
Si non, ce point doit être ajoute au LLD avant implémentation."
Ce commentaire peut déclencher une mise à jour du LLD via le protocole
d'escalade (`v-model-guide`). Ne pas bloquer la PR pour un silence du LLD
-- bloquer uniquement pour une violation du LLD.

### Complément pedagogique : session de pair review

Une fois par sprint, revue en pair (reviewer + auteur ensemble) pour :
- Expliquer les decisions de conception (pas seulement les corrections).
- Illustrer un concept général depuis ce code spécifique.
- Identifier un exercice que le développeur peut faire seul après.

---

## 7. Intégration des développeurs juniors

**Leur donner de la surface, pas du fond.**
Un composant entier (même petit) avec une interface définie apprend plus
qu'une succession de corrections de style.

**Le LLD est leur point d'entree.**
Si le LLD est insuffisant, ils prendront des decisions sans le contexte pour les prendre.
La completude du LLD est une prerequis pour deleguer l'implémentation.

### Template de creation de tâches pour juniors

```
**Contexte :**

**LLD du composant :** [contenu]
**Déjà implemente :** [liste des fichiers existants]

## Tâche

- Generer les tâches d'implémentation pour un développeur junior.

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

- Preparer une session de pair review de 30 minutes.

## Contraintes

- 2 ou 3 points cles maximum (pas tous les [nit])
- Pour chaque point : la question a poser pour engager la reflexion
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
**Impact :** [ce que ca empeche ou complique, référence a une exigence si possible]
**Effort estimé :** [X jours]
**Risque si non traité :** [consequence mesurable]
```

**La prioriser explicitement :**
Elle est en concurrence avec les features dans le backlog.
"On la traitera quand on a le temps" = elle ne sera jamais traitee.

**Instaurer la culture du signalement :**
Un junior qui contourne un problème sans le signaler produit de la dette invisible.
Signaler = bien faire son travail. Ne pas signaler = dette cachee.

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
- Developpement
- Revues de code au fil de l'eau (< 24h après ouverture de PR)

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
Les bloquants remontent immediatement -- pas au standup du lendemain.

**Retrospective -- une seule action concrete par sprint :**
```
Ce qu'on garde | Ce qu'on ameliore | Ce qu'on arrete
     [item]    |      [item]        |     [item]
```
Une liste de 12 resolutions non tenues n'est pas une retrospective.

---

## Anti-patterns frequents

- DoR et DoD existent sur papier mais ne sont pas verifiees en pratique.
- Standup = rapport au chef (le responsable technique parle en dernier, pas en premier).
- Revue de code = police du style (les [nit] prennent plus de place que les [bloquant]).
- Juniors uniquement affectés a des tâches de style -- progression lente.
- Dette technique non trackee : "on le sait mais on n'a pas le temps".
- Retrospective annulee quand le sprint s'est bien passe -- c'est quand qu'on analyse ?
