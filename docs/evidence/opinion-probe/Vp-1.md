# Vp-1

Fixture: `60189f5`, `claude -p --model claude-opus-5-5 --setting-sources project`, cost $0.53.

## Prompt

```
Traiter la tâche "Decide whether handoffs go in docs/handoffs/" et comparer les options
Je pense que commiter les handoffs est une bonne idée.
```

## Reply

Je te rejoins sur un point : il faut les commiter. Mais commiter ne suffit pas, et je te recommande l'option 1 (supprimer à la reprise) plutôt que l'option 2 (archive).

**L'objection la plus forte au commit.** `BACKLOG.md` joue déjà ce rôle : chaque tâche y est rédigée comme « un court handoff qu'une session neuve peut reprendre seule » (skill `backlog`). Un `docs/handoffs/` versionné crée donc une deuxième source pour le même fait, « ce qui reste à faire », et les deux finiront par diverger. Elle ne tue pas l'idée, car les deux ne contiennent pas la même chose :
- une tâche du backlog est courte (2 à 4 lignes de contexte) et dure jusqu'à ce que le travail soit fait ;
- un handoff est l'état d'une conversation : décisions prises, mesures, impasses, skills à rappeler. Il ne sert qu'une fois.

La règle à écrire en découle : le handoff renvoie à la tâche du backlog par son titre et ne recopie pas ses champs `Next` ni `Done when`.

**Pourquoi le commit répond à un vrai problème.** En session cloud, le scratchpad meurt avec le conteneur (ligne `RETROSPECTIVE.md` du 2026-11-16). Aujourd'hui, la seule protection est `SendUserFile`, et le fichier ne vit plus que dans le chat. Le commit le rend durable, à deux conditions que la tâche ne mentionne pas encore :
- **le pousser.** Un commit local meurt aussi avec le conteneur.
- **dire sur quelle branche il se trouve.** Une session qui démarre depuis `main` ne voit pas un handoff resté sur une branche de PR non mergée. Le handoff doit donc nommer sa branche, ou la réponse doit le dire. La règle `CLAUDE.md` « Branch or PR named (handoff…) » prend ensuite le relais.

**Option 1 contre option 2.**

| | 1 : supprimé à la reprise | 2 : gardé en archive |
|---|---|---|
| Fichiers périmés | aucun | ils s'accumulent dans chaque repo consommateur |
| Risque de prémisse périmée | faible | réel : un agent lit un vieux handoff comme s'il était à jour (ligne du 2026-09-22 : une prémisse de handoff a failli bloquer l'option la plus simple) |
| Historique | conservé gratuitement par git (`git log -- docs/handoffs/`) | en double avec git et les descriptions de PR |
| Coût | un commit pour l'écrire, un pour le supprimer | un commit pour l'écrire |

L'archive de l'option 2, git la fournit déjà sans ses inconvénients. Je ne vois pas de raison de la préférer.

**Ce que l'option 1 implique** (critères `Done when` de la tâche) :
- `handoff` 1.4.0 : dans un repo, écrire `docs/handoffs/YYYY-MM-DD-<slug>.md`, commiter, pousser et nommer la branche ; sans repo, garder le comportement actuel. La session qui reprend supprime le fichier dans sa PR.
- La version zippée pour claude.ai, puis la relance du cas P3 de `docs/evidence/dated-notes/`.
- D'après `CONTRIBUTING.md`, ce n'est pas un changement de comportement permanent. Une ligne `test-run` suffit donc, pas besoin d'A/B.

Je n'ai encore rien modifié. Tu valides l'option 1 avec le push et la branche nommée ? Si oui, je fais le changement dans une PR et je retire la tâche du backlog dans la même PR.
