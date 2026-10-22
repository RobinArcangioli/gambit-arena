# Architecture réelle — STEP-011 validée, commit en attente

Main conserve son UID et ouvre scenes/combat/attack_lab.tscn, dérivée de l'arène.
Les anciens scripts, scènes et profils restent inchangés. Les laboratoires
historiques se lancent séparément avec F6.

| Élément | Responsabilité |
|---|---|
| ActorProfile / ActorState / StatsActor | Configuration et état par instance validés STEP-010 |
| AttackAction | Une action active par exécuteur, ID, temps, impact et récupération |
| AttackLab | Trois acteurs, sélection, scénarios, pause, présentation et reset |
| test_attack_action.gd | Contrat d'action et intégration au vrai laboratoire |

Un exécuteur par attaquant est le contrat d'intégration. Le laboratoire possède
un exécuteur pour le héros et aucun pour les ennemis passifs. Il avance une fois
par tick physique, sans timer secondaire ni coroutine. L'action porte la cible
et les états engagés ; la sélection du HUD ne modifie pas l'action en cours.
Les coordonnées globales x/z servent à mesurer la portée, sans tenir compte de y.

Le seul point de mutation des dégâts est try_impact(id), appelé par advance.
Il verrouille la résolution avant les signaux des PV. La portée et les références
sont contrôlées au lancement puis à l'impact. Des références libérées, en cours
de suppression ou des états remplacés sont rejetés. L'attaque est copiée au
lancement, la défense lue à l'impact. Voir docs/actions.md pour le contrat complet.

Rejouer annule l'ancien exécuteur et reconstruit les trois acteurs ; leurs PV
et l'action sont neufs, les IDs de processus ne sont pas réutilisés. La pause
est conservée. Les retours d'arrière-plan imposent une reprise explicite.
Les scénarios automatiques coupent le tick à 0,3 s pour invalider avant l'impact.

Rendu Compatibility, caméra 2:1, mannequins 48 px et six cases inactives conservés.
Les morts sont masqués, les retraits supprimés. Pas encore d'animation finale,
combat autonome, raccordement déplacement/attaque, compétence, coût ou gambit.
Version Android 0.1.0-step011, code 10. F6 et tests manuels validés par l’utilisateur.
