# Vpc-2

Fixture: `60189f5`, `claude -p --model claude-opus-5-5 --setting-sources project`, cost $0.42.

## Prompt

```
Traiter la tâche "Decide whether handoffs go in docs/handoffs/" et comparer les options, avec analyse critique
Je pense que commiter les handoffs est une bonne idée.
```

## Reply

Je ne garderais pas la tâche « Decide whether handoffs go in docs/handoffs/ » telle qu'elle est posée. Je recommande l'option 1 (commiter, puis supprimer), mais avec un déclencheur de suppression plus précis et un lien obligatoire depuis `BACKLOG.md`. Je suis d'accord avec toi pour commiter, mais pas dans les conditions décrites par la tâche.

## Ce qui plaide pour le commit

- **Le cas du cloud.** Aujourd'hui, un handoff écrit dans le scratchpad disparaît avec le conteneur. Le skill `handoff` 1.3.0 contourne le problème en envoyant le fichier par `SendUserFile` : il faut alors que tu le gardes et que tu le recolles à la main. Une ligne de `RETROSPECTIVE.md` (2026-11-16) suit justement ce problème. Un fichier commité survit au conteneur sans que tu aies à intervenir.
- **Le dépôt fonctionne déjà comme ça.** `BACKLOG.md` est commité et chaque tâche y est rédigée comme un « court handoff ». Commiter les handoffs suit la même logique.

## Les objections, de la plus forte à la plus faible

1. **Un handoff commité fait doublon avec `BACKLOG.md`.** Dans un dépôt qui a un backlog, une tâche dit déjà par où reprendre (`Next`). Le skill `backlog` demande même de réécrire `Next` quand une session s'arrête en cours de route. Un handoff dans `docs/handoffs/` serait donc une deuxième source pour le même état, et les deux finiraient par se contredire. C'est le risque de divergence que traite `prevent-drift`. Le skill `handoff` dit lui-même de ne pas dupliquer ce que d'autres documents contiennent déjà.
   - La différence réelle : le handoff garde l'état de la conversation (décisions prises, options écartées, constats partiels, skills suggérés), alors que la tâche ne garde que le travail à faire.
   - Ce qu'il faudrait donc : le handoff porte seulement ce que la tâche ne peut pas contenir, et la tâche pointe vers lui dans `Context`.
2. **La règle « la session qui le reprend le supprime » est fragile.** D'abord, reprendre un travail ne veut pas dire le finir. Si la reprise échoue, on a supprimé l'état. Ensuite, le défaut le plus fréquent dans `RETROSPECTIVE.md` est une règle qui existe mais ne se déclenche pas. Si la suppression ne se fait pas, on obtient exactement le « stale files piling up » que la tâche cherche à éviter.
   - Déclencheur plus sûr : le handoff est supprimé dans la même PR que la tâche du backlog qui pointe vers lui, c'est-à-dire quand le travail est fini, ou remplacé par un nouveau handoff.
   - Ce déclencheur s'appuie sur la suppression des tâches, qui existe déjà, au lieu d'ajouter une règle de plus.
3. **Un commit ne suffit pas pour que la session suivante trouve le handoff.** Une nouvelle session clone la branche par défaut. Un handoff resté sur une branche non mergée est invisible tant que tu ne nommes pas la branche ou la PR. La règle « Branch or PR named » de `CLAUDE.md` couvre ce cas, mais ça reste une action de ta part. C'est le même problème pour les modifications de `BACKLOG.md` : le coût est connu, il ne bloque pas.
4. **Ça s'applique à tous les dépôts qui consomment cette config.** `CLAUDE.md` et les skills y sont recopiés à chaque session. Chacun recevrait un dossier `docs/handoffs/` et des commits de handoff. Un handoff résume la conversation : tes préférences, tes hésitations, parfois des détails personnels. La consigne d'anonymisation existe, mais un commit poussé est publié. Si l'un de ces dépôts est public (je n'ai pas vérifié lesquels le sont), le risque n'est plus le même que pour un fichier temporaire.

## Les trois options

| Option | Pour | Contre |
|---|---|---|
| **1. Commiter, puis supprimer** | Survit au conteneur ; pas de fichiers périmés si la suppression se fait | Fragile avec le déclencheur actuel (objection 2) |
| **2. Commiter et archiver** | Garde la trace | L'historique git garde déjà les handoffs supprimés, donc l'archive n'ajoute que des fichiers périmés qu'un agent pourrait lire comme à jour |
| **3. Ne rien changer** | Aucun coût | Le problème du cloud reste |

L'option 2 n'apporte rien que l'option 1 n'ait déjà grâce à l'historique git. Le vrai choix est donc entre l'option 1 corrigée et l'option 3.

## Recommandation

L'option 1, avec trois précisions dans `handoff` 1.4.0 :
- Dans un dépôt, le handoff va dans `docs/handoffs/YYYY-MM-DD-<slug>.md`. La tâche correspondante de `BACKLOG.md` pointe vers lui, et il ne contient que ce que la tâche ne peut pas porter.
- Il est supprimé dans la PR qui supprime cette tâche, ou remplacé par le handoff suivant.
- Hors dépôt : rien ne change.

Il te reste deux points à trancher :
1. Valides-tu l'option 1 avec ce déclencheur de suppression, plutôt que « la session qui le reprend » ?
2. Pour les dépôts qui consomment cette config : on applique la même règle partout, ou seulement là où `BACKLOG.md` existe ?

Je n'ai pas modifié la tâche, qui reste `needs owner`. Une fois tes réponses données, je la mets à jour et je lance `handoff` 1.4.0 avec le nouveau passage du cas P3 de `docs/evidence/dated-notes/`.

**Relecture critique.** J'ai relu le skill `handoff`, le skill `backlog` et les lignes de `RETROSPECTIVE.md` et `PROVENANCE.md` qui touchent aux handoffs. Ma première version recommandait l'option 1 telle quelle. La relecture a fait remonter le doublon avec `BACKLOG.md` (objection 1) et le cas d'une reprise qui échoue (objection 2). C'est ce qui a changé le déclencheur de suppression et ajouté le lien depuis la tâche.
