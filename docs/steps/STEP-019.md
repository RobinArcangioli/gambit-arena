# STEP-019 — Trois règles activables et réordonnables

Statut : Validée, commit en attente.
Base : 4719e8d2790cb6dd371733d2beebcec51d145d46, STEP-018 clôturée.
GO reçu le 24 octobre 2026. Retour F6/manuels/fluidité OK sur v1, avec réserve
sur le petit pas à l’attaque. FIX-STEP-019-001 livré en v2 puis validé par le retour utilisateur global.

## Périmètre et décisions

Trois lignes fixes, priorité du haut vers le bas. Boutons Oui/Non, Haut/Bas, disponibles
en jeu et en pause. Tout déplacement conserve la règle complète. Rejouer et scénario
conservent la configuration. Pas de persistance disque ni d'édition de champs.
Intentions en attente annulées ; actions engagées conservées. Aucun coût sur édition.
Les six emplacements futurs sont masqués dans ce laboratoire pour loger les règles.
La v2 corrige la demande d’approche du héros déjà à portée dans CombatSimulation ;
le reste du combat, de l’évaluation, du diagnostic et de l’exécution reste inchangé.

Nouveaux : gambit_editor.gd, gambit_editor_lab.gd, test_gambit_editor.gd et leurs UID,
scènes gambit_editor_lab et gambit_editor_tests, docs/gambit-editor.md et cette recette.
Main ouvre le laboratoire éditeur. Version Android 0.1.0-step019, code 18.

## Installation et tests F6

Fermer Godot. Appliquer sur STEP-019 non commitée, base 4719e8d. Extraire dans ~
gambit-arena-complet-step-019-v2.tar.gz, sans remplacer .git ni annuler les modifications.
Vérifier git diff --check, puis importer dans Godot.

Dans scenes/tests/, lancer d’abord attack_stationary_tests.tscn : position et jambes
immobiles à portée, répétitions à 30/60/120 Hz, approche hors portée, pause et édition.
Puis lancer avec F6, F8 entre chaque banc :
1. gambit_editor_tests.tscn : copies isolées, bornes, signaux uniques, mille allers-retours,
   vraie scène, activation prioritaire, ordre de sélection, soin engagé, pause et resets.
2. gambit_diagnostics_tests.tscn : diagnostics, journal borné et correctif v2 STEP-018.
3. gambit_controller_tests.tscn : pilotage et engagements uniques.
4. gambit_tests.tscn : évaluation déterministe.
5. lifecycle_tests.tscn : pause et mort.
6. combat_simulation_tests.tscn : combat historique et resets.

Attendu : OK, zéro échec par banc, aucun nouvel avertissement GDScript.
Godot non exécuté chez l'assistant : ni compilation, ni réussite F6 présumée.

## Recette F5 et Android

1. Vérifier trois lignes lisibles sans recouvrement en portrait : Soin, Spéciale, Attaque.
   Chaque ligne montre sa condition, son activation et sa priorité 1/2/3. Haut de la
   première ligne et Bas de la dernière sont désactivés. Toucher une fois = une opération.
2. Mettre en pause ; désactiver une ligne puis la déplacer. Son état Non suit la règle.
   Les autres champs restent identiques. Les PV, temps d'action, énergie et CD restent figés.
3. Rejouer en pause : configuration et pause conservées, aucun engagement. Reprendre
   explicitement. Parcourir Combat, Soin, Groupe 20 : ordre et activation conservés.
4. Dans Soin, pause immédiate puis Rejouer : 40/100 PV. Avec Soin en tête activé,
   reprendre : premier engagement heal. Recommencer avec Attaque en tête : approche
   et attaque prioritaires, même si le soin serait valide. Restaurer Soin en tête.
5. Pendant un soin engagé, le désactiver/déplacer : il finit une fois, avec son coût
   déjà payé. Les prochains choix suivent le nouvel ordre ; aucun double effet/coût.
6. Toutes les règles sur Non puis Rejouer : héros immobile et aucune compétence ;
   ennemis toujours autonomes. Réactiver Attaque : reprise du ciblage au prochain tick.
7. Dix Rejouer, dont plusieurs en pause : trois lignes toujours présentes, règles
   conservées, pas d'acteurs en double, erreurs ou signaux multipliés.
