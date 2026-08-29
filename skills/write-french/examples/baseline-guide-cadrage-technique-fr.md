# Cadrage technique d'un périmètre de développement

## 0. Mode d'emploi

### 0.1 Objet

Ce guide répond à une seule question : **que faut-il savoir, et que faut-il décider, avant de pouvoir découper ?**

Il est conçu pour être :

- **borné** — le cadrage a une fin, et le guide dit à quoi on la reconnaît ;
- **structurant** — chaque étape produit un artefact que la suivante, ou le découpage, consomme ;
- **vérifiable** — chaque règle porte son niveau de preuve et sa source.

Calibrage de référence : 1 à 3 développeurs juniors, périmètres de 2 semaines à 6 mois, **forfait ferme** (prix, périmètre et date engagés ; tout ajout passe par avenant). Un chef de projet arbitre délai et périmètre.

**Fait déterminant, dont tout le reste découle.** Le cadrage technique intervient **après l'engagement commercial**. Le périmètre est déjà vendu quand le responsable technique arrive. Le cadrage n'est donc pas une phase de conception préalable à la décision commerciale : c'est la première confrontation entre ce qui a été vendu et ce qui existe. Le cas où cette confrontation révèle une incohérence n'est pas un accident — c'est un cas de première importance, traité au §6 et présent dans la procédure du §3.

**Limite de généricité, à connaître d'emblée.** Les §1 à §5 valent quel que soit le cadre contractuel. Le §6 suppose que le périmètre est déjà engagé : si le responsable technique intervient *avant* la vente, ce qu'il produit devient une entrée de l'offre et non un écart à remonter. La procédure ne change pas, son destinataire si.

### 0.2 Ce qui est hors périmètre

| Sujet | Où le traiter |
|---|---|
| Découpage en lots, items, tâches ; ordonnancement | [[pro/outils/guide-lead-tech/2-decoupage-projet]] |
| Chiffrage, timebox de découverte, pilotage quotidien | [[pro/outils/guide-lead-tech/3-estimation-pilotage]] |
| Qui fait quoi, délégation | [[pro/outils/guide-lead-tech/4-conduite-equipe]] |
| Définition de fini, revue, registre de dette | [[pro/outils/guide-lead-tech/5-qualite-revue]] |
| Quand et à qui remonter, escalade | [[pro/outils/guide-lead-tech/6-reporting-alerte]] |
| Conception détaillée, diagrammes de classes, schémas de données | Conception, pas cadrage |
| Recueil du besoin, entretiens utilisateurs | Amont produit — voir E1.1, *vérification* du besoin |
| Chiffrage commercial, avant-vente | Hors corpus |

Frontière opérationnelle : **le cadrage s'arrête là où le découpage commence.** Il ne produit ni liste de morceaux ni ordre ; il produit ce sans quoi cette liste serait fausse.

Cette frontière n'est pas étanche dans l'autre sens non plus : [[pro/outils/guide-lead-tech/2-decoupage-projet]] E2.1 écrit les objectifs et le hors-périmètre, E2.3 liste les inconnues. Le cadrage alimente ces deux étapes sans les faire (§5.4).

### 0.3 Conventions de preuve

Conventions partagées par tout le corpus, voir [[pro/outils/guide-lead-tech/0-conventions-corpus]] §5. Rappel du barème : `[Standard]`, `[Standard*]`, `[Établi]`, `[Heuristique]`, `[Composition]`. Une étiquette dit d'où vient la règle, pas si elle oblige. Les sources complètes sont en annexe E.

**À annoncer d'emblée : ce guide porte peu de `[Standard]`.** Il existe une norme de la *description* d'architecture (ISO/IEC/IEEE 42010) mais elle ne contient aucune méthode de cadrage et ne peut donc en cautionner aucune. Le reste s'appuie sur des auteurs identifiés — Nygard, Brown, Fowler, Klein, Cockburn, Fairbanks, Poppendieck — et sur des compositions assumées.

**En particulier, la règle de frontière du §1 (P1.1) et son contrôle (§5.1) sont une `[Composition]`.** Elles ont été construites par élimination de trois autres formulations, puis confrontées aux sources au moment de la rédaction. Résultat de ce dépouillement, annoncé ici parce qu'il change la façon de défendre la règle :

