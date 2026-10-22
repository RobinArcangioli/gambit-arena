# Contrat de rendu hybride — TRANSITION-001

## Choix testé

Fond 2D dessiné par Node2D, mannequins 3D dans un seul SubViewport transparent,
HUD 2D au-dessus. La caméra est orthographique et fixe. Le damier de diagnostic
est vectoriel et procédural ; ce n’est pas encore une illustration d’arène.
La texture du décor est un SVG original, porté par un Sprite3D vertical pour
participer à l’occultation géométrique du monde 3D.

## Projection

Sol = (x,z), altitude = y. La caméra regarde l’origine depuis
(10, sqrt(200/3), 10), soit azimut 45 degrés et hauteur angulaire 30 degrés.
Pour une échelle k=48 pixels par unité, la projection au sol est :

- u = centre_x + k × (x-z) / sqrt(2).
- v = centre_y + k × (x+z) / (2×sqrt(2)).

Le fond utilise la caméra elle-même pour éviter deux implémentations divergentes.
La conversion inverse testée lance le rayon de caméra puis l’intersecte avec
le plan y=0. Attendu : rapport 2.000:1 et erreur <= 0,001 unité.
Le fond a une grille d’une unité ; aucun moteur physique n’intervient.

48/64/80 sont des comparaisons d’échelle apparente, pas des tailles de texture
ou de modèle. Le mannequin debout fait environ 1,08 unité de haut, soit près
de 48 px projetés à l’échelle initiale selon son orientation et son volume.
Les autres valeurs multiplient Model par 64/48 ou 80/48 sans changer la racine.

## Occultation

Les volumes se masquent selon leur géométrie et le tampon de profondeur,
ce qui peut différer d’un tri global par les pieds utilisé pour les sprites.
Le décor 2D est une carte verticale large d’environ 1,41 unité et haute de 1,65.
Son bas est à y=0 ; rotation Y=45 degrés ; pas de billboard ni de rotation caméra.
Alpha cut élimine les pixels transparents, avec un contour potentiellement plus
crénelé que l’alpha mélangé. Tester les bords et la silhouette sur téléphone.

Lors du passage exactement à travers la carte, une partie du corps peut être
devant et une autre derrière : intersection géométrique volontaire, sans collision.
Évaluer l’ordre sur les positions nettement de part et d’autre, pas seulement
à cet instant. Un acteur loin derrière peut dépasser visuellement le haut du
décor ; cela doit rester cohérent avec la caméra et les hauteurs.

Pour une future illustration : séparer sol et éléments occultants. Chaque
élément doit posséder un ancrage et une représentation de profondeur cohérente.
Les cartes verticales ne résolvent pas automatiquement les bâtiments, toits,
ombres ou éléments horizontaux. La solution artistique détaillée reste à cadrer.

## Limites du prototype

Pas d’ombres projetées : le sol 2D ne reçoit pas les ombres du monde 3D.
Pas de personnage riggé ni d’animations Attack/Hit/Death 3D. La marche est un
balancement procédural ; les pieds peuvent se lever mais la racine reste à y=0.
Marche désactivée permet d’observer la pose debout et l’alignement de la base.
Aucun clic/toucher pour déplacer un personnage : les trajets sont automatiques.
Les vingt mannequins servent à un premier relevé, sans qualifier le combat futur.

## Sources officielles

- https://docs.godotengine.org/en/4.7/classes/class_subviewportcontainer.html
- https://docs.godotengine.org/en/4.7/classes/class_viewport.html
- https://docs.godotengine.org/en/4.7/classes/class_camera3d.html
- https://docs.godotengine.org/en/4.7/classes/class_spritebase3d.html

## Validation reçue — 22 octobre 2026

Validation explicite utilisateur reçue le 22 octobre 2026.
- Damier 2D sous les mannequins : OK.
- Projection 2.000:1, erreur < 0,001 : OK.
- Ancrages et profondeur entre personnages : OK.
- Passage derrière/devant le décor 2D : OK.
- Boutons, pause et F8 : OK ; validation globale de l’étape reçue.
- Taille préférée en 3D : 48 px de référence.
- Relevé utilisateur : moyenne 60 FPS, pire image 16,7 ms, aucune saccade.
- Installation ADB : Success sur Galaxy A16 Android 16.
- SHA-256 APK : 124654de74db47ac162a9f925d7f4f3844aa7504a316f43a559c4a3d86635f10.

Ces mesures concernent le diagnostic livré et sont rapportées par l’utilisateur.
Elles ne qualifient pas les futurs modèles riggés, animations, combat ou effets.
Durée exacte du relevé, charge batterie/secteur et économie d’énergie non précisées
séparément dans le retour ; aucun profil GPU ni capture n’a été transmis.
