# Pause commune et cycle de vie — STEP-015

GameClock est détenue par le coordinateur, partagée avec ses SkillExecutor.
step retourne zéro en pause, à l'arrêt ou pour un delta non positif/non fini.
Sinon elle accumule min(delta, 1/30 s). Une reprise n'accumule pas le temps perdu.
Chaque acteur reçoit le même delta ; il n'avance pas lui-même l'horloge commune.

| Situation | Résultat |
|---|---|
| Pause pendant préparation/récupération | Temps, effets, CD et énergie figés |
| Demande directe pendant pause | Refus sans coût ni nouveau cooldown |
| Callback d'impact pendant pause | Aucun effet, même au seuil temporel |
| Mort source avant effet | Annulation et retrait définitif, aucun effet tardif |
| Mort source pendant récupération | Arrêt de l'action, effet passé conservé |
| Mort cible avant effet | Annulation, coût conservé, CD peut reprendre ensuite |
| Cible tuée par l'effet courant | Un impact puis récupération normale |
| Sortie d'arbre d'un participant | Même invalidation que sa disparition |
| Reset | Anciens exécuteurs retirés, nouveaux acteurs, pause préservée |
| Fin du combat | Horloge arrêtée, exécuteurs retirés, aucun nouveau lancement |

La pause gèle le temps de jeu. Elle ne retarde pas une invalidation de cycle de vie
imposée de l'extérieur : un acteur détruit ou tué pendant la pause ne garde pas
une action en attente. Les boutons de mort du laboratoire restent bloqués en pause ;
le banc automatisé couvre aussi l'invalidation extérieure pendant la pause.

Les abonnements mort/sortie d'arbre existent pendant l'action et sont déconnectés
en fin ou annulation. Les gardes de vie et d'identité restent une seconde protection
pour queue_free et remplacement d'état. Les coûts ne sont jamais remboursés.
Une cible tuée à l'impact ne doit pas provoquer l'annulation de sa propre réception :
le verrou resolved est posé avant l'effet et les signaux qu'il déclenche.

Les laboratoires STEP-011 à STEP-014 gardent leurs appels explicites avec paused.
La nouvelle garde d'horloge s'applique à LifecycleLab et au combat autonome.
Le combat ne choisit encore que l'attaque normale. Pas de nouvelle stratégie.

F6 : lifecycle_tests.tscn et les quatre bancs partagés décrits dans STEP-015.
La recette Android inclut accueil, retour et verrouillage ; validation moteur requise.

## Validation

F6, tests manuels et fluidité confirmés OK par l’utilisateur.
STEP-015 validée, commit en attente. Voir docs/steps/STEP-015.md.

## Attente manuelle — STEP-023

Une commande attend au plus trois secondes de GameClock.elapsed ; pause et arrière-plan
figent son échéance. Nouveaux appuis refusés en pause. Mort/sortie d'arbre des participants
annulent l'attente via signaux ; reset/scénario/fin la nettoient. Aucun coût n'est engagé
par une simple attente. Une action déjà engagée reste sous le cycle de vie existant.
