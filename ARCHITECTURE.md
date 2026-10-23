# Architecture réelle — STEP-012 validée, commit en attente

Main conserve son UID et instance scenes/combat/battle_lab.tscn, dérivée de l'arène.
CombatUnit compose les classes validées StatsActor, GroundMover et AttackAction.
CombatSimulation pilote le tick unique ; BattleLab ne fournit que les commandes,
la pause et le HUD. Aucun acteur ne se traite seul.

| Élément | Responsabilité |
|---|---|
| combat_unit.gd | PV/statistiques, mouvement, action et présentation par acteur |
| combat_simulation.gd | Ciblage, résolution des contacts, actions, morts, apparitions, fin |
| battle_lab.gd | Trois scénarios, pause/rejouer, repères et diagnostics |
| test_combat_simulation.gd | Combats complets et invariants d'intégration |

Ordre : retirer les morts, cibler, déplacer/résoudre, avancer les actions existantes,
retirer les nouveaux morts, vérifier fin, engager les actions suivantes, apparitions.
Priorité explicite : héros puis ordre d'insertion des ennemis. Delta commun borné
à 1/30 s. Les actions actives immobilisent leurs acteurs, y compris les corrections.
Portée, verrou de cible et impact unique restent ceux de STEP-011 inchangée.

Les morts n'occupent plus de disque ; leurs actions sont annulées et leurs nœuds
supprimés. Une fin annule toutes les actions et arrête le temps. Rejouer reconstruit
le scénario en conservant la pause. Les profils de diagnostic sont copiés localement.
Voir docs/combat.md pour les valeurs, la sélection et les invariants des compteurs.

Les anciens scripts, scènes, profils et assets sont conservés. Le laboratoire
historique se lance séparément avec F6, sans tourner en parallèle avec le combat.
World reste à transformation identité. Caméra 2:1, mannequins 48 px et rendu
Compatibility conservés. Version 0.1.0-step012, code 11.
Pas encore d'exécuteur de compétences, coûts/cooldowns, gambits, vagues, animations
finales ou écran de partie final. Le ciblage temporaire sera remplacé à STEP-017.
