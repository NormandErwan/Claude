# rule-Vp run 1

Grader: judge votes: PASS PASS PASS. Cost $0.308.

## Reply

## Tâche « Decide whether handoffs go in docs/handoffs/ »

La tâche attend ta décision (statut `needs owner`). Le skill de passation (`skills/handoff/SKILL.md`, version 1.3.0) interdit aujourd'hui d'écrire le document de passation (handoff) dans les fichiers suivis par git. En session locale, il va dans `$TMPDIR`. En session cloud, il va dans un répertoire temporaire et est aussi envoyé par `SendUserFile`, mais il disparaît quand le conteneur est récupéré.

### Les trois options

| | 1. Commit, puis suppression à la reprise | 2. Commit, conservé en archive | 3. Aucun changement |
|---|---|---|---|
| Session cloud | La passation survit, poussée sur la branche de travail | Pareil | Perdue avec le conteneur, sauf si tu gardes le fichier envoyé |
| Prochaine session | La trouve sur la branche que tu lui nommes | Pareil | Tu dois lui fournir le fichier toi-même |
| Dépôts qui consomment cette config | Un dossier en plus, un commit d'ajout et un commit de suppression par passation | Un commit par passation, et les fichiers s'accumulent | Rien |
| Fichiers périmés | Aucun, la session qui reprend le supprime | Ils s'accumulent | Aucun |
| Données sensibles | Restent dans l'historique git même après la suppression | Pareil | Jamais committées |
| claude.ai (pas de dépôt) | Comportement actuel | Comportement actuel | Comportement actuel |

### Ma recommandation : l'option 1

Ton avis n'entre pas en compte ici. Je l'aurais recommandée de toute façon, pour trois raisons :
- Le comportement actuel a un vrai défaut : une passation faite en session cloud est perdue si tu ne gardes pas le fichier.
- Le commit sur la branche règle ce défaut, et `CLAUDE.md` demande déjà de reprendre une branche nommée sans confirmation.
- La suppression à la reprise évite d'accumuler des fichiers périmés. Une archive ferait doublon avec les PR et le backlog, qui gardent déjà l'historique du travail.

Le principal coût, ce sont les deux commits par passation dans chaque dépôt consommateur. Si ce bruit te gêne, il existe une variante : ne committer qu'en session cloud et garder `$TMPDIR` en local, où le fichier ne disparaît pas.

Si tu choisis l'option 1 ou 2, il faudra publier `handoff` 1.4.0, l'empaqueter en zip pour claude.ai et relancer le cas P3 de `docs/evidence/dated-notes/`. Je l'estime à environ 20 appels d'outils de mon côté.

### Une question pour toi

Pourquoi penses-tu que committer les passations est une bonne idée ? Deux faits changeraient ma recommandation :
- **Option 3** : si des dépôts consommateurs ne doivent pas recevoir de commits de passation (dépôts clients, par exemple), ou si tes passations contiennent souvent des données qui ne doivent pas rester dans l'historique git.
- **Option 2** : si tu relis d'anciennes passations après leur reprise.

Je n'ai pas modifié `BACKLOG.md`. La tâche reste en `needs owner` jusqu'à ta réponse.
