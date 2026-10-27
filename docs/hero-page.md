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

# Fiches de personnage — UI-003

## Parcours et données

F5 → Équipe → carte de Mako ou d'Anne ouvre la fiche de ce héros. Les panneaux et le bouton
‹ Équipe restent sur l'image team.png fournie, dans le thème night_gold.tres. Le contenu
défile sous l'en-tête fixe ; une zone sûre protège le bouton Retour sur Android. Le bouton
Gambits en bas est visible mais désactivé : sa programmation sera livrée par UI-004.

hero_reference.gd est un adaptateur en lecture seule. Il produit un nouveau dictionnaire à
partir de TeamRoster.PROFILES et des méthodes statiques de PartyExecutor. Aucun acteur ou
exécuteur n'est instancié. Identité, PV maximums, capacité de mana, attaque, défense, vitesse,
régénération et liste de compétences proviennent des profils. Coût, portée, durée, recharge
et récupération proviennent de l'exécuteur existant. Les descriptions et noms français sont
de la présentation uniquement. Aucun profil n'est modifié ; le dictionnaire des compétences
est créé à chaque lecture. Aucune statistique de combat n'est utilisée.

Valeurs actuelles : Mako 180 PV, 60 mana, attaque 18, défense 4 ; Anne 140 PV, 60 mana,
attaque 12, défense 3 ; vitesse 1,2 et régénération 5 mana/s pour les deux.
Mako : Attaque et Foudre ; Anne : Attaque et Soin. Attaque : coût 0, portée 1, préparation
0,6 s, récupération 0,4 s. Foudre : coût 30, portée 4, incantation 2 s, recharge 6 s.
Soin : coût 20, portée 4, incantation 1,5 s, recharge 4 s. Les PV/mana affichés sont des
maximums de référence, sans blessures, cooldowns ou mana restante d'un combat abandonné.
Les barres de référence sont pleines : rouge pour PV, bleu pour mana. Les sorts rappellent
que la mana est dépensée à leur résolution ; aucune règle de coût/cible/dégât n'est changée.

## Propriété et cycle de vie

AppRoot possède au plus une HeroPage. L'identifiant stable de la carte est validé avant
création. La route passe de team à hero ; la page Équipe reste sélectionnée, cachée et
inactive, avec ses deux contextes 3D conservés mais sans animation ni mise à jour GPU.
La fiche n'ajoute aucun contexte 3D et aucune simulation. Retour vers Équipe libère la fiche
et réactive les deux aperçus, sans rattrapage du temps d'absence. Un retour direct accueil
libère fiche et équipe. Le garde de transition évite les ouvertures multiples.

Le bouton, Échap et Retour Android reviennent d'abord à Équipe, puis à l'accueil au retour
suivant. La déduplication Escape/Back de UI-001 reste appliquée. Le garde d'application coupe
les commandes en arrière-plan ; la reprise ne réactive que la route visible. Le routeur tactile
existant est réutilisé sans modification pour le défilement de la fiche ; perte de focus,
redimensionnement et fermeture annulent les gestes. Aucun fichier de gambits n'est écrit par
la fiche. Combat, compétences, modèles, gabarits, navigation et effets restent inchangés.

## Vérification exécutée

Godot 4.7.2 Compatibility : 47 scènes, 2 920 contrôles réussis, aucune erreur/warning dans
leurs journaux. Nouveaux bancs hero_page_tests (49) et hero_layout_tests (55). Les deux bancs
Équipe existants conservent leurs 61 et 37 contrôles mais passent désormais par le retour de
fiche entre deux sélections : adaptation intentionnelle au nouveau parcours.

Couverture : identité, source des champs/métadonnées, copie indépendante, absence de données
blessées après abandon d'un vrai combat, sélection/retour, arrêt des aperçus, pause/focus,
12 cycles de fiches, Retour Android à un niveau puis accueil, zéro orphelin. Tests aux formats
540 × 960, 540 × 1170 et 360 × 640, avec zone sûre : véritables événements doigt/souris émulée
au viewport, ouverture depuis chaque modèle, scroll si nécessaire, accès au bouton Gambits,
absence de débordement horizontal, vieux relâchement après reprise et nouvelle commande valide.

Captures GPU PC pilotées par script avec focus explicite du pilote de recette ; fiches haut/bas
inspectées, fermeture avec zéro orphelin. Le pilote NVIDIA hôte signale son chargement puis le
rendu utilise correctement AMD Mesa. Ce rendu n'est pas une recette manuelle PC.
APK normal 0.1.0-ui003 (46), 41 234 538 octets, SHA-256 :
`2d10e45f9d5622a479def8ad64e4f2e38083527c3613ea010bcb5052b364d6f0`.
Galaxy A16 : installation -r, Mako puis Anne, glissements, Retour Android fiche → équipe →
accueil, Retour sur accueil, Home système/reprise sur la fiche et bouton Équipe. Captures et
log natifs joints à la livraison ; la fiche tient entièrement sur le grand écran A16, les
glissements y sont sans débordement. Le scroll est vérifié sur les formats plus courts.
Téléphone laissé sur Anne. Aucune nouvelle mesure FPS.
Recette utilisateur encore attendue ; détails de la validation finale à consigner à sa réception.

## Recette utilisateur

F5 → Équipe → Mako : vérifier 180 PV, 60 mana et Foudre ; revenir puis Anne : 140 PV,
60 mana et Soin. Lire les métadonnées, défiler jusqu'à Gambits (désactivé dans UI-003),
essayer le bouton Équipe et Retour Android. Mettre la fiche en arrière-plan puis reprendre.
F6 : scenes/tests/hero_page_tests.tscn et hero_layout_tests.tscn, F8 entre les bancs.
