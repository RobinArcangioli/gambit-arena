# Assets temporaires et contrat d'animation — STEP-005

## Origine et utilisation

Les SVG assets/debug/ et assets/actors/ sont des formes vectorielles originales
créées avec assistance IA pour ce projet, sans image tierce copiée ni pack externe.
Le script tools/generate_actor_atlases.py contient les sources de construction.
Ils sont fournis pour utilisation, modification et redistribution dans ce projet,
sans condition supplémentaire imposée par l'assistant. Aucun droit exclusif,
licence tierce ou protection juridique des productions IA n'est revendiqué ici.
La licence publique globale du jeu n'est pas définie à cette étape.
Voir aussi assets/actors/PROVENANCE.md. Aucun asset Broken Ranks/Final Fantasy.

## Inventaire

| Source | Dimensions | Usage |
|---|---|---|
| assets/actors/hero_atlas.svg | 320 × 1600 | Héros cyan, casque et épée |
| assets/actors/enemy_atlas.svg | 320 × 1600 | Ennemi rouge, capuche et dague |
| assets/debug/actor.svg | 48 × 48 | Ancien laboratoire |
| assets/debug/actor_tall.svg | 80 × 80 | Ancien test d'ancrage |
| assets/debug/pillar.svg | 76 × 100 | Ancien test d'occultation |

Taille retenue après STEP-004 : 48 px de référence. Pour les nouveaux acteurs,
c'est la hauteur approximative du corps debout, pas la cellule entière :
la marge transparente accueille l'épée et les effets. La respiration varie
légèrement la hauteur ; la mort réduit la silhouette. Ce sont des assets de
travail non pixel art, pas la direction artistique finale.

## Atlas et ancrage

Une planche comporte quatre colonnes × vingt lignes ; cellule 80 × 80.
Colonnes = images 0, 1, 2, 3. Lignes = idle, move, attack, hit, death,
chacun avec se, sw, ne, nw dans cet ordre. Ligne = état × 4 + direction.
Ancrage constant (40,68). AnimatedSprite2D : centered=false, offset=(-40,-68).
L'AtlasTexture utilise la cellule entière avec filter_clip=true.
La racine est au sol et ne change jamais selon les dimensions du dessin.

Les directions sont dimétriques : se = +x (bas-droite), sw = +y (bas-gauche),
ne = -y (haut-droite), nw = -x (haut-gauche). Les vues arrière ont leur propre
dessin (pas de visage, détails de dos). Les couples gauche/droite sont des
miroirs assumés pour ces assets temporaires : la latéralité de l'arme n'est
pas une contrainte de gameplay à ce stade. Les noms de ressources restent
anglais ; le bouton affiche SO/NO pour sw/nw.

## Lecture

| État | Images | FPS | Durée | Boucle |
|---|---|---|---|---|
| idle | 4 | 4 | 1 s | Oui |
| move | 4 | 8 | 0,5 s | Oui |
| attack | 4 | 8 | 0,5 s | Non |
| hit | 4 | 10 | 0,4 s | Non |
| death | 4 | 6 | environ 0,667 s | Non |

Chaque animation existe dans les quatre directions, pour chacun des deux acteurs
(40 séquences, 160 images au total). Attack et Hit conservent la pose finale ;
Death reste au sol. Le futur contrôleur décidera des transitions, pas les assets.
Le signe visuel de frappe n'applique aucun dégât. Les durées ne sont pas des
engagements de timing du combat futur.

## Import et budget

Godot importe les SVG en textures ; laisser l'échelle SVG à 1, les mipmaps
désactivées et la compression sans perte pour cette première qualification.
Le script impose un filtrage linéaire, sans agrandissement dans le laboratoire.
Les deux textures RGBA8 représentent 4 096 000 octets bruts (environ 3,91 Mio),
hors métadonnées, copies et cache. Ce calcul n'est pas une mesure de RAM/VRAM
sur Android. Les anciennes textures restent incluses avec all_resources.
Pas d'optimisation ni de budget de production validé à ce stade.

Les nouveaux .svg.import et .gd.uid seront générés par Godot. Les suivre dans
Git après import. Conserver les anciens ; exclure .godot/. Aucun UID nouveau
n'est inventé par cette livraison. Les scènes référencent les nouvelles sources
par chemin. Les atlas sont déjà fournis : le générateur Python est facultatif.

## Changement de direction après validation STEP-005

Le 22 octobre 2026, l’utilisateur valide ce laboratoire puis choisit des
personnages 3D sur fond 2D isométrique. Ces SVG restent des assets de diagnostic
historique et ne constituent plus la filière de production des personnages.
Aucun modèle, rig ou animation 3D n’est inclus dans cette validation.
Le prochain prototype déterminera les besoins de production 3D et la taille
apparente ; 48 px est le repère initial, pas une dimension imposée aux modèles.

## Sources nouvelles TRANSITION-001

scripts/hybrid/proxy_actor.gd crée deux silhouettes de mannequins à partir de
BoxMesh/SphereMesh Godot, sans fichier de modèle importé, rig ou texture externe.
Couleurs cyan/orange, tête ronde/cubique. Le code est une source du projet.
assets/hybrid/occluder.svg (96 × 112) est un dessin vectoriel original créé pour
ce diagnostic ; aucune image ni police tierce intégrée. Même provenance et
conditions de fourniture que les sources originales décrites plus haut.
Le fond est dessiné par scripts/hybrid/ground_canvas.gd, sans image extérieure.

La pose et la marche procédurales ne remplacent pas les cinq animations de
production prévues. Les assets historiques 2D et leurs métadonnées restent
conservés. Ne pas déduire un budget 3D du calcul des atlas 2D ci-dessus.
Les nouveaux .gd.uid/.svg.import générés par Godot devront être suivis dans Git.

## Échelle du prototype hybride validée

Le 22 octobre 2026, l’utilisateur confirme 48 px de référence comme taille
préférée pour les mannequins 3D. Cette échelle guidera la suite ; la lisibilité
des futurs modèles et animations devra être vérifiée avec leurs vraies silhouettes.
