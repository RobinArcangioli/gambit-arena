# GRAPHICS-008 validée — 27 octobre 2026

Le propriétaire confirme « Step validée. » pour les disques d'ombre indiquant le gabarit.
APK 0.1.0-graphics008 (42), SHA-256
`3cb968ff960280aece6b1636edd06f34fd33120eb7c429a89f5806011f11d8cc`.
Validation globale, sans détail supplémentaire ni nouvelle mesure de performance.
Code, scènes, assets, configuration et APK identiques à la livraison validée ; seuls les
documents sont actualisés. Les 40 bancs / 2 541 contrôles déjà réussis ne sont pas relancés.
Clôture par un commit unique puis sauvegarde restaurée/vérifiée. GAMEPLAY-003 reste annulée :
tailles et contournements conservés. STEP-029 attend un nouveau GO, puis viendra STEP-030.
Les mentions de recette et de réduction des gabarits suivantes sont historiques.

# Disques d'ombre au sol — GRAPHICS-008

Chaque modèle d'Anne, Mako et des deux squelettes possède un disque sombre translucide.
Son diamètre est celui du corps de collision : 0,70 unité (rayon 0,35) pour les quatre
participants actuels. Les dimensions des modèles (échelle 0,65) et le contournement validés
sont conservés ; GAMEPLAY-003 est complètement annulée à la demande du propriétaire.

## Composition

StatsActor transmet GroundCrowd.RADIUS à CharacterView. Cette donnée définit la taille du
disque ; aucune taille n'est déduite d'une animation, d'une arme ou d'une boîte de mesh.
Le modèle importé garde son propre enfant et sa propre échelle. Le disque est un autre
enfant de la vue, centré sur le corps, à y = 0,006 pour éviter tout conflit avec le sol.
La rotation du personnage ne change pas son emprise circulaire. Le disque reste horizontal
et ancré au sol pendant la marche, les attaques, les sorts et la mort. La vue de mort
emporte son disque et le détruit avec elle ; le disque n'est pas un objet de collision.

FootprintShadow construit un seul PlaneMesh de côté 2 × rayon. Le shader découpe un disque
à partir des UV, avec transparence uniforme et adoucissement limité au bord intérieur.
La limite extérieure correspond au rayon fourni : pas de halo au-delà du gabarit. En vue
isométrique le cercle au sol est naturellement projeté en ellipse. Le rayon est exprimé
en unités du terrain et ne suit pas l'échelle du modèle artistique importé.

Rendu Compatibility : unshaded, alpha blend, sans écriture de profondeur ni ombre projetée,
avec test de profondeur conservé pour l'occlusion par les personnages. Aucune texture,
Decal, lumière supplémentaire, traitement physique ou callback de temps indépendant.
Les flashes de dégâts s'appliquent aux meshes du modèle, sans recolorer le disque.

## Modification artistique

Dans CharacterDefinition, séparément pour chaque apparence :

- ground_shadow_enabled : afficher/masquer le disque, sans désactiver le modèle ;
- ground_shadow_color : teinte et alpha (défaut brun presque noir, opacité 0,26) ;
- ground_shadow_feather : largeur normalisée du bord adouci (défaut 0,04).

La géométrie et le shader sont isolés dans scripts/presentation/footprint_shadow.gd et
assets/shaders/footprint_shadow.gdshader. Le style n'écrit jamais dans les paramètres du
corps, du pathfinding, des gambits ou des compétences. Un futur changement de gabarit doit
partir de la logique de collision et continuer à fournir son rayon à la vue.

## Recette

F6 scenes/debug/footprint_shadow_lab.tscn : choisir Anne/Mako, Squelette A/B, repos/marche,
les orientations et les arènes. La galerie reprend les commandes tactiles et la protection
de pause existantes. F8 puis F5 retrouve le vrai combat avec ses disques.

18 captures PC couvrent les quatre apparences sur les huit fonds illustrés et le fond de
référence (deux paires par fond), inspectées en planches de détail. Cela ne constitue pas
une nouvelle qualification de performance ni une campagne Android sur les huit fonds.
Le banc dédié vérifie le diamètre, le centrage à huit orientations, l'indépendance de
l'échelle artistique, le flash, la mort/détachement, le style et le nettoyage.
Voir steps/GRAPHICS-008.md pour l'APK, l'état de la recette et les vérifications réalisées.
