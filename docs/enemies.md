# Ennemis — STEP-008

Statut : validé par l’utilisateur, commit en attente. Tests manuels OK, aucune
saccade observée ; verrouillage et réduction/retour confirmés.

## Contrat

EnemyUnit dérive du mannequin existant, possède un GroundMover indépendant,
une horloge de marche et les mêmes ancrages au sol. initialize s’appelle après
add_child (membres visuels créés dans _ready). advance déplace puis présente.
EnemyDirector.configure reçoit un World Node3D et un héros dans le même repère.
set_hero fournit une cible à toutes les instances ; null annule leur intention.
Le directeur ne choisit pas une autre cible si le héros disparaît.

| Réglage | Valeur |
|---|---|
| Vitesse héros mobile | 1,2 u/s |
| Vitesse ennemie | 0,9 u/s |
| Distance d’arrêt ennemi | 0,8 u |
| Cadence nominale | 1 s de simulation |
| Budgets des scénarios | 4, 4, 20 |
| Plafond de présence | 20 |
| Pieds aux côtés | ±2,65 u, dans l’arène |

Les côtés sont ceux du carré logique, projetés en losange, pas les quatre bords
de l’écran. Les points d’apparition restent dedans pour éviter qu’un clamp ne
ramène brutalement un acteur initialement extérieur. Positions déterministes,
pas d’aléatoire ni de mécanisme de vagues. Un pas long ne crée qu’un ennemi.
La pause conserve la fraction de cadence. Apparitions non ou héros absent remet
la cadence à zéro au pas suivant ; reprise après une seconde active sans rafale.

## Scénarios

1. Héros fixe au centre, quatre ennemis successifs ; approche puis arrêt à 0,8 u.
2. Héros mobile suivant automatiquement un carré intérieur ; quatre poursuivants
   réorientent leur déplacement sur sa position actuelle.
3. Même route, vingt apparitions ; laisser au moins 25 secondes et vérifier que
   le compteur ne dépasse pas 20. Chevauchements attendus avant STEP-009.

Retirer héros masque le modèle et invalide sa cible logique. Les ennemis
s’arrêtent et les apparitions sont suspendues. Rendre héros reprend la poursuite.
La vraie suppression du Node3D est couverte par le banc F6. Rejouer conserve
la pause mais restaure l’ensemble du scénario, sans anciennes instances visibles.

## Tests

scenes/tests/enemy_director_tests.tscn, F6 : quatre côtés, compteurs, movers
indépendants, points dans les limites, vitesse, pause des horloges et pose,
cible mobile/absente/détruite, plafond, nettoyage, arrêt/reprise de cadence et
pas long sans rafale. Attendu OK, zéro échec. Banc non exécuté chez l’assistant.
Le banc STEP-007 est conservé pour le contrôleur partagé inchangé.

La distance 0,8 est un réglage d’approche, pas encore une portée de combat.
La séparation bornée et l’encerclement appartiennent à STEP-009.
