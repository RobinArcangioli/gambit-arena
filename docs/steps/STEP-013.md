# STEP-013 — Exécuteur partagé, coûts et cooldowns uniques

Statut : Validée, commit en attente.
Base : 9725f5d2476a2db427a7379c58a2c95351b6ad62, STEP-012 clôturée.
GO reçu. STEP-013 validée ; empreinte APK reçue, commit et sauvegarde à recevoir.

## Périmètre

Un point commun d'engagement, ressource par acteur, cooldown par identifiant,
débit et déclenchement uniques, refus sans effet et impact hérité de STEP-011.
L'attaque de base du combat autonome utilise ce même exécuteur. Une attaque payante
de diagnostic teste le contrat ; elle n'est pas encore la spéciale du gameplay.
Pas de régénération, soin, spéciale, file d'attente ou arbitrage de gambits.

Fichiers nouveaux : scripts/skills/skill_executor.gd, executor_lab.gd ;
scenes/skills/executor_lab.tscn ; tests/test_skill_executor.gd ;
scenes/tests/skill_executor_tests.tscn ; docs/skill-executor.md et cette recette.
CombatUnit remplace son exécuteur ; Main garde son UID et ouvre le laboratoire.
Version Android 0.1.0-step013, code 12. Anciens laboratoires conservés.

## Installation et bancs F6

Fermer Godot ; vérifier main propre et HEAD 9725f5d. Extraire l'archive complète
'gambit-arena-complet-step-013-v1.tar.gz' dans ~, sans remplacer .git.
Dans ~/gambit-arena : git diff --check puis git status --short --branch.

Après import, ouvrir scenes/tests/skill_executor_tests.tscn puis F6.
Attendu : OK, zéro échec. F8 arrête. Transmettre toute erreur avant de poursuivre.
Relancer aussi scenes/tests/combat_simulation_tests.tscn avec F6 : la substitution
de l'exécuteur concerne les deux camps. Attendu : OK, zéro échec.

Le nouveau banc couvre refus, spam manuel/auto, débit unique, cooldown unique,
impact dupliqué/réentrant, indépendance des acteurs, énergie exacte/insuffisante,
attaque gratuite pendant cooldown, pause/deltas invalides, portée perdue,
annulation sans remboursement, mort/remplacement/retrait, dix resets et vrai combat.
Godot absent chez l'assistant : aucune compilation GDScript ni exécution moteur ici.

## Recette F5 puis Android

| Commande | Touche | Effet |
|---|---|---|
| Scénario | P | Manuel / Auto / Deux acteurs |
| Essai 20 | A | Coût 20, cooldown 3 s, effet d'attaque normal |
| Base 0 | B | Attaque gratuite, sans cooldown additionnel |
| Acteur H/A | T | Sélectionne le lanceur manuel |
| Éloigner/Rapprocher | E | Place la cible hors portée / à portée |
| Auto oui/non | U | Active/suspend les demandes automatiques |
| Rejouer | R | Annule et recrée les états ; conserve la pause |
| Pause/Reprendre | Espace | Gèle action, cooldown et demandes |
| Repères | G | Repères utilisables aussi en pause |

1. Manuel : H et A affichent 60/60 énergie, zéro coût/cooldown engagé.
   Essai20 sur H : énergie40, coût20, acceptées1, CD lancés1, CD démarre à3 s.
   Après 0,6 s, un impact de11 PV. Ressource et cooldown ne sont pas redébités.
2. Marteler Essai20 puis Base0 pendant l'action : refus occupé, même action,
   aucun coût ajouté. Après récupération mais avant fin du CD, Essai20 est refusé
   sans remettre le CD à3 ; Base0 est accepté gratuitement.
3. Attendre le CD, refaire deux essais : énergie20 puis0. Un quatrième essai est
   refusé pour ressource insuffisante ; Base0 reste possible après récupération.
4. Rejouer, éloigner puis Essai20 : refus, énergie60 et zéro CD engagé.
   Rapprocher, Essai20 puis éloigner avant impact : aucun dégât, mais coût20
   conservé et cooldown qui continue. Rapprocher ne provoque aucun impact tardif.
5. Acteur A : sa ressource et son cooldown restent indépendants de H.
6. Auto : après environ10 secondes actives, H a accepté3 actions payantes,
   énergie0, coût60, CD lancés3 ; A conserve60, cible967 PV.
7. Deux acteurs : chacun a accepté3 actions, coût60 et énergie0 ; cible946 PV.
   Les demandes refusées répétées n'ajoutent aucun débit ni impact.
8. Pause pendant préparation puis cooldown : PV, temps, ressource et cooldown figés.
   Rejouer en pause : énergie60 pour chacun, compteurs remis à zéro, toujours pause.
   Reprendre : aucun ancien impact. Dix resets : aucun doublon.
9. Six cases À venir inactives, HUD/arène lisibles, aucune erreur ; F8 fonctionne.
10. Sur téléphone : mêmes essais tactiles, fluidité, accueil/réduction/verrouillage.
    Retour en pause jusqu'à Reprendre, sans cooldown consommé en arrière-plan.

## Android et clôture

Exporter Android Debug avec débogage vers ~/gambit-arena-builds/step-013-debug.apk,
hors dépôt. Installer par adb -d install -r et calculer sha256sum.
Transmettre les deux résultats F6, les tests manuels, la fluidité et le SHA-256.
Validation utilisateur reçue. Commit proposé :
feat: [STEP-013] partager lexecution et garantir les couts uniques
Puis sauvegarde complète et vérification du point de reprise.
STEP-014 attend clôture et GO : attaque, soin, spéciale et ressource récupérable.

## Validation utilisateur reçue — 23 octobre 2026

STEP-013 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Le retour F6 est global, sans résultat séparé pour chacun des deux bancs demandés.
APK identifié : step-013-debug.apk ; version de la livraison 0.1.0-step013, code 12.
SHA-256 communiqué : 8d8dfe72772347cb335f1849207b222a0683dec78bd656ba7b61543dce2c5cf2.
Aucune mesure chiffrée de performance fournie.

Archive : gambit-arena-complet-step-013-validation.tar.gz.
Code, scènes, profils, tests et configuration identiques à la livraison v1.
Seule la documentation évolue ; aucun lancement Godot chez l’assistant.
Statut : Validée, commit en attente. Hash et sauvegarde à recevoir.

## Passage à STEP-014

Clôture confirmée : 1ffd24ad027991f57f2aee1d96b1cbcfa87228c6.
Sauvegarde restaurée : historique complet, 152 fichiers identiques, dépôt propre.
