# Gambit Arena — STEP-012

Prototype Godot Android portrait, fond 2D et mannequins 3D temporaires.
STEP-011 clôturée au commit 3633927 ; STEP-012 validée, commit en attente.
F6, tests manuels et fluidité confirmés OK par l’utilisateur.

F5 ouvre le combat autonome : ciblage, approche, séparation, attaques des deux
camps, morts et changement de cible. Trois scénarios : Victoire, Défaite, Groupe 20.
Les profils renforcés servent aux tests ; le scénario Défaite utilise le héros normal.

Scénario/P, Rejouer/R, Pause/Espace, Repères/G. Six cases toujours inactives.
Pas encore de compétences, gambits, vagues ou animations finales de combat.

Ouvrir scenes/tests/combat_simulation_tests.tscn puis F6 ; attendre le rapport
OK, zéro échec. F8 arrête. Godot n'a pas été exécuté chez l'assistant.
Tous les anciens laboratoires restent disponibles séparément avec F6.

- [Recette STEP-012](docs/steps/STEP-012.md)
- [Combat autonome](docs/combat.md), [actions](docs/actions.md)
- [Architecture](ARCHITECTURE.md), [état](PROJECT_STATUS.md), [roadmap](ROADMAP.md)
- [Android](docs/android.md), [sauvegarde](docs/backup.md)

Version Android 0.1.0-step012, code 11. Export Debug hors dépôt.
Validation reçue : commit puis sauvegarde complète à effectuer.
