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

## Interface et comportement

Pendant le combat, un seul bouton : Pause en haut à droite. Quatre panneaux non interactifs
juste en dessous, en grille 2 × 2 : Mako, Anne, Vide, Vide. Les deux héros ont un portrait
statique face caméra, leur nom et les barres PV, mana, sort. La barre de sort n'est dessinée
que pendant l'incantation. Les héros KO gardent leur panneau avec portrait atténué et PV zéro.
Les portraits sont rendus à partir des modèles existants, aucune scène 3D supplémentaire
n'est calculée pour le HUD. La recette de génération est conservée dans verification/.

Aucun titre, vague, résultat textuel, sélection de héros, commande manuelle, catalogue
d'arènes, éditeur de gambits ni bouton de bas d'écran dans cette page produit. La pastille
jaune disparaît en laissant selected_hero vide ; les barres au-dessus des héros et ennemis
conservent leurs valeurs/couleurs/incantations. Le terrain et le bas de page restent visibles.

Pause ouvre un petit menu centré avec Reprendre / Rejouer / Abandonner. Le combat est gelé,
y compris incantations, mana, déplacements et effets. Reprendre ferme le menu ; Rejouer
crée une partie neuve et effectue exactement un nouveau tirage d'arène parmi les huit fonds
éligibles (répétition possible), avec les gambits sauvegardés. Abandonner ouvre une confirmation
Annuler / Abandonner ; Annuler revient au menu en restant en pause, confirmer détruit le
combat et revient à l'accueil. Pas d'abandon direct par Retour Android : il ouvre la pause,
annule d'abord une confirmation, ou reprend un combat en cours si le menu Pause est affiché.

En fin de combat, Pause reste disponible : Reprendre est désactivé, Rejouer et Abandonner
restent accessibles. Le retour de l'arrière-plan conserve le menu et requiert une reprise
explicite. Les rappels de layout/projection ignorent une arène déjà détachée de l'arbre.
Les actions de menu sont protégées des doubles activations lors des événements tactiles.

## Architecture

HeroStatusPanel ne lit que les valeurs des acteurs et reprend OverheadBars pour l'ordre et
les couleurs. Les portraits PNG transparents sont indépendants des statistiques et actions.
ArenaPage compose les nouveaux panneaux et menu ; PartyApplication expose deux points de
composition pour les contrôles et surimpressions. Le parcours produit ne construit plus les
anciens boutons, scrollers ou sélecteurs. Les laboratoires historiques gardent leur HUD et
leurs commandes de diagnostic. AppRoot délègue le Retour Android à ArenaPage.handle_back.

L'édition des gambits reste accessible depuis Équipe → Fiche → Gambits, sauvegarde immédiate.
Aucun changement de logique des capacités automatiques, de ciblage des gambits, de paiement,
de durée, de navigation, de gabarit ou d'animation. Les compétences manuelles reviendront
ultérieurement dans un chantier propre ; les anciennes commandes ne sont pas recyclées ici.

## Recette

54 scènes / 3 592 contrôles, sans erreur ni avertissement. Nouveau banc arena_hud_tests :
94 contrôles avec 540×960, 540×1170 et 360×640, zone sûre, vrais taps doigt + copie souris,
PV/mana/incantation réels, pause pendant un soin, retour OS, rejeu, fin de combat, annulation
et confirmation d'abandon, sauvegarde inchangée et libération des acteurs/menus.
Les bancs de navigation, layout et gambits ont été adaptés au nouveau parcours sans perdre
les contrôles de cycle de vie. Les anciens bancs restent dans la suite complète.

Captures GPU de l'arène, de Pause et de la confirmation relues. Pas de validation manuelle
PC prétendue : les scènes sont pilotées par le script de recette. APK exporté/signé/vérifié,
installé sur Galaxy A16 ; preuves et rapport natif dans verification/ de l'archive.
F6 : scenes/tests/arena_hud_tests.tscn puis F8 ; F5 : Accueil → Arène.
Vérifier le rendu, les panneaux, la reprise et l'abandon sur le téléphone avant validation.
