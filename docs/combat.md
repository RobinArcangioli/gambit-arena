# Combat autonome — STEP-012

CombatUnit étend StatsActor : état propre, GroundMover, AttackAction et temps de
pose. Aucun acteur ne se traite seul. CombatSimulation coordonne tous les systèmes.
Les composants STEP-007/009/010/011 restent inchangés.

## Ordre du pas

1. Pause, résultat terminal ou delta invalide : aucun traitement.
2. Retirer les ennemis morts/invalides ; vérifier victoire ou défaite.
3. Borner le delta à 1/30 s pour mouvement, actions, poses et apparitions ensemble.
4. Conserver la cible vivante du héros ; sinon choisir le plus proche, avec ordre
   d'insertion en cas d'égalité. Les ennemis visent le héros.
5. Déplacements demandés, séparation commune, application des positions.
6. Avancer les actions déjà engagées : héros puis ennemis dans l'ordre d'insertion.
7. Retirer les morts, vérifier la fin et renouveler les cibles invalides.
8. Engager les nouvelles attaques à portée ; leur temps commence au prochain pas.
9. Apparition éventuelle puis présentation.

Cet ordre donne une priorité explicite au héros à impact simultané. Un ennemi
mort ne riposte pas. Pas de simultanéité différée ni d'effets après la fin.
Le temps excédentaire d'une longue frame n'est pas rattrapé ; il ralentit l'ensemble.
Les acteurs partagent un World à transformation identité, comme les anciens labos.

## Déplacement et attaque

Vitesses des profils : héros 1,2 u/s, ennemi 0,9. Arrêt demandé à 0,8 u ; portée
AttackAction 1 u. Dès l'engagement, déplacement et correction passive de cet
acteur sont suspendus jusqu'à la fin de l'action. Les voisins le voient toujours
comme un disque. Le héros n'est jamais poussé passivement. Pas de détour calculé.
La cible d'une action reste verrouillée selon STEP-011. Une cible morte est
remplacée pour le mouvement, mais l'ancienne action ne change pas de destinataire.
L'animation présentée reste le mannequin temporaire idle/marche ; aucune animation
Attack/Hit/Death finale n'est revendiquée. Le HUD affiche phase et impacts.

## Morts, compteurs et fin

Une mort ennemie annule son action, retire son disque et cache/supprime son nœud.
Elle est comptée une fois. Une référence retirée extérieurement augmente removed,
pas defeated. Invariant : spawned = vivants + defeated + removed.
Victoire : budget entièrement apparu et aucun ennemi restant, sans retrait externe.
Un retrait externe conduit à INTERROMPU si tous les autres ennemis sont éliminés.
Défaite : héros mort/invalide. À la fin, toutes les actions sont annulées et toutes
les intentions arrêtées ; temps, apparitions et dégâts restent figés.
Ce résultat de laboratoire n'est pas encore la boucle de partie finale STEP-026.

## Scénarios de diagnostic

| Mode | Héros | Ennemis |
|---|---|---|
| Victoire | 250 PV, ATQ 30, DEF 3 | 3 présents dès le départ, chacun 60 PV, ATQ 8, DEF 1 |
| Défaite | Profil normal : 100 PV, ATQ 12, DEF 3 | Les mêmes 3 ennemis |
| Groupe 20 | 2500 PV, ATQ 12, DEF 3 | 20 apparitions au total, cadence 1 s simulée |

Les profils renforcés sont des copies locales de test : aucun .tres partagé
n'est modifié. Ce ne sont pas des valeurs d'équilibrage acquises.
Groupe 20 n'exige pas 20 vivants simultanés : des ennemis meurent entre apparitions.
Plafond de 20 vivants et budget fini de 20 ; aucune recharge, ni système de vagues.
Chaque apparition essaie les points de côté ; emplacement occupé : autre essai
ou attente à la prochaine échéance. Aucune création forcée en chevauchement.

Rejouer annule les anciens exécuteurs et recrée les acteurs. La pause de l'interface
est conservée ; les retours Android imposent une reprise explicite.
Le banc F6 teste les scénarios, les contacts, les bornes, les compteurs, les morts,
la pause, les références détruites et dix resets. Godot non exécuté ici.
Un calcul numérique indépendant soutient le scénario, sans valider GDScript.

## Validation

F6, tests manuels et fluidité confirmés OK par l’utilisateur.
STEP-012 validée, commit en attente. Voir docs/steps/STEP-012.md.

## Passage à STEP-013

CombatUnit utilise désormais SkillExecutor, dérivé de l’exécuteur d’attaque.
Le coordinateur appelle toujours begin pour une attaque basic gratuite, sans
cooldown supplémentaire. Relancer le banc combat après cette substitution.
Voir docs/skill-executor.md ; les autres règles du combat restent inchangées.

## Passage à STEP-015

CombatSimulation partage GameClock avec tous les exécuteurs et fournit un même
delta borné aux systèmes. Fin de combat : horloge arrêtée et exécuteurs retirés.
Reset préserve la pause et retire les anciens exécuteurs. Voir docs/lifecycle.md.

## Passage à STEP-017

Le héros est désormais piloté uniquement par GambitController. Le sélecteur
temporaire du héros est retiré ; les ennemis restent dans leur boucle basic.
Le diagnostic historique utilise une règle basic via le nouveau contrôleur.
Voir docs/gambit-controller.md pour les trois règles du nouveau laboratoire.

## Passage à STEP-018

La fin et le clear transmettent leur motif et temps de jeu au contrôleur pour le
journal borné. L’ordre de simulation et les règles de combat restent ceux de STEP-017.
