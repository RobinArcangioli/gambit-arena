# ATTACK-BARS-001 — Progression de l’attaque normale

Statut : validée par le propriétaire sur Galaxy A16 (« Étape validée. »).
Base : 353346b4963ad4930860f55f1763e1599591079d (PORTRAITS-001).

## Présentation

La troisième ligne des barres affiche désormais aussi l’attaque normale. La première
portion est dorée (préparation), la seconde argentée (récupération). Une épée fixe
marque leur séparation et le moment exact du coup. Les proportions proviennent des
durées réelles de l’exécuteur : actuellement 0,6 seconde puis 0,4 seconde.
Le shader néon et le widget des barres sont partagés par les panneaux héros et les
barres flottantes des héros et ennemis, y compris les squelettes sans mana.
L’épée mesure 12 px dans les panneaux et 6 px au-dessus des modèles.
Le texte du panneau indique « Attaque : …s » puis « Récup. : …s ».
Les sorts gardent leur barre et leur icône habituelles.

La présentation lit seulement l’état et le temps personnel de l’action. Booster
accélère naturellement la progression ; la pause la fige. Une annulation avant
impact masque la jauge ; un coup fatal conserve sa récupération. Fin d’action
et mort masquent la ligne. Les deux préférences de barres flottantes s’appliquent.
Aucune modification des durées, impacts, animations, gambits ou sauvegardes.

## Vérification et recette

70 scènes / 5 166 contrôles réussis dans la copie isolée, dont 61 contrôles dédiés
à 540×960, 540×1170 et 360×640 : phases réelles, impact, épée fixe, pause, Booster,
annulation, coup fatal, sort, ennemi sans mana, options et libération des widgets.
Rendu GPU du laboratoire contrôlé sur Galaxy A16 : préparation et récupération.
APK normal réinstallé en version 81 ; nouvelle vague laissée en pause pour recette.
Le propriétaire valide ensuite globalement le rendu. Aucune mesure FPS.
La clôture compare les sources intégrées avec la copie testée et exécute les bancs
ciblés. Le SVG intégré possède simplement une fin de ligne finale supplémentaire.

## Laboratoire et APK

scenes/debug/attack_progress_lab.tscn montre Préparation, Coup, Récupération et Sort.
Il utilise la vraie simulation sur des instantanés figés, avec chemins de sauvegarde
vides. tools/export_attack_progress_lab.py exporte une copie isolée.
Main continue d’ouvrir l’application normale.

Normal : attackbars-001-debug.apk, 0.1.0-attackbars001 (81).
SHA-256 : e9a2ba7ada291e539640b227e39543ef30f4bcff93b62edb688ce698913e7a87.
Laboratoire : attackbars-001-lab-debug.apk, 0.1.0-attackbars001-lab (81).
SHA-256 : cd3b1d4cb4d2f6b394822870b2a4000c1b22b92c053f816c6f58bbc89c8d940e.
Commit local autorisé, sauvegarde complète restaurée et comparée, aucun push automatique.
