---
name: v-model-niveau-4
version: 1.2.1
description: >
  Skill pour le Niveau 4 du modèle en V : Conception détaillée / Low-Level
  Design. Utiliser après validation du HLD pour spécifier chaque composant
  au niveau où un développeur peut implémenter sans prendre de décision
  d'architecture. Déclencher quand on doit rédiger un LLD, un DDD, spécifier
  une interface, une structure de données, un algorithme, ou un contrat
  d'erreur. Prérequis : v-model-niveau-3 valide. Skill suivant :
  v-model-implementation et v-model-tests (tests unitaires).
---

# Niveau 4 : Conception détaillée (LLD)

## Contexte

**Répond à :** comment chaque composant est-il implémenté en détail ?
**Un développeur doit pouvoir implémenter à partir de ce niveau sans décision de conception.**
**Input :** HLD valide + ADRs.
**Output :** Low-Level Design Document (LLD), un fichier par composant.
**Skill suivant :** `v-model-implementation` + `v-model-tests` (tests unitaires).

---

## Roles

| Role | Responsabilité |
|---|---|
| Architecte / Responsable technique | Rédige le LLD de chaque composant |
| Développeur senior | Valide la faisabilité et la complétude |
| Développeur junior | Lit le LLD -- signale toute ambiguïté avant d'implémenter |

---

## Règle fondamentale

**Spécifier les décisions que le développeur ne doit pas prendre seul.
Pas le code lui-même.**

Un LLD trop vague -> le développeur invente ses propres conventions.
Un LLD trop détaillé -> du pseudo-code inutile que personne ne lit.

**Critère de complétude :** un développeur junior peut implémenter le composant
en posant uniquement des questions de syntaxe, jamais des questions de conception.

---

## Règle : Décision de bibliothèque

Avant de specifier l'implémentation d'un composant non trivial, TOUJOURS vérifier
si une bibliothèque ou un outil existant résout déjà le problème — même si les
exigences ou le plan n'en font pas mention.

**La sélection ou le rejet d'une bibliothèque est une décision de conception :
elle appartient au LLD, pas au développeur.**

**Déclencheurs :** algorithmes, parseurs, validation, sérialisation, réseau/IO,
cryptographie, gestion de dates, utilitaires de test, formatage.

**Template de décision (à inclure dans la section concernée) :**
```
**Bibliothèque candidate :** [nom + version minimale requise]
**Justification du choix :** [pourquoi elle couvre le besoin et est bien maintenue]
— ou —
**Rejet et implémentation custom :** [raison + contrainte projet ou exigence]
**Exigence satisfaite :** [SW-F-XXX ou SW-NF-XXX]
```

Si aucune bibliothèque n'est pertinente : écrire explicitement
`Aucune bibliothèque identifiée — implémentation custom` dans la section algorithme.

---

**Sections obligatoires selon le type de composant :**

| Section | Composant metier | Composant persistance | Composant reseau/IO | Composant UI |
|---|---|---|---|---|
| Interfaces | Obligatoire | Obligatoire | Obligatoire | Obligatoire |
| Structures de données | Obligatoire | Obligatoire | Obligatoire | Si non trivial |
| Algorithmes | Si non trivial | Si non trivial | Si non trivial | Rare |
| Machine d'états | Si états distincts | Si états distincts | Obligatoire | Si états distincts |
| Schéma persistance | Non applicable | Obligatoire | Non applicable | Non applicable |
| Contrats d'erreur | Obligatoire | Obligatoire | Obligatoire | Obligatoire |
| Traçabilité | Obligatoire | Obligatoire | Obligatoire | Obligatoire |

---

## 1. Spécification des interfaces

Pour chaque interface exposee par le composant :

**Template :**
```
[NomInterface]
  [NomMethode]([parametres]) -> [type de retour]
**Précondition :** [ce qui doit être vrai avant l'appel]
**Postcondition :** [ce qui est garanti après l'appel]
**Erreur :** [ExceptionType] si [condition]
**Garantie :** [propriété observable, ex. "résultat transmis en < 500 ms"]
**Idempotent :** [oui / non]
**Traçabilité :** [SW-F-XXX ou SW-S-XXX satisfait par cette méthode]
```

---

## 2. Spécification des structures de données

Pour chaque structure centrale du composant :

**Template :**
```
[NomStructure]
  [nomChamp] : [type]  // [contrainte + justification]
    Exemple :
    operatorId : string  // Traçabilité SW-S-001, non null, non vide
    autonomyRatio : float  // [0.0-1.0], rejete si > 0.9 (SW-F-003)
```

**Couvrir :** les invariants (ce qui doit toujours être vrai sur la structure),
les valeurs interdites, les unités si applicable (mètres, WGS84...).

---

## 3. Spécification des algorithmes

Uniquement les algorithmes non triviaux -- ceux ou le développeur pourrait
prendre une mauvaise decision s'il n'est pas guide.

**Template :**
```
# Algorithme : [nom]

**Objectif :** [ce qu'il fait]
**Décision bibliothèque :** [nom + version retenue] | Aucune — implémentation custom ([raison])
**Approche retenue :** [nom de l'algorithme ou pattern]
**Justification :** [pourquoi cette approche, pas une autre]
**Paramètres clés :** [seuils, constantes -- avec leur justification]
**Cas limites à traiter :** [conditions non triviales]
**Exigences satisfaites :** [SW-F-XXX, SW-NF-XXX]
```

