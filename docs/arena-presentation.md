# Présentation des arènes — GRAPHICS-001

## Changer le décor

Dans `scenes/main.tscn`, le nœud ApplicationLab expose `arena_definition`. Lui assigner
`resources/presentation/arenas/colisee_solaire.tres` ou `reference.tres` suffit à changer
le décor. Les laboratoires historiques ne spécifient rien et retrouvent le terrain original.
F6 sur `scenes/debug/graphics_lab.tscn` ouvre la galerie indépendante du combat : Reference,
Colisee, grille de l'image, repères logiques et cinq placements de personnages.

## Ajouter une variante

1. Conserver l'image source et documenter sa provenance sous `assets/art/arenas/`.
2. Créer une scène Node2D qui hérite du contrat `scripts/presentation/arena_view.gd`.
   Pour une illustration, réutiliser `illustrated_arena_view.gd` avec sa texture et ses
   repères : centre image, demi-largeur/hauteur de grille, emprise visuelle et marge.
3. Créer une Resource portant `arena_definition.gd`, un identifiant stable, un nom et la
   `PackedScene` de cette vue. Aucun champ de coût, portée, obstacle ou apparition.
4. Assigner cette ressource au point de composition et vérifier la galerie puis le jeu.
   Une définition sans scène ou avec une scène incompatible utilise le terrain de référence.

Le changement à l'exécution passe par `floor_canvas.set_definition(resource)` ; l'ancienne
vue est détachée puis libérée. `set_presentation_enabled(false)` masque le décor et son overlay
sans modifier le combat. Cette présentation nulle concerne le terrain ; l'extraction des
personnages de l'héritage graphique est prévue dans GRAPHICS-003.

## Contrat et calage

`ArenaFloor` reste la façade compatible des laboratoires : caméra, taille de viewport,
repères et positions des pieds. Il possède une seule `ArenaView`, laquelle reçoit uniquement
la caméra et la taille du viewport. La simulation ne reçoit aucune définition artistique.
Le décor ne contient aucun Control capturant le toucher, collision ou script de combat.
L'overlay logique reste au-dessus du fond et sous les personnages 3D.

Le Colisée utilise le centre fourni (270,455) et le losange de demi-dimensions (240,138).
La caméra et les unités logiques existantes restent inchangées. La pente de la grille de
l'illustration (0,575) diffère de celle de la caméra (0,5) : on ne prétend donc pas que les
cases du dessin correspondent une à une aux unités du jeu. Le carré logique de demi-côté 3
est projeté à l'intérieur du losange, avec une occupation horizontale maximale de 88 %.
Les pieds au centre et aux quatre coins sont vérifiés par projection inverse dans l'image.

La texture garde son ratio 540/960. Les régions hors du viewport sont découpées à l'affichage,
pas étirées ou dessinées sous le HUD. Une partie du décor haut/bas est donc absente en jeu ;
la galerie et les captures de livraison permettent de valider ce choix de cadrage. Pas de
retouche de l'image source, changement de perspective de caméra ou modification des limites.

`framing_half_extent` est un repère de présentation, pas une nouvelle limite de déplacement.
La référence originale continue à lire ArenaBounds pour dessiner ses repères historiques.
La lumière des mannequins reste commune ; aucune ombre dynamique n'est ajoutée.

## Vérification

`scenes/tests/arena_presentation_tests.tscn` vérifie le remplacement/libération, les replis,
quatre tailles de viewport, le ratio de l'image, le centre et les coins du terrain. Il compare
900 ticks réels de Main avec référence, Colisée et fond absent : positions, états, actions,
PV, énergie, coûts, dégâts/soins et compteurs identiques à chaque tick. Ce test ne démontre
pas une équivalence de tous les parcours possibles ni une validation artistique subjective.

Les exports de performance portent désormais `arena_id`, `arena_presentation_enabled` et
le build GRAPHICS-001 pour éviter de mélanger les fonds aux mesures de STEP-028.
