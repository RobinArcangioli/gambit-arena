# Arène fixe — STEP-006

## Domaine

Carré logique dans le plan XZ : [-3,3] × [-3,3]. Unités de monde 3D ; y est
l’altitude. Caméra orthographique fixe à 45° d’azimut, 30° d’élévation, rapport 2:1.
L’arène est un sol 2D dessiné à partir de cette projection, pas un mesh de terrain.
Le trait doré matérialise la limite géométrique ; la ceinture extérieure est décorative.
Aucun obstacle ni décor bloquant au centre. Les quatre pastilles périphériques
sont des motifs de repérage, pas des entrées de vagues implémentées.

## Contrat de limites

Source : scripts/arena/arena_bounds.gd.
HALF_EXTENT=3, ACTOR_MARGIN=0.35. clamp_ground(point, margin) borne chaque axe
à ±(3-margin). Une marge négative est ramenée à zéro ; une marge >=3 ramène
au centre. contains_ground compare au point borné avec la tolérance Vector2.
Ce contrat est destiné aux racines au sol, pas aux rectangles projetés à l’écran.

Pour le mannequin actuel : x et z entre -2,65 et 2,65. La marge ne définit pas
encore un rayon de collision. Elle devra être réévaluée avec les modèles définitifs,
leurs armes, poses et la future séparation des acteurs.
Il n’existe ni mur physique ni déplacement dans cette étape. STEP-007 devra
appliquer le bornage à chaque mise à jour du futur déplacement automatique.

## Recette des cinq placements

1. Héros au centre, ennemi en (1,4 ; -1,4).
2. Héros au coin (-2,65 ; -2,65), ennemi au coin opposé.
3. Héros au coin (+2,65 ; -2,65), ennemi au coin opposé.
4. Héros au coin (+2,65 ; +2,65), ennemi au coin opposé.
5. Héros au coin (-2,65 ; +2,65), ennemi au coin opposé.

Les demandes brutes des coins sont ±4 pour exercer clamp_ground en situation
hors domaine. Le bouton suivant revient au centre. Repères affiche la frontière
des racines et leurs croix. Aucun toucher sur le sol ne déplace les mannequins.

## Réservations d’interface dans la zone sûre

- Marge horizontale générale : 16 pixels de référence.
- Panneau supérieur : y=12, hauteur 100. Titre, pause, réservation pour l’état.
- Aire de rendu : y=124 ; hauteur = hauteur sûre - 388, minimum technique 300.
- Panneau inférieur : hauteur 240, à 12 pixels du bas.
- Deux boutons de recette en haut de ce panneau ; six cases inactives en deux
  rangées de trois pour matérialiser les futurs emplacements manuels.

À 540 × 960, le rendu mesure 508 × 572 ; il est distinct des panneaux, avec
un intervalle de 12 pixels. La largeur projetée de la bordure extérieure est
environ 448 px ; elle tient dans le rendu. Les personnages conservent leur
échelle apparente 48 px, indépendante de la hauteur du viewport.
Ces valeurs ciblent le portrait du Galaxy A16. Les petites fenêtres dont la zone
sûre est inférieure à 688 px de haut ne sont pas prises en charge par ce layout.
Le paysage et le HUD final ne sont pas qualifiés ici.

## Ce qui reste à venir

Les cases n’exécutent aucune action ; les trois compétences actives futures
ne sont pas encore assignées. Les gambits auront leur panneau à leur étape.
Pas de faux PV, faux ennemis tués ou faux compteurs de vague. Le dessin actuel
est un fond de travail modifiable par code, pas l’illustration définitive.

## Validation utilisateur — 22 octobre 2026

Arène et bordure entièrement visibles, mannequins lisibles à 48 px, cinq
placements dans les limites sans coupure ni chevauchement avec l’interface.
Pause/Position/Repères et les six cases inactives conformes ; F8 sans erreur.
STEP-006 validée. Voir la fiche d’étape pour l’empreinte de l’APK testé.
