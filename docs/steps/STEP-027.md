# STEP-027 — Pause, arrière-plan, verrouillage et retour Android

Statut : Validée, commit en attente. Base clôturée 344a584, GO reçu après clôture et confirmé.
Livraison préparée le 26 octobre 2026 : gambit-arena-complet-step-027-v1.tar.gz.
Android 0.1.0-step027, code 27. APK STEP-027 validé par le retour utilisateur ci-dessous.

## Périmètre

ApplicationGuard et ApplicationLab autour de la simulation validée : blocage des entrées
pendant perte de focus/suspension, reprise explicite, rejet des anciens gestes et du premier
delta après reprise. Formulaire, zones sûres, replay et résultat terminal conservés.
Aucune modification du combat, du ciblage fix1, des animations ou du routeur tactile.
Pas de sauvegarde/reprise après destruction du processus ; pas d’optimisation non mesurée.
Voir ../application-lifecycle.md pour les choix, références moteur et limites.

## Installation

Fermer Godot et vérifier la base propre :

```bash
cd ~/gambit-arena &&
git status --short --branch &&
git log -1 --format="%h %s"
```

Attendu : main propre, 344a584. Puis :

```bash
tar -xzf ~/Downloads/gambit-arena-complet-step-027-v1.tar.gz -C ~ &&
cd ~/gambit-arena &&
git diff --check
```

Archive complète sans .git/.godot ; bundle séparé de la base 344a584, sans STEP-027
non commitée. Aucun git restore ni commit avant validation.

## F6

Lancer les scènes de scenes/tests, F8 entre chaque banc :

1. application_lifecycle_tests.tscn
2. run_lifecycle_tests.tscn
3. target_lock_tests.tscn
4. wave_sequence_tests.tscn
5. wave_schedule_tests.tscn
6. lifecycle_tests.tscn
7. manual_commands_tests.tscn
8. touch_scroll_tests.tscn
9. portrait_hud_tests.tscn
10. attack_stationary_tests.tscn
11. gambit_controller_tests.tscn
12. gambit_diagnostics_tests.tscn
13. gambit_fields_tests.tscn
14. skill_slots_tests.tscn

Attendu : OK, zéro échec et aucun nouvel avertissement. Les autres bancs restent disponibles.
Godot absent chez l’assistant : aucune compilation/exécution F6 ici. Le nouveau banc utilise
des notifications synthétiques et ne remplace pas la recette sur le téléphone.

## PC

F5 : pendant une action ou avec une commande manuelle en attente, changer de fenêtre puis
revenir. Le jeu reste en pause, les PV/ressources/délais/compteurs n’ont pas avancé. Cliquer
Reprendre : aucune rafale, coût supplémentaire ou double impact. Ouvrir un formulaire,
changer une valeur sans appliquer, perdre le focus puis revenir : brouillon intact et pause
maintenue. Appuis courts, clics et molette restent utilisables. Rejouer garde les gambits.

## Android — recette obligatoire

Effectuer au moins dix allers-retours au total, en répartissant les cas ci-dessous.
Attendre 5 à 10 secondes hors application ; faire aussi un essai plus long d’environ 30 secondes.

1. En combat, bouton Accueil, puis retour : PAUSE / retour ; pas de changement de PV,
   énergie, cooldowns, positions, nombre d’ennemis ou compteur de vague pendant l’absence.
2. Écran des applications récentes, puis retour : même résultat, jamais de reprise automatique.
3. Verrouiller l’écran pendant une attaque, déverrouiller et revenir : action toujours en
   pause, coût déjà payé inchangé. Reprendre termine cette action sans double effet.
4. Répéter avec un soin ou une spéciale en attente : échéance de trois secondes de jeu
   conservée, pas trois secondes de temps mural. Pas d’expiration due à l’absence seule.
5. Garder un doigt appuyé sur une compétence ou commencer un swipe, puis perdre le focus/
   verrouiller. Au retour, relâcher : aucune commande parasite. Un geste neuf doit fonctionner.
6. Ouvrir l’éditeur de gambit, modifier le brouillon, verrouiller puis revenir : formulaire
   et brouillon conservés. Appliquer/Annuler garde la pause ; Reprendre ensuite seulement.
7. Observer les zones sûres après retour/barres système : boutons et dernières lignes
   restent accessibles, swipes Gambits/Compétences opérationnels.
8. Après défaite, quitter et revenir : bilan toujours terminal, pas de résurrection.
   Rejouer au retour crée une partie neuve en pause ; Reprendre relance ensuite normalement.

Si Reprendre reste désactivé après le retour complet, signaler précisément le chemin
(Accueil, applications récentes, verrouillage) : ne pas considérer l’étape validée.
L’arrêt forcé du processus recommence une session, ce n’est pas une reprise persistante.
Le ciblage vivant à portée et l’immobilité à l’attaque doivent rester inchangés.

## APK

Exporter Android Debug vers ~/gambit-arena-builds/step-027-debug.apk puis :

```bash
~/Android/Sdk/platform-tools/adb devices -l &&
~/Android/Sdk/platform-tools/adb -d install -r ~/gambit-arena-builds/step-027-debug.apk &&
sha256sum ~/gambit-arena-builds/step-027-debug.apk
```

Transmettre F6, tests manuels PC/Android, fluidité et nouveau SHA-256.
Après validation documentée, message prévu :
feat: [STEP-027] securiser la pause et le retour Android
Puis statut propre, sauvegarde complète et vérification avant GO STEP-028.

## Validation utilisateur — 26 octobre 2026

STEP-027 explicitement validée : F6 OK, tests manuels OK, fluidité OK.
Retour global, sans résultats séparés par banc ou mesure chiffrée ; aucune réserve signalée.
APK : step-027-debug.apk ; version 0.1.0-step027, code 27.
SHA-256 : 07467efcfb7e663e363e6f6fc61644fd2bf2889e7ee3a3001d42589e0c6cf611.
Statut : Validée, commit en attente.

Archive : gambit-arena-complet-step-027-validation.tar.gz.
Seule la documentation change depuis v1 ; code, scènes, tests et configuration identiques.
Aucun lancement Godot chez l’assistant. Les instructions de recette précédentes décrivent
la validation maintenant reçue ; aucun nouveau test requis pour cette mise à jour documentaire.
Prochaine action : commit, statut propre et sauvegarde complète à transmettre.
STEP-028 attend clôture et nouveau GO.
