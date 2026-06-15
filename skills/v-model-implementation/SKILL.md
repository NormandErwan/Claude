---
name: v-model-implementation
version: 1.2.1
description: >
  Skill pour la phase d'implémentation du modèle en V. Utiliser quand un
  développeur commence à coder un composant, quand on génère du code depuis
  une spécification, ou quand on veut structurer le travail d'implémentation
  depuis un LLD. Prérequis strict : LLD du composant valide et porte de
  validation du Niveau 4 complétée. Skill connexe : v-model-tests pour les
  tests unitaires à produire en parallèle.
---

# Implémentation

## Contexte

**L'implémentation traduit le LLD en code.**
**Un développeur ne devrait pas prendre de décision de conception ici.**
**Input :** LLD valide + interfaces générées depuis le HLD.
**Output :** code source + tests unitaires.
**Skill connexe :** `v-model-tests` (tests unitaires à écrire en même temps).

---

## Roles

| Role | Responsabilité |
|---|---|
| Développeur (junior ou senior) | Implemente le composant depuis le LLD |
| Responsable technique | Produit le LLD, disponible pour les questions de conception |
| Reviewer | Revue de code après implémentation (`v-model-équipe`) |

---

## Principe fondamental

Si un développeur prend une décision de conception pendant l'implémentation,
c'est le signal que le LLD était insuffisant -- pas que le développeur a mal travaillé.

**Protocole en cas d'ambiguïté :**
1. Stopper l'implémentation du point ambigu.
2. Signaler l'ambiguïté au responsable technique **par écrit** (ticket, note, commentaire de PR).
   Ne pas signaler uniquement à l'oral -- une ambiguïté signalée verbalement
   et non tracée devient invisible et se répète.
3. Attendre la mise à jour du LLD.
4. Implémenter depuis le LLD mis à jour.

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

## Si le défaut remet en cause un niveau supérieur

L'ambiguïté et la dette technique restent locales au LLD. Un troisième cas
existe : l'implémentation révèle qu'une décision d'un niveau supérieur est
*erronée* (HLD, SRS ou SRD), pas seulement floue ou impraticable.

Ne pas corriger uniquement le LLD ni le code. Déclencher un Change Request
interne :

1. Stopper l'implémentation du point concerné.
2. Ouvrir une Change Request (voir `v-model-gestion` §5), `Demandeur = équipe technique`.
3. Impact Assessment : remonter niveau par niveau (LLD → HLD → SRS → SRD) pour
   identifier la décision la plus haute invalidée.
4. Corriger d'abord le niveau le plus haut impacté, puis re-dériver vers le bas.
5. Mettre à jour la baseline et le registre des décisions.

**Règle :** on corrige du haut vers le bas. Patcher seulement le code laisse
les documents mentir.

| Nature du souci | Traitement |
|---|---|
| LLD flou, décision juste pas détaillée | Mise à jour LLD (protocole d'ambiguïté ci-dessus) |
| Écart pragmatique sans remise en cause amont | Dette technique (section « Signal d'alarme » ci-dessous) |
| Décision HLD/SRS/SRD invalidée | CR interne + Impact Assessment (`v-model-gestion` §5) |

---

## Sequence d'implémentation par composant

**1. Préparer le contexte**

Avant de commencer, rassembler :
- Le LLD du composant a implementer.
- Les interfaces des composants dont il depend (déjà implementes).
- Les ADRs pertinents du HLD.
- Les contraintes transversales (HLD-T-XXX).

**2. Générer la structure (pas l'implémentation)**

Commencer par le squelette : classes, interfaces, enums, méthodes vides
avec leurs préconditions en commentaire.
Faire valider la structure avant d'implémenter le comportement.

**3. Implémenter les validations de préconditions en premier**

Les erreurs d'entrée doivent être détectées avant toute logique métier.
Référence : contrats d'erreur du LLD.

**4. Implémenter la logique métier**

Suivre les algorithmes du LLD. Si un algorithme est ambigu : escalade.

**5. Implémenter le logging**

Aux niveaux specifies dans les contrats d'erreur du LLD.

**6. Écrire les tests unitaires**

Un test positif et un test négatif pour chaque règle metier du LLD.
Référence : `v-model-tests` (section tests unitaires).

---

## Template de contexte pour l'implémentation

```
**Contexte :**

**LLD du composant :** [contenu ou référence au fichier]
**Interfaces disponibles :** [interfaces des dependances]
**Contraintes transversales :** [HLD-T-XXX applicables]

## Tâche

- Implémenter [NomComposant] en respectant strictement le LLD.

## Contraintes

- Respecter les préconditions et postconditions de chaque méthode
- Appliquer les contrats d'erreur (type d'exception, niveau de log)
- Respecter les niveaux de log spécifiés
- Ne pas prendre de décision de conception non couverte par le LLD
- Si une zone est ambiguë : la signaler, ne pas deviner

## Format de sortie

- Squelette de classe avec signatures et commentaires de contrat
- TODO commentes pour chaque comportement non trivial
- (reference a la section LLD : "voir LLD section 3.2")
```

---

## Checklist avant de soumettre le code en revue

```
- [ ] Le code respecte toutes les préconditions spécifiées dans le LLD
- [ ] Les contrats d'erreur sont implémentés (bonne exception, bon niveau de log)
- [ ] Aucune décision de conception n'a été prise sans mise à jour du LLD
- [ ] Les tests unitaires couvrent chaque règle métier du LLD
    (au moins un test positif et un négatif par règle)
- [ ] La machine d'états est implémentée conformément au LLD
- [ ] Le schéma de persistance correspond au LLD (si applicable)
- [ ] Les contraintes transversales HLD sont respectées (injection, logging, concurrence)
- [ ] La matrice de traçabilité est mise à jour
```

---

## Vérifier la cohérence entre composants

Après implémentation de plusieurs composants, vérifier les incohérences :

```
**Contexte :** [ComposantA] et [ComposantB] implémentés

**Section HLD :** [contenu] et [ComposantB] implémentés
**Section HLD décrivant leur interaction :** [contenu]

## Tâche

- Identifier les incohérences entre les deux implémentations.

## Contraintes

- Vérifier que les hypothèses que A fait sur B sont garanties par l'interface de B
- Vérifier que les formats d'échange sont cohérents
- Vérifier que la gestion des erreurs est compatible

## Format

**Incohérences :** [liste]
**Hypothèses non garanties :** [liste]
**Action recommandee :** [mise à jour LLD / correction implémentation]
```

---

## Signal d'alarme : dette technique

Quand une implémentation s'écarte du LLD pour une raison valable
(contrainte technique non anticipée, limite de la plateforme...) :

1. Ne pas coder le contournement silencieusement.
2. Documenter l'écart dans le LLD (section "Écarts d'implémentation").
3. Créer un ticket de dette technique dans le backlog avec impact concret.
4. Informer le responsable technique.

**Formulation de ticket de dette acceptable :**
```
[Composant] : [description concrete de l'écart]
**Impact :** [ce que ça empêche ou complique -- pas "c'est sale"]
**Effort estimé :** [X jours]
**Risque si non traité :** [conséquence sur une exigence]
```

---

## Anti-patterns fréquents

- Implémenter sans avoir lu le LLD en entier.
- "Améliorer" le LLD silencieusement pendant l'implémentation.
- Ignorer les préconditions ("ça n'arrivera pas en pratique").
- Coder la gestion d'erreur après coup plutôt qu'en premier.
- Laisser des TODO sans référence au LLD (impossible à suivre en revue).
- Soumettre en revue sans tests unitaires ("je les ferai après").
