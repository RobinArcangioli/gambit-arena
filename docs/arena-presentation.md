# Présentation des arènes — GRAPHICS-002

GRAPHICS-001 validée, commit local `f5a790d38ed12cd3ccc3bac85162308986a5f894`, sauvegarde
restaurée/vérifiée. GRAPHICS-002 ajoute le catalogue des huit images fournies et le sélecteur
commun à la galerie et au jeu.

## Changer le décor

Dans `scenes/main.tscn`, le nœud ApplicationLab expose `arena_definition`. Lui assigner
`resources/presentation/arenas/colisee_solaire.tres` ou `reference.tres` suffit à changer
le décor. Les laboratoires historiques ne spécifient rien et retrouvent le terrain original.
F6 sur `scenes/debug/graphics_lab.tscn` ouvre la galerie indépendante du combat : Reference,
Colisee par défaut, grille de l'image, repères logiques et cinq placements de personnages.
Le bouton **Arènes...** ouvre les huit décors et le terrain de référence de diagnostic.

En jeu, **GAMBIT / Mesures → Choisir l'arène** ouvre le même sélecteur avec miniatures.
L'ouverture fige la partie ; sélectionner ou fermer conserve cette pause. Reprendre est
explicite. Le choix change seulement le fond, sans reset, soin, débit ou nouvelle action.
Rejouer conserve l'arène choisie pendant cette session ; un nouveau lancement utilise la
ressource de Main (Colisée). Aucune persistance sur disque n'est ajoutée.

## Catalogue et entrées

`ArenaCatalog` expose neuf identifiants stables : les huit illustrations et `reference`.
Il conserve seulement les noms et chemins ; les grandes textures sont chargées à la sélection.
Les vignettes 108 × 192 ont leurs propres fichiers pour éviter de charger huit fonds pour
afficher le menu. Le profil de composition Colisée peut rester référencé par la scène Main ;
une seule vue est active, sans promettre l'absence de tout cache moteur de textures.

`ArenaApplicationLab` étend PerformanceLab et instancie la scène de base Arena, avec le même
héritage fonctionnel. Il possède le sélecteur et reste hors des règles de combat. La scène
évite de remplacer à l'instanciation un script PerformanceLab déjà initialisé, qui créerait
des objets Node de construction sans parent. Le nouveau banc vérifie aussi les orphelins
après destruction de Main et de la galerie.

Le sélecteur réutilise TouchScrollRouter : swipe depuis une image ou carte sans sélection,
appui court unique, liste active exclusive, copie souris tactile consommée. ApplicationGuard
reste le dernier enfant de Main pour recevoir les entrées en premier. La galerie possède
également un garde et un routeur. Un retour Android garde le menu et la pause ; les anciens
relâchements sont refusés. Les raccourcis de jeu n'agissent pas sous le menu.

## Ajouter une variante

1. Conserver l'image source et documenter sa provenance sous `assets/art/arenas/`.
2. Créer une scène Node2D qui hérite du contrat `scripts/presentation/arena_view.gd`.
   Pour une illustration, réutiliser `illustrated_arena_view.gd` avec sa texture et ses
   repères : centre image, demi-largeur/hauteur de grille, emprise visuelle et marge.
3. Créer une Resource portant `arena_definition.gd`, un identifiant stable, un nom et la
   `PackedScene` de cette vue. Aucun champ de coût, portée, obstacle ou apparition.
4. Assigner cette ressource au point de composition et vérifier la galerie puis le jeu.
   Une définition sans scène ou avec une scène incompatible utilise le terrain de référence.
5. Pour une entrée visible dans le sélecteur, enregistrer son identifiant et nom dans
   `ArenaCatalog.ENTRIES`, et son aperçu dans `assets/art/arenas/previews/`. Aucun script de
   combat n'est à modifier. Un identifiant absent du catalogue utilise `reference`.

Le changement à l'exécution passe par `floor_canvas.set_definition(resource)` ; l'ancienne
vue est détachée puis libérée. `set_presentation_enabled(false)` masque le décor et son overlay
sans modifier le combat. Cette présentation nulle concerne le terrain ; l'extraction des
personnages de l'héritage graphique est prévue dans GRAPHICS-003.

## Contrat et calage

`ArenaFloor` reste la façade compatible des laboratoires : caméra, taille de viewport,
repères et positions des pieds. Il possède une seule `ArenaView`, laquelle reçoit uniquement
la caméra et la taille du viewport. La simulation ne reçoit aucune définition artistique.
Le décor ne contient aucun Control capturant le toucher, collision ou script de combat.
Le sélecteur est un menu séparé, qui capture volontairement les entrées pendant son affichage.
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
