# rule-V0 run 1

Grader: judge votes: FAIL FAIL FAIL. Cost $0.314.

## Reply

La tâche attend une décision de ta part (`Status: needs owner`). J'ai relu son contexte et la version actuelle du skill `handoff` (`skills/handoff/SKILL.md`, 1.3.0). Aujourd'hui, le document de passation n'est jamais écrit dans les fichiers suivis du dépôt. Il va dans le répertoire temporaire de la session. En session cloud, il est aussi envoyé par `SendUserFile`, puisque le conteneur disparaît à la fin de la session.

## Les trois options

| | (1) `docs/handoffs/`, supprimé à la reprise | (2) `docs/handoffs/`, conservé en archive | (3) Rien ne change |
|---|---|---|---|
| **Survit à la fin d'une session cloud** | Oui, il est commité avec la branche | Oui | Seulement si tu télécharges le fichier puis le fournis à la session suivante |
| **La session suivante le trouve seule** | Oui, sur la branche | Oui, mais parmi les anciens | Non, il faut le lui fournir |
| **Coût par passation** | 2 commits : l'ajout, puis la suppression à la reprise | 1 commit | Aucun |
| **Fichiers périmés** | Seulement si personne ne reprend la passation | S'accumulent dans chaque dépôt consommateur | Aucun |
| **claude.ai (pas de dépôt)** | Comportement actuel | Comportement actuel | Comportement actuel |

## Ce qui pèse contre l'option 2
- **Doublon avec l'historique.** Le skill interdit déjà de recopier ce qui existe ailleurs (commits, PR, spécifications). Une archive ferait doublon avec l'historique git et les descriptions de PR.
- **Prémisses périmées.** Une passation vieillit vite. `CLAUDE.md` traite déjà ses affirmations comme non vérifiées. Les conserver multiplie les prémisses périmées qu'une session future pourrait relire comme si elles étaient vraies.

## Une solution existante à prendre en compte
Le backlog joue déjà une partie de ce rôle. Une session qui s'arrête en cours de tâche réécrit le champ `Next` dans `BACKLOG.md`, et ce fichier est commité. L'état d'avancement survit donc déjà à la fin d'une session. Ce qui manque, c'est le contexte de la conversation : les décisions prises, les pistes écartées. C'est le seul apport de l'option 1.

## Recommandation : l'option 1
Elle répond au vrai problème. En session cloud, la passation ne survit aujourd'hui que si tu télécharges le fichier puis le redonnes à la session suivante. Avec l'option 1, elle voyage avec la branche, et la règle « branche nommée dans une passation → l'utiliser » s'applique telle quelle. Le coût reste borné : deux commits par passation, et la suppression à la reprise empêche les fichiers de s'accumuler.

Le travail se ferait entièrement côté agent, en environ 15 à 25 appels d'outils :
- modifier le skill en version 1.4.0 ;
- mettre à jour `SKILLS.md` ;
- préparer le zip pour claude.ai ;
- relancer le cas P3 de `docs/evidence/dated-notes/`.

Ma recommandation basculerait vers l'option 3 si tu reprends tes passations surtout en local, ou toujours en les fournissant toi-même à la session suivante. La perte en cloud ne se produirait alors jamais en pratique.

**Ta décision :** quelle option choisis-tu ? Par ailleurs, qu'est-ce qui t'avait fait demander `docs/handoffs/` dans la PR #133 ? Je n'en trouve pas la raison dans l'historique git, et elle peut changer la recommandation.

Je ne modifie pas `BACKLOG.md` tant que tu n'as pas choisi.
