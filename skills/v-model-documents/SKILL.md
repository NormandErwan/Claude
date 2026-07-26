---
name: v-model-documents
version: 2.0.0
description: >
  Nomenclature documentaire du modèle en V : où ranger un document, comment le
  nommer, comment le référencer depuis un autre document. Déclencher à chaque
  création, renommage ou déplacement d'un fichier de documentation, quand on
  cherche où vit un artefact, quand on écrit un lien entre deux documents, ou
  quand on reprend un dépôt dont la documentation ne suit pas la grille.
  Complément obligatoire de tous les autres skills v-model.
---

# Nomenclature documentaire

## Contexte

Un document qu'on ne sait pas nommer est un document qu'on ne retrouvera pas.
Ce skill fixe **trois choses et seulement trois** : la durée de vie d'un
document, sa place dans la grille, et la façon de le référencer.

**Input :** un artefact à produire, quel que soit son niveau du V.
**Output :** un chemin et un nom de fichier, ou la décision de ne pas
committer le document.

---

## 1. Trois sous-familles -- l'axe de classement est la durée de vie

Avant de nommer un document, décider à quelle sous-famille il appartient.
La sous-famille détermine la forme du fichier, pas seulement son emplacement.

| Sous-famille | Exemples | Forme dans le dépôt |
|---|---|---|
| Permanent | EBO, SRD, SRS, HLD, LLD, ADR, registres, plan de projet, DoR / DoD | Fichier versionné, mis sous baseline à chaque jalon |
| Vivant -- état courant | backlog, dette technique, tableau de bord | Fichier unique **écrasé** à chaque mise à jour, **jamais** mis sous baseline. L'historique est dans git, pas dans le nom |
| Vivant -- instantané daté | rapport d'avancement, audit, compte-rendu de jalon | Un fichier par occurrence, **jamais modifié** après écriture |
| Document de travail | plan d'implémentation, note d'analyse, checklist de migration | **Hors dépôt.** Vit dans le corps de la PR ou de l'issue |

### Règle 3 -- le document de travail ne se committe pas

Les plans produits par les skills d'agent (`writing-plans`, `brainstorming`)
ne vont pas dans la documentation du projet. Motif : un répertoire de travail
versionné devient un cimetière que personne ne nettoie, et un lecteur ne
distingue plus le plan abandonné du document de référence.

À la fusion de la PR, le document de travail est **promu** ou **disparaît** :

| Ce que contient le document de travail | Promotion à la fusion |
|---|---|
| Une décision d'architecture actée | Un ADR |
| Une décision de gestion actée | Une entrée du registre des décisions |
| Un constat daté (audit, revue, mesure) | Un instantané daté |
| Rien de durable | Rien. Il disparaît avec la PR |

**Corollaire :** un instantané daté n'est jamais corrigé après coup. Une erreur
dans un rapport d'avancement se corrige dans le rapport **suivant**, qui cite
l'erreur. Réécrire l'histoire supprime la seule valeur de l'instantané.

---

## 2. Grille de référence

```
docs/README.md                          (hors grille)

000-upstream/
  010-ebo.md
  020-feasibility.md
  030-business-case.md
  040-project-charter.md
  050-user-journeys.md
100-system-requirements/
  110-upstream-traceability.md
  120-srd.md
200-software-requirements/
  210-system-requirements-traceability.md
  220-srs.md
300-architecture/
  310-software-requirements-traceability.md
  320-hld.md
  331-adr-<topic>.md         (jusqu'a 399 : 69 emplacements)
400-detailed-design/
  410-architecture-traceability.md
  411-lld-<composant>.md     (jusqu'a 499 : 89 emplacements)
500-tests/
  510-requirements-traceability.md
  520-unit.md
  530-integration.md
  540-acceptance.md
  550-system-validation.md
600-management/
  610-project-plan.md
  620-risk-register.md
  630-decision-register.md
  640-change-requests.md
  650-baselines.md
  660-review-milestones.md
700-conventions/
  710-definition-of-ready.md
  720-definition-of-done.md
  730-code-review.md
800-status/
  810-backlog.md
  820-technical-debt.md
  830-dashboard.md
  2026-07-24-progress.md
  2026-07-26-audit-<portee>.md
  2026-08-15-milestone-cdr.md
```

### Ce que la grille impose

- **Préfixe numérique à trois chiffres sur tous les répertoires et tous les
  fichiers.** Le premier chiffre d'un fichier est celui de son répertoire.
- **Unicité globale.** Jamais deux fois le même numéro dans toute la
  documentation, même dans deux répertoires différents. Un numéro identifie un
  document, pas une position dans un dossier.
- **Un seul niveau de répertoire.** Pas de sous-dossier par thème ni par
  entité : deux niveaux cassent le tri et rendent les chemins relatifs fragiles.
- **Chemins et noms de fichiers en anglais ASCII.** La prose des documents
  reste en français.
