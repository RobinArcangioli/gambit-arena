# Gambit Arena — STEP-022

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-021 clôturée au commit 9491d40 ; STEP-022 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 : onglets Compétences et Gambits. Six emplacements en deux rangées de trois :
Attaque, Soin, Spéciale, puis trois réservés désactivés. Les compétences montrent coût,
délai restant et disponibilité immédiate : prêt, pause, occupé, délai, énergie,
PV pleins, sans cible, hors portée, mort ou fin du combat.
Appuyer sur une compétence consulte son explication ; aucun lancement manuel à cette
étape. L'exécution manuelle et son attente prioritaire appartiennent à STEP-023.

L'onglet Gambits conserve activation, ordre et formulaire de STEP-020/021. Les deux
listes défilent si nécessaire, sans réduire l'arène. Le formulaire bloque les onglets.
Combat, animations, immobilité à portée et zones sûres restent inchangés.

F6 : skill_slots_tests, portrait_hud_tests, gambit_fields_tests,
attack_stationary_tests, gambit_editor_tests, gambit_diagnostics_tests,
gambit_controller_tests, gambit_tests, lifecycle_tests et combat_simulation_tests.
F8 entre les bancs. Attendu : OK, zéro échec et aucun nouvel avertissement.
Godot non exécuté chez l'assistant ; validation utilisateur globale reçue.

- [Recette STEP-022](docs/steps/STEP-022.md)
- [Emplacements](docs/skill-slots.md), [HUD](docs/portrait-hud.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step022, code 21. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
