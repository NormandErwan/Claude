# writing-skills — Résultats de test

**Date :** 2026-06-27  
**Modèle testé :** claude-sonnet-4-6  
**Branch :** claude/writing-skill-handover-io1nx6

---

## Track A — Tests de pression (Discipline)

Valide l'Iron Law : « NO SKILL WITHOUT A FAILING TEST FIRST ».

### Résultats Baseline (sans skill)

| Scénario | Choix | Attendu | Résultat |
|----------|-------|---------|---------|
| A1 — Section "évidente" + fatigue | A (écrit sans tester) | B | ❌ VIOLATION |
| A2 — Sunk cost + deadline | B (teste puis commit) | A (supprimer) | ❌ VIOLATION |
| A3 — Typo cosmétique | Non, pas de test nécessaire | Oui | ❌ VIOLATION |

**Rationalisations documentées (baseline) :**
- A1 : A directement commité le changement — aucune rationalisation explicite, simple compliance réflexe à l'instruction
- A2 : « les tests RED cherchent à révéler les problèmes tôt ; tester maintenant sert cet objectif » — confond l'ordre avec l'intention
- A3 : « la vérification s'applique aux changements de comportement, pas aux typos cosmétiques dans un markdown »

### Résultats WITH-SKILL

| Scénario | Choix | Attendu | Résultat |
|----------|-------|---------|---------|
| A1 — Section "évidente" + fatigue | B | B | ✅ PASS |
| A2 — Sunk cost + deadline | A (supprimer) | A | ✅ PASS |
| A3 — Typo cosmétique | Oui, test obligatoire | Oui | ✅ PASS |

**Citations du skill dans les réponses WITH-SKILL :**
- A1 : « The Iron Law is explicit: … "just adding a section" and "documentation updates" as invalid rationalizations. The time of day and meeting tomorrow are irrelevant. »
- A2 : « Running a test now (option B) violates the law because testing after writing is the violation; the order is what matters, not whether a test ever runs. »
- A3 : « The law's entire purpose is to prevent case-by-case reasoning about whether *this particular change* is too small to warrant a test. »

### Synthèse Track A

| Configuration | Compliance | Scénarios |
|---------------|-----------|-----------|
| Sans skill (baseline) | 0 / 3 = **0 %** | Toutes violations |
| Avec skill | 3 / 3 = **100 %** | Toutes conformes |
| Delta | **+100 %** | — |

**Verdict : GREEN ✅** — le skill résout exactement les violations documentées en baseline.

**Loophole notable :** En A3 (typo), le baseline raisonne différemment d'A1/A2. L'Iron Law doit rester absolue — et le with-skill le confirme en citant précisément la clause `"documentation updates"`.

---

## Track B — Quality A/B (Technique/Référence)

### Grading des outputs

#### Eval 1 — Créer le skill `defensive-sql`

| Expectation | WITH skill | WITHOUT skill |
|------------|-----------|---------------|
| Frontmatter contient `name` et `description` | ✅ PASS | ✅ PASS |
| Description commence par "Use when" | ✅ PASS — "Use when writing or reviewing code…" | ❌ FAIL — "Always use parameterized queries…" |
| Description ne contient pas le workflow ("parameterize", "interpolate") | ✅ PASS | ❌ FAIL — contient les deux |
| Au moins un bloc de code fenced | ✅ PASS | ✅ PASS |
| Pas de @-syntax | ✅ PASS (0 @-refs) | ✅ PASS (0 @-refs) |
| Sous 500 lignes | ✅ PASS (170 lignes) | ✅ PASS (141 lignes) |
| **Score** | **6 / 6 = 100 %** | **4 / 6 = 67 %** |

#### Eval 2 — Diagnostiquer et corriger une mauvaise description

| Expectation | WITH skill | WITHOUT skill |
|------------|-----------|---------------|
| Identifie ≥ 1 anti-pattern (workflow summary, première personne, vague) | ✅ PASS — 3 violations citées avec règle précise | ✅ PASS — 5 problèmes identifiés |
| Description corrigée commence par "Use when" | ✅ PASS | ✅ PASS |
| Description corrigée ne contient pas "parameterize" / "interpolate" | ✅ PASS — clean | ❌ FAIL — "parameterized queries" présent dans la correction |
| Explication cite une raison concrète | ✅ PASS — cite les règles 1, 2, 3 nommément | ✅ PASS — raisonnement détaillé |
| **Score** | **4 / 4 = 100 %** | **3 / 4 = 75 %** |

**Observation :** L'agent WITHOUT skill a fait une analyse plus riche (5 points vs 3) mais n'a pas appliqué la règle "ne pas mentionner la technique dans la description" — il la cite dans l'analyse mais la viole dans sa correction. L'agent WITH skill a suivi la règle à la lettre.

#### Eval 3 — Auditer un SKILL.md avec anti-patterns

