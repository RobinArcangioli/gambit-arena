# HUD-001 validée — 30 octobre 2026

Choix Godot : icône Menu A Trois traits ; séparateur B Losange central or.
Bandeau commun bleu nuit transparent sans bordure : statistiques et journal à gauche,
Vague N centré, réglages puis Menu à droite. Le compteur reste visible pendant les rapports.
Les quatre héros partagent le même fond bleu nuit transparent, sans cadres individuels,
avec de fins filets fondus et un losange or central dans les espaces de séparation.
Portraits, barres, buffs et ordre de l’équipe conservés. Menu garde Reprendre, Rejouer,
Abandonner avec confirmation et les protections de pause/reprise existantes.
79 scènes / 5 906 contrôles consolidés réussis, dont 65 dédiés au nouveau HUD.
Captures GPU vérifiées. APK v89 installé et validé sur Galaxy A16 :
« Oui, HUD-001 validée ». Gambits, équipe et réglages conservés, vérifiés par empreinte.
Clôture documentaire uniquement, code et APK identiques à la recette validée.
Commit local et sauvegarde complète restaurée/vérifiée ; aucun push automatique.
Prochain GO : UI-005. Détails : docs/steps/HUD-001.md.
Les états suivants sont historiques.

# AOE-002-FIX2 validée — 30 octobre 2026

Météore touche désormais tout ennemi vivant dont le disque logique au sol chevauche
le disque AOE, contact exact compris. Rayon AOE inchangé : 1,4 ; rayon des acteurs :
0,35. La distance maximale entre centres pour être touché est donc 1,75.
Le ciblage de groupe, les contrôles de zone vide et l’impact partagent cette règle.
Point verrouillé et victimes calculées au début de l’explosion, alliés exclus.
Aucun changement de l’animation validée, du coût, des dégâts ou des durées.
78 scènes / 5 841 contrôles consolidés, dont 68 de régression sur le chevauchement.
Captures GPU vérifiées ; deux APK v88 installés et validés sur Galaxy A16 :
« Oui, AOE-002-FIX2 validée ». Gambits, équipe et réglages conservés.
Clôture documentaire uniquement, code et APK identiques à la recette validée.
Commit local et sauvegarde restaurée/vérifiée ; aucun push automatique. Prochain GO : UI-005.
Détails : docs/steps/AOE-002-FIX2.md.
Les états suivants sont historiques.

# AOE-002-FIX1 validée — 30 octobre 2026

Godot : Flash compact + Rouge accentué + C Avec braises retenus.
Météore : roche irrégulière, flammes rouges et filets rose profond pendant la chute ;
demi-sphère blanche atténuée, volutes rouges, onde enflammée et braises à l’impact.
Chute accélérée de 30 % : environ 0,77 s ; explosion toujours 1 s.
Pendant l’incantation uniquement, contrôle toutes les 0,5 s de temps de combat :
si aucun ennemi vivant dans la zone fixe, annulation sans PM ni recharge et reprise
des gambits. Après lancement, le météore reste engagé et frappe les présents à l’impact.
77 scènes / 5 773 contrôles consolidés ; 108 contrôles finaux relancés avec succès.
Captures GPU vérifiées. Deux APK v87 installés et validés sur Galaxy A16 :
« Oui, AOE-002-FIX1 validée ». Gambits, équipe et réglages conservés, vérifiés par empreinte.
Clôture documentaire uniquement, code et APK identiques à la recette validée.
Commit local et sauvegarde complète restaurée/vérifiée ; aucun push automatique.
Prochain GO : UI-005. Détails : docs/steps/AOE-002-FIX1.md.
Les états ci-dessous sont historiques.

# AOE-002 validée — 30 octobre 2026

GO reçu pour Météore : 3 s d’incantation, puis 1 s de chute, puis 1 s d’explosion.
40 PM et recharge de 4 s engagés au lancement ; les ennemis actuellement dans le
disque fixe de rayon 1,4 subissent chacun 40 PV au début de l’explosion, sans défense.
La chute suit le temps de combat, sans accélération Booster ; pause respectée.
L’effet lancé survit à la mort d’Anne, mais pas à la fin du combat ni à son reset.
Icône fournie intégrée ; traînée rouge/rose profond, explosion procédurale et fondu
commun. Profil C « Intense » choisi dans Godot (remplace le choix B initial).
Le cercle de préparation reste optionnel via « Afficher zone AOE ».
76 scènes / 5 752 contrôles réussis ; captures GPU vérifiées. Dernières retouches
artistiques vérifiées dans Godot et banc Météore ciblé. Android v86 validé :
« Oui, AOE-002 validée ». Jeu normal et laboratoire séparé installés sur Galaxy A16.
Gambits, équipe et réglages conservés, vérifiés par empreinte avant/après installation.
Clôture documentaire uniquement, code et APK identiques à la recette validée.
Commit local et sauvegarde vérifiée ; aucun push automatique. Prochain GO : UI-005.
Détails : docs/steps/AOE-002.md. Les états suivants sont historiques.

# AOE-001 validée — 30 octobre 2026

Anne possède Attaque, Soin et Météore. Météore : 40 PM, 40 PV retirés par ennemi
sans réduction de défense, incantation 3 s, recharge 4 s à partir du lancement
effectif, rayon 1,4 et portée universelle des sorts de 4 unités.
Le critère « Groupe de 3 ou plus » maximise exactement le nombre d’ennemis couvrables
avec le rayon de la capacité associée, puis centre le groupe par son disque minimum.
Pendant l’approche, tous les gambits restent prioritaires dans leur ordre normal.
Le point est verrouillé au début du cast ; les victimes sont celles présentes à
l’impact, sans nouvelle optimisation. Une zone vidée coûte quand même les 40 PM.
Aucun dégât aux alliés, aucune dépendance à la vie d’un ennemi ciblé.
75 scènes / 5 733 contrôles réussis, dont 195 géométriques et 68 de mécanique/laboratoire.
Godot GPU vérifié. Jeu normal et laboratoire séparé v85 validés sur Galaxy A16 :
« Oui, AOE-001 validée ». Le laboratoire ne lit ni n’écrit les sauvegardes du jeu normal.
Les gambits existants ne sont pas modifiés.
Icône vectorielle fonctionnelle et effets d’incantation existants ; effet Météore final
réservé à AOE-002. Le cercle or d’incantation est conservé en production avec la case
« Afficher zone AOE », activée par défaut et mémorisée dans les réglages de combat.
Détails : docs/steps/AOE-001.md et docs/aoe-roadmap.md.
Clôture documentaire uniquement : code, ressources et deux APK identiques à la recette.
Commit local et sauvegarde complète restaurée/vérifiée. Aucun nouveau test ni relevé FPS.
Prochain GO : AOE-002 ; puis UI-005 et STEP-029/030. Aucun push automatique.
Les états suivants sont historiques.

# TEAM-002 validée — 30 octobre 2026

