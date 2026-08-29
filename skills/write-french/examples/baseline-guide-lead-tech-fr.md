# Méthode de découpage d'un projet de développement logiciel

## 0. Mode d'emploi

### 0.1 Objet

Cette méthode répond à une seule question : **comment transformer une intention floue en un ensemble de morceaux livrables, ordonnés, sans trou ni recouvrement**.

Elle est conçue pour être :

- **générique** — applicable en forfait comme en itératif, sur du neuf comme sur du legacy ;
- **structurante** — chaque étape produit un artefact que la suivante consomme ;
- **vérifiable** — chaque règle porte son niveau de preuve et sa source.

Calibrage de référence : équipe de 1 à 3 développeurs, projets de 2 semaines à 6 mois. Au-delà de ~10 personnes ou d'un an, les niveaux N0/N1 restent valides mais la coordination inter-équipes devient le problème dominant, que cette méthode ne traite pas.

**Limite de généricité, à connaître d'emblée.** Les étapes E2.1 à E2.5 valent quel que soit le cadre contractuel. En revanche E2.6 (priorisation), E2.7 (ordonnancement) et le principe P2.7 (découpage révisable) supposent un périmètre négociable. En forfait à périmètre fixe, ils restent utilisables mais changent de fonction : voir l'encadré « en forfait » de E2.6 et la note de P2.7.

### 0.2 Ce qui est hors périmètre

| Sujet | Où le traiter |
|---|---|
| Estimation de charge, chiffrage, tampons | [[pro/outils/guide-lead-tech/3-estimation-pilotage]] |
| Pilotage quotidien, escalade, réestimation | [[pro/outils/guide-lead-tech/3-estimation-pilotage]] |
| Choix d'architecture, découpage en contextes métier | Conception, pas projet |
| Recueil du besoin, entretiens utilisateurs | Amont produit |

Frontière opérationnelle : **le découpage s'arrête là où l'estimation commence**. Cette méthode produit la liste et l'ordre des morceaux ; elle ne dit pas combien ils coûtent.

