# Inventaire et budgets graphiques

Inventaire reproductible : `python3 tools/inventory_graphics_assets.py` produit
[data/graphics-assets.json](data/graphics-assets.json) : 26 fichiers sources/derivés, tailles,
SHA-256, dimensions, structure glTF, clips et réglages d'import. L'outil ne réécrit aucun
asset. Les fiches de provenance des arènes et des pirates restent les sources détaillées.

## Provenance et versions

Les huit fonds 540 x 960 viennent de `arenes_isometriques_540x960.zip`, fourni le
26 octobre 2026. Auteur, outil de création et licence non précisés. Les huit aperçus
108 x 192 sont dérivés dans le projet ; grille et coordonnées sont également fournies.
Les quatre GLB proviennent de `Pirate kit-glb.zip`, même date. L'archive ne fournit pas
d'auteur ni de licence établis, ni de version commerciale. Aucune licence n'est inventée.
La version technique du format est glTF 2 ; le champ générateur est conservé dans le JSON.
Les autres kits transmis sont réservés et ne font pas partie des sources importées actives.
Ces informations restent à compléter avant une diffusion publique des assets fournis.

Soin et Foudre sont des sources de ce projet : maillages/shader locaux, sans texture tierce.
Versions visuelles GRAPHICS-005 et GRAPHICS-006, exemples de permutation GRAPHICS-007.
L'inventaire n'attribue pas de licence supplémentaire au code du projet.

## Import et coût géométrique

Godot 4.7.2, renderer Compatibility et export arm64 Android. Fonds sans perte, mipmaps
désactivées ; les modèles conservent les GLB intacts, animation importée à 30 Hz, skins
nommés, génération de LOD et de shadow meshes à l'import. Les ombres des instances sont
désactivées à l'exécution. Échelle visuelle 0,65 et transformations dans CharacterDefinition.
Les pistes de jeu, méthodes et Root ne sont pas échantillonnées par CharacterView.

| Modèle | Triangles source | Sommets | Surfaces | Joints | Clips |
|---|---:|---:|---:|---:|---:|
| Anne | 12 368 | 7 902 | 2 | 58 | 14 |
| Mako | 13 170 | 11 019 | 2 | 58 | 14 |
| Squelette A (sans tête dans la source) | 11 668 | 7 325 | 2 | 58 | 15 |
| Squelette B (par défaut) | 14 260 | 9 143 | 2 | 58 | 15 |

Les nombres sont ceux des primitives glTF brutes, avant LOD/import ; les compteurs rendus
sur téléphone sont indiqués dans le rapport de qualification. Les atlas extraits sont
quatre PNG 1024 x 1024 identiques par SHA, avec mipmaps. Ils sont conservés sous quatre
chemins d'import ; cette duplication est une piste d'optimisation ultérieure si la mémoire
mesurée le justifie. Aucun atlas ou GLB n'a été réencodé pendant la qualification.

## Enveloppe retenue pour ce prototype

- Deux héros et six ennemis vivants au maximum : 111 098 triangles source avec le
  squelette B et 16 surfaces de personnages, avant LOD. Conserver cette enveloppe avant
  d'ajouter modèles ou matériaux ; mesurer chaque dépassement sur le Galaxy.
- Les vues de mort sont plafonnées à douze pendant environ 1 s ; elles peuvent
  s'ajouter aux vivants. L'enveloppe théorique atteint alors 282 218 triangles source
  et 40 surfaces de personnages avant LOD. Ce plafond de sécurité dépasse le pic attendu
  des compétences actuelles à cible unique ; examiner les compteurs réellement rendus.
- Une image d'arène active et un calage commun ; aucune géométrie de décor ajoutée.
- Un DirectionalLight sans ombre et ambiance fixe ; les effets ne créent pas de lumière.
- Soin : huit effets au maximum, un anneau et cinq Label3D chacun, durée 0,85 s.
- Foudre : quatre préparations de deux quads au maximum et huit frappes de quatre
  surfaces chacune (environ 206 sommets par frappe), durée 0,52 s. Glow local alpha/additif.
- Garder les plafonds et durées de nettoyage. Pas d'accumulation en pause ou après Rejouer.

Cette enveloppe décrit le contenu mesuré, sans promettre un nombre de FPS universel.
Les pics, la transparence locale des sorts, les appels de dessin, la mémoire et les limites
de la mesure sont détaillés dans graphics-qualification.md. Le seuil historique de 30 FPS
ne constitue pas un nouveau critère d'acceptation.
