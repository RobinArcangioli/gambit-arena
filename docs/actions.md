# Actions d'attaque — STEP-011

AttackAction est un RefCounted : un exécuteur par attaquant, avancé par le
coordinateur. Aucun Timer, await ou callback d'animation ne déclenche les dégâts.
Le laboratoire possède un seul exécuteur pour le héros ; les ennemis sont passifs.
Le raccordement au déplacement et au combat autonome appartient à STEP-012.

## Contrat

- begin(source, target) retourne un ID strictement positif si accepté, 0 sinon.
- Source/cible doivent être deux StatsActor distincts, dans SceneTree, vivants,
  valides et non queue_free ; distance au sol <= 1,0 unité à l'engagement.
- Une action active refuse tout nouveau lancement, sans file d'attente.
- ID monotone partagé par les exécuteurs du processus, conservé à travers Rejouer.
  Il repart au lancement d'un nouveau processus ; aucune persistance promise.
- La cible et les identités ActorState sont verrouillées à l'engagement.
  Changer la sélection ne redirige pas l'action ; reconfigurer un acteur l'annule.
- Attaque copiée au lancement ; défense lue à l'impact. Dégâts finaux proposés :
  max(1, attaque - défense), bornés aux PV restants par ActorState.damage.
  Avec les profils actuels : 12 - 1 = 11 PV ; valeurs provisoires.
- Préparation 0,6 s, impact au franchissement du seuil, récupération 0,4 s.
  Un grand delta peut franchir les deux phases mais ne produit qu'un impact.
- try_impact(id) exige l'ID courant, une action active, le seuil atteint et
  l'absence de résolution antérieure. Le verrou est posé AVANT damage et ses
  signaux, ce qui rejette aussi un appel réentrant pendant health_changed.
- À l'impact : les vies, références, états et portée sont vérifiés à nouveau.
  Une cible hors portée fait manquer le coup ; revenir ne crée pas d'effet tardif.
- Mort/retrait/changement d'état avant impact annulent l'action au prochain pas
  actif. Mort de l'attaquant pendant la récupération l'annule sans nouvel effet.
  Une cible tuée par l'impact n'empêche pas la récupération de se terminer.
- cancel ferme définitivement la résolution de cette action. L'ancien ID ne
  peut affecter aucune action ultérieure ; cancel est aussi utilisé par Rejouer.

## Temps et pause

advance ignore les deltas non finis, nuls ou négatifs. paused=true ne modifie
ni l'horloge ni l'état et n'accumule aucun retard. Le laboratoire bloque en plus
ses commandes pendant la pause. Un changement externe de vie pendant une pause
serait détecté avant tout impact à la reprise. Aucun ordonnanceur de combat
concurrent n'est encore présent. Les impacts ne passent que par advance dans
le laboratoire ; try_impact reste le point de contrôle testé pour les doublons.

## Laboratoire

Héros et deux ennemis utilisent StatsActor/ActorState inchangés de STEP-010.
Héros au centre, A en (0,6 ; -0,6), B en (-0,6 ; -0,6). Tous sont immobiles.
Le HUD indique les PV, l'ID, la cible engagée, la phase, le temps, le résultat
et les dégâts effectifs. Les morts sont masqués, les cibles retirées supprimées.
Pas d'animation Attack/Hit/Death finale ni d'effet visuel temporaire ajouté.

Les quatre scénarios d'invalidation interviennent à 0,3 s de préparation :
la cible engagée sort de portée, meurt, est retirée, ou le héros meurt.
Le pas est découpé à cette échéance pour conserver l'ordre même sur une frame
longue. Ces placements/retraits sont des interventions de test explicites.

Tests moteur : scenes/tests/attack_action_tests.tscn avec F6. Scénarios et
recette : docs/steps/STEP-011.md. Godot non exécuté chez l'assistant.

## Validation

F6, tests manuels et fluidité confirmés OK par l’utilisateur.
STEP-011 validée, commit en attente. Voir docs/steps/STEP-011.md.
