# Gambit Arena — STEP-013

Prototype Godot Android portrait avec mannequins 3D temporaires.
STEP-012 clôturée au commit 9725f5d ; STEP-013 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 : laboratoire de l'exécuteur partagé. Manuel, Auto et Deux acteurs utilisent
le même point d'engagement. Ressource 60 par acteur ; essai payant 20, cooldown 3 s.
Débit et cooldown uniquement à l'acceptation ; refus sans effet, impact unique.
Le combat autonome utilise aussi cet exécuteur pour son attaque gratuite.

Scénario/P, Essai20/A, Base0/B, Acteur/T, Éloigner/E, Auto/U, Rejouer/R,
Pause/Espace, Repères/G. Six cases inactives ; soin et spéciale arrivent STEP-014.

F6 : scenes/tests/skill_executor_tests.tscn puis combat_simulation_tests.tscn.
Attendu pour chacun : OK, zéro échec. F8 arrête. Godot non exécuté ici.
Anciens laboratoires conservés ; BattleLab reste accessible avec F6.

- [Recette STEP-013](docs/steps/STEP-013.md)
- [Exécuteur](docs/skill-executor.md), [combat](docs/combat.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step013, code 12. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
