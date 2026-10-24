# Architecture réelle — STEP-018 validée, commit en attente

Main conserve son UID et ouvre scenes/gambits/gambit_diagnostics_lab.tscn.
GambitEvaluator.evaluate et explain partagent le même parcours _run. evaluate
retourne le contrat STEP-016 inchangé ; explain ajoute au plus trois motifs de règles.
Aucun acteur, coût ou cooldown n'est modifié par l'évaluation ou l'explication.
Une règle sous la priorité retenue est marquée lower_priority sans être évaluée.

GambitController collecte les explications à la planification et journalise décisions,
engagements acceptés, invalidations, refus d'exécuteur et arrêts. La revalidation reste
limitée à la règle/cible sélectionnée ; son motif est consigné si elle invalide le plan.
Le refus d'exécuteur est enregistré au plus une fois par intention en attente.
Pas de trace par frame d'approche ou d'action occupée. Le diagnostic est désactivable.

GambitTrace conserve les 64 dernières entrées, élimine la plus ancienne au dépassement
et expose total/dropped. Champs autorisés seulement, chaînes bornées, trois motifs
maximum, copies profondes à la lecture. Ni acteur, ni état, ni snapshot stocké.
Le contrôleur garde seulement la dernière explication, également bornée et copiée.
Les dates sont le temps de jeu de GameClock. CombatSimulation transmet l'heure de
clear/terminal ; ses mouvements, ordre d'actions et apparitions ne changent pas.

Le laboratoire montre soit le combat réel à trois règles, soit un des huit snapshots
fixes de GambitScenarios. Dans les cas fixes, le monde est masqué et n'est pas avancé ;
les lectures sont cadencées à 10 Hz par GameClock. Une prévisualisation initiale est
calculée au reset, même en pause, sans événement dans le journal. Le compteur de
lectures commence à zéro. Les règles et données des fixtures sont recréées à chaque reset.

Vue journal : quatre dernières entrées seulement. Vue raisons : dernière décision
et motifs des trois règles. Une ancienne lecture ne prétend pas décrire l'état courant.
La pause bloque nouvelles lectures/écritures ; la vue reste consultable. Reset efface
le journal, ses compteurs et les explications, tout en gardant pause et activation.

Le banc diagnostics compare les trajectoires avec/sans trace et les journaux de deux
combats après normalisation des IDs de session. Il contrôle huit fixtures, 2000 écritures,
copies, invalidations, refus, pause et dix resets. F6 et tests manuels confirmés OK par l’utilisateur.
Acteurs, profils, compétences, actions, mouvement/contact et GameClock restent inchangés.
Version 0.1.0-step018, code 17. Pas d'éditeur ni de priorité manuelle ajoutés.
