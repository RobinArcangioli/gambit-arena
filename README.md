# Gambit Arena — STEP-015

Prototype Godot Android portrait avec mannequins 3D temporaires.
Base clôturée : STEP-014, commits 5c39ac2 et 4f4244c.
STEP-015 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 : laboratoire de pause commune et interruption par la mort.
Trois scénarios : Pause libre, Mort cible, Mort héros. Les interruptions automatiques
surviennent à 0,3 s, avant l'effet. Compétences et valeurs de STEP-014 conservées.

Scénario/P, Attaque/A, Soin/H, Spéciale/S, Mort héros/D, Mort cible/E,
Rejouer/R, Pause/Espace, Repères/G. Six cases toujours inactives.

F6 : lifecycle_tests, skills_tests, attack_action_tests, skill_executor_tests et
combat_simulation_tests dans scenes/tests/. Attendu : OK, zéro échec par banc.
F8 arrête. Godot non exécuté chez l'assistant ; anciens laboratoires conservés.

- [Recette STEP-015](docs/steps/STEP-015.md)
- [Pause et cycle de vie](docs/lifecycle.md), [compétences](docs/skills.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step015, code 14. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
