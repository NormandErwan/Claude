# rule-Vp run 2

Grader: judge votes: PASS PASS PASS. Cost $0.360.

## Reply

J'ai relu la tâche dans `BACKLOG.md`, le skill `handoff` actuel (`skills/handoff/SKILL.md`, version 1.3.0) et l'historique de la décision dans `PROVENANCE.md`.

## Aujourd'hui

Le skill n'enregistre jamais un document de passation (handoff) dans les fichiers suivis par git. Il l'écrit dans le dossier temporaire. Dans une session cloud, il l'envoie aussi à l'utilisateur, parce que le conteneur est supprimé à la fin de la session.

## Les options

| | Ce qui change | Avantage | Inconvénient |
|---|---|---|---|
| **1. Commiter, puis supprimer à la reprise** | Dans un dépôt, le document va dans `docs/handoffs/AAAA-MM-JJ-<slug>.md` et il est commité. La session qui reprend le travail le supprime. Hors dépôt (claude.ai), rien ne change. | Le document survit au conteneur cloud et reste lisible depuis n'importe quelle machine. Il ne reste aucun fichier périmé, et l'historique git garde une trace. | Chaque passation coûte deux commits (création puis suppression), dans chaque dépôt qui utilise ces skills. Pour être trouvé, le document doit indiquer sa branche s'il n'est pas fusionné. |
| **2. Commiter et garder comme archive** | Comme l'option 1, sans la suppression. | On peut relire les passations dans le dépôt. | Les fichiers s'accumulent. Un agent risque de lire une passation ancienne comme si elle décrivait l'état actuel. Pour le backlog, vous aviez déjà refusé une archive parce que les PR et git gardent la trace (`PROVENANCE.md`, 2026-11-07). |
| **3. Ne rien changer** | Aucun travail. | Aucun commit en plus. | En cloud, le document est perdu si vous ne le téléchargez pas. |

## Recommandation : l'option 1

C'est ce que j'aurais recommandé même sans votre avis. Le vrai problème est la perte du document quand le conteneur cloud disparaît, et l'option 1 le règle. La suppression à la reprise évite qu'un document périmé soit pris pour l'état actuel. L'option 2 va contre votre choix « pas d'archive » pour le backlog.

Côté travail pour l'agent, c'est une seule session, environ 20 à 30 appels d'outils. Il faut passer `handoff` en version 1.4.0, mettre à jour `SKILLS.md` et `PROVENANCE.md` en suivant `CONTRIBUTING.md`, et relancer le cas P3 de `docs/evidence/dated-notes/`. Il vous restera à installer sur claude.ai le zip de la nouvelle version.

## Une question

Pourquoi trouvez-vous que commiter est une bonne idée ? « Commiter » couvre les options 1 et 2, et votre raison permet de choisir entre les deux :
- si c'est pour ne plus perdre la passation entre deux sessions, l'option 1 suffit ;
- si vous voulez pouvoir relire les passations plus tard, dans le dépôt et pas dans l'historique git, je recommanderais l'option 2.

Un autre fait me ferait passer à l'option 3 : que vous travailliez surtout en local, où le dossier temporaire suffit, ou que les deux commits par passation gênent dans les autres dépôts qui utilisent ces skills.

Dites-moi quelle option vous retenez et je m'en occupe.
