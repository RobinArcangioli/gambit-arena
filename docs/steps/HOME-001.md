# HOME-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » après le choix de l'essai C et la recette Android.
La version retenue est HOME-001-FIX2 : huit bougies recalées, deux braséros, halos doux à
taille fixe, scintillement C. Le banc A/B/C est conservé pour les ajustements futurs.
APK 0.1.0-home001-fix2 (52), SHA-256
`7cfefa33a7cdd0a85ca246864f2875534923de3d62a0ce3e50879d3a949783bb`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 144 contrôles de parcours et 24 contrôles GPU ne
sont pas relancés. Recette Android réussie, gambits conservés octet pour octet.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée prolongée Android, puis STEP-029/030. GAMEPLAY-003 reste annulée.
Les états et essais précédents ci-dessous sont historiques.

# HOME-001-FIX2 — Réglage C retenu par le propriétaire — en recette

Après comparaison dans Godot de trois essais (A Doux, B Équilibré, C Un peu plus présent),
le propriétaire choisit explicitement « C — Un peu plus présent ». Ce choix esthétique
n'est pas encore une validation de clôture de HOME-001.
Halos adoucis, taille fixe, aucune langue de flamme synthétique ni gonflement de disque.
Huit bougies recalées sur les flammes visibles : les faux points sur livres/colonnes retirés.
Deux braséros conservés. Rayons : bougies 28×38, braséros 72×90 (pixels de l'illustration).
Intensités C : bougies 0,30, braséros 0,46 ; modulation maximale ±34 % avec rythmes déphasés.
Le scintillement utilise trois oscillations ; arrêt hors accueil / arrière-plan conservé.
Banc F6 réutilisable : scenes/debug/home_lighting_tuning.tscn, défilement A/B/C toutes les
8 secondes, pause et sélection ; il conserve le choix dans user://home_lighting_choice.json
et ne change pas les réglages de production. L'accueil normal utilise désormais C par défaut.
APK 0.1.0-home001-fix2 (52), SHA-256 `7cfefa33a7cdd0a85ca246864f2875534923de3d62a0ce3e50879d3a949783bb`.
144 contrôles de parcours et 24 contrôles GPU réussis. Recette Android dans la livraison.
Les essais précédents ci-dessous sont historiques et remplacés par ce réglage.

# HOME-001-FIX1 — Animation renforcée — en recette

Retour propriétaire : l'effet initial est trop subtil et l'animation imperceptible.
Variation de luminosité portée de ±9 % à ±52 %, halos agrandis et rayons animés de ±18 %.
Deux langues lumineuses ondulent dans chaque flamme ; phases distinctes par source.
Intensités de base : bougies 0,46, braséros 0,64. Arrêt hors accueil et en arrière-plan
conservé ; la texture et le cadrage ne changent pas. Les valeurs restent réglables dans
le profil visuel. Ce fix appartient à HOME-001, toujours en attente de validation.
APK 0.1.0-home001-fix1 (51), SHA-256 `17d389a3ed5a8dd66ed59e98a99655911b7f7c501f958feb9085d4b4bad98a4f`.
Deux bancs / 144 contrôles et recette GPU / 24 contrôles réussis après réimport ;
aperçu animé 3 secondes et recette Android, sans erreur. Gambits Android identiques.
La livraison précédente HOME-001 est remplacée par cette révision ; aucun commit effectué.
Les descriptions antérieures ci-dessous décrivent la version initiale.

# HOME-001 — Lueurs procédurales de l'accueil — en recette

À la demande du propriétaire, les bougies et les deux braséros de l'accueil reçoivent des
halos additifs locaux et un scintillement discret. Profil visuel séparé du routage et de la
logique de jeu ; image d'origine intacte. Nouvelle étape esthétique avant UI-005.
Base clôturée GAMBITS-002 : `4b5eea1412cdc8c52daca1c85638d36bb6675ce9`, sauvegarde restaurée
et vérifiée (685 fichiers). HOME-001 attend validation avant commit et sauvegarde de clôture.
APK 0.1.0-home001 (50), SHA-256 `739a198892a17db6eecb158cc475d50354cb0f360bbd41d0c725fc88cd951ce4`.
Deux bancs de parcours/layout : 144 contrôles ; vérification GPU dédiée : 24 contrôles,
sans erreur. Preuves avant/après et recette native dans l'archive de livraison.
Aucun benchmark FPS. Prochaine étape après validation/clôture et GO : UI-005.
Les états précédents ci-dessous sont historiques.

## Réalisation

Treize petits rectangles à shader canvas additif : onze bougies et les deux braséros.
Couleurs chaudes dorées / bleu cyan, halo doux et petit noyau lumineux. Scintillement borné
à ±9 % de l'intensité de référence, avec phases différentes et deux oscillations douces.
Le temps est fourni par le composant, sans TIME global de shader, pour geler réellement
l'animation en arrière-plan. L'effet est arrêté dans les autres routes et reprend sans saut.

`scripts/presentation/home_lighting.gd` ne manipule que des contrôles décoratifs, sans prise
d'entrée. `home_lighting_profile.gd` et `resources/presentation/home_lights.tres` permettent
de modifier les positions dans l'image, les rayons, couleurs, intensités et scintillement.
`assets/shaders/home_glow.gdshader` dessine chaque halo local : aucun bloom plein écran ni
nouvelle scène 3D. AppRoot compose cette couche dans le fond, derrière les boutons.
Les positions reprennent le cadrage centré STRETCH_KEEP_ASPECT_COVERED de l'image ; les
marges système ne décalent pas les lumières. La couche est coupée aux limites de l'écran.

Le logo, la lune et les étoiles ne reçoivent pas d'effet. Aucun modèle, combat, gambit,
pathfinding ou équilibrage modifié. La texture source reste identique.

## Vérification

Deux bancs existants app_layout_tests (64) et app_navigation_tests (80) : 144 contrôles.
Script GPU de recette : 24 contrôles, 13 sources, cadrage 540×960 / 540×1170 / 360×640,
retour à l'accueil, arrêt hors de la page, perte/reprise de focus et absence de nœuds orphelins.
Les captures avant/après utilisent le même temps visuel figé pour comparer uniquement l'effet.
Cette recette est automatisée, pas un test manuel PC du propriétaire.

APK exporté/signé/vérifié et recette Galaxy A16 : voir verification/home001-android-report.json.
Réglages de gambits comparés octet pour octet avant/après ; aucune donnée privée incluse dans
la livraison. Les captures permettent de juger l'intensité sur le vrai écran. Aucun chiffre
FPS avancé : le choix de petits quads réduit la surface traitée, sans prétendre à une mesure.

F5 ou F6 scenes/app/app_root.tscn : observer l'accueil quelques secondes, ouvrir Équipe et
revenir, puis mettre l'application en arrière-plan et la reprendre. Ajuster si nécessaire
l'intensité avant la validation de HOME-001.
