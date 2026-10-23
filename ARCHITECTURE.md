# Architecture réelle — STEP-015 validée, commit en attente

Main conserve son UID et ouvre scenes/skills/lifecycle_lab.tscn, dérivée du
laboratoire de compétences. Les scènes historiques restent disponibles.

GameClock porte pause, arrêt terminal et temps écoulé. Chaque coordinateur appelle
step une fois par tick : delta positif fini, borné à 1/30 s, sans rattrapage.
CombatSimulation utilise ce même pas pour mouvement, poses, actions, cooldowns,
récupération et apparitions. LifecycleLab l'utilise pour ses compétences statiques.
Chaque SkillExecutor du coordinateur référence la même horloge ; request, advance
et try_impact consultent la porte commune. L'horloge n'est pas avancée par acteur.
Les anciens laboratoires sans horloge liée conservent leur contrat explicite paused.

AttackAction connecte la mort et la sortie d'arbre des participants à l'engagement,
puis déconnecte à l'annulation ou à la fin. Mort de la source : annulation immédiate ;
SkillExecutor se retire définitivement. Mort de la cible avant effet : annulation.
Après effet déjà résolu, la disparition de la cible ne supprime pas la récupération.
Une mort imposée extérieurement pendant la pause invalide donc l'action immédiatement.
Le verrou d'impact reste posé avant l'émission des signaux de PV.

Les gardes de vie, identité d'état, portée, ID et résolution restent actives.
Remplacement d'état détecté à l'avance ou à la validation d'effet ; aucune mutation
de l'état neuf par une ancienne action. Coûts engagés non remboursés.
La fin du combat arrête l'horloge et retire tous les exécuteurs. Reset retire les
anciens, recrée les acteurs, remet les compteurs à zéro et préserve la pause.
Les notifications d'arrière-plan passent toujours par l'arène ; reprise explicite.

SkillExecutor conserve basic, heal, special et paid_test historique. Soin 30,
coût 20/CD 4 s ; spéciale 2×attaque-défense, coût 30/CD 6 s ; énergie +5/s,
plafond 60. CombatSimulation ne demande toujours que basic. Aucun gambit ajouté.
Mannequins, profils, projection et six cases inactives conservés.
Version 0.1.0-step015, code 14. F6 et tests manuels confirmés OK par l’utilisateur.
