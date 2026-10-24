# Gambit Arena — STEP-018

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-017 clôturée au commit 5b2bc4d ; STEP-018 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 : diagnostic du combat et huit cas fixes de règles. Vue des raisons de la dernière
lecture ou des quatre derniers événements. Journal limité à 64 entrées, désactivable.
Les cas fixes sont évalués sans exécution ; leur arène est masquée volontairement.

Scénario/P, Rejouer/R, Vue/V, Trace/T, Pause/Espace, Repères/G.
Changer de vue reste possible en pause. Rejouer conserve pause et activation de trace.
Les six cases À venir restent inactives. Aucun éditeur de règles ajouté.

F6 dans scenes/tests/ : gambit_diagnostics_tests, gambit_controller_tests,
gambit_tests, lifecycle_tests et combat_simulation_tests. Attendu : OK, zéro échec
par banc ; F8 entre les bancs. Godot non exécuté chez l'assistant.

- [Recette STEP-018](docs/steps/STEP-018.md)
- [Diagnostics](docs/gambit-diagnostics.md), [pilotage](docs/gambit-controller.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step018, code 17. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.

Correctif v2 — FIX-STEP-018-001 : le banc compte les acteurs du laboratoire
sans inclure caméra/éclairage/environnement ; avertissement report supprimé.
Correctif v2 inclus dans la validation utilisateur de STEP-018.
