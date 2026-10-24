# Architecture réelle — STEP-020 validée, commit en attente

Main conserve son UID et ouvre scenes/gambits/gambit_fields_lab.tscn.
GambitFieldsLab étend le laboratoire éditeur STEP-019. Ses trois résumés sont désormais
des boutons qui ouvrent un formulaire modal. Un brouillon Dictionary contient quatre
scalaires : target, condition, threshold, skill. L'activation reste propriété de la ligne.
Le formulaire met paused et GameClock.paused à true. Appliquer/Annuler ferment le
formulaire sans reprendre le temps. Les raccourcis et commandes sous-jacentes sont
bloqués pendant l'édition ; Échap annule. L'arrière-plan conserve pause et brouillon.

GambitEditor.validate_fields refuse les clés manquantes/supplémentaires, types incorrects,
options inconnues, seuil non entier ou hors 0..100 et couples cible/action incompatibles.
Soin nécessite Soi ; Attaque et Spéciale nécessitent Ennemi. update_fields applique
une nouvelle Resource d'un seul coup, en conservant enabled et la position. L'appelant
ne partage aucune référence modifiable. Un changement accepté émet changed une fois ;
un refus ou une sauvegarde sans différence n'émet rien et ne modifie pas l'intention.

Le raccordement STEP-019 invalide toute intention en attente lors d'un changement réel
puis transmet une copie au contrôleur. Une action engagée garde son coût, sa cible et
son exécuteur. Ni l'ouverture ni les ajustements du brouillon ne publient une règle.
Annuler n'altère pas l'intention en attente. Rejouer et scénario conservent les champs.

Le résumé du laboratoire de base est rendu depuis les valeurs réelles des règles,
y compris le seuil. Les anciens résumés des trois règles standard gardent leur sens.
Toujours ignore le seuil mais conserve sa valeur. PV < seuil est strict et porte sur
la cible de la règle ; le soin inutile à PV pleins reste refusé par l'évaluateur.

GambitRule, GambitEvaluator, GambitController, CombatSimulation, GameClock,
SkillExecutor, AttackAction, mannequin, acteurs, profils et mouvement/contact sont
identiques à STEP-019. FIX-STEP-019-001 est conservé octet pour octet.
Les anciens laboratoires et tests restent disponibles. Un nouveau banc teste validation,
atomicité, copies, bornes, application réelle, modalité, pause, action engagée et resets.
Godot non exécuté chez l'assistant. Version 0.1.0-step020, code 19.
Aucune compétence supplémentaire, commande manuelle ou persistance ajoutée.
