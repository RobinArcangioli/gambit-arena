# ARENA-005 validée — 29 octobre 2026

Le propriétaire confirme : « Step validée. » après installation sur Galaxy A16.
Les dix arènes partagent un octogone central fixe, une caméra commune à 45° et les
mêmes limites physiques. Seuls le zoom uniforme et le décalage des fonds s’adaptent.
Ville d’Alexandrie et Ombres de Beherit sont ajoutées à partir des PNG fournis intacts.
Les formations apparaissent au sud/nord avec marge de gabarit ; les héros conservent
positions et états entre vagues. Le contrôle des silhouettes sur les flancs a conduit
à ajouter une réserve visuelle par zoom de 18 % des fonds, sans changer l’octogone.
La case « Afficher grille » des réglages montre le quadrillage clippé sous les modèles,
sans pause ; elle est désactivée par défaut et son choix est mémorisé immédiatement.
Les 68 scènes / 5 027 contrôles et la recette tactile Android ont réussi, y compris
la mémorisation de la grille après relance. Gambits et réglages initiaux préservés.
Clôture documentaire uniquement : code, ressources, configuration et APK identiques
à la livraison validée. Aucun nouveau test ni mesure de performances à cette clôture.
APK installé : `0.1.0-arena005-grid` (78), SHA-256
`8ea6c9963a40c1ec94bc00b9d8226de410db7f21eab529217e521703a8de8b5e`.
Clôture par commit local et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# ARENA-005 — Octogone central commun, dix fonds et formations nord/sud

Statut : en recette, validation utilisateur attendue.
Base ARENA-004 : `1a0baa9da71b9cea0e2862a671acd27a5b362e78`.

## Contrat retenu

Le propriétaire demande un octogone commun, toujours identique et toujours à la même
position. Ce sont les images qui s’adaptent par zoom et/ou décalage. La réalisation
finale abandonne donc les inclinaisons propres à chaque décor étudiées en cours d’étape.
Pour un même viewport et une même zone sûre, les huit sommets projetés ont exactement
les mêmes coordonnées sur toutes les arènes. La caméra reste fixe à 45° et son cadrage
dépend seulement de l’octogone et des panneaux héros, jamais du fond sélectionné.
L’adaptation habituelle au format d’écran reste commune à tous les décors.

## Géométrie et déplacements

Un seul ArenaBounds définit un octogone régulier convexe : |x| et |z| ≤ 3√2,
|x|+|z| ≤ 6. Ce choix conserve la largeur et hauteur projetées de la zone agrandie
précédente et utilise davantage de dallage dans ses anciens coins vides. Les huit
plans sont érodés de 0,35 pour protéger le gabarit complet des personnages.
Le contour est indépendant de toute image, ressource artistique ou scène d’arène.

Le clamp utilise le point le plus proche sur les huit côtés. Le mouvement balayé et
la correction de foule restent dans ce domaine convexe. Le contournement conserve
une grille interne carrée à pas 0,2 (39×39 cellules), mais rend solides toutes les
cellules situées hors de l’octogone érodé. Les raccourcis doivent avoir leurs deux
extrémités dans cette zone ; tout leur segment y reste par convexité. Aucun trajet
ne peut emprunter un coin supprimé. Les budgets de recherche restent bornés.
La grille de démonstration 8×8 est également coupée au vrai contour octogonal.

## Fonds et catalogue

Ville d’Alexandrie et Ombres de Beherit sont copiées octet pour octet depuis les deux
PNG fournis, en 540×960. Aucune génération, retouche, déformation ni recadrage des
fichiers sources. Noms et SHA-256 : assets/art/arenas/supplied_additions.json.
Miniatures 108×192 via le procédé technique existant. Les huit PNG antérieurs et
leurs miniatures restent inchangés.

Les dix scènes règlent uniquement le centre et l’emprise de leur image. Le rendu
calcule un facteur d’échelle uniforme et un décalage derrière l’octogone fixe. Les
repères sont dans assets/art/arenas/calibration/arena_calibration.json. Les polygones
de dallage servent au contrôle des fonds ; ils ne définissent pas dix limites de jeu.
Aucun angle de caméra, contour physique ou rayon de terrain n’est propre à une arène.
Le catalogue compte dix arènes jouables plus la référence technique, exclue du mode.
Le RNG visuel et la rotation vers un autre décor toutes les dix vagues sont conservés.

## Formations du mode Infini

