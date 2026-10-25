# STEP-026 — Défaite et dix redémarrages sans résidus

Statut : Validée, commit en attente. GO reçu le 25 octobre 2026 après clôture de STEP-025.
Base : f62162db145d4a3e3b70a7cc839770f34df4caaa ; fix1 inclus.
Livraison : gambit-arena-complet-step-026-v1.tar.gz.
Android : 0.1.0-step026, code 26. APK STEP-026 validé par le retour utilisateur ci-dessous.

## Objectif et périmètre

Défaite unique et lisible, bilan figé et dix redémarrages sans anciens acteurs/actions,
commandes ou compteurs. Le héros est neuf, les gambits et la pause sont conservés.
La cible offensive fix1, le swipe, les animations, les profils et les vagues restent inchangés.
Pas de nouveau scénario de jeu, équilibrage, sauvegarde persistante ou système de résurrection.
Les garanties et limites sont détaillées dans ../run-lifecycle.md.

## Fichiers

CombatSimulation : _end_run idempotent, rapport scalaire, diagnostic run_id/terminal_count,
nettoyage de clear/_dispose/_exit_tree et observation d’une mort avant le filtre de pause.
RunLifecycleLab : bilan dans le HUD existant, scène principale et export actualisés.
Nouveau banc test_run_lifecycle.gd et scène associée. Documentation mise à jour.

## Installation

Fermer Godot et vérifier la base propre :

```bash
cd ~/gambit-arena &&
git status --short --branch &&
git log -1 --format="%h %s"
```

Attendu : main propre, f62162d. Puis :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-step-026-v1.tar.gz -C ~ &&
cd ~/gambit-arena &&
git diff --check
```

Archive complète sans .git/.godot. Bundle séparé : historique jusqu’à f62162d,
sans la STEP-026 non commitée. Aucun git restore nécessaire.

## F6

Lancer ces scènes de scenes/tests avec F6, puis F8 entre chacune :

1. run_lifecycle_tests.tscn
2. target_lock_tests.tscn
3. wave_sequence_tests.tscn
4. wave_schedule_tests.tscn
5. lifecycle_tests.tscn
6. manual_commands_tests.tscn
7. gambit_controller_tests.tscn
8. gambit_diagnostics_tests.tscn
9. attack_stationary_tests.tscn
10. touch_scroll_tests.tscn
11. portrait_hud_tests.tscn
12. skill_slots_tests.tscn
13. gambit_fields_tests.tscn
14. gambit_editor_tests.tscn
15. combat_simulation_tests.tscn

Attendu : OK, zéro échec et aucun nouvel avertissement. Le nouveau banc simule une
séquence complète et plusieurs frames de nettoyage : attendre le bilan affiché.
Godot absent chez l’assistant : aucune compilation/exécution moteur ni mesure matérielle ici.

## Recette PC puis Android

1. F5, désactiver les trois gambits pour provoquer une défaite naturelle sans soins.
   Laisser les ennemis tuer le héros. Vérifier DEFAITE, PV zéro, bilan et Rejouer visible.
2. Attendre quelques secondes : ennemis, temps, énergie, cooldowns, vagues et compteurs
   restent figés. Une compétence ne peut plus être lancée. Pause/Reprendre ne relance pas la partie.
3. Rejouer : héros neuf, compteurs nuls, vague 1/3, aucune ancienne cible ; les gambits
   désactivés restent désactivés. Première arrivée après une seconde hors pause.
4. Répéter dix Rejouer, en alternant après défaite et pendant une action/en attente d’une
   commande manuelle. Pour accélérer, un reset en plein combat est valable et doit nettoyer
   les mêmes acteurs. Vérifier absence de doublons et d’impacts sur le nouveau héros.
5. Sur certains essais, passer en pause avant Rejouer : le nouveau combat doit rester en
   pause, sans arrivée jusqu’à Reprendre. Le bilan final doit rester DEFAITE pendant la pause.
6. Modifier un seuil, réordonner et activer/désactiver une règle ; fermer le formulaire,
   puis Rejouer : conserver ces changements. Réactiver les gambits pour la suite.
7. Mode Charge, plusieurs ennemis présents : Rejouer élimine tout le groupe ancien.
   Scénario conservé. Le mode Soin garde son profil blessé prévu après reset.
8. Vérifier le ciblage fix1, les swipes et appuis courts, et l’absence de pas parasite
   pendant l’attaque. Aucun nouveau changement visuel des animations n’est attendu.

Les tests de victoire et compteurs sont aussi couverts par wave_sequence_tests.
La recette ne remplace pas une mesure de mémoire ou de performance : STEP-028 reste dédiée à cela.

## APK

Exporter Android Debug vers ~/gambit-arena-builds/step-026-debug.apk, puis :

```bash
~/Android/Sdk/platform-tools/adb devices -l &&
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-026-debug.apk &&
sha256sum ~/gambit-arena-builds/step-026-debug.apk
```

Transmettre F6, tests manuels (dont dix Rejouer), fluidité et SHA-256 du nouvel APK.
Ne pas commiter avant validation. Message prévu après consignation du retour :
feat: [STEP-026] figer la defaite et fiabiliser les redemarrages
Puis statut propre et sauvegarde complète à vérifier avant GO STEP-027.

## Validation utilisateur — 25 octobre 2026

STEP-026 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour global, sans résultats séparés par banc ou mesure chiffrée ; aucune réserve signalée.
APK : step-026-debug.apk ; version 0.1.0-step026, code 26.
SHA-256 : 1c6e699d3acf44a6f3e5ce6e85d333ac9bb60c14e946a548992bd5eb099a47a2.
Statut : Validée, commit en attente.

Archive : gambit-arena-complet-step-026-validation.tar.gz.
Seule la documentation change depuis v1 ; code, scènes, tests et configuration identiques.
Aucun lancement Godot chez l’assistant. Les instructions de recette précédentes décrivent
la validation maintenant reçue ; aucun nouveau test requis pour cette mise à jour documentaire.
Prochaine action : commit, statut propre et sauvegarde complète à transmettre.
STEP-027 attend clôture et nouveau GO.
