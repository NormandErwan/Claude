# Changelog -- suite v-model

## [2.0.0] -- 2026-07-26

Nomenclature documentaire — rupture. Nouveau skill `v-model-documents`, onzième de la suite : classement des documents par durée de vie (permanent, état courant écrasé, instantané daté immuable, document de travail hors dépôt), grille de référence à préfixe numérique unique sur trois chiffres pour tous les répertoires et tous les fichiers, règles de nommage (minuscules-tiret, pas de 10, préfixe de type), porte de nommage à sortie écrite obligatoire, et procédure de reprise d'un dépôt existant. Les dix skills existants sont réalignés sur cette grille : tous les chemins documentaires changent, à commencer par la contradiction `docs/amont/` contre `docs/00-amont/` qui devient `000-upstream/`. Seconde rupture : un ADR n'a plus d'identifiant propre, `ADR-NNN` est supprimé du vocabulaire — le nom de fichier de grille est le seul identifiant d'un document, et toute référence se fait en lien markdown relatif. Les identifiants qui désignent des sections (SYS-*, SW-*, HLD-T-*) passent en titre seul avec l'énoncé en dessous, pour que l'ancre survive à une reformulation ; six titres markdown malformés sont corrigés au passage. Le guide gagne une entrée de routage vers le nouveau skill, v-model-gestion une étape 0 de porte de nommage dans sa porte de cohérence et l'interdiction de mettre le répertoire d'état sous baseline, v-model-niveau-3 une matrice de traçabilité SRS vers architecture.

## [1.4.0] -- 2026-06-26

Propagation ADR→LLD : v-model-guide gagne une vérification préalable aux 5 lentilles — détection des ADRs datés après les LLDs qu'ils impactent, puis liste explicite des LLDs que le §Conséquences de chaque ADR candidat impose de mettre à jour, avec sortie structurée obligatoire (une ligne par ADR candidat ou mention « RAS »). Surface les écarts de propagation avant la revue critique plutôt que pendant.

## [1.3.0] -- 2026-06-21

Porte de coherence propagation : v-model-gestion gagne §8 (trigger commit ≥2 docs, 4 points : identifiants renommes, contrats d'interface, noms entre niveaux de conception, tracabilite des exigences) — generalisee pour tout projet, pas de references aux fichiers du projet d'origine. Skill retrospective ajoute dans CLAUDE.md (6 codes F1-F6, trigger binaire, format de sortie normalise). Bootstrap CLAUDE.md : recherche proactive de skills via `npx skills find` avant toute declaration d'absence.

## [1.2.1] -- 2026-06-15

Corrections orthographiques et diacritiques : correction systématique des accents manquants et des fautes de français dans tous les 10 skills v-model (à/a, é/e, è/e, ç/c, ô/o, etc.). Tous les skills v-model passent à la version 1.2.1 selon la règle de versionnage en bloc.

## [1.2.0] -- 2026-06-14

Parcours utilisateur : v-model-phase-amont gagne §5 (template, arborescence, gate, anti-patterns, minimum viable) ; v-model-niveau-1 fait de l'audit EBO un exercice parcours-first, ajoute le champ Parcours source dans §2 et reformate §7 en matrice EBO→Parcours→SYS ; v-model-tests §4 gagne la règle de dérivation depuis les parcours, un champ Parcours source dans le Scénario TVS et un template de génération TVS. Règle de versionnage introduite : tous les skills v-model évoluent ensemble.

## [1.1.0] -- 2026-06-13

Patchs Q3 -- remontee multi-niveaux : v-model-implementation gagne une section 'Si le defaut remet en cause un niveau superieur' declenchant un CR interne ; v-model-gestion §5 s'ouvre au declencheur interne (Demandeur = equipe technique) et renvoie vers v-model-implementation. Regle : corriger du haut vers le bas.

## [1.0.0] -- 2026-06-13

Premiere version formellement baselinee de la suite v-model (10 skills). Historique anterieur (pre-1.0, non versionne) : campagne 1 -- correctifs d'usage reel (porte de revue critique, audit vocabulaire-solution EBO, matrice de tracabilite, anti-patterns de verifiabilite) ; campagne 2 -- francisation diacritique ; campagne 3 -- reformatage des templates en markdown interne + sed-as-anti-pattern.

