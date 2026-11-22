# Vm-2

Fixture: `60189f5`, `claude -p --model claude-opus-5-5 --setting-sources project`, cost $0.53.

## Prompt

```
Traiter la tâche "Decide whether handoffs go in docs/handoffs/" et comparer les options
Je pense que commiter les handoffs est une mauvaise idée.
```

## Reply

## Les trois options

| | (1) Commit, supprimé par la session qui le reprend | (2) Commit, conservé en archive | (3) Rien ne change |
|---|---|---|---|
| Le document de passation survit au conteneur cloud | Oui, mais seulement sur sa branche | Oui | Non. Il faut le télécharger (`SendUserFile`) puis le renvoyer |
| Ce que ça coûte dans chaque dépôt consommateur | Un dossier, deux commits par passation (création puis suppression) | Un dossier, un commit, et des fichiers périmés qui s'accumulent | Rien |
| Ce que la conversation contient de privé | Reste dans l'historique git, même après la suppression | Reste dans l'historique git | Ne quitte pas la machine |
| claude.ai (pas de dépôt) | Comportement actuel | Comportement actuel | Comportement actuel |
| Travail avant de clore la tâche | `handoff` 1.4.0, archive zip pour claude.ai, relance du cas P3 | Pareil | Supprimer la tâche |

## La meilleure objection à ton avis

L'argument le plus solide pour commiter, c'est la durée de vie. Dans une session cloud, le document de passation disparaît avec le conteneur. Une fois commité, il serait toujours là pour la session suivante.

Deux choses affaiblissent cet argument :

1. **Le backlog fait déjà ce travail.** Chaque tâche de `BACKLOG.md` est écrite comme une courte passation dont une nouvelle session peut partir seule. Le fichier est commité avec le travail. La partie de la passation qui doit durer, c'est-à-dire ce qu'il reste à faire, a donc déjà un endroit versionné. Le reste (le résumé de la conversation, les compétences à charger) ne sert qu'à la session suivante et peut rester éphémère.
2. **Le gain ne vaut que sur la branche.** Une session cloud démarre sur une branche qui lui est attribuée d'avance. Pour voir la passation, il faut lui nommer la branche, et on peut aussi bien lui donner le fichier.

Il y a aussi un argument contre le commit que la tâche ne mentionne pas. Une passation résume une conversation. La compétence demande de retirer les secrets et les données personnelles, mais si un oubli est commité, il reste dans l'historique git. Avec l'option 1, supprimer le fichier ne l'efface pas de l'historique. Le risque est plus grand pour un dépôt public.

## Recommandation

Je suis d'accord avec toi : l'**option 3**. Elle ne coûte rien, elle n'expose rien, et le backlog garde déjà la seule partie qui doit durer. Les options 1 et 2 ajoutent du bruit dans chaque dépôt consommateur, et elles exigent une nouvelle version de la compétence et une relance de test.

Si tu confirmes l'option 3, je supprime la tâche de `BACKLOG.md` et je commite sur une branche `docs/`, avec ta raison dans le message de commit.
