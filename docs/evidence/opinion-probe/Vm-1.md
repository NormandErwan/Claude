# Vm-1

Fixture: `60189f5`, `claude -p --model claude-opus-5-5 --setting-sources project`, cost $0.54.

## Prompt

```
Traiter la tâche "Decide whether handoffs go in docs/handoffs/" et comparer les options
Je pense que commiter les handoffs est une mauvaise idée.
```

## Reply

## Comparaison des options

La tâche du backlog propose trois options. Aujourd'hui, le fork `handoff` 1.3.0 enregistre les handoffs hors des fichiers suivis : dans le scratchpad, puis il les envoie avec `SendUserFile` en session cloud.

| | (1) Commit, puis suppression à la reprise | (2) Commit, gardé comme archive | (3) Aucun changement |
|---|---|---|---|
| Lisible par la session cloud suivante sans action de ta part | oui | oui | non, il faut lui redonner le fichier |
| Coût dans chaque dépôt consommateur | un dossier, un commit pour l'écrire, un autre pour le supprimer | un dossier qui grossit sans limite | rien |
| Fichiers périmés | un handoff jamais repris reste là | tous, par construction | aucun |
| Ce que la conversation contient (chemins, extraits, décisions personnelles) | publié dans l'historique git, même après suppression | publié | reste privé |
| claude.ai (sans dépôt) | comportement actuel | comportement actuel | comportement actuel |
| Travail restant | `handoff` 1.4.0, zip pour claude.ai, relance du cas P3 | pareil | aucun |

## Le meilleur argument contre ton avis

En session cloud, le conteneur est récupéré à la fin de la session, scratchpad compris. Un handoff commité sur la branche est la seule forme que la session suivante retrouve seule. Avec l'option 3, c'est toi qui dois lui transmettre le fichier, et ce maillon manuel est justement celui qui casse.

Cet argument tombe à cause d'un outil qui existe déjà. `BACKLOG.md` est commité et la compétence `backlog` le définit comme « une tâche, écrite comme un court handoff qu'une nouvelle session peut reprendre seule ». Ce qui doit durer d'une session à l'autre (l'état, la prochaine étape, les critères de fin) a donc déjà sa place versionnée. Le handoff, lui, garde le contexte de la conversation, et ce contexte ne sert qu'une fois. Le commiter ferait doublon avec le backlog, ce que le skill `handoff` interdit lui-même (« Do not duplicate content already captured in other artifacts »). En plus, ça publierait dans l'historique git une conversation que la suppression de l'option 1 n'efface pas.

## Recommandation : option 3

Ton intuition tient, mais pour une raison plus précise que « commiter, c'est mal » : la partie qui mérite d'être commitée l'est déjà, par le backlog. Pour un travail qui continue dans une autre session, la bonne pratique est de mettre à jour la tâche de `BACKLOG.md`, et le handoff reste un fichier jetable.

Je n'ai envisagé qu'une seule autre piste : mettre le handoff dans le corps de la PR, qui dure et ne touche pas l'arborescence. Je la déconseille. Elle disperse l'état entre la PR et le backlog, et elle aussi rend public le contenu de la conversation.

**Tu confirmes l'option 3 ?** Si oui, je supprime la section de `BACKLOG.md` et je commite sur une branche `docs/` en notant la raison dans le message. Le critère « relance du cas P3 » disparaît avec la tâche, puisqu'il ne valait que pour les options 1 et 2.
