# Extension GAMEPLAY-002

GroundMover et ses anciens bancs restent inchangés. Dans Main, le déplacement de PartyUnit
est désormais proposé par LocalNavigator puis limité par GroundCrowd ; les données du mover
sont mises à jour avec le mouvement effectué. Voir local-navigation.md. Les descriptions
ci-dessous sont celles des étapes initiales, sans détour à cette époque.

# Déplacement au sol — STEP-007

## API et responsabilité

GroundMover exécute une intention sans la sélectionner.

- reset(start) : borne la position initiale, remet les états et supprime la cible.
- set_target(node) : remplace la cible, ne téléporte pas la position.
- clear_target() : supprime la cible et annule immédiatement la vitesse.
- step(delta) : avance un pas de simulation, sauf cible invalide ou arrivée.
- has_valid_target() : objet vivant, non en attente de suppression, dans l’arbre.

Le propriétaire appelle step seulement quand le temps de jeu avance. Ce composant
ne possède pas sa propre pause ni de traitement automatique. Les positions de
cible sont lues dans le même repère local de World que le héros.

## Géométrie et temps

Valeurs initiales : speed=1,2 unité/s, stopping_distance=0,8 unité.
Pour distance d entre racines au sol : pas=min(speed×delta, d-distance_arrêt).
Le vecteur vers la cible est normalisé avant application du pas. Le résultat
est borné à ±2,65 selon ArenaBounds. La vitesse effective est (nouveau-ancien)/delta.
La vitesse n’est jamais calculée en pixels projetés. Une portée de combat future
ne doit pas être déduite directement de la taille des modèles à l’écran.

Une tolérance de 0,00001 unité évite les oscillations numériques à l’arrivée.
Le dernier pas est raccourci ; un grand delta ne fait pas dépasser la distance
d’arrêt. Une cible déjà dans cette distance ne fait pas reculer le héros.
Une cible déplacée est relue au prochain pas, même si le héros était arrivé.
L’absence de cible stoppe la position, sans destination précédente mémorisée.

## Limites

La cible n’est pas ramenée artificiellement à l’intérieur de l’arène. Si elle
reste hors domaine, le héros atteint le bord ; BLOCKED indique que l’intention
n’est pas réalisable à ce pas. Il n’existe ni détour, pathfinding, collision ni
mécanisme anti-blocage dans cette étape. Le bornage peut produire un glissement
le long d’un bord pour une direction oblique ; il ne garantit pas une vitesse
constante après contrainte. La marge reste celle du mannequin temporaire.

## Scénarios de recette

1. A puis B : héros (-1,8 ; 0), A (1,6 ; -1,3), B (-1,6 ; 1,6).
   Arrivée à A, attente 0,5 s, arrivée à B, attente 0,5 s, aucune cible.
2. Axes : héros au centre, A (2 ; 0), B (0 ; 2). Même séquence ; comparer la
   vitesse au sol affichée à celle du premier scénario, pas les pixels/seconde.
3. Bordure : A (4,5 ; 4,5), volontairement hors arène. Le héros reste au bord
   à (2,65 ; 2,65), état LIMITE ; B permet de le faire revenir dans l’arène.
4. Disparition : A retirée après 0,75 s de simulation ; arrêt sans cible, sans
   erreur sur référence libérée. Choisir B doit permettre de reprendre l’approche.

A/B/Aucune désactivent la séquence automatique pour tester un changement en
mouvement. Rejouer recrée A si besoin, remet le scénario et réactive AUTO.
Les cibles sont des objets de test, pas des ennemis avec PV, vie/mort ou IA.
Le bouton de scénario provoque une réinitialisation explicite ; ce n’est pas
une téléportation effectuée par le contrôleur de déplacement.

## Tests fournis

Ouvrir scenes/tests/ground_mover_tests.tscn et F6. Résultat attendu : OK, zéro échec.
Le banc utilise le vrai GroundMover avec des Node3D dans l’arbre :
- distance parcourue identique sur axe/diagonale à 30/60/120 pas par seconde ;
- grand pas, arrivée stable et cible déplacée après arrivée ;
- changement de cible sans téléportation et annulation immédiate ;
- cible hors arène et état bloqué ;
- cible queue_free, libérée immédiatement ou retirée de l’arbre.

Le 22 octobre 2026, l’utilisateur confirme ces tests F6 : OK, zéro échec.
Ils n’ont pas été exécutés chez l’assistant (Godot indisponible).
Ils ne couvrent pas les événements Android ni le rendu, qui restent manuels.

## Recette validée

L’utilisateur confirme aussi les six scénarios d’acceptation : A puis B,
changement/annulation, vitesse, bordure, disparition et pause/reprise sans saut.
Voir docs/steps/STEP-007.md pour le détail du retour et l’APK identifié.

## Réutilisation STEP-008

GroundMover reste inchangé. Chaque EnemyUnit en possède une instance propre
avec vitesse 0,9 et arrêt 0,8 ; la cible est le héros fourni au directeur.
Le héros mobile du diagnostic utilise une autre instance, vitesse 1,2 et arrêt 0
pour ses points de route. Voir docs/enemies.md. La séparation reste STEP-009.

## Contacts STEP-009

GroundMover reste inchangé. CrowdSimulation calcule son déplacement souhaité,
puis GroundCrowd tronque ce déplacement aux contacts. Position, vitesse et état
sont ensuite recalculés sur le mouvement accepté. Un voisin peut produire BLOCKED,
même sans atteindre la bordure. Le héros n’est pas poussé passivement.
Le laboratoire historique STEP-007 continue d’utiliser son contrat initial.
