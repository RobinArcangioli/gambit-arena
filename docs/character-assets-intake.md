# Modèles retenus — réception du 26 octobre 2026

Choix actualisé du propriétaire : Anne et Mako du Pirate Kit pour les héros ; les deux
squelettes de ce même Pirate Kit pour les ennemis. Les six archives KayKit sont réservées
pour plus tard, y compris KayKit Skeletons initialement envisagé.
Ce document décrit une inspection des données glTF, pas une intégration ou une recette moteur.
Base : GRAPHICS-002 clôturée au commit `1e427560a9d2884ce1d3e339a093d576192fc22f`.

## Sources inspectées

| Archive dans Downloads | SHA-256 |
|---|---|
| Pirate kit-glb.zip | `9e312bdd2c41a9c3ffd76d9716334e3249cfffea1fa13aecda1ef9809385246c` |
| KayKit_Skeletons_1.1_FREE.zip | `21fbad59ee6cc1d7bed12d0e425acab8ebe564b8620bbc1d017aedb29dd8a3d2` |

Le pack Skeletons contient une licence déclarant CC0 et Kay Lousberg comme créateur.
L'archive Pirate contient uniquement des GLB : auteur et licence ne sont pas établis par
ces fichiers. Conserver cette provenance comme non renseignée, sans inventer de licence.

## Modèles et animations disponibles

Anne et Mako possèdent chacun un skin de 58 joints, deux meshes et une texture PNG embarquée.
Les noms complets des animations comportent plusieurs préfixes `CharacterArmature|` et
certains suffixes tronqués. La table de correspondance devra utiliser les noms réellement
importés par Godot, avec vérification de leur existence, plutôt que des indices numériques.

Les deux héros contiennent les mêmes 14 clips, présentés ici sous leur nom abrégé :
Death (0,75 s), Duck (1,667 s), HitReact (0,583 s), Idle (1 s), Jump_Idle (0,5 s),
Jump_Land (0,333 s), Jump (0,333 s), No (1,667 s), Punch (0,75 s), Run (0,708 s),
Sword (0,833 s), Walk (1 s), Wave (1,667 s), Yes (1,667 s).
Ces durées sont les maxima des entrées temporelles glTF, avant import moteur.

Les ennemis retenus sont `Skeleton.glb` et `Skeleton-yq5ATpujSt.glb` du Pirate Kit.
Chacun possède un skin de 58 joints et 15 animations embarquées : les 14 noms de clips
présents chez Anne et Mako, plus `Jump_Idlea`. Les clips utiles (Idle, Walk, Run, Sword,
Punch, HitReact, Death) sont donc disponibles directement sur chaque modèle.
Leur rendu, les poses de repos et les ancrages restent à vérifier dans Godot.

| Modèle ennemi | SHA-256 |
|---|---|
| Skeleton.glb | `300878829f3d0c4fd2cf030505405f67682617b08714835c3914c2f63660c43c` |
| Skeleton-yq5ATpujSt.glb | `80be43fa7bd961faef44fa82a8067048a48ba329d65fed663a184ee73a18aacb` |

L'inspection préalable de KayKit Skeletons avait identifié des modèles sans clips embarqués
et deux bibliothèques séparées. Ce raccordement est désormais hors périmètre : les modèles
et animations KayKit ne sont pas utilisés dans cette première intégration.

## Correspondance prévue avec le jeu

| État / action | Anne et Mako | Squelettes | Étape |
|---|---|---|---|
| Repos | Idle | Idle | GRAPHICS-003 |
| Déplacement | Walk ou Run selon rendu à la vitesse logique | Walk ou Run | GRAPHICS-003 |
| Attaque | Sword ou Punch selon équipement | Sword ou Punch selon équipement | GRAPHICS-004 |
| Coup reçu | HitReact | HitReact | GRAPHICS-004 |
| Mort | Death | Death | GRAPHICS-004 |
| Soin (`heal`) | Duck | Duck si cette action est utilisée | GRAPHICS-005 |
| Foudre de Mako | Duck | Duck si cette action est utilisée | GRAPHICS-006 |

Choix explicite du propriétaire : utiliser `Duck` comme geste visuel `cast spell` pour
le soin et la Foudre. Cette correspondance reste dans les profils de présentation ;
les compétences propres à Anne et Mako sont définies dans le
[plan équipe et compétences](party-skills-plan.md). La catégorie spéciale/secondaire
est supprimée du périmètre cible. Adapter la lecture de Duck aux incantations désormais
fixées à 1,5 s pour le soin et 2 s pour la Foudre, pilotées par le jeu. Les effets propres
au soin et à la Foudre permettent de distinguer les deux actions malgré le geste commun.
Ce choix n'ajoute aucune compétence aux ennemis. Aucun téléchargement d'animation
supplémentaire ni utilisation des autres kits n'est engagé par cette réception.

## Intégration GRAPHICS-003

Préparer Anne et Mako comme deux profils visuels indépendants pour les deux futurs héros
alliés. Leur coexistence en combat est traitée dans GAMEPLAY-001, après GRAPHICS-003.
Préparer les squelettes comme habillages des ennemis existants,
avec `Skeleton.glb` comme premier profil et `Skeleton-yq5ATpujSt.glb` comme variante. Conserver les GLB sources intacts et placer
échelle, orientation, pivot, sockets et correspondances de clips dans des enveloppes de
présentation remplaçables.

La simulation reste propriétaire des positions, cibles, durées et impacts. Les animations
suivent le temps de jeu et ne déclenchent jamais dégâts, soin ou coût. Aucun root motion
ne déplace l'acteur logique. Extraire le mannequin de l'héritage de StatsActor et conserver
les modes mannequin et vue nulle pour comparer les états de combat.

Vérifications restant à effectuer : import Godot, poses de repos, ancrage des pieds,
orientations, dimensions, boucles, déplacement visuel des racines, pause/reprise et charge
sur Android. L'inspection des archives ne valide aucun de ces points.