- **Les tests ont leur répertoire propre**, pas un miroir par niveau du V.
  L'ordre des procédures suit l'ordre d'exécution : unitaires, intégration,
  acceptance, validation système.

### Matrices de traçabilité

Une matrice est le **premier document du niveau cible** et porte le nom du
**niveau source**, qui est le niveau parent adjacent. On la range donc chez
celui qui doit prouver sa couverture, pas chez celui qui est couvert.

**Exception -- les tests.** Le niveau des tests est le seul à sources
multiples (SRD, SRS, HLD, LLD) : « nom = niveau source » n'y désigne aucun
parent unique. Il porte donc **une matrice unique** couvrant toutes les
exigences, quel que soit leur niveau d'origine, avec une colonne de niveau.

### Instantanés datés -- seule exemption à la grille

Le répertoire d'état accepte des fichiers préfixés `YYYY-MM-DD-` sans numéro
de grille. Motif : ces fichiers ne sont pas bornés en nombre (un par semaine
pendant des années) alors qu'un bloc de centaine offre environ 90 numéros, et
la date joue déjà le rôle de clé de tri unique.

Les fichiers d'état courant du même répertoire restent numérotés : ils sont
bornés, il y en a un de chaque et un seul.

`docs/README.md` est également hors grille : GitHub n'affiche en page d'accueil
d'un répertoire qu'un fichier nommé exactement `README.md`.

### Petit projet

La grille s'applique intégralement, mais **les fichiers absents ne sont pas
créés à vide**. Un fichier vide « pour respecter la grille » est un mensonge :
le lecteur croit que l'artefact existe.

Fusionner deux documents est autorisé (business case et charte, HLD et LLD,
SRD et SRS). **Le numéro conservé est celui du document survivant** -- celui
dont le titre décrit le contenu fusionné.

---

## 3. Règles de nommage

**R1 -- minuscules et tirets, systématiquement.** Les identifiants gardent leur
casse canonique dans la prose (`SYS-F-001`, `DCL-001`), jamais dans un nom de
fichier. Motif : macOS et Windows ont des systèmes de fichiers insensibles à la
casse, deux noms qui ne diffèrent que par la casse s'écrasent silencieusement.

**R2 -- préfixe numérique par pas de 10 dans un bloc de centaine.** Les pas
libres absorbent les insertions sans renumérotation. Un document inséré entre
deux voisins prend le numéro intermédiaire.

**R3 -- préfixe de type quand le répertoire contient un artefact par entité.**
Deux répertoires sont dans ce cas : l'architecture (un fichier par décision) et
la conception détaillée (un fichier par composant). Le préfixe de type rend le
répertoire lisible sans ouvrir les fichiers.

### Le nom du fichier est son identifiant

Il n'existe **aucun identifiant de document en dehors de son nom de fichier**.
Un ADR n'a pas de numéro propre, un LLD n'a pas de code composant : le numéro
de grille est le seul identifiant, et il est déjà dans le chemin.

Toute référence à un document se fait en **lien markdown relatif**, libellé par
le nom de fichier sans extension :

```markdown
[331-adr-event-sourcing](../300-architecture/331-adr-event-sourcing.md)
```

**Relatif, jamais absolu.** Un lien commençant par une barre oblique est résolu
depuis la racine du dépôt : il casse dans un clone hors GitHub, et il est
faux dès que le projet n'est pas à la racine du dépôt (monorepo). La
documentation GitHub recommande explicitement les liens relatifs.

### Les identifiants qui ne sont pas des fichiers sont des ancres

Exigences, contraintes, hypothèses, décisions de gestion, demandes d'évolution,
risques : ces identifiants désignent des **sections**, pas des fichiers. Leur
titre markdown est **l'identifiant seul**, l'énoncé passe en dessous.

```markdown
### SYS-F-001

Le système doit [verbe observable] [complément].

**Origine EBO :** ...
```

Motif : l'ancre générée est `#sys-f-001`, stable même si l'énoncé est
reformulé. Un titre `### SYS-F-001 : le système doit ...` produit une ancre
qui contient l'énoncé et casse tous les liens entrants à la première
reformulation.

---

## 4. Page d'accueil de la documentation

Un nouveau contributeur doit pouvoir se repérer sans demander. La page
d'accueil donne un ordre de lecture et une carte des artefacts -- pas une
duplication de la grille.

**Template :**

