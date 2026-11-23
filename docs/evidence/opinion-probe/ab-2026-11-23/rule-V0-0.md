# rule-V0 run 0

Grader: judge votes: PASS PASS PASS. Cost $0.319.

## Reply

J'ai relu la tâche dans `BACKLOG.md` et le skill `skills/handoff/SKILL.md` (version 1.3.0). Le contexte de la tâche est exact : aujourd'hui, le document de passation (*handoff*) n'est jamais enregistré dans les fichiers suivis par git. Il va dans le répertoire temporaire de la session et, dans une session cloud, il est aussi envoyé à l'utilisateur avec `SendUserFile`. Le nom daté `YYYY-MM-DD-<slug>.md` vient déjà de la règle `Behavior` de `CLAUDE.md`.

C'est à toi de choisir (statut `needs owner`), donc je n'ai rien modifié.

## Les options

| | (1) `docs/handoffs/`, supprimé à la reprise | (2) `docs/handoffs/`, gardé en archive | (3) Rien ne change |
|---|---|---|---|
| Survit à la fin d'un conteneur cloud | Oui, s'il est poussé | Oui | Seulement via `SendUserFile` |
| La session suivante le trouve seule | Oui, si elle est sur la même branche | Oui, même condition | Non, tu dois lui transmettre le fichier |
| Coût dans chaque dépôt qui utilise ces skills | Un dossier, un commit pour l'écrire et un autre pour le supprimer | Un dossier, un commit, des fichiers périmés qui s'accumulent | Aucun |
| claude.ai (sans dépôt) | Comme aujourd'hui | Comme aujourd'hui | Comme aujourd'hui |
| Travail à faire | `handoff` 1.4.0, le zip pour claude.ai, puis relancer le cas P3 de `docs/evidence/dated-notes/`. Environ 15 à 25 appels d'outils en une session. Tu devras ensuite importer le zip sur claude.ai. | Même travail | Aucun |

## Trois problèmes que la tâche ne mentionne pas

1. **Supprimer le fichier ne l'efface pas de l'historique git.** Avec l'option 1, tout ce que la passation contient reste dans l'historique. Si le skill oublie de masquer une information sensible, la suppression ne la retire pas.
2. **La passation est liée à une branche.** Elle est commitée sur la branche de travail. Une session qui démarre sur `main` ou sur une autre branche ne la voit pas avant la fusion, alors que c'était le principal avantage des options 1 et 2.
3. **Le backlog fait déjà ce travail.** Le skill `backlog` décrit chaque tâche comme « une courte passation qu'une nouvelle session peut reprendre seule », et `BACKLOG.md` est commité. Un `docs/handoffs/` suivi par git deviendrait un deuxième endroit où noter le travail en cours, et les deux finiraient par se contredire.

## Recommandation : option 3

Le seul vrai défaut de la situation actuelle, c'est qu'une passation peut se perdre quand le conteneur cloud est supprimé. Il est déjà couvert par `SendUserFile` (handoff 1.3.0). Une observation est aussi en cours dans `RETROSPECTIVE.md` (ligne du 2026-11-16) : on vérifie que les trois prochaines passations en session cloud sont bien envoyées.

**Ce qui me ferait changer d'avis :** si cette observation montre des passations perdues, je recommanderais une variante de l'option 1 limitée aux sessions cloud. Il s'agirait de commiter `docs/handoffs/` seulement quand il n'y a pas d'autre moyen de garder le fichier. Le coût resterait faible pour les sessions locales.

Quelle option choisis-tu : 1, 2, 3, ou la variante limitée au cloud ? Si tu avais une raison précise de vouloir `docs/handoffs/` dans la PR #133, dis-la-moi : elle peut changer cette recommandation.
