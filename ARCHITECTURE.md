# Architecture réelle — TRANSITION-001 validée, commit en attente

## Composition du rendu

Main conserve son UID et instance scenes/hybrid/hybrid_lab.tscn. La racine du
laboratoire est un Control contenant, dans l’ordre de dessin : fond de couleur,
Ground (Node2D), Render3D (SubViewportContainer), HUD (Control).
Ground dessine un damier dimétrique en 2D. Render3D affiche un unique SubViewport
transparent avec son propre World3D. Les personnages partagent ce monde et son
tampon de profondeur. Le HUD se dessine au-dessus ; aucun y_sort 2D ne trie les
volumes 3D. Les anciens laboratoires restent disponibles via F6.

| Source | Rôle |
|---|---|
| scenes/hybrid/hybrid_lab.tscn | Arbre de composition, caméra et HUD |
| scripts/hybrid/hybrid_lab.gd | Scénarios, raccord projection, commandes et compteurs |
| scripts/hybrid/ground_canvas.gd | Fond 2D recalculé selon la projection de la caméra |
| scripts/hybrid/proxy_actor.gd | Mannequin procédural, orientation et balancement des membres |
| assets/hybrid/occluder.svg | Décor 2D original, utilisé par un Sprite3D |
| scripts/world/ground_projection.gd | Ancienne conversion conservée pour les diagnostics 2D |

## Caméra, coordonnées et décor

Plan logique (x,z) = plan horizontal 3D ; altitude y=0 aux pieds. Caméra
orthographique fixe, azimut 45 degrés et élévation 30 degrés : rapport de
projection au sol 2:1. C’est une vue dimétrique, dans le sens courant de fond
isométrique du projet. L’ancienne convention graphique 2:1 est conservée.

Le fond n’est pas un mesh : il utilise camera.unproject_position() pour placer
ses sommets en pixels du SubViewport. Le Node2D est au même emplacement que le
conteneur 3D. Stretch est activé sans réduction (stretch_shrink=1) ; un pixel
logique du rendu correspond à un pixel du fond. La caméra adapte sa largeur
orthographique à la largeur du SubViewport / 48 pour conserver l’échelle.
Le contrôle projection/inverse projette puis recoupe le rayon avec y=0.

Le décor est une image sur un Sprite3D vertical, orienté à 45 degrés autour de Y,
ancré au sol. Alpha cut discard à 0,5, profondeur active, sans éclairage ni ombre.
Les pixels opaques participent à la profondeur ; le contour transparent ne
forme pas un rectangle opaque. Ce test décrit une carte verticale, pas un
bâtiment volumétrique. Un fond unique aplati ne suffit pas à reproduire cette
occultation : les futurs éléments qui masquent les personnages devront être
séparés et raccordés à une représentation de profondeur adaptée.

## Mannequins et scénarios

Deux mannequins initiaux, cyan et orange, composés de BoxMesh et d’une SphereMesh
pour la tête du cyan. Chaque racine est au sol ; seul l’enfant Model est mis
à l’échelle. Les pivots des membres créent une marche de diagnostic par sinus.
Pas de squelette, de modèle importé, de système d’animation de production ou de
combat. Les commandes ne changent que la présentation et les trajets de test.

Croisement : deux trajets opposés sur huit secondes, mêmes règles de demi-tour
instantané que les diagnostics précédents. Décor 2D : le cyan traverse le plan
vertical du décor ; l’orange est à l’écart. Charge 20 : vingt mannequins au total
sur deux cercles ; les dix-huit supplémentaires sont cachés dans les autres modes.
Ce nombre n’est pas un résultat de qualification du plafond de vingt ennemis.

Une lumière directionnelle et de l’ambiance, sans ombres, sans post-traitement,
sans MSAA ajouté. Le fond 2D ne reçoit pas l’éclairage 3D. Aucun personnage n’est
pré-rendu individuellement ; le coût est celui d’un seul rendu 3D partagé.

## Pause et mesures

Une horloge locale pilote positions et poses. Pause/perte de focus la fige ;
le retour ne la relance pas. Repartir réinitialise cycle et mesures sans reprendre.
Moyenne = nombre de frames traitées / somme des delta non pausés ; pire image =
plus grand delta observé. Ce sont des indications de cadence de traitement,
non des mesures GPU. Les valeurs dépendent aussi de VSync, du delta moteur et de
la chauffe. Changer mode, échelle ou marche réinitialise les mesures.

## Configuration

Godot 4.7.2 standard, Compatibility, portrait 540 × 960 canvas_items/expand.
Entrées tactiles via émulation souris conservée. Zone sûre Android convertie
dans le viewport principal. Fenêtre de rendu 3D de 380 px de haut dans la zone
sûre ; ce HUD est un diagnostic pour le portrait du Galaxy A16.
Preset Android Debug : ARM64, APK standard, sans Gradle, paquet inchangé,
version 0.1.0-transition001 code 4. JDK/SDK et signature restent locaux.
La compatibilité 3D matérielle n’est pas déduite du succès STEP-005 en 2D.

## Limites et suite

Import, exécution et export validés par l’utilisateur le 22 octobre 2026.
Relevé du diagnostic sur téléphone : 60 FPS moyens, pire image 16,7 ms, sans
saccade signalée ; taille 48 px confirmée. Ce résultat ne qualifie pas les
futurs modèles et la charge du combat. Pas de collision,
pathfinding, dommages, gambits ou persistance. La traversée du décor est volontaire.
Les futurs modèles riggés, cinq animations et licences seront cadrés après ce
prototype. Le gameplay doit continuer à séparer données, décisions, exécution
et présentation ; les animations ne posséderont pas l’horloge des dégâts.
