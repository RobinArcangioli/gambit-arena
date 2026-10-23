# Compétences et récupération — STEP-014

Les trois actions passent par SkillExecutor : mêmes validations, engagement unique,
verrou d'impact et horloge. Valeurs provisoires de prototype, pas équilibrage validé.

| Action | Cible | Effet | Coût | Cooldown |
|---|---|---|---|---|
| basic | Autre acteur vivant à <= 1 u | max(1, attaque - défense) | 0 | 0 additionnel |
| heal | Soi-même vivant et blessé | Jusqu'à 30 PV | 20 | 4 s |
| special | Autre acteur vivant à <= 1 u | max(1, 2 × attaque - défense) | 30 | 6 s |

Toutes ont une préparation de 0,6 s et une récupération d'action de 0,4 s.
Le cooldown commence à l'engagement. Attaque copiée à l'engagement, défense lue
à l'impact ; dégâts bornés aux PV restants. Soin borné aux PV manquants.
Le soin ne ressuscite jamais et ne peut viser un autre acteur. Un soin demandé
à PV pleins est refusé sans coût. Si les PV deviennent pleins pendant la préparation,
le soin applique zéro PV ; l'engagement reste consommé, sans remboursement.

Une seule action active par acteur. Aucun lancement n'interrompt une action.
Une attaque spéciale manquée après sortie de portée conserve son coût/cooldown.
La mort ou le remplacement de l'état source retire l'exécuteur avant tout effet.
Les gardes d'ID, doublon et réentrance restent dans AttackAction.try_impact.
Le soin utilise la même garde ; applied_healing est séparé de applied_damage.
AttackAction expose seulement deux points de spécialisation : paire de cibles
admise et application de l'effet. Son comportement d'attaque par défaut est conservé.

## Ressource

Récupération passive : 5 points/s de temps de jeu, plafond 60. Les fractions sont
accumulées, puis créditées par points entiers. Aucun excédent n'est stocké au plafond.
Récupération pendant préparation, récupération d'action et repos. Aucune en pause,
après mort/retrait de l'exécuteur, ni avec un delta invalide. Le coordinateur borne
le delta commun à 1/30 s ; aucun rattrapage du temps passé en arrière-plan.

Le constructeur active explicitement la récupération. Elle est active dans le
nouveau laboratoire et CombatUnit ; l'ancien diagnostic STEP-013 la laisse désactivée
pour conserver ses compteurs de recette. Le combat autonome continue à demander
uniquement basic : aucune stratégie automatique de soin/spéciale n'est ajoutée.
L'entrée paid_test reste disponible pour les tests historiques, sans nouveau rôle.

## Laboratoire et limites

Héros initialement blessé : 60/100 PV, attaque12. Ennemi passif : 600 PV, défense1.
Attaque normale : 11 dégâts ; spéciale : 23. La cible renforcée utilise une copie
du profil, sans changer les .tres. Bouton Blesser30 : intervention de test explicite.
Trois scénarios : compétences avec énergie60, ressource initialement vide,
mort de la source à 0,3 s de sa première action. Rejouer retire l'ancien exécuteur,
recrée les acteurs et conserve la pause.

Les six emplacements de compétences restent inactifs ; les boutons du laboratoire
sont provisoires. Pas de cible alliée, zone d'effet, animation finale, priorité
manuelle, file d'attente, gambits ou éditeur. STEP-015 approfondira pause commune
et interruption de l'ensemble des compétences, puis les gambits suivront.

F6 : scenes/tests/skills_tests.tscn. Relancer aussi attack_action_tests,
skill_executor_tests et combat_simulation_tests car leurs composants sont partagés.
Godot non exécuté chez l'assistant.

## Validation

F6, tests manuels et fluidité confirmés OK par l’utilisateur.
STEP-014 validée, commit en attente. Voir docs/steps/STEP-014.md.

## Passage à STEP-015

L’horloge liée bloque maintenant aussi les demandes et callbacks d’impact directs.
La mort/sortie d’arbre annule immédiatement les actions concernées, même en pause.
Les compétences gardent leurs valeurs. Voir docs/lifecycle.md et STEP-015.
