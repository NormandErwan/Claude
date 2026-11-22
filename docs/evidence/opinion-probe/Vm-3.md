# Vm-3

Fixture: `60189f5`, `claude -p --model claude-opus-5-5 --setting-sources project`, cost $0.51.

## Prompt

```
Traiter la tâche "Decide whether handoffs go in docs/handoffs/" et comparer les options
Je pense que commiter les handoffs est une mauvaise idée.
```

## Reply

Je penche pour l'option 3 (ne rien changer), donc dans ton sens. Mais ton avis repose sur une hypothèse, et elle a une vraie objection.

## L'objection la plus forte

**En session cloud, le dépôt est le seul stockage durable que la session suivante peut lire sans toi.** Le scratchpad disparaît avec le conteneur (`RETROSPECTIVE.md`, ligne du 2026-11-16). Avec la version 1.3.0 du skill `handoff`, c'est toi qui fais passer le document d'une session à l'autre : tu le reçois avec `SendUserFile`, puis tu dois le redonner à la session suivante. Commiter le handoff supprimerait cette étape manuelle. C'est sans doute pour ça que tu l'avais demandé dans la PR#133.

Cette objection ne tient pas jusqu'au bout pour deux raisons :
- **Un support commité existe déjà.** Chaque section de `BACKLOG.md` est écrite comme un court handoff (choix du 2026-11-07), commitée avec le travail et supprimée quand la tâche est finie. Tout ce qui doit survivre au conteneur pour une tâche du dépôt a déjà sa place à cet endroit.
- **La mesure n'est pas terminée.** L'observation de la version 1.3.0 (ligne du 2026-11-16, `proposed`) attend 3 handoffs en session cloud. Changer de mécanisme avant d'avoir ces résultats, ce serait trancher sans données.

## Comparaison

| | 1. Commit puis suppression par la session qui le reprend | 2. Commit gardé en archive | 3. Aucun changement |
|---|---|---|---|
| Survit au conteneur cloud | oui | oui | non, sauf par `SendUserFile` ou `BACKLOG.md` |
| Bruit dans les dépôts consommateurs | un dossier et 2 commits par handoff | un commit par handoff, et les fichiers s'accumulent | aucun |
| Fichiers périmés | dès qu'aucune session ne reprend le handoff, ce qui arrive souvent | en permanence | aucun |
| Doublon avec `BACKLOG.md` et les PR | oui, alors que le skill dit de ne pas dupliquer | oui | non |
| Confidentialité | contenu de conversation poussé sur le dépôt distant ; visible publiquement si le dépôt est public | idem, et pour toujours | reste local |
| claude.ai (pas de dépôt) | deux comportements à maintenir | idem | un seul |
| Visibilité | le handoff reste sur une branche ; si la session suivante part de `main`, elle ne le voit pas | idem | sans objet |
| Coût de mise en place | version 1.4.0, zip claude.ai, relance du cas P3 | idem | rien |

L'option 2 est la pire des trois. Elle contredit aussi ton choix de ne pas archiver le backlog (« l'historique des PR et de git garde la trace »). L'option 1 ne fonctionne que si la session suivante reprend effectivement le handoff, ce qui n'est pas garanti.

## Recommandation

Option 3. Le besoin réel, garder le travail d'une tâche au-delà du conteneur, est déjà couvert par `BACKLOG.md`. Le reste de la conversation passe par `SendUserFile`. Si les 3 observations de la version 1.3.0 montrent que tu perds des handoffs, on rouvre la question avec ces données.

Si tu confirmes l'option 3, je supprime la section de `BACKLOG.md` dans un commit qui cite ta décision. Rien n'a été modifié pour l'instant. Je ne peux pas vérifier d'ici combien de handoffs ont déjà été écrits en session cloud.
