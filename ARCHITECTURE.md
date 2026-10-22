# Architecture réelle — STEP-010 validée, commit en attente

Main conserve son UID et ouvre scenes/combat/stats_lab.tscn, dérivée de l'arène.
Les sources des anciens laboratoires restent inchangées. Ils sont accessibles
avec F6 ; leurs systèmes ne tournent pas simultanément avec ce laboratoire.

| Élément | Responsabilité |
|---|---|
| ActorProfile / data/actors/*.tres | Configuration partagée, scalaires uniquement |
| ActorState | Copie indépendante, PV, dégâts finaux, soins, signaux |
| StatsActor | Mannequin ProxyActor et état propre |
| StatsLab | Sélection, commandes, verrou de pause, affichage et reset |
| test_actor_state.gd | Invariants des données et tests de la vraie scène |

Les références aux profils ne sont pas conservées dans ActorState. Chaque
StatsActor construit un état neuf. Le moteur de combat pourra utiliser cet état
sans dépendre de l'interface ; ce raccordement ne fait pas partie de STEP-010.
Le contrat des mutations et des événements figure dans docs/stats.md.

Le laboratoire masque les deux mannequins hérités, les supprime par queue_free
et construit ses trois StatsActor. Rejouer masque et supprime les anciens,
recrée trois états et conserve la pause. Aucun timer ni tick de combat.
Le retour d'arrière-plan impose une reprise explicite via l'arène héritée.

Rendu Compatibility, projection 2:1 et taille apparente 48 px conservés.
Les silhouettes mortes sont masquées ; pas d'animation Death ni destruction
immédiate des états. Ni attaques, calcul de défense, mouvement dans ce labo,
cooldowns, effets retardés, gambits ou compétences. Les mannequins 3D finaux
et leurs animations restent à produire et qualifier.

Les détails des systèmes historiques restent dans docs/movement.md,
docs/enemies.md et docs/crowd.md. Version 0.1.0-step010, code 9.
