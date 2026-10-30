# STYLE-002 — Palette unifiée de l’arène et Berserk rouge/noir

## État

Demande du 30 octobre 2026, base STYLE-001 `0598c16`.
Quatre variantes présentées dans Godot : A Berserk actuel, B Crépuscule (bleu nuit,
violet et orange du screenshot), C Rouge et noir, D Obsidienne cuivrée.
Choix du propriétaire : **C — Rouge et noir**.
80 scènes / 5 948 contrôles consolidés réussis sur le profil canonique choisi.
Captures GPU des quatre variantes et huit vues chacune.
APK v91 installé et validé sur Galaxy A16 : « Oui, STYLE-002 validée ».
Gambits, équipe et réglages identiques avant/après installation, vérifiés par empreinte.
Clôture documentaire uniquement : code et APK inchangés. Commit local et sauvegarde
complète restaurée/vérifiée ; aucun push automatique.

## Palette et portée

La définition Berserk associe maintenant son Theme et une ressource ArenaHudStyle.
Fond principal noir `#0b090a`, boutons `#18090d`, survol `#2b0c11`, appui `#7f101b`.
Icônes rouge vif `#ff333b`, titres `#ff575c`, bordures `#b41c29`, texte ivoire `#fff0ef`.
Les opacités, formes et dimensions validées sont conservées : fond commun du bandeau
et des quatre héros, losange et filets centraux, marges et menus. Les portraits gardent
leur cadrage ; leur bordure s’accorde à la palette. Les réglages, statistiques, journal,
menu de pause et confirmation d’abandon partagent les rôles de couleur.
Les fonds Berserk de l’accueil/équipe sont conservés et leurs contrôles adoptent la même
palette rouge/noir, listes déroulantes et cadres vides compris.

Berserk est le défaut en l’absence de préférence, ou si celle-ci est invalide. Les choix
Arcane/Berserk déjà enregistrés restent respectés. La bascule conserve le même bouton
Cristal/braise et le même fichier indépendant. Arcane reste intégralement disponible.

## Isolation de présentation

InterfaceStyle porte les ressources de présentation, transmises à l’arène avant sa
création. ArenaHudStyle regroupe fonds, titres, textes, bordures, contours et couleurs
des glyphes ; les composants reçoivent leur profil avant leur initialisation.
Les SVG existants conservent leur géométrie : une copie privée de leur petite image
est recolorée et mise en cache par palette. Aucun SVG source n’est lu sur disque dans
l’APK et aucune texture partagée n’est modifiée. Le remplissage de l’engrenage suit
également le fond de la palette. Le journal conserve ses glyphes pause/lecture.

Aucun changement de simulation, statistiques, journal, règles, sauvegardes de combat,
géométrie d’arène ou temps d’action. Les couleurs fonctionnelles restent conservées :
PV, PM, incantation cyan, attaque or/argent, dégâts, soins, barres de statistiques,
MVP magenta, icônes de compétences/buffs et effets de sorts.

## Comparatif et vérifications

F6 : `scenes/debug/arena_palette_lab.tscn`. Vue portrait réelle et commandes du comparatif
à côté, sans recouvrir le bandeau ni les panneaux héros. Quatre palettes, huit types de
vues, trois décors (Ombres, Alexandrie, Colisée), combat figé ou animé. Préférences,
gambits et équipe en mémoire ; aucune donnée joueur touchée. Les variantes restent
indépendantes du profil canonique afin de conserver la référence A après sélection C.

Les régressions vérifient le nouveau défaut, sa persistance, l’application de la palette
à l’arène et la conservation de la palette Arcane. Les tests de vagues et de cadres
comparent les rôles du style choisi au lieu d’imposer de l’or/bleu. Neuf contrôles de
plus vérifient taille/cache des glyphes, couleur intérieure des quatre engrenages et
absence de mutation de leur texture source. Vérification GPU de l’arène, réglages,
statistiques, journal, pause, accueil, équipe et gambits pour chaque variante.

Rendu rouge/noir validé sur Galaxy : bandeau, icônes, fonds héros, menus et pages
hors combat. Captures Android de l’accueil, du combat et de Menu, sans erreur Godot.
Le combat est mis en pause pour la recette, puis validation du propriétaire obtenue.
Aucun nouveau relevé de performances.

## APK validé

- style-002-debug.apk (v91) : `13cb61a10ffd3d134e6adc2bd59a10f602b39f8181175f4dc50688e8cd706a91`
