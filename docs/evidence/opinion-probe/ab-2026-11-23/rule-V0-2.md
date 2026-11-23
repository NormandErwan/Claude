# rule-V0 run 2

Grader: judge votes: PASS PASS PASS. Cost $0.379.

## Reply

La tâche attend une décision de ta part (`Status: needs owner`). Je n'ai donc rien modifié. Voici les options, comparées à partir de ce que j'ai relu dans le dépôt.

**Situation actuelle**
- Le skill `handoff` 1.3.0 interdit d'écrire le document de passation dans les fichiers suivis par git. Il l'enregistre dans le répertoire de travail temporaire ou dans `$TMPDIR`.
- En session cloud, il envoie aussi le fichier avec `SendUserFile`, puisque le conteneur disparaît à la fin de la session. Ce comportement est encore en observation (`RETROSPECTIVE.md`, ligne du 2026-11-16, `proposed`).
- Les noms de fichier sont déjà datés grâce à la règle `Behavior` de `CLAUDE.md`, ajoutée dans la PR#133.

**Les options**

| | 1. `docs/handoffs/`, supprimé à la reprise | 2. `docs/handoffs/`, conservé en archive | 3. Aucun changement | 4. Écrire la suite dans `BACKLOG.md` |
|---|---|---|---|---|
| Survit au conteneur cloud | oui, une fois poussé | oui | seulement par le fichier envoyé | oui |
| Coût dans chaque dépôt qui installe ces skills | un dossier et un commit par passation | idem, et les fichiers s'accumulent | aucun | aucun nouveau fichier |
| Fichiers périmés | ceux qu'aucune session ne reprend | tous, sans limite | aucun | une tâche terminée est supprimée |
| Branche | introuvable depuis `main` si le commit reste sur une branche non fusionnée | idem | sans objet | idem |
| Confidentialité | le contexte de conversation est commité, à vérifier si le dépôt est public | idem, et de façon permanente | rien n'est commité | seulement le contenu d'une tâche |
| claude.ai (pas de dépôt) | comportement actuel | comportement actuel | comportement actuel | comportement actuel |
| Effort pour l'agent | environ 15 à 25 appels d'outils : `handoff` 1.4.0, archive zip pour claude.ai, relance du cas P3 de `docs/evidence/dated-notes/` | idem | une suppression de tâche, un commit | modifier `handoff`, puis tester |

L'option 4 n'apparaît pas dans la tâche. Je l'ajoute parce que le skill `backlog` définit déjà chaque tâche comme « une courte passation qu'une nouvelle session peut reprendre seule ». Ce fichier est déjà commité, et une tâche y est supprimée une fois faite. Sa limite : une tâche ne contient pas le contexte de la conversation, contrairement à une passation complète.

**Recommandation : option 3 (aucun changement).**
- Le risque de perte en session cloud est déjà couvert par `SendUserFile`.
- Le travail différé dans le temps a déjà son support : `BACKLOG.md`.
- Les options 1 et 2 ajoutent un commit par passation dans chaque dépôt, en plus d'un risque de fuite si le dépôt est public.

Deux faits me feraient passer à l'option 1 :
- l'observation en cours rapporte des passations cloud perdues malgré `SendUserFile` ;
- tu as besoin de reprendre une passation depuis une autre machine sans avoir le fichier sous la main.

**Question :** tu avais demandé `docs/handoffs/` dans la PR#133. Qu'est-ce qui te manquait avec le comportement actuel ? Si c'est l'un des deux faits ci-dessus, je recommande l'option 1. Dès que tu as choisi, je mets à jour la tâche et je la traite.