- **aucune source trouvée ne propose de frontière incompatible** ; la question « qu'est-ce qui entre dans le cadrage » est, dans la littérature, peu traitée en tant que telle ;
- **la *forme* de la règle — définir ce qui compte par son effet, pas par une liste — est, elle, adossée.** Nygard réserve l'enregistrement aux décisions qui ont un effet sur la suite du projet ; la littérature sur les exigences architecturalement significatives les définit par leur effet mesurable sur l'architecture ; Fowler définit l'architecture par ce qui est perçu comme difficile à changer. Trois sources indépendantes, trois définitions par l'effet ;
- **le triplet retenu ici — découpage, estimation, irréversibilité — n'est adossé à rien.** Les deux premiers effets sont de nature projet et n'apparaissent dans aucune des sources architecturales dépouillées. C'est un choix, pas un fait ;
- une quatrième formulation mérite d'être connue parce qu'elle répond à une question voisine : Fairbanks fait dépendre l'effort de conception amont du **risque**. Elle ne dit pas *quoi* cadrer mais *combien*, et elle est reprise ici en P1.5.

Conséquence pratique : si quelqu'un conteste P1.1, ne pas citer d'autorité. Défendre par le contrôle §5.1, qui rend la règle opposable sans source.

### 0.4 Comment s'en servir

- **Première lecture** : §1 (principes) puis §3 (procédure). Le reste est de la référence.
- **Cadrage réel** : dérouler §3, en piochant dans §4 (instruments) et en contrôlant au §5.
- **Cadrage qui dérape ou qui n'en finit pas** : §5.1, puis P1.5.
- **Découverte d'une incohérence dans ce qui a été vendu** : §6 directement.
- **Revue d'un cadrage existant** : annexe D.

---

## 1. Principes invariants

Sept règles. Tout le reste du document en découle.

### P1.1 — Ce qui entre au cadrage se reconnaît à son effet `[Composition]`

Entre au cadrage ce qui **change le découpage**, **change l'estimation**, ou **crée une irréversibilité**. Tout le reste se décide en chemin.

Trois effets, un seul suffit :

| Effet | Question de reconnaissance |
|---|---|
| Découpage | Si on tranche autrement, l'arbre des lots change-t-il ? |
| Estimation | Si on tranche autrement, l'ordre de grandeur change-t-il ? |
| Irréversibilité | Si on se trompe, que faut-il défaire, et qui doit revalider ? |

*Conséquence, et c'est la moitié utile du principe* : une décision technique réelle, discutable, intéressante, mais sans aucun de ces trois effets, **ne se prend pas au cadrage**. Elle se prend au moment de coder, par celui qui code. Le cadrage qui n'en finit pas est presque toujours un cadrage qui a admis ces décisions-là.

*Ce que la règle n'est pas* : une frontière par niveau d'abstraction. Il n'est pas vrai que le contexte et les conteneurs relèvent du cadrage et les composants de la conception. Sur une refonte, une décision de niveau composant peut être la plus structurante de toutes (§7). C'est l'effet qui décide, jamais l'étage.

*Preuve, en toutes lettres* : voir §0.3. La forme de la règle est adossée, le triplet ne l'est pas.

### P1.2 — Un artefact de cadrage tranche une question nommée, ou n'existe pas `[Composition]` `⟵ P1.1`

Pour chaque document, schéma, tableau ou note produit pendant le cadrage, on doit pouvoir nommer la question de découpage, d'estimation ou d'irréversibilité qu'il tranche. Aucune question nommée : l'artefact sort.

C'est P1.1 rendu opposable. Sans ce contrôle, P1.1 est une intention ; avec lui, c'est une règle qu'on peut appliquer à un artefact précis, devant quelqu'un, sans discuter de principes.

*Test* : « ce schéma, il sert à décider quoi ? » Si la réponse est « à comprendre », c'est un instrument de travail personnel — légitime, mais il ne va pas dans les livrables de cadrage et il ne consomme pas de budget.

### P1.3 — L'état de connaissance coûte plus cher que le niveau d'abstraction `[Composition]`

Se tromper de niveau d'abstraction coûte un redessin. Croire **su** ce qui est **supposé** coûte une décision irréversible prise sur du sable.

*Conséquence* : le pivot du guide (§2) croise les deux, mais c'est l'axe de l'état de connaissance qui commande les priorités. Le danger n'est pas ce qu'on ignore — c'est ce qu'on croit savoir.

### P1.4 — Le coût d'une décision se mesure à sa réversibilité, pas à sa taille `[Établi]`

Fowler, reprenant Johnson, définit l'architecture comme ce que les développeurs perçoivent comme difficile à changer — et non comme ce qui est gros, central ou visible. Ce qui devient facile à changer sort de l'architecture.

Trois conséquences, dans cet ordre :

1. Une décision **réversible** se prend vite, même mal informée. L'erreur coûte le temps de la refaire.
2. Une décision **irréversible** justifie d'investir avant de trancher : c'est là que va le budget de découverte.
3. **Rendre une décision réversible est un troisième choix**, souvent meilleur que les deux autres. Isoler la dépendance derrière un contrat, versionner le format d'échange, garder les deux chemins un temps : la décision cesse d'être architecturale et n'a plus à être prise au cadrage.

