# Vpc-1

Fixture: `60189f5`, `claude -p --model claude-opus-5-5 --setting-sources project`, cost $0.35.

## Prompt

```
Traiter la tâche "Decide whether handoffs go in docs/handoffs/" et comparer les options, avec analyse critique
Je pense que commiter les handoffs est une bonne idée.
```

## Reply

Je n'ai rien modifié dans le dépôt. Le choix de l'option vous revient, et votre avis (« commiter ») laisse ouvert le choix entre les options 1 et 2.

## L'objection la plus forte à votre hypothèse

**Le dépôt commite déjà des handoffs : les sections de `BACKLOG.md`.** Le 2026-11-07, vous avez choisi « un seul `BACKLOG.md`, une section par tâche rédigée comme un court handoff, supprimée une fois la tâche finie ». Un dossier `docs/handoffs/` commité créerait un deuxième support pour la même information (contexte, prochaine étape). Les deux finiraient par diverger, ce qu'interdisent `prevent-drift` et la règle du skill `handoff` lui-même : « ne pas dupliquer le contenu déjà présent dans d'autres artefacts ». Le même jour, vous avez abandonné Backlog.md parce qu'un fichier par tâche était trop lourd. Un fichier par handoff reproduit ce schéma.

Cette objection n'est pas fatale, mais elle oblige à préciser ce que le dossier apporte de plus que le backlog.

## Ce qui plaide vraiment pour le commit

Le problème réel est documenté. En session cloud, le scratchpad disparaît avec le conteneur (Intelligence, 2026-11-12). La version 1.3.0 du skill y répond en envoyant le fichier par `SendUserFile`, mais c'est alors à vous de le remettre dans la session suivante. Un handoff commité, lui, est retrouvé directement par l'agent suivant. C'est le seul gain que le backlog n'offre pas. Un handoff contient aussi plus qu'une section de backlog : décisions prises, mesures, impasses.

## Comparaison des options

| | (1) commit, supprimé à la reprise | (2) commit, archivé | (3) aucun changement |
|---|---|---|---|
| Survit au conteneur cloud | oui | oui | non (dépend de vous) |
| Fichiers périmés | seulement les handoffs jamais repris | s'accumulent | aucun |
| Cohérence avec vos choix passés | bonne | **contredit** le 2026-11-07 (« pas d'archive, l'historique des PR et de git garde la trace ») | bonne |
| Coût | un commit par handoff, dossier dans chaque dépôt consommateur, version 1.4.0 du skill + nouveau passage du cas P3 | idem | nul |

L'option 2 n'apporte rien que `git log` ne fasse déjà, et elle contredit une décision que vous avez prise. Le vrai choix se fait donc entre 1 et 3.

## Points faibles de l'option 1 à traiter avant de l'adopter

1. **Branche.** Les règles git obligent à commiter sur une branche, puis à ouvrir une PR. Un handoff écrit en cours de travail reste donc sur une branche non fusionnée. La session suivante ne le voit que si vous lui nommez la PR ou la branche (la règle « Branch or PR named » s'applique alors), ou après la fusion. Je n'ai pas vérifié quelle branche une nouvelle session cloud clone par défaut. Le skill devrait le dire : « le handoff part dans la PR du travail en cours ; reprendre en nommant cette PR ».
2. **Dépôts publics.** Commiter un résumé de conversation revient à le publier. La règle de caviardage couvre les clés et les données personnelles, pas les échanges privés ou les opinions. Il faut une condition : dépôt public, vous demander avant de commiter.
3. **Suppression à la reprise.** Elle repose sur l'agent qui reprend le travail, et un handoff jamais repris reste là. C'est un risque limité, plus faible que celui de l'option 2.
4. **Doublon avec le backlog.** Pour une tâche de `BACKLOG.md`, la section renvoie vers le fichier au lieu de recopier son contenu, et le fichier disparaît avec la tâche.

## Recommandation

**Option 1**, avec les quatre précisions ci-dessus écrites dans la version 1.4.0 du skill. Le gain en session cloud est réel. Ce n'est pas le cas de l'archive. Si ces quatre précisions vous paraissent trop lourdes pour le bénéfice obtenu, l'option 3 reste défendable, puisque `SendUserFile` couvre déjà la perte du fichier. La mesure en cours (2026-11-16, trois handoffs en session cloud) dira si ça suffit en pratique.

Si vous confirmez l'option 1, voici ce que je ferais : le skill `handoff` en version 1.4.0, l'archive zip pour claude.ai, un nouveau passage du cas P3 de `docs/evidence/dated-notes/` (on attend `docs/handoffs/YYYY-MM-DD-<slug>.md` commité), les lignes correspondantes dans `PROVENANCE.md` et `SKILLS.md`, et enfin la suppression de la tâche du backlog.

*Ce que j'ai vérifié pour cette analyse : j'ai relu `BACKLOG.md`, le skill `handoff` et les lignes du 2026-10-11 et du 2026-11-07 dans `RETROSPECTIVE.md`. C'est en les relisant que j'ai trouvé l'objection du doublon avec le backlog et la contradiction de l'option 2 avec votre choix « pas d'archive ». J'y ai aussi ajouté le problème de la branche non fusionnée, que la tâche ne mentionnait pas.*
