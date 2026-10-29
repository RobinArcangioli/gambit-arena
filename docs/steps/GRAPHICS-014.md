# GRAPHICS-014 validée — 29 octobre 2026

Le propriétaire confirme sur Android : « Oui, step validée » pour le réglage B —
Équilibré. Le fin contour bleu et les huit particules attirées vers le lanceur sont
validés pendant l’incantation de Soin, Foudre et Booster. La présentation reste isolée
de la logique ; elle s’arrête à la résolution, à l’annulation, à la mort et au reset.
Les 63 bancs / 4 215 contrôles et la recette Galaxy A16 avaient déjà réussi.
Clôture documentaire uniquement : code, ressources, configuration et les deux APK
restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-graphics014` (64), SHA-256
`b6f76cc9754ad40ff2813894904d475e60bc780c774378b640694e835d37a68e`.
Gambits conservés octet pour octet ; gel de la pause vérifié sur le téléphone.
Laboratoire A/B/C exporté séparément, non installé sur Android.
Clôture par commit et sauvegarde complète restaurée/vérifiée.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Aucun push automatique. Les états précédents ci-dessous sont historiques.

# GRAPHICS-014 — Énergie ambiante pendant l’incantation

Statut : en recette. Base GRAPHICS-013, `b497548d283849af42aa821a52ed9a51711eb095`.
Le propriétaire choisit B — Équilibré dans le laboratoire Godot le 29 octobre 2026.

## Rendu

Contour bleu fin autour des maillages animés de Mako et Anne. Deux coques partagent
le maillage, la peau et le squelette existants : un cœur fin et une coque plus diffuse.
Les matériaux sont privés ; aucun shader ni animation de combat n’est modifié sur les
ressources importées. Les coques sont créées au premier lancement visuel, réutilisées
puis masquées. Épaisseurs 0,00025 / 0,00065 dans l’échelle des maillages Pirate importés.
Le flash de coup reste sur les maillages originaux et coexiste avec le contour.

Huit petits quads bleus face caméra montent et convergent vers le torse, avec une légère
courbure. Cycle déterministe 1,35 s, rayons 0,83 → 0,10 unité, apparition/disparition douce
de chaque particule. Aucun tirage dans le RNG du combat, aucune horloge autonome.
L’intensité B est 0,65 (A : 0,42 ; C : 0,88), pour contour et particules.

## Séparation et cycle de vie

`combat_presenter.gd` observe seulement `action.casting()`, la vie et l’équipe du héros.
Il fournit explicitement le delta visuel personnel accepté (donc accéléré sous Booster).
Les particules ne détiennent aucune référence aux exécutants ou aux états du jeu.
`character_view.gd` échantillonne le contour, `casting_energy.gd` les particules ; leurs
shaders sont dans `shaders/presentation/`. Aucune modification de la simulation.

L’effet concerne Soin, Foudre et Booster, uniquement sur le lanceur héro vivant.
L’effet s’arrête immédiatement en récupération, annulation, mort, fin de combat,
désactivation de la présentation ou changement de partie. Une pause conserve les
positions et l’âge ; la disparition des cibles et le reciblage gardent le contrat existant.
Les particules sont bornées à huit par héros en incantation, nœuds libérés à la fin.
Les effets de réussite Soin/Foudre/Booster restent indépendants.

## Validation

- 63 scènes / 4 215 contrôles réussis, zéro erreur ou warning moteur dans les bancs.
- 24 contrôles spécifiques : inactivité, vrais engagements Foudre/Booster, unicité,
  huit particules, gel à delta nul, aucune dépense, flash compatible, réutilisation,
  annulation, récupération, présentation désactivée, état terminal, reset, orphelins.
- Vérification GPU : deux héros en incantation, contour calé sur les modèles importés,
  shader Compatibility compilé. Réglage B explicitement choisi par le propriétaire.
- Laboratoire F6 : `scenes/debug/casting_energy_lab.tscn`, A/B/C ; boucle de vrais états
  d’incantation isolés sans effets de compétence ni sauvegarde des gambits du joueur.
- Android : APK normal installé sur Galaxy A16, version et SHA installés vérifiés,
  gambits conservés octet pour octet. Capture en combat : Mako incante Booster, contour
  bleu visible. Deux captures de pause strictement identiques. Aucun défaut dans les
  logs Godot/AndroidRuntime. Le téléphone reste en pause pour la recette du propriétaire.
  Le laboratoire correspondant est exporté séparément, non installé.

Main, F5, la navigation, la grille basse et le cadrage approuvé sont conservés.
Aucune mesure chiffrée de performance nouvelle. Validation complète de l’étape attendue.

## APK

Normal : `graphics-014-debug.apk`, version `0.1.0-graphics014` (64).
SHA-256 : `b6f76cc9754ad40ff2813894904d475e60bc780c774378b640694e835d37a68e`.
Laboratoire : `graphics-014-lab-debug.apk`, version `0.1.0-graphics014-lab` (64).
SHA-256 : `9acfd98776e943315274083f45b613af5595767d47c101c2b6fc82fb06bd6f2d`.
Ne pas confondre ces empreintes avec celle de l’archive complète de livraison.
