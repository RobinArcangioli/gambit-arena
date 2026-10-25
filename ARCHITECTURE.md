# Architecture réelle — STEP-023 validée, commit en attente

Main conserve son UID et ouvre scenes/manual/manual_command_lab.tscn.
ManualCommandLab étend SkillSlotsLab et active simulation.manual_enabled.
Les anciens laboratoires restent automatiques ; skill_slots_lab conserve ses callbacks
de consultation, via les deux méthodes de texte surchargeables ajoutées à son script.
Les six contrôles existants sont réutilisés, sans ajout de boutons ou de connexions.

ManualCommands est un RefCounted attaché au coordinateur. Il contient au plus une
intention : compétence, références source/cible, leurs ActorState et une échéance sur
GameClock.elapsed. snapshot() restitue uniquement une nouvelle copie de valeurs.
L'appui choisit soi pour Soin, sinon le plus proche ennemi vivant ; égalité par ID stable.
Une cible absente, une compétence inconnue, la pause ou la fin font refuser l'appui
sans remplacer l'attente existante. Occupé, cooldown, énergie, PV pleins et portée sont
réévalués pendant l'attente. Une commande acceptée ne dépense rien dans le callback.

CombatSimulation.request_manual accepte puis oublie l'intention automatique via
controller.stop, qui ne coupe jamais l'action engagée. Sur chaque tick autorisé :
1. Prune/fin, puis avance unique de GameClock.
2. Validation/expiration manuelle ; si attente valide, elle fournit l'approche et les
   gambits ne planifient pas. Sinon, planification automatique historique.
3. Déplacements et séparation, avec l'arrêt à portée inchangé (FIX-STEP-019-001).
4. Avance des actions existantes, prune et éventuelle fin.
5. Nouvelle revalidation de la commande manuelle, sinon exécution automatique.
   Si sa cible disparaît pendant les impacts, les gambits peuvent reprendre ce tick.
6. Engagements ennemis, apparitions et présentation historiques.

La validation de fin de tick ne réécrit pas la vitesse de déplacement : les jambes
continuent de marcher pendant une approche réelle. L'expiration est inclusive à trois
secondes de temps de jeu (tolérance numérique 1e-6). Une commande remplacée repart
pour trois secondes. Les grands deltas restent bornés par GameClock.MAX_STEP.
Le soin n'approche personne ; une attaque approche sa cible verrouillée, même si elle
attend encore une ressource ou un cooldown. Les gambits attendent derrière elle.

Au lancement, SkillExecutor.request reste l'unique autorité : vivant, pause/arrêt,
acteur non retiré, état, occupation, cooldown, utilité du soin, coût, cible et portée.
Paiement, cooldown, windup, impact unique et récupération ne sont pas modifiés.
L'intention manuelle est consommée après succès ; aucun rejeu automatique de cette
commande. Une action engagée continue même si l'attente suivante expire/remplace.
La mort/destruction des participants annule l'attente via signaux ; changement d'état
ou retrait de la liste est détecté à la revalidation. Les connexions sont retirées
à la consommation, au remplacement, à l'annulation et à la destruction du coordinateur.
Rejouer/scénario efface l'attente et les compteurs ; la pause survit comme auparavant.

Les compteurs manuels sont distincts des compteurs gambits. Sans appels directs de test,
hero.action.accepted = controller.launched + manual.launched pour la partie courante.
Le journal borné historique reste consacré aux gambits ; l'état manuel expose uniquement
la dernière issue et des compteurs, sans liste croissante. L'UI montre l'attente et son
reste dans l'en-tête, les détails et refus sous la grille. Les cartes affichent toujours
la disponibilité immédiate ; celle-ci ne réserve pas une nouvelle cible pour l'attente.

Nouveaux scripts : manual_commands.gd, manual_command_lab.gd, test_manual_commands.gd.
Logique historique modifiée : arbitrage dans CombatSimulation uniquement.
SkillSlotsLab reçoit deux méthodes de texte surchargeables, sans changer son comportement.
Action, exécuteur, contrôleur gambit, animation, mouvement, profils, horloge, layout et
anciens tests sont identiques à la base vérifiée 307e8c6.
Version Android 0.1.0-step023, code 22. Contrôles statiques ici ; validation utilisateur reçue, swipe Android restant à corriger.
