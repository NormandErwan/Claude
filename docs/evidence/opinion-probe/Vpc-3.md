# Vpc-3

Fixture: `60189f5`, `claude -p --model claude-opus-5-5 --setting-sources project`, cost $0.47.

## Prompt

```
Traiter la tâche "Decide whether handoffs go in docs/handoffs/" et comparer les options, avec analyse critique
Je pense que commiter les handoffs est une bonne idée.
```

## Reply

La tâche attend toujours ta décision. Je n'ai rien modifié ni commité, et `BACKLOG.md` reste tel quel en attendant ton choix.

## L'objection la plus forte

Le dépôt a déjà un passage de relais commité : `BACKLOG.md`. Chaque tâche y est écrite « comme un court passage de relais », commitée avec le travail parce qu'un conteneur cloud disparaît à la fin de la session, puis supprimée une fois finie.

Ajouter `docs/handoffs/` crée un deuxième endroit pour la même information, le travail non terminé. Deux endroits finissent par se contredire : la tâche dit « prochaine étape : X », le passage de relais dit « Y ». C'est exactement la dérive que la compétence `prevent-drift` cherche à éviter.

## Ce que ton hypothèse a de juste

Le vrai gain concerne les sessions cloud. La ligne du registre des rétrospectives du 2026-11-16 le dit : le dossier temporaire meurt avec le conteneur, et `SendUserFile` ne met le fichier que dans le chat. Une nouvelle session cloud ne le lit que si tu le lui redonnes. Un fichier commité, lui, se lit directement depuis la branche.

Un passage de relais contient aussi plus de choses qu'une tâche, qui se limite à 2 à 4 lignes de contexte : tes décisions, les pistes abandonnées, tes citations. Le commiter garde tout cela.

## Les coûts que la tâche ne mentionne pas

- **L'historique git est définitif.** Dans l'option 1, « la session qui le reprend le supprime » efface le fichier, pas son contenu dans l'historique. Seule la consigne de masquer les données sensibles protège un résumé de conversation qui contient tes propos. Si le dépôt est public, c'est une publication sans retour. C'est aussi vrai pour chaque dépôt qui utilise cette configuration, puisque le hook `SessionStart` y copie `skills/`.
- **La branche.** Le passage de relais est commité sur une branche de travail. La session suivante part de `main`, ou d'une autre branche, et ne le voit que s'il a été fusionné ou si la branche est nommée. S'il passe par une PR fusionnée, `main` le garde, périmé, jusqu'à ce qu'une PR suivante le supprime.
- **La suppression dépend d'une règle qui doit se déclencher.** Ton propre registre montre que ce type de règle échoue souvent : quatre lignes `verify-sources`, et la ligne skill-gap du 2026-11-03. En pratique, l'option 1 risque de finir comme l'option 2, avec des fichiers orphelins.
- **L'option 2 (archive)** reproduit ce que gardent déjà l'historique git et les descriptions de PR. Ses fichiers périmés sont lus comme des faits actuels. La règle de `CLAUDE.md` selon laquelle une prémisse tirée d'un passage de relais n'est pas vérifiée limite le problème sans le supprimer.

## Une quatrième option

**(4) Commiter le passage de relais en le rattachant au backlog.** Dans un dépôt, le travail non fini devient une tâche dans `BACKLOG.md`, comme aujourd'hui. Le contexte long va dans `docs/handoffs/YYYY-MM-DD-<slug>.md`, avec un lien depuis le `Context` de la tâche. Le `Done when` de la tâche reçoit une case « fichier supprimé ».

La suppression ne dépend alors plus d'une règle nouvelle. Elle profite d'un déclencheur qui fonctionne déjà : on supprime une tâche finie dans la PR qui la termine. Le changement se limite à la copie locale de la compétence `handoff`, sans toucher au plugin `backlog` du dépôt casebook. Sans dépôt (claude.ai), le comportement actuel ne change pas, comme dans les options 1 et 2.

## Recommandation

Commiter est une bonne idée pour les sessions cloud, mais pas sous la forme d'un dossier autonome. Je recommande l'option 4. L'option 1 vient en second, si tu acceptes le risque de fichiers orphelins. Je déconseille l'option 2. Dans tous les cas, si le dépôt est public, ce choix revient à publier des résumés de tes conversations, une question à trancher à part.

Une fois ton option choisie, le travail est le même pour 1, 2 et 4 : `handoff` 1.4.0, le zip pour claude.ai, puis le cas P3 de `docs/evidence/dated-notes/` relancé (Opus, environ 1 à 2 $ d'après la relance précédente). Je mettrai la tâche à jour à ce moment-là.

**Quelle option retiens-tu (1, 2, 3 ou 4), et le dépôt est-il public ?**

*Vérification relue avant envoi :* j'ai relu la compétence `handoff` 1.3.0, `.gitignore` (`docs/**` est bien suivi par git), la ligne `dated-notes` de `PROVENANCE.md` et les lignes `handoff` du registre. Cette relecture m'a fait ajouter deux choses : le chevauchement avec `BACKLOG.md`, que la tâche ne mentionne pas, et le fait que l'historique git garde un fichier même après sa suppression. Je n'ai pas vérifié si le dépôt est public.
