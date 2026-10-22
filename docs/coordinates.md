# Coordonnées et profondeur — laboratoire de projection STEP-004

Ce document décrit la scène conservée scenes/debug/projection_lab.tscn (F6).
Depuis STEP-005, F5 ouvre le laboratoire d’animations ; son contrat d’ancrage
et ses directions sont décrits dans docs/assets.md et ARCHITECTURE.md.
La conversion sol/écran ci-dessous est partagée et inchangée.

## Deux espaces, une conversion

Le plan logique du sol utilise (x, y), en unités de jeu. L'écran utilise (u, v),
en pixels de référence, avec v positif vers le bas. Aucun calcul de portée,
vitesse ou séparation ne doit utiliser une distance dans l'espace affiché.
La projection est dimétrique 2:1, sans grille de gameplay ni caméra 3D.

Fichier unique : scripts/world/ground_projection.gd.

- Projection : écran = origine + (x - y, (x + y) / 2).
- Inverse, pour (u, v) = écran - origine : sol = (u / 2 + v, v - u / 2).
- +x se projette vers le bas à droite ; +y vers le bas à gauche.
- -x se projette vers le haut à gauche ; -y vers le haut à droite.

Exemple : avec origine (270, 430), le sol (100, 0) devient (370, 480).
La distance au sol entre (100, 0) et (130, 40) vaut 50 unités ; la distance
entre leurs projections ne doit pas servir à calculer une portée d'attaque.
Un déplacement de 100 unités selon +x et selon +y conserve la même longueur
logique. Les vitesses apparentes peuvent différer entre directions projetées.

## Application dans le laboratoire

World porte la translation d'origine : origine de la zone sûre + (largeur sûre / 2, 420).
Ses enfants reçoivent la projection sans origine, pour éviter de l'ajouter
une seconde fois. Le dessin du sol utilise la projection avec cette origine.
Le HUD affiche la position logique et la position globale affichée de A.
Il n'y a ni rotation ni zoom du monde dans cette étape.

Deux zones de diagnostic, pas une arène de jeu :

- Croisement : centre logique (-140, -140).
- Décor : centre logique (130, 130).

Le paramètre de trajet s parcourt -45 à +45 en quatre secondes, puis revient.
A = centre + (s - 4, s + 4), B = centre + (-s + 4, -s - 4).
C = centre du décor + (s + 5, s - 5).
La vitesse logique de chaque acteur est environ 31,82 unités/s sur chaque
segment. Les demi-tours instantanés sont propres au diagnostic.

Aux secondes 2 et 6, les acteurs du croisement atteignent la même profondeur.
Observer l'ordre avant et après cet instant ; à égalité exacte, aucun ordre
sémantique avant/arrière n'est imposé par le gameplay dans cette étape.
Le décor est non bloquant : C le traverse volontairement pour tester le tri.

## Hiérarchie et tri

- Main (Node2D)
  - ProjectionLab (Node2D, script de diagnostic et dessin du sol)
    - World (Node2D, y_sort_enabled=true)
      - ActorA (Node2D)
      - ActorB (Node2D)
      - Pillar (Node2D)
      - ActorC (Node2D)
    - HUD (CanvasLayer, layer=1)
      - SafeFrame (Control)
        - Title, CrossingTitle, DecorTitle, Diagnostics (Label)
        - PauseButton, SizeButton, RestartButton, SilhouetteButton (Button)

Au lancement, chaque acteur et le pilier reçoivent Visual (Sprite2D) et
FootMarker (Line2D). Ils apparaissent dans l'arbre distant de l'éditeur.
Tous les éléments triés ont le même z_index (0). Les racines des acteurs
n'activent pas le tri de leurs propres enfants : sprite et repère restent
un groupe trié selon la position de la racine au sol.
Le fond est dessiné par ProjectionLab avant ses enfants. Le HUD est indépendant.

## Ancrage, silhouette et empreinte

La racine représente les pieds. Sprite2D.centered=false ; son offset vaut
(-largeur/2, -hauteur). L'ancrage reste le centre inférieur lors du changement
de texture : 48 × 48 vers 80 × 80. Le corps est au même emplacement relatif
aux pieds ; seuls les bras et l'effet supérieur étendent la silhouette.
Lorsque le test Silhouette est activé, la variante alterne toutes les deux
secondes, sans modifier la trajectoire. Il est désactivé au lancement.
La taille choisie (48/64/80) correspond au cadre de la texture normale dans
les pixels de référence du viewport, pas aux pixels physiques de l’écran.
La texture haute reçoit la même échelle : elle dépasse cette hauteur.
La mise à l’échelle est appliquée au visuel, sans déplacer les pieds.
Ce test n'est pas encore le système Idle/Move/Attack/Hit/Death de STEP-005.

Le pilier utilise le centre inférieur de sa base comme point de profondeur.
La croix claire indique l'ancrage, pas une collision ni une portée.
Aucune empreinte physique ni collision n'est encore implémentée.
Ne pas utiliser le rectangle des textures comme empreinte future.

## Commandes de diagnostic

- Espace : suspend/reprend l'horloge locale du laboratoire.
- R : remet l'horloge à zéro, en conservant l'état pause/marche.
- T / bouton Silhouette : active/désactive l'alternance de silhouette.
- S / bouton Taille : cycle 48 → 64 → 80 → 48.
- Les boutons Pause et Repartir correspondent à Espace et R.

Ces commandes ne déplacent pas manuellement les acteurs. La pause globale
du gameplay reste à son étape. La perte de focus suspend le diagnostic ;
il faut explicitement choisir Reprendre après le retour.

## Sources de référence Godot 4.7

- https://docs.godotengine.org/en/4.7/classes/class_canvasitem.html#class-canvasitem-property-y-sort-enabled
- https://docs.godotengine.org/en/4.7/classes/class_sprite2d.html
- https://docs.godotengine.org/en/4.7/classes/class_inputeventkey.html
