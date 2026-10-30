# STYLE-001 — Styles Arcane et Berserk hors combat

## État

Demande du 30 octobre 2026, base HUD-001 `48f762c`.
Le propriétaire demande fonds **et palette hors combat** et choisit
**B — Cristal / braise** dans le laboratoire Godot. Arcane est le style initial.
80 scènes / 5 939 contrôles consolidés réussis ; captures GPU des quatre pages
et de leurs listes déroulantes vérifiées. APK v90 installé et validé sur Galaxy A16 :
« Oui, STYLE-001 validée ». Gambits, équipe et réglages identiques avant/après installation,
vérifiés par empreinte. Clôture documentaire uniquement : code et APK inchangés.
Commit local et sauvegarde complète restaurée/vérifiée ; aucun push automatique.

## Fonctionnement

Bouton sans texte ni cadre, 48 × 48, en haut à droite de l’accueil dans la zone sûre.
Chaque pression alterne Arcane/Berserk et mémorise immédiatement le choix dans
`user://appearance.cfg`, indépendant de l’équipe, des gambits et des réglages de combat.
L’infobulle indique le style de destination. Le bouton est protégé lors des transitions
et du passage en arrière-plan. En cas d’échec d’écriture, le style précédent est conservé.
Le fichier absent ne provoque aucune écriture ; une préférence invalide revient à Arcane.

Berserk utilise les deux images fournies, copiées sans transformation : Accueil sur
l’accueil, Balcony sur Équipe, Fiche et Gambits. Les images conservent le recadrage
centré de type cover. Sur ces pages, boutons, cadres des cartes, étiquettes, panneaux,
menus déroulants et contrôles de gambits utilisent des noirs/bordeaux et accents rouge
chaud, avec des textes ivoire. PV/PM et états actif/inactif gardent leur sens visuel.
Les cadres vides restent identiques aux cadres occupés, sans changer les dimensions,
les cadrages des portraits ou les tailles des miniatures Idle.

Le combat garde sa palette Arcane, sa géométrie et son HUD. Aucun changement de
compétence, d’ordre de l’équipe, de gambit, de simulation ou de tirage d’arène.

## Présentation remplaçable

`InterfaceStyle` décrit les fonds, Theme, couleurs de cadre/texte et éclairage décoratif.
Les définitions Arcane/Berserk sont dans `resources/ui/styles/`. Les pages reçoivent
la définition avant leur création. La palette originale reste une ressource distincte,
jamais modifiée par la bascule ; les menus de gambits fabriquent leur propre Theme.
L’illustration partage un paramètre de couleur de cadre, avec l’or original par défaut.

Les lumières de l’accueil suivent un profil par fond : bougies chaudes recalées sur
Berserk, sans braséros bleus. Les anciens effets sont détachés lors d’une bascule ;
les changements répétés ne multiplient pas les lumières.

F6 : `scenes/debug/interface_style_lab.tscn` compare Éclipse, Cristal/braise et Palette
et ouvre les véritables pages hors combat. Ses préférences, équipe et gambits sont en
mémoire. Le panneau de comparaison est propre au laboratoire, absent du jeu normal.

## Vérifications

33 contrôles dédiés : préférences absentes/invalides, écriture/relecture et échec,
bascule par clic, taille/marge du bouton, changements répétés sans accumulation,
protection du focus et des routes, quatre pages et leurs menus, absence de mutation
Arcane et des ordres pendant le changement de palette, combat à palette originale.
Suite complète : 80 scènes / 5 939 contrôles, sans échec ni erreur moteur.
Captures GPU Arcane/Berserk : accueil, équipe, fiche, gambits et menu déroulant.
La bibliothèque graphique choisit la carte AMD disponible sur le poste ; le diagnostic
de recherche du pilote NVIDIA est un message de démarrage du poste, pas du jeu.

Validation du propriétaire sur Galaxy : icône Cristal/braise, deux fonds et palettes
hors combat, navigation et conservation du choix après relance. L’installation conserve
les empreintes des gambits, de l’équipe et des réglages de combat. La palette de combat
est vérifiée dans les tests de navigation. Aucun nouveau relevé de performances.

## APK validé

- style-001-debug.apk (v90) : `b3565a81519c165f8f1c718b6d3ff2c1103c1d041fa87d0fb3c75fcda35759ff`