Au nouveau combat, Mako et Anne se placent sur le bord sud, à la marge de gabarit,
Mako à gauche. Leur position est calculée sur le plan sud de l’octogone érodé, sans
coordonnées artistiques. Les six ennemis privilégient deux rangées centrées de trois
près du bord nord. Si des héros occupent des places d’arrivée, les premiers points
libres du demi-terrain nord sont utilisés. Écart minimal 0,71 et spawn atomique par six.
Les héros ne sont pas replacés entre vagues : positions, PV, PM et buffs restent acquis.
Les trois secondes d’attente, la pause, la défaite, Rejouer et l’abandon sont conservés.

## Laboratoire et vérification

scenes/debug/new_arenas_lab.tscn : comparaison figée via Précédente/Suivante et Grille,
avec nom du fond et marqueurs des pieds. Aucun fichier du joueur lu/écrit. Le laboratoire
projette la géométrie réelle ; les grilles SVG techniques correspondent au même contour.
La case « Afficher grille » des réglages de combat affiche le quadrillage du terrain
et son contour octogonal, sous les modèles. Masquée par défaut, elle est mémorisée
immédiatement et ne met pas le combat en pause. Les repères des pieds restent réservés
au laboratoire.
L’outil tools/export_new_arenas_lab.py exporte depuis une copie isolée ; F5 reste l’accueil.

68 scènes / 5 027 contrôles réussis : 216 pour les décors/projections, 257 pour la
limite octogonale, le contournement et les arrivées. Contrôles sur 540×960, 540×1170 et
360×640 : PNG intacts, miniatures, images sans déformation, calage sur le dallage,
identité des huit sommets à l’écran entre les dix fonds, absence de mutation du combat.
Clamps sous 64 angles, marge de disque sur huit plans, grille clippée, vraies routes
contournant un obstacle, cellules interdites, arrêt réel sur le bord et 100 formations
avec deux héros occupant des positions quelconques. Les suites antérieures restent
réussies. Les fixtures dépendant des anciens bords sont adaptées à ce contrat explicite.
Une première exécution du banc EnemyDirector attendait encore les anciens bords carrés ;
la relance après mise à jour de cette attente réussit sans erreur/warning moteur.

Captures GPU et recette Android sur les dix fonds, puis restauration du jeu normal,
préservation des gambits/réglages et contrôle de la pause. Les captures Android sont
associées au décor et à l’état de grille confirmés par le laboratoire après chargement.
La validation esthétique du propriétaire reste attendue. Aucune mesure FPS ajoutée.

## Contrôle complémentaire des extrémités latérales

La première passe contrôlait surtout le contour et les gabarits au sol ; elle ne
vérifiait pas systématiquement les silhouettes contre les éléments peints. La passe
ciblée a révélé des chevauchements près de colonnes, bannières et rambardes.
Les dix calages reçoivent une réserve visuelle supplémentaire par zoom uniforme
du fond de 18 % ; ni la caméra, ni les limites, ni les positions des modèles ne changent.
Les grilles SVG et métadonnées de calage suivent ce nouveau zoom. Les PNG restent intacts.

Vérification GPU des dix décors avec huit modèles sur les deux flancs, aux quatre
positions tangentielles −2,25 / −0,75 / 0,75 / 2,25, à la marge physique de 0,35.
Deux dispositions inversées placent aussi Mako et Anne à droite puis à gauche.
Les captures contrôlent les silhouettes et pas uniquement les points des pieds.
Les 216 contrôles de calage/projection sont relancés sans échec ni erreur moteur.
Après ajout du réglage de grille, la suite complète est relancée : 68 scènes /
5 027 contrôles réussis. Le réglage est testé par toucher aux trois résolutions :
affichage immédiat, persistance, masquage, Rejouer et nouveau combat.

## APK

Normal : arena-005-grid-debug.apk, version 0.1.0-arena005-grid (78).
SHA-256 : `8ea6c9963a40c1ec94bc00b9d8226de410db7f21eab529217e521703a8de8b5e`.
Laboratoire : arena-005-grid-lab-debug.apk, version 0.1.0-arena005-grid-lab (78).
SHA-256 : `450a1ddcbf256ba10266b2365a23a0de1ade1c990b8fe6b86851975935b8b88b`.
Livraison complète sans .git/.godot, bundle de base séparé et restauration vérifiée.
Aucun fichier privé du joueur livré. Validation attendue avant commit ; aucun push.
