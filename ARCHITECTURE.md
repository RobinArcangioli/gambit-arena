# Architecture réelle — STEP-006 validée, commit en attente

## Scène principale et responsabilités

Main conserve son UID et instance scenes/arena/arena.tscn. La structure reprend
le rendu validé : fond Node2D, unique SubViewport 3D transparent, HUD 2D au-dessus.
Camera3D orthographique fixe (azimut 45°, élévation 30°), projection au sol 2:1.
Les personnages partagent le tampon de profondeur 3D ; aucun y_sort 2D ne les trie.

| Source | Rôle |
|---|---|
| scenes/arena/arena.tscn | Composition arène, mannequins et zones de HUD |
| scripts/arena/arena.gd | Placement de l’interface, caméra et contrôles de recette |
| scripts/arena/arena_floor.gd | Dessin vectoriel 2D du sol et de ses bordures |
| scripts/arena/arena_bounds.gd | Domaine logique au sol et bornage des racines |
| scripts/hybrid/proxy_actor.gd | Mannequins 3D validés réutilisés sans modification |
| scenes/hybrid/hybrid_lab.tscn | Diagnostic historique 3D/2D accessible avec F6 |
| scenes/debug/*.tscn | Anciens diagnostics 2D conservés |

Le HUD possède un panneau supérieur et inférieur. Six boutons désactivés sont
créés à l’exécution pour matérialiser les futurs emplacements. Aucun gestionnaire
de compétences ou gambits n’est encore présent. Les trois boutons de recette
Position, Repères et Pause ont un rôle explicite et temporaire.

## Monde et limites

Sol logique Vector2(x,z) ; altitude 3D y=0 aux pieds. Domaine carré [-3,3]².
ArenaBounds fournit clamp_ground et contains_ground, avec marge initiale 0,35
pour les mannequins. Leurs racines admissibles restent donc dans [-2,65,2,65]².
La scène demande volontairement des positions hors domaine aux quatre coins ;
elle applique le bornage avant de les afficher. Centre et coins permettent de
vérifier l’alignement, la marge visuelle et la lisibilité près des bords.
Ce helper ne déplace personne automatiquement et n’est pas une collision physique.
STEP-007 devra l’utiliser dans le futur contrôleur de déplacement.

La bordure principale correspond à ±3. Une ceinture décorative plate s’étend
jusqu’à ±3,3. Aucun obstacle occultant n’est posé sur l’arène ; les quatre motifs
sur la ceinture ne sont pas encore des points de spawn fonctionnels.
Les repères montrent la limite des racines à ±2,65 et les croix aux pieds.
Le dessin des limites utilise les constantes d’ArenaBounds.

## Projection et interface

Le fond utilise camera.unproject_position() ; son origine coïncide avec celle
du SubViewportContainer. Stretch actif, sans réduction. La largeur de caméra
vaut largeur du SubViewport / 48 : la taille apparente reste celle du prototype.
Le carré au sol est fixe. L’espace disponible du portrait peut s’allonger sans
étirer les personnages ni ajouter de zoom ou de caméra suiveuse.

Zone sûre Android convertie dans le viewport principal. À l’intérieur : panneau
supérieur de 100 px, début de l’aire de rendu à y=124, panneau inférieur de 240 px
à 12 px du bas ; marges horizontales de 16 px. Un espace de 12 px sépare rendu
et panneau inférieur sur le format portrait ciblé. Les détails sont dans docs/arena.md.
Les réservations représentent une première organisation, pas le HUD final STEP-021.

## État et comportement

Les deux mannequins ont une pose debout et une orientation fixes, sans animation
ni trajet. Position change instantanément le placement pour la recette, sauf en
pause. Cette téléportation de diagnostic n’est pas un contrôle manuel du héros.
La perte de focus passe en pause et bloque Position jusqu’à Reprendre.
Repères et les panneaux restent accessibles. Aucune horloge de combat ni sauvegarde
d’état n’est ajoutée. La reprise après destruction du processus repart du centre.

## Configuration et limites

Godot 4.7.2 standard, Compatibility, portrait 540 × 960, canvas_items/expand.
Même éclairage simple que la transition, sans ombres ou post-traitement ajouté.
APK standard ARM64, Gradle désactivé, version 0.1.0-step006 code 5, paquet inchangé.
SDK/JDK et signature restent locaux. STEP-006 n’a pas été exécutée chez l’assistant.
Le relevé de 60 FPS de la transition reste historique, sans être revendiqué ici.

Les vrais modèles riggés et cinq animations 3D sont encore à produire. La scène
réutilise les mannequins pour éviter de lier la définition de l’arène à l’art final.
Pas de collision, ennemi autonome, compétence, dégâts ou gambits anticipés.
Les décisions, le déplacement, l’exécution et la présentation resteront séparés.

## Validation reçue

Le 22 octobre 2026, l’utilisateur valide la visibilité complète de l’arène,
la lisibilité à 48 px, les cinq placements bornés, la séparation de l’interface,
la pause, les cases inactives et l’arrêt F8 sans erreur. APK installé avec succès.
Le code de cette livraison de validation est identique à la v1 testée.
