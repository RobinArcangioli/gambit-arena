# GRAPHICS-003 — modèles pirates et locomotion

Base : `1e427560a9d2884ce1d3e339a093d576192fc22f` (GRAPHICS-002, sauvegarde restaurée
et vérifiée). GO reçu pour cette étape après les décisions modèles, compétences et barres.
Travail préparé dans /tmp/gambit-graphics003-work avant synchronisation du dépôt.

## Livraison

Anne, Mako et deux squelettes pirates importés avec textures et armes embarquées. Idle/Walk
suivent le temps accepté par le jeu. StatsActor ne dérive plus du mannequin : vue enfant
remplaçable, repli mannequin et présentation absente. Main affiche Anne et le squelette
avec crâne ; la galerie F6 character_lab présente les quatre profils et huit orientations.
Voir docs/character-presentation.md et assets/art/characters/pirates/PROVENANCE.md.

La préparation documentaire acte GAMEPLAY-001 : Anne et Mako ensemble, compétences propres,
soin d'un allié sous 50 %, mana et barres rouge/bleu/or, incantations 1,5/2 s. Cette étape
future n'est pas implémentée ici. Les attaques, soin et spéciale existants fonctionnent
encore selon leurs règles de référence, sans les nouveaux gestes.

## Vérifications effectuées

Godot 4.7.2.stable.official.ed1daf0bf, Compatibility.
28 scènes headless : **1 803 contrôles, zéro échec, aucun warning/erreur** dans la campagne.
Dont 75 nouveaux contrôles : quatre profils, clips, huit orientations sans déplacement
logique, animation manuelle, repli absent/incompatible, 24 remplacements, 900 ticks identiques
avec modèles/mannequin/vue nulle, pause/focus, dix Rejouer par mode et galerie.
Les cinq tests historiques de comptage utilisent désormais le type logique StatsActor.

Rendu en fenêtre vérifié pour les quatre modèles, avec comparaison rapprochée du squelette
brut et de sa vue : Skeleton.glb est sans tête dans la source. Le profil ennemi par défaut
utilise donc skeleton_variant.glb, avec crâne. Aucune géométrie inventée ou source retouchée.

APK exporté, signé, installé avec succès sur Galaxy A16 SM-A165F (R58Y30CRFLR), lancé via
GodotAppLauncher ; versionCode 31, versionName 0.1.0-graphics003. Capture du combat réel
avec Anne et les squelettes, processus vivant. Filtrage borné des logs du processus : aucune
ligne Script Error/Parse Error/Fatal Exception trouvée ; cela ne remplace pas une recette
exhaustive. Le téléphone a reçu une commande de pause en fin de contrôle.
Aucune mesure FPS ni nouvelle campagne de performance n'est revendiquée.

APK : `/tmp/graphics-003-debug.apk` — 37 207 900 octets.
SHA-256 : `c4c6eec8f8259d825ccd0c384299b90a53be9bc5df3fb9818724548e08dce267`.

## Validation attendue

F6 character_lab, F8 puis F5, lisibilité des modèles, repos/marche, tactile, pause/reprise et
Rejouer sur l'APK ci-dessus. Les gestes d'attaque et de sorts sont les étapes suivantes.
Statut : livraison en recette ; pas encore validée par le propriétaire, ni commitée/poussée.

## Validation du propriétaire

« Step validée. GO next. » : GRAPHICS-003 validée, clôture autorisée avant GAMEPLAY-001.
Les fichiers non documentaires sont identiques à la livraison validée.
