# Architecture réelle — STEP-008 validée, commit en attente

## Composition

Main conserve son UID et instance scenes/enemies/pursuit_lab.tscn, dérivée de
l’arène STEP-006. Le laboratoire STEP-007 reste disponible en F6 sans modification.
Le parent d’arène conserve caméra orthographique 2:1, éclairage, fond 2D,
SubViewport 3D transparent, zone sûre, six cases inactives et commandes de pause.
Le mannequin orange statique hérité est retiré au démarrage du nouveau laboratoire.

| Source | Responsabilité |
|---|---|
| scripts/enemies/enemy_unit.gd | Mannequin ennemi, GroundMover indépendant et pose |
| scripts/enemies/enemy_director.gd | Cadence, côtés déterministes, budget, liste et nettoyage |
| scripts/enemies/pursuit_lab.gd | Scénarios, route automatique du héros, commandes de diagnostic |
| scenes/enemies/pursuit_lab.tscn | Scène dérivée d’arène utilisée par Main |
| tests/test_enemy_director.gd | Tests du vrai directeur et des vrais movers dans SceneTree |
| scenes/tests/enemy_director_tests.tscn | Entrée F6 du banc STEP-008 |
| scripts/movement/ground_mover.gd | Contrôleur de déplacement validé STEP-007, inchangé |
| scripts/arena/arena_bounds.gd | Limites ±2,65 pour les pieds, inchangées |
| scripts/hybrid/proxy_actor.gd | Mannequin procédural original, inchangé |

## Simulation

Le laboratoire appelle les déplacements uniquement dans _physics_process, hors
pause locale. Le héros mobile suit quatre points via GroundMover (1,2 u/s,
arrêt 0 pour les points de diagnostic). Sa position est appliquée avant de faire
avancer le directeur. Chaque ennemi relit cette position avec son propre mover
(0,9 u/s, arrêt 0,8). Tous les acteurs partagent le repère local World à l’identité.
EnemyUnit ne traite rien de façon autonome ; advance(delta) pilote son mover
puis son temps de marche et sa pose. Les états restent NO_TARGET, MOVING,
ARRIVED, BLOCKED. La cible est fournie, aucun moteur de décision/gambit ajouté.

EnemyDirector est un Node sans boucle autonome. Il déplace d’abord les acteurs
existants, puis peut créer un ennemi : sa position initiale reste visible sur
le côté pendant ce pas. Premier ennemi après une seconde, puis cadence une
seconde de simulation ; au plus un nouvel ennemi par tick, sans rattrapage en
rafale après un long pas. Budget diagnostic 4 ou 20, plafond absolu 20 présents.
Les côtés alternent X−, Z−, X+, Z+ sur les limites intérieures ±2,65. Les groupes
suivants utilisent des décalages 0, −1,4, +1,4, −0,7, +0,7 : résultat reproductible.
Pas d’apparition hors écran ni de traversée de la bordure.

Une cible absente, détachée, queue_free ou libérée est rejetée par GroundMover.
Le directeur suspend les apparitions sans héros valide. Le bouton Retirer héros
cache le mannequin et transmet null ; les tests F6 couvrent aussi sa vraie
destruction. Rendre héros restitue la cible à tous les ennemis conservés.
Arrêter les apparitions n’arrête pas les ennemis déjà présents. La cadence repart
sans dette ; le budget total émis ne se renouvelle pas après suppression d’un ennemi.
Ce comportement n’est pas encore un système de vagues.

## Pause et nettoyage

La pause ne fait avancer ni cadence, ni route, ni pose. Le directeur expose aussi
advance(delta, is_paused) pour tester cette suspension explicitement. Les notifications
d’arrière-plan héritées passent en pause et exigent une reprise explicite.
Rejouer cache et queue_free les ennemis, vide la liste, les compteurs et la cadence,
réactive les apparitions et le héros, réinitialise la route. L’état pause est conservé.
Le banc attend une frame pour vérifier la destruction effective des anciens nœuds.
Les références ennemies invalides sont retirées de la liste au pas suivant.

## Présentation et limites

Mannequins à 48 px, aucun changement aux assets/imports validés. Les trois boutons
supplémentaires et l’état se placent dans l’espace libre au-dessus du terrain.
La géométrie d’arène et les six réservations restent inchangées.
Version Android 0.1.0-step008, code 7, ARM64, Compatibility, sans Gradle.
Pas de séparation, évitement, dégâts ou combat. Les corps peuvent se superposer ;
une distance d’arrêt au héros ne garantit pas un espacement entre ennemis.
Les modèles riggés et animations 3D définitifs restent à produire et qualifier.