Cette frontière n'est pas étanche, et il vaut mieux le dire que le masquer : cinq points du document ont besoin d'un dimensionnement pour fonctionner — E2.5 (contrôle de granularité), §5.2 (grain des lots), E2.6 (plafond en pourcentage d'effort), §6.3 (dénominateur du coût du retard) et §6.6 (passage de relais). Ce qui y est requis est un **ordre de grandeur relatif** : savoir classer les items du plus petit au plus gros, et repérer ceux qui pèsent une part visible du total. Aucun de ces cinq points ne demande un chiffrage en jours ; celui-ci relève de [[pro/outils/guide-lead-tech/3-estimation-pilotage]].

### 0.3 Conventions de preuve

Chaque règle porte une étiquette. Elle indique quoi faire quand un client, un collègue ou toi-même la contestez.

**Une étiquette dit d'où vient la règle, pas si elle oblige.** La force contraignante est portée par la formulation elle-même : « le PMI impose » et « le Scrum Guide décrit une pratique laissée à la main de l'équipe » cohabitent sous `[Standard]` sans contradiction. Lire l'étiquette et le verbe ensemble.

| Étiquette | Sens | Que faire si contesté |
|---|---|---|
| `[Standard]` | Publié par un organisme de référence, vérifié sur la source primaire | Citer la source, elle fait autorité |
| `[Standard*]` | Publié par un organisme de référence, vérifié seulement via des descriptions secondaires convergentes | Citer, mais annoncer la nuance |
| `[Établi]` | Pratique de référence attribuée à un auteur identifié | Discuter sur le fond, pas sur l'autorité |
| `[Heuristique]` | Règle de terrain, sourcée ou non, sans valeur normative | Négociable, à recalibrer par contexte |
| `[Composition]` | Assemblage personnel de plusieurs sources | Assumer que c'est un choix, pas un fait |

**Notation de dérivation.** Une règle dérivée d'un principe hérite de son étiquette et l'indique par `⟵ P2.1`. Quand la dérivation apporte un seuil chiffré que le principe ne contient pas, le seuil porte sa propre étiquette : `⟵ P2.4, seuil [Heuristique]`. Un principe ne cautionne jamais un nombre qu'il ne dit pas.

Ces conventions sont partagées par tout le corpus : voir
[[pro/outils/guide-lead-tech/0-conventions-corpus]] §5. Les sources complètes sont en annexe D.

### 0.4 Comment s'en servir

- **Première lecture** : §1 (principes) puis §3 (procédure). Le reste est de la référence.
- **Découpage réel** : dérouler §3, en piochant dans §4 (patterns) à l'étape E2.4b et dans §5 (contrôles) à l'étape E2.5.
- **Revue d'un découpage existant** : annexe C directement.

---

## 1. Principes invariants

Sept règles qui tiennent quel que soit le cadre de gestion de projet. Tout le reste du document en découle.

### P2.1 — Couverture intégrale `[Standard]`

La somme des morceaux d'un niveau doit représenter exactement 100 % du niveau au-dessus : ni trou, ni élément hors périmètre. La règle s'applique à chaque étage de l'arbre, et couvre tous les livrables, y compris internes et intermédiaires.

*Conséquence pratique* : un arbre de découpage se relit toujours de bas en haut — « ces cinq morceaux, mis bout à bout, font-ils bien tout le lot parent, et rien de plus ? »

### P2.2 — Découper par résultat aux niveaux N0 et N1 `[Standard*]`

Les nœuds qui vont au contrat et à la recette nomment des choses obtenues, pas des actions menées. « Suivi des imports » et non « développer le suivi des imports ». La formulation nominale empêche mécaniquement les recouvrements — deux résultats distincts ne peuvent pas se chevaucher, deux activités si — et rend l'avancement binaire : le résultat existe ou n'existe pas.

**Portée.** Le principe s'arrête à N1. En N2 et N3, la forme verbale est la norme du découpage en items et il n'y a aucune raison de s'en écarter : « Importer un fichier conforme » se lit mieux que « Import d'un fichier conforme », et c'est la forme employée par les patterns du §4.

Ce qui prend le relais en N2, là où la forme nominale ne protège plus :

- contre les recouvrements — les critères d'acceptation, qui bornent explicitement chaque item ;
- contre l'avancement flou — le critère *testable* d'INVEST (§5.1) ;
- contre la tâche technique remontée trop haut — le test de P2.4, « à qui je le montre ».

*Test* `⟵ P2.2` : un nœud N0 ou N1 qui commence par un verbe d'action est mal formulé. En N2, ce test ne s'applique pas ; utiliser celui de P2.4.

### P2.3 — Trancher verticalement `[Établi]`

Un morceau livrable traverse toutes les couches techniques nécessaires à produire son résultat. Il ne correspond ni à une couche (« la base de données »), ni à un composant (« le service d'authentification »).

C'est le point où trois sources indépendantes convergent : le squelette ambulant de Cockburn, les tranches de release de Patton, et le constat de Lawrence qu'un item « insécable » est presque toujours une tâche ou un composant déguisé.

*Conséquence* : les couches horizontales existent dans le code, jamais dans le plan.

### P2.4 — Chaque item porte une valeur démontrable `[Établi]`

Un item de niveau N2 doit pouvoir être montré à quelqu'un qui n'a pas écrit le code, et cette personne doit pouvoir dire si c'est fait. La valeur peut être fonctionnelle (l'utilisateur peut faire X), opérationnelle (l'exploitant voit Y) ou de connaissance (on sait maintenant si Z tient).

*Test* : « à qui je le montre, et qu'est-ce qu'il en dit ? » Pas de réponse = ce n'est pas un item.

### P2.5 — Profondeur variable selon l'horizon `[Standard*]`

Le travail proche se planifie en détail, le lointain à gros grain. C'est la planification par vagues : le niveau de détail est fonction de la distance temporelle, pas de l'importance du sujet.

*Conséquence* : un plan où tout est découpé au même grain dès le premier jour est un plan faux — il affiche une précision que l'information disponible ne permet pas.

*Règle de calibrage* `[Heuristique]` : détail fin (N3) sur l'itération ou le mois en cours, détail moyen (N2) sur le trimestre, gros grain (N1) au-delà.

### P2.6 — Le travail invisible fait partie du périmètre `[Standard]`

La couverture intégrale porte sur tout le travail, y compris ce qui ne se voit pas dans l'interface : chaîne d'intégration, reprise de données, migration, jeux de tests, documentation, recette, mise en production, accompagnement.

*Conséquence* : ces éléments sont des nœuds de l'arbre, pas des « à-côtés ». Un lot « mise en production » qui n'existe nulle part sera fait quand même — hors plan, hors budget, sous pression.

### P2.7 — Le découpage est révisable `[Standard]`

Découper n'est pas un acte initial mais une activité continue : les morceaux se précisent et se subdivisent au fil de l'avancement, à mesure que l'information arrive.

*Conséquence* : un découpage figé au démarrage et jamais retouché est un symptôme, pas une réussite. Prévoir un créneau récurrent de raffinage.

**En forfait.** Le principe reste vrai mais son coût change du tout au tout. Réviser librement suppose un périmètre négociable ; à périmètre fixe, toute révision qui touche le contenu contractuel devient un avenant. La distinction à tenir : subdiviser un lot ou préciser des critères d'acceptation reste du raffinage interne, gratuit et souhaitable ; ajouter, retirer ou déplacer du contenu est un acte contractuel. Écrire cette frontière avant le premier raffinage, pas au premier désaccord.

---

## 2. Modèle pivot à quatre niveaux

`[Composition]` — aucune source ne couvre les quatre niveaux. Les extrémités sont adossées (N0 : cartographie d'impact ; N3 : Scrum Guide) ; les niveaux intermédiaires sont un raccord entre l'arbre de livrables du PMI et la carte narrative de Patton. C'est ce raccord qui rend la méthode utilisable indifféremment en forfait et en itératif.

### 2.1 Les quatre niveaux

| Niveau | Objet | Question de contrôle | Grain indicatif | Durée de vie |
|---|---|---|---|---|
| **N0 — Intention** | Pourquoi, pour qui, quel changement attendu | « Si on livre ça et que le comportement de personne ne change, a-t-on réussi ? » | 1 à 5 objectifs | Tout le projet |
| **N1 — Lot** | Un ensemble livrable et nommable côté client | « Le client sait-il dire ce qu'il obtient ? » | 1 à 3 semaines-équipe `[Heuristique]` | Quelques mois |
| **N2 — Item** | Une tranche verticale démontrable | « À qui je le montre ? » | Quelques jours `[Heuristique]` | Quelques semaines |
| **N3 — Tâche** | Une unité de travail interne | « Quelqu'un peut-il la prendre demain matin ? » | ≤ 1 jour `[Heuristique]` | Quelques jours |

**Sur le repère d'une journée en N3.** Le Scrum Guide 2020 indique que les développeurs décomposent *souvent* les items en unités d'un jour ou moins, et précise que la façon de le faire est laissée à leur seule discrétion. C'est donc une pratique décrite, pas une obligation : le repère est utile parce qu'une tâche de plus d'un jour masque presque toujours une incertitude, mais il ne s'oppose à personne.

**Sur le repère de 8 à 80 heures.** Ce repère classique des arbres de découpage n'est pas retenu ici. Il vient d'un contexte où un lot est porté par une seule ressource ; à deux ou trois développeurs, trois semaines-équipe représentent environ 240 heures et la borne haute perd son sens. Le grain de N1 est donc exprimé en semaines-équipe.

### 2.2 Correspondance forfait ↔ itératif

C'est cette table qui rend le même découpage lisible des deux côtés. Un seul arbre, deux vocabulaires.

| Niveau | Vocabulaire forfait / jalonné | Vocabulaire itératif / flux |
|---|---|---|
| N0 | Objectifs de la note de cadrage | Objectif produit |
| N1 | Lot contractuel, poste de chiffrage | Epic, capacité |
| N2 | Livrable élémentaire, ligne de recette | Item de backlog, story |
| N3 | Tâche de planning | Tâche d'itération |
| — | Tranche + jalon | Incrément, release |
| — | Procès-verbal de recette | Définition de fini (DoD) |
| — | Réunion de suivi | Démonstration |

**Lot et tranche ne sont pas la même chose**, et les confondre est l'erreur de découpage la plus coûteuse :

| | Lot (N1) | Tranche (§6.5) |
|---|---|---|
| Nature | Un **périmètre** | Un **moment** |
| Répond à | « Qu'est-ce que le client obtient ? » | « Qu'est-ce qui est démontrable à cette date ? » |
| Produit par | E2.4 | E2.7c |
| Relation | Un item appartient à un seul lot | Une tranche traverse plusieurs lots |

Une tranche prend quelques items dans plusieurs lots pour former un ensemble montrable ; elle ne remplace jamais les lots. Un découpage qui n'a que des tranches n'a pas de périmètre — il ne peut ni se contractualiser, ni se contrôler en couverture (P2.1).

*Usage* : produire l'arbre une fois, l'exporter dans le vocabulaire du destinataire. Ne jamais maintenir deux découpages parallèles — c'est la source la plus fiable d'incohérence entre le contrat et le backlog.

### 2.3 Règles de passage entre niveaux

| Règle | Énoncé | Preuve | Ce qu'elle détecte |
|---|---|---|---|
| R2.1 | Tout N2 se rattache à exactement un N1 | `⟵ P2.1` | Un N2 à cheval sur deux lots ⇒ les lots ne sont pas disjoints |
| R2.2 | Tout N1 sert au moins un N0 | `⟵ P2.1` | Un lot qui ne sert aucun objectif ⇒ hors périmètre, ou objectif non écrit |
| R2.3 | Un N3 n'apparaît jamais au contrat ni à la recette | `⟵ P2.2` | Une tâche technique promue en livrable ⇒ voir anti-pattern A2.4 |
| R2.4 | Le grain descend avec l'horizon | `⟵ P2.5` | Un arbre uniformément fin ⇒ fausse précision |
| R2.5 | Un lot n'est subdivisé en items qu'une fois son critère d'acceptation écrit | `[Heuristique]` | Un lot sans critère ⇒ le découpage se fera sur des suppositions |

R2.5 s'applique **à l'intérieur de E2.4**, qui produit les deux niveaux : elle fixe l'ordre entre la constitution des lots et leur subdivision, pas une condition entre deux étapes.
