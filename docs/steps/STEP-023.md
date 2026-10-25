# STEP-023 — Commande manuelle prioritaire et attente bornée

Statut : Validée, commit en attente.
Base : 307e8c6fcb294102638cd55fab388c10352dcb70, STEP-022 clôturée.
GO et validation utilisateur reçus le 25 octobre 2026. Commit et sauvegarde à recevoir.

## Périmètre et décisions

Trois commandes depuis les cartes existantes, une seule attente remplaçable valable
3 s de temps de jeu. Priorité sur toute nouvelle action gambit ; action engagée intacte.
Cible fixée à l'appui : soi pour Soin, plus proche ennemi vivant pour les attaques,
égalité par ID. Approche automatique si nécessaire ; perte de cible = annulation.
Les blocages temporaires attendent sans coût. Pause refuse de nouveaux appuis et fige
l'attente. Une commande acceptée est consommée une seule fois à l'exécution.
Rejouer/scénario/fin nettoient l'attente. Aucun changement d'animation ou d'immobilité à portée.

Nouveaux : scripts/manual/manual_commands.gd, manual_command_lab.gd, leurs UID,
tests/test_manual_commands.gd et UID, scènes manual_command_lab et manual_commands_tests,
docs/manual-commands.md et cette recette. Arbitrage ajouté à CombatSimulation et deux
méthodes de texte dans SkillSlotsLab ; anciens tests conservés. Main/export STEP-023.
Version 0.1.0-step023, code 22. Aucune vague progressive ajoutée dans cette étape.

## Installation

Fermer Godot. Partir de main propre au commit 307e8c6. Extraire dans ~
gambit-arena-complet-step-023-v1.tar.gz sans remplacer .git, puis git diff --check.
Ouvrir le projet Godot et laisser l'import se terminer.

## Tests F6

Dans scenes/tests/, F6 puis F8 entre chaque banc :

1. manual_commands_tests.tscn : priorité, remplacement, paiement/impact uniques,
   action engagée préservée, expiration inclusive à 30/60/120 Hz, pause/grand delta,
   énergie/cooldown/soin/portée revalidés, identités, cible verrouillée, mort/suppression,
   reprise des gambits, approche et immobilité, dix resets, interface/modal/scroll,
   arrière-plan et combat identique à STEP-022 sans appui manuel.
2. skill_slots_tests.tscn : consultation historique et disponibilité inchangées.
3. portrait_hud_tests.tscn : zones sûres et défilement des dernières lignes.
4. gambit_fields_tests.tscn : édition et validation.
5. attack_stationary_tests.tscn : absence de pas et mouvement de jambes à portée.
6. gambit_editor_tests.tscn : activation et ordre.
7. gambit_diagnostics_tests.tscn : journal borné et scénarios.
8. gambit_controller_tests.tscn : contrôleur automatique.
9. gambit_tests.tscn : évaluateur.
10. lifecycle_tests.tscn : pause, mort et annulation.
11. combat_simulation_tests.tscn : combat historique.

Attendu : OK, zéro échec et aucun nouvel avertissement GDScript.
Godot absent chez l'assistant : ni compilation ni exécution de ces bancs effectuées ici.

## Recette F5, PC et Android

1. Laisser un combat sans appui : gambits, victoire/défaite, approche et fluidité usuels.
   Vérifier l'absence de petits pas et de jambes en marche sur une cible déjà à portée.
2. Rejouer ; toucher Attaque/Spéciale : l'attente apparaît, puis approche si nécessaire
   et lancement dès que possible. La dépense n'arrive qu'au lancement (0/30 E).
3. Pendant une action engagée, toucher Spéciale puis Soin : seule la dernière attente
   reste. L'action en cours termine normalement ; aucun coût anticipé ou doublé.
   Soin peut attendre une blessure si les PV sont pleins. Il coûte 20 E lorsqu'il part.