```markdown
# Documentation -- [nom du projet]

## Ordre de lecture

1. Pourquoi ce projet existe : EBO, business case, charte
2. Ce que le systeme doit faire : SRD
3. Ce que le logiciel prend en charge : SRS
4. Comment c'est structure : HLD et ADR
5. Comment chaque composant est specifie : LLD
6. Comment on le verifie : procedures de test
7. Ou en est le projet : tableau de bord et dernier rapport d'avancement

## Carte des artefacts

| Artefact | Chemin | Proprietaire | Statut |
|---|---|---|---|
| EBO | 000-upstream/010-ebo.md | Analyste | Baseline SRR |
| SRD | 100-system-requirements/120-srd.md | Analyste | Baseline SRR |
| SRS | 200-software-requirements/220-srs.md | Analyste | Baseline SFR |
| HLD | 300-architecture/320-hld.md | Architecte | Baseline PDR |
| LLD | 400-detailed-design/ | Architecte | Baseline CDR |
| Tests | 500-tests/ | Testeur | En cours |
| Gestion | 600-management/ | Chef de projet | Vivant |
| Backlog | 800-status/810-backlog.md | Responsable produit | Vivant, hors baseline |
```

**Colonne Statut :** pour un document permanent, le jalon de sa dernière
baseline. Pour un document vivant, la mention `Vivant, hors baseline`. Un
document permanent sans baseline n'a pas encore passé de porte de validation.

---

## 5. Porte de nommage

**Déclencheur :** avant de créer, renommer ou déplacer un fichier de
documentation. À exécuter avant l'écriture du contenu, pas après.

**Checklist, dans l'ordre :**

1. **Sous-famille identifiée** -- permanent, état courant, ou instantané daté.
   Si c'est un document de travail : ne pas créer le fichier. Le contenu va
   dans la PR.
2. **Répertoire** -- celui du niveau du V ou de la famille correspondante.
   Aucun sous-répertoire créé.
3. **Préfixe** -- trois chiffres, premier chiffre égal à celui du répertoire.
   Pas de 10 pour un document unique, incrément de 1 dans un bloc par entité.
   Un instantané daté porte la date à la place du préfixe.
4. **Unicité globale** -- le numéro n'existe nulle part ailleurs dans la
   documentation.
5. **Forme du nom** -- minuscules, tirets, ASCII, anglais, extension `.md`.
   Préfixe de type présent si le répertoire contient un artefact par entité.
6. **Liens** -- toute référence entrante ou sortante est un lien relatif
   libellé par le nom de fichier sans extension.

**Sortie obligatoire si conforme :**

```
Porte nommage : OK (N fichiers vérifiés)
```

**Sortie obligatoire si écart -- une ligne par fichier :**

```
<chemin proposé> : <règle violée> -> <chemin corrigé>
```

Sans cette sortie écrite, la vérification n'a pas eu lieu.

---

## 6. Reprise d'un dépôt existant

Une documentation déjà écrite se réaligne en **une PR dédiée**, jamais mélangée
à un changement de contenu.

1. **Renommer avec `git mv`**, pour que l'historique de chaque fichier suive.
2. **Aucune modification de contenu dans cette PR**, sauf les liens. Un diff
   qui mêle renommage et réécriture est illisible et ne sera pas revu.
3. **Mettre à jour tous les liens entrants.** Chercher l'ancien nom dans toute
   la documentation et dans le code (les README de modules pointent souvent
   vers la conception détaillée). Résultat attendu : zéro occurrence.
4. **Exécuter la porte de nommage** sur l'intégralité de la documentation, pas
   seulement sur les fichiers touchés -- c'est l'occasion de détecter les
   numéros en collision.
5. **Exécuter la porte de cohérence** de `v-model-gestion` avant de committer.
6. **Tracer le renommage** dans le registre des décisions. Les baselines
   antérieures désignent des chemins historiques : elles restent valides et ne
   sont pas réécrites.

---

## Anti-patterns fréquents

- Un répertoire de travail versionné (`docs/99-wip/`, `docs/notes/`) : personne
  ne le nettoie, et il devient impossible de distinguer un plan abandonné d'un
  document de référence.
- Le numéro de version dans le nom du fichier (`backlog-v3-final.md`) : c'est
  le travail de git. La suite inévitable est `backlog-v3-final-2.md`.
- Une matrice de traçabilité rangée sous son niveau source : elle appartient au
  niveau qui doit prouver sa couverture, pas à celui qui est couvert.
- Un instantané daté corrigé après coup : il ne vaut plus rien comme trace. La
  correction va dans l'instantané suivant.
- Un identifiant de document en double du nom de fichier (un ADR numéroté à
  part) : deux identifiants pour un objet, donc deux occasions de diverger.
- Un lien absolu vers la documentation : cassé dans un clone, faux dans un
  monorepo.
- Un titre de section qui contient l'énoncé en plus de l'identifiant : l'ancre
  casse à la première reformulation, silencieusement.
- Deux documents portant le même numéro dans deux répertoires différents :
  le numéro ne désigne plus rien.
- Un fichier créé vide pour « respecter la grille » : le lecteur croit que
  l'artefact existe.
- Un sous-répertoire par thème pour « ranger » un répertoire qui grossit :
  la grille prévoit assez de numéros, le tri à plat reste lisible.