Appui long de 450 ms sur une carte, puis dépôt sur une autre pour échanger les deux
emplacements, y compris avec Vide. Clic bref : fiche du héros. Aperçu 2D léger et
contour or uniquement pendant le geste ; style, cadrages et tailles Idle conservés.
Chaque échange est sauvegardé immédiatement. Formation, panneaux et ciblage Allié
utilisent ce nouvel ordre au prochain combat ; les gambits restent liés aux héros.
Glissement précoce, relâchement hors carte, retour Android, redimensionnement,
deuxième doigt et perte de focus annulent sans clic résiduel. Échec d’écriture :
ancien ordre conservé avec un message bref.
Les barres de sorts sont cyan clair (#8befff), dans les panneaux et au-dessus
des personnages. La préparation dorée et la récupération argentée de l’attaque
restent inchangées, avec leur épée.
73 scènes / 5 444 contrôles réussis, dont 97 dédiés aux gestes et à la persistance.
Godot GPU vérifié ; APK 0.1.0-team002 (84) validé sur Galaxy A16 : « Oui, étape validée ».
Laboratoire : scenes/debug/team_reorder_lab.tscn ; détails : docs/steps/TEAM-002.md.
Clôture documentaire uniquement : code, ressources et APK identiques à la recette.
Commit local et sauvegarde complète restaurée/vérifiée. Aucun nouveau test ni relevé FPS.
Prochain GO : UI-005, qualification intégrée, puis STEP-029/030. Aucun push automatique.
Les états précédents ci-dessous sont historiques.

# TEAM-001 validée — 30 octobre 2026

Nassau rejoint Mako et Anne : 160 PV, 60 PM, attaque 14, défense 4, vitesse 1,2,
régénération 5 PM/s. Booster et ses gambits sont transférés depuis Mako ; Mako garde
Attaque/Foudre. Composition initiale Mako, Anne, Nassau, Vide, transmise aux cartes,
panneaux, ciblage Allié et quatre positions fixes au bas de l’octogone.
Les cartes occupées conservent leur style précédent ; seul le cadre de la case vide
est harmonisé. Nassau descend légèrement dans sa miniature Idle sans changement de taille.
Migration v3 → v4 avec copie .v3.bak, 100 lignes préservées et sauvegarde atomique.
72 scènes / 5 344 contrôles réussis ; 87 contrôles ciblés après centrage final.
Version Android 83 validée sur Galaxy A16 : « Oui, étape validée ».
Clôture documentaire uniquement : code, ressources et APK identiques à la recette.
Commit local et sauvegarde complète restaurée/vérifiée ; aucun nouveau test ni relevé FPS.
APK `team-001-debug.apk`, SHA-256
`b6f7670d04f043072c897be5c1275f89cb1ea940ffd83a1d9a8055747f88e9ea`.
Détails : `docs/steps/TEAM-001.md`. Au prochain GO : TEAM-002,
appui long et échange des cartes. Aucun push automatique.
Les états précédents ci-dessous sont historiques.

# MATERIALS-001 validée — 30 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, étape validée » pour le profil
C « Peint contrasté », choisi dans Godot puis installé en version 82.
Héros, ennemis et miniatures Idle partagent les matériaux mats et l’éclairage
bleuté/chaud. Les textures et GLB restent intacts ; le profil est isolé de la logique.
14 scènes ciblées / 937 contrôles avaient réussi, dont 80 dédiés.
La clôture actualise seulement les documents : code, ressources, configuration
et APK identiques à la livraison validée. Aucune nouvelle mesure FPS ni relance des tests.
APK `0.1.0-materials001` (82), SHA-256
`f58a09e0ed0cd9fe0986e2ec2aaaaf51c161a2858de9d4e3c21f6df49be9102c`.
Clôture par commit local et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Détails : `docs/steps/MATERIALS-001.md`. Prochain GO : UI-005, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# ATTACK-BARS-001 validée — 29 octobre 2026

Le propriétaire confirme : « Étape validée. » après installation de la version 81
sur Galaxy A16. L’attaque normale expose sa préparation dorée et sa récupération
argentée dans la ligne d’incantation des panneaux et au-dessus des unités.
L’épée fixe sépare les phases au moment exact du coup : 0,6 s / 0,4 s de temps
personnel. La progression suit Booster et la pause. Les réglages d’affichage
des barres s’appliquent aussi à cette jauge. La logique de combat reste inchangée.
70 scènes / 5 166 contrôles réussis, dont 61 dédiés. Rendu Android vérifié et
validé par le propriétaire. Aucun nouveau relevé FPS.
APK installé : `0.1.0-attackbars001` (81), SHA-256
`e9a2ba7ada291e539640b227e39543ef30f4bcff93b62edb688ce698913e7a87`.
Clôture par commit local et sauvegarde restaurée/vérifiée. Aucun push automatique.
Détails : `docs/steps/ATTACK-BARS-001.md`. Prochain GO : UI-005 puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# PORTRAITS-001 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, étape validée » pour la version
corrigée : Mako remonté dans Équipe et Combat, Anne inchangée, cadres Idle plus petits
avec modèles conservés à leur taille initiale et buffs horizontaux au bas des panneaux.
Les PNG fournis sont intacts. Les cadrages et fenêtres de présentation sont indépendants
de la logique de jeu. Les 69 scènes / 5 105 contrôles et la recette tactile Android
avaient réussi. Gambits et réglages sont conservés octet pour octet ; pause vérifiée.
Clôture documentaire uniquement : code, ressources, configuration et APK identiques
à la livraison validée. Aucun nouveau test ni mesure de performances à cette clôture.
APK installé : `0.1.0-portraits001-layout` (80), SHA-256
`fd47a9d30effb17185507dac7b3739c71693efd4fcb8630bdfe9d227deb44ad6`.
Clôture par commit local et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# PORTRAITS-001 — Illustrations des héros — en recette

Base ARENA-005 clôturée : `0ee76d488ba1dc8d12c8b99c513a464c161604ec`.
Mako et Anne utilisent les PNG fournis à l’identique. La page Équipe présente chaque
illustration avec son petit cadre 3D Idle superposé à l’angle inférieur droit,
débordant de 12 px à droite et en bas de l’image, dans l’emplacement de carte réservé.
Les cadres Idle sont resserrés par clipping du viewport initial : aucune modification
de la projection ni de la taille des modèles à l’écran. Mako est remonté dans les deux
cadrages 2D ; le cadrage d’Anne reste celui de la première proposition.
En combat, un portrait rapproché occupe la colonne gauche ; les buffs s’alignent
horizontalement sous les barres. Les quatre panneaux mesurent 110 px de haut pour
garder une vraie marge sous les buffs. Présentation partagée, sans changement de combat.
69 scènes / 5 105 contrôles réussis. Validation visuelle Android attendue avant commit.
APK `0.1.0-portraits001-layout` (80), `portraits-001-layout-debug.apk`, SHA-256 :
`fd47a9d30effb17185507dac7b3739c71693efd4fcb8630bdfe9d227deb44ad6`.
Détails : `docs/steps/PORTRAITS-001.md`. Après clôture : UI-005, qualification intégrée Android.
Les états précédents ci-dessous sont historiques.

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

# ARENA-005 — Domaine octogonal commun et calage des images

ArenaBounds définit le même octogone convexe pour tous les acteurs et tous les décors.
Huit plans de support et une projection sur les huit segments bornent les déplacements.
L’inrayon de 3√2 conserve l’emprise projetée de la zone agrandie précédente ; la marge
0,35 est retirée de chaque plan pour protéger le disque complet du personnage.
GroundMover et GroundCrowd utilisent ce domaine commun. LocalNavigator utilise une
AStarGrid2D interne 39×39 à pas 0,2, dont les cellules hors octogone érodé sont solides.
Les extrémités des raccourcis sont validées ; la convexité garantit tout le segment.
Les budgets de recherche par tick, intervalle de replanification et règles d’obstacles
entre personnages restent inchangés. Les coins de la boîte englobante sont inaccessibles.
Arena.gd fixe la caméra à 45°. ArenaPage cadre seulement le domaine et la hauteur des
modèles dans la zone centrale. Aucun calcul de taille ou position de caméra ne dépend
du fond. IllustratedArenaView n’agit plus sur la caméra : image_center et grid_half_size
produisent uniquement un décalage et une échelle uniforme du PNG. Le ratio reste 9:16.
ArenaCatalog ajoute les deux profils et miniatures sans précharger les grands fonds.
ArenaChoice conserve son RNG visuel indépendant. Les dix images restent intactes.
La calibration des fonds est dans calibration/arena_calibration.json. Les SVG et le
laboratoire projettent la même géométrie et coupent la grille à l’octogone. Aucun réglage
de grille n’apparaît dans le produit. Les vues techniques de référence suivent aussi
le contour commun.
InfiniteSchedule place les héros sur le bord sud érodé, Mako à gauche, Anne à droite.
Les six ennemis préfèrent deux rangées de trois au nord, puis les premiers points
libres du demi-terrain nord si des héros les occupent. Les six places sont validées
avant spawn atomique. Les héros conservent leurs positions et états entre vagues.
Les anciennes fixtures d’icônes et d’abandon placent explicitement une cible à portée,
indépendamment du nouveau placement de départ. La fixture EnemyDirector suit les
nouveaux bords du domaine commun. Les sections suivantes sont historiques.

# ARENA-004 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, step validée » pour les dégâts
flottants blancs sur les ennemis, rouges sur les héros et les soins verts inchangés.
Animation commune du soin, trois options indépendantes et mémorisées, encart compact
« Textes flottants » avec fond noir à 25 % d’opacité. Le combat continue dans les réglages.
Les 66 scènes / 4 501 contrôles et la recette Android avaient déjà réussi ; les deux
bancs initialement en dépassement de délai ont réussi leur relance isolée.
Clôture documentaire uniquement : code, ressources, configuration et APK identiques
à la livraison validée. Aucune nouvelle exécution des tests ni mesure de performances.
APK installé : `0.1.0-arena004-layout` (74), SHA-256
`8f4231a9e1b35767b1be019b622516014db95068272c0f2043310abccf8a1d2a`.
Gambits conservés octet pour octet ; préférences initiales rétablies après la recette.
Clôture par commit et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# ARENA-004 — Textes de combat passifs et réglages

`floating_combat_text.gd` extrait la présentation du nombre de soin : Label3D,
police 48, pixel_size 0,006, contour 5, progression acceptée et enveloppe commune.
HealEffect utilise ce composant sans modifier ses anneaux ni son glow. CombatPresenter
consomme les impacts déjà résolus et les PV réellement perdus : couleur selon le
camp de la cible, jamais selon le lanceur. Les bindings copient désormais aussi le
camp. Aucun appel vers les acteurs/exécuteurs depuis ces textes.
Les nombres de dégâts suivent la position graphique de leur cible puis restent au
dernier emplacement si elle meurt ; durée 1 s, dérive 0,24 unité et fondu identiques
au soin. Léger décalage des impacts successifs pour les distinguer. Au plus 48 nombres
de dégâts simultanés ; nettoyage à expiration, désactivation de la présentation et
nouveau combat. Aucun effet sur les statistiques, le journal, les coûts ou les PV.
CombatSettings ajoute trois booléens au groupe floating_text du ConfigFile existant.
Types invalides ou clés absentes : true. L’interface reflète les cinq options sans
émettre de changement. Les réglages des textes émettent un signal séparé des barres.
L’encart compact fait partie de la liste défilante ; titre et OK restent accessibles.
TouchScrollRouter reçoit ce scroller quand les réglages sont ouverts et continue de
supprimer les taps issus d’un swipe ou de la copie souris d’un événement tactile.
Les textes actifs sont masqués immédiatement par leur option sans supprimer le soin
visuel ; les textes masqués continuent de vieillir. Les préférences survivent au replay.
Les descriptions précédentes ci-dessous sont historiques.

# ARENA-003 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, step validée » pour les statistiques,
le MVP et le journal. Deux boutons indépendants sans chevron ; menus pleine largeur,
statistiques en colonnes Héros / Ennemis. Bordures alignées sur les panneaux héros,
espace inférieur de 12 px. MVP magenta, score dégâts effectifs + soins effectifs.
Journal continu des 1 000 dernières entrées en RAM, Direct et pause/lecture intégrée.
Horodatages mm:ss.mmm, mentions de non-paiement retirées et récupération d’Attaque omise.
Les 65 scènes / 4 451 contrôles et la recette Android avaient déjà réussi.
Clôture documentaire seule : code, ressources, configuration et APK identiques à
la livraison validée ; aucune nouvelle exécution des tests ni mesure de performances.
APK installé : `0.1.0-arena003-journal` (70), SHA-256
`0d33882137b374f25164d328a33f5642b28e6b66510982666002221af2e225dc`.
Gambits conservés octet pour octet ; pause et scroll du journal vérifiés sur Galaxy.
Clôture par commit et sauvegarde complète restaurée/vérifiée. Aucun push automatique.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# ARENA-003 — Observation de combat et deux menus indépendants

`CombatReport` est un RefCounted à valeurs, sans référence d’acteur ni ressource de
présentation. PartySimulation lui transmet les faits immuables déjà produits par
PartyExecutor : identifiants, séquences, PV réellement modifiés, PM réellement payés,
états de cible/lanceur et durées. La validation/paiement reste dans l’exécuteur.
Les expirations de buffs sont détectées autour de l’avancement de leur état réel.
Les révisions séparent les données statistiques et les entrées du journal.
Deux héros et les six ennemis courants sont conservés ; la nouvelle vague supprime
seulement les fiches ennemies. Le journal est un cache RAM FIFO fixé à 1 000 entrées,
effacé au nouveau combat. Aucun fichier, ConfigFile ou archivage du journal.
`CombatStatisticsMenu` compose deux panneaux exclusifs commandés chacun par son bouton
ArenaPage. Statistiques pleine largeur, deux colonnes avec scrolls indépendants et
dessin virtualisé. Le journal pleine largeur utilise un ScrollContainer et un
RichTextLabel continu : ajout des nouvelles entrées et retrait des paragraphes évincés.
Direct suit la fin ; une remontée manuelle suspend le suivi. Le bouton pause/lecture
émet une demande à ArenaPage, qui conserve les gardes d’application et la pause de
simulation sans afficher le menu Pause. Les deux vues restent hors des panneaux héros.
Le journal omet la récupération de l’attaque et les mentions de non-paiement ;
son horodatage de présentation utilise mm:ss.mmm. Aucun temps de simulation modifié.
Les boutons/tablette, feuille, pause et lecture sont des SVG locaux de présentation.
MVP : PV effectifs infligés + PV effectifs soignés ; égalité départagée par dégâts,
puis ordre d’équipe. Aucun score si tous les héros sont à zéro. Badge magenta #ff00ff.
Les descriptions précédentes ci-dessous sont historiques.

# ARENA-002 validée — 29 octobre 2026

Le propriétaire confirme sur Galaxy A16 : « Oui, step validée » pour les réglages de
combat et les huit arènes sans quadrillage blanc. Engrenage de 30 px, intérieur bleu
nuit, contour or, sans cadre, zone tactile de 48 px alignée au bord droit central.
Menu translucide, titre or, options PV / PM / Incantation indépendantes pour héros et
ennemis, actives par défaut et mémorisées immédiatement. OK compact et combat continu.
Compteur agrandi à 22 px, texte strict « Vague N », y compris après une défaite.
Les 64 bancs / 4 321 contrôles et la recette Android avaient déjà réussi.
Clôture documentaire uniquement : code, ressources, configuration et APK restent
identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-arena002-layout` (66), SHA-256
`4e3f7734f3135fa32210e318b0dcb46efdaa66854626512c082f8b39364a5ef8`.
Gambits conservés octet pour octet ; réglages persistants et gel de la pause vérifiés.
Clôture par commit et sauvegarde complète restaurée/vérifiée.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Aucun push automatique. Les états précédents ci-dessous sont historiques.

# ARENA-002 — Réglages de combat et décors sans grille — en recette

Base GRAPHICS-014 clôturée : `62cc34bfc23249b96c5e1cc38684dabc9e8326e0`.
Le 29 octobre 2026, engrenage seul agrandi à 30 px, zone tactile 48 px alignée au bord
droit du rectangle central, sans marge supplémentaire.
Intérieur bleu nuit, contour or, extérieur transparent ; aucun fond ni cadre de bouton.
Menu translucide assorti aux panneaux héros, deux cases indépendantes pour les barres
flottantes des héros et des ennemis, actives par défaut, effet et sauvegarde immédiats.
Combat maintenu en cours ; bouton OK compact, centré, ajusté au texte, qui ferme le menu.
Options libellées PV / PM / Incantation ; titre « Réglages de combat » en or #ffd16a.
Compteur de vagues agrandi à 22 px : texte strict « Vague N », même après une défaite.
Les panneaux bas et leurs barres restent visibles. Menu absent hors arène.
Les huit fonds et miniatures sont remplacés par des variantes sans quadrillage blanc,
créées avec imagegen intégré. Aucune option de grille. Joints naturels conservés,
caméra et coordonnées de jeu inchangées. Qualification dans `docs/steps/ARENA-002.md`.
Validation complète de l’étape attendue avant commit et sauvegarde de clôture.
Prochain GO après clôture : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

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

# GRAPHICS-014 — Énergie d’incantation — en recette

GRAPHICS-013 clôturée : `b497548d283849af42aa821a52ed9a51711eb095`.
Le 29 octobre 2026, ajout d’un fin contour bleu sur la silhouette des héros pendant
l’incantation et de huit particules flottantes attirées vers le lanceur. Choix validé
dans le laboratoire Godot : B — Équilibré (intensité 0,65). Fin immédiate à la résolution,
à l’annulation, à la mort ou à la fin du combat ; aucun effet pendant la récupération.
Présentation seule : aucun changement de ciblage, coûts, durées ou états de combat.
63 bancs / 4 215 contrôles réussis, dont 24 sur le cycle de vie de cette présentation.
APK normal `0.1.0-graphics014` (64) ; laboratoire séparé exporté. APK installé sur Galaxy A16, gambits inchangés et gel de la pause vérifiés.
Validation complète de l’étape attendue avant commit et sauvegarde de clôture.
Prochain GO après clôture : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-013 validée — 29 octobre 2026

Le propriétaire confirme « Step validée. » après approbation du cadrage sur Galaxy A16.
Icônes Discret dans les compétences et gambits ; icône d'incantation au bord droit
fixe de la barre des panneaux héros. Portraits retirés, buffs verticaux en haut à
gauche au padding commun. Grille 2×2 en bas avec quatre panneaux identiques ; arène
légèrement dézoomée et recadrée au-dessus, compteur de vagues au-dessus de la grille.
Les 62 bancs / 4 191 contrôles et la recette Android avaient déjà réussi.
Clôture documentaire uniquement : code, ressources, configuration et les deux APK
restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-graphics013-layout` (63), SHA-256
`e43cc09f1411c2e9ecd1b76fe97237bae6f9894f9eabf3dd56c0965219066a91`.
Gambits conservés. Le laboratoire a été exporté ; seule la version normale du dernier
cadrage a été installée et validée. Clôture par commit et sauvegarde complète vérifiée.
Prochain GO : UI-005, qualification intégrée Android, puis STEP-029/030.
Aucun push automatique. Les états précédents ci-dessous sont historiques.

# GRAPHICS-013 — Grille basse et cadrage Android approuvé — en recette

Le 28 octobre, le propriétaire valide sur Galaxy A16 : « Oui, ce cadrage me convient ».
Arène légèrement dézoomée (base 8 %) et cadrée au-dessus de la grille 2×2 placée en bas.
Quatre panneaux strictement identiques : 106 px de hauteur, ancrage à 12 px du bas de la
zone sûre, compteur de vagues juste au-dessus. Pause reste en haut à droite.
Le décor, les personnages et leurs barres partagent la même projection ; le cadrage
s'adapte aux petits formats. Les icônes Discret, les buffs verticaux au padding commun
et l'absence de portraits sont conservés. Aucun changement de logique de jeu.
62 bancs / 4 191 contrôles réussis. APK normal `0.1.0-graphics013-layout` (63) installé :
`e43cc09f1411c2e9ecd1b76fe97237bae6f9894f9eabf3dd56c0965219066a91`.
Gambits conservés ; gel de la pause et SHA installé vérifiés. La validation du cadrage
est acquise ; clôture complète de GRAPHICS-013 après validation de l'étape.
Prochain GO après clôture : UI-005, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-013 — Icônes Discret et colonne de buffs — en recette

Le propriétaire a retenu A — Discret, puis demandé la suppression des portraits des
panneaux de combat et des buffs empilés verticalement en haut à gauche. Padding hérité
du panneau : 14 px à gauche, 8 px en haut. Icônes d'incantation 16 px au bord droit fixe
de la barre ; buffs actifs 14 px dans l'ancien espace du portrait. Panneaux conservés
à 106 px, bloc terminé à y=292 et compteur à y=300, avant décalage de zone sûre.
Fiches : icônes 40 px ; gambits et menus : 16 px. Les trois PNG fournis restent intacts.
Catalogue et ressource de style séparés de la logique ; aucun changement de combat.

62 bancs / 4 191 contrôles réussis, dont 67 spécifiques. Aperçus GPU et recette Galaxy
A16 réalisés ; APK normal réinstallé, gambits conservés octet pour octet.
APK normal `0.1.0-graphics013` (62), SHA-256
`545af3b45c59d234df5fe12b10ae181133fd031cfc4497fa7e3d1233b26173c4`.
Étape en attente de validation utilisateur avant commit/sauvegarde de clôture.
Après clôture : UI-005, qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# MODE-INFINI-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le premier mode Infini : vagues de six,
attente de trois secondes, compteur, départs sud-ouest/nord-est et nouveau décor aux
vagues 11, 21, 31… avec conservation des héros et de leurs états.
Les 61 bancs / 4 124 contrôles et la recette Godot/Galaxy A16 avaient déjà réussi.
Clôture documentaire uniquement : code, scènes, profils, configuration et les deux APK
restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-infinite001` (61), SHA-256
`7b4346c28e9b056f0f3cbaf0e32925e571f8f5ac99fcc964f9ada82071c5afcd`.
Gambits conservés. Clôture par commit et sauvegarde complète restaurée/vérifiée.
Prochain GO : UI-005, qualification intégrée Android incluant le mode Infini, puis
STEP-029/030. Aucun push automatique. Les états précédents ci-dessous sont historiques.

# MODE-INFINI-001 — Premier mode Infini — en recette

Après FIX-COMBAT-001 clôturée (`7d8530d`), le bouton d'accueil « Mode Infini » ouvre
le seul mode produit disponible. Vagues simultanées de six squelettes, sans limite de
vagues ni victoire automatique ; défaite lorsque tous les héros sont morts, ou abandon
confirmé. Héros au sud-ouest au départ, ennemis au nord-est. La vague suivante apparaît
après trois secondes de combat, uniquement après élimination complète de la précédente.
Compte à rebours central or à bordure bleue, compteur sous les quatre panneaux héros.
L'arène initiale est aléatoire puis change pour une autre aux vagues 11, 21, 31…
Aucune réinitialisation des héros entre vagues/décors : PV, mana, buffs, positions,
actions et recharges continuent normalement ; pause et arrière-plan figent le délai.
Les laboratoires et anciens modes techniques gardent leurs contrats historiques.

61 bancs / 4 124 contrôles réussis, dont 70 pour ce mode. Aperçus GPU et recette
Galaxy A16 effectués ; APK normal remis, gambits conservés octet pour octet.
APK `0.1.0-infinite001` (61), SHA-256
`7b4346c28e9b056f0f3cbaf0e32925e571f8f5ac99fcc964f9ada82071c5afcd`.
Validation utilisateur attendue avant commit/sauvegarde. Prochaine étape après clôture :
UI-005, qualification Android incluant le mode Infini, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# FIX-COMBAT-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le reciblage après annulation d'une
incantation et les squelettes sans mana ni barre bleue. Les 60 bancs / 4 054 contrôles
et les 24 contrôles natifs sur Galaxy A16 avaient déjà réussi ; gambits conservés.
Clôture documentaire uniquement : code, scènes, profils, shader, configuration et
les deux APK restent identiques à la livraison validée. Pas de nouvelle exécution des tests.
APK normal installé : `0.1.0-fix-combat001` (60), SHA-256
`934a920feb9a906756f2325e5c56ec47c987229497edf5135fa35094271fb824`.
Clôture par commit et sauvegarde complète restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030. Aucun push automatique.
Les états précédents ci-dessous sont historiques.

# FIX-COMBAT-001 — Annulation et squelettes sans mana — en recette

Correctif demandé après GRAPHICS-012 clôturée (`ea1a3e4`). Une incantation interrompue
avant sa résolution libère désormais sa recharge : le prochain pas de combat peut
sélectionner une nouvelle cible et relancer le sort, sans débit de mana ni récupération
résiduelle. Les recharges des autres capacités et celles des sorts déjà résolus restent
intactes, y compris lorsque l'impact tue sa propre cible. Cadence des sorts réussis conservée.
Les squelettes ont 0 mana et 0 régénération ; leur barre bleue disparaît. Les héros
conservent leurs ressources et le rendu GRAPHICS-012. Le laboratoire des néons respecte
également ces caractéristiques réelles.

60 bancs / 4 054 contrôles réussis, dont 24 nouveaux contrôles de régression. Les 24
contrôles passent aussi sur Galaxy A16 ; combat, rendu et gel de la pause vérifiés.
Gambits enregistrés identiques octet pour octet. APK normal corrigé installé :
`0.1.0-fix-combat001` (60), SHA-256
`934a920feb9a906756f2325e5c56ec47c987229497edf5135fa35094271fb824`.
Étape en attente de validation utilisateur, avant commit/sauvegarde. UI-005 reste ensuite
prévue pour la qualification intégrée Android, puis STEP-029/030.
Détails et recette : [FIX-COMBAT-001](docs/steps/FIX-COMBAT-001.md).
Les états précédents ci-dessous sont historiques.

# GRAPHICS-012 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les panneaux héros enrichis : textes
blancs PV/mana et sort/temps restant, PV/mana en dix segments, incantation continue,
portions vides renforcées. Panneaux Lumineux et barres flottantes B conservées.
59 bancs / 4 030 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, profils, shader, configuration et
les deux APK restent identiques à la livraison validée. Les tests ne sont pas relancés.
Gambits conservés ; affichage et compte à rebours vérifiés, APK normal remis sur le Galaxy.
APK normal 0.1.0-graphics012 (59), SHA-256
`9aaa8c30283c291c8c7d8ca53fb68156b810bfe997dc83a3fc4be869dfe7d858`.
APK laboratoire 0.1.0-graphics012-lab (59), SHA-256
`5c43e9ed890ac77d61d6863a5c59719f505a485d5899614a7d946973a298e525`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-012 — Textes et segments des panneaux héros — en recette

Demande du propriétaire après GRAPHICS-011 clôturée (`fdf9f6e3e5086861794bf1d546e4abcaee1e6f76`,
766 fichiers vérifiés). Rendu Godot ajusté puis approuvé : panneaux en néon Lumineux,
barres flottantes conservées en B. Textes blancs PV actuels / maximums, mana actuelle /
maximum et nom du sort / secondes restantes. Espacement augmenté sans chevauchement.
PV et mana divisés en dix segments, fractions conservées ; incantation continue.
Les portions vides gardent la teinte de la barre, assombrie mais nettement visible.
Longueurs inchangées. Aucune modification des valeurs ou de la logique de combat.

59 bancs / 4 030 contrôles réussis sans erreur ni avertissement moteur, dont 29 nouveaux
contrôles des textes, valeurs, espacement, styles et compte à rebours avec Booster.
Aperçus GPU et recette native Galaxy A16 dans la livraison. Aucun nouveau benchmark FPS.
APK normal 0.1.0-graphics012 (59), SHA-256
`9aaa8c30283c291c8c7d8ca53fb68156b810bfe997dc83a3fc4be869dfe7d858`.
APK laboratoire 0.1.0-graphics012-lab (59), SHA-256
`5c43e9ed890ac77d61d6863a5c59719f505a485d5899614a7d946973a298e525`.
F6 : `scenes/debug/neon_bars_lab.tscn` pour l'instantané et le combat avec ce rendu.
Détails : [GRAPHICS-012](docs/steps/GRAPHICS-012.md). L'accord Godot concerne le rendu ;
validation finale de l'étape attendue avant commit et sauvegarde de clôture.
Après clôture et prochain GO : UI-005, puis STEP-029/030. Les états précédents sont historiques.

# GRAPHICS-011 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » après le choix B — Fin et lisible : barres
néon fines, largeur monde 42 → 29,4 (−30 %), panneaux à longueur inchangée avec un trait
légèrement plus épais. Profil visuel commun et glow discret, sans scintillement.
58 bancs / 4 001 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, ressources, shader, configuration et
les deux APK restent identiques à la livraison validée. Les tests ne sont pas relancés.
Gambits conservés ; rendu clair/sombre et combat vérifiés sur le Galaxy, APK normal remis.
APK normal 0.1.0-graphics011 (58), SHA-256
`937951eb510873159c201e43eed516e4dc88d59793e914e32c23b06bc571f887`.
APK essais 0.1.0-graphics011-lab (58), SHA-256
`8ead02ad9e147bd7afe99d5845e53f3f56bc3076dab76459b3196fb10c4d8e49`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-011 — Barres néon fines — en recette

Demande directe du propriétaire après GRAPHICS-010 clôturée (`eec1310a599051e5391740efcedd733c575e3078`,
756 fichiers vérifiés). Nouvelle étape visuelle avant UI-005. Le propriétaire choisit
B — Fin et lisible parmi les trois essais Godot ; ce choix ne vaut pas encore clôture.
Barres au-dessus de tous les héros et ennemis : longueur 42 → 29,4 (−30 %), trait de
1,25 au lieu de 3,5. Panneaux : même rendu, trait de 1,9 au lieu de 5, longueur inchangée.
PV rouges, mana bleue et incantation dorée facultative, léger glow local sans scintillement.
Profil visuel commun, sans modification des valeurs, de la logique ou du HUD hors combat.

58 bancs / 4 001 contrôles existants réussis sans erreur ni avertissement moteur.
Captures GPU A/B/C sur arènes claire et sombre : quatre barres de monde à 29,4 et deux
panneaux conservant leur largeur de 171 sur le viewport 540×960. Aucun nœud orphelin.
Recette Android et preuves dans la livraison ; aucun nouveau benchmark FPS.
APK normal 0.1.0-graphics011 (58), SHA-256
`937951eb510873159c201e43eed516e4dc88d59793e914e32c23b06bc571f887`.
APK laboratoire 0.1.0-graphics011-lab (58), SHA-256
`8ead02ad9e147bd7afe99d5845e53f3f56bc3076dab76459b3196fb10c4d8e49`.
F6 : `scenes/debug/neon_bars_lab.tscn` pour comparer A/B/C, arène claire/sombre et combat.
Détails : [GRAPHICS-011](docs/steps/GRAPHICS-011.md). Validation utilisateur attendue avant
commit et sauvegarde de clôture. Prochain GO après clôture : UI-005, puis STEP-029/030.
Les descriptions précédentes ci-dessous sont historiques.

# GRAPHICS-010 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » après le choix B — Équilibré : montre dorée
procédurale translucide de 2 s, aiguilles accélérées, suivi de cible et fondu partagé.
Le soin garde son rendu et sa durée de 1 s ; la logique des buffs reste inchangée.
58 bancs / 4 001 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, ressources, configuration et deux APK
restent identiques à la livraison validée. Les tests moteur ne sont pas relancés.
Gambits du téléphone conservés ; réglage B vérifié sur le Galaxy et APK normal remis.
APK normal 0.1.0-graphics010 (57), SHA-256
`593592a564cd8b5b2493875f799c4aed43aed77cd039395ad65c43eff2c4417d`.
APK essais 0.1.0-graphics010-lab (57), SHA-256
`2f52538443d4f35d2a61c4ea01c1451522edc170d79a00116a14aa0032975eb9`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée Android, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

# GRAPHICS-010 — Montre Booster et fondu partagé — en recette

GO reçu après BUFFS-002 clôturée `1d2d66a8a3e6356ae4867b0e1727776bb1b28d27`
(sauvegarde restaurée, 738 fichiers vérifiés). Montre dorée procédurale translucide,
deux aiguilles accélérant rapidement, durée de 2 s et fondu commun avec le soin.
Le propriétaire choisit B — Équilibré dans le laboratoire A/B/C. Ce choix de rendu
ne constitue pas encore la validation de clôture de GRAPHICS-010.

La montre suit la cible et regarde la caméra ; elle apparaît uniquement sur un fait réel
buff_applied réussi. Doublons, annulations, décès, disparition, pause et reset sont gérés.
Les matériaux sont privés et le nombre d'effets borné. Le soin garde sa durée de 1 s,
son intensité et ses anneaux : seule sa formule d'opacité est extraite, à résultat identique.
Aucune logique de buff, de mana, de ciblage ou de temps personnel n'est modifiée.
58 bancs / 4 001 contrôles réussis sans erreur ni avertissement moteur ; 152 contrôles
dédiés au fondu et à la montre. Aperçus GPU PC et recette Android dans la livraison.
Aucun nouveau benchmark FPS. Les gambits enregistrés restent conservés.
APK normal 0.1.0-graphics010 (57), SHA-256
`593592a564cd8b5b2493875f799c4aed43aed77cd039395ad65c43eff2c4417d`.
APK laboratoire 0.1.0-graphics010-lab (57), SHA-256
`2f52538443d4f35d2a61c4ea01c1451522edc170d79a00116a14aa0032975eb9`.
F6 : `scenes/debug/booster_watch_lab.tscn` pour les essais visuels A/B/C, ou
`scenes/debug/booster_lab.tscn` pour les vrais gambits Mako → Anne avec la montre.
Détails : [GRAPHICS-010](docs/steps/GRAPHICS-010.md). Validation attendue avant commit et
sauvegarde de clôture. Prochain GO après clôture : UI-005, qualification intégrée Android,
puis STEP-029/030. Les descriptions précédentes sont historiques.

# BUFFS-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour Booster dans les compétences et les
Gambits de Mako : 20 mana, cast 1,5 s, ×1,30 pendant 60 s de combat normal, aucune
recharge dédiée, sans cumul ni renouvellement. Allié cible Mako puis Anne en ignorant
les porteurs du même buff ; mana insuffisante → gambit suivant. Débit au succès réel.
57 bancs / 3 849 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour cette clôture : code, scènes, profils, configuration, assets et APK
restent identiques à la livraison validée. Aucun nouveau test moteur nécessaire.
Gambits du téléphone conservés ; laboratoire isolé disponible pour la séquence complète.
APK normal 0.1.0-buffs002 (56), SHA-256
`a53bc49cf29fc2f7e16a2331619055740863f56990c39f0b3a574302d9933ce5`.
APK laboratoire 0.1.0-buffs002-lab (56), SHA-256
`df954bbd424f0354d7a0396b7c7a697c42624173c5565360522cbb2ca5e9766f`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : GRAPHICS-010,
montre dorée procédurale et fondu partagé avec le soin, puis UI-005.
Les états précédents ci-dessous sont historiques.

# BUFFS-002 — Booster jouable via les gambits — en recette

GO reçu après clôture de BUFFS-001 `eac9a39eb14c040dde5d3fc4a3477809d8a4829b`
(sauvegarde restaurée, 727 fichiers vérifiés). Mako possède Attaque, Foudre et Booster ;
Anne conserve Attaque et Soin. Booster : 20 mana, cast 1,5 s, portée 4, récupération
habituelle et aucune recharge dédiée, ×1,30 pendant 60 s de combat normal.
Les critères classent les cibles ; le buff écarte celles qui portent déjà Booster, même
si elles sont ennemies. Toute indisponibilité ou mana insuffisante fait passer au gambit
suivant. Débit uniquement à la résolution réussie, jamais sur une annulation ou un doublon.

57 bancs / 3 849 contrôles réussis sans erreur ni avertissement moteur, dont 118 contrôles
dédiés à Booster. Aperçu GPU PC piloté : Duck, Mako puis Anne, 40 mana dépensés, fiche et
contrôles libérés sans nœud orphelin. Recette Android et preuves dans la livraison.
Aucun nouveau benchmark FPS. Pas de modification automatique des gambits sauvegardés.
APK normal 0.1.0-buffs002 (56), SHA-256
`a53bc49cf29fc2f7e16a2331619055740863f56990c39f0b3a574302d9933ce5`.
APK laboratoire 0.1.0-buffs002-lab (56), SHA-256
`df954bbd424f0354d7a0396b7c7a697c42624173c5565360522cbb2ca5e9766f`.
F6 : `scenes/debug/booster_lab.tscn` ; le preset isolé place Allié → Booster avant les
anciens ordres et journalise les vraies applications. Le jeu normal conserve les ordres
existants ; programmer Booster depuis la fiche de Mako. Détails :
[BUFFS-002](docs/steps/BUFFS-002.md). Validation utilisateur attendue avant commit et
sauvegarde de clôture. Prochain GO après clôture : GRAPHICS-010, montre dorée procédurale
et fondu partagé avec le soin ; puis UI-005. Les états précédents sont historiques.

# BUFFS-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le socle des buffs et du temps personnel.
Attaques, incantations, récupération, recharges, déplacements et modèles utilisent le
pas propre à chaque acteur ; mana, durée des buffs et effets autonomes gardent le temps
normal. Laboratoire isolé conservé ; aucune nouvelle compétence dans le jeu à cette étape.
56 bancs / 3 719 contrôles et recette tactile Galaxy A16 déjà réussis. Seuls les documents
sont actualisés pour la clôture, sans relancer les tests : code, scènes, configuration,
assets et APK demeurent identiques à la livraison validée. Gambits Android conservés.
APK normal 0.1.0-buffs001 (55), SHA-256
`5a13e0b27641d448bd6a5ce7ffd4e3a54fe432cea0693a80f8c97c39c09c0851`.
APK laboratoire 0.1.0-buffs001-lab (55), SHA-256
`5efb3f08aeaf0cc3a314b08e2ab30ab6256173b2d5021a54e1c184e0af880d78`.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : BUFFS-002,
Booster dans les compétences de Mako et les gambits, puis GRAPHICS-010 et UI-005.
Les états précédents ci-dessous sont historiques.

# BUFFS-001 — États de buffs et temps personnel — en recette

GO reçu après clôture de GAMBITS-003 `6b527253c086861f8d8108e75498487169230817`
(sauvegarde restaurée, 716 fichiers vérifiés). Buffs de combat séparés des définitions,
horloge propre à chaque participant, expiration sur le temps normal du combat.
Attaques, incantations, récupération, recharges, déplacement et animations suivent
le temps personnel ; mana, vagues, collisions et VFX autonomes gardent leur temps normal.
Aucun buff appliqué par défaut dans le jeu, aucune nouvelle compétence à cette étape.
Booster jouable et son filtrage des cibles appartiennent à BUFFS-002 ; montre à GRAPHICS-010.

56 bancs / 3 719 contrôles réussis sans erreur ni avertissement moteur, dont 75 nouveaux.
Aperçu GPU PC piloté et recette tactile Galaxy A16 : comparaison des casts, mana,
pause figée et reprise explicite au retour d'arrière-plan. Aucun benchmark FPS.
APK normal 0.1.0-buffs001 (55), SHA-256
`5a13e0b27641d448bd6a5ce7ffd4e3a54fe432cea0693a80f8c97c39c09c0851`.
APK laboratoire 0.1.0-buffs001-lab (55), SHA-256
`5efb3f08aeaf0cc3a314b08e2ab30ab6256173b2d5021a54e1c184e0af880d78`.
L'APK normal est remis sur le téléphone, gambits d'origine identiques octet pour octet.
F6 : `scenes/debug/personal_time_lab.tscn` ; recette et architecture détaillées dans
[BUFFS-001](docs/steps/BUFFS-001.md). Étape en attente de validation avant commit et
sauvegarde de clôture. Prochain GO après clôture : BUFFS-002, puis GRAPHICS-010 et UI-005.
Les descriptions précédentes ci-dessous sont historiques.

# GAMBITS-003 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » : critère Allié sans condition, ordre
Mako puis Anne parmi les vivants, lanceur compris, et candidats classés préparés
pour les buffs. Catalogue de onze critères, sauvegarde v3 immédiate conservée.
Résultats de la recette précédente : 55 bancs / 3 644 contrôles réussis et recette
tactile Android ; réglages d'origine restaurés. Aucun nouveau test moteur pour
cette clôture documentaire, aucune modification du code ou de la configuration.
APK validé : 0.1.0-gambits003 (54), SHA-256
`cbe4b7c0b65b9f305aab866c1d563b40f900b1a3902088d24294e3cfa5a086a5`.
Les fichiers temporaires de livraison et l'APK local de la recette précédente ne
sont plus disponibles ; leur empreinte ci-dessus est celle consignée à la livraison.
La clôture sauvegarde les sources et l'historique Git, sans recréer cet APK.
Prochain GO : BUFFS-001 (états de buffs et horloge personnelle), puis BUFFS-002,
GRAPHICS-010 et UI-005. Les descriptions antérieures ci-dessous sont historiques.

# GAMBITS-003 — Critère Allié et ordre d'équipe — en recette

Roadmap Allié / Booster validée par le GO du propriétaire. Première étape implémentée :
critère « Allié » sans condition, candidats ordonnés et rang d'équipe explicite. Mako précède
Anne, y compris si Anne est le lanceur. L'ordre de traitement Anne puis Mako ne change pas.
Catalogue de onze critères ; sauvegarde immédiate v3 et défaut Ennemi proche conservés.
55 bancs / 3 644 contrôles réussis sans erreur ni avertissement moteur ; captures GPU PC
et recette Android dans la livraison. Aucun nouveau benchmark FPS.
APK 0.1.0-gambits003 (54), SHA-256 `cbe4b7c0b65b9f305aab866c1d563b40f900b1a3902088d24294e3cfa5a086a5`.
Base clôturée : ARENA-001 `15bf1f5cc21c1334491f3fa43e2cc04edd9f30bc` (706 fichiers vérifiés).
Le plan préparé après cette clôture est inclus dans la livraison de GAMBITS-003.
Étape en attente de validation, commit et sauvegarde vérifiée. Prochain GO : BUFFS-001,
puis BUFFS-002, GRAPHICS-010, UI-005 et STEP-029/030. Booster et l'horloge personnelle
ne sont pas encore implémentés. Les états précédents ci-dessous sont historiques.

# ARENA-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour l'arène épurée : Pause, quatre panneaux
passifs Mako / Anne / Vide / Vide, portraits et barres, suppression des anciennes commandes
et de la sélection. Menu Reprendre / Rejouer / Abandonner, confirmation avant l'accueil.
APK 0.1.0-arena001 (53), SHA-256
`08b675affdafd61effb941737381e0458792705796807bf64978b1f921651293`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 54 bancs / 3 592 contrôles déjà réussis ne sont pas
relancés. Recette tactile Android réussie, pause visuellement figée et gambits inchangés.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée prolongée Android, puis STEP-029/030. GAMEPLAY-003 reste annulée.
Les états précédents ci-dessous sont historiques.

# ARENA-001 — Arène épurée et menu Pause — en recette

GO reçu pour retirer les commandes et informations de combat, sauf Pause et quatre panneaux
passifs en haut. Grille Mako / Anne puis Vide / Vide, portraits fixes et barres PV rouges,
mana bleue et incantation dorée lorsqu'un sort est en cours. Barres au-dessus des acteurs
conservées, pastille jaune de sélection supprimée. Bas de l'écran dégagé.
Pause suspend le combat et propose Reprendre, Rejouer, Abandonner ; l'abandon exige une
confirmation avant l'accueil. Retour Android ouvre Pause, puis revient d'abord au menu
si une confirmation est affichée. Les gambits se programment depuis la fiche hors combat.
54 bancs / 3 592 contrôles réussis sans erreur ni avertissement moteur ; recette GPU PC et
native Android dans la livraison. Aucune nouvelle mesure FPS.
APK 0.1.0-arena001 (53), SHA-256 `08b675affdafd61effb941737381e0458792705796807bf64978b1f921651293`.
Base validée : HOME-001 `5d08abec22a8513c10447a6d5ec5b5233e76d7e8`, sauvegarde restaurée
et vérifiée (696 fichiers). ARENA-001 attend validation avant commit et sauvegarde de clôture.
Après clôture et prochain GO : UI-005, qualification intégrée, puis STEP-029/030.
Les états précédents ci-dessous sont historiques.

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

# GAMBITS-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la refonte intégrée et sa passe stylistique.
APK 0.1.0-gambits002 (49), SHA-256
`8ca94f2f17f5624e9724f5225d3774932933d312d4ff22efb878c32a19e5a95f`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 53 bancs / 3 497 contrôles réussis ne sont pas
relancés. Les essais Android couvrent les listes, l'autosauvegarde, 100 ordres et la reprise.
Téléphone rendu à l'accueil avec les ordres d'origine migrés, dont Anne 80 % → 70 % ;
copie v2 protégée conservée. Aucun nouveau benchmark FPS.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : UI-005,
qualification intégrée prolongée Android, puis STEP-029/030. GAMEPLAY-003 reste annulée.
Les états précédents ci-dessous sont historiques.

# GAMBITS-002 — en recette — 27 octobre 2026

Le jeu F5 utilise désormais le catalogue de dix critères de ciblage fixes et les capacités
indépendantes. Éditeur partagé entre fiche et combat, 0–100 ordres par héros, sauvegarde
immédiate de chaque changement, sans Appliquer/Annuler. Ligne unique : activation verte /
croix rouge, chevrons, critère, capacité, corbeille. Ajouter et compteur sous la liste.
Passe stylistique réalisée : bleu nuit, bordures or, menus ivoire/orange, sur le fond fourni.

53 bancs / 3 497 contrôles réussis sans erreur ni avertissement moteur. Recette visuelle GPU
PC et gestes Android documentés dans la livraison. Aucun nouveau benchmark FPS.
APK 0.1.0-gambits002 (49), SHA-256 `8ca94f2f17f5624e9724f5225d3774932933d312d4ff22efb878c32a19e5a95f`.
Base clôturée : GAMBITS-001 `307030fc500dbdf076adaee95b984edfbf3b6d16`, sauvegarde
`gambit-arena-20261027-081032-307030fc500d.tar.gz`, restaurée et vérifiée (678 fichiers).
Cette étape attend la validation utilisateur avant commit et sauvegarde de clôture.
Ensuite : UI-005, qualification intégrée prolongée Android, puis STEP-029/030.
GAMEPLAY-003 reste annulée. Les états précédents ci-dessous sont historiques.

# GAMBITS-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le nouveau modèle et son laboratoire
isolé. Validation globale, sans précisions supplémentaires. APK normal 0.1.0-gambits001 (48),
SHA-256 `b2a8e4defb65f46d41ebbd4f91cf57dcf85c8d066f58291943cad4d06e1c073e`.
APK laboratoire 0.1.0-gambits001-lab (48), SHA-256
`bfa7b4781efa728a54ebebaf5cefa71facd46a1adc07d8a13e85050bbe4eeb97`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et les deux APK
restent identiques à la livraison validée. Les 52 bancs / 3 461 contrôles déjà réussis ne
sont pas relancés. Aucune nouvelle mesure FPS. Règles de jeu Android v2 conservées.
Clôture par commit unique et sauvegarde restaurée/vérifiée. Prochain GO : GAMBITS-002,
bascule du combat et des éditeurs, sauvegarde immédiate sans Appliquer/Annuler, 100 ordres.
Le jeu normal conserve UI-004 en v2 jusqu'à cette bascule. Puis UI-005 et STEP-029/030.
GAMEPLAY-003 reste annulée. Les mentions de recette ci-dessous sont historiques.

# GAMBITS-001 — Modèle et laboratoire en recette — 27 octobre 2026

GO reçu pour la première étape de refonte. Catalogue des dix critères fixes, ordres à
critère/capacité indépendants, listes de 0 à 100 par héros, résolution déterministe et
codec v3 avec migration v2 et sauvegarde protégée. Écriture immédiate par héros, sans
workflow Appliquer/Annuler dans le nouveau modèle. Anne 80 % devient 70 % en migration.
F6 : scenes/debug/gambits_criteria_lab.tscn. Ce banc isolé résout des instantanés et écrit
uniquement user://gambits_v3_lab.json ; il ne lance aucun soin/attaque/sort réel.
F5 et l'APK normal conservent intégralement le jeu et l'éditeur UI-004 en v2, y compris leurs
anciennes commandes : la bascule du combat et de l'interface est GAMBITS-002, pas cette étape.
52 bancs / 3 461 contrôles réussis ; captures GPU PC et laboratoire Android vérifiés.
APK normal 0.1.0-gambits001 (48), SHA-256 `b2a8e4defb65f46d41ebbd4f91cf57dcf85c8d066f58291943cad4d06e1c073e`.
Téléphone remis sur l'accueil de l'APK normal ; règles de jeu Android identiques à l'origine.
Voir docs/gambits-model.md et docs/steps/GAMBITS-001.md. En recette, non commitée.
Après validation : clôture et sauvegarde vérifiée, puis GO pour GAMBITS-002 et UI-005.
GAMEPLAY-003 reste annulée. Les états précédents ci-dessous sont historiques.

# Précision de périmètre — sauvegarde immédiate des gambits

Demande du propriétaire : aucune commande Appliquer/Annuler dans la refonte. Chaque
changement est enregistré immédiatement, y compris ajout, suppression et réordonnancement.
Retour conserve les modifications. Interface sobre, sans confirmation ni message de réussite
à chaque action. Ce comportement concerne la refonte GAMBITS-001/002 ; le checkpoint UI-004
reste inchangé tant que cette refonte n'est pas implémentée.

# Refonte des gambits proposée — 27 octobre 2026

Demandes et précisions du propriétaire : Critère de ciblage + capacité, dix critères fixes,
alliés incluant soi-même, sélection de l'allié au plus faible pourcentage de PV, ennemis
classés par PV actuels absolus, associations libres, 0 à 100 ordres par héros. Migration
des seuils vers le plus grand seuil disponible inférieur ou égal (Anne 80 → 70).
Plan : GAMBITS-001 (catalogue/modèle/migration isolés), GAMBITS-002 (bascule combat et
éditeurs sur une ligne avec ajout/suppression), puis UI-005 étendue à la recette intégrée.
Voir docs/gambits-refactor-roadmap.md. Plan proposé, aucun code ou APK modifié. Attendre
validation du découpage et GO. UI-004 reste le checkpoint fonctionnel 2f1e9b9603d7.
Les périmètres antérieurs ci-dessous sont historiques s'ils décrivent les trois règles v2.

# UI-004 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les gambits hors combat et le correctif
Équipe : cartes en accès direct, sans sélection persistante. Validation globale sans
précisions supplémentaires. APK normal 0.1.0-ui004 (47), SHA-256
`527b5cb468049fef6bd421ec4b756d85edc0c6cf950278085f957024b13f74b7`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 49 bancs / 3 028 contrôles déjà réussis ne sont pas
relancés. Aucune nouvelle mesure FPS. Les réglages Android initiaux restent conservés.
Clôture par commit unique et sauvegarde restaurée/vérifiée. UI-005, recette intégrée du
parcours complet PC/Android, attend le prochain GO ; puis STEP-029 et STEP-030.
GAMEPLAY-003 reste annulée. Les mentions de recette ci-dessous sont historiques.

# UI-004 — Gambits hors combat et correctif Équipe en recette — 27 octobre 2026

GO reçu après UI-003 clôturée au commit `c8497aac5760bc4672c80cdff7f80745749e3a49`.
F5 → Équipe → héros → Gambits : trois règles éditables, activation, ordre, compétence,
condition et seuil. Appliquer enregistre et revient à la même fiche ; Annuler/Retour
abandonnent le brouillon. Même fichier party_rules_v2.json et validation que le combat.
L'arène recharge ces règles ; les modifications d'un héros préservent celles de l'autre.
Correctif demandé : plus de texte, surlignage ou état de sélection persistant dans Équipe.
Les cartes ouvrent directement leur fiche ; le retour libère leur focus. Identité conservée
uniquement pour router la bonne fiche et les gambits. Fonds et thème nuit/or conservés.
49 bancs / 3 028 contrôles réussis ; captures GPU PC et recette native Galaxy A16.
APK 0.1.0-ui004 (47), SHA-256 `527b5cb468049fef6bd421ec4b756d85edc0c6cf950278085f957024b13f74b7`.
Téléphone laissé sur les gambits d'Anne ; réglages Android initiaux rétablis à l'identique
après essais de sauvegarde/annulation/relance. Aucun changement de logique de combat.
Voir docs/gambits-page.md et docs/steps/UI-004.md. Validation attendue, aucun commit UI-004.
Après validation : commit et sauvegarde vérifiée ; GO suivant pour UI-005, puis STEP-029/030.
GAMEPLAY-003 reste annulée. Les états précédents ci-dessous sont historiques.

# UI-003 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les fiches de personnage, avec un correctif
UX demandé pour la prochaine étape UI-004 : supprimer le surlignage et le texte de sélection
sur Équipe, ainsi que leur persistance au retour. Les cartes deviennent de simples accès
aux fiches ; l'identifiant du héros reste transmis pour ouvrir la bonne fiche et ses gambits.
Ce correctif est planifié, pas appliqué dans la clôture de UI-003.
APK normal 0.1.0-ui003 (46), SHA-256
`2d10e45f9d5622a479def8ad64e4f2e38083527c3613ea010bcb5052b364d6f0`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 47 bancs / 2 920 contrôles déjà réussis ne sont pas
relancés. Aucune nouvelle mesure FPS. Clôture par commit unique et sauvegarde vérifiée.
UI-004 attend le prochain GO : gambits hors combat et correctif Équipe ci-dessus.
GAMEPLAY-003 reste annulée. Les mentions de recette ci-dessous sont historiques.

# UI-003 — Fiches de personnage en recette — 27 octobre 2026

GO reçu après UI-002 clôturée au commit `2d3787fc1aeb50a69a6dfb77ae7744cce723573d`.
F5 → Équipe → Mako/Anne : fiche du bon héros, PV/mana maximums, attaque, défense, vitesse,
régénération et compétences de référence. Fond fourni et thème bleu nuit/or conservés.
Défilement tactile, retour Équipe par bouton/Échap/Android, sélection retenue. Les aperçus
Idle restent arrêtés derrière la fiche ; aucune simulation n'est créée pour sa lecture.
Le bouton Gambits en bas est désactivé jusqu'à UI-004. Aucun éditeur hors combat livré ici.
47 bancs / 2 920 contrôles réussis ; captures GPU PC et recette tactile native Galaxy A16.
APK normal 0.1.0-ui003 (46), SHA-256 `2d10e45f9d5622a479def8ad64e4f2e38083527c3613ea010bcb5052b364d6f0`.
Installé sans effacement des données ; téléphone laissé sur la fiche d'Anne.
Voir docs/hero-page.md et docs/steps/UI-003.md. Étape non commitée, validation attendue.
Après validation : commit et sauvegarde vérifiée ; prochain GO pour UI-004, puis UI-005,
STEP-029 et STEP-030. GAMEPLAY-003 reste annulée. Les états suivants sont historiques.

# UI-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la page Équipe : Mako/Anne en Idle,
deux places vides, sélection et retours. Validation globale sans détail supplémentaire.
APK normal 0.1.0-ui002 (45), SHA-256
`88d5de3adf6e6cdf4b686548418d14f4cd30047f0dbd15b8d51a38c11943ab04`.
Seuls les documents sont actualisés ; code, scènes, assets, configuration et APK restent
identiques à la livraison validée. Les 45 bancs / 2 816 contrôles déjà réussis ne sont pas
relancés. Aucune nouvelle mesure de performance. Clôture par commit unique et sauvegarde
restaurée/vérifiée ; prochain GO : UI-003, fiches de personnage en valeurs de référence.
Les fiches et les gambits hors combat ne sont pas encore implémentés. GAMEPLAY-003 reste
annulée. Les mentions de recette ci-dessous décrivent les états historiques.

# UI-002 — Équipe en recette — 27 octobre 2026

GO reçu après clôture de UI-001 au commit `01481bad6e02514c2edc3758838a7b0ee81e8365`.
F5 → Équipe : grille 2 × 2, Mako puis Anne animés en Idle et deux places « Vide ».
Fond fourni et cartes/bouton Accueil en surimpression bleu nuit/or. Un appui sur le modèle
ou sa carte sélectionne son identifiant stable et affiche son nom ; les fiches attendent UI-003.
Deux aperçus passifs au plus, arrêtés en arrière-plan et libérés au retour. Aucune simulation
sur Équipe ; ordre logique du combat et sauvegardes conservés. GAMEPLAY-003 reste annulée.
45 bancs / 2 816 contrôles réussis ; captures PC et recette tactile native sur Galaxy A16.
APK normal 0.1.0-ui002 (45), SHA-256 `88d5de3adf6e6cdf4b686548418d14f4cd30047f0dbd15b8d51a38c11943ab04`.
Installation avec conservation des données ; téléphone laissé sur Équipe, Anne sélectionnée.
Voir docs/team-page.md et docs/steps/UI-002.md. Étape non commitée, en attente de validation.
Après validation : clôture et sauvegarde vérifiée, puis nouveau GO pour UI-003, UI-004,
UI-005, STEP-029 et STEP-030. Les états précédents ci-dessous sont historiques.

# UI-001 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour l'accueil, le thème, les retours et les
arènes aléatoires. APK normal 0.1.0-ui001 (44), SHA-256
`0c18f5936ca60e5bda292f364501a5a765c834f9827ff07b9b560cb33ee615fa`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 43 bancs / 2 718 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. Prochaine étape UI-002 :
page Équipe avec Mako, Anne et deux places vides ; attendre un nouveau GO.
GAMEPLAY-003 reste annulée. Les mentions de recette suivantes sont historiques.

# UI-001 — composition de l'application

AppRoot possède l'accueil et une ArenaPage temporaire. La scène de combat historique reste
inchangée ; la page produit en dérive pour sa composition, son thème et son tirage visuel.
Arène est libérée au retour et recréée à l'entrée, avec les règles sauvegardées existantes.
ArenaChoice a son propre RNG ; décor et caméra conservent leur calibration en plein écran.
Le thème est centralisé dans resources/ui/night_gold.tres. Les deux fonds fournis sont sous
assets/art/ui/. Équipe/Fiche/Gambits restent des routes futures, sans simulation cachée.
Voir docs/app-navigation.md. Les sections suivantes sont historiques.

Précisions du propriétaire (27 octobre 2026) : tous les boutons sont superposés aux fonds
sur toutes les pages, avec thème bleu nuit/bleu profond et or/orange ambré. Chaque nouveau
combat, y compris Rejouer, choisit une des huit arènes illustrées au hasard. UI-001 intègre
ces exigences, UI-005 les recettera. Roadmap documentaire ; attendre GO avant implémentation.

# Architecture proposée pour les pages (non implémentée)

Voir docs/app-pages-roadmap.md. Une racine de navigation ouvrira l’accueil, l’équipe,
la fiche, les gambits et le combat. Quitter l’arène détruira le combat ; y revenir en créera
un nouveau avec les gambits sauvegardés. Les aperçus Idle utiliseront les vues passives,
sans simulation de combat. Profils et métadonnées de compétences alimenteront les fiches
en lecture seule. L’éditeur sera réutilisable par identifiant de héros, avec la validation
et la sauvegarde existantes. L’ordre des cartes ne modifiera pas l’ordre logique des acteurs.
Le point d’entrée F5 passera à l’accueil ; la scène/UID du combat existant restera préservée.
Les sections suivantes décrivent l’architecture actuellement implémentée et son historique.

# GRAPHICS-009 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour le soin vert fluo à deux anneaux tournants.
APK normal 0.1.0-graphics009 (43), SHA-256
`fc84f63d53b40a9246b3d7466a32833026545ef8c4968b668fbe16881be16fc9`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 41 bancs / 2 574 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette suivantes retracent les états historiques.

# GRAPHICS-009 — remplacement du visuel de soin

HealEffect conserve son contrat passif setup(profile, healed) / advance_visual(dt).
Deux anneaux concentriques à axes distincts, coques et aura de glow additif composent
l'effet d'une seconde ; toutes les composantes suivent le temps accepté et le fondu.
HealEffectDefinition contient le style, les tailles et les rotations. CombatPresenter,
la cible réelle, le moteur de jeu, les gabarits et les ombres ne changent pas.
Voir docs/heal-presentation.md. Les sections suivantes sont historiques.

# GRAPHICS-008 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les disques d'ombre indiquant le gabarit.
APK 0.1.0-graphics008 (42), SHA-256
`3cb968ff960280aece6b1636edd06f34fd33120eb7c429a89f5806011f11d8cc`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 40 bancs / 2 541 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette et de réduction des gabarits suivantes sont historiques.

# GRAPHICS-008 — empreinte de présentation

StatsActor fournit GroundCrowd.RADIUS à CharacterView. La vue crée un FootprintShadow,
un PlaneMesh dont le shader ne conserve qu'un disque translucide de diamètre 2 × rayon.
Le modèle et le disque sont des enfants distincts : le modèle peut changer d'échelle ou de
pose sans fausser l'emprise physique indiquée au sol. Style dans CharacterDefinition,
shader et composant isolés ; pas de nouvelle collision ni de callback de simulation.
GAMEPLAY-003 est annulée : gabarits et navigation de GAMEPLAY-002 conservés.
Voir docs/ground-shadows.md. Les sections suivantes sont historiques.

# GAMEPLAY-002 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour la livraison du contournement local partagé.
APK normal 0.1.0-gameplay002 (41), installé sur Galaxy A16 et laissé en pause.
SHA-256 APK : `105021ffe77922674c6a9c90be8cd60a79f5a8cbd748776ff76bcf1e1e6d0505`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets et configuration identiques à la livraison validée ; seuls les documents
sont actualisés. Les 39 bancs / 2 481 contrôles et 28 cas Android déjà réussis ne sont pas
relancés pour cette clôture documentaire. Clôture par un commit unique puis sauvegarde
restaurée/vérifiée. GAMEPLAY-003 (gabarits plus fins) attend un nouveau GO.
Les mentions de recette et de préparation suivantes décrivent les états historiques.

# GAMEPLAY-002 — navigateur partagé dans PartyUnit

Chaque unité possède un LocalNavigator sans références de scène. PartySimulation transmet
positions, cible et portée, répartit une recherche par pas en rotation et applique ensuite
GroundCrowd. Le résultat réel alimente progression, état/facing et animation. Les actions
actives et l'arrivée à portée figent l'approche. Mort/replay invalident les routes ; le temps
suit GameClock. La grille native est petite et les recherches espacées. Les colliders/images,
les règles et la présentation ne pilotent pas le routage. Voir docs/local-navigation.md.
Les sections suivantes sont historiques.

# Navigation locale et gabarits — architecture prévue

GAMEPLAY-002 prévoit un composant de navigation partagé par PartyUnit et ses déplacements,
qui reçoit cible/portée et propose un trajet court ; GroundCrowd reste l'autorité finale
pour les contacts. Le navigateur ne choisit aucune cible et ne dépend pas des modèles.
GAMEPLAY-003 réduira ensuite les empreintes logiques et les profils visuels séparément,
avec des valeurs cohérentes pour contacts/navigation/bords/spawn. Cette architecture est
planifiée, non implémentée. Voir docs/local-navigation-plan.md. Les sections suivantes
décrivent l'implémentation déjà livrée.

# GRAPHICS-007 — qualification sans dépendance du gameplay

Un laboratoire distinct compose Main avec des règles en mémoire et contrôle les variantes
artistiques. Le collecteur borné de STEP-028 est réutilisé, avec les callbacks physiques et
processus normaux. Les modèles/exemples d'éclair sont des ressources remplaçables ; les
traces comparatives vérifient l'identité des valeurs du jeu. Les outils d'inventaire,
d'export diagnostique isolé et de synthèse des mesures ne sont pas appelés par Main.
Voir docs/graphics-qualification.md. Les sections suivantes sont historiques.

# GRAPHICS-006 — présentation de Foudre

CombatPresenter compose un LightningPresenter indépendant qui ne reçoit que des faits
et des instantanés de présentation. Il gère la préparation suivie et les frappes détachées
à la position de résolution, même sur coup fatal. Deux scènes passives et un profil Resource
portent l'apparence ; un shader local dessine le glow et de petits ArrayMesh regroupent
les branches/étincelles. Le temps est fourni explicitement ; aucun appel de combat ni RNG
global. Voir docs/lightning-presentation.md. Les sections suivantes sont historiques.

# GRAPHICS-005 — présentation du soin

CombatPresenter consomme les événements heal résolus avec soin positif ; le halo n'a
aucune référence au combat. HealEffect reçoit profil, montant et temps accepté. Un profil
Resource référence une PackedScene remplaçable. CharacterDefinition fournit l'origine par
modèle. Les effets suivent les instantanés de cible, restent bornés et sont nettoyés par le
présentateur. Voir docs/heal-presentation.md. Les sections suivantes sont historiques.

# GRAPHICS-004 — transitions et vues d'action

PartyExecutor publie des faits de transition, PartySimulation les copie avec run_id et
collecte les morts. CombatPresenter applique l'instantané d'action avant les réactions,
consomme une seule fois les faits et transfère uniquement la vue graphique lors d'une mort.
CharacterView échantillonne les clips manuellement avec priorité explicite ; aucune piste
ne rappelle le jeu. La fin visuelle terminale respecte pause/focus sans avancer le combat.
Voir docs/combat-presentation.md. Les paragraphes suivants sont historiques.

# GAMEPLAY-001-fix1

PartyRules inclut la source dans les candidats du soin et partage prefer_heal avec les
commandes manuelles (ratio de PV, puis distance et identité). PartyExecutor ne débite plus
à request : le débit est dans _apply_effect après les gardes d'AttackAction, avant les
signaux de santé. La résolution est déjà verrouillée, ce qui interdit un double débit.
Voir docs/steps/GAMEPLAY-001-fix1.md ; les conventions antérieures ci-dessous sont historiques.

# GAMEPLAY-001 — équipe, exécuteurs et HUD composés

Main instancie PartyApplication, qui compose PartySimulation, PartyUnit, PartyExecutor,
PartyRules et OverheadBars. Les profils de combat sont séparés des CharacterDefinition.
La simulation détient incantation, mana, effets et cibles ; les barres ne lisent que des
valeurs. AttackAction expose portée/préparation/récupération surchargeables, avec ses
valeurs historiques par défaut. Voir [l'architecture d'équipe](docs/party-gameplay.md).
L'ancienne composition ArenaApplicationLab reste dans graphics003_reference.tscn pour
les régressions et le banc de mesure historique. Les sections suivantes sont historiques.

# Actualisation — GRAPHICS-003 en recette

StatsActor est désormais Node3D avec une vue enfant facultative. CharacterDefinition décrit
l'art ; CharacterView lit Idle/Walk en mode manuel. ArenaApplicationLab compose les profils
et transmet le temps de simulation accepté. Le mannequin reste un repli et la vue nulle
est testée. Voir [la présentation des personnages](docs/character-presentation.md).
Les paragraphes suivants décrivent les étapes précédentes ; la mention d'un héritage
StatsActor/ProxyActor à extraire est remplacée par cette implémentation.

# Architecture actuelle — GRAPHICS-002 validée

ArenaApplicationLab → PerformanceLab → ApplicationLab est maintenant le sommet de la chaîne
de Main. La couche de composition connaît ArenaCatalog et ArenaPicker ; la simulation ne
connaît ni le catalogue ni les fichiers artistiques. Le sélecteur modal réutilise le routeur
tactile et le garde Android, remet le jeu en pause et remplace seulement la vue ArenaFloor.
Les grandes textures se chargent à la sélection ; le menu utilise huit vignettes distinctes.
La galerie sans combat partage le même catalogue et le même composant de sélection.

Depuis la base STEP-028 / 580ce64, ArenaFloor est une façade de présentation possédant une
ArenaView interchangeable. La Resource exportée `Arena.arena_definition` choisit la scène
de fond : Main utilise Colisée solaire, les anciens labs gardent la référence procédurale.
La vue reçoit seulement caméra et taille de viewport ; elle ne possède aucune référence à la
simulation. Le dessin des repères/pieds reste dans ArenaFloor, au-dessus de la vue et sous
le rendu 3D. La caméra, les dimensions jouables et les exécuteurs sont inchangés.
Voir docs/arena-presentation.md. La séparation des modèles de personnages est prévue dans
GRAPHICS-003 ; leur héritage actuel n'est pas encore refactorisé.

Référence : `665c0c8d86a6400f88c77773295ed06b1a518206`. Cette synthèse de passation remplace
les formulations de livraison des étapes précédentes. STEP-028 ajoute la couche de mesure
décrite ci-dessous, sur la base documentaire cc91c79.

## Scène d’entrée et héritage UI

project.godot lance scenes/main.tscn (UID conservé), qui instancie
scenes/performance/performance_lab.tscn. Chaîne des scripts :

PerformanceLab → ApplicationLab → RunLifecycleLab → WaveSequenceLab → WaveLab → ManualCommandLab →
SkillSlotsLab → PortraitHudLab → GambitFieldsLab → GambitEditorLab → BattleLab → Arena.

Les couches parent construisent l’arène et le HUD, les couches dérivées ajoutent leurs
fonctions. Beaucoup de méthodes sont virtuelles et appelées pendant le _ready parent :
respecter setup_complete/editor_ready/hud_ready/slots_ready/manual_ready et les contrôles
is_node_ready. Les laboratoires historiques peuvent être lancés seuls par F6.

Arena possède le SubViewport 3D, caméra, mannequins initiaux, lumières et HUD. BattleLab
remplace les mannequins par la simulation. Le parent graphique du monde n’est pas forcément
le coordinateur ; ce dernier nettoie donc les acteurs dans _exit_tree.
Les constantes de modes des anciens labs ne doivent pas être confondues avec les libellés
actuels des trois vagues.

## Simulation et données

| Composant | Responsabilité / fichier |
|---|---|
| CombatSimulation | Seul coordinateur des ticks, acteurs, arrivées, transitions et fins ; scripts/combat/combat_simulation.gd |
| GameClock | Temps de jeu, pause/stopped, dt borné ; scripts/core/game_clock.gd |
| ActorProfile / ActorState | Resource de configuration puis état indépendant d’acteur ; scripts/combat/ |
| CombatUnit | Mover, exécuteur, identité, mémoire de cible offensive, présentation |
| GroundMover / GroundCrowd | Approche de la cible fournie et séparation déterministe bornée ; scripts/movement/ et scripts/crowd/ |
| AttackAction | Identité, préparation/récupération, latch d’impact, portée et annulations |
| SkillExecutor | Coûts, cooldowns, ressource et effets uniques ; scripts/skills/skill_executor.gd |
| GambitSnapshot / Evaluator | Valeurs capturées et évaluation pure sans effet ; scripts/gambits/ |
| GambitController | Intentions 10 Hz, revalidation et engagement via exécuteur |
| ManualCommands | Une attente de 3 s, remplacement/revalidation/priorité ; scripts/manual/manual_commands.gd |
| WaveSchedule | Calendrier d’arrivées borné sans acteurs ; scripts/waves/wave_schedule.gd |

Ordre du tick : observer une éventuelle mort préalable ; filtres pause/temps ; prune et
fin/transition ; horloge ; intention manuelle sinon gambits ; cibles ennemies ; mouvement
et séparation ; actions engagées (héros puis ennemis stables) ; prune et fin/transition ;
engagement manuel sinon automatique ; nouveaux engagements ennemis ; arrivées ; présentation.
Un nouvel acteur ou une action nouvellement engagée ne reçoit pas rétroactivement le dt.
Le héros ne marche pas si son action est active ou si sa cible sélectionnée vit à portée.

La cible offensive de CombatUnit est indépendante du mouvement et de l’intention du moment.
focused_enemy valide source/état, cible/état, appartenance au combat et portée. Le contrôleur
restreint le snapshot à cette cible ; ManualCommands la préfère à nearest. Un soin ne l’efface
pas. La mémoire est nettoyée à la fin/replay, sans changer le comportement en combat.

## Coûts et annulations

SkillExecutor est le seul point d’engagement. Le débit précède l’exécution et n’est pas
répété à l’impact. AttackAction ne peut appliquer son effet qu’une fois pour action_id.
Les signaux de mort/sortie et identités ActorState invalident les participants périmés.
retire annule définitivement un ancien exécuteur ; il ne peut pas affecter une nouvelle partie.
Une action payée annulée ne récupère pas automatiquement son coût. Pas de résurrection par soin.

ManualCommands.submit mémorise source/cible/états et deadline GameClock. Une commande
invalide n’écrase pas une attente valide. Busy/cooldown/énergie/soin inutile/approche peuvent
attendre jusqu’à expiration. La mort/sortie invalide les références et les connexions sont
nettoyées. Une file prioritaire n’interrompt jamais l’action engagée.

## Vagues et fins

wave_enabled préserve les anciens laboratoires ; sequence_enabled active trois vagues.
Normal/Soin : quota 12 par vague, cap 6 ; Charge : quota 24, cap 20.
WaveSchedule ne confirme issued qu’après une création réussie. Saturation/bord occupé ne
consomment pas le budget et ne stockent qu’une arrivée due, jamais une rafale.

spawned, defeated et removed sont cumulés sur la partie ; wave.issued est local à la vague.
Après prune : spawned = defeated + removed + vivants. Des bases mémorisées calculent les
vaincus/retirés locaux. Serial d’ennemi est global à la partie. completed_waves contient au
plus trois instantanés scalaires. La transition remet seulement le calendrier local à zéro,
conserve le héros et réapplique le délai initial d’une seconde.

La défaite précède la transition/victoire. Une suppression externe entraîne INTERROMPU
à la fin de vague, pas une victoire. _end_run est unique : horloge arrêtée, actions retirées,
cibles/commandes annulées puis bilan figé. final_report renvoie une copie de valeurs.
run_id et terminal_count servent aux diagnostics. Rejouer recrée acteurs/états, efface
compteurs, vagues, traces et bilan ; garde règles et pause. clear/_exit_tree assurent le nettoyage.

## Interface, scroll et application

PortraitHudLab calcule les zones sûres via HudLayout, réorganise status/arène/footer/modal
et utilise des ScrollContainer dont la hauteur de contenu est explicite. Les hauteurs
minimales réelles des contrôles doivent être respectées. L’éditeur ouvre la pause et ne
reprend pas automatiquement en fermant ; son brouillon n’est appliqué qu’explicitement.
SkillAvailability décrit la disponibilité sans effet ; ManualCommandLab active les commandes.

TouchScrollRouter possède les séquences tactiles commençant dans une liste active.
Au-delà de 12 pixels logiques, le geste reste un swipe. Appui court valide : une émission
pressed au relâchement. La copie souris device -1 est consommée ; souris physique/molette
restent natives. Multi-touch, annulation, zone invalide, replay et arrière-plan annulent l’appui.

ApplicationGuard est ajouté en dernier pour recevoir _input avant le routeur/GUI. Il suit
focus et suspension séparément, bloque les entrées pendant l’absence, et refuse les drags/
relâchements/répétitions sans nouvel appui. ApplicationLab force la pause, annule les gestes,
recalcule le layout au retour et attend Reprendre. Le premier pas actif après cette reprise
est écarté ; ensuite GameClock reprend sans temps mural. Un formulaire et un bilan terminal
conservent leurs garanties. _notification est distribué par Godot aux classes de l’héritage :
ne pas rajouter super._notification, qui dupliquerait le traitement.

## Documentation détaillée et points d’entrée

PerformanceLab délègue le jeu ordinaire à ApplicationLab. Une capture explicite utilise
PerformanceCapture, RefCounted à valeurs scalaires, horloge monotone indépendante de GameClock,
buffers bornés et export JSON après arrêt. BattleLab possède un chronométrage optionnel autour
de simulation.advance ; aucune règle de simulation n'y est modifiée. Le tick complet est mesuré
par la couche dérivée. Les coûts incluent respectivement la présentation des acteurs et le HUD.
Les temps GPU et la présentation physique de l'écran ne sont pas mesurés.

Le menu de diagnostic utilise les zones sûres, un ScrollContainer et TouchScrollRouter ;
ApplicationGuard est remis en dernier enfant pour conserver son ordre de réception des entrées.
Le banc contrôle UI/règles, invalide les captures interrompues et laisse la pause à la fin.
La fixture saturated20 utilise seulement des profils locaux durables et des positions initiales
espacées ; Rejouer retrouve les trois vagues. Le gameplay des laboratoires historiques reste inchangé.
Voir docs/performance.md et scenes/tests/performance_tests.tscn.

Lire docs/actions.md, docs/skill-executor.md, docs/skills.md, docs/gambit-controller.md,
docs/manual-commands.md, docs/wave-sequence.md, docs/run-lifecycle.md et
docs/application-lifecycle.md. Les règles fix1 priment sur les anciennes descriptions
« choisir le plus proche » sans mémoire entre actions. Pour les tests : docs/handoff/TESTING.md.

## GAMBITS-002 — composants

OrdersEditor → ConfigurationStore → Codec v3 (save atomique) ; configuration_changed → PartySimulation.
GambitsPage et ArenaPage composent le même éditeur. OrderIcon ne dessine que les pictogrammes.
Le mode historique est réservé aux bancs ; le produit active orders_enabled.
