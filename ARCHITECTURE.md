# Architecture réelle — STEP-005 validée, commit en attente

Cible décidée le 22 octobre 2026 : personnages 3D sur fond 2D isométrique.
Le présent document décrit encore le laboratoire 2D effectivement livré.
La transition est cadrée dans docs/decisions/DEC-001-personnages-3d.md.

## Structure réelle

Main conserve son UID uid://do6vxhog253vu et instance maintenant AnimationLab.
L'ancien ProjectionLab reste disponible comme scène de diagnostic via F6.

| Fichier | Responsabilité |
|---|---|
| scenes/main.tscn | Point d'entrée |
| scenes/debug/animation_lab.tscn | Monde trié, héros, ennemi et HUD tactile |
| scripts/debug/animation_lab.gd | Sélection des animations, pause, parcours de test |
| scenes/actors/hero_visual.tscn | Présentation du héros, atlas assigné |
| scenes/actors/enemy_visual.tscn | Présentation de l'ennemi, atlas assigné |
| scripts/actors/actor_visual.gd | Construction des SpriteFrames et lecture visuelle |
| assets/actors/*_atlas.svg | Deux planches vectorielles sources |
| tools/generate_actor_atlases.py | Génération déterministe des planches, Python standard |
| scripts/world/ground_projection.gd | Conversion pure sol/écran, inchangée |
| scenes/debug/projection_lab.tscn et script associé | Ancien laboratoire STEP-004 conservé |

## Présentation réutilisable

Chaque scène d'acteur est une racine Node2D au sol. Son script crée un enfant
AnimatedSprite2D et une bibliothèque SpriteFrames de vingt animations : cinq
états × quatre directions, quatre images chacune. Les racines ont z_index=0 ;
World active y_sort_enabled. Le changement de texture ne modifie pas la racine.
Le laboratoire ajoute les croix de diagnostic ; elles ne font pas partie de
l'acteur réutilisable et ne sont ni une collision ni une portée.

Le contrat public est play_pose(state, direction, restart=false), puis
set_visual_paused(paused). Une demande répétée de la même pose sans restart
ne remet pas l'animation à zéro. Un changement d'état ou de direction recommence
à la première image. Aucune sélection automatique de direction n'est implémentée.
Chaque instance possède sa lecture et sa bibliothèque ; elle partage seulement
la texture importée. Aucune animation ne déclenche un dégât, une mort logique
ou un déplacement. Le signal de fin visuelle n'est pas une horloge de combat.

## Laboratoire

Deux acteurs à 48 px de corps, côte à côte au départ. Les six boutons pilotent
les deux présentations ensemble. Image suivante suspend la lecture puis avance
le frame modulo quatre. Rejouer réinitialise aussi le temps des croisements.
Le croisement optionnel projette deux trajets logiques opposés ±45 unités,
cycle de huit secondes. La direction visuelle choisie reste indépendante : ce
mode teste le tri même sur Attack, Hit ou Death, sans simuler une action de jeu.

La pause met speed_scale à zéro et suspend uniquement le temps de diagnostic.
Elle conserve les poses de fin des animations non bouclées. La perte de focus
ou la pause Android déclenche cette pause locale, sans reprise automatique.
Le HUD reste dans un CanvasLayer séparé. Le rectangle natif de zone sûre est
converti par l'inverse de get_screen_transform(), borné au viewport, puis
utilisé au placement. Si le rectangle est vide, le viewport est utilisé.
Portrait de référence 540 × 960 ; autres formes non qualifiées à cette étape.

## Configuration et limites

Godot 4.7.2 standard, Compatibility desktop/mobile, canvas_items et expand,
portrait, ETC2/ASTC import activé, émulation souris depuis le toucher activée.
Preset Android Debug : ARM64, APK standard, Gradle désactivé, all_resources,
org.gambitarena.prototype, version 0.1.0-step005 code 3, signature activée.
Les chemins SDK/JDK et clés de signature restent locaux.
Les réglages hérités Jolt/Windows sont présents ; aucune 3D n'est utilisée.

La chaîne Android et le laboratoire STEP-005 ont été validés par l’utilisateur.
Installation ADB réussie ; empreinte APK consignée dans la fiche STEP-005. Filtrage linéaire, sans mipmaps ni compression VRAM demandée
pour ces atlas de diagnostic (import SVG par défaut à contrôler sur le poste).
Le coût brut des deux textures à échelle d'import 1 est décrit dans docs/assets.md.
Aucun autoload, collision, combat, ciblage, gambit ou contrôleur de héros.

## Principes pour la suite

Données, décisions, exécution et présentation resteront séparées. Les positions,
portées et vitesses seront calculées au sol. Le déplacement exécutera une
intention ; les animations ne posséderont pas l'horloge des dégâts. Les états
mutables resteront propres à chaque acteur. Un décideur automatique unique et
un exécuteur partagé pour gambits/commandes manuelles viendront aux étapes prévues.
