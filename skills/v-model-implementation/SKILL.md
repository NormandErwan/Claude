---
name: v-model-implementation
version: 1.0.0
description: >
  Skill pour la phase d'implémentation du modèle en V. Utiliser quand un
  développeur commence a coder un composant, quand on genere du code depuis
  une spécification, ou quand on veut structurer le travail d'implémentation
  depuis un LLD. Prerequis strict : LLD du composant valide et porte de
  validation du Niveau 4 completee. Skill connexe : v-model-tests pour les
  tests unitaires a produire en parallele.
---

# Implémentation

## Contexte

**L'implémentation traduit le LLD en code.**
**Un développeur ne devrait pas prendre de decision de conception ici.**
**Input :** LLD valide + interfaces generees depuis le HLD.
**Output :** code source + tests unitaires.
**Skill connexe :** `v-model-tests` (tests unitaires a ecrire en même temps).

---

## Roles

| Role | Responsabilité |
|---|---|
| Développeur (junior ou senior) | Implemente le composant depuis le LLD |
| Responsable technique | Produit le LLD, disponible pour les questions de conception |
| Reviewer | Revue de code après implémentation (`v-model-équipe`) |

---

## Principe fondamental

Si un développeur prend une decision de conception pendant l'implémentation,
c'est le signal que le LLD etait insuffisant -- pas que le développeur a mal travaille.

**Protocole en cas d'ambiguïté :**
1. Stopper l'implémentation du point ambigu.
2. Signaler l'ambiguïté au responsable technique **par ecrit** (ticket, note, commentaire de PR).
   Ne pas signaler uniquement a l'oral -- une ambiguïté signalee verbalement
   et non tracée devient invisible et se repete.
3. Attendre la mise à jour du LLD.
4. Implementer depuis le LLD mis à jour.

Format de signalement ecrit minimal :
```
# Ambiguïté LLD — [composant] — [date]

**Section concernée :** [référence section LLD]
**Situation non couverte :** [description précise]
**Options possibles :** [a] ... [b] ...
**Bloque :** implémentation de [methode] jusqu'a clarification
```

Ne jamais "deviner" une zone floue sans la signaler. Voir `v-model-guide`
(protocole d'escalade) pour la procedure complete.

---

## Sequence d'implémentation par composant

**1. Preparer le contexte**

Avant de commencer, rassembler :
- Le LLD du composant a implementer.
- Les interfaces des composants dont il depend (déjà implementes).
- Les ADRs pertinents du HLD.
- Les contraintes transversales (HLD-T-XXX).

**2. Générer la structure (pas l'implémentation)**

Commencer par le squelette : classes, interfaces, enums, methodes vides
avec leurs preconditions en commentaire.
Faire valider la structure avant d'implementer le comportement.

**3. Implementer les validations de preconditions en premier**

Les erreurs d'entree doivent être detectees avant toute logique metier.
Référence : contrats d'erreur du LLD.

**4. Implementer la logique metier**

Suivre les algorithmes du LLD. Si un algorithme est ambigu : escalade.

**5. Implementer le logging**

Aux niveaux specifies dans les contrats d'erreur du LLD.

**6. Ecrire les tests unitaires**

Un test positif et un test négatif pour chaque règle metier du LLD.
Référence : `v-model-tests` (section tests unitaires).

---

## Template de contexte pour l'implémentation

```
**Contexte :**

**LLD du composant :** [contenu ou référence au fichier]
**Interfaces disponibles :** [interfaces des dependances]
**Contraintes transversales :** [HLD-T-XXX applicables]

## Tache

- Implementer [NomComposant] en respectant strictement le LLD.

## Contraintes

- Respecter les preconditions et postconditions de chaque methode
- Appliquer les contrats d'erreur (type d'exception, niveau de log)
- Respecter les niveaux de log specifies
- Ne pas prendre de decision de conception non couverte par le LLD
- Si une zone est ambigue : la signaler, ne pas deviner

## Format de sortie

- Squelette de classe avec signatures et commentaires de contrat
- TODO commentes pour chaque comportement non trivial
- (reference a la section LLD : "voir LLD section 3.2")
```

---

## Checklist avant de soumettre le code en revue

```
- [ ] Le code respecte toutes les preconditions specifiees dans le LLD
- [ ] Les contrats d'erreur sont implementes (bonne exception, bon niveau de log)
- [ ] Aucune decision de conception n'a été prise sans mise à jour du LLD
- [ ] Les tests unitaires couvrent chaque règle metier du LLD
    (au moins un test positif et un négatif par règle)
- [ ] La machine d'états est implementee conformement au LLD
- [ ] Le schéma de persistance correspond au LLD (si applicable)
- [ ] Les contraintes transversales HLD sont respectees (injection, logging, concurrence)
- [ ] La matrice de traçabilité est mise à jour
```

---

## Vérifier la coherence entre composants

Après implémentation de plusieurs composants, vérifier les incoherences :

```
**Contexte :** [ComposantA] et [ComposantB] implémentés

**Section HLD :** [contenu] et [ComposantB] implementes
**Section HLD decrivant leur interaction :** [contenu]

## Tâche

- Identifier les incoherences entre les deux implémentations.

## Contraintes

- Verifier que les hypothèses que A fait sur B sont garanties par l'interface de B
- Verifier que les formats d'echange sont coherents
- Verifier que la gestion des erreurs est compatible

## Format

**Incoherences :** [liste]
**Hypothèses non garanties :** [liste]
**Action recommandee :** [mise à jour LLD / correction implémentation]
```

---

## Signal d'alarme : dette technique

Quand une implémentation s'ecarte du LLD pour une raison valable
(contrainte technique non anticipee, limite de la plateforme...) :

1. Ne pas coder le contournement silencieusement.
2. Documenter l'écart dans le LLD (section "Écarts d'implémentation").
3. Creer un ticket de dette technique dans le backlog avec impact concret.
4. Informer le responsable technique.

**Formulation de ticket de dette acceptable :**
```
[Composant] : [description concrete de l'écart]
**Impact :** [ce que ça empêche ou complique -- pas "c'est sale"]
**Effort estimé :** [X jours]
**Risque si non traité :** [conséquence sur une exigence]
```

---

## Anti-patterns frequents

- Implementer sans avoir lu le LLD en entier.
- "Ameliorer" le LLD silencieusement pendant l'implémentation.
- Ignorer les preconditions ("ca n'arrivera pas en pratique").
- Coder la gestion d'erreur après coup plutot qu'en premier.
- Laisser des TODO sans référence au LLD (impossible a suivre en revue).
- Soumettre en revue sans tests unitaires ("je les ferai après").
