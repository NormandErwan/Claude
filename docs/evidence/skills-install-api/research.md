# Installer des skills au démarrage de session, plus vite et plus sûrement

Date : 2026-11-03. Sources primaires : code du paquet npm `skills` 1.7.6 (lu dans `dist/cli.mjs`), documentation Claude Code, mesures faites dans ce conteneur. Les mentions « non vérifié » signalent ce que je n'ai pas testé.

## 1. Pourquoi `npx skills add` est lent ici

Lu dans le code de `skills` 1.7.6 ([npm](https://www.npmjs.com/package/skills)) :

- **Voie rapide réservée à 4 propriétaires.** Pour `vercel`, `vercel-labs`, `heygen-com` et `remotion-dev`, le CLI évite `git clone` : il lit l'arbre du dépôt via `api.github.com`, puis les fichiers via `raw.githubusercontent.com`, puis un instantané de chaque skill chez `https://skills.sh/api/download/<owner>/<repo>/<skill>`. Les autres dépôts (les vôtres) passent toujours par `git clone --depth 1`, sans `--filter` ni `--sparse`. Donc le dépôt entier est téléchargé (caveman : 35 Mo pour un skill de 8 Ko).
- **Variables d'environnement non documentées** : `SKILLS_CLONE_TIMEOUT_MS` (défaut 300 000 ms), `SKILLS_CLONE_CONCURRENCY` (défaut 4, utilisé pour les mises à jour), `SKILLS_DOWNLOAD_URL` (remplace la base `https://skills.sh`), `GITHUB_TOKEN`/`GH_TOKEN`. Aucun réglage de profondeur, de cache ni de mode hors ligne.
- Votre plafond de 45 s tue donc un clone que le CLI laisserait tourner 300 s.
- **Restauration depuis un verrou** (`experimental_install`, `skills-lock.json`) : elle refait les mêmes clones ([docs/commands.md](https://github.com/vercel-labs/skills/blob/main/docs/commands.md)). Aucun gain de vitesse.
- **Sources de type « archive »** : une URL `github.com/<o>/<r>/archive/...`, `releases/download/...` ou `raw.githubusercontent.com/...` est téléchargée comme archive. Mais `codeload` et `github.com/.../archive` renvoient 403 ici (mesuré), pour les dépôts non rattachés à la session.

## 2. Options

### A. API `skills.sh` appelée directement avec `curl` (recommandée en premier)

- **Mesure** : `https://skills.sh/api/download/<owner>/<repo>/<skill>` répond 200 pour les 5 dépôts de `skills.txt` (0,3 à 1,4 s chacun ; casebook `write-skill` : 312 Ko en 1,4 s). Les 24 skills de `addyosmani/agent-skills`, en 24 appels parallèles : 2,0 s au total, 24 réponses 200. Comparaison avec `raw.githubusercontent.com` pour `test-driven-development` : `SKILL.md` identique à `main`.
- **Format** : JSON `{"files":[{"path","contents"}...],"hash"}`. À écrire dans `skills/<nom>/<path>` avec `python3 -I` ou `jq`. Texte seulement : un fichier binaire serait à vérifier (non vérifié).
- **Coût** : environ 30 lignes dans le hook. Pas de `npx`, donc plus de téléchargement de paquet non plus.
- **Risques** :
  1. L'API n'est pas documentée : je l'ai lue dans le code du CLI, pas dans une doc. Elle peut changer.
  2. Instantané parfois en retard sur le dépôt : [issue #2626](https://github.com/vercel-labs/skills/issues/2626) (SKILL.md modifié le 31 oct., page toujours ancienne ; résolu le 1er nov. sans explication), voir aussi #2516 et #2600.
  3. Dépendance à un service tiers (Vercel). Si une skill n'est pas indexée, la réponse n'est pas 200 : non testé.
  4. Les fichiers hors du dossier de la skill (les `references/` d'addyosmani) ne sont pas inclus, comme avec le CLI.
- **Repli** : si un appel échoue, relancer l'ancien `npx skills add` pour ce seul dépôt.

### B. `references/` d'addyosmani via `raw.githubusercontent.com`

- **Mesure** : `raw` répond en 0,1 à 0,4 s (README de agent-skills et de caveman : 200). `api.github.com` répond 403 (dépôt non rattaché à la session) : impossible de lister un dossier.
- **Méthode** : extraire des `SKILL.md` téléchargés (option A) les chemins `references/*.md` (10 trouvés), puis les récupérer un par un. Résultat : 7 réponses 200, 3 réponses 404 (`floor-guard.md`, `hardening-patterns.md`, `optimization-patterns.md`) : liens morts amont ou dossiers différents (cause non vérifiée). Un téléchargement sur 10 parallèles a échoué une fois (« Failure when receiving data from the peer ») : prévoir `curl --retry 3`.
- **Gain** : remplace le clone de 36 à 60 s (ou le timeout) par moins d'1 s. **Coût** : 10 lignes. **Risque** : une référence nouvelle non détectée si le lien est écrit autrement que `references/x.md`.

### C. Copier les skills dans le dépôt (vendoring), avec épinglage

- **Principe** : committer `skills/` (ou `vendor/skills/`) avec le commit amont noté ; le hook copie, sans réseau. Le dépôt a déjà `skills/` pour les forks et `SKILLS.md` pour suivre les changements amont, donc la procédure existe.
- **Effet** : zéro latence, zéro panne réseau, reproductible.
- **Coût** : mises à jour manuelles ou planifiées ; le dépôt grossit (24 skills ≈ 400 Ko d'après les réponses de l'API : estimation). Licences à conserver dans `LICENSES/` (règle de CLAUDE.md du casebook pour le contenu tiers).
- **Risque** : retard sur l'amont, et les consommateurs du modèle (`templates/`) doivent recevoir les fichiers copiés.

### D. Clone partiel : `git clone --depth 1 --filter=blob:none --sparse` puis `sparse-checkout set <dossiers>`

- **Source** : [doc Claude Code, git-subdir](https://code.claude.com/docs/en/plugins/marketplace-reference.md#git-subdir-plugin-source) (« partial clone ») ; vos mesures : 36 s contre 60 s pour agent-skills. Réduit sans supprimer la variance du proxy.
- **Usage** : seulement en repli de A, pour un dépôt que l'API ne connaît pas. `git ls-remote` répond vite (HEAD obtenu), ce qui permet de détecter une panne avant de cloner.

### E. Plugins et marketplace Claude Code

- **Source** : [marketplace-reference](https://code.claude.com/docs/en/plugins/marketplace-reference.md). Types de source : `github`, `url`, `git-subdir` (checkout partiel), `npm`, `archive` (zip HTTPS avec `sha256`), `command`. `extraKnownMarketplaces` dans les réglages déclare un catalogue.
- **Effet** : `git-subdir` évite le dépôt entier, mais reste un clone git soumis au même proxy (non mesuré). `npm` et `archive` ne passent pas par git : un paquet npm de nos skills (registry.npmjs.org est dans `noProxy`, donc direct) serait probablement le chemin le plus fiable (non vérifié ici).
- **Coût élevé** : les skills d'un plugin sont préfixées (`plugin:skill`), ce qui change leurs noms ; il faut un marketplace avec une entrée par skill amont ; mise en route d'un autre mécanisme que le hook actuel. Le dépôt casebook est déjà organisé en plugins, mais pas les autres amonts.
- **Risque** : l'installation des plugins se fait au démarrage ou à la commande `claude plugin install` ; l'ordre par rapport au gel de la liste de skills n'est pas vérifié.

### F. Script d'installation de l'environnement cloud

- **Source** : la doc intégrée (`read_documentation`) dit que le script d'installation s'exécute au démarrage de chaque nouvelle session ; le détail (instantané mis en cache de l'image, ou non) n'y figure pas. Non vérifié. Même réseau lent, donc seul un instantané en cache aiderait.

## 3. Ce que font les autres

Je n'ai trouvé aucune issue de vercel-labs/skills sur la lenteur du clone ou le `sparse-checkout`. Résultats voisins : [#1469](https://github.com/vercel-labs/skills/issues/1469) (installe tout un monorepo), [#2644](https://github.com/vercel-labs/skills/issues/2644) (`skills ls` lent), et un outil concurrent signale le même problème de clone complet ([runkids/skillshare #46](https://github.com/runkids/skillshare/issues/46)). Je n'ai pas lu #1469 ni #46 en entier (résumé de recherche).

## 4. Recommandation classée

1. **A + B, avec repli sur l'ancien chemin** (npx par dépôt, plafond 45 s, puis D en dernier). Attendu : de 45 s (ou échec) à environ 3 s quand l'API répond. Un hook de ~60 lignes.
2. **C (vendoring)** en complément pour les skills critiques, si le retard d'instantané ne vous convient pas. C'est la seule option sans réseau.
3. **E avec `npm`** seulement si vous voulez distribuer vos propres forks ; sinon trop lourd pour le gain.
4. D seul : gain faible (36 s contre 60 s) et variance conservée.

## 5. Objection la plus forte contre A

Le hook dépend d'une API interne non documentée de `skills.sh`, qui peut changer sans préavis et servir un instantané plus vieux que le dépôt (issue #2626). Un échec silencieux est le pire cas : une skill obsolète installée sans erreur. Parades : comparer le champ `hash` à celui noté dans `skills.txt` ou `SKILLS.md`, ou épingler un commit et utiliser C ; le repli sur npx reste en filet pour les erreurs franches, pas pour la péremption.

## Non vérifié

- Comportement de l'API `skills.sh` pour une skill absente de l'index ou avec fichiers binaires.
- Fraîcheur de l'API par rapport à `main` (une seule comparaison identique).
- Débit des sources `archive` et `git-subdir` derrière ce proxy.
- Cache de l'image d'environnement cloud.
- Pourquoi 3 références d'addyosmani renvoient 404.
