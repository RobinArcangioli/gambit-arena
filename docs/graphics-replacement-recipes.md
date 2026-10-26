# Remplacer l'apparence sans changer le jeu

Les exemples ci-dessous sont exécutables via F6 `scenes/debug/graphics_qualification_lab.tscn`,
bouton « Demo : arene / modele / eclair ». F8 puis F5 retrouve Main avec ses choix habituels.
Le laboratoire utilise ses propres gambits en mémoire et n'écrit jamais le fichier des règles.
Les exemples ne sont pas activés par défaut dans Main.

## 1. Changer une arène

Choisir `resources/presentation/arenas/sanctuaire_polaire.tres` dans le catalogue ou appeler
`floor_canvas.set_definition(resource)`, puis synchroniser la projection. La scène de fond,
son image et ses points de calage sont des ressources de présentation. Le centre, les limites
logiques, le rayon des acteurs et les points de spawn ne sont pas modifiés.
Pour remplacer le thème de Main durablement, assigner l'autre ArenaDefinition au point de
composition `scenes/party/party_application.tscn`. Ne pas modifier ArenaBounds.
La démo emploie le Sanctuaire polaire ; le test compare 600 ticks pour les huit fonds et
la référence. Un mauvais type de scène retombe sur la référence calibrée.

## 2. Permuter un modèle

`resources/presentation/examples/mako_as_anne.tres` reprend uniquement l'apparence et les
clips d'Anne. L'appliquer via `mako.set_appearance(resource)` change le modèle de Mako,
mais sa clé, ses PV, son attaque, ses compétences, sa mana et ses règles restent celles de Mako.
Pour une modification durable, changer `model` et les noms de clips dans son
`resources/presentation/characters/mako.tres`. Vérifier les noms exacts importés et les
ancrages visuels, sans toucher `data/party/mako.tres`.
La démo montre deux apparences Anne ; celle contrôlée par Mako lance toujours Foudre.
Un modèle absent, ou dépourvu de rig/clips nécessaires, utilise le mannequin de repli.

## 3. Remplacer l'éclair

`resources/presentation/examples/lightning_violet.tres` référence une autre PackedScene :
`scenes/presentation/lightning_violet.tscn`, avec une silhouette resserrée et un glow violet.
L'assigner à `action_presenter.lightning.definition` remplace cet habillage. Pour le choix
permanent, changer les scènes/couleurs dans `resources/presentation/effects/lightning.tres`.
La nouvelle scène respecte `setup(profile, visual_seed)` et `advance_visual(dt)` ; elle
ne demande aucune action, ne débite pas de mana et n'applique pas de dégâts.
La préparation conserve son contrat séparé décrit dans lightning-presentation.md.
La démo conserve les 2 s d'incantation et les règles de Foudre. Le test compare les valeurs
de jeu tick par tick ; une scène sans les méthodes attendues est ignorée.

## Contrat vérifié

Le banc `scenes/tests/graphics_contracts_tests.tscn` vérifie 600 ticks par composition
(18 compositions, soit 10 800 ticks), avec soin et Foudre réellement résolus dans chacune.
Il compare positions, orientations, PV, mana, dépenses, cooldowns, phases, temps d'action,
dégâts, soin, vagues et résultat. La vue absente, les assets invalides, le modèle permuté,
les deux squelettes et la scène d'éclair remplacée gardent les mêmes valeurs de jeu.
Il vérifie aussi la résolution complète entre deux instantanés et l'absence d'orphelins.
Ces exemples prouvent la séparation pour les assets utilisés ; un nouveau rig doit toujours
être inspecté visuellement et ses clips doivent être raccordés dans son profil.
