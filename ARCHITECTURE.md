# Architecture réelle — STEP-017 validée, commit en attente

Main conserve son UID et ouvre scenes/gambits/gambit_battle_lab.tscn.
CombatSimulation possède un GambitController, seul appelant automatique des cibles
et compétences du héros. Le choix temporaire du héros a été retiré ; seuls les
ennemis restent dans la boucle de lancement basic du coordinateur.

Le contrôleur capture des valeurs copiées depuis les acteurs, leurs exécuteurs
et GameClock, puis appelle l'évaluateur pur de STEP-016. Chaque CombatUnit reçoit
un combat_id positif monotone à sa création, distinct de son serial d'affichage.
Les IDs restent stables pendant sa vie et ne sont pas réutilisés au reset.
L'évaluateur ne reçoit jamais les acteurs ou leurs états vivants.

Planification au premier tick, puis à 10 Hz lorsque libre ; invalidation d'une cible
ou règle détectée au prochain tick sans attendre la période. Pendant une action
engagée, aucune replanification et aucun changement de sa cible verrouillée.
Une intention offensive fournit la cible à GroundMover ; soin ou aucune intention
retire la cible de déplacement. Mouvement et contacts restent dans le coordinateur.

Après avance des actions existantes et retrait des morts, execute revalide la règle
sélectionnée sur un snapshot frais restreint à sa cible. Il vérifie aussi les acteurs,
leurs identités d'état, appartenance au combat et signature de règle. À portée,
il appelle SkillExecutor.request. Coût, cooldown et ID restent gérés uniquement par
l'exécuteur ; chaque intention est consommée une fois. Pas d'action de secours
implicite lorsque toutes les règles sont désactivées.

Ordre du tick : purge/fin, horloge, plan héros, cibles ennemies, mouvement/contact,
actions existantes héros puis ennemis, purge/fin, engagement héros puis ennemis,
apparitions, présentation. Les nouveaux engagements ne reçoivent du temps qu'au
tick suivant. Les acteurs restent immobiles pendant leurs actions.

Terminal/clear invalident l'intention. Reset retire les anciens exécuteurs,
recrée les acteurs et réinitialise le contrôleur tout en conservant les règles et
la pause. Les scénarios du laboratoire remplacent explicitement le préréglage.
Les diagnostics historiques utilisent une seule règle basic, via le même contrôleur.

GameClock, AttackAction, SkillExecutor, profils, évaluateur et mouvement/contact
conservent leur implémentation STEP-016. Aucun éditeur tactile ni priorité manuelle.
Mannequins temporaires et six cases inactives conservés. Version 0.1.0-step017,
code 16. F6 et tests manuels confirmés OK par l’utilisateur.
