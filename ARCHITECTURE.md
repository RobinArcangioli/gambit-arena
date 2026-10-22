# Architecture réelle — STEP-009 validée, commit en attente

## Composition

Main conserve son UID et instance scenes/crowd/crowd_lab.tscn, dérivée de l’arène
STEP-006. Tous les scripts des étapes précédentes restent inchangés. Leur usage
historique via F6 est conservé ; le nouveau coordinateur réutilise GroundMover,
EnemyUnit et les positions déterministes d’EnemyDirector sans leur déléguer le tick.

| Source | Responsabilité |
|---|---|
| scripts/crowd/ground_crowd.gd | Disques, séparation bornée, contrôle du segment de déplacement |
| scripts/crowd/crowd_simulation.gd | Tick commun, intentions, résolution, application, apparitions |
| scripts/crowd/crowd_lab.gd | Scénarios, intentions du héros, commandes et présentation |
| scripts/crowd/crowd_marks.gd | Empreintes 2D projetées sous les modèles 3D |
| scenes/crowd/crowd_lab.tscn | Scène utilisée par Main |
| tests/test_ground_crowd.gd | Tests des vrais solveur et coordinateur dans SceneTree |
| scenes/tests/ground_crowd_tests.tscn | Entrée F6 du banc |

## Tick commun et responsabilités

CrowdSimulation.advance est appelé une fois par pas physique depuis le laboratoire.
Aucun ennemi ne se traite seul. Une pause retourne avant toute modification.
Le pas accepté vaut min(delta, 1/30 s) : pas de rattrapage violent d’un grand delta.
Ce même pas alimente intentions, poses et cadence ; un pas exceptionnel trop long
ralentit donc le temps simulé, sans faire avancer les apparitions en avance.

Le coordinateur capture les positions, demande à chaque GroundMover un déplacement
puis restaure sa position avant de résoudre les contacts. Les intentions lisent
la position du héros en début de tick ; les transformations visuelles ne sont
appliquées qu’après résolution. Les états et vitesses sont recalculés sur le
mouvement effectivement accepté, et non la vitesse souhaitée. Le temps de marche
n’avance que si la position change. L’arrivée et la limite ne garantissent pas
la possibilité de contourner un autre acteur.

Les acteurs partagent World à l’identité : Vector2(x,z), y=0 en 3D. Le héros est
l’index 0, puis les ennemis restent dans leur ordre d’insertion. L’ordre est stable,
mais non symétrique : il introduit une priorité, pas une simulation de masses.

## Contacts au sol

Disques de rayon 0,35 ; distance minimale nominale des centres 0,70. Les limites
ArenaBounds restent ±2,65. GroundCrowd travaille sur une copie des positions.
Pour chaque acteur autorisé à corriger : somme des demi-pénétrations dirigées
vers l’extérieur, plafonnée à 0,6 × dt. Centres confondus : normale déterministe
antisymétrique. Le héros n’est jamais poussé passivement ; les gardiens du scénario
Blocage sont également fixes. Un chevauchement pathologique peut persister si
aucune direction de correction admissible n’existe ; aucune éjection forcée.

Correction puis intention passent par un test analytique segment/disque contre
les voisins. Le déplacement est tronqué au premier contact, avec marge 0,0001.
Pour une pénétration préexistante, seules les directions ne l’aggravant pas sont
acceptées. Le clamp d’arène précède le test du segment. Pas de glissement automatique,
pathfinding ou recherche de détour. Le solveur borne aussi chaque intention à
1,2 × dt ; les intentions ennemies sont déjà bornées à 0,9 × dt par GroundMover.
Ainsi le héros parcourt au plus 1,2 × dt, un ennemi au plus (0,9 + 0,6) × dt.
Ces bornes excluent uniquement les positions initiales créées par Rejouer/scénario.

## Apparitions, vie des références et pause

Cadence une seconde simulée, au plus un nouvel acteur par tick et 20 au total.
Chaque apparition essaie les 20 points de côté existants à partir de l’index
courant. Un centre doit être à au moins 0,71 unité des autres centres. Si tous
les points sont occupés, l’apparition attend la prochaine échéance. Aucun acteur
vivant n’est déplacé pour libérer une place. Le budget ne se recharge pas après retrait.

La pile de Bordure utilise explicitement allow_overlap pour créer un cas invalide
à corriger ; cette exception n’est jamais utilisée par les apparitions normales.
Une cible héros invalide arrête le coordinateur et annule les intentions ennemies.
Les ennemis libérés ou queue_free sont purgés ; Rejouer cache puis supprime les
anciennes instances et remet cadence, horloges, compteurs et maximum de pas à zéro.
Arrière-plan : pause héritée de l’arène, reprise explicite. Rejouer conserve la pause.

## Présentation et limites

Rendu 2D/3D, caméra 2:1, modèles 48 px, zone sûre et six cases inactives conservés.
Des disques 2D projetés apparaissent avec Repères ; ils servent à distinguer
contact au sol et occultation des silhouettes. Le HUD montre l’état du héros,
le nombre de bloqués et le plus grand pas réellement observé depuis Rejouer.
Version 0.1.0-step009 code 8, ARM64, Compatibility, sans Gradle.
Ni PV, attaque, dégâts, masse physique, évitement global ni animation finale.
Les scènes historiques demeurent des diagnostics, pas des systèmes simultanés.