---

## 4. Machines d'états

Pour chaque composant avec des états distincts :

**Template :**
```
# Machine d'états : [NomComposant]

## États

[liste des états possibles]

## Transitions

- [EtatA] --(condition)--> [EtatB]
- [EtatB] --(condition)--> [EtatA]
- ...

## Actions par état

- [EtatA] : [ce que le composant fait dans cet état]

## Seuils justifiés

- [Seuil] = [valeur] car [justification alignée sur une exigence]
```

---

## 5. Spécification de la persistance

Si le composant gère de la persistance :

**Template schéma :**
```
TABLE [nom]
  [colonne] [type] [contrainte]  -- [justification]

## Règles de coherence

- [Toute transition X est atomique et couvre les tables A et B]

## Stratégie d'intégrité

- [Comment les données sont protégées en cas de coupure]
**Exigence :** [SYS-NF-XXX ou SW-NF-XXX]
```

---

## 6. Contrats d'erreur

Les erreurs sont des décisions de conception -- ne pas les laisser au jugement
du développeur. Une erreur non spécifiée sera gérée inconsistamment.

**Template :**

| Situation | Type d'erreur | Niveau de log | Action attendue |
|---|---|---|---|
| [condition] | [ExceptionType] | Debug/Info/Warning/Error/Critical | [ce que le code appelant doit faire] |

**Règle générale :**
- Erreurs opérateur (entrée invalide) : exception récupérable, message utilisateur.
- Erreurs système (BDD, réseau, matériel) : Critical, remontent sans détail technique.

---

## 7. Traçabilité vers le Niveau 2

Chaque élément du LLD doit pointer vers l'exigence qu'il satisfait.

**Template :**

| Élément LLD | Exigence satisfaite |
|---|---|
| [méthode ou comportement] | [SW-F-XXX ou SW-S-XXX] |

Si un élément du LLD ne pointe vers aucune exigence : le supprimer ou
l'ajouter comme exigence manquante via le processus d'évolution (`v-model-gestion`).

---

## Template de completude du LLD

```
**Contexte :** LLD du composant [NomComposant], HLD valide

**Tâche :** Vérifier la complétude du LLD

## Contraintes

- Identifier les décisions que le développeur devra prendre seul
- (zones de LLD incomplètes)
- Vérifier que chaque élément pointe vers une exigence
- Vérifier que les contrats d'erreur couvrent toutes les situations d'échec
- Vérifier que la machine d'états couvre tous les états possibles

## Format

**Decisions non couvertes :** [liste]
**Éléments sans exigence :** [liste]
**Erreurs non specifiees :** [liste]
**États manquants dans la machine d'états :** [liste]
```

---

## Porte de validation -- Niveau 4

Ne pas démarrer l'implémentation si une case est vide.

```
- [ ] Toutes les interfaces exposées par le composant sont spécifiées
    (préconditions, postconditions, erreurs, garanties)
- [ ] Pour chaque composant non trivial : décision de bibliothèque documentée
    (bibliothèque retenue avec justification, ou rejet explicite avec raison)
- [ ] Toutes les structures de données centrales sont spécifiées avec leurs invariants
- [ ] Tous les algorithmes non triviaux ont une spécification (pas juste un nom)
- [ ] Les machines d'états couvrent tous les états et toutes les transitions
- [ ] Les contrats d'erreur couvrent toutes les situations d'échec identifiées
- [ ] Chaque élément du LLD pointe vers une exigence du SRS
- [ ] Un développeur junior a relu le LLD et n'a posé que des questions de syntaxe
```

---

## Minimum viable (petit projet)

Si HLD et LLD sont fusionnes, conserver au minimum :
- Les preconditions et erreurs de chaque methode publique.
- Les invariants des structures de données centrales.
- La machine d'états si le composant a des états distincts.
- Les seuils des algorithmes avec leur justification.

---

## Anti-patterns fréquents

- LLD qui est du pseudo-code : trop détaillé, plus personne ne le lit.
- LLD qui laisse les erreurs au développeur : incohérence garantie.
- Laisser la sélection de bibliothèque au développeur : incohérence de stack,
  risques de sécurité, et dette technique évitable.
- Implémenter custom ce qu'une bibliothèque bien maintenue résout déjà : coût
  de maintenance sans valeur ajoutée. Documenter le rejet si une contrainte l'impose.
- Machines d'états incomplètes : états manquants découverts à l'intégration.
- Éléments LLD sans exigence : fonctionnalité non demandée implémentée.
- LLD rédigé après l'implémentation : il ne sert alors qu'à la documentation,
  pas à guider -- valeur réduite, erreurs reproduites.
- Développeur qui "devine" une zone floue du LLD sans signaler l'ambiguïté :
  instaurer la culture que signaler = bien faire son travail.
- Renommer une interface ou un composant avec sed dans le LLD : le nom peut
  apparaître dans des identifiants LLD-COMP-XX, dans la matrice de traçabilité,
  et dans les références croisées vers le HLD. Chaque contexte a un comportement
  attendu différent. Lire le LLD, chercher toutes les occurrences, éditer manuellement
  selon le contexte de chaque apparition.