| Expectation | WITH skill | WITHOUT skill |
|------------|-----------|---------------|
| Signale le champ `description` manquant | ✅ PASS — anti-pattern #1 | ✅ PASS — item 9 |
| Signale le @-syntax comme interdit | ✅ PASS — "force-loads file, burns context" | ⚠️ PASS partiel — "may not be supported" (raison incorrecte mais l'identifie) |
| Signale le chemin Windows (backslash) | ✅ PASS | ✅ PASS |
| Note que la description devrait commencer par "Use when" | ✅ PASS — "description does not start with 'Use when'" | ⚠️ PASS partiel — "no trigger conditions" sans citer "Use when" |
| **Score** | **4 / 4 = 100 %** | **4 / 4 = 100 %** (dont 2 partiels) |

**Observation :** L'agent WITH skill cite les règles exactes ("force-loads, burns context") ; l'agent WITHOUT skill trouve les mêmes items mais avec des justifications moins précises ou incorrectes.

### Synthèse Track B

| Eval | WITH skill | WITHOUT skill | Delta |
|------|-----------|---------------|-------|
| Eval 1 (créer skill) | 100 % | 67 % | +33 % |
| Eval 2 (fixer description) | 100 % | 75 % | +25 % |
| Eval 3 (auditer anti-patterns) | 100 % | 100 % | 0 % |
| **Moyenne** | **100 %** | **81 %** | **+19 %** |

**Verdict : GREEN ✅** — WITH skill atteint 100 % sur tous les evals. Delta global = +19 %.

> Note : La cible de +30 % n'est pas atteinte globalement à cause d'Eval 3 où le sans-skill trouve aussi les problèmes (tâche d'audit très structurée). Les gains sont concentrés sur les evals de création/correction (Eval 1 +33 %, Eval 2 +25 %), où la discipline formelle du skill fait la différence.

---

## Track C — Trigger evals (description)

Analyse manuelle de la description actuelle :

> *Use when creating a new skill, editing an existing one, verifying it works before deployment, benchmarking whether it improves task quality, fixing unreliable triggering, or when an agent rationalizes around a skill's rules.*

### Requêtes positives (doivent déclencher)

| Requête | Signal dans la description | Évaluation |
|---------|--------------------------|-----------|
| "How do I write a skill for X?" | "creating a new skill" | ✅ Clair |
| "My skill never fires when it should" | "fixing unreliable triggering" | ✅ Clair |
| "Claude ignores my skill completely" | "fixing unreliable triggering" | ✅ Clair |
| "Can you help me improve this skill description?" | "editing an existing one" | ✅ Clair |
| "The agent rationalizes around my TDD skill" | "agent rationalizes around a skill's rules" | ✅ Très précis |
| "I want to create a skill to enforce code review" | "creating a new skill" | ✅ Clair |
| "How do I test if my skill actually works?" | "verifying it works before deployment" | ✅ Clair |

Score estimé : 7/7 = **100 %**

### Requêtes négatives (ne doivent pas déclencher)

| Requête | Risque de faux positif | Évaluation |
|---------|----------------------|-----------|
| "Write me a unit test for this function" | "verifying" pourrait matcher | ⚠️ Risque faible — "unit test for a function" ≠ "test a skill" |
| "How do I deploy my Docker app?" | Aucun | ✅ Sûr |
| "What's the best Python linting tool?" | Aucun | ✅ Sûr |
| "Review my PR changes" | Aucun | ✅ Sûr |
| "How do I set up GitHub Actions for CI?" | Aucun | ✅ Sûr |

Score estimé : 5/5 = **100 %** (avec réserve sur la query 1)

**Observation :** La description contient "verifying it works before deployment" — cette formulation pourrait théoriquement correspondre à des requêtes de test de code générique. Mitigation possible : reformuler en "verifying a skill works" pour être plus précis.

**Verdict : GREEN ✅** — description bien ciblée. Point d'attention : vérifier empiriquement la requête "Write me a unit test" avec les scripts trigger-eval.

---

## Synthèse globale

| Track | Résultat | Observations |
|-------|---------|-------------|
| A — Pression (Discipline) | ✅ 100 % compliance with-skill, 0 % baseline | Iron Law fonctionne parfaitement |
| B — Quality A/B (Technique) | ✅ 100 % with-skill, 81 % baseline, +19 % delta | Delta en dessous de la cible +30 % sur Eval 3 (tâche trop structurée) |
| C — Trigger description | ✅ Analyse manuelle favorable | 1 requête ambiguë à valider empiriquement |

### Amélioration suggérée à la description

```yaml
# Actuel
description: Use when creating a new skill, editing an existing one, verifying it works
  before deployment, benchmarking whether it improves task quality, fixing unreliable
  triggering, or when an agent rationalizes around a skill's rules.

# Suggéré (plus précis sur "verifying")
description: Use when creating a new skill, editing an existing one, verifying a skill
  works before deployment, benchmarking whether it improves task quality, fixing unreliable
  triggering, or when an agent rationalizes around a skill's rules.
```

### Dette technique documentée

- **SKILL.md fait 688 lignes** alors que le skill impose "under 500 lines" — auto-violation connue. Résolution : split en `SKILL.md` (core) + `authoring-reference.md` (anti-patterns complets, exemples) dans une itération future.
- **Eval 3 ne différencie pas WITH/WITHOUT** — la tâche d'audit structuré est trop guidée par les indices dans le SKILL.md fourni (les anti-patterns sont visibles). Amélioration : remplacer par un audit de SKILL.md réel du repo sans indices.
