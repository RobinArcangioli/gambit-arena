# Architecture

## Réalité à STEP-003 — laboratoire de projection

| Fichier | Rôle |
|---|---|
| project.godot | Configuration du projet et référence de la scène principale |
| export_presets.cfg | Preset Android Debug : APK standard, sans Gradle personnalisé, ARM64 |
| scenes/main.tscn | Main conserve son UID et instance ProjectionLab |
| scenes/debug/projection_lab.tscn | Monde trié et HUD indépendant |
| scripts/world/ground_projection.gd | Conversion pure entre sol et écran |
| scripts/debug/projection_lab.gd | Trajets, contrôle numérique et présentation du laboratoire |
| assets/debug/*.svg | Deux silhouettes de diagnostic et un pilier |
| icon.svg | Icône initiale du projet |
| icon.svg.import | Réglages d'import de l'icône |
| .gitignore | Exclusion du cache Godot et du dossier Android généré |
| .gitattributes | Attributs Git générés à la création du projet |
| .editorconfig | Conventions d'édition générées à la création du projet |

Les documents de suivi sont placés à la racine et dans docs/steps/.

## Réglages observés

- Nom : Gambit Arena.
- Godot retenu : 4.7.2.
- Scène principale : uid://do6vxhog253vu.
- Même UID dans scenes/main.tscn.
- renderer/rendering_method : gl_compatibility.
- renderer/rendering_method.mobile : gl_compatibility.
- Métadonnée de rendu : GL Compatibility, correction confirmée par l'utilisateur.
- Étirement existant : canvas_items, aspect expand.
- Résolution de référence initiale : 540 × 960, à valider visuellement en STEP-004.
- Orientation Android : Portrait (window/handheld/orientation=1).
- Import ETC2/ASTC : textures/vram_compression/import_etc2_astc=true.

Ce dernier réglage prépare ces formats pour les textures utilisant la compression
VRAM ; il ne définit pas les réglages individuels des futurs sprites.

## Preset Android observé

- Nom : Android Debug ; plateforme Android.
- Ressources : all_resources.
- Compilation Gradle : désactivée.
- Architecture activée : arm64-v8a uniquement.
- Identifiant : org.gambitarena.prototype.
- Nom affiché : Gambit Arena.
- Version : 0.1.0 ; code 1.
- Signature : activée ; chemin de sortie encore vide.
- Aucune permission activée dans l'extrait transmis.

La validation globale de STEP-002 a été reçue le 21 octobre 2026. Aucun résultat
de contrôle UI distinct n'a été transmis pour Runnable ou les messages du preset. Le nom du preset ne garantit pas un export de
débogage : Export With Debug devra être vérifié lors de la génération.
Aucun APK n'a été généré, installé ou lancé.

Les chemins SDK/JDK sont des paramètres locaux de l'éditeur, distincts de
la configuration versionnée. Voir [l'environnement Android](docs/android.md).

Le réglage de physique 3D Jolt et le réglage de pilote Windows sont présents,
mais aucun système 3D n'est utilisé.

## Responsabilités actuelles

Main reste le point d'entrée et instance ProjectionLab. Le script du laboratoire
possède une horloge locale et les positions logiques de ses trois acteurs.
Il projette ces positions vers les racines Node2D ; les Sprite2D enfants sont
ancrés aux pieds. World active y_sort_enabled et conserve tous les acteurs
au même z_index. Le HUD appartient à un CanvasLayer distinct.

Le script construit les Sprite2D et repères Line2D au démarrage. La hiérarchie
complète, les conversions et les seuils sont décrits dans docs/coordinates.md.
Aucun autoload, combat, gambit, collision ou contrôleur de héros n'est livré.
La pause locale n'est pas encore la pause globale du jeu.
La logique de diagnostic sera remplacée dans les étapes de gameplay prévues.

## Principes approuvés pour les étapes futures

- Séparer données, décisions, exécution des actions et présentation.
- Utiliser un plan logique au sol et une projection centralisée.
- Le déplacement exécute une intention ; il ne choisit pas sa cible.
- Un seul décideur automatique pilote le héros après STEP-017.
- Les animations ne possèdent pas l'horloge des dégâts.
- Une compétence partage son exécuteur entre gambit et commande manuelle.
- Les états mutables appartiennent à chaque acteur.
- Aucun système de gameplay anticipé n'est implémenté à ce stade.

Ces principes sont des décisions de conception, pas des composants existants.
