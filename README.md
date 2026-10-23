# Gambit Arena — STEP-017

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-016 clôturée au commit 1da833e ; STEP-017 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 : combat piloté par trois gambits pour le héros : soin si PV < 50 %,
spéciale sur ennemi, puis attaque normale. Approche automatique et effets réels,
via l'exécuteur partagé. Les ennemis poursuivent et attaquent comme auparavant.
L'ancien choix automatique de cible/attaque du héros est retiré du coordinateur.

Scénario/P : Combat, Soin, Groupe 20, Sans règle. Rejouer/R conserve la configuration
des règles ; Pause/Espace ; Repères/G. Six cases À venir toujours inactives.
Changer de scénario charge un préréglage de diagnostic, sans éditeur de règles.

F6 dans scenes/tests/ : gambit_controller_tests, gambit_tests, lifecycle_tests,
skills_tests et combat_simulation_tests. Attendu : OK, zéro échec par banc.
F8 entre les bancs. Godot non exécuté chez l'assistant.

- [Recette STEP-017](docs/steps/STEP-017.md)
- [Pilotage du héros](docs/gambit-controller.md), [évaluateur](docs/gambits.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step017, code 16. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
