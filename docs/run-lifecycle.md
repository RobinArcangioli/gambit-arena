# Défaite et redémarrage — STEP-026

## Fin de partie

La mort du héros a priorité sur une victoire ou une transition de vague. La fin est
consignée une seule fois : clock.stopped, actions retirées, intentions/commande manuelle
annulées, cibles et déplacements effacés. Les ennemis encore vivants restent affichés,
figés, jusqu’au redémarrage ; ils ne sont pas comptés comme vaincus.
Le dernier impact est intégré aux compteurs avant de figer le bilan.
Une mort injectée pendant une pause est constatée au prochain advance sans consommer de dt.
Les arrivées, cooldowns et ressources ne reprennent pas si l’utilisateur enlève ensuite la pause.

final_report contient uniquement des valeurs : numéro de partie, résultat, temps, vague,
nombre de vagues terminées, arrivés/budget, vaincus, retirés, vivants, impacts et pic simultané.
Chaque lecture retourne une copie. Le HUD affiche le résultat même en pause et réutilise
les lignes existantes. Le détail défilable donne le temps et les autres comptes.
VICTOIRE conserve les critères STEP-025 ; INTERROMPU reste distinct d’une victoire.

## Rejouer

Rejouer n’est pas une résurrection : l’ancien héros et tous les ennemis sont retirés,
les anciens exécuteurs sont définitivement invalidés, puis un nouvel acteur et un nouvel
ActorState sont créés. Les suppressions Godot sont différées à la fin de frame ; les anciens
acteurs sont immédiatement cachés et inactifs. Après cette frame, seul le nouveau héros
reste dans le monde en mode vagues, jusqu’à la première arrivée après une seconde de jeu.

Remis à zéro : PV/ressource selon le profil, cooldowns, action, cible offensive, position,
temps, compteurs de combat, plan de vague, historique des vagues, commande en attente,
diagnostics manuels, intentions/traces et bilan final. Les identifiants d’acteurs/actions
restent monotones pour éviter de réutiliser une ancienne identité.
Conservés : scénario choisi, configuration/ordre/activation des trois gambits, état de pause.
Le formulaire d’édition conserve sa règle historique : Rejouer est bloqué tant qu’il est ouvert.
La préférence d’onglet et la compétence consultée peuvent rester sélectionnées.

clear et la sortie de scène retirent aussi les actions et cibles ; une référence conservée
vers un ancien exécuteur ne doit plus déclencher d’impact dans une nouvelle partie.
Ce nettoyage ne change pas la règle de cible persistante pendant un combat vivant.

## Banc et portée de validation

run_lifecycle_tests : dix resets du même coordinateur avec actions des deux camps et
commande manuelle, pauses alternées, défaite ou reset en cours d’action. Contrôle des
valeurs fraîches, signaux déconnectés, acteurs libérés après frames, absence d’effet tardif,
règles préservées et premier spawn après le dixième reset.
Cas supplémentaires : coup létal réel d’un ennemi, victoire après trois calendriers complets,
nettoyage du plafond de 20 ennemis et suppression d’un coordinateur dont le monde survit.
Le laboratoire réel est ensuite testé par dix clics souris injectés au viewport sur Rejouer,
avec règles personnalisées, contrôles de pause, compteurs et absence de doublons.

Ces tests sont livrés, pas exécutés chez l’assistant (Godot absent). Ils ne mesurent pas
la mémoire native ou la performance à long terme. La recette PC/Android demande dix
redémarrages tactiles et vérifie le retour visible ; robustesse Android approfondie en STEP-027.

STEP-026 validée le 25 octobre 2026 : F6, tests manuels et fluidité OK.
Retour global sans mesure chiffrée ; commit et sauvegarde en attente.
APK : 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2.
