# MATERIALS-001 — Personnages mats et peints

Statut : validée sur Galaxy A16 le 30 octobre 2026 (« Oui, étape validée »).
Base : 88250d43c11ee580524f1a211a09d67772c468fb (ATTACK-BARS-001).

## Choix visuel

Les GLB importés utilisent un atlas commun avec metallic=0,4 et roughness≈0,272.
Le profil C choisi conserve les textures et leurs couleurs, passe metallic à 0,
roughness à 0,95 et metallic_specular à 0,05, avec diffusion Lambert. L’ambiance
bleutée vaut 0,32 ; la lumière principale chaude vaut 1,05. Ces valeurs sont communes
au combat et aux miniatures Idle. Les modèles et images source restent intacts.
Les ombres au sol, les flashs d’impact et les effets lumineux des sorts restent actifs.

## Architecture

character_surface_profile.gd regroupe les seuls paramètres de présentation.
resources/presentation/surfaces/painted_contrast.tres est le profil partagé sélectionné.
CharacterView duplique les matériaux de surface et conserve les textures partagées.
Chaque instance possède ses copies ; changer un modèle ne modifie ni le GLB ni un
autre personnage. Les originaux sont conservés pour comparer/revenir à l’original.
La sortie d’arbre restitue les matériaux avant libération ; l’entrée d’arbre réapplique
le profil, notamment lors du transfert d’un personnage vers son animation de mort.
Ce cycle évite des erreurs de libération du moteur de rendu sans modifier les actions.
Le profil s’applique aux nouvelles vagues par la création habituelle des CharacterView.
Les lumières du combat et des portraits utilisent la même ressource.

## Comparaison et validation

Le laboratoire scenes/debug/character_materials_lab.tscn montre les quatre modèles
animés et le combat, avec références et variantes de présentation. Aucun chemin de
sauvegarde joueur. Les variantes Mat naturel, Peint doux, C1 Ombres profondes,
C2 Illustré et C3 Lunaire restent disponibles comme ressources de comparaison.
Le propriétaire a choisi C de référence après deux séries d’essais Godot.
Le laboratoire maintient la variante sélectionnée sur les nouveaux ennemis.

14 scènes ciblées / 937 contrôles réussis sans échec ni erreur moteur.
Le nouveau banc character_surfaces_tests compte 80 contrôles : textures et sources
préservées, instances indépendantes, retour exact à l’original, conservation de
l’attaque, transfert pour la mort, profil partagé Équipe/Combat et nouveaux ennemis.
Les autres bancs couvrent animation/priorité des actions, effets d’incantation,
soin/foudre, portraits, navigation Équipe, cycle de vie, Booster et barres d’attaque.
Captures GPU A/B/C puis variantes contrastées vérifiées. Aucune mesure FPS.

APK normal : materials-001-debug.apk, 0.1.0-materials001 (82).
SHA-256 : f58a09e0ed0cd9fe0986e2ec2aaaaf51c161a2858de9d4e3c21f6df49be9102c.
Installé sur Galaxy A16 ; rendu en combat contrôlé. Gambits et préférences du joueur
conservés octet pour octet après installation. Rendu esthétique validé sur Android.
Clôture documentaire : code, ressources, configuration et APK identiques à la livraison
validée ; les tests déjà réussis ne sont pas relancés. Commit local et sauvegarde
complète restaurée/vérifiée.
Aucun push automatique. UI-005 reste la prochaine qualification intégrée planifiée.
