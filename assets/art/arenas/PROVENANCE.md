# État courant — ARENA-002 (29 octobre 2026)

Le propriétaire retire définitivement le quadrillage blanc et son option. Les huit
fonds aux chemins historiques sont remplacés par leurs variantes sans grille créées
avec l’outil intégré image_gen.imagegen (compétence imagegen). Les miniatures sont
régénérées. Les fichiers d’origine restent récupérables dans les sauvegardes et
l’historique Git antérieurs, sans être chargés par le jeu.
Consignes exactes, sorties de génération et empreintes finales : `generation.json`.
Les sorties sont normalisées au canevas d’origine 540 × 960 avec ImageMagick, sans
recadrage. La caméra, les repères du sol et les placements restent inchangés.
La reconstruction peut introduire de légères différences de texture. Les joints
naturels du dallage restent présents ; les lignes blanches tactiques sont retirées.
La fiche de fourniture ci-dessous décrit les originaux historiques avant remplacement.

# Fonds d'arène fournis — GRAPHICS-002

Source : archive `arenes_isometriques_540x960.zip` fournie par le propriétaire le
26 octobre 2026, SHA-256 `950ca806036b9ee425578099e73ff253936d627c05d2e2549eca173876d9d969`.
Elle contient huit illustrations, une grille transparente et un JSON de coordonnées.
GRAPHICS-001 a intégré le Colisée et les repères communs ; GRAPHICS-002 intègre les sept
autres décors. Les huit PNG de fond sont des copies inchangées des fichiers fournis.

| Fichier livré | Source dans l'archive | SHA-256 |
|---|---|---|
| colisee_solaire/colisee_solaire.png | 01_colisee_solaire_540x960.png | 4ff2a68a7d3d908b3f80e01c962f6f06830fe65d0314dde179494cb7591827fb |
| sanctuaire_polaire/sanctuaire_polaire.png | 02_sanctuaire_polaire_540x960.png | 1465652f1c15d4d9b437d8ba61cfa63d768f65d98e67b7912423d181d0200c29 |
| forteresse_volcanique/forteresse_volcanique.png | 03_forteresse_volcanique_540x960.png | b5b1338e4b5aedb101db23d124fc7c725c460093e16292ec7ef94b52d7fa03fa |
| temple_sylvestre/temple_sylvestre.png | 04_temple_sylvestre_540x960.png | 5de208dcfb8f8e5c0d98200c2014f42524c2c816862ad24903826bd00e12f2cb |
| arcane_bleu_sombre/arcane_bleu_sombre.png | 05_arcane_bleu_sombre_540x960.png | c9313d979d669218ef52dfd443ad9d24ba2d69defec60fa05de0ba30aced6a0f |
| chaos_vert_toxique/chaos_vert_toxique.png | 06_chaos_vert_toxique_540x960.png | 02bb3d3f96cdf782c67509a5e7b06fd4bfd82adb995d10e47e5186d2009f6e1f |
| lumiere_angelique/lumiere_angelique.png | 07_lumiere_angelique_540x960.png | 16b8a4a95c340f65dfa8c3bf39af6a21b6b6b881a5de24954c4958610c4c9cd4 |
| pirates_fantomes/pirates_fantomes.png | 08_pirates_fantomes_540x960.png | 69c3184cfd0e1ddb41f5fe73163210866495cdc034c889de2df19d65c76ca58f |
| calibration/grille_8x8.png | grille_8x8_commune_transparente_540x960.png | 285ee712274e916d4ce886d4ca2bbab5100523b604aed632da13f9b1ba86f763 |
| calibration/grille_8x8_coordonnees.json | grille_8x8_coordonnees.json | Copie inchangée du fichier fourni |

Les PNG sont conservés à leur taille originale 540 × 960, sans retouche ni réencodage.
Import Godot sans perte, sans mipmaps, affichage à échelle uniforme et recadrage dans le
viewport de jeu. L'image de grille est réservée à la galerie de diagnostic.

`previews/` contient huit miniatures 108 × 192 dérivées des fonds, générées avec ImageMagick
par `bash tools/generate_arena_previews.sh`. Elles servent uniquement aux cartes du catalogue ;
le jeu utilise les fonds pleine résolution. Ces aperçus n'altèrent pas les PNG originaux.

Auteur, outil de création et licence de redistribution non précisés dans l'archive reçue.
Aucune provenance tierce ni licence n'est présumée. Cette fiche constate la fourniture par
le propriétaire pour le développement ; elle ne constitue pas une autorisation de distribution
publique supplémentaire. La note du JSON parle de quatre visuels ; l'archive en contient huit.

Les ressources `.tres`, scènes et scripts de présentation sont des sources créées pour ce projet.