4. Après un lancement de Spéciale, alors que son cooldown dépasse encore 3,3 s,
   toucher de nouveau Spéciale : attente sans paiement, puis expiration après 3 s
   de jeu puisque le cooldown n'est pas terminé. Les gambits reprennent.
5. Pendant une attente, Pause : temps restant figé. Toucher une autre carte : refus
   explicite dans le détail, attente précédente conservée. Reprendre explicitement.
6. Pendant une attente, passer sur Gambits, ouvrir/modifier/appliquer une règle :
   pause conservée, attente préservée. Revenir à Compétences puis Reprendre.
7. Une cible qui meurt avant exécution annule son attente ; aucune action manuelle
   transférée à un autre ennemi. Les gambits retrouvent leur propre choix.
8. Rejouer pendant une attente, puis dix fois en pause : aucune ancienne commande,
   aucun doublon d'acteur ou de carte, règles conservées. Répéter un changement de scénario.
9. Accueil/verrouillage/retour Android pendant une attente : pause, délai figé,
   reprise explicite. Défaite/victoire : aucun lancement tardif ni nouvel appui accepté.
10. Six cartes, trois réserves inactives ; onglets et formulaire fonctionnels. Faire
    défiler jusqu'au dernier détail, sans commande involontaire lors d'un glissement.
    Vérifier lisibilité du délai d'attente distinct du cooldown et fluidité sur téléphone.

## Export et clôture

Exporter Android Debug vers ~/gambit-arena-builds/step-023-debug.apk, hors dépôt.
Installer avec adb -d install -r puis calculer sha256sum.
Validation utilisateur et SHA-256 reçus ; anomalie de swipe reportée à STEP-024.
Message de commit proposé :
feat: [STEP-023] prioriser une commande manuelle a attente bornee
Puis sauvegarde complète et vérification du point de reprise.
STEP-024 attend clôture et nouveau GO : vague progressive et plafond simultané.

## Validation utilisateur reçue — 25 octobre 2026

STEP-023 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour F6 global, sans résultat séparé pour chacun des onze bancs demandés.
APK : step-023-debug.apk ; version de la livraison 0.1.0-step023, code 22.
SHA-256 communiqué : 32a325594643055c00fa01a80a294f559be570c0bbc599bacc47680a47b005a1.
Aucune mesure chiffrée de performance fournie.
Anomalie de swipe Android signalée avec demande de correction à l’étape suivante.
Cette validation ne vaut donc pas réussite du défilement au doigt sur téléphone.

Archive : gambit-arena-complet-step-023-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

## FIX-STEP-023-001 — Prévu pendant STEP-024

Signalement utilisateur du 25 octobre 2026 : les zones de défilement Gambits et
Compétences fonctionnent à la molette, mais pas par glissement du doigt sur téléphone.
L’utilisateur valide STEP-023 et demande explicitement ce correctif à la prochaine étape.
Statut : à faire, aucune correction de code dans cette archive. Cause à diagnostiquer.

À intégrer au périmètre de STEP-024 : rétablir le swipe dans les deux listes, jusqu’aux
dernières règles/cartes/détails. Vérifier les gestes commencés sur les boutons et sur
les espaces libres ; un glissement ne doit ni commander une compétence, ni ouvrir ou
modifier un gambit. Conserver les appuis courts, la molette, les zones sûres et la pause.
Ajouter une régression ciblée et faire valider le geste sur le téléphone Android.

## Clôture vérifiée — 25 octobre 2026

Commit 7579504fd4a11b5b6fa1440567c597a92c67fa49, parent 307e8c6.
Sauvegarde gambit-arena-20261025-061552-7579504fd4a1.tar.gz vérifiée ; main propre.
260 fichiers identiques au commit et à la livraison validée, historique complet et intègre.
Les statuts antérieurs ci-dessus décrivent la livraison de validation.
FIX-STEP-023-001 livré dans STEP-024, en attente de validation ; voir sa recette dédiée.
