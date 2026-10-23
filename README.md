# Gambit Arena — STEP-014

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-013 clôturée au commit 1ffd24a ; STEP-014 en attente de validation.

F5 : attaque, soin personnel, frappe spéciale et récupération passive de ressource.
Trois scénarios : compétences, ressource vide, mort avant effet. Héros blessé60/100,
ennemi passif600 PV ; valeurs de test. Tous les effets passent par l'exécuteur commun.

Scénario/P, Attaque/A, Soin/H, Spéciale/S, Blesser/D, Éloigner/E, Rejouer/R,
Pause/Espace, Repères/G. Six cases toujours inactives ; interface provisoire.

F6 : skills_tests, attack_action_tests, skill_executor_tests et
combat_simulation_tests dans scenes/tests/. Attendu : OK, zéro échec pour chacun.
F8 arrête. Godot non exécuté chez l'assistant ; anciens laboratoires conservés.

- [Recette STEP-014](docs/steps/STEP-014.md)
- [Compétences](docs/skills.md), [exécuteur](docs/skill-executor.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step014, code 13. Export Debug hors dépôt.
Commit après validation explicite, puis sauvegarde complète.