8. Accueil/verrouillage/retour Android : pause conservée, reprise explicite ; aucune
   avance de cooldown ou action pendant l'absence. Toucher plusieurs Haut/Bas et Oui/Non
   après retour : une modification par appui, sans comportement double.
9. Vérifier fluidité, lisibilité, bords sûrs et boutons sur Samsung Galaxy A16. Les six
   cases futures sont volontairement masquées ; pas de commande manuelle disponible.
   G conserve les repères sur PC ; les anciens laboratoires sont toujours accessibles.

## Export et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-019-debug.apk,
hors dépôt. Installer avec adb -d install -r puis calculer sha256sum.
Transmettre F6, tests manuels, fluidité et SHA-256. Validation utilisateur reçue.
Message de commit proposé :
feat: [STEP-019] activer et reordonner trois gambits au toucher
Puis sauvegarde complète et vérification du point de reprise.
STEP-020 attend clôture et nouveau GO : cible, condition, seuil et action éditables.

## FIX-STEP-019-001 — 24 octobre 2026

Retour utilisateur v1 : F6 OK, tests manuels OK, fluidité OK, mais mouvement des
jambes accompagné d'un léger déplacement du héros pendant les attaques sur PC et Android.
SHA-256 APK v1 corrigé par l’utilisateur :
7fd4027080d9f560a77168d0256ced18ab322ec139084690271b805b89f4672a.
L’empreinte STEP-018 répétée initialement était une erreur de transcription.
Cette réserve empêchait la clôture de la v1. La v2 est désormais validée par l’utilisateur.

Analyse du code : la portée d'attaque est 1.0, la distance d'arrêt du déplacement 0.8.
Quand le héros redevient libre, l'approche précède l'engagement et peut encore avancer
vers 0.8 alors que l'attaque est déjà possible. Ce mouvement alimente la pose de marche.
Ce chemin existait avant STEP-019 ; l'animation n'avait pas été modifiée dans la v1.

Correctif : CombatSimulation ne demande plus de pas d'approche au héros dont la cible
vivante sélectionnée est déjà à portée, avec la même limite stricte Action.REACH que
l'exécuteur. La poursuite hors portée et le verrouillage des actions engagées restent
actifs. Aucun changement de pose, de portée, coût, cooldown, priorité ou mouvement ennemi.
Le dernier pas nécessaire pour entrer à portée reste normal ; une autre cible hors
portée autorise également un nouveau déplacement. L'immobilité n'est pas un gel global.

Nouveau banc scenes/tests/attack_stationary_tests.tscn : cible fixe aux distances
0.8/0.9/1.0, attaques répétées à 30/60/120 Hz, position/vitesse/jambes, dégâts uniques,
approche à 1.000005/1.02/2.0, reprise de poursuite, spéciale, pause et édition de règle.
Les tests précédents restent inchangés. Contrôles statiques seulement chez l’assistant ;
Godot absent, aucune compilation ni exécution moteur effectuée.

Livraison : gambit-arena-complet-step-019-v2.tar.gz, version 0.1.0-step019, code 18.
Appliquer sur STEP-019 non commitée. Relancer le nouveau banc et les six bancs précédents.
En F5 puis Android, observer plusieurs attaques sur la même cible à portée : aucun
petit pas répété ni relance de marche. Vérifier aussi l'approche d'une nouvelle cible,
les boutons d'édition, la pause et Rejouer. Réexporter l'APK et transmettre son nouveau SHA.
Correctif validé dans le retour global de STEP-019 v2. Pas de commit séparé :
le correctif est intégré au commit STEP-019 à effectuer.

## Validation utilisateur reçue — 24 octobre 2026

Retour : « Tout est OK. Step validée. » STEP-019 v2 et FIX-STEP-019-001 validés.
Retour global après demande de F6, recette PC/Android et réexport ; aucun détail
séparé pour chacun des sept bancs ni mesure chiffrée de performance fourni.
APK : step-019-debug.apk ; version 0.1.0-step019, code 18.
SHA-256 communiqué : 804fb0fd6521cbcafe374c582560d0284cc93f13cab9002acbd47d89593806c8.

Archive : gambit-arena-complet-step-019-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v2.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.
