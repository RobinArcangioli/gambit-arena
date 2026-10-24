# Architecture réelle — STEP-019 validée, commit en attente

Main conserve son UID et ouvre scenes/gambits/gambit_editor_lab.tscn.
GambitEditor possède trois règles de session initialisées depuis standard_rules.
Il permet uniquement toggle(index) et move(index, -1 ou +1), refuse les indices
hors limites et émet changed une fois par modification acceptée. Le déplacement
échange les règles complètes, activation comprise. snapshot retourne des Resources
copiées ; ni contrôleur ni lecteur ne partagent les règles internes modifiables.

GambitEditorLab étend BattleLab et réutilise CombatSimulation sans modifier son code.
Un seul raccordement changed appelle controller.stop avec rules_changed puis remplace
la configuration du contrôleur par une copie. Toute intention en attente est effacée,
même si une autre règle de priorité supérieure a changé. La prochaine planification
utilise la nouvelle configuration. L'exécuteur d'une action engagée reste propriétaire
de son action et de sa cible ; coût, cooldown et impact ne sont pas rejoués.

Les règles sont modifiables pendant la pause : seuls configuration, intention et
présentation évoluent ; le temps de jeu reste figé. Le journal peut consigner une
invalidation à temps constant lors d'une édition explicite. Aucun nouveau combat,
mouvement ou engagement n'est exécuté par les boutons de règles.
Rejouer et changer de scénario conservent ordre et activation ; le changement de
scénario reste bloqué en pause. Retour d'arrière-plan : reprise explicite conservée.

L'interface possède trois lignes fixes, boutons Oui/Non, Haut et Bas de 56 px de haut.
Les déplacements hors tableau sont désactivés. Les signaux sont raccordés une fois,
sans reconstruire les contrôles après édition ou reset. Le panneau bas remplace les
six emplacements réservés uniquement dans ce laboratoire ; les anciennes scènes restent
inchangées. La taille de référence reste 540 × 960 et les marges sûres sont réutilisées.

GambitEvaluator, GambitController, GameClock, SkillExecutor, AttackAction,
acteurs, profils et solveur de contact sont identiques à STEP-018.
FIX-STEP-019-001 modifie uniquement la demande de déplacement du héros dans
CombatSimulation : aucune approche supplémentaire lorsque la cible vivante sélectionnée
est déjà à portée Action.REACH. Hors portée, le mouvement habituel reprend.
Les ennemis gardent leur déplacement existant. Les actions actives restent verrouillées.
Le code de pose du mannequin et ses animations procédurales restent inchangés.
Le laboratoire diagnostics STEP-018 reste accessible par sa scène historique.
Le nouveau banc vérifie copies, bornes, signaux, réordonnancement, priorité réelle,
intentions, actions engagées, pause et resets. Godot non exécuté chez l'assistant.
Version 0.1.0-step019, code 18. Pas de persistance ou d'édition des champs de règle.