*Piège* : confondre irréversible et important. Le choix du framework de tests est important et réversible. Le format d'un fichier déjà échangé avec un tiers est mineur et irréversible.

### P1.5 — Le cadrage est borné par le risque, pas par l'exhaustivité `[Établi]`

L'effort de cadrage se règle sur le risque encouru, pas sur la taille du système : pas de conception méticuleuse là où le risque est faible, aucune excuse pour bâcler là où il menace le résultat. C'est le modèle piloté par le risque de Fairbanks — identifier et classer les risques, appliquer les techniques correspondantes, évaluer ce qui a été réduit.

*Conséquence* : un cadrage complet sur un périmètre sans risque est du gaspillage exactement au même titre qu'un cadrage bâclé sur un périmètre risqué. Les deux sont des erreurs de dosage, et la première est la plus fréquente chez qui vient de la recherche.

*Conséquence de méthode* : le cadrage est timeboxé. La timebox appartient à [[pro/outils/guide-lead-tech/3-estimation-pilotage]] §3 ; le cadrage y ajoute un second critère de sortie (§3, phase A).

### P1.6 — On décide au dernier moment responsable, et pas plus tard `[Établi]`

Le dernier moment responsable est celui où ne pas décider élimine une option qui comptait. Passé ce point, la décision se prend toute seule, par défaut — et personne ne l'a choisie.

*Combiné à P1.4* : les décisions réversibles se reportent volontiers, les irréversibles s'anticipent. Reporter n'est pas ne pas décider : une décision reportée porte une date et une condition de déclenchement, écrites (E1.5).

*Piège* : le report comme évitement. « On verra plus tard » sans date est une décision prise par défaut, avec le maximum d'inconvénients et aucun avantage.

### P1.7 — Le périmètre vendu est une donnée d'entrée, pas une vérité `[Heuristique]`

Le responsable technique reçoit un périmètre engagé. Sa fonction n'est ni de le valider ni de le contester : c'est d'en éprouver la cohérence assez tôt pour que l'écart reste arbitrable par celui dont c'est le rôle.

*Conséquence* : un écart constaté au cadrage est une information à haute valeur — la fenêtre d'arbitrage est encore ouverte. Le même écart constaté à mi-parcours n'est plus qu'un retard. Ce qui se joue au cadrage, ce n'est pas la qualité de l'analyse, c'est la **date à laquelle on sait**.

*Piège, et c'est le mode de défaillance normal du forfait ferme* : absorber l'écart en silence, en se disant qu'on le rattrapera. Voir [[pro/outils/guide-lead-tech/3-estimation-pilotage]] §7.2 et le §6 de ce guide.

---

## 2. Modèle pivot — la grille connaissance × structure

`[Composition]`. Aucune source ne publie cette grille. L'axe vertical est emprunté au modèle C4 de Simon Brown `[Établi]`, qui fournit ici un **système de coordonnées** et rien d'autre : il ne commande ni le vocabulaire ni la procédure ([[pro/outils/guide-lead-tech/0-conventions-corpus]] §4). L'axe horizontal et la pondération sont composés.

### 2.1 Les deux axes

**Axe vertical — les quatre niveaux du modèle C4**, du plus englobant au plus fin. Il sert à garantir qu'on a balayé toute la structure, et à situer chaque assertion sans discuter de vocabulaire.

| Niveau | Ce qu'on y range |
|---|---|
| **Contexte** | Le système, ses acteurs, les systèmes tiers avec lesquels il échange |
| **Conteneurs** | Les unités qui tournent et se déploient séparément : services, applications, bases |
| **Composants** | À l'intérieur d'un conteneur, les regroupements de fonctionnalité qui ne se déploient pas séparément |
| **Code** | Classes, fonctions, structures de données |

**La grille impose de balayer les quatre niveaux, composant compris.** C'est cohérent avec P1.1 : ce n'est pas l'étage qui décide de l'entrée au cadrage, c'est l'effet. Le niveau code n'y produit presque jamais d'assertion structurante — presque, pas jamais : une signature échangée avec un tiers, un format sérialisé et persisté, s'y logent et sont irréversibles.

**Axe horizontal — l'état de connaissance de chaque assertion.** Trois états, et un seul test pour les distinguer.

| État | Définition | Test |
|---|---|---|
| **Su** | Vérifié sur une source qu'on peut citer : le code, une mesure, un document contractuel | « Où l'ai-je vérifié, et quand ? » |
| **Supposé** | Plausible, cohérent, non vérifié | Même question, réponse du type « c'est comme ça d'habitude » ou « on me l'a dit » |
