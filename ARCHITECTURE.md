# Architecture réelle — STEP-013 validée, commit en attente

Main conserve son UID et ouvre scenes/skills/executor_lab.tscn, dérivée de l'arène.
SkillExecutor hérite de la garde d'impact AttackAction, qui reste inchangée.
Il ajoute l'engagement commun, une ressource et une table de cooldowns par acteur.

| Élément | Responsabilité |
|---|---|
| SkillExecutor.request | Valider, engager, débiter et démarrer le cooldown une seule fois |
| SkillExecutor.begin | Adaptateur basic pour le combat autonome existant |
| SkillExecutor.advance | Horloge commune des cooldowns et de l'action |
| SkillExecutor.retire | Invalidation définitive au reset ou à la mort |
| ExecutorLab | Demandes manuelles/automatiques et présentation des compteurs |
| CombatUnit | Possède désormais SkillExecutor.new(self), un exécuteur par acteur |

Le coordinateur CombatSimulation et les autres classes précédentes restent
inchangés. Leurs appels begin/advance passent désormais par SkillExecutor.
L'attaque basic est gratuite, sans cooldown supplémentaire ; sa récupération
STEP-011 reste le verrou de cadence. paid_test sert seulement à la recette.

Le coût est engagé au lancement accepté, jamais à l'impact. Le cooldown commence
au même instant. Pas de remboursement après coup manqué/annulation ; pas de
régénération. Le cooldown avance aussi au repos, mais jamais pendant la pause.
Le laboratoire retire explicitement les anciens exécuteurs au reset. Une source
morte ou dont l'état change invalide l'exécuteur ; aucun recyclage de son énergie.
Contrat complet, limites et ordre de validation : docs/skill-executor.md.

Les profils de laboratoire sont des copies avec 1000 PV ; aucun .tres n'est modifié.
Les trois mannequins restent immobiles ; les six cases sont inactives. Rendu,
projection 2:1 et caméra conservés. Les animations finales ne sont pas ajoutées.
Pas encore d'exécuteur générique d'effets multiples, soin, spéciale, coûts de
plusieurs ressources, file d'attente ou priorité des commandes manuelles.
Version Android 0.1.0-step013, code 12. F6 et tests manuels confirmés OK par l’utilisateur.
