# Bootstrap

Au démarrage de chaque session, synchroniser les skills depuis GitHub :

```bash
git -C ~/.claude pull --ff-only origin main 2>/dev/null || true
```

---

## Skills disponibles

### Token optimization

- `token-efficiency` — Charger avant toute opération sur fichiers, tâche multi-fichiers, ou début de session. Sélection de modèle (Haiku / Sonnet / Opus) + arbre de décision pour les opérations fichiers. Skill principal — tous les autres skills token en dépendent.
- `token-file-ops` — Patterns bash-first pour lire, éditer, créer et manipuler des fichiers. Pour les patterns .NET/C# spécifiques, charger aussi `token-dotnet`.
- `token-dotnet` — Charger pour tout projet C# ou .NET. Patterns grep avec exclusion des répertoires build, règles fichiers générés, stratégie d'exploration .NET.
- `token-codebase-exploration` — Utiliser pour explorer une base de code inconnue, comprendre comment une fonctionnalité fonctionne, ou apprendre comment les composants interagissent.

### Méthode V (développement logiciel structuré)

- `v-model-guide` — Point d'entrée unique. Charger pour tout projet logiciel structuré : démarrage, doute sur l'étape suivante, ou ambiguïté en cours de travail.
- `v-model-phase-amont` — Phase amont : EBO, faisabilité, business case, charte de projet. Prérequis obligatoire avant `v-model-niveau-1`.
- `v-model-niveau-1` — Niveau 1 : Exigences système (SRD). Après validation de la phase amont.
- `v-model-niveau-2` — Niveau 2 : Exigences logiciel (SRS). Après validation du SRD.
- `v-model-niveau-3` — Niveau 3 : Architecture / High-Level Design + ADRs. Après validation du SRS.
- `v-model-niveau-4` — Niveau 4 : Conception détaillée / LLD. Après validation du HLD.
- `v-model-implementation` — Phase d'implémentation depuis un LLD valide.
- `v-model-tests` — Branche droite du V : tests unitaires, intégration, acceptance, validation système.
- `v-model-equipe` — Pratiques d'équipe : DoR, DoD, backlog, estimation, revue de code, juniors, dette technique.
- `v-model-gestion` — Artefacts de gestion : plan de projet, risques, décisions, configuration, évolutions, jalons.
