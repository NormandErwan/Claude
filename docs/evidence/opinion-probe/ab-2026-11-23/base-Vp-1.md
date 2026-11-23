# base-Vp run 1

Grader: judge votes: FAIL FAIL FAIL. Cost $0.317.

## Reply

La tâche est en attente de ta décision (« needs owner »). Ton avis règle déjà une question : on commite les handoffs, donc l'option 3 (ne rien changer) est écartée. Il reste à choisir ce que devient un handoff une fois qu'une session l'a repris.

## Ce qui se passe aujourd'hui

La copie locale du skill `handoff` (version 1.3.0) interdit d'écrire dans les fichiers suivis du dépôt. Le document part dans le dossier de travail temporaire de la session (scratchpad) ou dans `$TMPDIR`. Dans une session cloud, il disparaît avec le conteneur, sauf si on te l'envoie avant.

## Les deux options possibles

| | **Option 1 : supprimé à la reprise** | **Option 2 : conservé comme archive** |
|---|---|---|
| Emplacement | `docs/handoffs/AAAA-MM-JJ-<slug>.md`, commité | Même emplacement |
| À la reprise | La session qui reprend le handoff le supprime dans son propre commit | Le fichier reste dans le dossier |
| Historique | Toujours consultable avec `git log -- docs/handoffs/` | Consultable directement dans le dossier |
| Dossier | Ne contient que les handoffs pas encore repris | Grossit à chaque handoff |
| Risque | Faible | Une session peut prendre un vieux handoff pour l'état actuel. C'est le défaut que la règle « une prémisse venue d'un handoff n'est pas vérifiée » de `CLAUDE.md` cherche déjà à éviter. |
| Sans dépôt (claude.ai) | Comportement actuel | Comportement actuel |

## Ma recommandation : l'option 1

Git conserve déjà l'archive, donc l'option 2 n'apporte rien de plus que des fichiers périmés visibles par les sessions suivantes. Avec l'option 1, la présence d'un fichier dans `docs/handoffs/` veut dire une seule chose : du travail attend d'être repris.

Avant de lancer quoi que ce soit, voici trois coûts à connaître. Ils valent pour les deux options :

- **Deux commits par handoff** : un pour l'ajouter, un pour le supprimer avec l'option 1. Chaque dépôt qui utilise cette configuration reçoit aussi un dossier `docs/handoffs/`.
- **La branche compte** : un handoff commité sur une branche non fusionnée est invisible depuis `main`. Pour le corriger, le skill doit pousser la branche et donner son nom dans la réponse. La session suivante utilise alors cette branche, comme le prévoit déjà la règle « Branche ou PR nommée ».
- **Confidentialité** : dans un dépôt public, chaque handoff devient public, même si le skill retire déjà les secrets. Il faut donc une règle de repli : pas de commit si le dépôt est public, sauf si tu l'autorises.

**Travail à faire une fois l'option choisie :** environ 15 à 25 appels d'outils. Cela comprend la version 1.4.0 du skill, `SKILLS.md`, le zip pour claude.ai, la nouvelle exécution du cas P3 de `docs/evidence/dated-notes/` et la mise à jour du backlog. Je lirai `CONTRIBUTING.md` avant de modifier le skill.

**Options 1 ou 2 ? Et veux-tu la règle de repli pour les dépôts publics ?**
